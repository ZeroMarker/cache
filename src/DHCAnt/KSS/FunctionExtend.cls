/// CTOR: QP
/// DATE: 2016-09-04
/// VERN: V4.1.3
/// DESC: 抗菌药物配置功能扩展类，存放所有在主配置中扩展的功能的后台方法
Class DHCAnt.KSS.FunctionExtend Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 限制越级医生同一个病人同一种药品只能越级一次
/// IN  : 
/// OUT : 1表示已越级过，0表示未越级过
/// EXEC: 
ClassMethod ChksameKssIsEnc(Adm, Arcim)
{
    s flag=0
    s AARowid=""
    f  s AARowid=$o(^DHCDAAi("AdmDR",Adm,AARowid),-1) q:AARowid=""  d
    .s OEORIDR=$p(^DHCDAA("ANT",AARowid,1),"^",6)
    .q:OEORIDR=""
    .q:##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(OEORIDR)=1
    .s ArcimDr=$p(^DHCDAA("ANT",AARowid),"^",2)
    .q:ArcimDr'=Arcim
    .s AAisEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)
    .i AAisEmergency=1 d
    ..s flag=1
    q flag
}

/// CTOR:   LSJ
/// DATE:   2017-03-13
/// Table:  
/// DESC:   控制越级使用后未审核的是否还能越级
/// INPUT:  admId - PA_Adm表id,arcimId - ARC_ItmMast表id
/// OUTPUT: 0 - 可以，1 - 不可以
/// DEBUG:  w ##class(DHCAnt.KSS.FunctionExtend).ChkEmergencyType(2,"34||5")
ClassMethod ChkEmergencyType(admId As %String, arcimId As %String = "", type As %String = "", InHosp = "")
{
	n (admId,arcimId,type,InHosp)
	s ret=0
	q:$g(admId)="" ret
	s eoeValue=type
	i eoeValue="" s eoeValue=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("EOE",InHosp)	//1 - 控制到病人，2 - 控制的医嘱项id
	q:(eoeValue="")||(eoeValue=0) ret
	
	s aaRowid=""
	f  s aaRowid=$o(^DHCDAAi("AdmDR",admId,aaRowid),-1) q:aaRowid=""!ret=1  d
	.s oeori=$p(^DHCDAA("ANT",aaRowid,1),"^",6)
	.q:oeori=""
	.s isEmergency=$p(^DHCDAA("ANT",aaRowid,1),"^",23)
	.q:isEmergency'=1
	.i oeori'="" s oeoriStatusDr=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",13)	//OEC_OrderStatus
	.i oeoriStatusDr'="" s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	.q:(oeoriStatus="U")||(oeoriStatus="C") ;医嘱状态为撤销
	.s isAud=$p(^DHCDAA("ANT",aaRowid),"^",12)	//审核状态
	.i eoeValue=1 d
	..d chkfroPat
	.i eoeValue=2 d
	..d chkforArcim
	
	q ret
	
chkfroPat
	i (isAud'="U")&&(isAud'="R") d
	.s ret=1
	q

chkforArcim
	s drugId=$p(^DHCDAA("ANT",aaRowid),"^",2)
	q:drugId'=arcimId
	i (isAud'="U")&&(isAud'="R") d
	.s ret=1
	q
}

