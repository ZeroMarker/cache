Include Nur.DateFormat

Class web.DHCConsult Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：     LiuMeng
/// CreatDate :   2017-11-19
/// Description : 查询当前日期段别科邀请本科某个医生所有会诊记录
/// Input :       开始日期,结束日期,当前科室Id,当前医生UserCode
/// Return ：     床号,登记号,姓名,出生日期,就诊号,就诊类型,性别,入院日期,入院时间,就诊号,申请会诊科室,申请会诊医生,会诊意见,年龄,预交金,费用,余额,缴费方式,病案号,民族
/// d ##class(%ResultSet).RunQuery("web.DHCConsult","ConsultSubInfo","2015-07-08","2017-11-18","9","")
Query ConsultSubInfo(StartDate, EntDate, NowLocId, UserCode) As websys.Query(ROWSPEC = "BedCode:%String,RegNo:%String,Name:%String,ToSeeNo:%String,ToSeeType:%String,Sex:%String,Date:%String,Time:%String,apploc:%String,condoc:%String,ConDestination:%String,Age:%String,TotalAm:%String,Cost:%String,Balance:%String,PaymentMe:%String,MedRecord:%String,Peoples:%String")
{
}

ClassMethod ConsultSubInfoExecute(ByRef QHandle As %Binary, StartDate, EntDate, NowLocId, UserCode) As %Status
{
	s repid=$I(^CacheTemp)        
	s ind=1,ret=""                      
	s QHandle=$lb(0,repid,0) 
	i ((StartDate="")&(EntDate="")&(NowLocId="")) q $$$OK 
    s:StartDate["-" StartDate=$zdh(StartDate,3)
    s:StartDate["/" StartDate=$zdh(StartDate,5)
    s:EntDate["-" EntDate=$zdh(EntDate,3)
    s:EntDate["/" EntDate=$zdh(EntDate,5)
    s CurConLoc=" "_NowLocId
    f CurDate=StartDate:1:EntDate
    {
    	s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",CurDate,CurConLoc,id)) q:id=""  d
    	.s a=^User.DHCConsultationD(id)             
    	.s appdep=$listget(a,4)   
    	.s apploc=$p(^CTLOC(appdep),"^",2)     //请会诊科室
    	.i apploc["-" s apploc=$p(apploc,"-",2)
    	.s appdoc=$listget(a,5)                //申请医生userid
    	.s appdoc=$p($g(^SSU("SSUSR",appdoc)),"^",2)
    	.s conlocid=$listget(a,11)              
		.s ConDestination=$listget(a,7)        //会诊意见
		.s adm=$listget(a,2)    
		.s ToSeeNo=$p($g(^PAADM(adm)),"^",81)      //就诊号
		.s ToSeeType=$p($g(^PAADM(adm)),"^",2)     //就诊类型
		.s Birthday=$zd($p(^PAPER($p($g(^PAADM(adm)),"^",1),"ALL"),"^",6),3)
   		.s PatInfo=##class(web.DHCNurIpComm).NurPatInfo(adm)
   		.s Name=$p($g(PatInfo),"^",1)
   		.s Sex=$p($g(PatInfo),"^",2)
   		.s Age=$p($g(PatInfo),"^",3)
   		.s BedCode=$p($g(PatInfo),"^",4)
   		.s RegNo=$p($g(PatInfo),"^",5)    
   		.s Date=$p($p($g(PatInfo),"^",6)," ",1) 
   		.s Time=$p($p($g(PatInfo),"^",6)," ",2)
    	.s Cost=$p($g(PatInfo),"^",7)          //费用
    	.s TotalAm=$p($g(PatInfo),"^",8)       //预交金
    	.s PaymentMe=$p($g(PatInfo),"^",10)    //缴费方式
    	.s MedRecord=$p($g(PatInfo),"^",16)    //病案号
    	.s Peoples=$p($g(PatInfo),"^",17)      //民族
    	.s Balance=$p($g(PatInfo),"^",20)      //余额
    	.s condocCode=$listget(a,20)               
    	.s:condocCode'="" condoc=$p($g(^CTPCP(condocCode,1)),"^",2)  //会诊医生
   		.q:(NowLocId'=conlocid)
   		.q:((UserCode'="")&(UserCode'=condocCode)&(condocCode'=""))
		.d OutputRow9
    }
	Set QHandle=$lb(0,repid,0)    
	Quit $$$OK                    
OutputRow9
	set Data=$lb(BedCode,RegNo,Name,Birthday,ToSeeNo,ToSeeType,Sex,Date,Time,apploc,condoc,ConDestination,Age,TotalAm,Cost,Balance,PaymentMe,MedRecord,Peoples)
	Set ^CacheTemp(repid,ind)=Data       
	Set ind=ind+1                        
	quit
}

/// Creator：     LiuMeng
/// CreatDate :   2017-10-09
/// Description : 判断病人是否会诊，院内会诊几次，院外会诊几次
/// Input :       病人就诊号 Adm
/// Return ：     0 该病人没有会诊记录, 非0 院内院外会诊次数
/// w ##class(web.DHCConsult).JudgmentConsult(2166)
ClassMethod JudgmentConsult(Adm As %String)
{
	q:Adm=""
	s count=0,num=0,ret=""
	s PatInfo=##class(web.DHCNurIpComm).NurPatInfo(Adm)
	s Date=$p($p($g(PatInfo),"^",6)," ",1)    //患者入院日期
    s Date=$zdh(Date,3)
    s EndDate=$p($h,",",1)
    f CurDate=Date:1:EndDate
    {
    	s CurConLoc="" f  s CurConLoc=$O(^User.DHCConsultationI("ConSultDep",CurDate,CurConLoc)) q:CurConLoc=""  d
    	.s ConLocId=$TR(CurConLoc," ","")
    	.s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",CurDate,CurConLoc,id)) q:id=""  d
	    ..s a=^User.DHCConsultationD(id)
	    ..s adm=$listget(a,2)
	    ..q:(adm'=Adm)
	    ..s InOut=$listget(a,14)    //会诊类型(I:院内,O:院外)
	    ..i InOut="I" s count=count+1
	    ..i InOut="O" s num=num+1   
    } 
    i ((count=0)&(num=0)) s ret=0
	e  s ret="院内会诊次数:"_count_"##"_"院外会诊次数:"_num
    q ret
}

// 根据科室取医院名称

ClassMethod gethospital(id)
{
	q:id="" ""
	s hospitaldr=$p(^CTLOC(id),"^",22)
	q:hospitaldr="" ""
	s desc=$p(^CT("HOSP",hospitaldr),"^",2)
	q desc
}

// d ##class(web.DHCConsult).GetListConsult("2017-02-10","2017-02-11","6","","","","0","addconsult")

ClassMethod GetListConsult(stdate, edate, loc, consultType, ConsultInOut, consultStatu, execflag, funname, currUser As %String = "", consultId As %String = "")
{
	;s ^sctmpv1("GetListConsult") = stdate_","_ edate_","_ loc_","_ consultType_","_ ConsultInOut_","_ consultStatu_","_ execflag_","_funname
    i execflag="true" s execflag=1
    i execflag="false" s execflag=0
    s stdate=$$$ZDH(stdate,3),edate=$$$ZDH(edate,3)
    s locStr=##class(User.DHCLocGroup).getLocStr(loc)
    i locStr="" s locStr="^"_loc_"^",isNotDutyRoomFlag=1
    e  s isNotDutyRoomFlag=0
    
    s curDocGrade = ""
    i $d(%session)
    {
    	s curDoc=$g(%session.Data("LOGON.USERID"))
    	i curDoc'="" d
    	.s curUserCode = $p($g(^SSU("SSUSR",curDoc)),"^",1)
    	.s ctpcpID =""  
    	.f  s ctpcpID = $o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(curUserCode),ctpcpID)) q:ctpcpID=""  d
    	..s curDocGrade = $p($g(^CTPCP(ctpcpID,1)),"^",4)
    }
    else{
	    s curDoc=""
    	s curUserCode =""
    	s curDocGrade = ""
    	i curDoc'="" d
    	.s curUserCode = $p($g(^SSU("SSUSR",curDoc)),"^",1)
    	.s ctpcpID =""  
    	.f  s ctpcpID = $o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(curUserCode),ctpcpID)) q:ctpcpID=""  d
    	..s curDocGrade = $p($g(^CTPCP(ctpcpID,1)),"^",4)
	}
    i funname="" //打印
    {
	    s curDoc=currUser
    	i curDoc'="" d
    	.s curUserCode = $p($g(^SSU("SSUSR",curDoc)),"^",1)
    	.s ctpcpID =""  
    	.f  s ctpcpID = $o(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(curUserCode),ctpcpID)) q:ctpcpID=""  d
    	..s curDocGrade = $p($g(^CTPCP(ctpcpID,1)),"^",4)
	  }
    /*else{
    	s curDoc=""
    	s curUserCode =""
    	s curDocGrade = ""
	}*/
		
    i ("^"_loc_"^")'[locStr s locStr=locStr_loc_"^"
    s num=$length(locStr,"^")
    s isAntiDoc=0
    s isAntiDoc=##class(DHCAnt.KSS.Common.Method).ComIfAntiConsultDoc(curDoc)
    s AntiId=""
    f  s AntiId=$O(^DHCAntBasePurposeDataConfigI("PDCType","CONDOC",AntiId)) q:(AntiId="")!(isAntiDoc=1)  d
    .s antiDoc=$p(^DHCAntBasePurposeDataConfigD(AntiId),"^",3)
    .s antiDoc=$O(^SSU("SSUSR",0,"CTPCP",antiDoc,""))
    .i curDoc=antiDoc s isAntiDoc=1
    .e  s isAntiDoc=0

    /*s AntiId=""
    f  s AntiId=$O(^User.DHCAntiConsultDocInfoI("ConLocDR"," "_loc,AntiId)) q:(AntiId="")!(isAntiDoc=1)  d
    .s objAnti=^User.DHCAntiConsultDocInfoD(AntiId)
    .s antiDoc=$listget(objAnti,3)
    .s antiDoc=$O(^SSU("SSUSR",0,"CTPCP",antiDoc,""))
    .i curDoc=antiDoc s isAntiDoc=1
    .e  s isAntiDoc=0*/
    if (consultId=""){
	    f date=stdate:1:edate
	    {
		    f ind=2:1:num
		    {
				s locId=$P(locStr,"^",ind)
				q:locId=""
	    		s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",date," "_locId,id)) q:id=""  d
		    	.;q:((consultId'="")&&(id'=consultId))
		    	.s a=^User.DHCConsultationD(id)
		    	.d Consult(a)
		    }
	    }
    }else{	    
    	s id=consultId
	    s a=^User.DHCConsultationD(id)
	    d Consult(a)
	}
    s locDesc=$p(^CTLOC(loc),"^",2)
    i locDesc["国际医疗" 
    {
	    
	    s linkLocId=0
	    f  s linkLocId=$o(^CTLOC(loc,"LINK",linkLocId)) q:linkLocId=""  d
	    .s linkLocId=^CTLOC(loc,"LINK",linkLocId)
	    .f date=stdate:1:edate d
	    ..s id="" f  s id=$O(^User.DHCConsultationI("AppDep",date," "_linkLocId,id)) q:id=""  d
	    ...s a=^User.DHCConsultationD(id)
		...s type=$listget(a,9)
		...q:(consultType'="")&(type'=consultType)
		...s curInOut=$listget(a,14)
		...q:(ConsultInOut'="")&(curInOut'=ConsultInOut)
		...s conStatus=$listget(a,16)
		...q:(consultStatu'="")&(conStatus'=consultStatu)
	    ...s Adm=$listget(a,2)
	    ...s currentWardDr=$p(^PAADM(Adm),"^",70)
	    ...q:currentWardDr=""
	    ...s locationDr=$p(^PAWARD(currentWardDr),"^",5)
	    ...q:(locationDr="")||(locationDr'=loc)
	    ...s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
	    ...s Diag=$P(patinf,"^",9)
	    ...S patname=$P(patinf,"^",5)
	    ...s bedcode=$P(patinf,"^",6)
	    ...s RegNo=$P(patinf,"^",1)
	    ...s Bah=$P(patinf,"^",10)
	    ...s appdate=$listget(a,3)
	    ...if appdate'="" s appdate=$$$ZD(appdate,3)
	    ...s appdep=$listget(a,4)
	    ...if appdep'="" s appdep=$P(^CTLOC(appdep),"^",2)
	    ...if $L(appdep,"-")>1 s appdep=$P(appdep,"-",2)
	    ...s appdoc=$listget(a,5)
	    ...if appdoc'="" s appdoc=$P(^SSU("SSUSR",appdoc),"^",14)
	    ...s apptime=$listget(a,6)
	    ...if apptime'=""  s apptime=$ZT(apptime,2)
	    ...s attitude=$listget(a,7)
	    ...s condestinat=$listget(a,8)
	    ...s type=$listget(a,9)
	    ...s consultdate=$listget(a,10)
	    ...if consultdate'="" s consultdate=$$$ZD(consultdate,3)
	    ...s condep=$listget(a,11)
	    ...s condepID=condep
	    ...if condep'=""  s condep=$P(^CTLOC(condep),"^",2)
	    ...if $L(condep,"-")>1 s condep=$P(condep,"-",2)
	    ...s condoc=$listget(a,12)
	    ...if condoc'="" d
	    ....//s condoc=$P($G(^SSU("SSUSR",condoc)),"^",14)
	    ....s condoc=$p($G(^CTPCP(condoc,1)),"^",2)
	    ....i condoc="" s condoc=$listget(a,12)
	    ...s contime=$listget(a,13)
	    ...if contime'="" s contime=$ZT(contime,2)
	    ...s InOut=$listget(a,14)
	    ...i InOut="I" s InOut="院内"
	    ...i InOut="O" s InOut="院外"
	    ...s RelOrder=$listget(a,15)
	    ...s status=$listget(a,16)
	    ...q:status="C"
	    ...q:(execflag=1)&(status'="E")
	    ...q:(execflag=0)&(status="E")
	    ...i status="V" s status="申请"
	    ...i status="E" s status="执行"
	    ...i status="C" s status="撤销"
	    ...i status="W" s status="待审"
	    ...q:(status="R")&&(consultStatu'="R")
	    ...i status="R" s status="退回"
	    ...i type="C" s typ="普通"
	    ...if type="E" s typ="急"
	    ...if type="M" s typ="多科"
	    ...if type="A" s typ="抗菌药"
		...s RequestConDoc=$listget(a,20)
    	...i RequestConDoc'="" s RequestConDoc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
    	...e  s RequestConDoc=""
    	...s a=##class(User.DHCConsultation).%OpenId(id) //抗菌药
        ...s attitudetsy=a.attitudetsy  //抗菌药
        ...s Specordid=a.Specordid  //抗菌药
    	...s arcitmmastdesc=""  //抗菌药
    	...i Specordid'="" d     //抗菌药
    	....s OEORDRowId=$p(Specordid,"_")
    	....s OEORIChildsub=$p(Specordid,"_",2)
    	....s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
    	...i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat  //抗菌药
	    ...//s ^tmpe245(1)=type_"^"_typ_"^"_patname_"^"_condepID
	    ...i funname="" d
	    ....s ^mtemp($J,"ListConsult",id)=condep_"^"_condoc_"^"_status_"^"_$P($g(bedcode),"@",2)_"^"_appdep_"^"_InOut_"^"_$P($g(Diag),"@",2)_"^"_condestinat_"^"_$P($g(patname),"@",2)_"^"_apptime_"^"_appdate_"^"_consultdate_"^"_contime_"^"_Adm_"^"_id_"^"_typ_"^"_condepID_"^"_RequestConDoc_"^"_$P($g(RegNo),"@",2)_"^"_$P($g(Bah),"@",2)
	    ...e  d
	    ....s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(condoc),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($G(InOut),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($G(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"','"_$ZCVT($g(condepID),"O","JS")_"','"_$ZCVT($g(RequestConDoc),"O","JS")_"','"_$ZCVT($P($g(RegNo),"@",2),"O","JS")_"','"_$ZCVT($P($g(Bah),"@",2),"O","JS")_"');"
	    ....&javascript<#(rtnval)#>
    }
    q
Consult(a)
	s type=$listget(a,9)
	q:(consultType'="")&(type'=consultType)
	s curInOut=$listget(a,14)
	q:(ConsultInOut'="")&(curInOut'=ConsultInOut)
	s conStatus=$listget(a,16)
	q:(consultStatu'="")&(conStatus'=consultStatu)
	s applocId=$listget(a,4)
	s conlocId=$listget(a,11)
	s appgroup=##class(User.DHCLocGroup).getGroupByLocDR(applocId)
	s congroup=##class(User.DHCLocGroup).getGroupByLocDR(conlocId)
	i appgroup=congroup s isSameDepGroup=1
	else  s isSameDepGroup=0
	s MoreLoc=$listget(a,22)
	s type=$listget(a,9)
	s subId=$O(^User.DHCConsultationSubI("ConsultDRINDEX"," "_id,""),-1)
	s DutyFlag=0
	i subId'="" d
	.s subObj=^User.DHCConsultationSubD(subId)
	.s ISDutyRoomFlag=$listget(subObj,3)
	.i isSameDepGroup=0 d
	..i (isNotDutyRoomFlag=0)&&(ISDutyRoomFlag'="Y") s DutyFlag=1 //值班室已发送的退出
	..i (isNotDutyRoomFlag=1)&&(ISDutyRoomFlag="Y") s DutyFlag=1 //非值班室未发送的退出
	.e  i isNotDutyRoomFlag=0 s DutyFlag=1
	q:(DutyFlag=1)&(consultStatu'="T")&&(MoreLoc'="Y")&&(type'="A")
	i (isNotDutyRoomFlag=1)&&(loc'=conlocId) q
	s Adm=$listget(a,2)
	s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
	s Diag=$P(patinf,"^",9)
	S patname=$P(patinf,"^",5)
	s bedcode=$P(patinf,"^",6)
	s RegNo=$P(patinf,"^",1)
	s Bah=$P(patinf,"^",10)
	s EncryptLevel=$p(patinf,"^",25)
	s PatLevel=$p(patinf,"^",26)
	s appdate=$listget(a,3)
	if appdate'="" s appdate=$$$ZD(appdate,3)
	s appdep=$listget(a,4)
	if appdep'="" s appdep=$P(^CTLOC(appdep),"^",2)
	if $L(appdep,"-")>1 s appdep=$P(appdep,"-",2)
	s appdoc=$listget(a,5)
	if appdoc'="" s appdoc=$P(^SSU("SSUSR",appdoc),"^",14)
	s apptime=$listget(a,6)
	if apptime'=""  s apptime=$ZT(apptime,2)
	s attitude=$listget(a,7)
	s condestinat=$listget(a,8)
	s type=$listget(a,9)
	s consultdate=$listget(a,10)
	if consultdate'="" s consultdate=$$$ZD(consultdate,3)
	s condep=$listget(a,11)
	s condepID=condep
	if condep'=""  s condep=$P(^CTLOC(condep),"^",2)
	if $L(condep,"-")>1 s condep=$P(condep,"-",2)
	s condoc=$listget(a,12)
	if condoc'="" d
	.//s condoc=$P($G(^SSU("SSUSR",condoc)),"^",14)
	.s condoc=$p($G(^CTPCP(condoc,1)),"^",2)
	.i condoc="" s condoc=$listget(a,12)
	s contime=$listget(a,13)
	if contime'="" s contime=$ZT(contime,2)
	s InOut=$listget(a,14)
	i InOut="I" s InOut="院内"
	i InOut="O" s InOut="院外"
	s RelOrder=$listget(a,15)
	s status=$listget(a,16)
	q:status="C"
	q:(execflag=1)&(status'="E")
	q:(execflag=0)&(status="E")
	i status="V" s status="申请"
	i status="E" s status="执行"
	i status="C" s status="撤销"
	i status="T" s status="发至专科"
	i status="W" s status="待审"
	q:(status="R")&&(consultStatu'="R")
	i status="R" s status="退回"
	if type="C" s typ="普通"
	if type="E" s typ="急"
	if type="M" s typ="多科"
	if type="A" s typ="抗菌药"
	s RequestConDoc=$listget(a,20)
	i RequestConDoc'="" s RequestConDoc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
	e  s RequestConDoc=""
	s MoreLoc=$listget(a,22)
	s confirmFlag=$listget(a,31)
	q:(MoreLoc="Y")&(confirmFlag="Y")
	s a=##class(User.DHCConsultation).%OpenId(id) //抗菌药
	s attitudetsy=a.attitudetsy  //抗菌药
	s Specordid=a.Specordid  //抗菌药
	s arcitmmastdesc=""  //抗菌药
	s isAntShow=0
	i (Specordid'="") d
	.s requestDoc=a.RequestConDoc
	.s requestDoc=$O(^SSU("SSUSR",0,"CTPCP",requestDoc,""))
	.i (isAntiDoc=0)&&(applocId=conlocId) d
	..s isAntShow=1
	.e  i (curDoc'=requestDoc)&&(applocId'=conlocId) d
	..s isAntShow=1
	q:(isAntShow=1)
	s requestDoc=""
	i a.RequestConDoc'="" d
	.s requestDoc=a.RequestConDoc
	.s requestDoc=$O(^SSU("SSUSR",0,"CTPCP",requestDoc,""))
	e  d
	.i a.DocGrade=curDocGrade d
	.s requestDoc=curDoc
	.e  s requestDoc=""
	q:((curDoc'=requestDoc)&&(applocId'=conlocId))
	i Specordid'="" d     //抗菌药
	.s OEORDRowId=$p(Specordid,"_")
	.s OEORIChildsub=$p(Specordid,"_",2)
	.s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
	i arcitmmastdesc'="" s condestinat=condestinat_" "_arcitmmastdesc  //抗菌药
	//s ^tmpe245(1)=type_"^"_typ_"^"_patname_"^"_condepID
	i funname="" d
	.s ^mtemp($J,"ListConsult",id)=condep_"^"_condoc_"^"_status_"^"_$P($g(bedcode),"@",2)_"^"_appdep_"^"_InOut_"^"_$P($g(Diag),"@",2)_"^"_condestinat_"^"_$P($g(patname),"@",2)_"^"_apptime_"^"_appdate_"^"_consultdate_"^"_contime_"^"_Adm_"^"_id_"^"_$g(typ)_"^"_condepID_"^"_RequestConDoc_"^"_$P($g(RegNo),"@",2)_"^"_$P($g(Bah),"@",2)
	e  d
	.s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(condoc),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($G(InOut),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($G(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"','"_$ZCVT($g(condepID),"O","JS")_"','"_$ZCVT($g(RequestConDoc),"O","JS")_"','"_$ZCVT($P($g(RegNo),"@",2),"O","JS")_"','"_$ZCVT($P($g(Bah),"@",2),"O","JS")_"','"_$ZCVT($P($g(EncryptLevel),"@",2),"O","JS")_"','"_$ZCVT($P($g(PatLevel),"@",2),"O","JS")_"');"
	.&javascript<#(rtnval)#>
}

ClassMethod GetListConsultPrnint(stdate, edate, loc, execflag, funname)
{
    i execflag="true" s execflag=1
    i execflag="false" s execflag=0
    //s ^ojbcyf1=stdate_"^"_edate_"^"_loc_"^"_execflag_"^"_funname
    s stdate=$$$ZDH(stdate,3),edate=$$$ZDH(edate,3)
    f date=stdate:1:edate
    {
    	s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",date," "_loc,id)) q:id=""  d
	    .s a=^User.DHCConsultationD(id)
	    .s Adm=$listget(a,2)
	    .s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
	    .s Diag=$P(patinf,"^",9)
	    .S patname=$P(patinf,"^",5)
	    .s bedcode=$P(patinf,"^",6)
	    .s RegNo=$P(patinf,"^",1)
	    .s Bah=$P(patinf,"^",10)
	    .s appdate=$listget(a,3)
	    .if appdate'="" s appdate=$$$ZD(appdate,3)
	    .s appdep=$listget(a,4)
	    .if appdep'="" s appdep=$P(^CTLOC(appdep),"^",2)
	    .if $L(appdep,"-")>1 s appdep=$P(appdep,"-",2)
	    .s appdoc=$listget(a,5)
	    .if appdoc'="" s appdoc=$P(^SSU("SSUSR",appdoc),"^",14)
	    .s apptime=$listget(a,6)
	    .if apptime'=""  s apptime=$ZT(apptime,2)
	    .s attitude=$listget(a,7)
	    .s condestinat=$listget(a,8)
	    .s type=$listget(a,9)
	    .s consultdate=$listget(a,10)
	    .if consultdate'="" s consultdate=$$$ZD(consultdate,3)
	    .s condep=$listget(a,11)
	    .s condepID=condep
	    .if condep'=""  s condep=$P(^CTLOC(condep),"^",2)
	    .if $L(condep,"-")>1 s condep=$P(condep,"-",2)
	    .s condoc=$listget(a,12)
	    .if condoc'="" d
	    ..//s condoc=$P($G(^SSU("SSUSR",condoc)),"^",14)
	    ..s condoc=$p($G(^CTPCP(condoc,1)),"^",2)
	    .s contime=$listget(a,13)
	    .if contime'="" s contime=$ZT(contime,2)
	    .s InOut=$listget(a,14)
	    .i InOut="I" s InOut="院内"
	    .i InOut="O" s InOut="院外"
	    .s RelOrder=$listget(a,15)
	    .s status=$listget(a,16)
	    .q:status="C"
	    .q:(execflag=1)&(status'="E")
	    .q:(execflag=0)&(status="E")
	    .i status="V" s status="申请"
	    .i status="E" s status="执行"
	    .i status="C" s status="撤销"
	    .i status="W" s status="待审"
	    .i type="C" s typ="普通"
	    .if type="E" s typ="急"
	    .if type="M" s typ="多科"
	    .if type="A" s typ="抗菌药"
		.s RequestConDoc=$listget(a,20)
    	.i RequestConDoc'="" s RequestConDoc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
    	.e  s RequestConDoc=""
    	.s Specordid=$listget(a,24)
    	.b ;1
    	.s arcitmmastdesc=""
    	.i Specordid'="" d
    	..s OEORDRowId=$p(Specordid,"_")
    	..s OEORIChildsub=$p(Specordid,"_",2)
    	..s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
    	.i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    	
	    .//s ^tmpe245(1)=type_"^"_typ_"^"_patname_"^"_condepID
	    .i funname="" d
	    ..s ^mtemp($J,"ListConsult",id)=condep_"^"_condoc_"^"_status_"^"_$P($g(bedcode),"@",2)_"^"_appdep_"^"_InOut_"^"_$P($g(Diag),"@",2)_"^"_condestinat_"^"_$P($g(patname),"@",2)_"^"_apptime_"^"_appdate_"^"_consultdate_"^"_contime_"^"_Adm_"^"_id_"^"_typ_"^"_condepID_"^"_RequestConDoc_"^"_$P($g(RegNo),"@",2)_"^"_$P($g(Bah),"@",2)
	    .e  d
	    ..s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(condoc),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($G(InOut),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($G(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"','"_$ZCVT($g(condepID),"O","JS")_"','"_$ZCVT($g(RequestConDoc),"O","JS")_"','"_$ZCVT($P($g(RegNo),"@",2),"O","JS")_"','"_$ZCVT($P($g(Bah),"@",2),"O","JS")_"');"
	    ..&javascript<#(rtnval)#>
    }
    q
}

ClassMethod GetConsult(parr, funname) As %String
{

  	//w ##class(web.DHCConsult).GetConsult("57^2017-02-06^2017-02-08^false^9","addconsult")
  	s ^tmpscv1("GetConsult") = parr
  	s adm=$p(parr,"^",1)
  	s stdate=$p(parr,"^",2)
  	s edate=$p(parr,"^",3) 
  	s allflag=$p(parr,"^",4)
  	s logonLoc=$p(parr,"^",5)
  	s exeState=$p(parr,"^",6)
  	if allflag="true" {
	  	k tmp
	  	if adm'="" {
		  	
	  		s loc=$P($g(^PAADM(adm)),"^",4)
	  		q:(logonLoc'=loc) "不能查询非本科病人会诊"
	  	}
	  	else {
		  	if logonLoc="" q
		  	s logonLocType=$p(^CTLOC(logonLoc),"^",13)
		  	if logonLocType'="E" {
		    	s linkSub=0  f  s linkSub=$o(^CTLOC(logonLoc,"LINK",linkSub)) q:linkSub=""  d
    			.s loc=$G(^CTLOC(logonLoc,"LINK",linkSub))
			}
			else {
				s loc=logonLoc
			}
		}
	  	i $g(loc)="" q
		i stdate'="" s stdate=$$$ZDH(stdate,3)
		e  s stdate=+$h-2
		i edate'="" s edate=$$$ZDH(edate,3)
		e  s edate=+$h
		f date=stdate:1:edate
		{
			s id="" f  s id=$O(^User.DHCConsultationI("AppDep",date," "_loc,id)) q:id=""  d
			.s a=^User.DHCConsultationD(id)
			.s admId=$listget(a,2)
			.q:admId=""
			.s pavisit=$p($g(^PAADM(admId)),"^",20)
            .s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(admId)
 			.q:(pavisit="D")&(currentStatus'="B")
			.s bedId=$p($g(^PAADM(admId)),"^",73)
			.s WardId=$p(bedId,"||",1)
			.s bedSub=$p(bedId,"||",2)
			.q:(WardId="")!(bedSub="")
			.s bedCode=$p($g(^PAWARD(WardId,"BED",bedSub)),"^",1)
            .q:bedCode=""
            .s tmp(bedCode,id)=""
		}
		s curBedCode="" f  s curBedCode=$O(tmp(curBedCode)) q:curBedCode=""  d
		.s id="" f  s id=$O(tmp(curBedCode,id)) q:id=""  d
		..d OutputPatInfo(id)	
  	} 
  	else {
	  	s loc=$P($g(^PAADM(adm)),"^",4)
	  	q:(logonLoc'=loc) "不能查询非本科病人会诊"
	  	s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:id=""  d
	    .d OutputPatInfo(id)
	}
	q 0
OutputPatInfo(id)
	s a=^User.DHCConsultationD(id)
	s Adm=$listget(a,2)
	s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
	s Diag=$P(patinf,"^",9)
	S patname=$P(patinf,"^",5)
	s bedcode=$P(patinf,"^",6)
	s RegNo=$P(patinf,"^",1)
	s Bah=$P(patinf,"^",10)
	s EncryptLevel=$p(patinf,"^",25)
	s PatLevel=$p(patinf,"^",26)
	s appdate=$listget(a,3)
	if appdate'="" s appdate=$$$ZD(appdate,3)
	s appdep=$listget(a,4)
	if appdep'="" s appdep=$P(^CTLOC(appdep),"^",2)
	if $L(appdep,"-")>1 s appdep=$P(appdep,"-",2)
	s appdoc=$listget(a,5)
	if appdoc'="" s appdoc=$P(^SSU("SSUSR",appdoc),"^",14)
	s apptime=$listget(a,6)
	if apptime'=""  s apptime=$ZT(apptime,2)
	s attitude=$listget(a,7)
	s condestinat=$listget(a,8)
	s type=$listget(a,9)
	s consultdate=$listget(a,10)
	if consultdate'="" s consultdate=$$$ZD(consultdate,3)
	s condep=$listget(a,11)
	s condepID=condep
	if condep'=""  s condep=$P($G(^CTLOC(condep)),"^",2)
	if $L(condep,"-")>1 s condep=$P(condep,"-",2)
	s condoc=$listget(a,12)
	s condocID=condoc
	i condoc'="" s condoc=$p($g(^CTPCP(condoc,1)),"^",2)
	s contime=$listget(a,13)
	if contime'="" s contime=$ZT(contime,2)
	s InOut=$listget(a,14)
	i InOut="I" s InOut="院内"
	i InOut="O" s InOut="院外"
	s RelOrder=$listget(a,15)
	s status=$listget(a,16)	
	q:((exeState'="")&&(exeState'=status))
	i status="V" s status="申请"
	i status="E" s status="执行"
	i status="C" s status="撤销"
	i status="W" s status="待审"
	i type="C" s typ="普通"
	if type="E" s typ="急"
	if type="M" s typ="多科"
	if type="A" s typ="抗菌药"
	s RequestConDoc=$listget(a,20)
	s condocID=RequestConDoc
	i condocID'="" s condocID=$o(^SSU("SSUSR",0,"CTPCP",condocID,""))
	i RequestConDoc'="" s RequestConDoc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
	e  s RequestConDoc=""	
	s Specordid=$listget(a,24)
    	s arcitmmastdesc=""
    	i Specordid'="" d
    	.s OEORDRowId=$p(Specordid,"_")
    	.s OEORIChildsub=$p(Specordid,"_",2)
    	.s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
    	i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    i funname="" d
    .s ^mtemp($J,"Consult",id)=condep_"^"_condoc_"^"_status_"^"_$P($g(bedcode),"@",2)_"^"_appdep_"^"_InOut_"^"_$P($g(Diag),"@",2)_"^"_condestinat_"^"_$P($g(patname),"@",2)_"^"_apptime_"^"_appdate_"^"_consultdate_"^"_contime_"^"_Adm_"^"_id_"^"_typ_"^"_RequestConDoc_"^"_$P($g(RegNo),"@",2)_"^"_$P($g(Bah),"@",2)
    e  d
    .s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(condoc),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($G(InOut),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($G(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"','"_$ZCVT($g(RequestConDoc),"O","JS")_"','"_$ZCVT($P($g(RegNo),"@",2),"O","JS")_"','"_$ZCVT($P($g(Bah),"@",2),"O","JS")_"','"_$ZCVT($P($g(EncryptLevel),"@",2),"O","JS")_"','"_$ZCVT($P($g(PatLevel),"@",2),"O","JS")_"','"_$ZCVT($g(condocID),"O","JS")_"','"_$ZCVT($g(condepID),"O","JS")_"');"		
	.&javascript<#(rtnval)#>
}

ClassMethod getSingleConsult(id) As %String
{
    //w ##class(web.DHCConsult).getSingleConsult(67)
    s a=^User.DHCConsultationD(id)
    s Adm=$listget(a,2)
    s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
    s Diag=$P(patinf,"^",9)
    S patname=$P(patinf,"^",5)
    s bedcode=$P(patinf,"^",6)
    s bah=$P(patinf,"^",10)
    s appdate=$listget(a,3)
    if appdate'="" s appdate=$$$ZD(appdate,3)
    s appdep=$listget(a,4)
    if appdep'="" s appdep=$P($G(^CTLOC(appdep)),"^",2)
    s appdoc=$listget(a,5)
    if appdoc'="" s appdoc=$P(^SSU("SSUSR",appdoc),"^",2)
    e  s appdoc=""
    s apptime=$listget(a,6)
    if apptime'=""  s apptime=$ZT(apptime,2)
    s attitude=$listget(a,7)
    s attitude=..Replace(attitude,""_$C(13,10)_"","@")
    s condestinat=$listget(a,8)
    s type=$listget(a,9)
    s consultdate=$listget(a,10)
    if consultdate'="" s consultdate=$$$ZD(consultdate,3)
    s condep=$listget(a,11)
    //if condep'=""  s condep=$P(^CTLOC(condep),"^",2)
    s condoc=$listget(a,12)
    //if condoc'="" s condoc=$P($G(^SSU("SSUSR",condoc)),"^",14)
    s contime=$listget(a,13)
    if contime'="" s contime=$ZT(contime,2)
    s InOut=$listget(a,14)
    s RelOrder=$listget(a,15)
    s status=$listget(a,16)
    s RequestConDoc=$listget(a,20)
    s DocGrade=$listget(a,21)
    s Specordid=$listget(a,24)
     s attitudetsy=$listget(a,25)
    	s arcitmmastdesc=""
    	i Specordid'="" d
    	.s OEORDRowId=$p(Specordid,"_")
    	.s OEORIChildsub=$p(Specordid,"_",2)
    	.s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
    	i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    	//i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    ;i type="C" s typ="一般"
	;if type="E" s typ="急"
	s:condoc'="" condocName=$p($g(^CTPCP(condoc,1)),"^",2)
    s ret=appdate_"^"_apptime_"^"_attitude_"^"_condestinat_"^"_type_"^"_condep_"^"_condoc_"^"_InOut_"^"_appdoc_"^"_consultdate_"^"_contime_"^"_RequestConDoc_"^"_DocGrade_"^"_arcitmmastdesc_"^"_attitudetsy_"^"_bah_"^"_$g(condocName)
    q ret
}

ClassMethod getSingleConsultApply(id) As %String
{
    //w ##class(web.DHCConsult).getSingleConsult(67)
    s a=^User.DHCConSultationNewD(id)
    s Adm=$listget(a,2)
    s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
    s Diag=$P(patinf,"^",14)
    S patname=$P(patinf,"^",5)
    s bedcode=$P(patinf,"^",6)
    s bah=$P(patinf,"^",10)
    s appdate=$listget(a,3)
    if appdate'="" s appdate=$$$ZD(appdate,3)
    s appdep=$listget(a,5)
    if appdep'="" s appdep=$P($G(^CTLOC(appdep)),"^",2)
    s appdoc=$listget(a,6)
    if appdoc'="" s appdoc=$P($g(^SSU("SSUSR",appdoc)),"^",2)
    e  s appdoc=""
    s apptime=$listget(a,4)
    if apptime'=""  s apptime=$ZT(apptime,2)
    s attitude=$listget(a,9)
    s attitude="" ;..Replace(attitude,""_$C(13,10)_"","@")
    s condestinat=$listget(a,9)
    s type=$listget(a,7)
    s consultdate=$listget(a,10)
    if consultdate'="" s consultdate=$$$ZD(consultdate,3)
    s condep="" ;$listget(a,11)
    //s subid="" f  s subid=$O(^User.DHCConsultationI("AppDep",date," "_loc,id)) q:id=""  d
    s subid="" f  s subid =$O(^User.DHCConSultationNewSubI("ConsultDep",id,subid)) q:subid=""  d
    .s condep=condep_" "_$P(^CTLOC($tr(subid," ")),"^",2)
    s condoc="" ;$listget(a,12)
    //if condoc'="" s condoc=$P($G(^SSU("SSUSR",condoc)),"^",14)
    s contime="" ;$listget(a,19)
    if contime'="" s contime=$ZT(contime,2)
    s InOut=$listget(a,8)
    s RelOrder="" ;$listget(a,15)
    s status=$listget(a,10)
    s RequestConDoc="" ;$listget(a,20)
    s DocGrade="" ;$listget(a,21)
    s Specordid= "" ;$listget(a,24)
     s attitudetsy=$listget(a,13)
    	s arcitmmastdesc=""
    	i Specordid'="" d
    	.s OEORDRowId=$p(Specordid,"_")
    	.s OEORIChildsub=$p(Specordid,"_",2)
    	.s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
    	i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    	//i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    ;i type="C" s typ="一般"
	;if type="E" s typ="急"
    s ret=appdate_"^"_apptime_"^"_attitude_"^"_condestinat_"^"_type_"^"_condep_"^"_condoc_"^"_InOut_"^"_appdoc_"^"_consultdate_"^"_contime_"^"_RequestConDoc_"^"_DocGrade_"^"_arcitmmastdesc_"^"_attitudetsy_"^"_bah
    q ret
}

ClassMethod getConsultInfo(id) As %String
{
 //w##class(web.DHCConsult).getConsultInfo("166")
    s a=^User.DHCConsultationD(id)
    s obj=##class(User.DHCConsultation).%OpenId(id)
    s Adm=$listget(a,2)
    s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
    s Diag=$P(patinf,"^",9)
    S patname=$P(patinf,"^",5)
    s bedcode=$P(patinf,"^",6)
    s RegNo=$P(patinf,"^",1)
    s medcareno=$P(patinf,"^",10)
    s PatWard=$P(patinf,"^",8)
    s appdate=$listget(a,3)
    if appdate'="" s appdate=$$$ZD(appdate,3)
    s appdep=$listget(a,4)
    s hospital=""
    if appdep'="" d
    .s hospital=..gethospital(appdep)
    .s appdepDes=$P(^CTLOC(appdep),"^",2)
    .i $L(appdepDes,"-")>1 s appdepDes=$P(appdepDes,"-",2)
    e  s appdepDes=""
    s appdoc=$listget(a,5)
    if appdoc'="" s appdocDes=$P($g(^SSU("SSUSR",appdoc)),"^",2)
    s apptime=$listget(a,6)
    if apptime'=""  s apptime=$ZT(apptime,2)
    s attitude=$listget(a,7)
    s condestinat=$listget(a,8)
    s type=$listget(a,9)
    s consultdate=$listget(a,10)
    if consultdate'="" s consultdate=$$$ZD(consultdate,3)
    s condep=$listget(a,11)
    if condep'=""  d
    .s condepDes=$P(^CTLOC(condep),"^",2)
    .i $L(condepDes,"-")>1 s condepDes=$P(condepDes,"-",2)
    e  s condepDes=""
    s condoc=$listget(a,12)
    if condoc'="" s condocDes=$p($g(^CTPCP(condoc,1)),"^",2)
    //if condoc'="" s condocDes=$P(^SSU("SSUSR",condoc),"^",14)
    s contime=$listget(a,13)
    if contime'="" s contime=$ZT(contime,2)
    s InOut=$listget(a,14)
    s RelOrder=$listget(a,15)
    s status=$listget(a,16)
    s RequestConDoc=$listget(a,20)
    if RequestConDoc'="" s RequestConDocDesc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
    e  s RequestConDocDesc=""
    s contype=obj.ConType
    s re1="InOut&"_hospital_"^ConType&"_contype_"^PatName&"_$P(patname,"@",2)_"^BedCode&"_$P(bedcode,"@",2)_"^PatDep&"_$G(appdepDes)_"^PatRegNo&"_$P(RegNo,"@",2)_"^PatId&"_$P(medcareno,"@",2)_"^PatDoc&"_$G(appdocDes)_"^Diag&"_$P(Diag,"@",2)_"^PatWard&"_$P(PatWard,"@",2)
    s ret=re1_"^AppDate&"_appdate_"^AppTime&"_apptime_"^Attitude&"_attitude_"^ConDestination&"_condestinat_"^type&"_type_"^ConsultDep&"_condep_"|"_$G(condepDes)_"^ConsultDoc&"_condoc_"|"_$G(condocDes)_"^RequestConDoc&"_RequestConDoc_"|"_$G(RequestConDocDesc)_"^ConsultDate&"_consultdate_"^ConsultTime&"_contime
    q ret  //    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo
}

ClassMethod getConsultInfoApply(id) As %String
{
 //w##class(web.DHCConsult)getConsultInfoApply("70") 
 	;s ^scv1("consultid")=id
    s a=^User.DHCConSultationNewD(id)
    s obj=##class(User.DHCConSultationNew).%OpenId(id)
    s Adm=$listget(a,2)
    s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
    s Diag=$P(patinf,"^",9)
    S patname=$P(patinf,"^",5)
    s bedcode=$P(patinf,"^",6)
    s RegNo=$P(patinf,"^",1)
    s medcareno=$P(patinf,"^",10)
    s PatWard=$P(patinf,"^",8)
    s appdate=$listget(a,3)
    if appdate'="" s appdate=$$$ZD(appdate,3)
    s appdep=$listget(a,5)
    s hospital=""
    if appdep'="" d
    .s hospital=..gethospital(appdep)
    .s appdepDes=$P(^CTLOC(appdep),"^",2)
    .i $L(appdepDes,"-")>1 s appdepDes=$P(appdepDes,"-",2)
    e  s appdepDes=""
    s appdoc=$listget(a,6)
    if appdoc'="" s appdocDes=$P(^SSU("SSUSR",appdoc),"^",2)
    s apptime=$listget(a,4)
    if apptime'=""  s apptime=$ZT(apptime,2)
    s attitude=$listget(a,9)
    s attitude="" ;..Replace(attitude,""_$C(13,10)_"","@")
    s condestinat=$listget(a,9)
    s type=$listget(a,7)
    s consultdate=$listget(a,10)
    if consultdate'="" s consultdate=$$$ZD(consultdate,3)
    s condep="" ;$listget(a,11)
    //s subid="" f  s subid=$O(^User.DHCConsultationI("AppDep",date," "_loc,id)) q:id=""  d
    s subid="" f  s subid =$O(^User.DHCConSultationNewSubI("ConsultDep",id,subid)) q:subid=""  d
    .s condep=condep_" "_$P(^CTLOC($tr(subid," ")),"^",2)
    s condoc="" ;$listget(a,12)
    //if condoc'="" s condoc=$P($G(^SSU("SSUSR",condoc)),"^",14)
    s contime="" ;$listget(a,19)
    if contime'="" s contime=$ZT(contime,2)
    s InOut=$listget(a,8)
    s RelOrder="" ;$listget(a,15)
    s status=$listget(a,10)
    s RequestConDoc="" ;$listget(a,20)
    if RequestConDoc'="" s RequestConDocDesc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
    e  s RequestConDocDesc=""
    s contype=obj.ConType
    s re1="InOut&"_hospital_"^ConType&"_contype_"^PatName&"_$P(patname,"@",2)_"^BedCode&"_$P(bedcode,"@",2)_"^PatDep&"_$G(appdepDes)_"^PatRegNo&"_$P(RegNo,"@",2)_"^PatId&"_$P(medcareno,"@",2)_"^PatDoc&"_$G(appdocDes)_"^Diag&"_$P(Diag,"@",2)_"^PatWard&"_$P(PatWard,"@",2)
    s ret=re1_"^AppDate&"_appdate_"^AppTime&"_apptime_"^Attitude&"_attitude_"^ConDestination&"_condestinat_"^type&"_type_"^ConsultDep&"_condep_"|"_$G(condepDes)_"^ConsultDoc&"_condoc_"|"_$G(condocDes)_"^RequestConDoc&"_RequestConDoc_"|"_$G(RequestConDocDesc)_"^ConsultDate&"_consultdate_"^ConsultTime&"_contime
    q ret  //    s retStr="REGNO@"_regNo_"^LOC@"_ctlocDesc_"^ROOM@"_$g(room)_"^SEX@"_$g(sex)_"^PATNAME@"_$g(patName)_"^BEDCODE@"_$g(bedCode)_"^AGE@"_$g(age)_"岁^WARD@"_$g(wardDesc)_"^DIAG@"_diag_"^MedCareNo@"_MedCareNo
}

/// 会诊申请时会插一条医嘱费用
/// 只有一条会诊费用时s arcimId=$g(^DHCCLSet("Consult","ConsultArcimId"))
/// 	安徽省立南区2010-12-09
/// 	院内-主任费	^DHCCLSet("Consult","I","D")
/// 	院内-普通费	^DHCCLSet("Consult","I","C")
/// 	总院-主任费	^DHCCLSet("Consult","O","D")
/// 	总院-普通费	^DHCCLSet("Consult","O","C")
/// 积水潭2011-04-13
/// 	特需病房	^DHCCLSet("Consult","AppLocId",科室ID,"D")=主任医师医嘱项ID
/// 				^DHCCLSet("Consult","AppLocId",科室ID,"A")=副主任医师医嘱项ID
/// 				^DHCCLSet("Consult","AppLocId",科室ID,"C")=普通医师医嘱项ID				
ClassMethod InsertConsultOrder(userId, appDepId, EpisodeID, ConDepID, ConAppID, InOut, DocGrade, Type) As %String
{
	 ;s ^tmeo123as(1)=userId_"^"_EpisodeID_"^"_ConDepID_"^"_ConAppID_"^"_InOut_"^"_DocGrade
	 TSTART
	 ;i InOut'="",DocGrade'="" s arcimId=$g(^DHCCLSet("Consult",InOut,DocGrade))
	 ;e  s arcimId=""
	 s arcimId=""
	 i InOut'="",DocGrade'="",ConDepID'="" d //取根据科室配置的医嘱
	 .s depitmid=$O(^User.DHCConsultDepItmI("Consult"," "_InOut," "_DocGrade," "_ConDepID," "_Type,""))
	 .i depitmid'="" d
	 ..s depitmobj=##class(User.DHCConsultDepItm).%OpenId(depitmid)
	 ..s arcimId=depitmobj.ConsultItmDr
	 .i arcimId=""  d  //科室没有配置医嘱，看看是否配置了全院通用会诊医嘱
	 ..s depitmid2=$O(^User.DHCConsultDepItmI("Consult"," "_InOut," "_DocGrade," ALL"," "_Type,""))
	 ..i depitmid2'="" d
	 ...s depitmobj=##class(User.DHCConsultDepItm).%OpenId(depitmid2)
	 ...s arcimId=depitmobj.ConsultItmDr
	 i arcimId="" d  //科室及全院都没配置医嘱，取默认会诊医嘱
	 .s depitmid=$O(^User.DHCConsultDepItmI("Dep"," DF"," "_Type,""))
	 .i depitmid'="" d
	 ..s depitmobj=##class(User.DHCConsultDepItm).%OpenId(depitmid)
	 ..s arcimId=depitmobj.ConsultItmDr
	 //i arcimId="" s arcimId=$g(^DHCCLSet("Consult","ConsultArcimId"))
	 s retInsord=0
	 i (arcimId="")  {
		 TRollBack 1  
		 q "没有医嘱项目ID(arcimId)，插入会诊医嘱错误!"
	 }
	 i (userId=""){
		   TRollBack 1
		   q "没有用户ID(userId)，插入会诊医嘱错误!"
	 }
     i (EpisodeID=""){
	       TRollBack 1  
	       q "没有EpisodeID，插入会诊医嘱错误！"
     }
     s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
     i oeordId="" d
     .s curDate=+$h,curTime=$p($h,",",2)
     .&sql(insert into sqluser.OE_Order(OEORD_Adm_DR,OEORD_Date,OEORD_Time) values(:EpisodeID,:curDate,:curTime))
     .i 'SQLCODE s oeordId=$g(%ROWID)
     i oeordId="" TRollBack  q "没有oeordId插入会诊医嘱错误!"
     s userDeptId=$p(^PAADM(EpisodeID),"^",4)
     i userDeptId'="",$D(^DHCCLSet("Consult","AppLocId",userDeptId))'=0 d
	 .i DocGrade'="" s arcimId=$g(^DHCCLSet("Consult","AppLocId",userDeptId,DocGrade))
     s anaId=""      ;OEORI_Anaest_DR        OR_Anaesthesia
     s Ret3=""       ;OEORI_AnaOper_DR       OR_Anaest_Operation
     s billDesc=""   ;OEORI_BillDesc
     i ConDepID'="" s ConDep=$P($G(^CTLOC(ConDepID)),"^",2)
     e  s ConDep=""
     i $L(ConDep,"-")>1 s ConDep=$P(ConDep,"-",2)
     s oeoriDepProcNotes="请"_ConDep_"会诊"    ;s PLIST(53)=notes //OEORI_DepProcNotes
     s retInsord=##class(web.DHCConsultOrder).InsertOrdItemNew(userId, oeordId, arcimId,3,1, appDepId, anaId, Ret3, "",oeoriDepProcNotes,ConDepID,"Y")
     ;i +retInsord'=0 TRollBack  q "插入会诊医嘱错误!"
     i +retInsord=100 TRollBack  q "插入会诊医嘱错误!"
     s ConOrdId=$P(retInsord,"*",2)
     i ConOrdId'="" d
     .i $g(ConAppID)'="" d
     ..i Type="E" D
     ...&sql(update sqluser.DHC_Consultation set ExcuteOrder=:ConOrdId where ID=:ConAppID) 
     ..i Type="A" D
     ...&sql(update sqluser.DHC_Consultation set RelOrder=:ConOrdId where ID=:ConAppID) 
    TCOMMIT
    q 0
}

ClassMethod GetPerson(ids As %String) As %String
{
 //s a=##class(web.DHCConsult).GetPerson()
     q:"" ""
     s ids=$ZConvert(ids,"U")

	 s id=ids
	 s ln=$L(ids)
	 s im=ids
	 s flag=0
	 s ret=""
	 b
	 s rw="" s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",id,rw))
	 if rw'=""  d sa
	 f  s id=$O(^SSU("SSUSR",0,"SSUSR_Initials",id)) q:(id="")!(flag=1)  d
	 .w !,id
	 .if $E(id,0,ln)'=im s flag=1
	 .s rw=""  f  s rw=$O(^SSU("SSUSR",0,"SSUSR_Initials",id,rw)) q:rw=""!(flag=1)  d
     ..d sa
     ..
   q ret
sa
 	 s parr= ^SSU("SSUSR",rw)
     s name=$P(^SSU("SSUSR",rw),"^",2)
     s ret=ret_rw_"|"_name_"^"
    q
}

ClassMethod GetDoc(dep, docgrade = "") As %String
{
  //s a=##class(web.DHCConsult).GetDoc()
	s ret=""
	q:dep="" ret
	if $g(dep)'=""
	{
		s resId="" f  s resId=$O(^RB("RES",0,"CTLOC",dep,resId))  q:resId=""  d
			   .s ctcpId=$P(^RB("RES",resId),"^",2)
			   .q:ctcpId=""
			   .s ctcptId=$p($g(^CTPCP(ctcpId,1)),"^",4)
			   .q:((docgrade)&&(ctcptId'=docgrade))
			   .q:ctcptId=""
			   .//s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
			   .//q:(ifDoctor'="")&(ifDoctor="Y")&(ctcptType'="DOCTOR")
		       .//q:(ifDoctor'="")&(ifDoctor'="Y")&(ctcptType'="NURSE")
			   .s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
			   .s ret=ret_ctcpId_"|"_ctcpDesc_"^"
			   .;b
	}
	else
	{
		s ctcpId="" f  s ctcpId=$O(^CTPCP(ctcpId))  q:ctcpId=""  d
		.s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
		.q:ctcptId=""
    	.s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
		.q:ctcptInternalType'="DOCTOR"
		.s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
		.s ret=ret_ctcpId_"|"_ctcpDesc_"^"
	}
   	q ret
}

/// 	会诊统计查询与打印共用程序
/// 	积水潭,提成方法：
/// 	普通科室 主任医师、副主任医师 每例5元 普通医师 每例3元
/// 		特需病房 主任医师 每例50元 副主任医师 每例30元 普通医师 每例 20元
/// 	2010-12-15
ClassMethod GetConsultStatComm(StDate, EDate, InOut, ConLoc, ConsultStat)
{
    //d ##class(web.DHCConsult).GetConsultStatComm("2010-11-01","2011-12-31","","")
    //定义收费标准
    s ConsultPrice(0,"D")=5,ConsultPrice(0,"A")=5,ConsultPrice(0,"C")=3
    s apploc="" f  s apploc=$O(^DHCCLSet("Consult","AppLocId",apploc)) q:apploc=""  d
    .s ConsultPrice(apploc,"D")=50,ConsultPrice(apploc,"A")=50,ConsultPrice(apploc,"C")=20
    
    s StDate=$$$ZDH(StDate,3),EDate=$$$ZDH(EDate,3)
    s AllConNum=0,AllConMoney=0
    k ConsultStat,AllConNum,AllConMoney
    f CurDate=StDate:1:EDate
    {
    	s CurConLoc="" f  s CurConLoc=$O(^User.DHCConsultationI("ConSultDep",CurDate,CurConLoc)) q:CurConLoc=""  d
    	.s ConLocId=$TR(CurConLoc," ","")
    	.q:(ConLoc'="")&(ConLoc'=ConLocId)
    	.s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",CurDate,CurConLoc,id)) q:id=""  d
	    ..s a=^User.DHCConsultationD(id)
		..s status=$listget(a,16)
	    ..q:status'="E"
	    ..s CurInOut=$listget(a,14)
	    ..q:CurInOut=""
	    ..q:(InOut'="")&(InOut'=CurInOut)
		..s DocGrade=$listget(a,21)
		..q:DocGrade=""
	    ..s RelOrder=$listget(a,15)
	    ..;q:RelOrder=""
	    ..s appdep=$listget(a,4)
	    ..q:appdep=""
    	..s ConsultDoc=$listget(a,12)
    	..q:ConsultDoc=""
    	..s ConPrice=$G(ConsultPrice(0,DocGrade))
    	..i $D(ConsultPrice(appdep,DocGrade)) s ConPrice=$G(ConsultPrice(appdep,DocGrade))
    	..;s DocGrade=$S(DocGrade="D":1,DocGrade="A":2,DocGrade="C":3,1:0)
    	..s AllConNum(ConLocId,DocGrade,ConsultDoc)=+$G(AllConNum(ConLocId,DocGrade,ConsultDoc))+1
    	..s AllConMoney(ConLocId,DocGrade,ConsultDoc)=+$G(AllConMoney(ConLocId,DocGrade,ConsultDoc))+ConPrice
    	..s ConsultStat(ConLocId,DocGrade,ConsultDoc)=+$G(AllConNum(ConLocId,DocGrade,ConsultDoc))_"^"_+$G(AllConMoney(ConLocId,DocGrade,ConsultDoc))
    }
	q
}

/// 	会诊统计
/// 	2010-12-15
/// 	按会诊科室与医师级别统计,显示"专家","主治","小计"
ClassMethod GetConsultStat(StDate, EDate, InOut, ConLoc, funname)
{
    //w ##class(web.DHCConsult).GetConsultStat("2010-11-01","2010-12-31","","","add")
    d ..GetConsultStatComm(StDate, EDate, InOut, ConLoc, .ConsultStat)
    //s preConLoc=""
    s CurConLoc="" f  s CurConLoc=$O(ConsultStat(CurConLoc)) q:CurConLoc=""  d
    .//s preDocGrade=""
    .s CurDocGrade="" f  s CurDocGrade=$O(ConsultStat(CurConLoc,CurDocGrade)) q:CurDocGrade=""  d
    ..s CurConDoc="" f  s CurConDoc=$O(ConsultStat(CurConLoc,CurDocGrade,CurConDoc)) q:CurConDoc=""  d
    ...i CurConLoc'="" s ConDep=$P(^CTLOC(CurConLoc),"^",2)
    ...e  s ConDep=""
    ...i $L(ConDep,"-")>1 s ConDep=$P(ConDep,"-",2)
    ...s DocGrade=$P($g(^CT("CPT",CurDocGrade)),"^",2) ;$S(CurDocGrade=1:"主任医师",CurDocGrade=2:"副主任医师",CurDocGrade=3:"普通医师",1:"")
    ...//i preConLoc=CurConLoc,preDocGrade=CurDocGrade s ConDep="",DocGrade=""
    ...s ConsultDoc=$p($g(^CTPCP(CurConDoc,1)),"^",2)
    ...s ConNum=$P($G(ConsultStat(CurConLoc,CurDocGrade,CurConDoc)),"^",1)
    ...s ConMoney=$P($G(ConsultStat(CurConLoc,CurDocGrade,CurConDoc)),"^",2)
	...//i preConLoc'=CurConLoc s preConLoc=CurConLoc
    ...//i preDocGrade'=CurDocGrade s preDocGrade=CurDocGrade
	...s rtnval=funname_"('"_$ZCVT($g(ConDep),"O","JS")_"','"_$ZCVT($g(DocGrade),"O","JS")_"','"_$ZCVT($g(ConsultDoc),"O","JS")_"','"_$ZCVT($g(ConNum),"O","JS")_"','"_$ZCVT($g(ConMoney),"O","JS")_"');"
	...&javascript<#(rtnval)#>
	q 0
}

/// 会诊统计打印
/// 2010-12-16
ClassMethod GetConsultStatPrnExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	//s parr="2010-11-01!2011-12-31!!"
 	//d ##class(%ResultSet).RunQuery("web.DHCConsult","GetConsultStatPrn","2010-11-01!2011-12-31!!")
	s StDate=$P(parr,"!",1)
	s EDate=$P(parr,"!",2)
	s InOut=$P(parr,"!",3)
	s ConLoc=$P(parr,"!",4)
	d ..GetConsultStatComm(StDate, EDate, InOut, ConLoc, .ConsultStat)
    //s preConLoc=""
    s CurConLoc="" f  s CurConLoc=$O(ConsultStat(CurConLoc)) q:CurConLoc=""  d
    .//s preDocGrade=""
    .s CurDocGrade="" f  s CurDocGrade=$O(ConsultStat(CurConLoc,CurDocGrade)) q:CurDocGrade=""  d
    ..s CurConDoc="" f  s CurConDoc=$O(ConsultStat(CurConLoc,CurDocGrade,CurConDoc)) q:CurConDoc=""  d
    ...i CurConLoc'="" s ConDep=$P(^CTLOC(CurConLoc),"^",2)
    ...e  s ConDep=""
    ...i $L(ConDep,"-")>1 s ConDep=$P(ConDep,"-",2)
    ...s DocGrade=$P($g(^CT("CPT",CurDocGrade)),"^",2)
    ...;s DocGrade=$S(CurDocGrade=1:"主任医师",CurDocGrade=2:"副主任医师",CurDocGrade=3:"普通医师",1:"")
    ...//i preConLoc=CurConLoc,preDocGrade=CurDocGrade s ConDep="",DocGrade=""
    ...s ConsultDoc=$p($g(^CTPCP(CurConDoc,1)),"^",2)
    ...s ConNum=$P($G(ConsultStat(CurConLoc,CurDocGrade,CurConDoc)),"^",1)
    ...s ConMoney=$P($G(ConsultStat(CurConLoc,CurDocGrade,CurConDoc)),"^",2)
    ...//i preConLoc'=CurConLoc s preConLoc=CurConLoc
    ...//i preDocGrade'=CurDocGrade s preDocGrade=CurDocGrade
    ...d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

 
OutRowtyp
	set Data=$lb(ConDep,DocGrade,ConsultDoc,ConNum,ConMoney)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsultStatPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultStatPrnExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetConsultStatPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultStatPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetConsultStatPrn(parr As %String) As %Query(ROWSPEC = "ConDep,DocGrade,ConsultDoc,ConNum,ConMoney")
{
}

/// 会诊科室打印会诊列表(积水潭)
/// 2011-03-11
ClassMethod GetListConsultPrnExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	;s ^sctmpv1("GetConsultStatPrn") = parr
	Set repid=$I(^CacheTemp)
 	s ind=1
 	;s ^objcyf1112=parr
 	//d ##class(%ResultSet).RunQuery("web.DHCConsult","GetListConsultPrn",^objcyf1112)
    s execflag=""
    s stdate=$P(parr,"!",1)
    s edate=$P(parr,"!",2)
    s loc=$P(parr,"!",3)
    s execflag=$P(parr,"!",4)
    s userId = $P(parr,"!",5)
    ;i execflag="true" s execflag=1
    ;e  s execflag=0
    k ^mtemp($J,"ListConsult")
    d ..GetListConsult(stdate, edate, loc, "","","",execflag,"",userId)
    
	s id="" f  s id=$O(^mtemp($J,"ListConsult",id)) q:id=""  d
    .s a=$G(^mtemp($J,"ListConsult",id))
	.s ConDep=$P(a,"^",1)
	.s ConDoc=$P(a,"^",2)
	.s Status=$P(a,"^",3)
	.s BedCode=$P(a,"^",4)
	.s PatDep=$P(a,"^",5)
	.s InOut=$P(a,"^",6)
	.s Diag=$P(a,"^",7)
	.s Destination=$P(a,"^",8)
	.s PatName=$P(a,"^",9)
	.s AppTime=$P(a,"^",10)
	.s AppDate=$P(a,"^",11)
	.s ConDate=$P(a,"^",12)
	.s ConTime=$P(a,"^",13)
	.//s EpisodeId=$P(a,"^",14)
	.//s RowID=$P(a,"^",15)
	.s Contyp=$P(a,"^",16)
	.//s ConDepID=$P(a,"^",17)
	.s RequestConDoc=$P(a,"^",18)
	.s RegNo=$P(a,"^",19)
	.s Bah=$P(a,"^",20)
    .d OutRowtyp   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ConDep,ConDoc,Status,BedCode,PatDep,InOut,Diag,Destination,PatName,AppTime,AppDate,ConDate,ConTime,Contyp,RequestConDoc,RegNo,Bah)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListConsultPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListConsultPrnExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListConsultPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListConsultPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetListConsultPrn(parr As %String) As %Query(ROWSPEC = "ConDep,ConDoc,Status,BedCode,PatDep,InOut,Diag,Destination,PatName,AppTime,AppDate,ConDate,ConTime,Contyp,RequestConDoc,RegNo,Bah")
{
}

/// 会诊科室提示当天有几条会诊申请
/// 2011-04-13
ClassMethod GetConsultNum(loc)
{
    //w ##class(web.DHCConsult).GetConsultNum(210) 
    q:loc="" ""
    s num=0
    s stdate=+$h,edate=+$h
    f date=stdate:1:edate
    {
    	s id="" f  s id=$O(^User.DHCConsultationI("ConSultDep",date," "_loc,id)) q:id=""  d
	    .s a=^User.DHCConsultationD(id)
	    .s status=$listget(a,16)
	    .q:status'="V"	//V:申请 E:执行 C:撤销
	    .s num=num+1
    }
    if num'=0 q "本科室今日有"_num_"条会诊申请!"
    q ""
}

/// 整串转换指定的字符串
/// w ##class(web.DHCNUREMR).Replace("abcdefghijklmn&KeyEnter;opqrstuvwxyz","&KeyEnter;","\n")
ClassMethod Replace(Strings, Str, Rep) As %String [ Language = basic ]
{
	return Replace(Strings,Str,Rep)
}

/// 申请科室打印会诊列表(积水潭)
/// 2011-05-27
ClassMethod GetConsultPrnExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//d ##class(%ResultSet).RunQuery("web.DHCConsult","GetConsultPrn","30!2013-03-14!2013-03-16!false!9")
 	//d ##class(%ResultSet).RunQuery("web.DHCConsult","GetConsultPrn","2015-02-22!2017-02-23!9!false")
    s ^obccc=parr
    s adm=$P(parr,"!",1)
    s stdate=$P(parr,"!",2)
    s edate=$P(parr,"!",3)
    s allflag=$P(parr,"!",4)
    s logonLoc=$P(parr,"!",5)
    k ^mtemp($J,"Consult")
    s aa=..GetConsultApply(adm_"^"_stdate_"^"_edate_"^"_allflag_"^"_logonLoc,"") ;..GetConsult(adm_"^"_stdate_"^"_edate_"^"_allflag_"^"_logonLoc,"")
	s id="" f  s id=$O(^mtemp($J,"Consult",id)) q:id=""  d
    .s a=$G(^mtemp($J,"Consult",id))
	.s ConDep=$P(a,"^",1)
	.s ConDoc=$P(a,"^",2)
	.s Status=$P(a,"^",3)
	.s BedCode=$P(a,"^",4)
	.s PatDep=$P(a,"^",5)
	.s InOut=$P(a,"^",6)
	.s Diag=$P(a,"^",7)
	.s Destination=$P(a,"^",8)
	.s PatName=$P(a,"^",9)
	.s AppTime=$P(a,"^",10)
	.s AppDate=$P(a,"^",11)
	.s ConDate=$P(a,"^",12)
	.s ConTime=$P(a,"^",13)
	.//s EpisodeId=$P(a,"^",14)
	.//s RowID=$P(a,"^",15)
	.s Contyp=$P(a,"^",16)
	.s RequestConDoc=$P(a,"^",17)
	.s RegNo=$P(a,"^",18)
	.s Bah=$P(a,"^",19)
    .d OutRowtyp   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(ConDep,ConDoc,Status,BedCode,PatDep,InOut,Diag,Destination,PatName,AppTime,AppDate,ConDate,ConTime,Contyp,RequestConDoc,RegNo,Bah)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsultPrnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultPrnExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetConsultPrnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultPrnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetConsultPrn(parr1 As %String) As %Query(ROWSPEC = "ConDep,ConDoc,Status,BedCode,PatDep,InOut,Diag,Destination,PatName,AppTime,AppDate,ConDate,ConTime,Contyp,RequestConDoc,RegNo,Bah")
{
}

// parr:ConsultDep|____^AppDate|___^........^Status|V^

// ConsultDep 会诊科室

// AppDate    申请日期

// AppTime    申请时间

// ConType    类别：一般|C 急|E

// InOut      院内(I)|院外(O)

// ConDestination  会诊理由

// EpisdeID        病人Adm

// Specordid       医嘱id  140_62

// RequestConDoc   要求会诊医生

// DocGrade        医生级别:主任医师--D

//                         副主任医师--A

//                         普通医师--C

// AppDep      申请科室

// AppDoc      申请医生

// Status      申请状态(V)

// d ##class(web.DHCConsult).savetskjy("ConsultDep|13^AppDate|2012-07-31^AppTime|10:35^ConType|C^InOut|I^ConDestination|哈111哈哈^EpisdeID|149^Status|V^AppDep|13^AppDoc|3473^id|^RequestConDoc|348^DocGrade|D^Specordid|140_62")

ClassMethod savetskjy(parr) As %String
{
	s l=$L(parr,"^")
	for i=1:1:l
	{
		s itm=$P(parr,"^",i)
		if itm="" continue
		s name=$P(itm,"|")
		s val=$P(itm,"|",2)
		s tmp(name)=val
	}
	b ;3
	i (tmp("ConsultDep")="") q "请选择会诊科室"
	i (tmp("InOut")="") q "请选择院内院外"
	i (tmp("DocGrade")="") q "请选择医师级别"
	i (tmp("ConType")="") q "请选择类别"
	i (tmp("AppDate")="") q "请选择会诊日期"
    i (tmp("AppTime")="") q "请选择会诊时间"
    i (tmp("EpisdeID")="") q "患者Adm不能为空"
    i (tmp("AppDep")="") q "请选择申请科室"
    i (tmp("AppDoc")="") q "申请医生不为空"
    s adm=tmp("EpisdeID")
    s arcitmid=tmp("Specordid")
    i adm="" q "adm不能为空"
    i arcitmid="" q "医嘱项id不能为空"
    /*
    s flag=""
    s rw="" f rw=$o(^User.DHCConsultationI("ArcimAdm"," "_arcitmid," "_adm,rw)) q:rw=""  d
    .s a=##class(User.DHCConsultation).%OpenId(rw)
	.s status=a.Status
	.b ;009
	.q:status'="E"
	.s attitudetsy=a.attitudetsy  //会诊意见2 不同意；1 同意  attitudetsy为空：没会诊或会诊没执行
	.q:attitudetsy=""
	.b ;888
	.s flag=attitudetsy
	i flag=1 q "病人该医嘱项id已经会诊同意"
	*/
	s saveflag=##class(User.DHCConsultation).SaveKjy(parr)
	s saveFlag2=1_"^"_saveflag
	b ;7
	q saveFlag2
}

// w ##class(web.DHCConsult).checktsyhzrowid("614||1","21")

// 

ClassMethod checktsyhzrowid(arcitmid, adm, Date, Time) As %Status
{
	s ^liyufeng("arcitmid")=arcitmid
	s flag="无"
	s arcitmid=$p(arcitmid,"||")_"_"_$p(arcitmid,"||",2)
	s flag=""
	s flag2=""
	s flag1=""
	s stdatetime=..GetAbsTime(Date_","_Time)
    s rw="" f  s rw=$o(^User.DHCConsultationI("ArcimAdm"," "_arcitmid," "_adm,rw)) q:rw=""  d 
    .s a=##class(User.DHCConsultation).%OpenId(rw)
	.s status=a.Status
	.//b ;009
	.q:status'="E"
	.s ConsultDate=a.ConsultDate
	.s ConsultTime=a.ConsultTime
	.s Consultdatetime=..GetAbsTime(ConsultDate_","_ConsultTime)
	.q:stdatetime>(Consultdatetime+24*3600)
	.s attitudetsy=a.attitudetsy  //会诊意见2 不同意；1 同意  attitudetsy为空：没会诊或会诊没执行
	.i attitudetsy=1 d
	..s flag1=1
	.i attitudetsy=2 d
	..s flag2=1
	i (flag1="")&(flag2=1) s flag=2
	i flag1=1  s flag=1
	b ;03
	q flag     //flag为空 无会诊
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod OpenOrdEntry(consultId As %String) As %String
{
	q:consultId="" "请选择一条数据!"
	s ^DHCConsult("OrdEntry",consultId)=1
	q 0
}

ClassMethod CloseOrdEntry(consultId As %String) As %String
{
	q:consultId="" "请选择一条数据!"
	k ^DHCConsult("OrdEntry",consultId)
	q 0
}

/// 0表示未授权,1表示已授权
ClassMethod GetOrdEntry(consultId As %String) As %String
{
	s rtn=0
	q:consultId="" rtn
	q:$d(^DHCConsult("OrdEntry",consultId))=0 rtn
	i $g(^DHCConsult("OrdEntry",consultId))=1  s rtn=1
	e  s rtn=0
	q rtn
}

/// 获取科室列表
ClassMethod getlocBak(funname As %String, hosId As %String = "", inout As %String = "") As %String
{
	//s ^tmpscv1("getloc") = funname_","_hosId_","_inout
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .s dateFrom=$P(^CTLOC(rw),"^",24)
 .s dateTo=$P(^CTLOC(rw),"^",25)
 .s hospitalDR = $P(^CTLOC(rw),"^",22)
 .s h=+$h
 .q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 .q:c=""
 .i inout="I" q:hospitalDR'=hosId
 .i inout="O" q:hospitalDR=hosId
 .;s c=$P(c,"-",2)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

/// 获取科室列表
ClassMethod getloc(funname As %String, hosId As %String = "", inout As %String = "", consultType = "DOCTOR") As %String
{
	;s ^sctmpv1("getloc") = funname_","_hosId_","_inout
 s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
 .s a=$P(^CTLOC(rw),"^")
 .s c=$P(^CTLOC(rw),"^",2)
 .s dateFrom=$P(^CTLOC(rw),"^",24)
 .s dateTo=$P(^CTLOC(rw),"^",25)
 .s hospitalDR = $P(^CTLOC(rw),"^",22)
 .s h=+$h
 .q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
 .q:c=""
 .i inout="I" q:hospitalDR'=hosId
 .i inout="O" q:hospitalDR=hosId
 .s ifConsultLoc="",locListTypeDr=""
 .i consultType="DOCTOR" s locListTypeDr=$o(^CT("LL",0,"Desc","医疗会诊",""),-1)
 .i consultType="NURSE" s locListTypeDr=$o(^CT("LL",0,"Desc","护理会诊",""),-1)
 .i $g(locListTypeDr)'="" s ifConsultLoc = $o(^CT("LL",0,"Loc1",rw,locListTypeDr,""))
 .q:ifConsultLoc=""
 .;s c=$P(c,"-",2)
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

/// 获取医师级别
ClassMethod getDocGrade(funname As %String, type As %String = "DOCTOR", hosId As %String = "") As %String
{
	;W ##class(web.DHCConsult).getDocGrade("adddocgrade")
	;s ^sctmpv1("getDocGrade") = funname_","_type
 s rw="" f  s rw=$O(^CT("CPT",rw)) q:rw=""  d
 .s a=rw
 .s c=$P($g(^CT("CPT",rw)),"^",2)
 .s activeFlag = $P($g(^CT("CPT",rw)),"^",3)
 .s ptype = $P($g(^CT("CPT",rw)),"^",4)
 .q:((ptype'=type)||(activeFlag'="Y"))
 .q:c=""
 .s rtnval=funname_"('"_$ZCVT($g(rw),"O","JS")_"','"_$ZCVT($g(c),"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .//w !,b
 q 0
}

/// 从会诊申请表里查询数据
ClassMethod GetConsultApply(parr, funname) As %String
{
		;s ^sctmpv1("GetConsultApply") = parr_","_ funname	
  	//w ##class(web.DHCConsult).GetConsultApply("340810^2011-05-23^2011-05-25^true","addconsult")
  	s adm=$p(parr,"^",1)
  	s stdate=$p(parr,"^",2)
  	s edate=$p(parr,"^",3) 
  	s allflag=$p(parr,"^",4)
  	s logonLoc=$p(parr,"^",5)
  	s exeState=$p(parr,"^",6)
  	if allflag="true" {
	  	k tmp
	  	if adm'="" {
		  	
	  		s loc=$P($g(^PAADM(adm)),"^",4)
	  		q:(logonLoc'=loc) "不能查询非本科病人会诊"
	  	}
	  	else {
		  	if logonLoc="" q
		  	s logonLocType=$p(^CTLOC(logonLoc),"^",13)
		  	if logonLocType'="E" {
		    	s linkSub=0  f  s linkSub=$o(^CTLOC(logonLoc,"LINK",linkSub)) q:linkSub=""  d
    			.s loc=$G(^CTLOC(logonLoc,"LINK",linkSub))
			}
			else {
				s loc=logonLoc
			}
		}
	  	i $g(loc)="" q
		i stdate'="" s stdate=$$$ZDH(stdate,3)
		e  s stdate=+$h-2
		i edate'="" s edate=$$$ZDH(edate,3)
		e  s edate=+$h
		f date=stdate:1:edate
		{
			s id="" f  s id=$O(^User.DHCConsultationI("AppDep",date," "_loc,id)) q:id=""  d
			.s a=^User.DHCConsultationD(id)
			.s admId=$listget(a,2)
			.q:admId=""
			.s pavisit=$p($g(^PAADM(admId)),"^",20)
            .s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(admId)
 			.q:(pavisit="D")&(currentStatus'="B")
			.s bedId=$p($g(^PAADM(admId)),"^",73)
			.s WardId=$p(bedId,"||",1)
			.s bedSub=$p(bedId,"||",2)
			.q:(WardId="")!(bedSub="")
			.s bedCode=$p($g(^PAWARD(WardId,"BED",bedSub)),"^",1)
            .q:bedCode=""
            .s tmp(bedCode,id)=""
		}
		s curBedCode="" f  s curBedCode=$O(tmp(curBedCode)) q:curBedCode=""  d
		.s id="" f  s id=$O(tmp(curBedCode,id)) q:id=""  d
		..d OutputPatInfo(1,id)
		f date=stdate:1:edate
		{
			s id="" f  s id=$O(^User.DHCConSultationNewI("AppDep",date," "_loc,id)) q:id=""  d
			.s a=^User.DHCConSultationNewD(id)
			.s admId=$listget(a,2)
			.q:admId=""
			.s pavisit=$p($g(^PAADM(admId)),"^",20)
            .s currentStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(admId)
 			.q:(pavisit="D")&(currentStatus'="B")
			.s bedId=$p($g(^PAADM(admId)),"^",73)
			.s WardId=$p(bedId,"||",1)
			.s bedSub=$p(bedId,"||",2)
			.q:(WardId="")!(bedSub="")
			.s bedCode=$p($g(^PAWARD(WardId,"BED",bedSub)),"^",1)
            .q:bedCode=""
            .s tmp(bedCode,id)=""
		}
		s curBedCode="" f  s curBedCode=$O(tmp(curBedCode)) q:curBedCode=""  d
		.s id="" f  s id=$O(tmp(curBedCode,id)) q:id=""  d
		..d OutputPatInfo(2,id)	
  	} 
  	else {
	  	s loc=$P($g(^PAADM(adm)),"^",4)
	  	q:(logonLoc'=loc) "不能查询非本科病人会诊"
	  	s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_adm,id)) q:id=""  d
	    .d OutputPatInfo(1,id)
	    s id="" f  s id=$O(^User.DHCConSultationNewI("Adm"," "_adm,id)) q:id=""  d
	    .d OutputPatInfo(2,id)
	}
	q 0
OutputPatInfo(typ,id)
	i typ=1 s a=^User.DHCConsultationD(id)
	i typ=2 s a=$G(^User.DHCConSultationNewD(id))
	s Adm=$listget(a,2)
	q:Adm=""
	s patinf=##class(web.DHCMGNurComm).PatInfo(Adm)
	s Diag=$P(patinf,"^",9)
	S patname=$P(patinf,"^",5)
	s bedcode=$P(patinf,"^",6)
	s RegNo=$P(patinf,"^",1)
	s Bah=$P(patinf,"^",10)
	s EncryptLevel=$p(patinf,"^",25)
	s PatLevel=$p(patinf,"^",26)
	s appdate=$listget(a,3)
	if appdate'="" s appdate=$$$ZD(appdate,3)
	i typ = 1 d
	.s appdep=$listget(a,4)
	.if $L(appdep,"-")>1 s appdep=$P(appdep,"-",2)
	.s appdoc=$listget(a,5)
	.s apptime=$listget(a,6)
	.s condep=$listget(a,11)
	.s status=$listget(a,16)
	.s InOut=$listget(a,14)
	.s condestinat=$listget(a,8)
	.s consultdate=$listget(a,10)
	.s type=$listget(a,9)	
	.s RequestConDoc=$listget(a,20)
	.s condepID=condep
	.if condep'=""  s condep=$P($G(^CTLOC(condep)),"^",2)
	.if $L(condep,"-")>1 s condep=$P(condep,"-",2)
	i typ = 2 d
	.s appdep=$listget(a,5)
	.s appdoc=$listget(a,6)
	.s apptime=$listget(a,4)
	.s condep="",condepID=""
	.s subid="" f  s subid =$O(^User.DHCConSultationNewSubI("ConsultDep",id,subid)) q:subid=""  d
    ..s condepID=condepID_"^"_subid
    ..s CTLoc=$P(^CTLOC($tr(subid," ")),"^",2)
    ..if $L(CTLoc,"-")>1 s CTLoc=$P(CTLoc,"-",2)
    ..s condep=condep_" "_CTLoc
    
	.s status=$listget(a,10)
	.s InOut=$listget(a,8)
	.s condestinat=$listget(a,9)
	.s consultdate=""
	.s type=$listget(a,7)
	.s RequestConDoc=""
	q:(typ=2)&&(status="E") 
	if appdep'="" s appdep=$P(^CTLOC(appdep),"^",2)
	if appdoc'="" s appdoc=$P($G(^SSU("SSUSR",appdoc)),"^",14)	
	if apptime'=""  s apptime=$ZT(apptime,2)
	s attitude=$listget(a,7)
	
	if consultdate'="" s consultdate=$$$ZD(consultdate,3)
	
	
	s condoc=$listget(a,12)
	s condocID=condoc
	i condoc'="" s condoc=$p($g(^CTPCP(condoc,1)),"^",2)
	s contime=$listget(a,13)
	if contime'="" s contime=$ZT(contime,2)
	
	i InOut="I" s InOut="院内"
	i InOut="O" s InOut="院外"
	s RelOrder=$listget(a,15)
	q:status="F"
	q:((exeState'="")&&(exeState'=status))
	i status="V" s status="申请"
	i status="E" s status="执行"
	i status="C" s status="撤销"
	i status="R" s status="拒绝"
	i status="W" s status="待审"
	i type="C" s typ="普通"
	if type="E" s typ="急"
	if type="M" s typ="多科"
	if type="A" s typ="抗菌药"
	s condocID=RequestConDoc
	i condocID'="" s condocID=$o(^SSU("SSUSR",0,"CTPCP",condocID,""))
	i RequestConDoc'="" s RequestConDoc=$p($g(^CTPCP(RequestConDoc,1)),"^",2)
	e  s RequestConDoc=""	
	s Specordid=$listget(a,24)
    	s arcitmmastdesc=""
    	i Specordid'="" d
    	.s OEORDRowId=$p(Specordid,"_")
    	.s OEORIChildsub=$p(Specordid,"_",2)
    	.s arcitmmastdesc=$p(^ARCIM(OEORDRowId,OEORIChildsub,1),"^",2)
    	i arcitmmastdesc'="" s condestinat=arcitmmastdesc_"---"_condestinat
    i funname="" d
    .s ^mtemp($J,"Consult",id)=condep_"^"_condoc_"^"_status_"^"_$P($g(bedcode),"@",2)_"^"_appdep_"^"_InOut_"^"_$P($g(Diag),"@",2)_"^"_condestinat_"^"_$P($g(patname),"@",2)_"^"_apptime_"^"_appdate_"^"_consultdate_"^"_contime_"^"_Adm_"^"_id_"^"_typ_"^"_RequestConDoc_"^"_$P($g(RegNo),"@",2)_"^"_$P($g(Bah),"@",2)
    e  d
    .s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(condoc),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($G(InOut),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($G(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"','"_$ZCVT($g(typ),"O","JS")_"','"_$ZCVT($g(RequestConDoc),"O","JS")_"','"_$ZCVT($P($g(RegNo),"@",2),"O","JS")_"','"_$ZCVT($P($g(Bah),"@",2),"O","JS")_"','"_$ZCVT($P($g(EncryptLevel),"@",2),"O","JS")_"','"_$ZCVT($P($g(PatLevel),"@",2),"O","JS")_"','"_$ZCVT($g(condocID),"O","JS")_"','"_$ZCVT($g(condepID),"O","JS")_"');"		
	.&javascript<#(rtnval)#>
}

/// Creator:      SongChao
/// CreateDate:   2017.9.19
/// Description:  患者会诊记录(提供接口给电子病历产品组)
/// Input:        EpisodeID
/// Return:
/// Other:		  d ##class(%ResultSet).RunQuery("web.DHCConsult","ConsultInfo","66")
Query ConsultInfo(EpisodeID As %String) As %Query(ROWSPEC = "PatRegNo,PatId,PatName,SEX,AGE,PatDep,PatWard,BedCode,Diag,ConDestination,ConType,PatDep2,PatDoc,ConsultDep,ConsultDoc,Attitude,ConsultDate,ConsultTime")
{
}

ClassMethod ConsultInfoExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	s EpisodeID=$g(EpisodeID)
	i EpisodeID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
 	s patinf=##class(web.DHCMGNurComm).PatInfo(EpisodeID)
 	S PatName=$P(patinf,"^",5)
 	s PatName=$p(PatName,"@",2)
 	s BedCode=$P(patinf,"^",6)
 	s BedCode=$p(BedCode,"@",2)
 	s PatRegNo=$P(patinf,"^",1)
 	s PatRegNo=$p(PatRegNo,"@",2) 	
 	s SEX=$p($P(patinf,"^",4),"@",2)
    s AGE=$p($P(patinf,"^",7),"@",2)
 	s PatId=$P(patinf,"^",10)
 	s PatId=$p(PatId,"@",2)
 	s PatWard=$P(patinf,"^",8)
 	s PatWard=$p(PatWard,"@",2)
 	
 	s id="" f  s id=$O(^User.DHCConsultationI("Adm"," "_EpisodeID,id)) q:id=""  d
 	.s a=^User.DHCConsultationD(id)
 	.s status=$listget(a,16)
 	.q:(status'="V")&(status'="E")
 	.s Diag=$listget(a,30)
    .//s appdate=$listget(a,3)
    .//if appdate'="" s appdate=$ZD(appdate,3)
    .s appdep=$listget(a,4)
    .if appdep'="" d
    ..s appdepDes=$P(^CTLOC(appdep),"^",2)
    ..i $L(appdepDes,"-")>1 s appdepDes=$P(appdepDes,"-",2)
    .e  s appdepDes=""
    .s PatDep=appdepDes
    .s PatDep2=PatDep
    .s appdoc=$listget(a,5)
    .if appdoc'="" s PatDoc=$P(^SSU("SSUSR",appdoc),"^",2)
    .e  s PatDoc=""
   
    .s condestinat=$listget(a,8)
    .s condestinat=$tr(condestinat,"*","x")
    .s ConDestination=condestinat
    .s ConType=""
    .s type=$listget(a,9)
    .i type="C" s ConType="普通"
    .i type="E" s ConType="急"
    .if type="M" s ConType="多科"
    .if type="A" s ConType="抗菌药"
    .s condep=$listget(a,11)
    .if condep'=""  d
    ..s condepDes=$P(^CTLOC(condep),"^",2)
    ..i $L(condepDes,"-")>1 s condepDes=$P(condepDes,"-",2)
    .e  s condepDes=""
    .s ConsultDep=condepDes
     .s condoc=$listget(a,12)
    .if condoc'="" s condocDes=$p($g(^CTPCP(condoc,1)),"^",2)
    .e  s condocDes=""
    .s ConsultDoc=condocDes
    .s consultdate=$listget(a,10)
    .if consultdate'="" s consultdate=$ZD(consultdate,3)
    .s ConsultDate=consultdate
    .s contime=$listget(a,13)
    .if contime'="" s contime=$ZT(contime,2)
    .s ConsultTime=contime
    .s Attitude=$listget(a,7)
    .s Attitude=$tr(Attitude,"*","x")    
	.d Consult
	s qHandle=$lb(0,repid,0)
	q $$$OK

Consult
	s Data=$lb(PatRegNo,PatId,PatName,SEX,AGE,PatDep,PatWard,BedCode,Diag,ConDestination,ConType,PatDep2,PatDoc,ConsultDep,ConsultDoc,Attitude,ConsultDate,ConsultTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod ConsultInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ConsultInfoExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod ConsultInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ConsultInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

}
