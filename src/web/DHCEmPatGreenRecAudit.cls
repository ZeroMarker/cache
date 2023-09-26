Import SQLUser

Class web.DHCEmPatGreenRecAudit Extends %RegisteredObject
{

/// Description: 绿色通道待审核
/// Creator:     hxy
/// CreateDate:  2022-07-15
/// Table: 		 DHC_EmPatGreenRec
/// Input:  	 开始日期、结束日期、姓名、登记号、审核已未、
/// Return： 	 
/// Others:		w ##class(web.DHCEmPatGreenRecAudit).List(1,60,"2^2022-07-18^2022-07-19^^^N")
ClassMethod List(page, rows, Params) As %Status
{
	s start=(page-1)*rows+1
    s end=page*rows
    s HtmlHospID=$p(Params,"^",1)
    s StDate=$p(Params,"^",2)
    s EdDate=$p(Params,"^",3)
    s HtmlName=$p(Params,"^",4)
    s HtmlNo=$p(Params,"^",5)
    s HtmlFlag=$p(Params,"^",6)
    s StDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
    s EdDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EdDate)
    s:StDate="" StDate=+$h
    s:EdDate="" EdDate=+$h
    
    s GREENAUDIT=##Class(web.DHCEMComPar).GetAppPropValue("DHCGUA","GREENAUDIT",HtmlHospID,"","","")
    
    s count=0
    s jsonObj=##class(web.DHCEMJsonCommon).%New()
    s ListTitle="ID^Name^RegNo^Loc^AdmDateTime^GreenSta^ThreeNo^AuditSta^DateTime^Hours^Reason^User^AuditUser^AuditDateTime^AuditedFlag^AdmID^ChkID"
    w "{""rows"":["
    f CurDate=StDate:1:EdDate  d 
	.s ID=""
	.f  s ID=$o(^DHCEMPGR(0,"Date",CurDate,ID)) q:ID=""  d
	..q:ID=0
	..s ChkID=$p(^DHCEMPGR(ID),"^",1)
	..s AdmID=$p(^DHCEMPGR(ID),"^",6)
	..i AdmID="" d
	...s EmAdmID=$o(^DHCEMPCA(0,"PatCheckLev",ChkID,""),-1)
	...s AdmID=$p($g(^DHCEMPCA(+EmAdmID)),"^",2)
	..s PatientID=$p($g(^PAADM(+AdmID)),"^",1)    /// 病人ID
	..s:AdmID="" PatientID=$p($g(^DHCEMPCL(+ChkID)),"^",1)
	..q:PatientID=""	
	..q:'$d(^PAPER(PatientID,"PAT",1))
	..s Name=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	..s RegNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 病人登记号
	..s LoDr=$p($g(^PAADM(+AdmID)),"^",4)
	..i LoDr="" d 
	...s EmPccID=$o(^DHCEMPCC(0,"PatCheckLev",ChkID,""))
	...i EmPccID'="" s LoDr=$p(^DHCEMPCC(EmPccID),"^",3)
	..s Loc=$p(^CTLOC(LoDr),"^",2) //科室
	..s HospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LoDr)
	..q:(HtmlName'="")&($$ALPHAUP^SSUTIL4(Name)'[$$ALPHAUP^SSUTIL4(HtmlName))
	..q:(HtmlNo'="")&(HtmlNo'=RegNo)
	..q:(HtmlHospID'="")&(HtmlHospID'=HospID) 
	..s AdmDate=$p($g(^PAADM(+AdmID)),"^",6)
	..s AdmTime=$P($g(^PAADM(+AdmID)),"^",7)
	..i AdmDate="" d
	...s AdmDate=$p(^DHCEMPCL(ChkID),"^",4) //分诊日期
	...s AdmTime=$p(^DHCEMPCL(ChkID),"^",5) //分诊时间
	..s AdmDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AdmDate)
	..s:AdmTime'="" AdmTime=$zt(AdmTime)
	..s AdmDateTime=AdmDate_" "_AdmTime     //就诊时间
	..s GreenSta=..GetGreenSta(ID) //绿通状态
	..q:GreenSta="取消"
	..s ThreeNo="否" //三无
	..s ThreeDr=$p($g(^DHCEMPCL(+ChkID)),"^",40) // 特殊人群
	..s ThreeDesc=$p($g(^DHCEMPT(+ThreeDr)),"^",2)
	..s:ThreeDesc["三无" ThreeNo="是"
	..s AuditSta=..getAuditSta(ID,GREENAUDIT) //审核状态
	..s AuditedFlag=$s(AuditSta="审核拒绝":"Y",AuditSta="审核通过":"Y",1:"N")
	..q:(GREENAUDIT=1)&&(AuditedFlag'=HtmlFlag)&&(HtmlFlag'="")
	..s LastPar=..GetLastParRef(ID) //最后一条绿通记录
	..q:(+$p($g(^DHCEMPGR(+LastPar)),"^",10)'=0)&&(GREENAUDIT=1)&&(HtmlFlag="N") //取消人不为空
	..s LastParRef=..GetLastReqParRef(ID) //待审显示真正的待审（最后一条申请） st
	..q:(GREENAUDIT=1)&&(ID'=LastParRef)&&(HtmlFlag="N") //ed
	..s:(GreenSta="有效")&&(ID'=LastParRef) GreenSta="失效" //2022-07-21 有多条申请数据时，默认只有最后一条为有效状态，其余显示为失效;
	..s:((AuditSta="待审核")!(AuditSta="撤销审核"))&&(GreenSta="有效") GreenSta="申请" //2022-07-26
	..s:(AuditSta="审核拒绝")&&(GreenSta="有效") GreenSta="无效"
	..s Date=$p(^DHCEMPGR(ID),"^",8)
	..s Time=$p(^DHCEMPGR(ID),"^",9)
	..s DateTime=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)_" "_$zt(Time) //申请时间
	..s Hours=..GetHours(ID) //申请时长(h)		
	..s Reason=$p(^DHCEMPGR(ID),"^",14)
	..s Reason=$p($g(^DHCEMDI(+Reason)),"^",2) //申请原因
	..s User=$p(^DHCEMPGR(ID),"^",7)
	..s:User'="" User=$p($g(^SSU("SSUSR",+User)),"^",2) //申请人
	..s AuditUser="",AuditDateTime="",AuditDate="",AuditTime=""
	..s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",ID,""),-1)
	..i AuditID'="" d
	...s AuditUser=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),3)
	...s AuditDate=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),4)
	...s AuditTime=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),5)
	..s:AuditUser'="" AuditUser=$p($g(^SSU("SSUSR",+AuditUser)),"^",2) //审核人
	..s:AuditDate'="" AuditDateTime=##class(web.DHCEMCommonUtil).DateLogicalToHtml(AuditDate)_" "_$zt(AuditTime) //审核时间
	..// 多语言
	..S Loc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",Loc)
	..s GreenSta=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp",GreenSta)
	..s ThreeNo=##class(web.DHCEMCommonUtil).GetTrans("",ThreeNo)
	..s AuditSta=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp",AuditSta)
	..s Reason=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmDicItem","EMDesc","",Reason)
	..S User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
	..S AuditUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",AuditUser)
	..s ListData=ID_"^"_Name_"^"_RegNo_"^"_Loc_"^"_AdmDateTime_"^"_GreenSta_"^"_ThreeNo_"^"_AuditSta_"^"_DateTime_"^"_Hours //10
	..s ListData=ListData_"^"_Reason_"^"_User_"^"_AuditUser_"^"_AuditDateTime_"^"_AuditedFlag_"^"_AdmID_"^"_ChkID //16
	..s count=count+1
	..q:count<start
	..q:count>end
    ..w $case(count,start:"",:",")
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w "],""total"":"_count_"}"
	q ""
}