/// CTOR:   LSJ
/// DATE:   2017-03-13
/// Table:  
/// DESC:   根据医嘱项id或医嘱子类来判断登记表送检框是否默认为"Yes"
/// INPUT:  arcimId - ARC_ItmMast表id
/// OUTPUT: 0 - 不是，1 - 是
/// DEBUG:  w ##class(DHCAnt.KSS.FunctionExtend).ChkSubmitType("883||1","LABOECATE")
ClassMethod ChkSubmitType(arcimId As %String, mcgCode As %String = "", InHosp = "")
{
	n (arcimId,mcgCode,InHosp)
	s ret=0
	q:(arcimId="")||(InHosp="") ret
	s labValue=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("LABWAY",InHosp)
	i labValue="LABARCIM" d
	.s id=$o(^CF.ANT.ItmMastI("HospArcim",InHosp,arcimId,0))
	.q:id=""
	.s isLab=$p(^CF.ANT.ItmMastD(id),"^",2)
	.q:isLab'="Y"
	.s ret=1
	
	i labValue="LABOECATE" d
	.s flag=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10)
	.s arr=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("LABOECATE",InHosp)
	.i (##class(DHCAnt.KSS.Common.Method).InArray(arr,flag)=1) s ret=1
	
	q ret
}

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 限制越级医生同一个病人同一种药品只能越级一次
/// IN  : 
/// OUT : >0表示不需要弹出，-1需要弹出
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).ChkSameAntForOnce(1957,"904||1")
ClassMethod ChkSameAntForOnce(admId As %String, arcimId As %String, mcgCode As %String = "", InHosp = "")
{
	n (admId,arcimId,mcgCode,InHosp)
	s ^TEMP("QP",2)=admId_": "_arcimId
	q:$g(admId)="" "-1"
	q:InHosp="" "-1"
	s emerNoAuditFlag=0	//越级未审核标志
	s code=mcgCode
	i code="" s code=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("SAMEKSSONCE",InHosp)
	q:code="" "-1"
	
	s mcgAPPTime=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("COPYTIME",InHosp)
	q:(mcgAPPTime=0)||(mcgAPPTime="") "-1"
	
	s tflag=0,flag="-1",ret=""
	i code="COMMONNAME" d
	.s phcdf=$p($g(^ARCIM(+arcimId,1,1)),"^",12)
	.s gen=$p(^PHCD(+phcdf,4),"^",1) ;通用名dr
	.s daupRowid=""
	.f  s daupRowid=$o(^DAUP("NEWADM",admId,daupRowid),-1)  q:daupRowid=""!tflag=1  d
	..s ordRowid=$p(^DAUP("DAUP",daupRowid),"^",3)
	..q:ordRowid=""
	..s oeoriStatus=""
	..s oeoriStatusDr=$p(^OEORD(+ordRowid,"I",$p(ordRowid,"||",2),1),"^",13)
	..i oeoriStatusDr'="" s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	..q:(oeoriStatus="U")||(oeoriStatus="C")
	..s aarowid="",isEmergency="",curStatus=""
	..i $d(^DHCDAAi(0,"OEORI",ordRowid)) s aarowid=$o(^DHCDAAi(0,"OEORI",ordRowid,""))
	..i aarowid'="" d
	...s isEmergency=$p(^DHCDAA("ANT",aarowid,1),"^",23)
	...s curStatus=$p(^DHCDAA("ANT",aarowid),"^",12)
	..q:(aarowid'="")&&(curStatus'="U")
	..;q:(isEmergency=1)&&(curStatus'="U")	//控制越级
	..s arcimRowid=$p(^DAUP("DAUP",daupRowid),"^",21)
	..s daupPhcdf=$p($g(^ARCIM(+arcimRowid,1,1)),"^",12)
	..s daupGen=$p(^PHCD(+daupPhcdf,4),"^",1)
	..q:daupGen'=gen
	..i (isEmergency=1)&&(curStatus'="R")&&(curStatus'="U") s emerNoAuditFlag=1
	..s daupDate=$p(^DAUP("DAUP",daupRowid),"^",4)
	..s daupTime=$p(^DAUP("DAUP",daupRowid),"^",14)
	..s daupDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(daupDate_","_daupTime)
	..s curDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
	..i (curDT-daupDT)>(mcgAPPTime*3600) s tflag=1
	..q:(curDT-daupDT)>(mcgAPPTime*3600)
	..s ret=##class(DHCAnt.KSS.MainInterface).CopyAntUsePurpose(ordRowid,arcimId)
	..i $p(ret,"^",1)=0 s flag=$p(ret,"^",2),tflag=1
	
	e  i code="SAMEKSS" d
	.s poisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcimId)
	.s poisonCode=$p(^PHCPO(poisonRowid),"^",1)
	.s daupRowid=""
	.f  s daupRowid=$o(^DAUP("NEWADM",admId,daupRowid),-1)  q:(daupRowid="")!(tflag=1)  d
	..s ordRowid=$p(^DAUP("DAUP",daupRowid),"^",3)
	..q:ordRowid=""
	..s oeoriStatus=""
	..s oeoriStatusDr=$p(^OEORD(+ordRowid,"I",$p(ordRowid,"||",2),1),"^",13)
	..i oeoriStatusDr'="" s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	..q:(oeoriStatus="U")||(oeoriStatus="C")
	..s aarowid="",isEmergency="",curStatus=""
	..i $d(^DHCDAAi(0,"OEORI",ordRowid)) s aarowid=$o(^DHCDAAi(0,"OEORI",ordRowid,""))
	..i aarowid'="" d
	...s isEmergency=$p(^DHCDAA("ANT",aarowid,1),"^",23)
	...s curStatus=$p(^DHCDAA("ANT",aarowid),"^",12)
	..q:(aarowid'="")&&(curStatus'="U")
	..s arcimRowid=$p(^DAUP("DAUP",daupRowid),"^",21)
	..s daupPoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcimRowid)
	..s daupPoisonCode=$p(^PHCPO(daupPoisonRowid),"^",1)
	..q:daupPoisonCode'=poisonCode
	..i (isEmergency=1)&&(curStatus'="R")&&(curStatus'="U") s emerNoAuditFlag=1
	..s daupDate=$p(^DAUP("DAUP",daupRowid),"^",4)
	..s daupTime=$p(^DAUP("DAUP",daupRowid),"^",14)
	..s daupDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(daupDate_","_daupTime)
	..s curDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
	..i (curDT-daupDT)>(mcgAPPTime*3600) s tflag=1
	..q:(curDT-daupDT)>(mcgAPPTime*3600)
	..s ret=##class(DHCAnt.KSS.MainInterface).CopyAntUsePurpose(ordRowid,arcimId)
	..i $p(ret,"^",1)=0 s flag=$p(ret,"^",2),tflag=1
	
	e  i code="WHONET" d
	.s phcdf=$p($g(^ARCIM(+arcimId,1,1)),"^",12)
	.s whoNet=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),"DHC"),"^",10),daupRowid=""
	.f  s daupRowid=$o(^DAUP("NEWADM",admId,daupRowid),-1)  q:daupRowid=""!tflag=1  d
	..s ordRowid=$p(^DAUP("DAUP",daupRowid),"^",3)
	..q:ordRowid=""
	..s oeoriStatus=""
	..s oeoriStatusDr=$p(^OEORD(+ordRowid,"I",$p(ordRowid,"||",2),1),"^",13)
	..i oeoriStatusDr'="" s oeoriStatus=$p(^OEC("OSTAT",oeoriStatusDr),"^",1)
	..q:(oeoriStatus="U")||(oeoriStatus="C")
	..s aarowid="",isEmergency="",curStatus=""
	..i $d(^DHCDAAi(0,"OEORI",ordRowid)) s aarowid=$o(^DHCDAAi(0,"OEORI",ordRowid,""))
	..i aarowid'="" d
	...s isEmergency=$p(^DHCDAA("ANT",aarowid,1),"^",23)
	...s curStatus=$p(^DHCDAA("ANT",aarowid),"^",12)
	..q:(aarowid'="")&&(curStatus'="U")
	..s arcimRowid=$p(^DAUP("DAUP",daupRowid),"^",21)
	..s daupPhcdf=$p($g(^ARCIM(+arcimRowid,1,1)),"^",12)
	..s daupWhoNet=$p(^PHCD(+daupPhcdf,"DF",$p(daupPhcdf,"||",2),"DHC"),"^",10)
	..q:daupWhoNet'=whoNet
	..i (isEmergency=1)&&(curStatus'="R")&&(curStatus'="U") s emerNoAuditFlag=1
	..s daupDate=$p(^DAUP("DAUP",daupRowid),"^",4)
	..s daupTime=$p(^DAUP("DAUP",daupRowid),"^",14)
	..s daupDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(daupDate_","_daupTime)
	..s curDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
	..i (curDT-daupDT)>(mcgAPPTime*3600) s tflag=1
	..q:(curDT-daupDT)>(mcgAPPTime*3600)
	..s ret=##class(DHCAnt.KSS.MainInterface).CopyAntUsePurpose(ordRowid,arcimId)
	..i $p(ret,"^",1)=0 s flag=$p(ret,"^",2),tflag=1
	
	q:emerNoAuditFlag=1 "-2"
	
	q flag
}

/// creator:dyp
/// desc:返回抗菌药物停医嘱标志
ClassMethod ExpectStopOeord(oeord As %String) As %String
{
	n (oeord)
	q:oeord="" 0
	s stopflag=0
	
	f  s rowid=$o(^DAUP("OEORI",oeord,rowid))   q:(rowid="")||(stopflag=1)  d
	.s dtaupdr=$p(^DAUP("DAUP",rowid),"^",20)
	
	.s bigAimDr=$p(^DHCAntBasePurposeDataConfigD(dtaupdr),"^",6)
	.q:bigAimDr=""
	.s aurcode=$p(^DHCAntBasePurposeDataConfigD(bigAimDr),"^",4)
	.Q:aurcode="ZL"
	.s usedays=$p(^DAUP("DAUP",rowid),"^",24)  ;预计用药天数
	.q:usedays=""
	.s oeordstdate=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),1),"^",9)	//开医嘱时间
	.s nowdate=$p(+$h+1,",")
	.if (oeordstdate+usedays)>=nowdate  d
	..s stopflag=1
	q stopflag
}

