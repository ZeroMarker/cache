/// 急诊绿色通道
Class web.DHCEMPatGreenRec Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：      zhouxin
/// CreatDate：    2018-07-11
/// Description:： 保存绿色通道
/// Table：        DHC_EmPatGreenRec
/// Return：       {code:0,msg:msg}
/// w ##class(web.DHCEMPatGreenRec).saveGreenRec("","13806","284","N","","284")
ClassMethod saveGreenRec(adm As %String, lgUser As %String, lgGrp As %String, state As %String = "", hours As %String = "", chk As %String = "", GreRea = "") As %String
{
	
	n (adm,lgUser,lgGrp,state,hours,chk,GreRea)
	
	s admVisit=$p($g(^PAADM(+adm)),"^",20)
	q:(adm'="")&&(admVisit'="A")&&(state="Y") "当前就诊非正常状态,禁止开启绿通!当前就诊状态:"_admVisit
	
	s err=0
	ts
	;i (chk'="")&&(adm="") d
	;.i $d(^DHCEMPCA(0,"PatCheckLev",chk)) d	;存在就诊ID
	;..s chkAdmId=0
	;..f  s chkAdmId=$o(^DHCEMPCA(0,"PatCheckLev",chk,chkAdmId)) q:(chkAdmId="")||(err'=0)  d
	;...s thisAdmId=$p(^DHCEMPCA(chkAdmId),"^",2)
	;...s err=##class(web.DHCEMPatGreenRec).saveGreenRecItm(thisAdmId,lgUser,lgGrp,state,hours,chk)
	;.i '$d(^DHCEMPCA(0,"PatCheckLev",chk)) d ;不存在就诊ID
	;..s err=##class(web.DHCEMPatGreenRec).saveGreenRecItm("",lgUser,lgGrp,state,hours,chk)
	i (chk'="")&&(adm="") d
	.s err=##class(web.DHCEMPatGreenRec).saveGreenRecItm("",lgUser,lgGrp,state,hours,chk,GreRea)
	i adm'="" d ;就诊ID
	.s:$d(^DHCEMPCA(0,"AdmChkLev",adm))>=10 chk=$o(^DHCEMPCA(0,"AdmChkLev",adm,""))
	.s err=##class(web.DHCEMPatGreenRec).saveGreenRecItm(adm,lgUser,lgGrp,state,hours,chk,GreRea)
	tro:err'=0
	tc
	
	q err
}

ClassMethod saveGreenRecItm(adm As %String, lgUser As %String, lgGrp As %String, state As %String = "", hours As %String = "", chk As %String = "", GreRea = "")
{
	n (adm,lgUser,lgGrp,state,hours,chk,GreRea)
	
	s GreenAudit=""
	i (adm=""){ ;考虑到和医生站的对接，这里当分诊的时候未插入挂号,只修改插入的绿通
		s greenId=$o(^DHCEMPGR(0,"PatCheckLev",chk,""),-1)
		s obj=""
		i (greenId=""){
			s obj=##class(User.DHCEmPatGreenRec).%New()
		}else{
			s obj=##class(User.DHCEmPatGreenRec).%OpenId(greenId)
		}	
	}else{
		s obj=##class(User.DHCEmPatGreenRec).%New()
		s HospDr=##class(web.DHCEMCommonUtil).GetHospitalByAdm(adm) //hxy 2022-07-20 st
		s GreenAudit=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENAUDIT",HospDr,"","","") //开通绿色通道是否需要审核 //ed
	}
	
	s obj.PGRGreenStartDate=+$h
	s obj.PGRGreenStartTime=$p($h,",",2)
	s obj.PGROperateDate=+$h
	s obj.PGROperateTime=$p($h,",",2)
	s obj.PGRGroup=lgGrp
	d obj.PGROperatorSetObjectId(lgUser)
	d:chk'="" obj.PGRChkDrSetObjectId(chk)
	d:adm'="" obj.PGRAdmDrSetObjectId(adm)
	i state="N" {
		s obj.PGRXOperateDate=+$h
		s obj.PGRXOperateTime=$p($h,",",2)
		d obj.PGRXOperatorSetObjectId(lgUser)
	}
	i state="Y" {
		s obj.PGRXOperateDate=""
		s obj.PGRXOperateTime=""
		d obj.PGRXOperatorSetObjectId("")
	}
	i +hours'=0 {
		s end=$SYSTEM.SQL.DATEADD("hh",hours,$h)
		s end=$zdth(end,3)
		s obj.PGRGreenEndDate=+end
		s obj.PGRGreenEndTime=$p(end,",",2)
	}
	d obj.PGRReasonDrSetObjectId(GreRea)
	s sc=obj.%Save()
	s msg=""
	i $SYSTEM.Status.IsError(sc) {
		s code=$SYSTEM.Status.GetErrorCodes(sc)
		s msg=$SYSTEM.Status.GetErrorText(sc)
	}
	
	q:$SYSTEM.Status.IsError(sc) "保存绿通失败,失败信息:"_msg
	
	s err=0
	;s:(adm'="") err=##class(web.DHCEMPatCheckLev).UpdPaAdmPatGreen(adm,state) //hxy 2022-07-20 st
	s:(adm'="")&(GreenAudit'="1") err=##class(web.DHCEMPatCheckLev).UpdPaAdmPatGreen(adm,state)
	s:(adm'="")&(GreenAudit="1")&(state="N") err=##class(web.DHCEMPatCheckLev).UpdPaAdmPatGreen(adm,state) //ed

	q:err'=0 "修改就诊表绿通失败!"
	q 0
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-11
/// Description:： 查询绿色通道操作记录
/// Table：        DHC_EmPatGreenRec 
/// Others：       w ##class(web.DHCEMPatGreenRec).ListGreenRec("10","1","","18",2)
ClassMethod ListGreenRec(rows As %String, page As %String, adm As %String = "", chk As %String = "", hosp = "") As %String
{
	n (rows,page,adm,chk,hosp,%session)

	s end=page*rows
	s start=(page-1)*rows+1
	
	s GREENAUDIT=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENAUDIT",hosp,"","","") //hxy 2022-07-15
	s AuditUses=..getAuditUses(adm,chk) //审核人串
	s count=0
	s green="",LastGreen=""
	s Num=0
	i adm'="" d
	.f  s green=$o(^DHCEMPGR(0,"Adm",adm,green)) q:green=""  d
	..s LastGreen=##class(web.DHCEmPatGreenRecAudit).GetLastReqParRef(green) //hxy 2022-07-21
	..s Num=Num+1
	..d SetItmData
	s:(chk="")&&(Num=0) chk=$o(^DHCEMPCA(0,"AdmChkLev",adm,""),-1) //hxy 2022-11-01 容错
	i (chk'="")&&(Num=0) d //i (chk'="")&&(adm="") d //hxy 2022-10-14
	.s adm=""
	.f  s green=$o(^DHCEMPGR(0,"PatCheckLev",chk,green)) q:green=""  d
	..s LastGreen=##class(web.DHCEmPatGreenRecAudit).GetLastReqParRef(green) //$o(^DHCEMPGR(0,"PatCheckLev",chk,""),-1) //hxy 2022-07-21
	..d SetItmData
	
	s titlestr="group^opUser^opDate^state^aliveHours^reason^auditSta"
	w "{""rows"":["
	s index="",count=0
	f  s index=$o(TMPData(index)) q:index=""  d
	.s count = count+1
	.q:(count<start)||(count>end)
	.w $case(count,start:"",:",")
	.s tempstr=TMPData(index)
	.w ##class(web.DHCAPPJsonCommon).getJsonData(titlestr,tempstr)
    w "],""total"":"_count_"}"
	q ""
SetItmData
	s TrsEffect=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","有效")
	s TrsNoAudit=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","无需审核")
	s TrsWiAudit=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","待审核")
	s TrsR=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","审核拒绝")
	s TrsP=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","审核通过")
	s TrsC=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","撤销审核")
	s TrsUnEffect=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","失效")
	s TrsCancel=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","取消")
	s TrsReq=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","申请")
	s TrsNoEffect=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp","无效")
	s admId=+$p(^DHCEMPGR(green),"^",6)
	q:(adm'="")&&(adm'=admId)
	s opUser=+$p(^DHCEMPGR(green),"^",7)
	s:opUser'=0 opUser=$p(^SSU("SSUSR",opUser),"^",2)
	s group=$p(^DHCEMPGR(green),"^",13)
	s:group'="" group=$p(^SSU("SSGRP",group),"^",1)
	s opDate=$p(^DHCEMPGR(green),"^",8)
	s opTime=$p(^DHCEMPGR(green),"^",9)
	s opDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(opDate)_" "_$zt(opTime)
	s state=TrsEffect //"有效"
	
	s endDate=$p(^DHCEMPGR(green),"^",4)
	s endTime=$p(^DHCEMPGR(green),"^",5)
	s reason=$p(^DHCEMPGR(green),"^",14) //hxy 2022-07-15 st
	s reason=$p($g(^DHCEMDI(+reason)),"^",2) //原因
	i GREENAUDIT'=1 d
	.s auditStaDef=TrsNoAudit //"无需审核"
	e  d
	.s auditStaDef=TrsWiAudit //"待审核"
	s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",green,""),-1)
	s StaCode=""
	s:AuditID'="" StaCode=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),6)
	s auditSta=$s(StaCode="R":TrsR,StaCode="P":TrsP,StaCode="C":TrsC,1:auditStaDef) //ed
	s aliveHours=""
	i endDate'="" d
	.s aliveHours=$SYSTEM.SQL.DATEDIFF("ss",$h,endDate_","_endTime) //hxy 2022-07-06 hh->ss
	.i aliveHours<0 d
	..s state=TrsUnEffect //"失效"
	..s aliveHours=""
	s xUser=+$p(^DHCEMPGR(green),"^",10)
	q:(xUser'=0)&(AuditUses[("*"_xUser_"*")) //审核人审核拒绝的取消不显示
	i xUser'=0 d
	.s state=TrsCancel //"取消"
	.s aliveHours=""
	s:aliveHours'="" aliveHours=$j(aliveHours/3600,1,2) //hxy 2022-07-21
	s:state=TrsCancel auditSta="" //hxy 2022-07-21 状态为取消的行数据，审核状态列不要显示待审核，可默认为空;
	s:(state=TrsEffect)&&(LastGreen'="")&&(green'=LastGreen) state=TrsUnEffect //hxy 2022-07-21 审核状态为待审核时，绿色通道状态改为申请 ，有多条申请数据时，默认只有最后一条为申请状态，其余显示为无效; st
	s:(auditSta=TrsWiAudit)&&(state=TrsEffect) state=TrsReq //"申请" //ed
	s:(auditSta=TrsC)&&(state=TrsEffect) state=TrsReq //"申请"
	s:(auditSta=TrsR)&&(state=TrsEffect) state=TrsNoEffect //"无效"
	i state=TrsReq d //"申请"
	.s stDate=$p(^DHCEMPGR(green),"^",2)
	.s stTime=$p(^DHCEMPGR(green),"^",3)
	.s:endDate'="" aliveHours=$j($SYSTEM.SQL.DATEDIFF("ss",stDate_","_stTime,endDate_","_endTime)/3600,1,2)
	s:(state=TrsNoEffect)||(state=TrsUnEffect)||(auditSta=TrsR) aliveHours=""  // cy 2022-11-03 绿色通道状态无效或失效时、审核状态为拒绝时 不进行时间计时
	s group=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSGroup","SSGRPDesc","",group)
	s opUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",opUser)
    s auditSta=##class(web.DHCEMCommonUtil).GetTrans("",auditSta)
	s reason=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDicItem","EMDesc","",reason) //hxy 2022-12-20
	s tempstr=$g(group)_"^"_opUser_"^"_opDate_"^"_state_"^"_$g(aliveHours)_"^"_reason_"^"_auditSta
	s count = count+1
	s TMPData(count)=tempstr
	q ""
}

/// Creator：      zhouxin
/// CreatDate：    2018-07-11
/// Description:： 判断该就诊记录是否是绿色通道
/// Table：        DHC_EmPatGreenRec 
/// Others：       w ##class(web.DHCEMPatGreenRec).checkGreenRec("124")
/// Return:        0:非绿色通道 ，1:绿色通道 
ClassMethod checkGreenRec(adm As %String = "", chk As %String = "", Flag = "") As %String
{
	n (adm,chk,Flag)
	s green=""
	s:chk'="" green=+$o(^DHCEMPGR(0,"PatCheckLev",chk,""),-1)
	s:adm'="" green=+$o(^DHCEMPGR(0,"Adm",adm,""),-1)
	i (green=0)&(adm'="") d //仅用于容错，可去掉
	.s chk=$o(^DHCEMPCA(0,"AdmChkLev",adm,""),-1)
	.s:chk'="" green=+$o(^DHCEMPGR(0,"PatCheckLev",chk,""),-1)
	q:green=0 0
	s IfPass=""
	s:Flag="" IfPass=..IfPass(green) //是否审核通过
	q:(Flag="")&&(IfPass'="1") 0
	s endDate=$p(^DHCEMPGR(green),"^",4)
	s endTime=$p(^DHCEMPGR(green),"^",5)
	s aliveHours=0
	i endDate'="" d
	.s aliveHours=$SYSTEM.SQL.DATEDIFF("ss",$h,endDate_","_endTime)
	q:(endDate'="")&&(aliveHours<0) 0 //绿色通道超时
	s xUser=+$p(^DHCEMPGR(green),"^",10)
	q:(xUser'=0) 0 //取消绿色通道
	q 1
}

/// Creator：      qqa
/// CreatDate：    2021-08-25
/// Description:： 分诊就诊列表
/// Table：        DHC_EMPatChkAdm
/// Others：       w ##class(web.DHCEMPatGreenRec).ListChkAdm("292","2")
/// Return:        ListJson
ClassMethod ListChkAdm(chk, lgHospID)
{
	n (chk,lgHospID)
	w "["
	s chkAdmId=0,count=0
	f  s chkAdmId=$o(^DHCEMPCA(0,"PatCheckLev",chk,chkAdmId)) q:chkAdmId=""  d
	.s admId=$p(^DHCEMPCA(chkAdmId),"^",2)
	.s admHospId=##class(web.DHCEMCommonUtil).GetHospitalByAdm(admId)
	.q:(lgHospID'="")&&(lgHospID'=admHospId)
	.s admVisit=$p($g(^PAADM(admId)),"^",20)
	.s admDate=$p($g(^PAADM(admId)),"^",6)
	.s admDateDesc = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(admDate)
	.s admLocDr = $p($g(^PAADM(admId)),"^",4)
	.s admLocDesc = $p(^CTLOC(admLocDr),"^",2)
	.s provId = $p($g(^PAADM(admId)),"^",9)
	.s careProv=""
	.s:provId'="" careProv = $p(^CTPCP(provId,1),"^",2)
	.s listData = admId_"^"_admLocDesc_"("_careProv_":"_admDateDesc_")"
	.s count=count+1
	.W $case(count,1:"",:",") 
	.W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",listData)
	w "]"
	q ""
}

/// Creator：      qqa
/// CreatDate：    2021-08-25
/// Description:： 就诊状态是否处于正常状态
/// Table：        DHC_EmPatGreenRec 
/// Others：       w ##class(web.DHCEMPatGreenRec).admStateIsNormal("124")
/// Return:        Y/N
ClassMethod admStateIsNormal(adm As %String = "")
{
	n (adm)
	s admState=$P(^PAADM(adm),"^",20)
	q admState
}

/// Creator：      hxy
/// CreatDate：    2022-06-20
/// Description:： 判断该就诊记录该时间是否是绿色通道 (若传入时间为就诊时间，则返回本次就诊是否开通过绿色通道)
/// Table：        DHC_EmPatGreenRec 
/// Others：       w ##class(web.DHCEMPatGreenRec).checkGreenRecByTime("17863")
/// Return:        0:非绿色通道 ，1:绿色通道 
ClassMethod CheckGreenRecByTime(Adm As %String, Date As %String, Time As %String) As %String
{
	n (Adm,Date,Time)
	s Ids=..GetGreenIds(Adm)
	q:Ids="" 0
	s ret=0,flag=0
	s AdmDate=$p($g(^PAADM(+Adm)),"^",6)
    s AdmTime=$p($g(^PAADM(+Adm)),"^",7)
    s:(AdmDate=Date)&(AdmTime=Time) flag=1
	s DateTime=Date_","_Time
	s stIdStr="^"
  	s len=$l(Ids,"^")
  	for i=1:1:len d
  	.q:ret'=0
  	.s Id=$p(Ids,"^",i)
  	.q:Id=""
  	.q:stIdStr[("^"_Id_"^")
  	.s stDate="",stTime="",endDate="",endTime=""
	.s xUser=$p(^DHCEMPGR(Id),"^",10)
	.i xUser'="" d
	..s endDate=$p(^DHCEMPGR(Id),"^",11)
	..s endTime=$p(^DHCEMPGR(Id),"^",12)
	..s stId=$p(Ids,"^",i+1)
	..s stDate=$p(^DHCEMPGR(stId),"^",2)
	..s stTime=$p(^DHCEMPGR(stId),"^",3)
	..s stIdStr=stIdStr_stId_"^"
	..s IfPass=..IfPass(stId) //是否审核通过
	.e  d
	..s stDate=$p(^DHCEMPGR(Id),"^",2)
	..s stTime=$p(^DHCEMPGR(Id),"^",3)
	..s endDate=$p(^DHCEMPGR(Id),"^",4)
	..s endTime=$p(^DHCEMPGR(Id),"^",5)
	..s IfPass=..IfPass(Id) //是否审核通过
	.q:IfPass'="1"
	.s:flag=1 ret=1
	.q:ret=1
	.s:(endDate="")&&(i=1) endDate=+$h,endTime=$p($h,",",2)
	.q:(endDate="")&&(i'=1)
	.s timeDiff=0
	.i endDate'="" d
	..s timeDiff=$SYSTEM.SQL.DATEDIFF("ss",DateTime,endDate_","_endTime)
	.q:(endDate'="")&&(timeDiff<0)
	.q:$SYSTEM.SQL.DATEDIFF("ss",stDate_","_stTime,DateTime)<0
	.s ret=1

	q ret
}

/// Creator：      hxy
/// CreatDate：    2022-06-20
/// Description:： 根据就诊取绿通的ID串
/// Table：        DHC_EmPatGreenRec 
/// Return:        ^分割的ID串，例如"45^44^43^42"
/// Others：       w ##class(web.DHCEMPatGreenRec).GetGreenIds("17859")
ClassMethod GetGreenIds(Adm As %String) As %String
{
	n (Adm)
	s Ids=""
	s GreID=""
	F  s GreID=$o(^DHCEMPGR(0,"Adm",Adm,GreID),-1) Q:(GreID="")  D
	.s:Ids'="" Ids=Ids_"^"_GreID
	.s:Ids="" Ids=GreID
	q Ids
}

/// Creator：      hxy
/// CreatDate：    2022-07-20
/// Description:： 判断绿色通道是否审核通过
/// Table：        DHC_EmPatGreenRecAudit
/// Return:        1:通过
/// Others：       w ##class(web.DHCEMPatGreenRec).IfPass("124")
ClassMethod IfPass(green) As %String
{
	n (green)
	s ret=""
	s HospDr=##class(web.DHCEMCommonUtil).GetHospitalIDByGreID(green)
	s GREENAUDIT=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENAUDIT",HospDr,"","","")
	q:GREENAUDIT'=1 "1" //配置不需审核，则直接通过
	s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",green,""),-1)
	s StaCode=""
	i AuditID'="" d
	.s StaCode=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),6)
	s:StaCode="P" ret="1"
	q ret
}

/// Creator：      hxy
/// CreatDate：    2022-07-29
/// Description:： 判断该分诊记录是否是绿色通道
/// Table：        DHC_EmPatGreenRec 
/// Others：       w ##class(web.DHCEMPatGreenRec).checkGreenRecAndRea("124")
/// Return:        绿通标识^绿通申请原因（0:非绿色通道 ，1:绿色通道）
ClassMethod checkGreenRecAndRea(chk) As %String
{
	n (chk)
	q:chk="" "^"
	s GreFlag=##class(web.DHCEMPatGreenRec).checkGreenRec("",chk,"Y")
	s GreReaDr=""
	s:GreFlag=1 GreReaDr=##Class(web.DHCEMPatCheckLev).GetEmPatGreenReaDr(chk,"")
	q GreFlag_"^"_GreReaDr
}

/// Others：w ##class(web.DHCEMPatGreenRec).getAuditUses("3194","251")
ClassMethod getAuditUses(adm, chk) As %String
{
	n (adm,chk)
	s AuditUses="*"
	s green=""
	i adm'="" d
	.f  s green=$o(^DHCEMPGR(0,"Adm",adm,green)) q:green=""  d
	..s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",green,""))
	..i AuditID'=""  d
	...s User=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),3)
	...s:(User'="")&&(AuditUses'[("*"_User_"*")) AuditUses=AuditUses_User_"*"
	i (chk'="")&&(adm="") d
	.f  s green=$o(^DHCEMPGR(0,"PatCheckLev",chk,green)) q:green=""  d
	..s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",green,""))
	..i AuditID'=""  d
	...s User=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),3)
	...s:(User'="")&&(AuditUses'[("*"_User_"*")) AuditUses=AuditUses_User_"*"
	q AuditUses
}

}