/// Others:	w ##class(web.DHCEmPatGreenRecAudit).GetGreenSta()
ClassMethod GetGreenSta(green) As %Status
{
	s ret="有效"
	s endDate=$p(^DHCEMPGR(green),"^",4)
	s endTime=$p(^DHCEMPGR(green),"^",5)
	s aliveHours=""
	i endDate'="" d
	.s aliveHours=$SYSTEM.SQL.DATEDIFF("ss",$h,endDate_","_endTime)
	.s:aliveHours<0 ret="失效"
	s xUser=+$p(^DHCEMPGR(green),"^",10)
	s:xUser'=0 ret="取消"
	q ret
}

/// Others:	w ##class(web.DHCEmPatGreenRecAudit).getAuditSta()
ClassMethod getAuditSta(green, GREENAUDIT) As %Status
{
	i GREENAUDIT'=1 d
	.s ret="无需审核"
	e  d
	.s ret="待审核"
	s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",green,""),-1)
	s StaCode=""
	s:AuditID'="" StaCode=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),6)
	s ret=$s(StaCode="R":"审核拒绝",StaCode="P":"审核通过",StaCode="C":"撤销审核",1:ret) //ed
	q ret
}

/// Others:	w ##class(web.DHCEmPatGreenRecAudit).GetHours()
ClassMethod GetHours(green) As %Status
{
	s stDate=$p(^DHCEMPGR(green),"^",2)
	s stTime=$p(^DHCEMPGR(green),"^",3)
	s endDate=$p(^DHCEMPGR(green),"^",4)
	q:endDate="" "" //配置绿色通道时效启用 不启用时，为空
	s endTime=$p(^DHCEMPGR(green),"^",5)
	s ret=$SYSTEM.SQL.DATEDIFF("hh",stDate_","_stTime,endDate_","_endTime)
	q ret
}