/// creator:dyp
/// desc:根据医嘱id判断出来是否停医嘱的标志
/// note:不管是主医嘱还是子医嘱，只要有一个需要停止，都应该停止
ClassMethod AutoStopOeord(oeord As %String)
{
	n (oeord)
	q:oeord="" 0
	s rtn=..ExpectStopOeord(oeord)
	if rtn=1 Quit 1
	
	Set MainOrdId=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),11),"^",39)    // 把传进来的当做子医嘱id，去取关联的主医嘱id
	if MainOrdId=""{   //传进来的是没有关联的医嘱或者就是主医嘱。
		set Maioeord=oeord
			
	}else{ // 传进来的是子医嘱，取出主医嘱，判断主医嘱是否自动停医嘱
		set Maioeord=MainOrdId	
		s rtn=..ExpectStopOeord(Maioeord)
		if rtn=1 Quit 1
	}
	
	s rowid=0
	S OEORD=+oeord
	S OEOrdsub=$p(oeord,"||",2)
	S Oeori=0
	f  s Oeori=$o(^OEORDi(0,"OEORI",OEORD,Maioeord,Oeori))  q:(Oeori="")||(rtn=1)  d 
	.s oeori=OEORD_"||"_Oeori
	.s rtn=..ExpectStopOeord(oeori)
	
	
	Quit rtn
}

/// creator:DongYP
/// description: 获取当前已经用药天数
/// input:  就诊id、使用目的id
/// output: 已经用药天数
/// w ##class(DHCAnt.KSS.FunctionExtend).GetUsedDaysNew(1957,"883||1")
ClassMethod GetUsedDaysNew(admId As %String, arcim As %String) As %String
{
	q:admId="" ""
	q:arcim="" ""
	s oeord=0
	s usedaycount=0
	s firstflag=0,candays=0
	s maxusedays=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("YFDRUGTIME")
	s firstkss=..checkIsFirstKSS(admId,arcim)
	i firstkss=0  q maxusedays
	f  s oeord=$o(^DAUP("ADM",admId,oeord))  Q:oeord=""   d
	.s orderStatus=$p(^OEORD(+oeord,"I",$p(oeord,"||",2),1),"^",13)
	.s statusCode=$p(^OEC("OSTAT",orderStatus),"^",1)
	.q:(statusCode="C")||(statusCode="U")	;撤销和作废
	.s arcimdr=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),1),"^",2)
	.Q:arcimdr'=arcim
	.s rtn=..checkIsFirstOeord(admId,oeord)
	.s firstflag=+rtn
	.q:firstflag'=1
	.s usedays=$p(rtn,"^",2)
	.q:usedays=""
	.Set OrderStatus=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),1),"^",13)
	.Set StatusCode=$p(^OEC("OSTAT",OrderStatus),"^",1)
	.//Quit:StatusCode'="V"
	.set prioritydr=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),1),"^",8)
	.set prioritycode=$p(^OECPR(prioritydr),"^",1)
	.if (prioritycode="NORM")  d  ;临时医嘱
	..if StatusCode="V"    d 
	...set usedaycount=usedaycount+1
	.if (prioritycode="S")    d   ;长期医嘱
	..if StatusCode="V"  d
	...set usedaycount=usedaycount+usedays
	..if (StatusCode'="V")  d
	...Set StartDate=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),1),"^",9)
	...Set StopDate=$p(^OEORD(+oeord,"I",$P(oeord,"||",2),3),"^",34)
	...s oeore=0  ;以下是取第一条执行记录的日期和最后一条执行记录的日期。
	...s firstdate=""  ;
	...s lastdate=""
	... f  set oeore=$o(^OEORD(+oeord,"I",$P(oeord,"||",2),"X",oeore)) q:oeore=""   d
	....s oeorestaus=$P(^OEORD(+oeord,"I",$P(oeord,"||",2),"X",oeore),"^",16)    ;OEC_Order_AdminStatus
	....s oeccode=$p(^OEC("STAT",oeorestaus),"^",1)
	....Q:(oeccode="D")||(oeccode="C")
	....S Exstdate=$P(^OEORD(+oeord,"I",$P(oeord,"||",2),"X",oeore),"^",1)
	....if firstdate=""   set firstdate=Exstdate
	....set lastdate=Exstdate
	...s days=lastdate-firstdate
	...s usedaycount=usedaycount+days
	.s candays=maxusedays-usedaycount
	.i candays<=0  s candays=0
	q candays
}

ClassMethod checkIsFirstOeord(adm, oeord) As %String
{
	q:(adm="")||(oeord="") ""
	s firstflag=0
	s rowid=0 ,usedays=""
	f  s rowid=$o(^DAUP("ADM",adm,oeord,rowid))  q:(rowid="")||(firstflag=1)  d
	.s daupdr=$p(^DAUP("DAUP",rowid),"^",20)
	.s bigAimDr=$p(^DHCAntBasePurposeDataConfigD(daupdr),"^",6)
	.q:bigAimDr=""
	.s code=$p(^DHCAntBasePurposeDataConfigD(bigAimDr),"^",4)
	.q:code="ZL"
	.s rowidcopy=$p(^DAUP("DAUP",rowid),"^",26)
	.q:rowidcopy'=""
	.s usedays=$p($g(^DAUP("DAUP",rowid)),"^",24)
	.i usedays'=""  s firstflag=1
	Q firstflag_"^"_usedays
}

/// creator:dyp
/// desc:判断是否是第一次开抗菌药物
ClassMethod checkIsFirstKSS(adm, arcim) As %String
{
   
	q:(adm="")||(arcim="") ""
	s oeord=""
	s flag=0
	s oeord=$o(^OEORD(0,"Adm",adm,oeord)) q:oeord=""
	s oeordsub=0
	f  s oeordsub=$o(^OEORD(oeord,"I",oeordsub))  Q:(oeordsub="")||(flag=1)  d
	.s arcimdr=$p(^OEORD(oeord,"I",oeordsub,1),"^",2)
	.Q:arcimdr'=arcim
	.s flag=1
	q flag
}

/// CTOR: QP
/// DATE: 2016-09-04
/// DESC: 获取上次抗生素医嘱信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).GetLastDaupInfo(1957,"904||1")
ClassMethod GetLastDaupInfo(admId As %String, arcimId As %String, mcgCode As %String = "", InHosp = "")
{
	n (admId,arcimId,mcgCode,InHosp)
	q:$g(admId)="" "-1"
	
	i InHosp="" {
		s InHosp=%session.Get("LOGON.HOSPID")
		s mcgVal=1
		s mcgAPPTime=48
	} else {
		s mcgVal=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("AUTOAIM",InHosp)
		s mcgAPPTime=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("COPYTIME",InHosp)
	}

	q:(mcgAPPTime=0)||(mcgAPPTime="") "-1"
	q:mcgVal="" "-1"
	
	s data="",daupRowid=""
	i mcgVal="1" d
	.s daupRowid=$o(^DAUP("NEWADM",admId,daupRowid),-1)
	.q:daupRowid=""
	.s arcimRowid=$p(^DAUP("DAUP",daupRowid),"^",21)
	.s daupDate=$p(^DAUP("DAUP",daupRowid),"^",4)
	.s daupTime=$p(^DAUP("DAUP",daupRowid),"^",14)
	.s daupDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(daupDate_","_daupTime)
	.s curDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
	.q:(curDT-daupDT)>(mcgAPPTime*3600)
	.s dtupId=$p(^DAUP("DAUP",daupRowid),"^",20) //使用目的id
	.s dtaupCatCode=""
	.s aimDesc=$p(^DHCAntBasePurposeDataConfigD(dtupId),"^",3)
	.s bigAimDr=$p(^DHCAntBasePurposeDataConfigD(dtupId),"^",6)
	.s:bigAimDr'="" dtaupCatCode=$p(^DHCAntBasePurposeDataConfigD(bigAimDr),"^",4)
	.i aimDesc'["预防-手术" s dtaupCatCode="ZL"
	.s umpRtn=##class(DHCAnt.KSS.Config.UsePurposeManage).UPMControl(dtupId,arcimRowid,InHosp)
	.s upmFlag=$p(umpRtn,"^",1)
	.q:upmFlag=2	//使用目的管控
	.s indId=$p(^DAUP("DAUP",daupRowid),"^",10) //指征id
	.s bodyId=$p(^DAUP("DAUP",daupRowid),"^",6) //感染部位id
	.s yfTime=$p(^DAUP("DAUP",daupRowid),"^",22) //预防用药时机id
	.s sub=$p(^DAUP("DAUP",daupRowid),"^",15) //送检
	.s kss3IndId=$p(^DAUP("DAUP",daupRowid),"^",23) //特抗药指征idzbj
	.s zbjId=$p(^DAUP("DAUP",daupRowid),"^",27) //致病菌id
	.s data=dtupId_"^"_dtaupCatCode_"^"_indId_"^"_bodyId_"^"_yfTime_"^"_sub_"^"_kss3IndId_"^"_zbjId_"^"_upmFlag
	i mcgVal="2" d
	.f  s daupRowid=$o(^DAUP("NEWADM",admId,daupRowid),-1)  q:((daupRowid="")||(data'=""))  d
	..s arcimRowid=$p(^DAUP("DAUP",daupRowid),"^",21)
	..q:arcimRowid'=arcimId
	..s daupDate=$p(^DAUP("DAUP",daupRowid),"^",4)
	..s daupTime=$p(^DAUP("DAUP",daupRowid),"^",14)
	..s daupDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(daupDate_","_daupTime)
	..s curDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
	..q:(curDT-daupDT)>(mcgAPPTime*3600)
	..s dtupId=$p(^DAUP("DAUP",daupRowid),"^",20) //使用目的id
	..s dtaupCatCode=""
	..s aimDesc=$p(^DHCAntBasePurposeDataConfigD(dtupId),"^",3)
	..s bigAimDr=$p(^DHCAntBasePurposeDataConfigD(dtupId),"^",6)
	..s:bigAimDr'="" dtaupCatCode=$p(^DHCAntBasePurposeDataConfigD(bigAimDr),"^",4)
	..i aimDesc'["预防-手术" s dtaupCatCode="ZL"
	..s indId=$p(^DAUP("DAUP",daupRowid),"^",10) //指征id
	..s bodyId=$p(^DAUP("DAUP",daupRowid),"^",6) //感染部位id
	..s yfTime=$p(^DAUP("DAUP",daupRowid),"^",22) //预防用药时机id
	..s sub=$p(^DAUP("DAUP",daupRowid),"^",15) //送检
	..s kss3IndId=$p(^DAUP("DAUP",daupRowid),"^",23) //特抗药指征idzbj
	..i kss3IndId="undefined" s kss3IndId=""
	..s zbjId=$p(^DAUP("DAUP",daupRowid),"^",27) //致病菌id
	..s data=dtupId_"^"_dtaupCatCode_"^"_indId_"^"_bodyId_"^"_yfTime_"^"_sub_"^"_kss3IndId_"^"_zbjId
	
	q data
}

/// CTOR: QP
/// DATE: 2018-04-30
/// DESC: 获取申请单相关参数
/// IN  : 
/// OUT : 宽度^高度1^高度2^URL
/// 			800^550^630^650^dhcant.kss.main.hui.csp
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).GetApplyPara()
ClassMethod GetApplyPara()
{
	n 
	s SUSEDRUGTIME=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("SUSEDRUGTIME")
	s VERSION=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("VERSION")
	s APPLYWH=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("APPLYWH")
    s APPLYURL=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("APPLYURL")
    s SMANYCONSULT=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("SMANYCONSULT")
    s CONDEPNUM=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("CONDEPNUM")
    s AW=$p(APPLYWH,",",1)
    s AH=$p(APPLYWH,",",2)
    s ASH=$p(APPLYWH,",",3)
    s ACH=$p(APPLYWH,",",4)
    s ACSH=$p(APPLYWH,",",5)
    s AWAIM=$p(APPLYWH,",",6)	//提示的宽度
    i (SMANYCONSULT=1) d
    .q:CONDEPNUM=""
    .i CONDEPNUM>1 s ACH=ACSH
    s addH=55
    if ((VERSION="4.1.1")&&(SUSEDRUGTIME=1)) {
	    s AH=AH+addH
	    s ASH=ASH+addH
	    s ACH=ACH+addH
	}
    q AW_"^"_AH_"^"_ASH_"^"_ACH_"^"_APPLYURL_"^"_AWAIM
}

/// CTOR: QP
/// DATE: 2018-05-04
/// DESC: 获取联合用药的相关参数
/// IN  : 
/// OUT : 宽度^高度^路径
/// 			
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).GetCombinedPara()
ClassMethod GetCombinedPara()
{
	n 
	s COMBINEDWH=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("COMBINEDWH")
    s COMBINEDURL=##class(DHCAnt.Base.MainConfigExcute).GetOSValueByCode("COMBINEDURL")
    
    s CW=$p(COMBINEDWH,",",1)
    s CH=$p(COMBINEDWH,",",2)
    q CW_"^"_CH_"^"_COMBINEDURL
}

/// CTOR: QP
/// DATE: 2018-05-04
/// DESC: 获取会诊申请信息【山东菏泽东明】
/// IN  : 
/// OUT : 
/// 			
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).GetConsultApplyInfo(1842)
ClassMethod GetConsultApplyInfo(aaid)
{
	n (aaid)
	s execFlag1=0,execFlag2=0,execFlag3=0
	s Consultdep1=$p($g(^DHCDAA("ANT",aaid,1)),"^",4)
	s Consultdep2=$p($g(^DHCDAA("ANT",aaid,1)),"^",27)
	s Consultdep3=$p($g(^DHCDAA("ANT",aaid,1)),"^",30)
	
	s Consultdoc1=$p($g(^DHCDAA("ANT",aaid,1)),"^",5)
	s Consultdoc2=$p($g(^DHCDAA("ANT",aaid,1)),"^",28)
	s Consultdoc3=$p($g(^DHCDAA("ANT",aaid,1)),"^",31)
	
	s ConsultationID1=$p($g(^DHCDAA("ANT",aaid,1)),"^",22)
	s ConsultationID2=$p($g(^DHCDAA("ANT",aaid,1)),"^",26)
	s ConsultationID3=$p($g(^DHCDAA("ANT",aaid,1)),"^",29)
	i ConsultationID1'="" d
	.s obj=##class(User.DHCConsultation).%OpenId(ConsultationID1)
	.q:'$IsObject(obj)
	.s status=obj.Status
	.i status'="V" s execFlag1=1
	
	i ConsultationID2'="" d
	.s obj=##class(User.DHCConsultation).%OpenId(ConsultationID2)
	.q:'$IsObject(obj)
	.s status=obj.Status
	.i status'="V" s execFlag2=1
	
	i ConsultationID3'="" d
	.s obj=##class(User.DHCConsultation).%OpenId(ConsultationID3)
	.q:'$IsObject(obj)
	.s status=obj.Status
	.i status'="V" s execFlag3=1
	
	s out1=Consultdep1_":"_Consultdoc1_":"_execFlag1
	s out2=Consultdep2_":"_Consultdoc2_":"_execFlag2
	s out3=Consultdep3_":"_Consultdoc3_":"_execFlag3
	
    q out1_"^"_out2_"^"_out3
}