ClassMethod InsAudit(ParRef, Creator, CreateDate, CreateTime, Status) As %String
{
	&SQL(Insert Into DHC_EmPatGreenRecAudit(PGRA_ParRef,PGRA_Creator,PGRA_CreateDate,PGRA_CreateTime,PGRA_Status)
		values(:ParRef,:Creator,:CreateDate,:CreateTime,:Status))
	Q SQLCODE
}

/// Others:	w ##class(web.DHCEmPatGreenRecAudit).InsAuditS("19","18850","P")
/// Others:	w ##class(web.DHCEmPatGreenRecAudit).InsAuditS("106","9","R","118")
ClassMethod InsAuditS(ParRefS, Creator, Status, LgGrp) As %String
{
	s CreateDate=+$h
	s CreateTime=$p($h,",",2)
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(ParRefS,"$$")
  	for i=1:1:len d
  	.q:ret'=0
  	.s ParRef=$p(ParRefS,"$$",i)
  	.s:Status="C" ret=..ifPermit(ParRef,Creator) //撤销审核时，非本人不允许操作。
  	.q:ret'=0
  	.i Status="C" d
  	..s LastParRef=..GetLastReqParRef(ParRef) //撤销 非最新申请记录，不能撤销审核
  	..s:ParRef'=LastParRef ret=1
  	.q:ret'=0
  	.s:Status="C" ret=..delGreenRec(ParRef) //撤销 拒绝审核时删除取消记录
  	.q:ret'=0
  	.s ret=..InsAudit(ParRef,Creator,CreateDate,CreateTime,Status)
  	.q:ret'=0
  	.s:Status="R" ret=..saveGreenRec(ParRef,Creator,LgGrp) //审核拒绝时插入取消记录
  	.q:ret'=0
  	.s ret=..UpdPaAdmPatGreen(ParRef,Status)
	i ret'=0 TRollback
	q:ret=1 ret    //撤销 非最新申请记录，不能撤销审核
	q:ret="-2" ret //撤销审核时，非本人不允许操作
	q:ret'=0 "-1"
	TCOMMIT
	q ret
Err
	TRollback
	q -1
}

/// Others:	w ##class(web.DHCEmPatGreenRecAudit).ifPermit("276","9")
ClassMethod ifPermit(ParRef, Creator)
{
	s res="0"
	s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",ParRef,""),-1)
	s UserID=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),3)
	s:Creator'=UserID res="-2"
	q res
}

ClassMethod saveGreenRec(ParRef, Creator, LgGrp)
{
	s res="0"
	s Adm=$p(^DHCEMPGR(ParRef),"^",6)
	s Chk=$p(^DHCEMPGR(ParRef),"^",1)
	s res=##class(web.DHCEMPatGreenRec).saveGreenRec(Adm,Creator,LgGrp,"N","",Chk,"") //插入取消记录

	q res
}

ClassMethod delGreenRec(ParRef)
{
	s res="0"
	s AuditID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",ParRef,""),-1)
	s StaCode=""
	s:AuditID'="" StaCode=$lg(^User.DHCEmPatGreenRecAuditD(AuditID),6)
	i StaCode="R" d
	.s LastParRef=..GetLastParRef(ParRef)
	.&SQL(Delete From DHC_EmPatGreenRec Where PGR_RowID=:LastParRef)
	.s:SQLCODE=100 SQLCODE=0
	.s:SQLCODE'=0 res=-1
	q res
}

ClassMethod UpdPaAdmPatGreen(ParRef, Status)
{
	s ret="0"
	
	s LastParRef=..GetLastParRef(ParRef)
	q:ParRef'=LastParRef ret
	s GreenSta=..GetGreenSta(ParRef)
	q:GreenSta="取消" ret
	s EpisodeID=$p(^DHCEMPGR(ParRef),"^",6)
	s:(Status="P")&&(GreenSta="有效") ret=##class(web.DHCEMPatCheckLev).UpdPaAdmPatGreen(EpisodeID,"Y") /// 修改就诊表绿色通道信息
	s:Status'="P" ret=##class(web.DHCEMPatCheckLev).UpdPaAdmPatGreen(EpisodeID,"N") /// 修改就诊表绿色通道信息

	q ret
}

/// 取最后一条记录
ClassMethod GetLastParRef(ParRef)
{
	s LastParRef=""
	s Adm=$p(^DHCEMPGR(ParRef),"^",6)
	s ChkID=$p(^DHCEMPGR(ParRef),"^",1)
	s:Adm'="" LastParRef=$o(^DHCEMPGR(0,"Adm",Adm,""),-1)
	s:LastParRef="" LastParRef=$o(^DHCEMPGR(0,"PatCheckLev",ChkID,""),-1)
	q LastParRef
}