/// CTOR: QP
/// DATE: 2018-05-04
/// DESC: 修改会诊申请信息【山东菏泽东明】
/// IN  : 
/// OUT : 暂时不做状态流程不包括AFH,只做AH的。
/// 			
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).UpdateConsultInfo("1848^771^114^676^115^485^116")
ClassMethod UpdateConsultInfo(para)
{
	n (para)
	s aaid=$p(para,"^",1)
	q:aaid="" 0
	
	s doc1=$p(para,"^",2)
	s loc1=$p(para,"^",3)
	s osDoc1=$p($g(^DHCDAA("ANT",aaid,1)),"^",5)
	
	s doc2=$p(para,"^",4)
	s loc2=$p(para,"^",5)
	s osDoc2=$p($g(^DHCDAA("ANT",aaid,1)),"^",28)
	
	s doc3=$p(para,"^",6)
	s loc3=$p(para,"^",7)
	s osDoc3=$p($g(^DHCDAA("ANT",aaid,1)),"^",31)
	
	s user=$p(para,"^",8)
	
	s admId=$p(^DHCDAA("ANT",aaid),"^",1)
	s appStatus=$p($g(^DHCDAA("ANT",aaid)),"^",12)
	s cid1=$p($g(^DHCDAA("ANT",aaid,1)),"^",22)
	s cid2=$p($g(^DHCDAA("ANT",aaid,1)),"^",26)
	s cid3=$p($g(^DHCDAA("ANT",aaid,1)),"^",29)
	s Err=0
	TS 
	if (cid1'="")&&(doc1'=osDoc1)&&(doc1'=osDoc2)&&(doc1'=osDoc3) d
	.s obj1=##class(User.DHCConsultation).%OpenId(cid1)
	.q:'$IsObject(obj1)
	.s status1=obj1.Status
	.q:status1'="V"
	.;撤销之前的会诊申请->发送新的会诊申请
	.s cResult=##class(User.DHCConsultation).ChangeStatus(cid1,"C","Y",user,admId)
	.i cResult'=0 s Err="-101"	//-101 撤销会诊失败
	.q:Err'=0
	.s sResult=..CreateNewConsultationApply(aaid,loc1,doc1)
	.i sResult=0 s Err="-102"	//-102 插入会诊失败
	.q:Err'=0
	.s bResult=..UpdateNewConsultDR(aaid,sResult,1,loc1,doc1)
	.i bResult'=0 s Err="-103"	//-103 变更会诊指征失败
	.q:Err'=0
	
	i Err'=0 {
		TROLLBACK 
		q Err	
	}
	
	if (cid2'="")&&(doc2'=osDoc1)&&(doc2'=osDoc2)&&(doc2'=osDoc3) d
	.s obj2=##class(User.DHCConsultation).%OpenId(cid2)
	.q:'$IsObject(obj2)
	.s status2=obj2.Status
	.q:status2'="V"
	.s cResult=##class(User.DHCConsultation).ChangeStatus(cid2,"C","Y",user,admId)
	.i cResult'=0 s Err="-101"	//-101 撤销会诊失败
	.q:Err'=0
	.s sResult=..CreateNewConsultationApply(aaid,loc2,doc2)
	.i sResult=0 s Err="-102"	//-102 插入会诊失败
	.q:Err'=0
	.s bResult=..UpdateNewConsultDR(aaid,sResult,2,loc2,doc2)
	.i bResult'=0 s Err="-103"	//-103 变更会诊指征失败
	.q:Err'=0
	
	i Err'=0 {
		TROLLBACK 
		q Err	
	}
	
	if (cid3'="")&&(doc3'=osDoc1)&&(doc3'=osDoc2)&&(doc3'=osDoc3) d
	.s obj3=##class(User.DHCConsultation).%OpenId(cid3)
	.q:'$IsObject(obj3)
	.s status3=obj3.Status
	.q:status3'="V"
	.s cResult=##class(User.DHCConsultation).ChangeStatus(cid3,"C","Y",user,admId)
	.i cResult'=0 s Err="-101"	//-101 撤销会诊失败
	.q:Err'=0
	.s sResult=..CreateNewConsultationApply(aaid,loc3,doc3)
	.i sResult=0 s Err="-102"	//-102 插入会诊失败
	.q:Err'=0
	.s bResult=..UpdateNewConsultDR(aaid,sResult,3,loc3,doc3)
	.i bResult'=0 s Err="-103"	//-103 变更会诊指征失败
	.q:Err'=0
	
	i Err'=0 {
		TROLLBACK 
		q Err	
	}
	
 	TCOMMIT
	
    q Err
}

/// CTOR: QP
/// DATE: 2018-05-25
/// DESC: 修改会诊-发送新的会诊申请【山东菏泽东明】
/// IN  : 申请表Id、会诊科室个数
/// OUT : 
/// EXEC:  w ##class(DHCAnt.KSS.FunctionExtend).DBCreateConsultationApply("646","1")
ClassMethod CreateNewConsultationApply(AppRowid As %String, sendLoc As %String, sendDoc As %String)
{
	n (AppRowid,sendLoc,sendDoc)
	q:AppRowid="" -1
	s mRtn=1
	
	s ConsultDep=sendLoc	//$p(^DHCDAA("ANT",AppRowid,1),"^",30)
	s RequestConDoc=sendDoc	//$p(^DHCDAA("ANT",AppRowid,1),"^",31)
	s AppDate=$zd(+$h,3)		//申请日期
	s AppTime=$zt($p($h,",",2))	//申请时间
	s ConType="E"				//类别：一般|C 急|E
	s InOut="I"					//院内(I)|院外(O)  
	s EpisdeID=$p(^DHCDAA("ANT",AppRowid),"^",1)		//病人Adm
	s ArcIM=$p(^DHCDAA("ANT",AppRowid),"^",2)			//医嘱项ID
	s arcimDesc=$p(^ARCIM(+ArcIM,$p(ArcIM,"||",2),1),"^",2)
	s UseReasonID=$p(^DHCDAA("ANT",AppRowid,1),"^",20)	//使用目的表ID
	s UsePurpseDesc="",OPerIndDesc=""
	i UseReasonID'=""  d
	.s ReasonID=$P(^DAUP("DAUP",UseReasonID),"^",20)	//指向表DHC_CT_AntUsePurpose
	.s UsePurpseDesc=$p(^DHCAntBasePurposeDataConfigD(ReasonID),"^",3)	//使用目的：治疗-感染手术-药敏
	.s OPerIndDr=$P(^DAUP("DAUP",UseReasonID),"^",10)	//指向 DHC_Ant_Indications
	.s OPerIndDesc=$p(^DHCAntBasePurposeDataConfigD(OPerIndDr),"^",3)	//指征
	s ConDestination="本病人建议使用【"_arcimDesc_"】，使用目的为："_UsePurpseDesc_"，指征："_OPerIndDesc
	s Specordid=$p(ArcIM,"||",1)_"_"_$p(ArcIM,"||",2)
	s ConDocType=$p(^CTPCP(RequestConDoc,1),"^",4)
	s ConDocTypeDesc=$p(^CT("CPT",ConDocType),"^",2)
	;s DocGrade="C"
	;i ConDocTypeDesc="主任医师" Set DocGrade="D"
	;i ConDocTypeDesc="副主任医师" Set DocGrade="A"
	s AppDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",7)	//申请医生
	s AppDep=$p(^DHCDAA("ANT",AppRowid,1),"^",25)	//申请科室 
	s Status ="V"									//申请状态(V)
	s DocGrade=$p(^CTPCP(RequestConDoc,1),"^",4)
		
	Set parr="ConsultDep"_"|"_ConsultDep_"^"_"AppDate"_"|"_AppDate_"^"_"AppTime"_"|"_AppTime_"^"_"ConType"_"|"_ConType_"^"_"InOut"_"|"_InOut
 	Set parr=parr_"^"_"ConDestination"_"|"_ConDestination_"^"_"EpisdeID"_"|"_EpisdeID_"^"_"Status"_"|"_Status_"^"_"AppDep"_"|"_AppDep
 	Set parr=parr_"^"_"AppDoc"_"|"_AppDoc_"^"_"id|"_"^"_"RequestConDoc"_"|"_RequestConDoc_"^"_"DocGrade"_"|"_DocGrade_"^"_"Specordid"_"|"_Specordid
 	Set flag=##class(web.DHCConsult).savetskjy(parr)
 	q:$p(flag,"^",1)'=1 0
 	s mRtn=$p(flag,"^",2)
 	
	q mRtn
}

/// CTOR: QP
/// DATE: 2016-08-22
/// DESC: 修改会诊-变更申请表中相关会诊科室的指针【山东菏泽东明】
/// IN  : para: ConsultID1^ConsultID2^ConsultID3^AARowid
/// OUT : 
/// NOTE:  
/// EXEC:  w ##class(DHCAnt.KSS.FunctionExtend).DBUpdateConsultDR()
ClassMethod UpdateNewConsultDR(AARowid As %String, ConId As %String, Num As %String, Loc As %String, Doc As %String) As %String
{
	n (AARowid,ConId,Num,Loc,Doc)
	s Err=0
	i Num=1 {
		&SQL(update SQLUser.DHC_Doc_AntibioticApply set AA_DHCConsult_DR=:ConId,
			 AA_ConsultationDep_DR=:Loc,AA_ConsultationDoc_DR=:Doc
        	 where AA_Rowid=:AARowid)
	}
	i Num=2 {
		&SQL(update SQLUser.DHC_Doc_AntibioticApply set AA_DHCConsultTwo_DR=:ConId,
			 AA_ConsultationDepTwo=:Loc,AA_ConsultationDocTwo=:Doc
        	 where AA_Rowid=:AARowid)
	}
	i Num=3 {
		&SQL(update SQLUser.DHC_Doc_AntibioticApply set AA_DHCConsultThree_DR=:ConId,
			 AA_ConsultationDepThree=:Loc,AA_ConsultationDocThree=:Doc
        	 where AA_Rowid=:AARowid)
	}
 	i SQLCODE'=0 s Err=SQLCODE
 	
 	q Err
}

/// CTOR: QP
/// DATE: 2018-06-12
/// DESC: 是否可以再次越级【重庆市中医院】
/// IN  : 
/// OUT : 1：可以，0：不可以
/// TABL: PHC_Poison
/// EXEC: w ##class(DHCAnt.KSS.Common.Method).GetKssCate("903||1")
ClassMethod IfEnableDrug(admId As %String, cArcim As %String, cUser As %String)
{
	n (admId,cArcim,cUser)
	s rtn=1
	Q:(admId="")||(arcim="") rtn
	s aaid="",firstNum=0
	f  s aaid=$o(^DHCDAAi("AdmDR",admId,aaid)) q:(aaid="")||(firstNum=1)  d
	.s oeori=$p(^DHCDAA("ANT",aaid,1),"^",6)
	.q:oeori=""
	.s ord=+oeori,sub=$p(oeori,"||",2)
	.s arcim=$p(^DHCDAA("ANT",aaid),"^",2)
	.q:arcim'=cArcim
	.s Appdate=$P(^DHCDAA("ANT",aaid),"^",10)  
	.s AppTime=$P(^DHCDAA("ANT",aaid),"^",11) 
	.s IsEmergency=$p(^DHCDAA("ANT",aaid,1),"^",23)
	.q:IsEmergency'=1
	.s AppUserDr=$p(^DHCDAA("ANT",aaid),"^",9) 
	.q:AppUserDr'=cUser
	.s opori=$p(^OEORD(ord,"I",sub,1),"^",8)
	.s firstNum=firstNum+1
	.s appNum=86400*Appdate+AppTime
	.s curNum=+$h*86400+$p($h,",",2)
	.i curNum-appNum>86400 s rtn=0
	q:rtn=1 rtn
	
	//当超过24小时之后
	s mRtn=0
	s daupId="",stopNum=""
	f  s daupId=$o(^DAUP("NEWADM",admId,daupId)) q:daupId=""  d
	.s oeori=$p(^DAUP("DAUP",daupId),"^",3)
	.q:oeori=""
	.s ord=+oeori,sub=$p(oeori,"||",2)
	.s arcim=$p(^DAUP("DAUP",daupId),"^",21)
	.q:arcim'=cArcim
	.s opori=$p(^OEORD(ord,"I",sub,1),"^",8)
	.q:opori'=5
	.s stopDate=$p(^OEORD(ord,"I",sub,3),"^",34)
	.s stopTime=$p(^OEORD(ord,"I",sub,2),"^",15)
	.q:stopDate=""
	.s stopNum=stopDate*86400+stopTime
	q:stopNum="" mRtn
	s curNum=+$h*86400+$p($h,",",2)
	i curNum-stopNum<86400 s mRtn=1
	
	q mRtn
}