/// 取最后一条申请记录
/// Others:		w ##class(web.DHCEmPatGreenRecAudit).GetLastReqParRef(261)
ClassMethod GetLastReqParRef(ParRef)
{
	s LastReqParRef=""
	s Adm=$p(^DHCEMPGR(ParRef),"^",6)
	s ChkID=$p(^DHCEMPGR(ParRef),"^",1)
	i Adm'="" d
	.s LastParRef=""
	.f  s LastParRef=$o(^DHCEMPGR(0,"Adm",Adm,LastParRef),-1) q:(LastParRef="")!(LastReqParRef'="")  d
	..s xUser=+$p(^DHCEMPGR(LastParRef),"^",10)
	..q:xUser'=0
	..s LastReqParRef=LastParRef
	i LastReqParRef="" d
	.s LastParRef=""
	.f  s LastParRef=$o(^DHCEMPGR(0,"PatCheckLev",ChkID,LastParRef),-1) q:(LastParRef="")!(LastReqParRef'="")  d
	..s xUser=+$p(^DHCEMPGR(LastParRef),"^",10)
	..q:xUser'=0
	..s LastReqParRef=LastParRef
	q LastReqParRef
}

/// Description: 绿色通道审核历史
/// Creator:     hxy
/// CreateDate:  2022-07-20
/// Table: 		 DHC_EmPatGreenRecAudit
/// Input:  	 ID
/// Return： 	 
/// Others:		w ##class(web.DHCEmPatGreenRecAudit).AuditList(1)
ClassMethod AuditList(page, rows, Params) As %Status
{
	s start=(page-1)*rows+1
    s end=page*rows
   	q:Params="" ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)
    s Parref=$p(Params,"^",1)
    
    s count=0
    s jsonObj=##class(web.DHCEMJsonCommon).%New()
    s ListTitle="User^DateTime^Sta"
    w "{""rows"":["
	s ID=""
	f  s ID=$o(^User.DHCEmPatGreenRecAuditI("IndexParref",Parref,ID)) q:ID=""  d
	.q:ID=0
	.s User=$lg(^User.DHCEmPatGreenRecAuditD(ID),3)
	.s Date=$lg(^User.DHCEmPatGreenRecAuditD(ID),4)
	.s Time=$lg(^User.DHCEmPatGreenRecAuditD(ID),5)
	.s:User'="" User=$p($g(^SSU("SSUSR",+User)),"^",2) //审核人
	.S User=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",User)
	.s DateTime=""
	.s:Date'="" DateTime=##class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)_" "_$zt(Time) //审核时间
	.s StaCode=$lg(^User.DHCEmPatGreenRecAuditD(ID),6)
	.s Sta=$s(StaCode="R":"审核拒绝",StaCode="P":"审核通过",StaCode="C":"撤销审核",1:"") //ed
	.s Sta=##class(web.DHCEMCommonUtil).GetTrans("dhcem.green.rec.csp",Sta)
	.s ListData=User_"^"_DateTime_"^"_Sta
	.s count=count+1
	.q:count<start
	.q:count>end
    .w $case(count,start:"",:",")
	.w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w "],""total"":"_count_"}"
	q ""
}

/// Creator:      hxy
/// CreatDate:    2022-07-20
/// Description:  获取用户所有可登录科室对应的医院
/// Input:        用户Id
/// Others:  w ##class(web.DHCEmPatGreenRecAudit).GetHosps("18850") 
ClassMethod GetHosps(UserId)
{
	w "["
	s DefLoc=$p($g(^SSU("SSUSR",+UserId)),"^",4)
	s DefHospDr=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(DefLoc)
	s DefHosp=$p($g(^CT("HOSP",+DefHospDr)),"^",2)
	s DefHosp=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",DefHosp)
	s Tmp=DefHospDr_"^"_DefHosp
	s Str="*"_DefHospDr_"*"
	W ##class(web.DHCEMJsonCommon).getJsonData("id^text",Tmp)
	s OTHLLSub=0
	f  s OTHLLSub=$o(^SSU("SSUSR",UserId,"OTHLL",OTHLLSub)) q:(OTHLLSub="")  d
	.s OTHLLCTLocID=$p(^SSU("SSUSR",UserId,"OTHLL",OTHLLSub),"^",1)
	.s HospDr=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(OTHLLCTLocID)
	.q:Str[("*"_HospDr_"*")
	.s Str=Str_HospDr_"*"
	.s HospDesc=$p($g(^CT("HOSP",+HospDr)),"^",2)
	.s HospDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTHospital","HOSPDesc","",HospDesc)
	.s Tmp=HospDr_"^"_HospDesc
	.W ","_##class(web.DHCEMJsonCommon).getJsonData("id^text",Tmp)
	w "]"
	
	q ""
}

}