/// CTOR: QP
/// DATE: 2019-06-21
/// DESC: 越级24h未审核，不能开具所有的抗菌药物
/// IN  : 
/// OUT : 1可以开具，0不可以开具
/// EXEC: 
ClassMethod EnableANTDurg(UserID, Adm, Arcim)
{
	n (UserID, Adm, Arcim)
	k ^TEMP("FunctionExtend",$j)
    s mRtn=1,Seqno=0
    s AARowid=""
    f  s AARowid=$o(^DHCDAAi("AdmDR",Adm,AARowid)) q:AARowid=""  d
    .s OEORIDR=$p(^DHCDAA("ANT",AARowid,1),"^",6)
    .q:OEORIDR=""
    .s ApplyUser=$p(^DHCDAA("ANT",AARowid),"^",9)
    .q:UserID'=ApplyUser
    .q:##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(OEORIDR)=1
    .s ArcimDr=$p(^DHCDAA("ANT",AARowid),"^",2)
    .q:ArcimDr'=Arcim
    .s AAisEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)
    .q:AAisEmergency'=1
    .s ApplyDate=$p(^DHCDAA("ANT",AARowid),"^",10)
    .s ApplyTime=$p(^DHCDAA("ANT",AARowid),"^",11)
    .s ApplyStatus=$p(^DHCDAA("ANT",AARowid),"^",12)
    .q:(ApplyStatus="R")||(ApplyStatus="U")||(ApplyStatus="C")
    .s Seqno=Seqno+1
    .s ^TEMP("FunctionExtend",$j,Seqno,ArcimDr)=ApplyDate_"^"_ApplyTime_"^"_ApplyStatus
    q:Seqno=0 mRtn	//无匹配记录，可以越级
    
    s HasNoAuditRecord=0
    s Seqno=0
    f  s Seqno=$o(^TEMP("FunctionExtend",$j,Seqno)) q:(Seqno="")||(HasNoAuditRecord=1)  d
    .s cArcim=""
    .f  s cArcim=$o(^TEMP("FunctionExtend",$j,Seqno,cArcim)) q:(cArcim="")||(HasNoAuditRecord=1)  d
    ..s ApplyDate=$p(^TEMP("FunctionExtend",$j,Seqno,cArcim),"^",1)
    ..s ApplyTime=$p(^TEMP("FunctionExtend",$j,Seqno,cArcim),"^",2)
    ..s ApplyStatus=$p(^TEMP("FunctionExtend",$j,Seqno,cArcim),"^",3)
    ..s currentDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime($h)
    ..s applyDT=##class(DHCAnt.KSS.Common.Method).GetAbsTime(ApplyDate_","_ApplyTime)
    ..i (currentDT-applyDT)>(24*3600) s mRtn=0,HasNoAuditRecord=1
    
    q mRtn
}

/// CTOR: QP
/// DATE: 2019-06-21
/// DESC: 是否需要皮试提醒
/// IN  : 
/// OUT : 1需要，0不需要
/// EXEC: 
ClassMethod IfNeedPSTip(Arcim)
{
	n (Arcim)
	s mRtn=1
	q:Arcim="" mRtn
	s NOPSDRUG=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("NOPSDRUG")
	i ##class(DHCAnt.KSS.Common.Method).InArray(NOPSDRUG,Arcim)=1 s mRtn=0
	
    q mRtn
}

/// CTOR: QP
/// DATE: 2020-01-11
/// DESC: 越级次数控制
/// IN  : 
/// OUT : 1可以越级/0不可越级
/// EXEC: 
ClassMethod EMNumsControl(InAdm, InArcim, InUser, InHosp)
{
	n (InAdm,InArcim,InUser,InHosp)
	
	s EMNUM=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("EMNUM",InHosp)
	s EMLEVEL=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("EMLEVEL",InHosp)
	Q:EMLEVEL="" 1
	i EMNUM="" s EMNUM=0
	
	s mRtn=1
    s AARowid="",Count=0
	i (EMLEVEL=1)||(EMLEVEL=3) {
		f  s AARowid=$o(^DHCDAAi("ApplyUser",InUser,AARowid)) q:AARowid=""  d
		.s exitFlag=$$IsExit(InAdm, InArcim, InUser, EMLEVEL,AARowid)
		.q:exitFlag=1
		.s Count=Count+1
	} else {
		f  s AARowid=$o(^DHCDAAi("AdmDR",InAdm,AARowid)) q:AARowid=""  d
		.s exitFlag=$$IsExit(InAdm, InArcim, InUser, EMLEVEL,AARowid)
		.q:exitFlag=1
		.s Count=Count+1
	}
	i EMNUM<=Count s mRtn=0
	
	Q mRtn
    
IsExit(InAdm, InArcim, InUser, EMLEVEL, AARowid)
 	n (InAdm, InArcim, InUser, EMLEVEL, AARowid)
	s exit=1
	s OEORIDR=$p(^DHCDAA("ANT",AARowid,1),"^",6)
    q:OEORIDR="" exit
    s AAisEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23)
    q:AAisEmergency'=1 exit
    q:##class(DHCAnt.KSS.Common.Method).FilterOrdStatus(OEORIDR)=1 exit
    s ArcimDr=$p(^DHCDAA("ANT",AARowid),"^",2)
    s ApplyUser=$p(^DHCDAA("ANT",AARowid),"^",9)
    i (EMLEVEL=1)||(EMLEVEL=2) {
		i (ArcimDr=InArcim) s exit=0
	} else {
		s exit=0
	}
	
    Q exit
}

/// CTOR: QP
/// DATE: 2020-01-11
/// DESC: 二次申请控制
/// IN  : 
/// OUT : -1(禁止)、0(不做控制)、1(发送申请)
/// EXEC: 
ClassMethod TwoApplyControl(InAdm, InArcim, InUser, InAdmType, InHosp)
{
	n (InAdm,InArcim,InUser,InAdmType,InHosp)
	s okMsg="0^^^"
	s sendMsg="1^^^"
	s TWOAPP=##class(DHCAnt.Base.MainConfigExcute).GetValueByMCGCode("TWOAPP",InHosp)
	q:(TWOAPP="")||(TWOAPP=0) okMsg
	s KSSCode=##class(DHCAnt.KSS.Common.Method).GetKssCate(InArcim)
	q:KSSCode'["KSS" okMsg
	s InPoisonId=##class(DHCAnt.KSS.Common.Method).GetKssPoisonId(InArcim)
	s InDocId=##class(DHCAnt.KSS.Common.Method).TransSSUserToCTCare(InUser)
	s UserAuthStr=##class(DHCAnt.KSS.MainBusiness).GetDoctorTypePoisonStrNew(InDocId,InAdmType,InHosp)
	s UserAuth=##class(DHCAnt.KSS.Common.Method).GetArrayItem(UserAuthStr,"^",InPoisonId)
	q:UserAuth="" okMsg
	s UserAuth=$p(UserAuth,$C(1),2)
	q:UserAuth="F" "-1^^您没有开具该药品的权限^"
	q:UserAuth="A" okMsg
	s InPhcdf=$p($g(^ARCIM(+InArcim,1,1)),"^",12)
	s InGen=$p(^PHCD(+InPhcdf,4),"^",1)
	
	s AARowid="",TempFlag=0,TempDaupid=""
	f  s AARowid=$o(^DHCDAAi("ApplyUser",InUser,AARowid)) q:(AARowid="")||(TempFlag=1)  d
	.s aaid=AARowid
	.s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
	.s adm=$p(^DHCDAA("ANT",AARowid),"^",1)
	.q:(InAdm'="")&&(adm'=InAdm)
	.s phcdf=$p($g(^ARCIM(+arcim,1,1)),"^",12)
	.s gen=$p(^PHCD(+phcdf,4),"^",1)
	.q:(arcim'=InArcim)&&(TWOAPP=1)
	.q:(gen'=InGen)&&(TWOAPP=2)
	.s oeori=$p(^DHCDAA("ANT",aaid,1),"^",6)
	.s isEmergency=$p(^DHCDAA("ANT",aaid,1),"^",23)
	.;q:(isEmergency=1)&&(oeori="")
	.s status=$p(^DHCDAA("ANT",aaid),"^",12)
	.q:(status="R")||(status="C")
	.s TempDaupid=$p(^DHCDAA("ANT",aaid,1),"^",20)
	.q:'$d(^DAUP("DAUP",TempDaupid))
	.s TempFlag=1
	
   	i TempFlag=1 {
		s copyInfo=..CopyAntUsePurpose(TempDaupid)
		s copyCode=$P(copyInfo,"^",1)
		s copyDaupid=$P(copyInfo,"^",2)
		i copyCode=0 {
			i UserAuth="E" {
				s EnableEM=..EMNumsControl(InAdm, InArcim, InUser, InHosp)
				q "2^"_copyDaupid_"^^"_EnableEM	//临时
			} else {
				i status="U" {
					q "3^"_copyDaupid_"^^"	//长期
				} else {
					s EnableEM=..EMNumsControl(InAdm, InArcim, InUser, InHosp)
					q "4^"_copyDaupid_"^^"_EnableEM	//无需发会诊，但是还不能开长期
				}
				
			}
		} else {
			q "-1^^复制使用目的失败！^"
		}
	} else {
		q sendMsg
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-01-11
/// DESC: 复制医嘱时同时复制使用目的
/// IN  : 
/// OUT : 
/// EXEC: d ##class(DHCAnt.Hosp.HB.XT.JLXYY).CopyAntUsePurpose("24||8")
ClassMethod CopyAntUsePurpose(daupid As %String = "")
{
	n (daupid)
	
	q:$g(daupid)="" 100_"^"
	s Obj=##class(User.DHCAntUsePurpose).%OpenId(daupid)
	if $ISObject(Obj){
		s ObjNew=##class(User.DHCAntUsePurpose).%New()
		if $ISObject(ObjNew){
			s ObjNew.DAUPAdmdr = Obj.DAUPAdmdr
			s ObjNew.DAUPUser = Obj.DAUPUser
			s ObjNew.DAUPLastUpdateUser = Obj.DAUPLastUpdateUser
			//i arcim'="" do ObjNew.DAUPItmMastDRSetObjectId(arcim)	//Quinn	
			s ObjNew.DAUPItmMastDR = Obj.DAUPItmMastDR
			s ObjNew.DAUPDTAUPDR = Obj.DAUPDTAUPDR
			s ObjNew.DAUPOPerInd = Obj.DAUPOPerInd
			s ObjNew.DAUPBodyPart = Obj.DAUPBodyPart
			s ObjNew.DAUPOperaYFTimeDR = Obj.DAUPOperaYFTimeDR
			s ObjNew.DAUPSubmission = Obj.DAUPSubmission  
			S ObjNew.DAUPSusceptDR = Obj.DAUPSusceptDR
			S ObjNew.DAUPOperationDR = Obj.DAUPOperationDR
			s ObjNew.DAUPPatDR = Obj.DAUPPatDR  //病人ID
			s ObjNew.DAUPKSS3Indication = Obj.DAUPKSS3Indication   //新增特抗药指征
			s ObjNew.DAUPZBJ = Obj.DAUPZBJ    //新增致病菌
			s ObjNew.DAUPPreUseDrugTime = Obj.DAUPPreUseDrugTime  //新增预防用药天数
			s ObjNew.DAUPExtendUseReason = Obj.DAUPExtendUseReason  //新增延长用药原因
			s ObjNew.DAUPDate = +$h
			s ObjNew.DAUPTime = $p($h,",",2)
			s ObjNew.DAUPLastUpdateDate = +$h
			s ObjNew.DAUPLastUpdateTime = $p($h,",",2)
			s ObjNew.DAUPCopy = daupid
			set sc=ObjNew.%Save()
			if $$$ISERR(sc){
				quit 200_"^"
			}
			set daupRowid=ObjNew.%Id()
			d ObjNew.%Close()
			S rtn=0
		} else {
			Q 400_"^"
		}
		do Obj.%Close()
	} else {
		Q 300_"^"
	}
	
	Q rtn_"^"_daupRowid
}

/// CTOR: QP
/// DATE: 2020-06-24
/// DESC: 获取上次抗生素医嘱信息
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCAnt.KSS.FunctionExtend).GetDaupInfo(257)
ClassMethod GetDaupInfo(aaid, daupRowid = "")
{
	n (aaid,daupRowid)
	
	i daupRowid="" {
		s daupRowid=$P(^DHCDAA("ANT",aaid,1),"^",20)
	}
	q:$g(daupRowid)="" "-1"
	s data="",upmFlag=0
	s arcimRowid=$p(^DAUP("DAUP",daupRowid),"^",21)
	s daupDate=$p(^DAUP("DAUP",daupRowid),"^",4)
	s daupTime=$p(^DAUP("DAUP",daupRowid),"^",14)
	s dtupId=$p(^DAUP("DAUP",daupRowid),"^",20) //使用目的id
	s dtaupCatCode=""
	s aimDesc=$p(^DHCAntBasePurposeDataConfigD(dtupId),"^",3)
	s bigAimDr=$p(^DHCAntBasePurposeDataConfigD(dtupId),"^",6)
	s:bigAimDr'="" dtaupCatCode=$p(^DHCAntBasePurposeDataConfigD(bigAimDr),"^",4)
	i aimDesc'["预防-手术" s dtaupCatCode="ZL"
	s indId=$p(^DAUP("DAUP",daupRowid),"^",10) //指征id
	s bodyId=$p(^DAUP("DAUP",daupRowid),"^",6) //感染部位id
	s yfTime=$p(^DAUP("DAUP",daupRowid),"^",22) //预防用药时机id
	s sub=$p(^DAUP("DAUP",daupRowid),"^",15) //送检
	s kss3IndId=$p(^DAUP("DAUP",daupRowid),"^",23) //特抗药指征idzbj
	s zbjId=$p(^DAUP("DAUP",daupRowid),"^",27) //致病菌id
	s data=dtupId_"^"_dtaupCatCode_"^"_indId_"^"_bodyId_"^"_yfTime_"^"_sub_"^"_kss3IndId_"^"_zbjId_"^"_upmFlag
	
	q data
}

}
