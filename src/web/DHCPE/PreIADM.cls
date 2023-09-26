Import SQLUser

Class web.DHCPE.PreIADM Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 491;

///  搜索登记信息 只适合个人登记患者 
///  d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADM","SearchPreIADM","0000000001","","","","","","","","","","","")
Query SearchPreIADM(RegNo As %String = "", Name As %String = "", PEStDate As %String = "", Status As %String = "", ChargedStatus As %String = "", CheckedStatus As %String = "", EndDate As %String = "", GroupID As %String = "", TeamID As %String = "", DepartName As %String = "", VIPLevel As %String, RoomPlace As %String = "", ReCheck As %String = "", SexDR As %String = "", CardTypeNew As %String = "", HospID As %String = "", ShowTotal As %String = "Y") As %Query(ROWSPEC = "PIADM_RowId:%String, PIADM_PIBI_DR:%String, PIADM_PIBI_DR_RegNo:%String, PIADM_PIBI_DR_Name:%String, PIADM_PGADM_DR:%String, PIADM_PGADM_DR_Name:%String, PIADM_PGTeam_DR:%String, PIADM_PGTeam_DR_Name:%String, PIADM_PEDateBegin:%String, PIADM_PEDateEnd:%String, PIADM_PETime:%String, PIADM_PEDeskClerk_DR:%String, PIADM_PEDeskClerk_DR_Name:%String, PIADM_Status:%String, PIADM_Status_Desc:%String, PIADM_AsCharged:%String, PIADM_AccountAmount:%String, PIADM_DiscountedAmount:%String, PIADM_SaleAmount:%String, PIADM_FactAmount:%String, PIADM_AuditUser_DR:%String, PIADM_AuditUser_DR_Name:%String, PIADM_AuditDate:%String, PIADM_UpdateUser_DR:%String, PIADM_UpdateUser_DR_Name:%String, PIADM_UpdateDate:%String, PIADM_ChargedStatus:%String, PIADM_ChargedStatus_Desc:%String, PIADM_CheckedStatus:%String, PIADM_CheckedStatus_Desc:%String, PIADM_AddOrdItem:%String, PIADM_AddOrdItemLimit:%String, PIADM_AddOrdItemAmount:%String, PIADM_AddPhcItem:%String, PIADM_AddPhcItemLimit:%String, PIADM_AddPhcItemAmount:%String, PIADM_IReportSend:%String, PIADM_IReportSend_Desc:%String, PIADM_DisChargedMode:%String, PIADM_DisChargedMode_Desc:%String, PIADM_VIP:%String,PIADMRemark:%String,PIADM_OldHPNo:%String,TSort:%String,TGetReportDate:%String,TType:%String,TPayType:%String,PIBI_IDCard:%String,PGBI_Tel1:%String,TAge:%String,PIADMPIBI_DR_SEX:%String,TPosition:%String,TAdmIdPIDM:%String,TBLPrtFlag:%String,TNewHPNo:%String,TOrdEnt:%String,TPatItemPrtFlag:%String,TAsType:%String,TRoomPlace:%String,TMark:%String,TAdmDate:%String,TAccountAmount:%String,TFactAmount:%String,TReportStatus:%String,TDiet:%String,TPACCardType:%String,TMarryDesc:%String,TGetCheckDate")
{
}

ClassMethod SearchPreIADMExecute(ByRef qHandle As %Binary, RegNo As %String = "", Name As %String = "", PEStDate As %String = "", Status As %String = "", ChargedStatus As %String = "", CheckedStatus As %String = "", EndDate As %String = "", GroupID As %String = "", TeamID As %String = "", DepartName As %String = "", VIPLevel As %String, RoomPlace As %String = "", ReCheck As %String = "", SexDR As %String = "", CardTypeNew As %String = "", HospID As %String = "", ShowTotal As %String = "Y") As %Status
{
    s ^tempdhcpe("SearchPreIADM")=$lb(RegNo,Name,PEStDate,Status,ChargedStatus,CheckedStatus,EndDate,GroupID,TeamID,DepartName,VIPLevel,RoomPlace,ReCheck,SexDR,CardTypeNew,HospID,ShowTotal)
	i PEStDate'="" s PEStDate=##class(websys.Conversions).DateHtmlToLogical(PEStDate) 
	i EndDate'=""  s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	Set repid=$I(^CacheTemp)
	s PETime=""
	s Name=##class(web.DHCPE.DHCPECommon).UnEscape(Name)
	s DepartName=##class(web.DHCPE.DHCPECommon).UnEscape(DepartName)
	if ((""=RegNo)&(""=Name)&(""=PEStDate)&(""=PETime)&(""=Status)&(""=ChargedStatus)&(""=CheckedStatus)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	 
	//复制项目界面如果登记号和姓名为空，直接退出
    if ((""=RegNo)&(""=Name)&(ShowTotal="N")) {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }

	//s RoomPlace=$P(VIPLevel,"^",2)
	//s VIPLevel=$P(VIPLevel,"^",1)
	s Job=$J
	k ^TempDHCPEPerIADM(Job)
	K ^TempDHCPEPerIADMVIP(Job)
	
	s PESystemStartDate=##class(web.DHCPE.Public.Setting).GetPESystemStartDate()
	s:Status="^" Status=""
	i Status="" s Status="^PREREG^PREREGED^REGISTERED^ARRIVED^CANCELPREREG^CANCELARRIVED^"
	
	i PEStDate="" s PEStDate=+$H 
	i EndDate="" s EndDate=+$H  
		
	Set ind=1
	s PreID="" 
	i RegNo'="" d 
	.//优先按照体检号进行查询，查不到数据按照登记号查询
    .s PreID=##class(web.DHCPE.HISUICommon).GetPreIDByHPNo(RegNo)
    .i PreID'=""  s PIBI=$P($g(^DHCPEPreIADM(PreID)),"^",1)
    .i PreID="" d
	..s ERegNo=""
	..s PAPMIID=""
	..f  s PAPMIID=$o(^PAPERi("EmplNo",RegNo,PAPMIID)) q:PAPMIID=""  d
	...s ActiveFlag=$p($g(^PAPER(PAPMIID,"PAT",1)),"^",6)
	...q:ActiveFlag="N"
	...s ERegNo=$P($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	..s:ERegNo'="" RegNo=ERegNo
	..s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.q:PIBI=""
	.s id=""
	.f  s id=$o(^DHCPEPreIADM(0,"PIBI",PIBI,id),-1) q:(id="")||(id=0)  d
	..q:((PreID'="")&&(PreID'=id)) //体检号
	..d GetPIADMInfo
	
	e  i Name'="" d
	.;s NameU=$ZCVT(Name,"U")
	.s NameU=$$ALPHAUP^SSUTIL4(Name)
	.s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",NameU),-1)
	.f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[NameU)  d
	..s PIBIDR=0
	..f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
	...s id=""
	...f  s id=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,id),-1) q:(id="")||(id=0)  d
	....d GetPIADMInfo
	e  i +GroupID'="0" d
	.s iTeamSub=0
	.f  s iTeamSub=$o(^DHCPEPreGADM(GroupID,"Team",iTeamSub)) q:iTeamSub=""  d
	..s iTeamID=GroupID_"||"_iTeamSub
	..q:(TeamID'="")&&(TeamID'=iTeamID)
	..s id=""
	..f  s id=$o(^DHCPEPreIADM(0,"PGTeam",iTeamID,id),-1) q:(id="")||(id=0)  d
	...d GetPIADMInfo
	e  d
	.s Date=""
	.f  s Date=$o(^DHCPEPreIADM(0,"BookDateTime",Date),-1) q:((Date="")||(Date=0)||(Date<PEStDate))  d
	..s EDate=0
	..f  s EDate=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate)) q:((EDate="")||(EDate=0)||(EDate>EndDate))  d
	...s Time=""
	...f  s Time=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time),-1) q:((Time="")||(Time=0))  d
	....;s id=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time,0)) q:((id="")||(id=0))
	....s id=""	//不能使用空字符串开始 s id="" ,否则会取到 0
	....f  s id=$o(^DHCPEPreIADM(0,"BookDateTime",Date,EDate,Time,id),-1) q:(id="")||(id=0)  d
	.....d GetPIADMInfo
	
	if (ShowTotal="Y"){
		
		s TotalEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp","合计：")
		s TotalEng1=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp","共")
 		s PersonEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp","人")
 		s SexDesc="",col=1
 		f  s SexDesc=$o(^TempDHCPEPerIADM(Job,SexDesc)) q:SexDesc=""  d
 		.s (id,PIADMPIBIDR,PIADMPIBIDRName,PIADMPGADMDR, PIADMPIBIDRSEX,PIADMPGTeamDR,PIADMPEDateBegin, PIADMPEDateEnd, PIADMPETime, PIADMPEDeskClerkDR, PIADMPEDeskClerkDRName, PIADMStatus, PIADMStatusDesc, PIADMAsCharged, PIADMAccountAmount, PIADMDiscountedAmount, PIADMSaleAmount, PIADMFactAmount, PIADMAuditUserDR, PIADMAuditUserDRName, PIADMAuditDate, PIADMUpdateUserDR, PIADMUpdateUserDRName, PIADMUpdateDate, PIADMChargedStatus, PIADMChargedStatusDesc, PIADMCheckedStatus, ReportStatus, PIADMAddOrdItem, PIADMAddOrdItemLimit, PIADMAddOrdItemAmount, PIADMAddPhcItem, PIADMAddPhcItemLimit, PIADMAddPhcItemAmount, PIADMIReportSend, PIADMIReportSenDdesc, PIADMDisChargedMode, PIADMDisChargedModeDesc, PIADMVIP,PIADMRemark,PIADMOldHPNo,TGetReportDate,TType,TPayType,PIBIIDCard,PGBITel,TAge,TPosition,PAADM,TBLPrtFlag,TNewHPNo,TOrdEnt,TPatItemPrtFlag,AsType,TRoomPlace,TMark,AdmDate,AccountAmount,FactAmount,ReportStatus,Diet,PACCardDesc,PIBIMarriedDRName,CheckDate)=""
 		.i col="1" s PIBIPAPMINo=TotalEng
 		.e  s PIBIPAPMINo=""
 		.s SexDescEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",SexDesc,"CTSEXDesc","cls")
 		.s PIADMPGADMDRName=SexDescEng_":"_TotalEng1_$g(^TempDHCPEPerIADM(Job,SexDesc))_PersonEng
 		.s col=col+1
    	.d FindBuild
 	
 	
 		s VIPDesc=""
 		f  s VIPDesc=$o(^TempDHCPEPerIADMVIP(Job,VIPDesc)) q:VIPDesc=""  d
    	.s (id, PIADMPIBIDR,PIADMPIBIDRName,PIADMPGADMDR, PIADMPIBIDRSEX,PIADMPGTeamDR, PIADMPGTeamDRName, PIADMPEDateBegin, PIADMPEDateEnd, PIADMPETime, PIADMPEDeskClerkDR, PIADMPEDeskClerkDRName, PIADMStatus, PIADMStatusDesc, PIADMAsCharged, PIADMAccountAmount, PIADMDiscountedAmount, PIADMSaleAmount, PIADMFactAmount, PIADMAuditUserDR, PIADMAuditUserDRName, PIADMAuditDate, PIADMUpdateUserDR, PIADMUpdateUserDRName, PIADMUpdateDate, PIADMChargedStatus, PIADMChargedStatusDesc, PIADMCheckedStatus, ReportStatus, PIADMAddOrdItem, PIADMAddOrdItemLimit, PIADMAddOrdItemAmount, PIADMAddPhcItem, PIADMAddPhcItemLimit, PIADMAddPhcItemAmount, PIADMIReportSend, PIADMIReportSenDdesc, PIADMDisChargedMode, PIADMDisChargedModeDesc, PIADMVIP,PIADMRemark,PIADMOldHPNo,TGetReportDate,TType,TPayType,PIBIIDCard,PGBITel,TAge,TPosition,PAADM,TBLPrtFlag,TNewHPNo,TOrdEnt,TPatItemPrtFlag,AsType,TRoomPlace,TMark,AdmDate,AccountAmount,FactAmount,ReportStatus,Diet,PACCardDesc,PIBIMarriedDRName,CheckDate)=""
    	.s VIPDescEng=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPDesc,"VLDesc","cls")
    	.s PIADMPGADMDRName=VIPDescEng_":"_$g(^TempDHCPEPerIADMVIP(Job,VIPDesc))_PersonEng
    	.i col="1" s PIBIPAPMINo=TotalEng
 		.e  s PIBIPAPMINo=""
 		.s col=col+1
 		.d FindBuild
 		
	}
 	k ^TempDHCPEPerIADM(Job)
 	k ^TempDHCPEPerIADMVIP(Job)
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetPIADMInfo
	s LocID=$P($g(^DHCPEPreIADM(id)),"^",26)
	s TReCheck=""
	//s TReCheck=##class(web.DHCPE.PreCommon).IsReCheck(id,"Pre")
	s TReCheck=$P($g(^DHCPEPreIADM(id)),"^",28)
	i TReCheck="Y" s TReCheck="1"
	e  s TReCheck="0"
	q:(ReCheck'="")&&(TReCheck'=ReCheck)
	s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",id)
	q:((DepartName'="")&&(TPosition'[DepartName))
	s CurData=$g(^DHCPEPreIADM(id))
	q:$P(CurData,"^",22)<PESystemStartDate
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",id,LocID)       
  	q:LocFlag=1  
  	s iLLoop=1
	// 个人基本信息DR
	s PIADMPIBIDR=$p(CurData,"^",1)
	q:(""=PIADMPIBIDR)	//防止取到空数据
	//预约体检日期 
	s PIADMPEDateEnd=$p(CurData,"^",5) 
	s PIADMPEDateEnd2=$p(CurData,"^",4) 
	//Q:(0'=PEDate)&(+PEDate>+PIADMPEDateEnd)
	q:(+PEStDate>+PIADMPEDateEnd)&&(RegNo="")&&(ShowTotal="Y")
	q:(+EndDate<+PIADMPEDateEnd2)&&(RegNo="")&&(ShowTotal="Y")
	i ""'=PIADMPEDateEnd s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	// 登记号
	i ""'=PIADMPIBIDR  d
	.s PIBIPAPMINo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
	e  d
	.s PIBIPAPMINo=""
	//q:(""'=RegNo)&(RegNo'=PIBIPAPMINo) //数据过滤
    q:(""'=RegNo)&(PreID="")&(RegNo'=PIBIPAPMINo)
	s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
	s PGBITel1=""
	s PGBITel2=""
	s PGBITel=""
	s PIADMPIBIDRName=""
	s TAge="",PIADMPIBIDRSEX=""
	q:$o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0))="" 
	S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	s PIBIIDCard=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PAT",3)),"^",6)
	
	//婚姻状况
	s PIBIMarriedDRName=""
	s PIBIMarriedDR=$p($g(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PER",2)),"^",3)
	i ""'=PIBIMarriedDR  d  
	.s PIBIMarriedDRName=$p($g(^CT("MAR",PIBIMarriedDR)),"^",2)
	e  d
	.s PIBIMarriedDR=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",17)
	.i ""'=PIBIMarriedDR  d  
	..s PIBIMarriedDRName=$p($g(^CT("MAR",PIBIMarriedDR)),"^",2)
	
	i ""'=PIADMPIBIDR  d
	.;s PIBIIDCard=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",9)       //身份证号     //Add
    .s PGBITel1=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",8) //联系电话 //Add
	.s PGBITel2=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",6) 
	.i PGBITel2="" s PGBITel2=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",7)
	.s TAge=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",4)
	.//i TAge'="" s TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H),"Y",1) 
	.;i TAge'="" s TAge=##class(web.DHCDocCommon).GetAgeDescNew($zd(TAge,3),"")
	.S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0))
	.i PAPMIRowId'="" d
	..;s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId)
	..s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID,LocID)
	.s PIADMPIBIDRSEX=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
	.i PGBITel1'=""  s PGBITel=PGBITel1
	.e  s PGBITel=PGBITel2
	.s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	q:(""'=Name)&('(PIADMPIBIDRName[Name))
	q:(""'=SexDR)&(SexDR'=PIADMPIBIDRSEX)
	i PIADMPIBIDRSEX'="" s PIADMPIBIDRSEX=$P(^CT("SEX",PIADMPIBIDRSEX),"^",2)
	s iLLoop=iLLoop+1
	// 对应团体的ADM 
	s PIADMPGADMDR=$p(CurData,"^",iLLoop)
	q:("0"'=+GroupID)&(GroupID'=PIADMPGADMDR) 
    q:("ALLI"=GroupID)&(""'=PIADMPGADMDR)
    q:("ALLG"=GroupID)&(""=PIADMPGADMDR)

	s PIADMPGADMDRName=""
	i ""'=PIADMPGADMDR  d
	.//PGADM_PGBI_DR DHC_PE_PreGADM
	.s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PIADMPGADMDR)),"^",1)
	.i ""'=PGADMPGBIDR d
	..//DHC_PE_PreGBaseInfo 2.1
	..s PIADMPGADMDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
	s iLLoop=iLLoop+1
	// PIADM_PGTeam_DR 对应组ADM
	s PIADMPGTeamDR=$p(CurData,"^",iLLoop)
	//PGT_ParRef
	s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	//PGT_ChildSub
	s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	i ""'=PIADMPGTeamDR  d 
	.s PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	e  d
	.s PIADMPGTeamDRName=""
	s iLLoop=iLLoop+1
	// PIADM_PEDateBegin	预约体检日期 4
	s PIADMPEDateBegin=$p(CurData,"^",iLLoop)
	//Q:(""'=PEDate)&(+PEDate<+PIADMPEDateBegin)
	//i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	s iLLoop=iLLoop+1

	s iLLoop=iLLoop+1
	// PIADM_PETime	预约体检时间 5
	s PIADMPETime=$p(CurData,"^",iLLoop)
	Q:(""'=PETime)&(PETime'=PIADMPETime)
	//i ""'=PIADMPETime s PIADMPETime=$ZT(PIADMPETime,2)
	i ""'=PIADMPETime s PIADMPETime=##class(websys.Conversions).TimeLogicalToHtml(PIADMPETime)
	s iLLoop=iLLoop+1
	
	// PIADM_PEDeskClerk_DR	预约接待人员 6
	s PIADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
	i ""'=PIADMPEDeskClerkDR d
	.s PIADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PIADMPEDeskClerkDR)),"^",2)
	e  d
	.s PIADMPEDeskClerkDRName=""
	s iLLoop=iLLoop+1
	// PIADM_Status	登记状态 7
	s PIADMStatus=$p(CurData,"^",iLLoop)
	S LocID=$P($g(^DHCPEPreIADM(id)),"^",26)
	//q:(($G(^DHCPESetting("DHCPE","HospitalCode",LocID))="SYYD")&&(PIADMStatus="CANCELPE"))
	q:(""'=Status)&(Status'[("^"_PIADMStatus_"^"))
	s PEADMID=$o(^DHCPEIADM(0,"CRMADM",id,0))
	s PEStatus=""
	i PEADMID'="" s PEStatus=$p(^DHCPEIADM(PEADMID),"^",8)
	s TRoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",id)) //诊室位置
	q:(RoomPlace'="")&&(RoomPlace'=TRoomPlace)
	;s:TRoomPlace'="" TRoomPlace=$P(^DHCPECTDataEx("RoomPlace",TRoomPlace),"^",2)
	s:TRoomPlace'="" TRoomPlace=$lg($g(^CF.PE.RoomPlaceD(TRoomPlace)),3) //诊室位置表 DHC_PE_RoomPlace
	i PIADMStatus="CANCELPE"  s TRoomPlace=""
	q:((PEStatus="CANCELARRIVED")&(Status'=""))&(Status'[("^"_PEStatus_"^"))
	s PIADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PIADMStatus)
	s AdmDate=""
	i PEADMID'="" d
	.s AdmDate=$p($g(^DHCPEIADM(PEADMID)),"^",5)
   .i AdmDate'="" s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	
	//就餐
	;s Diet=$p(CurData,"^",17)
	s Diet=""
	s Diet=##class(web.DHCPE.PreIADM).GetDietFlagByID(id)
	//应收金额
	s Amount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(id)
	s AccountAmount=+$p(Amount,"^",1)
	i $p(AccountAmount,".",1)="" s AccountAmount=0_AccountAmount
	s AccountAmount=$fn(AccountAmount,"",2)

	//最终金额
	s FactAmount=+$p(Amount,"^",2)
	i $p(FactAmount,".",1)="" s FactAmount=0_FactAmount
	s FactAmount=$fn(FactAmount,"",2)


	s iLLoop=iLLoop+1
	s ReportStatus="未初检"      
	s TBLPrtFlag="N",TPatItemPrtFlag="N"
	s CheckDate=""
	s PAADM=""
	i PEADMID'=""  d 
	.s RPId=$o(^DHCPERPT(0,"IADM",PEADMID,0))
	.s PAADM=$p(^DHCPEIADM(PEADMID),"^",1)
	.q:PAADM=""
	.s ReportStatus=$p(^DHCPERPT(RPId),"^",2)
	.s ReportStatus=##class(web.DHCPE.Report).GetStatusDesc(ReportStatus,PAADM)
	.;单据打印状态
	.s TBLPrtFlag=$D(^DHCPESpecialReportPrintRecord(PAADM, "DHCPEPISRequest"))
	.s:TBLPrtFlag'=0 TBLPrtFlag="Y"
	.S TPatItemPrtFlag="N"
	.S TPatItemPrtFlag=$G(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
	.i TPatItemPrtFlag="" s TPatItemPrtFlag="N"
	.;i TPatItemPrtFlag'=0 s TPatItemPrtFlag="Y"
	.;i TPatItemPrtFlag'=0 s TPatItemPrtFlag="1"
	.s ReportID=""
	.i RPId'="" d
	..s ReportID=$p(^DHCPERPT(RPId),"^",2)
	.s ReportStatus=##class(web.DHCPE.Report).GetStatusDesc(ReportID,PAADM)   
	.s RID=$o(^DHCPERLT(0,"ADM",PAADM,0))
	.i RID'="" s CheckDate=$p($G(^DHCPERLT(RID)),"^",6) //检查时间
	.i CheckDate'="" s CheckDate=##class(websys.Conversions).DateLogicalToHtml(CheckDate)
	
	// PIADM_AsCharged	视同收费 8
	s PIADMAsCharged=$p(CurData,"^",iLLoop)
	i PIADMAsCharged="N" S PIADMAsCharged="否"
	i PIADMAsCharged="Y" S PIADMAsCharged="是"
	s iLLoop=iLLoop+1
	// 允许加项	PIADM_AddOrdItem	19
	s PIADMAddOrdItem = $p(CurData,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	// 加项金额限制	PIADM_AddOrdItemLimit 20
	s PIADMAddOrdItemLimit = $p(CurData,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	// 允许加项金额	PIADM_AddOrdItemAmount 21
	s PIADMAddOrdItemAmount = $p(CurData,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	// 允许加药	PIADM_AddPhcItem 22
	s PIADMAddPhcItem = $p(CurData,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	// 加药金额限制	PIADM_AddPhcItemLimit 23
	s PIADMAddPhcItemLimit = $p(CurData,"^",iLLoop)
	s iLLoop=iLLoop+1
	
	// 允许加药金额	PIADM_AddPhcItemAmount 24
	s PIADMAddPhcItemAmount = $p(CurData,"^",iLLoop)
	s iLLoop=iLLoop+1
	// 个人报告发送	PIADM_IReportSend 25
	s PIADMIReportSend = $p(CurData,"^",iLLoop)
	s:(""'=PIADMIReportSend) PIADMIReportSendDesc=""
	s:(""'=PIADMIReportSend) PIADMIReportSendDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMIReportSend)
	s iLLoop=iLLoop+1
	// 结算方式	PIADM_DisChargedMode 26
	s PIADMDisChargedMode = $p(CurData,"^",iLLoop)
	s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=""
	s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMDisChargedMode)
	s iLLoop=iLLoop+1
	s TType=$p(CurData,"^",25)
	s TType=##class(web.DHCPE.PreCommon).GetPreTypeDesc(TType)
	
	s PIADMChargedStatusDesc=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(id)
	q:(ChargedStatus'="")&&(ChargedStatus'=PIADMChargedStatusDesc)
	s PIADMChargedStatusDesc=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlagDesc(PIADMChargedStatusDesc)
	// PIADM_VIP 28
	s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",id)
	s TVIPlevel=$P(PIADMVIP,"^",1)
	q:(VIPLevel'="")&&(VIPLevel'=TVIPlevel)
	s PIADMVIP=$P(PIADMVIP,"^",2)
	i PIADMVIP'="" s ^TempDHCPEPerIADMVIP(Job,PIADMVIP)=+$G(^TempDHCPEPerIADMVIP(Job,PIADMVIP))+1
	s iLLoop=iLLoop+1
	// PIADM_Remark
	s PIADMRemark = $p(CurData,"^",iLLoop+1)
	s iLLoop=iLLoop+1
	s PIADMOldHPNo=""
	s:(PIBIPAPMINo'="") PIADMOldHPNo=$g(^DHCPETempHPNo(PIBIPAPMINo))
	s iLLoop=iLLoop+1

	s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",id))
	i ReportDate'="" d
	.s $P(ReportDate,"^",1)=##class(websys.Conversions).DateLogicalToHtml($P(ReportDate,"^",1))
	.s $P(ReportDate,"^",2)=##class(websys.Conversions).TimeLogicalToHtml($P(ReportDate,"^",2))
	s TGetReportDate=$P(ReportDate,"^",1)
	s TPayType=$G(^DHCPEDataEx("DHCPEPreIADM","PayType",id))
	s TPayType=##class(web.DHCPE.PreCommon).GetPayTypeDesc(TPayType)
	s Percent=$G(^DHCPEDataEx("DHCPEPreIADM","Percent",id))
	s:Percent'="" Percent=" ("_Percent_"%)"
	s TPayType=TPayType_Percent
	s TNewHPNo=$p(CurData,"^",27)
	S TOrdEnt=""
	s TOrdEnt=##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(id)
	s AsInfo=$G(^DHCPEDataEx("AsCharged","I",id))
	s AsType=##class(web.DHCPE.PreIADMEx).GetAsTypeDesc($P(AsInfo,"^",1))
	s PIADMRemark=$P(AsInfo,"^",2)
	;i AsRemark'="" s AsType=AsType_"("_AsRemark_")"
	;s TMark=$g(^DHCPEDataEx("Mark","I",id))
	s TMark=$p($g(^DHCPEPreIADM(id)),"^",20)
	s:PIADMPIBIDRSEX'="" ^TempDHCPEPerIADM(Job,PIADMPIBIDRSEX)=+$G(^TempDHCPEPerIADM(Job,PIADMPIBIDRSEX))+1
	Do FindBuild
	q
	
FindBuild   

    /***翻译 start***/
	s PIADMPIBIDRSEX=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PIADMPIBIDRSEX,"CTSEXDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
    s PIADMVIP=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",PIADMVIP,"VLDesc","cls")
    s PIBIMarriedDRName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTMarital",PIBIMarriedDRName,"CTMARDesc","cls")
    s TRoomPlace=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPERoomPlace",TRoomPlace,"RPDesc","cls")
    s PIADMChargedStatusDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp",PIADMChargedStatusDesc)
    s PIADMAsCharged=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp",PIADMAsCharged)
    s PIADMStatusDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp",PIADMStatusDesc)
    s ReportStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp",ReportStatus)
    s AsType=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpepreiadmfind.hisui.csp",AsType)
    /***翻译 end***/
	set Data=$lb($g(id), PIADMPIBIDR, PIBIPAPMINo, PIADMPIBIDRName, PIADMPGADMDR, PIADMPGADMDRName, PIADMPGTeamDR, PIADMPGTeamDRName, PIADMPEDateBegin, PIADMPEDateEnd, PIADMPETime, PIADMPEDeskClerkDR, PIADMPEDeskClerkDRName, PIADMStatus, PIADMStatusDesc, PIADMAsCharged, PIADMAccountAmount, PIADMDiscountedAmount, PIADMSaleAmount, PIADMFactAmount, PIADMAuditUserDR, PIADMAuditUserDRName, PIADMAuditDate, PIADMUpdateUserDR, PIADMUpdateUserDRName, PIADMUpdateDate, PIADMChargedStatus, PIADMChargedStatusDesc, PIADMCheckedStatus, ReportStatus, PIADMAddOrdItem, PIADMAddOrdItemLimit, PIADMAddOrdItemAmount, PIADMAddPhcItem, PIADMAddPhcItemLimit, PIADMAddPhcItemAmount, PIADMIReportSend, PIADMIReportSenDdesc, PIADMDisChargedMode, PIADMDisChargedModeDesc, PIADMVIP,PIADMRemark,PIADMOldHPNo,ind,TGetReportDate,TType,TPayType,PIBIIDCard,PGBITel,TAge,PIADMPIBIDRSEX,TPosition,PAADM,TBLPrtFlag,TNewHPNo,TOrdEnt,TPatItemPrtFlag,AsType,TRoomPlace,TMark,AdmDate,AccountAmount,FactAmount,ReportStatus,Diet,PACCardDesc,PIBIMarriedDRName,CheckDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreIADMExecute ]
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

ClassMethod SearchPreIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取套餐
ClassMethod GetOrdEntByPIAdm(PreIAdm As %String)
{
	q:PreIAdm="" ""
	s ARCOSDesc=""
	s PIOESub=0
	f  s PIOESub=$o(^DHCPEPreIADM(PreIAdm,"ORDENT", PIOESub))  q:PIOESub=""  d
    .s OrderSetsDR=$p($g(^DHCPEPreIADM(PreIAdm,"ORDENT", PIOESub)),"^",1)
    .q:OrderSetsDR=""
    .s OEItemStat=$p($g(^DHCPEPreIADM(PreIAdm,"ORDENT", PIOESub)),"^",9)
    .Q:OEItemStat'=1 //医嘱套状态过滤
    .S ARCOSDesc=$P($g(^ARCOS(OrderSetsDR)),"^",2)
    q ARCOSDesc
}

/// 获取团体组的人员列表
Query SearchGTeamIADM(GTeam As %String = "", RegNo As %String = "", Name As %String = "", DepartName As %String = "", OperType As %String = "", Status As %String = "") As %Query(ROWSPEC = "PIADM_RowId:%String, PIADM_PIBI_DR:%String, PIADM_PIBI_DR_RegNo:%String, PIADM_PIBI_DR_Name:%String, PIADM_PGADM_DR:%String, PIADM_PGADM_DR_Name:%String, PIADM_PGTeam_DR:%String, PIADM_PGTeam_DR_Name:%String, PIADM_PEDateBegin:%String, PIADM_PEDateEnd:%String, PIADM_PETime:%String, PIADM_PEDeskClerk_DR:%String, PIADM_PEDeskClerk_DR_Name:%String, PIADM_Status:%String, PIADM_Status_Desc:%String, PIADM_AsCharged:%String, PIADM_AccountAmount:%String, PIADM_DiscountedAmount:%String, PIADM_SaleAmount:%String, PIADM_FactAmount:%String, PIADM_AuditUser_DR:%String, PIADM_AuditUser_DR_Name:%String, PIADM_AuditDate:%String, PIADM_UpdateUser_DR:%String, PIADM_UpdateUser_DR_Name:%String, PIADM_UpdateDate:%String, PIADM_ChargedStatus:%String, PIADM_ChargedStatus_Desc:%String, PIADM_CheckedStatus:%String, PIADM_CheckedStatus_Desc:%String, PIADM_AddOrdItem:%String, PIADM_AddOrdItemLimit:%String, PIADM_AddOrdItemAmount:%String, PIADM_AddPhcItem:%String, PIADM_AddPhcItemLimit:%String, PIADM_AddPhcItemAmount:%String, PIADM_IReportSend:%String, PIADM_IReportSend_Desc:%String, PIADM_DisChargedMode:%String, PIADM_DisChargedMode_Desc:%String, PIADM_VIP:%String,PIADMRemark:%String,TArriveDate:%String,TType:%String,Sequence:%String,Amount:%String,TNewHPNo:%String,IDCard:%String,PACCardDesc:%String")
{
}

ClassMethod SearchGTeamIADMExecute(ByRef qHandle As %Binary, GTeam As %String = "", RegNo As %String = "", Name As %String, DepartName As %String = "", OperType As %String = "", Status As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	if (""=GTeam) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s:Status="^" Status=""
	If Status="" Set Status="^PREREG^PREREGED^REGISTERED^ARRIVED^CANCELPREREG^CANCELARRIVED^"

 	s ind=1 	
 	s id=""	//不能使用空字符串开始 s id="" ,否则会取到 0
	//s Sequence=0
	f  s id=$o(^DHCPEPreIADM(0,"PGTeam",GTeam,id),-1) q:(id="")||(id=0)  d
	.s TPosition=##class(web.DHCPE.PreCommon).GetPosition("PreADM",id)
	.q:(DepartName'="")&&(TPosition'[DepartName)
	.s CurData=$G(^DHCPEPreIADM(id))
	.//s Sequence=Sequence+1
	.s iLLoop=1
	.// PIADM_PIBI_DR 预登记个人基本信息号 1
	.s PIADMPIBIDR=$p(CurData,"^",iLLoop)
	.//Q:(""=PIADMPIBIDR)	//防止取到空数据
	.
	.// PIBI_PAPMINo 登记号 DHC_PE_PreIBaseInfo 1.1
	.i ""'=PIADMPIBIDR  d
	..s PIBIPAPMINo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
	.e  d
	..s PIBIPAPMINo=""
	.Q:(""'=RegNo)&('(PIBIPAPMINo[RegNo)) //数据过滤
	.//证件类型 证件号
	.s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
	.i PIBIPAPMINo'="" d
	..S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PAT",3)),"^",7)
	..I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	..s PIBIIDCard=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",PIBIPAPMINo,0)),"PAT",3)),"^",6)

	.//PIBI_Name	姓名 1.2
	.s PIADMPIBIDRName=""
	.i ""'=PIADMPIBIDR  d
	..s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	.Q:(""'=Name)&('(PIADMPIBIDRName[Name))
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PGADM_DR 对应团体的ADM 2
	.s PIADMPGADMDR=$p(CurData,"^",iLLoop)
	.//Q:(""'=PIADMPGADMDR)  //只查询个人登记信息
	.s PIADMPGADMDRName=""
	.i ""'=PIADMPGADMDR  d
	..//PGADM_PGBI_DR DHC_PE_PreGADM
	..s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PIADMPGADMDR)),"",1)
	..i ""'=PGADMPGBIDR d
	...//DHC_PE_PreGBaseInfo 2.1
	...s PIADMPGADMDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"",2)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PGTeam_DR 对应组ADM	 3 DHC_PE_PreGTeam
	.s PIADMPGTeamDR=$p(CurData,"^",iLLoop)
	.//PGT_ParRef
	.s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	.//PGT_ChildSub
	.s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	.i ""'=PIADMPGTeamDR  d  //3.1
	..s PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	.e  d
	..s PIADMPGTeamDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDateBegin	预约体检日期 4
	.s PIADMPEDateBegin=$p(CurData,"^",iLLoop)
	.//Q:(""'=PEDate)&(+PEDate<+PIADMPEDateBegin)
	.i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	.s iLLoop=iLLoop+1
	.// PIADM_PEDateEnd	预约体检日期 27
	.s PIADMPEDateEnd=$p(CurData,"^",iLLoop)
	.//Q:(""'=PEDate)&(+PEDate>+PIADMPEDateEnd)
	.i ""'=PIADMPEDateEnd s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	.s iLLoop=iLLoop+1
	.// PIADM_PETime	预约体检时间 5
	.s PIADMPETime=$p(CurData,"^",iLLoop)
	.//Q:(""'=PETime)&(PETime'=PIADMPETime)
	.i ""'=PIADMPETime s PIADMPETime=$ZT(PIADMPETime,2)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDeskClerk_DR	预约接待人员 6
	.s PIADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMPEDeskClerkDR d
	..s PIADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PIADMPEDeskClerkDR)),"^",2)
	.e  d
	..s PIADMPEDeskClerkDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_Status	登记状态 7
	.s PIADMStatus=$p(CurData,"^",iLLoop)
	.q:PIADMStatus="CANCELPE"
	.Q:(""'=Status)&(Status'[("^"_PIADMStatus))
	.s PIADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PIADMStatus)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AsCharged	视同收费 8
	.s PIADMAsCharged=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.// 允许加项	PIADM_AddOrdItem	19
	.s PIADMAddOrdItem = $p(CurData,"^",iLLoop)
	.i PIADMAddOrdItem="N" s PIADMAddOrdItem="否"
	.e  s PIADMAddOrdItem="是"
	.s iLLoop=iLLoop+1
	.
	.// 加项金额限制	PIADM_AddOrdItemLimit 20
	.s PIADMAddOrdItemLimit = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加项金额	PIADM_AddOrdItemAmount 21
	.s PIADMAddOrdItemAmount = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加药	PIADM_AddPhcItem 22
	.s AddPhcItem = $p(CurData,"^",iLLoop)
	.i AddPhcItem="N" s PIADMAddPhcItem="否"
	.e  s PIADMAddPhcItem="是"
	.s iLLoop=iLLoop+1
	.
	.// 加药金额限制	PIADM_AddPhcItemLimit 23
	.s PIADMAddPhcItemLimit = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加药金额	PIADM_AddPhcItemAmount 24
	.s PIADMAddPhcItemAmount = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 个人报告发送	PIADM_IReportSend 25
	.s PIADMIReportSend = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMIReportSend) PIADMIReportSendDesc=""
	.s:(""'=PIADMIReportSend) PIADMIReportSendDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMIReportSend)
	.s iLLoop=iLLoop+1
	.
	.// 结算方式	PIADM_DisChargedMode 26
	.s PIADMDisChargedMode = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=""
	.s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMDisChargedMode)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_VIP 28
	.s PIADMVIP = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.s TType=$p(CurData,"^",25)
	.s TType=##class(web.DHCPE.PreCommon).GetPreTypeDesc(TType)
	.// PIADM_Remark
	.s PIADMRemark = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.s ArriveDate=""
	.s PEIADM=$o(^DHCPEIADM(0,"CRMADM",id,0))
	.i PEIADM'="" d
	..s ArriveDate=$P(^DHCPEIADM(PEIADM),"^",5)
	..i (ArriveDate'="")&&(PIADMStatus="ARRIVED") s ArriveDate=##class(websys.Conversions).DateLogicalToHtml(ArriveDate)
	..i PIADMStatus'="ARRIVED" s ArriveDate=""
	.s Amount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(id)
	.s Amount=$p(Amount,"^",2)
	.s PaiedFlag=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlag(id)
	.s PaiedFlag=##class(web.DHCPE.HandlerPreOrds).GetPaiedFlagDesc(PaiedFlag)
	.s Amount=Amount_"("_PaiedFlag_")"
	.s TNewHPNo=$p(CurData,"^",27)
	.d GTeamListOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GTeamListOutput      
	set Data=$lb($g(id), PIADMPIBIDR, PIBIPAPMINo, PIADMPIBIDRName, PIADMPGADMDR, PIADMPGADMDRName, PIADMPGTeamDR, PIADMPGTeamDRName, PIADMPEDateBegin, PIADMPEDateEnd, PIADMPETime, PIADMPEDeskClerkDR, PIADMPEDeskClerkDRName, PIADMStatus, PIADMStatusDesc, PIADMAsCharged, PIADMAccountAmount, PIADMDiscountedAmount, PIADMSaleAmount, PIADMFactAmount, PIADMAuditUserDR, PIADMAuditUserDRName, PIADMAuditDate, PIADMUpdateUserDR, PIADMUpdateUserDRName, PIADMUpdateDate, PIADMChargedStatus, PIADMChargedStatusDesc, PIADMCheckedStatus, PIADMCheckedStatusDesc, PIADMAddOrdItem, PIADMAddOrdItemLimit, PIADMAddOrdItemAmount, PIADMAddPhcItem, PIADMAddPhcItemLimit, PIADMAddPhcItemAmount, PIADMIReportSend, PIADMIReportSenDdesc, PIADMDisChargedMode, PIADMDisChargedModeDesc, PIADMVIP,PIADMRemark,ArriveDate,TType,ind,Amount,TNewHPNo,PIBIIDCard,PACCardDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGTeamIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGTeamIADMExecute ]
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

ClassMethod SearchGTeamIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGTeamIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查找指定日期内预约团体或团体组的成员
/// 使用模块：
/// 		体检排期(DHCPEBookingPlan.Result.csp)
/// 当 SearchType=G 时查找团体所有的成员
/// 当 SearchType=T 时查找团体组的成员
/// 当 SearchType=G 且 GTId=I 时查找散客
/// d ##Class(%ResultSet).RunQuery("web.DHCPE.PreIADM","SearchGADMPatient","I","01/09/2006","G")
Query SearchGADMPatient(GTId As %String = "", BookingDate As %String = "", BookingName As %String = "", SearchType As %String = "") As %Query(ROWSPEC = "PIADM_RowId:%String, PIADM_PIBI_DR:%String, PIADM_PIBI_DR_RegNo:%String, PIADM_PIBI_DR_Name:%String, PIADM_PGADM_DR:%String, PIADM_PGADM_DR_Name:%String, PIADM_PGTeam_DR:%String, PIADM_PGTeam_DR_Name:%String, PIADM_PEDateBegin:%String, PIADM_PEDateEnd:%String, PIADM_PETime:%String, PIADM_PEDeskClerk_DR:%String, PIADM_PEDeskClerk_DR_Name:%String, PIADM_Status:%String, PIADM_Status_Desc:%String, PIADM_AsCharged:%String, PIADM_AccountAmount:%String, PIADM_DiscountedAmount:%String, PIADM_SaleAmount:%String, PIADM_FactAmount:%String, PIADM_AuditUser_DR:%String, PIADM_AuditUser_DR_Name:%String, PIADM_AuditDate:%String, PIADM_UpdateUser_DR:%String, PIADM_UpdateUser_DR_Name:%String, PIADM_UpdateDate:%String, PIADM_ChargedStatus:%String, PIADM_ChargedStatus_Desc:%String, PIADM_CheckedStatus:%String, PIADM_CheckedStatus_Desc:%String, PIADM_AddOrdItem:%String, PIADM_AddOrdItemLimit:%String, PIADM_AddOrdItemAmount:%String, PIADM_AddPhcItem:%String, PIADM_AddPhcItemLimit:%String, PIADM_AddPhcItemAmount:%String, PIADM_IReportSend:%String, PIADM_IReportSend_Desc:%String, PIADM_DisChargedMode:%String, PIADM_DisChargedMode_Desc:%String, PIADM_VIP:%String")
{
}

ClassMethod SearchGADMPatientExecute(ByRef qHandle As %Binary, GTId As %String = "", BookingDate As %String = "", BookingName As %String = "", SearchType As %String = "") As %Status
{


	Set repid=$I(^CacheTemp)
	if (""=GTId) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
 	s ind=1
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
	s PersonTotal=+0
	
	// 团体组
	i "T"=SearchType d
	.f  s id=$o(^DHCPEPreIADM(0,"PGTeam",GTId,id)) q:id=""  d
	..s ^xwmtest("SearchGADMPatient",$j,id)=id
	..s PersonTotal=+PersonTotal+1
	
	// 团体
	i ("G"=SearchType)&("I"'=GTId) d
	.f  s id=$o(^DHCPEPreIADM(0,"PGADM",GTId,id)) q:id=""  d
	..s ^xwmtest("SearchGADMPatient",$j,id)=id
	..s PersonTotal=+PersonTotal+1	
	
	i ""'=BookingDate s BookingDate=$ZDH(BookingDate,4)
	
	// 散客
	i ("G"=SearchType)&("I"=GTId)&(""'=BookingDate) d
	.f  s id=$O(^DHCPEPreIADM(id)) q:id=""  d
	..Q:((BookingDate'="")&(BookingDate'=$P($G(^DHCPEPreIADM(id)),"^",4)))
	..
	..// 过滤团体客户
	..Q:(""'=$P($G(^DHCPEPreIADM(id)),"^",2))
	..s ^xwmtest("SearchGADMPatient",$j,id)=id
	..s PersonTotal=+PersonTotal+1
	
	// 按预约人查找
	i ("A"=SearchType)&(""'=BookingName) d
	.
	.f  s id=$O(^DHCPEPreIADM(id)) q:id=""  d
	..
	..// 日期
	..Q:((""'=BookingDate)&(BookingDate'=$P($G(^DHCPEPreIADM(id)),"^",4)))
	..
	..// 人名
	..s PIADMPIBIDR=$P($G(^DHCPEPreIADM(id)),"^",1)
	..Q:(""=PIADMPIBIDR)
	..s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	..Q:((""'=BookingName)&(PIADMPIBIDRName'[BookingName))
	..
	..s ^xwmtest("SearchGADMPatient",$j,id)=id
	..
	..s PersonTotal=+PersonTotal+1	
	
	s id="0"
	f  s id=$o(^xwmtest("SearchGADMPatient",$j,id)) q:id=""  d
	.s CurData=$g(^DHCPEPreIADM(id))
	.
	.s iLLoop=1
	.// PIADM_PIBI_DR 预登记个人基本信息号 1
	.s PIADMPIBIDR=$p(CurData,"^",iLLoop)
	.// PIBI_PAPMINo 登记号 DHC_PE_PreIBaseInfo
	.i ""'=PIADMPIBIDR  d
	..s PIBIPAPMINo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
	.e  d
	..s PIBIPAPMINo=""
	.//PIBI_Name	姓名
	.s PIADMPIBIDRName=""
	.i ""'=PIADMPIBIDR  d
	..s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PGADM_DR 对应团体的ADM 2
	.s PIADMPGADMDR=$p(CurData,"^",iLLoop)
	.b 
	.i ""'=PIADMPGADMDR  d
	..//PGADM_PGBI_DR DHC_PE_PreGADM
	..s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PIADMPGADMDR)),"^",1)
	..b // w id,PGADMPGBIDR
	..i ""'=PGADMPGBIDR d
	...//DHC_PE_PreGBaseInfo
	...s PIADMPGADMDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
	..e  d
	...s PIADMPGADMDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PGTeam_DR 对应组ADM	 3
	.s PIADMPGTeamDR=$p(CurData,"^",iLLoop)
	.//PGT_ParRef
	.s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	.//PGT_ChildSub
	.s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	.i ""'=PIADMPGTeamDR  d
	..s PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	.e  d
	..s PIADMPGTeamDRName=""
	.s iLLoop=iLLoop+1
	.
	.
	.// PIADM_PEDate	预约体检日期 4
	.s PIADMPEDate=$p(CurData,"^",iLLoop)
	.i ""'=PIADMPEDate s PIADMPEDate=$ZD(PIADMPEDate,4)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PETime	预约体检时间 5
	.s PIADMPETime=$p(CurData,"^",iLLoop)
	.i ""'=PIADMPETime s PIADMPETime=$ZT(PIADMPETime,2)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDeskClerk_DR	预约接待人员 6
	.s PIADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMPEDeskClerkDR d
	..s PIADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PIADMPEDeskClerkDR)),"^",2)
	.e  d
	..s PIADMPEDeskClerkDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_Status	登记状态 7
	.s PIADMStatus=$p(CurData,"^",iLLoop)
	.s PIADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PIADMStatus)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AsCharged	视同收费 8
	.s PIADMAsCharged=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AccountAmount	应收金额 9
	.s PIADMAccountAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_DiscountedAmount	打折后金额 10
	.s PIADMDiscountedAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_FactAmount	最终金额 11
	.s PIADMFactAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AuditUser_DR	审核人 12
	.s PIADMAuditUserDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMAuditUserDR d
	..s PIADMAuditUserDRName=$p($g(^SSU("SSUSR",PIADMAuditUserDR)),"^",2)
	.e  d
	..s PIADMAuditUserDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AuditDate	审核日期 13
	.s PIADMAuditDate=$p(CurData,"^",iLLoop)
	.i ""'=PIADMAuditDate s PIADMAuditDate=$ZD(PIADMAuditDate,4)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_UpdateUser_DR 14
	.s PIADMUpdateUserDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMUpdateUserDR d
	..s PIADMUpdateUserDRName=$p($g(^SSU("SSUSR",PIADMUpdateUserDR)),"^",2)
	.e  d
	..s PIADMUpdateUserDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_UpdateDate 15
	.s PIADMUpdateDate=$p(CurData,"^",iLLoop)
	.i ""'=PIADMUpdateDate s PIADMUpdateDate=$ZD(PIADMUpdateDate,4)
	.s iLLoop=iLLoop+1
	.
	.//PIADM_SaleAmount	销售金额 16
	.s PIADMSaleAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.	
	.// 收费状态	PIADM_ChargedStatus	17
	.s PIADMChargedStatus = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMChargedStatus) PIADMChargedStatusDesc=""
	.s:(""'=PIADMChargedStatus) PIADMChargedStatusDesc=##Class(web.DHCPE.PreCommon).TransChargedStatus(PIADMChargedStatus)
	.s iLLoop=iLLoop+1
	.
	.// 审核状态	PIADM_CheckedStatus	18
	.s PIADMCheckedStatus = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMCheckedStatus) PIADMCheckedStatusDesc=""
	.s:(""'=PIADMCheckedStatus) PIADMCheckedStatusDesc=##Class(web.DHCPE.PreCommon).TransCheckedStatus(PIADMCheckedStatus)
	.s iLLoop=iLLoop+1
	.
	.// 允许加项	PIADM_AddOrdItem	19
	.s PIADMAddOrdItem = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 加项金额限制	PIADM_AddOrdItemLimit 20
	.s PIADMAddOrdItemLimit = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加项金额	PIADM_AddOrdItemAmount 21
	.s PIADMAddOrdItemAmount = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加药	PIADM_AddPhcItem 22
	.s PIADMAddPhcItem = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 加药金额限制	PIADM_AddPhcItemLimit 23
	.s PIADMAddPhcItemLimit = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加药金额	PIADM_AddPhcItemAmount 24
	.s PIADMAddPhcItemAmount = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 个人报告发送	PIADM_IReportSend 25
	.s PIADMIReportSend = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMIReportSend) PIADMIReportSendDesc=""
	.s:(""'=PIADMIReportSend) PIADMIReportSendDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMIReportSend)
	.s iLLoop=iLLoop+1
	.
	.// 结算方式	PIADM_DisChargedMode 26
	.s PIADMDisChargedMode = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=""
	.s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMDisChargedMode)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDateEnd	预约体检日期 27
	.s PIADMPEDateEnd=$p(CurData,"^",iLLoop)
	.i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_VIP 28
	.s PIADMVIP= $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.d SearchGADMPatientOutput
	
	k ^xwmtest("SearchGADMPatient")
	s id="" 
	s PIADMPIBIDR="" 
	s PIBIPAPMINo="总计" 
	s PIADMPIBIDRName=PersonTotal_"个客户" 
	s PIADMPGADMDR="" 
	s PIADMPGADMDRName="" 
	s PIADMPGTeamDR="" 
	s PIADMPGTeamDRName="" 
	s PIADMPEDate="" 
	s PIADMPETime="" 
	s PIADMPEDeskClerkDR="" 
	s PIADMPEDeskClerkDRName="" 
	s PIADMStatus="" 
	s PIADMStatusDesc="" 
	s PIADMAsCharged=""
	s PIADMAccountAmount="" 
	s PIADMDiscountedAmount="" 
	s PIADMSaleAmount="" 
	s PIADMFactAmount="" 
	s PIADMAuditUserDR="" 
	s PIADMAuditUserDRName="" 
	s PIADMAuditDate="" 
	s PIADMUpdateUserDR="" 
	s PIADMUpdateUserDRName="" 
	s PIADMUpdateDate=""
	s PIADMChargedStatus=""
	s PIADMCheckedStatus =""
	s PIADMAddOrdItem = ""
	s PIADMAddOrdItemLimit = ""
	s PIADMAddOrdItemAmount = ""
	s PIADMAddPhcItem = ""
	s PIADMAddPhcItemLimit = ""
	s PIADMAddPhcItemAmount = ""
	s PIADMIReportSend = ""
	s PIADMDisChargedMode = ""
	s PIADMPEDateEnd=""
	s PIADMVIP=""
	d SearchGADMPatientOutput
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SearchGADMPatientOutput
				 
	set Data=$lb($g(id), PIADMPIBIDR, PIBIPAPMINo, PIADMPIBIDRName, PIADMPGADMDR, PIADMPGADMDRName, PIADMPGTeamDR, PIADMPGTeamDRName, PIADMPEDateBegin, PIADMPEDateEnd, PIADMPETime, PIADMPEDeskClerkDR, PIADMPEDeskClerkDRName, PIADMStatus, PIADMStatusDesc, PIADMAsCharged, PIADMAccountAmount, PIADMDiscountedAmount, PIADMSaleAmount, PIADMFactAmount, PIADMAuditUserDR, PIADMAuditUserDRName, PIADMAuditDate, PIADMUpdateUserDR, PIADMUpdateUserDRName, PIADMUpdateDate, PIADMChargedStatus, PIADMChargedStatusDesc, PIADMCheckedStatus, PIADMCheckedStatusDesc, PIADMAddOrdItem, PIADMAddOrdItemLimit, PIADMAddOrdItemAmount, PIADMAddPhcItem, PIADMAddPhcItemLimit, PIADMAddPhcItemAmount, PIADMIReportSend, PIADMIReportSenDdesc, PIADMDisChargedMode, PIADMDisChargedModeDesc, PIADMVIP)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGADMPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGADMPatientExecute ]
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

ClassMethod SearchGADMPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGADMPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 使用组件	 DHCPEPreIADM.Edit 个人预约 
/// 			 DHCPEPreIADM.GTEdit 团体客户预约修改 
/// 			 DHCPEPreIADM.Team 小组增加人员 
/// d UpdatePatInfo^DHCOPUpdatePatInfo(IDrowid, Namepar, Sexpar, Birthpar, IDCardNo1, OpMedicare, PatTypeDr, TelNopar, Company)
/// 更新函数
/// test: w ##Class(web.DHCPE.PreIADM).Save("","","^1261^^^14/10/70^14/10/70^^^PREREG^N^N^N^^N^N^^DC^ID^1^^^^^^^^^0^0^^1^^^6") 
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", User As %String = "", DepLoc As %String = "")
{
	new Date,Time,StartDate,EndDate,IID,GID
	s NetPreID=$P(InString,"$$",2)
	s InString=$P(InString,"$$",1)
	;"^1261^^^14/10/70^14/10/70^^^PREREG^N^N^N^^N^N^^DC^ID^1^^^^^^^^^0^0^^1^^^6"
	k PLIST
	i User="" d
	.s:$d(%session) User=%session.Get("LOGON.USERID")
	.s:'$d(%session) User=5918
	s Date=+$H
	s Time=$P($H,",",2)
	s iLLoop=1
	
	// PIADM_RowId 1
	s value=$p(InString,"^",iLLoop)
	s:(""'=value) PLIST(iLLoop)=value
	s IID=value
	s iLLoop=iLLoop+1
	
	//预登记个人基本信息号 PIADM_PIBIDR	2
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//对应团体的ADM PIADM_PGADMDR	3
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s GID=value
	s iLLoop=iLLoop+1
	/*
	i (GID'="")&&(IID="")
	{
		q:..IsNoUseAudit(GID,"PRE","G","CRM") "Err Audit"
	}
	*/
	//对应组ADM PIADM_PGTeamDR	4
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	//i value'=""  s 
	//预约体检日期 PIADM_PEDateBegin	5
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=##class(websys.Conversions).DateHtmlToLogical(value)
	s PLIST(iLLoop)=value
	s StartDate=value
	s iLLoop=iLLoop+1
	
	// 预约体检日期结束 PIADM_PEDateEnd 6
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=##class(websys.Conversions).DateHtmlToLogical(value)
	s PLIST(iLLoop)=value
	s EndDate=value
	s iLLoop=iLLoop+1
	
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=0
	//i StartDate>EndDate q "Err Date"
	
	//预约体检时间 PIADM_PETime	7
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=##class(websys.Conversions).TimeHtmlToLogical(value)
	i value="" s value=$p($H,",",2)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//预约接待人员 PIADM_PEDeskClerk_DR	8
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// PIADM_Status	9  
	s value=$p(InString,"^",iLLoop)
	i '($D(PLIST(1))) s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//视同收费 PIADM_AsCharged	10
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加项	PIADM_AddOrdItem	11
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 加项金额限制	PIADM_AddOrdItemLimit 12
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加项金额	PIADM_AddOrdItemAmount 13
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加药	PIADM_AddPhcItem 14
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 加药金额限制	PIADM_AddPhcItemLimit 15
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加药金额	PIADM_AddPhcItemAmount 16
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 个人报告发送	PIADM_IReportSend 17
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 结算方式	PIADM_DisChargedMode 18
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// VIP PIADM_VIP 19
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// PIADM_DelayDate20
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=$ZTH(value,2)
	//s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//PIADM_Remark21
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	
	s iLLoop=iLLoop+1
	
	s Sales=$p(InString,"^",iLLoop) //22
	
	s PLIST(iLLoop)=User    
	s iLLoop=iLLoop+1   
	s Type=$p(InString,"^",iLLoop) //23
	
	s PLIST(iLLoop)=Date
	s iLLoop=iLLoop+1
	s GetReportDate=$p(InString,"^",iLLoop)  //24
	i GetReportDate'="" s GetReportDate=##class(websys.Conversions).DateHtmlToLogical(GetReportDate)
	
	s PLIST(iLLoop)=Time
	s iLLoop=iLLoop+1
	s GetReportTime=$p(InString,"^",iLLoop)  //25
	i GetReportTime'="" s GetReportTime=$ZTH(GetReportTime)
	i GetReportTime="" s GetReportTime=$p($H,",",2)
	
	
	s PLIST(iLLoop)=Sales 
	//类型
	s iLLoop=iLLoop+1 
	s PLIST(iLLoop)=Type //职务 
	s PayType=$p(InString,"^",iLLoop) //26 类型

	///付款百分比
	;s PLIST(iLLoop)=Type
	s iLLoop=iLLoop+1
	s Percent=$p(InString,"^",iLLoop)  //27
	i DepLoc="" d
	.s:$d(%session) DepLoc=%session.Get("LOGON.CTLOCID")      //add 2009-08-05
	.s:'$d(%session) DepLoc=572
	s PLIST(iLLoop)=DepLoc                
	
	
	//是否给客人吃饭
    s iLLoop=iLLoop+1
	s DietFlag=$p(InString,"^",iLLoop)  //28
    //是否给客人赠品
    s iLLoop=iLLoop+1
    s GiftFlag=$p(InString,"^",iLLoop) //29
    
    s iLLoop=iLLoop+1                    //add by zl20100207  保险公司
    s InsureUnit=$p(InString,"^",iLLoop)  //30
    s iLLoop=iLLoop+1                    //add by zl20100222  病人类型
    s PatType=$p(InString,"^",iLLoop)  //31
  	i PatType="" s PatType=$p($G(^DHCPEPreIBI(PLIST(2))),"^",5)
    s iLLoop=iLLoop+1
    s CheckRoom=$p(InString,"^",iLLoop) //32
    s iLLoop=iLLoop+1
    s Position=$p(InString,"^",iLLoop)  //33
    i Position="" s Position=$p($G(^DHCPEPreIBI(PLIST(2))),"^",11)
    s iLLoop=iLLoop+1
    s ADMFeeType=$p(InString,"^",iLLoop) //34
    s iLLoop=iLLoop+1
    s ReCheckFlag=$p(InString,"^",iLLoop) //35 复检
    s PLIST(29)=ReCheckFlag
    
    s iLLoop=iLLoop+1
    s RoomPlace=$p(InString,"^",iLLoop) //36  检查位置
    //s PLIST(8)=RoomPlace
    
    s ret=..ISave2()
    i NetPreID'="" d
    .i $P(ret,"^",1)=0 d
    ..s InString="1^"_User_"^"_$P(ret,"^",2)
    ..d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateStatus(NetPreID,InString)
	;b ;3
	q ret
}

/// 判断团体是否有可用的审核纪录 0有  1没有
/// AuditType "PRE","ADD";  Type:"I","G"; PreType:"CRM","GI"
ClassMethod IsNoUseAudit(ID, AuditType, Type, PreType)
{
	new AuditID,Statu,Flag,AType,PreID,PeID
	s Flag=1
	s AuditID=0
	i PreType="CRM"
	{
		s PreID=ID
		s PeID=$o(^DHCPEGADM(0,"CRMADM",ID,0))
	}
	else
	{
		s PeID=ID
		s PreID=$p($G(^DHCPEGADM(ID)),"^",2)
	}
	i PreID'="" d
	.f  s AuditID=$o(^DHCPEPreA(0,"CRMADM",Type,PreID,AuditID)) q:(AuditID="")||(Flag=0)  d
	..s Statu=$p($g(^DHCPEPreA(AuditID)),"^",10)
	..q:Statu="Audited"
	..s AType=$p($g(^DHCPEPreA(AuditID)),"^",20)
	..q:AuditType'=AType
	..s Flag=0
	s AuditID=0
	i (PeID'="")&&(Flag=1) d 
	.f  s AuditID=$o(^DHCPEPreA(0,"GIADM",Type,ID,AuditID)) q:(AuditID="")||(Flag=0)  d
	..s Statu=$p($g(^DHCPEPreA(AuditID)),"^",10)
	..q:Statu="Audited"
	..s AType=$p($g(^DHCPEPreA(AuditID)),"^",20)
	..q:AuditType'=AType
	..s Flag=0
	q Flag
}

/// 删除函数
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	// 删除类型
	s DType=$p(InString,"^",1)
	s ID=$p(InString,"^",2)

	//按RowId 删除登记人员
	i ("0"=DType)||(""=DType) s ReturnFlag=..DeleteIADM(ID)
	
	//按患者删除 删除患者的所有登记记录
	i ("1"=DType) s ReturnFlag=..DeletePIBI(ID)
	
	//按团体删除 删除团体所属患者的登记
	i ("2"=DType) s ReturnFlag=..DeleteGADM(ID)
	
	//按团体组删除 删除团体所组属患者的登记
	i ("3"=DType) s ReturnFlag=..DeleteGTeam(ID)
	
	//未找到记录错误 不用处理 
	i "100"=ReturnFlag s ReturnFlag=0
	
	i "0"'=ReturnFlag s ReturnFlag="IADM Err^"_ReturnFlag
	
	Q ReturnFlag
}

/// 按RowId 删除登记人员
ClassMethod DeleteIADM(Rowid As %Library.String = "")
{
	new GID
	TSTART
	//TS
		// DHC_PE_PreIADM.{PIADM_PGTeam_DR} 团体组ID
		//s GTeamDR=$p($G(^DHCPEPreIADM(Rowid)),"^",3)
		s GID=$p($G(^DHCPEPreIADM(Rowid)),"^",2)
		&sql(delete from DHC_PE_PreIADM where PIADM_RowId=:Rowid)
		i "0"'=SQLCODE goto DeleteIADMErr
		
		//删除个人审核纪录0406
		s SQLCODE=..DeletePreAudit(Rowid,1)
		i "0"'=SQLCODE goto DeleteIADMErr
		
		///更新团体审核记录金额0406
		s SQLCODE=..UpdateGroupAuditAmount(GID)
		i SQLCODE goto DeleteIADMErr
		/*0331
		// 如果是团体组组成员，更新团体应收金额
		i ""'=GTeamDR d
		.s Ret=##Class(web.DHCPE.PreItemList).UpdateAmount(GTeamDR,"TEAM")
		.i ""'=Ret goto DeleteIADMErr
		.s SQLCODE=0
		*/
	TCOMMIT
	//TC
		Q SQLCODE
DeleteIADMErr
	TROLLBACK
	//TS	
		Q SQLCODE
}

/// 删除患者登记  
ClassMethod DeletePIBI(PIADMPIBIDR As %Library.String = "")
{
	&sql(delete from DHC_PE_PreIADM where PIADM_PIBI_DR= :PIADMPIBIDR)
	q SQLCODE
}

/// 删除团体患者
ClassMethod DeleteGADM(PIADMPGADMDR As %Library.String = "")
{
	//删除团体审核纪录0406
	&SQL(delete from sqluser.DHC_PE_PreAudit where PA_ADMType='G' and PA_CRMADM=:PIADMPGADMDR)
	i SQLCODE<0 q SQLCODE
	//删除团体里面个人的审核纪录0406
	&SQL(delete from sqluser.DHC_PE_PreAudit where PA_ADMType='I' and PA_CRMADM in (select PIADM_RowId from sqluser.DHC_PE_PreIADM where PIADM_PGADM_DR=:PIADMPGADMDR))
	i SQLCODE<0 q SQLCODE
	&sql(delete from DHC_PE_PreIADM where PIADM_PGADM_DR= :PIADMPGADMDR)
	i SQLCODE=100 s SQLCODE=0
	q SQLCODE
}

/// 删除组成员 
ClassMethod DeleteGTeam(PIADMPGTeamDR As %Library.String = "")
{
	//删除组里面个人的审核纪录
	new GID
	s GID=$p(PIADMPGTeamDR,"||",1)
	&SQL(delete from sqluser.DHC_PE_PreAudit where PA_ADMType='I' and PA_CRMADM in (select PIADM_RowId from sqluser.DHC_PE_PreIADM where PIADM_PGTeam_DR=:PIADMPGTeamDR))
	i SQLCODE<0 q SQLCODE
	
	&sql(delete from DHC_PE_PreIADM where PIADM_PGTeam_DR= :PIADMPGTeamDR)
	i SQLCODE<0 q SQLCODE
	i SQLCODE=100 s SQLCODE=0
	s SQLCODE=..UpdateGroupAuditAmount(GID)
	q SQLCODE
}

/// function:更新销售金额
/// w ##class(web.DHCPE.PreIADM).UpdateAuditSaleAmount()
ClassMethod UpdateAuditSaleAmount(FromAuditId, ToAuditId)
{
	s SaleAmount=$p($g(^DHCPEPreA(FromAuditId)),"^",8)
	i SaleAmount'="" d
	.S $p(^DHCPEPreA(FromAuditId),"^",8)=$p($g(^DHCPEPreA(FromAuditId)),"^",9)
	.S $p(^DHCPEPreA(ToAuditId),"^",8)=$p(^DHCPEPreA(ToAuditId),"^",9)
}

/*
/// 更新个人的审核记录金额
ClassMethod UpdatePersonAuditAmount(GID)
{
	new (GID)
	s SQLCODE=0
	i GID="" q SQLCODE
	s Items=""
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","I",GID,AuditID)) q:(AuditID=""||SQLCODE'=0)  d
	.s UseFlag=$p(^DHCPEPreA(AuditID),"^",21)
	.q:UseFlag="NU"
	.s AccountAmountTotal=0
	.s FactAmountTotal=0
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID,Sub)) q:(Sub="")  d
	..///排除无效的
	..s UFlag=$p($G(^DHCPEPreIADM(GID,"ORDITEM",Sub)),"^",16)
	..q:UFlag'=1
	..
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID,Sub,FSub)) q:(FSub="")  d
	...s Flag=..IsHaveTwoFeeRecord(GID_"||"_Sub,"ORDITEM")
	...s AccountAmount=0
	...i Flag=0 d
	....s AccountAmount=$p($G(^DHCPEPreIADM(GID,"ORDITEM",Sub)),"^",14)
	...s FactAmount=$p(^DHCPEPreIADM(GID,"ORDITEM",Sub,"FEE",FSub),"^",2)
	...i AccountAmount="" s AccountAmount=0
	...i FactAmount="" s FactAmount=0
	...s AccountAmountTotal=AccountAmountTotal+AccountAmount
	...s FactAmountTotal=FactAmountTotal+FactAmount
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,GID,Sub)) q:(Sub="")  d
	..///排除无效的
	..s UFlag=$p($G(^DHCPEPreIADM(GID,"ORDENT",Sub)),"^",9)
	..q:UFlag'=1
	..
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,GID,Sub,FSub)) q:(FSub="")  d
	...s Flag=..IsHaveTwoFeeRecord(GID_"||"_Sub,"ORDENT")
	...s AccountAmount=0
	...i Flag=0 d
	....s AccountAmount=$p($G(^DHCPEPreIADM(GID,"ORDENT",Sub)),"^",7)
	...s FactAmount=$p(^DHCPEPreIADM(GID,"ORDENT",Sub,"FEE",FSub),"^",2)
	...i AccountAmount="" s AccountAmount=0
	...i FactAmount="" s FactAmount=0
	...s AccountAmountTotal=AccountAmountTotal+AccountAmount
	...s FactAmountTotal=FactAmountTotal+FactAmount
	.s Status=$p(^DHCPEPreA(AuditID),"^",10)
	.i Status'="Audited" d
	..i AccountAmountTotal=FactAmountTotal s Status="NoAudited"
	..i AccountAmountTotal'=FactAmountTotal s Status="UnAudited"
	.&SQL(update sqluser.DHC_PE_PreAudit set PA_AccountAmount=:AccountAmountTotal,
	PA_DiscountedAmount=:FactAmountTotal,PA_FactAmount=:FactAmountTotal,PA_AuditedStatus=:Status where PA_RowId=:AuditID) 
	q SQLCODE
}
*/
/// 更新个人的审核记录金额
/// d ##class(web.DHCPE.PreIADM).UpdatePersonAuditAmount(798)
ClassMethod UpdatePersonAuditAmount(GID)
{
	new (GID)
	s SQLCODE=0
	i GID="" q SQLCODE
	s Items=""
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","I",GID,AuditID)) q:(AuditID=""||SQLCODE'=0)  d
	.s UseFlag=$p(^DHCPEPreA(AuditID),"^",21)
	.q:UseFlag="NU"
	.s AccountAmountTotal=0
	.s FactAmountTotal=0
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID,Sub)) q:(Sub="")  d
	..///排除无效的
	..s UFlag=$p($G(^DHCPEPreIADM(GID,"ORDITEM",Sub)),"^",16)
	..q:UFlag'=1
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID,Sub,FSub)) q:(FSub="")  d
	...s FactAmount=$p(^DHCPEPreIADM(GID,"ORDITEM",Sub,"FEE",FSub),"^",2)
	...s AccountAmount=$p(^DHCPEPreIADM(GID,"ORDITEM",Sub,"FEE",FSub),"^",9)
	...i AccountAmount="" s AccountAmount=0
	...i FactAmount="" s FactAmount=0
	...s AccountAmountTotal=AccountAmountTotal+AccountAmount
	...s FactAmountTotal=FactAmountTotal+FactAmount

	.s Status=$p(^DHCPEPreA(AuditID),"^",10)
	.i Status'="Audited" d
	..i AccountAmountTotal=FactAmountTotal s Status="NoAudited"
	..i AccountAmountTotal'=FactAmountTotal s Status="UnAudited"
	.&SQL(update sqluser.DHC_PE_PreAudit set PA_AccountAmount=:AccountAmountTotal,
	PA_DiscountedAmount=:FactAmountTotal,PA_FactAmount=:FactAmountTotal,PA_AuditedStatus=:Status where PA_RowId=:AuditID) 
	q SQLCODE
}

ClassMethod UpdateOneAuditFee(AuditID)
{
	new AType,GID,Flag,PLIST,Amount,Items,FlagOItemID,AuditID,IADM,PrivilegeMode,AccountAmount,AccountAmountTotal,FactAmount,FactAmountTotal,Rebate,Sub
	s SQLCODE=0
	i GID="" q SQLCODE
	s Items=""
	s AccountAmountTotal=0
	s FactAmountTotal=0
	s AType=$p(^DHCPEPreA(AuditID),"^",1)
	s GID=0
	f  s GID=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID)) q:(GID="")  d
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID,Sub)) q:(Sub="")  d
	..///排除无效的
	..s UFlag=$p($G(^DHCPEPreIADM(GID,"ORDITEM",Sub)),"^",16)
	..q:UFlag'=1
	.
	
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,GID,Sub,FSub)) q:(FSub="")  d
	...s Flag=..IsHaveTwoFeeRecord(GID_"||"_Sub,"ORDITEM")
	...s AccountAmount=0
	...i Flag=0 d
	....s AccountAmount=$p($G(^DHCPEPreIADM(GID,"ORDITEM",Sub)),"^",14)
	...e  d
	....i AType="G" d
	.....s AccountAmount=$p($G(^DHCPEPreIADM(GID,"ORDITEM",Sub)),"^",14)
	...s FactAmount=$p(^DHCPEPreIADM(GID,"ORDITEM",Sub,"FEE",FSub),"^",2)
	...i AccountAmount="" s AccountAmount=0
	...i FactAmount="" s FactAmount=0
	...s AccountAmountTotal=AccountAmountTotal+AccountAmount
	...s FactAmountTotal=FactAmountTotal+FactAmount
	.s Sub=0
	.f  s Sub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,GID,Sub)) q:(Sub="")  d
	..///排除无效的
	..s UFlag=$p($G(^DHCPEPreIADM(GID,"ORDENT",Sub)),"^",9)
	..q:UFlag'=1
	..
	..s FSub=0
	..f  s FSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,GID,Sub,FSub)) q:(FSub="")  d
	...s Flag=..IsHaveTwoFeeRecord(GID_"||"_Sub,"ORDENT")
	...s AccountAmount=0
	...i Flag=0 d
	....s AccountAmount=$p($G(^DHCPEPreIADM(GID,"ORDENT",Sub)),"^",7)
	...e  d
	....i AType="G" d
	.....s AccountAmount=$p($G(^DHCPEPreIADM(GID,"ORDENT",Sub)),"^",7)
 	...s FactAmount=$p(^DHCPEPreIADM(GID,"ORDENT",Sub,"FEE",FSub),"^",2)
	...i AccountAmount="" s AccountAmount=0
	...i FactAmount="" s FactAmount=0
	...s AccountAmountTotal=AccountAmountTotal+AccountAmount
	...s FactAmountTotal=FactAmountTotal+FactAmount
	s Status=$p(^DHCPEPreA(AuditID),"^",10)
	i Status'="Audited" d
	.i AccountAmountTotal=FactAmountTotal s Status="NoAudited"
	.i AccountAmountTotal'=FactAmountTotal s Status="UnAudited"
	&SQL(update sqluser.DHC_PE_PreAudit set PA_AccountAmount=:AccountAmountTotal,
	PA_DiscountedAmount=:FactAmountTotal,PA_FactAmount=:FactAmountTotal,PA_AuditedStatus=:Status where PA_RowId=:AuditID) 
	q SQLCODE
}

/// Description:  获取一个项目、套餐是否有两条费用（公+自）
/// Input:		  ItemID(个人预约项目ID/个人预约套餐ID), Type(ORDITEM/ORDENT) 
/// Return：      1(有两条费用（公+自）), 0(没有)
/// Debug: w ##class(web.DHCPE.PreIADM).IsHaveTwoFeeRecord()
ClassMethod IsHaveTwoFeeRecord(ItemID, Type)
{
	new i,iADM,id,Sub,AuditID
	s IAddFlag=0,GAddFlag=0,AddFlag=0
	s Sub=0
	s i=0
	s iADM=$p(ItemID,"||",1)
	s id=$p(ItemID,"||",2)
	i Type="ORDITEM"{
	f  s Sub=$O(^DHCPEPreIADM(iADM,Type,id,"FEE",Sub)) q:Sub=""  d
	.s AuditID=$p($g(^DHCPEPreIADM(iADM,Type,id,"FEE",Sub)),"^",5)
	.q:AuditID=""
	.s UseFlag=$p($g(^DHCPEPreA(AuditID)),"^",21)
	.q:UseFlag="NU"
	.s AddOrd=$p($g(^DHCPEPreA(AuditID)),"^",1)
	.i AddOrd="I" S IAddFlag=1
	.i AddOrd="G" S GAddFlag=1
	.//一个项目对两条收费记录(考虑按金额拆分的情况)
	.i ((IAddFlag=1)&&(GAddFlag=1)) s AddFlag=1 
	.s i=i+1
	}else{
		i $D(^DHCPEPreIADM(iADM,Type,id,"FEE")){
			f  s Sub=$O(^DHCPEPreIADM(iADM,Type,id,"FEE",Sub)) q:Sub=""  d
			.s AuditID=$p($g(^DHCPEPreIADM(iADM,Type,id,"FEE",Sub)),"^",5)
			.q:AuditID=""
			.s UseFlag=$p($g(^DHCPEPreA(AuditID)),"^",21)
			.q:UseFlag="NU"
			.s AddOrd=$p($g(^DHCPEPreA(AuditID)),"^",1)
			.i AddOrd="I" S IAddFlag=1
			.i AddOrd="G" S GAddFlag=1
			.i ((IAddFlag=1)&&(GAddFlag=1)) s AddFlag=1
			.s i=i+1
		}else{
			s ItemSub=0
			s PreIADM=+ItemID
			f  s ItemSub=$O(^DHCPEPreIADM(0,"OrdEnt",ItemID,PreIADM,ItemSub)) q:(ItemSub="")||(i>1)  d
			.s ItemStat=$P($g(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub)),"^",16)
			.q:ItemStat'="1"
			.s PreItemID=PreIADM_"||"_ItemSub
			.s i=..IsHaveTwoFeeRecord(PreItemID, "ORDITEM")
			.s:i=1 i=2
		}
	}
	//i i>1 q 1
	i (i>1)&&(AddFlag=1) q 1
	q 0
}

/// 更新团体组的审核纪录金额
ClassMethod UpdateGroupAuditAmount(GID, Flag As %Library.String = "0")
{
	//q 0
	new (GID,Flag)
	q:Flag=0 0
	s SQLCODE=0
	i GID="" q SQLCODE
	s Items=""
	s IADM=0
	f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",GID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
	.s SQLCODE=..UpdatePersonAuditAmount(IADM)
	q:SQLCODE'=0 SQLCODE
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM","G",GID,AuditID)) q:(AuditID=""||SQLCODE'=0)  d
	.s UseFlag=$p(^DHCPEPreA(AuditID),"^",21)
	.q:UseFlag="NU"
	.s AccountAmountTotal=0
	.s FactAmountTotal=0
	.s IADM=0
	.
	.f  s IADM=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM)) q:(IADM="")  d
	..//s SQLCODE=..UpdatePersonAuditAmount(IADM)
	..q:SQLCODE'=0
	..s Sub=0
	..f  s Sub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,Sub)) q:(Sub="")  d
	...///排除无效的
	...s UFlag=$p($G(^DHCPEPreIADM(IADM,"ORDITEM",Sub)),"^",16)
	...q:UFlag'=1
	...s FSub=0
	...f  s FSub=$o(^DHCPEPreIADM(0,"PAORDITEM",AuditID,IADM,Sub,FSub)) q:(FSub="")  d
	....s FactAmount=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub),"^",2)
	....s AccountAmount=$p(^DHCPEPreIADM(IADM,"ORDITEM",Sub,"FEE",FSub),"^",9)
	....i AccountAmount="" s AccountAmount=0
	....s AccountAmountTotal=AccountAmountTotal+AccountAmount
	....i FactAmount="" s FactAmount=0
	....s FactAmountTotal=FactAmountTotal+FactAmount
	.s IADM=0
	.
	.f  s IADM=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM)) q:(IADM="")  d
	..//s SQLCODE=..UpdatePersonAuditAmount(IADM)
	..q:SQLCODE'=0
	..s Sub=0
	..f  s Sub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,Sub)) q:(Sub="")  d
	...///排除无效的
	...s UFlag=$p($G(^DHCPEPreIADM(IADM,"ORDENT",Sub)),"^",9)
	...q:UFlag'=1
	...s FSub=0
	...f  s FSub=$o(^DHCPEPreIADM(0,"PAORDENT",AuditID,IADM,Sub,FSub)) q:(FSub="")  d
	....s AccountAmount=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub,"FEE",FSub),"^",9)
	....i AccountAmount="" s AccountAmount=0
	....s AccountAmountTotal=AccountAmountTotal+AccountAmount
	
	....s FactAmount=$p(^DHCPEPreIADM(IADM,"ORDENT",Sub,"FEE",FSub),"^",2)
	....i FactAmount="" s FactAmount=0
	....s FactAmountTotal=FactAmountTotal+FactAmount
	.s Status=$p(^DHCPEPreA(AuditID),"^",10)
	.i Status'="Audited" d
	..i AccountAmountTotal=FactAmountTotal s Status="NoAudited"
	..i AccountAmountTotal'=FactAmountTotal s Status="UnAudited"
	.&SQL(update sqluser.DHC_PE_PreAudit set PA_AccountAmount=:AccountAmountTotal,
	PA_DiscountedAmount=:FactAmountTotal,PA_FactAmount=:FactAmountTotal,PA_AuditedStatus=:Status where PA_RowId=:AuditID) 
	s ^wrz(3)=SQLCODE
	q SQLCODE
}

/// w ##class(web.DHCPE.PreIADM).GetPreIADM(28)
ClassMethod GetPreIADM(id As %Library.String = "")
{
	new Data
	s Data=""
	s CurData=$G(^DHCPEPreIADM(id))
	i ""'=CurData  d
	.s Data=$g(id)
	.s iLLoop=1			//1
	.//预登记个人基本信息号 PIADM_PIBI_DR	1
	.s PIADMPIBIDR = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMPIBIDR
	.s PIADMPIBIDRName=""
	.i PIADMPIBIDR'="" s PIADMPIBIDRName=$p($G(^SSU("SSUSR",PIADMPIBIDR)),"^",2)
	.s Data=Data_"^"_PIADMPIBIDRName
	.s iLLoop=iLLoop+1			//2
	.//对应团体的ADM PIADM_PGADM_DR	
	.s PIADMPGADMDR = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMPGADMDR
	.//	对应团体 2.1
	.s PIADMPGADMDRName=""
	.i ""'=PIADMPGADMDR  d
	..//PGADM_PGBI_DR DHC_PE_PreGADM
	..s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PIADMPGADMDR)),"",1)
	..i ""'=PGADMPGBIDR d
	...//DHC_PE_PreGBaseInfo
	...s PIADMPGADMDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"",2)
	.s Data=Data_"^"_PIADMPGADMDRName
	.s iLLoop=iLLoop+1			//3
	.// 对应组ADM PIADM_PGTeam_DR	
	.s PIADMPGTeamDR = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMPGTeamDR
	.// 对应组 3.1
	.//PGT_ParRef
	.s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	.//PGT_ChildSub
	.s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	.i ""'=PIADMPGTeamDR  d
	..s PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	.e  d
	..s PIADMPGTeamDRName=""
	.s Data=Data_"^"_PIADMPGTeamDRName
	.s iLLoop=iLLoop+1			//4
	.// 预约体检日期开始 PIADM_PEDateBegin	
	.s PIADMPEDateBegin = $p(CurData,"^",iLLoop)
	.i (""'=PIADMPEDateBegin) s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	.s Data=Data_"^"_PIADMPEDateBegin
	.s iLLoop=iLLoop+1			
	.// 预约体检结束日期//5
	.s PIADMPEDateEnd = $p(CurData,"^",iLLoop)
	.i (""'=PIADMPEDateEnd) s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	.s Data=Data_"^"_PIADMPEDateEnd
	.s iLLoop=iLLoop+1
	.// 预约体检时间 PIADM_PETime
	.s PIADMPETime = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMPETime) PIADMPETime=$ZT(PIADMPETime,2)
	.s Data=Data_"^"_PIADMPETime
	.s iLLoop=iLLoop+1			//6
	.// 预约接待人员 PIADM_PEDeskClerk_DR	
	.s PIADMPEDeskClerkDR = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMPEDeskClerkDR
	.i (""'=PIADMPEDeskClerkDR)  d // 6.1
  	..s PIADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PIADMPEDeskClerkDR)),"^",2)
	.e  d
	..s PIADMPEDeskClerkDRName=""
	.s Data=Data_"^"_PIADMPEDeskClerkDRName
	.s iLLoop=iLLoop+1			//7
	.// PIADM_Status	
	.s PIADMStatus = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMStatus
	.s iLLoop=iLLoop+1			//8
	.//视同收费 PIADM_AsCharged	
	.s PIADMAsCharged = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMAsCharged
	.s iLLoop=iLLoop+1			//9
	.// 允许加项	PIADM_AddOrdItem	19
	.s PIADMAddOrdItem = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMAddOrdItem
	.s iLLoop=iLLoop+1
	.// 加项金额限制	PIADM_AddOrdItemLimit 20
	.s PIADMAddOrdItemLimit = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMAddOrdItemLimit
	.s iLLoop=iLLoop+1
	.// 允许加项金额	PIADM_AddOrdItemAmount 21
	.s PIADMAddOrdItemAmount = $p(CurData,"^",iLLoop)
	.i ((PIADMAddOrdItemAmount'="")&&($p(PIADMAddOrdItemAmount,".",1)="")) s PIADMAddOrdItemAmount=0_PIADMAddOrdItemAmount
	.s Data=Data_"^"_PIADMAddOrdItemAmount
	.s iLLoop=iLLoop+1
	.// 允许加药	PIADM_AddPhcItem 22
	.s PIADMAddPhcItem = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMAddPhcItem
	.s iLLoop=iLLoop+1
	.// 加药金额限制	PIADM_AddPhcItemLimit 23
	.s PIADMAddPhcItemLimit = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMAddPhcItemLimit
	.s iLLoop=iLLoop+1
	.// 允许加药金额	PIADM_AddPhcItemAmount 24
	.s PIADMAddPhcItemAmount = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMAddPhcItemAmount
	.s iLLoop=iLLoop+1
	.// 个人报告发送	PIADM_IReportSend 25
	.s PIADMIReportSend = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMIReportSend
	.s iLLoop=iLLoop+1
	.// 结算方式	PIADM_DisChargedMode 26
	.s PIADMDisChargedMode = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_PIADMDisChargedMode
	.s iLLoop=iLLoop+1
	.// PIADM_VIP
	.s VIP=$p(CurData,"^",iLLoop)
	.s Data=Data_"^"_VIP
	.s iLLoop=iLLoop+1
	.// PIADM_DelayDate 28
	.s DelayDate = $p(CurData,"^",iLLoop)
	.;i (""'=DelayDate) s DelayDate=$ZD(DelayDate,4)
	.i (""'=DelayDate) s DelayDate=##class(websys.Conversions).DateLogicalToHtml(DelayDate)
	.s Data=Data_"^"_DelayDate
	.s iLLoop=iLLoop+1
	.//PIADM_Remark
	.s Remark = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_Remark
	.//业务员
	.s iLLoop=iLLoop+4
	.s Remark = $p(CurData,"^",iLLoop)
	.s Data=Data_"^"_Remark
	.i Remark'="" d
	..s Remark=$p($g(^SSU("SSUSR",Remark)),"^",2)
	.s Data=Data_"^"_Remark
	.s iLLoop=iLLoop+1
	.s Type=$p(CurData,"^",iLLoop)
	.s Data=Data_"^"_Type
	.s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",id))
	.i ReportDate'="" d
	..;s $P(ReportDate,"^",1)=$ZD($P(ReportDate,"^",1),4)
	..s $P(ReportDate,"^",1)=##class(websys.Conversions).DateLogicalToHtml($P(ReportDate,"^",1))
	..s $P(ReportDate,"^",2)=$ZT($P(ReportDate,"^",2))
	.i ReportDate="" s ReportDate="^"
	.s Data=Data_"^"_ReportDate
	.s PayType=$G(^DHCPEDataEx("DHCPEPreIADM","PayType",id))
	.s Data=Data_"^"_PayType
	.s Percent=$G(^DHCPEDataEx("DHCPEPreIADM","Percent",id))
	.s Data=Data_"^"_Percent
	.s InsureUnit=$G(^DHCPEDataEx("DHCPEPreIADM","InsureUnit",id))  //add by zl 20100207
	.s Data=Data_"^"_InsureUnit
	.s ADMFeeType=$G(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",id))  //add by zl 20110729
	.s Data=Data_"^"_ADMFeeType
	.s RoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",id))  //add by zl 20110729
	.s Data=Data_"^"_RoomPlace
	e  d
	.s Data=""
	
	q Data
}

/// 查看客户是否存在未完成的预约
/// w ##class(web.DHCPE.PreIADM).ThePersonIsExistAdm(1)
ClassMethod ThePersonIsExistAdm(PIBIDR As %String = "")
{
	Q:(""=PIBIDR) ""
	s IsExist=""
	s id=0
	f  s id=$O(^DHCPEPreIADM(0,"PIBI",PIBIDR,id)) Q:(""=id)  d
	.//PIADM_Status
	.s Status=$P($G(^DHCPEPreIADM(id)),"^",8)
	.q:Status="CANCELPE"
	.s:("PREREG"=Status)||("PREREGED"=Status)||("REGISTERED"=Status) IsExist=id
	.s date=$P($G(^DHCPEPreIADM(id)),"^",4)
	.i (("ARRIVED"=Status)&&(+$h<=date)) s IsExist=id
	Q IsExist
}

/// 判断记录是否可以更改 Status 为 PREREG 预登记 可以更改
/// w ##class(web.DHCPE.PreIADM).IsADMModfiy("77")
ClassMethod IsADMModfiy(id As %String = "")
{
	Q:(""=id) "0"
	s Status=$p($G(^DHCPEPreIADM(id)),"^",8)
	Q:("PREREG"=Status)||("PREREGED"=Status) "1"
	Q "0"
}

// w ##class(web.DHCPE.PreIADM).GroupIsExistIADM(95,23)

/// 判断客户在 团体/团体组理是否已存在
ClassMethod GroupIsExistIADM(PIBI As %String = "", GADM As %String = "", GTeam As %String = "")
{
	s IsExist=0
	q:GADM="" IsExist
	s IADM=""
	f  s IADM=$O(^DHCPEPreIADM(0,"PIBI",PIBI,IADM)) q:(IADM="")||(IsExist=1)  d
	.s Status=$P(^DHCPEPreIADM(IADM),"^",8)
	.q:"CANCELPE"=Status
	.s CurGADM=$P(^DHCPEPreIADM(IADM),"^",2)
	.q:CurGADM'=GADM
	.s IsExist=1
	Q IsExist
}

/// 
/// 获取客户信息
/// 
/// 如果通过预约号PIADMRowId查找，则获取 预约信息 和 客户信息
/// 如果通过客户登记号或姓名查找，则只获取 客户信息
/// IsShowAlert 是否在页面显示警告信息(已登记)
/// 使用组件 ： DHCPEPreIADM.Edit（个人预约）
/// 			DHCPEPreIADM.Team（团体人员分组）
/// 			DHCPEPreIADM.GTEdit 团体人员预约修改
/// w ##class(web.DHCPE.PreIADM).DocListBroker("","","127^^")
/// 
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	/*s PIADMRowId=$p(InString,"^",1)
	s PIBIPAPMINo=$p(InString,"^",2)
	s PIBIName=$p(InString,"^",3)
	Set IDCard=$p($g(InString),"^",4)
	*/
	s InStringOne=$p($g(InString),"$",1)
	s PIADMRowId=$P($g(InStringOne),"^",1)
	s PIBIPAPMINo=$p($g(InStringOne),"^",2)
	s PIBIName=$p($g(InStringOne),"^",3)
	S IDCard=$p($g(InStringOne),"^",4)
    s CardTypeDR=$p($g(InString),"$",2)

	s PatTypeName=""
	i ""'=PIADMRowId  d
	.s Data=..GetPreIADM(PIADMRowId)
	.s PreIADMData=Data
	.s PIBIID=$P(Data,"^",2)
	.s Data=##class(web.DHCPE.PreIBaseInfo).GetPreIBaseInfo(PIBIID_"^"_"^")
	.S LocID=$P($g(^DHCPEPreIADM(PIADMRowId)),"^",26)
	.;i $g(^DHCPESetting("DHCPE","HospitalCode"))="SHDF" d
	.i $g(^DHCPESetting("DHCPE","HospitalCode",LocID))="SHDF"  d

	..s PatTypeDR=$G(^DHCPEDataEx("DHCPEPreIADM","PatType",PIADMRowId))
	..i PatTypeDR'=""  s PatTypeName=$p($g(^CT("SS",PatTypeDR)),"^",2)
	..s Data=$P(Data,"^",1,6)_"^"_PatTypeDR_"^"_PatTypeName_"^"_$P(Data,"^",9,35)
	..s IBaseInfoData=Data
	.else  d
	..s IBaseInfoData=Data
	.s IsShowAlert="N"
	.
	e  d
	.s PreIADMData="0^"
	.s Data=##class(web.DHCPE.PreIBaseInfo).GetPreIBaseInfo(""_"^"_PIBIPAPMINo_"^"_PIBIName_"^"_IDCard_"$"_CardTypeDR)
	.s IBaseInfoData=Data
	.//查看客户是否存在未完成的登记
	.s IsShowAlert="N"
	.s PIBIDR=$p(Data,"^",1)
	.i "0"'=PIBIDR d
	..s IsShowAlert=..ThePersonIsExistAdm(PIBIDR)
	..i ""'=IsShowAlert s IsShowAlert="Y"
	//		客户信息			预约信息	是否已经预约过
	s Data=IBaseInfoData_";"_PreIADMData_";"_IsShowAlert
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	
	q Data
}

ClassMethod HISUIDocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", CardType As %Library.String = "", HospID As %Library.String = "")
{
	s PIADMRowId=$p(InString,"^",1)
	s PIBIPAPMINo=$p(InString,"^",2)
	s PIBIName=$p(InString,"^",3)
	Set IDCard=$p($g(InString),"^",4)
	s PatTypeName=""
	i ""'=PIADMRowId  d
	.s Data=..GetPreIADM(PIADMRowId)
	.s PreIADMData=Data
	.s PIBIID=$P(Data,"^",2)
	.s Data=##class(web.DHCPE.PreIBaseInfo).GetPreIBaseInfo(PIBIID_"^"_"^$"_CardType_"$"_HospID)
	.S LocID=$P($g(^DHCPEPreIADM(PIADMRowId)),"^",26)
	.;i $g(^DHCPESetting("DHCPE","HospitalCode"))="SHDF" d
	.i $g(^DHCPESetting("DHCPE","HospitalCode",LocID))="SHDF"  d
	..s PatTypeDR=$G(^DHCPEDataEx("DHCPEPreIADM","PatType",PIADMRowId))
	..i PatTypeDR'=""  s PatTypeName=$p($g(^CT("SS",PatTypeDR)),"^",2)
	..s Data=$P(Data,"^",1,6)_"^"_PatTypeDR_"^"_PatTypeName_"^"_$P(Data,"^",9,35)
	..s IBaseInfoData=Data
	.else  d
	..s IBaseInfoData=Data
	.s IsShowAlert="N"
	.
	e  d
	.s PreIADMData="0^"
	.s Data=##class(web.DHCPE.PreIBaseInfo).GetPreIBaseInfo(""_"^"_PIBIPAPMINo_"^"_PIBIName_"^"_IDCard_"$"_CardType_"$"_HospID)
	.s IBaseInfoData=Data
	.//查看客户是否存在未完成的登记
	.s IsShowAlert="N"
	.s PIBIDR=$p(Data,"^",1)
	.i "0"'=PIBIDR d
	..s IsShowAlert=..ThePersonIsExistAdm(PIBIDR)
	..i ""'=IsShowAlert s IsShowAlert="Y"
	//		客户信息			预约信息	是否已经预约过
	s Data=IBaseInfoData_";"_PreIADMData_";"_IsShowAlert
	
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
	.&javascript<#(retval)#>
	q "{""ret"":"""_Data_"""}"
	q Data
}

/// 预约审核
/// IAdmId 个人预约的ID
/// GAdmId 审核团体的预约成员，不能与IAdmId同时不为空
/// test w ##class(web.DHCPE.PreIADM).AuditAdm()
ClassMethod AuditAdm(IAdmId As %Library.String = "", GAdmId As %Library.String = "", FactAmount As %Library.String = "", AuditUserId As %Library.String = "")
{

	s Status="CHECKED"
	s AuditDate=+$H
	s ret=""
	/*
	// 个人客户审核
	i ""'=IAdmId d
	.&sql(update DHC_PE_PreIADM
		set PIADM_CheckedStatus = :Status
			,PIADM_FactAmount = :FactAmount
	        ,PIADM_AuditUser_DR = :AuditUserId
	        ,PIADM_AuditDate = :AuditDate
		where PIADM_RowId = :IAdmId
		)
	.i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret="AuditAdm dhc_pe_PreIAdm wrong, SQLCODE="_SQLCODE
	
	// 团体审核
	i ""'=GAdmId d
	.&sql(update SQLUSER.DHC_PE_PreIADM
			set PIADM_AuditUser_dr=:AuditUserId
			, PIADM_AuditDate=:AuditDate
			, PIADM_CheckedStatus=:Status
		where  piadm_pgadm_dr=:GAdmId)
	.
	.i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret="AuditAdm dhc_pe_PreGAdm wrong, SQLCODE="_SQLCODE
	 */
	Q ret
}

/// 放弃预约
/// IAdmId 个人预约的ID
/// GAdmId 审核团体的预约成员，不能与IAdmId同时不为空
/// test w ##class(web.DHCPE.PreIADM).CancelAdm("","","246^PREREGED^")
ClassMethod CancelAdm(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ^tempdhcpe("CancelAdm","Param")=InString
	s Rowid=$P(InString,"^",1)
	s CheckFlag=$P(InString,"^",3)  ;0不判断登记时的一些判断
	Q:(""=Rowid) "Err 01"				//无效患者
	s Status=$P($G(^DHCPEPreIADM(Rowid)),"^",8)
	Q:(""=Status) "Err 02"				// 无效状态
	Q:("ARRIVED"=Status)&&(CheckFlag'=0) "Err 03"	//已登记
	//Q:("CANCELPREREG"=Status) "Err 04"	//已放弃
	
	s Status=$P(InString,"^",2)
	i (Status="PREREGED")&&(CheckFlag'=0)
	{
		s Return=..HaveItemWhenPreOver(Rowid)
		q:Return'=0 Return
		
		s Return=##class(web.DHCPE.CRM.GatewayDHC).CheckCanArrive(Rowid,"I")
		;b // CancelAdm Return
		q:Return'=0 "NoArrive"
	}
	//s Status="CANCELPREREG"
	s:$d(%session) UpdateUserDR =%session.Get("LOGON.USERID")
	s:'$d(%session) UpdateUserDR=5918
	s UpdateDate = +$H
	/*
	,PIADM_UpdateDate = :UpdateDate
			,PIADM_UpdateUser_DR = :UpdateUserDR
	*/
	i ""'=Rowid d
	.
	.&sql(update DHC_PE_PreIADM
		set PIADM_Status = :Status
					
		where PIADM_RowId = :Rowid
		)
	.
	.s ret=SQLCODE
	
	Q ret
}

/// 判断完成预约的时候是否有检查项目
ClassMethod HaveItemWhenPreOver(iAdm)
{
	s flag="NoItem"
	s iSub=0
	f  s iSub=$o(^DHCPEPreIADM(iAdm,"ORDITEM",iSub)) q:(iSub="")||(flag=0)  d 
	.s Stat=$p($G(^DHCPEPreIADM(iAdm,"ORDITEM",iSub)),"^",16)
	.q:Stat'="1"
	.s flag=0
	q flag
}

/// 设置团体的 应收金额
/// w ##class(web.DHCPE.PreIADM).SaveAccountAmount("","","1^100")
ClassMethod SaveAccountAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s RowId=$p(InString,"^",1)
	
	s AccountAmount=$p(InString,"^",2)
	Q:(""=RowId) "Err A01"

	s ret=""
	/*&sql(update DHC_PE_PreIADM 
		set PIADM_AccountAmount = :AccountAmount 
		where PIADM_RowId = :RowId)*/
	i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret=SQLCODE
	q ret
}

ClassMethod SaveAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s RowId=$p(InString,"^",1)
	
	s AccountAmount=$p(InString,"^",2)
	Q:(""=RowId) "Err A01"

	s ret=""
	/*&sql(update DHC_PE_PreIADM 
		set PIADM_AccountAmount = :AccountAmount 
		where PIADM_RowId = :RowId)*/
	i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret=SQLCODE
	q ret
}

/// 更新金额 
/// 由调用者保证数据完整性(事务)
/// 使用	web.DHCPE.PreItemList.UpdateAmount(更改个人的项目，更新其金额)
/// 
/// w ##class(web.DHCPE.PreIADM).UpdateAmount("", "","3627^744.1^744.1^744.1^")
ClassMethod UpdateAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s ^xwmTest("UpdateAmount")=itmjs_", """_itmjsex_""","""_InString_""""
	
	s RowId=$p(InString,"^",1)
	Q:(""=RowId) "Err A01"
	k PLIST
	s CurData=$G(^DHCPEPreIADM(RowId))
	
	// 应收金额 PIADM_AccountAmount
	s AccountAmount=$p(InString,"^",2)
	i ""=AccountAmount  d
	.s AccountAmount=$P(CurData,"^",9)
	e  d
	.s PLIST(24)=AccountAmount
	
	// 打折后金额 PIADM_DiscountedAmount
	s DiscountedAmount=$p(InString,"^",3)
	i ""=DiscountedAmount  d
	.s DiscountedAmount=$P(CurData,"^",10)
	e  d
	.s PLIST(25)=DiscountedAmount

	// 	最终金额 PIADM_FactAmount
	s FactAmount=$p(InString,"^",5)
	i ""=FactAmount d
	.s FactAmount=$P(CurData,"^",11)
	e  d
	.s PLIST(26)=FactAmount	
	
	// 销售金额 PIADM_SaleAmount
	s SaleAmount=$p(InString,"^",4)
	i ""=SaleAmount d
	.s SaleAmount=$P(CurData,"^",16)
	e  d
	.s PLIST(41)=SaleAmount
	
	// PIADM_ChargedStatus
	//s PLIST(31)=
	
	// PIADM_Status
	s Status=$P(CurData,"^",7)
	// 取消预约 不能修改
	Q:("CANCELPREREG"=Status) "UpdateAmount Err:Status=CANCELPREREG"
	
	// PIADM_ChargedStatus	收费状态
	s ChargedStatus=$P(CurData,"^",17)
	
	// PIADM_CheckedStatus	审核状态
	s CheckedStatus=$P(CurData,"^",18)
	
	// // 预约状态 更改审核状态：审核/不需审核
	i ("PREREG"=Status) d 
	.// 如果应收金额等于销售金额,客户预约状态设为 NOCHECKED不需审核,否则为需审核的预约状态
	.i (""'=SaleAmount)&(""'=AccountAmount)&(AccountAmount=SaleAmount) d
	..s PLIST(32)="NOCHECKED"
	.e  d
	..s PLIST(32)="UNCHECKED"
	&SQL(Update SQLUSER.DHC_PE_PreIADM Values :PLIST() 
		where PIADM_RowId = :RowId)

	Q:("0"=SQLCODE) "" //成功返回空
	Q SQLCODE
}

/// 设置个人 的打折金额
/// w ##class(web.DHCPE.PreIADM).DiscountedAmount("","","1^100")
ClassMethod SaveDiscountedAmount(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{

	s RowId=$p(InString,"^",1)
	s DiscountedAmount=$p(InString,"^",2)
	
	Q:(""=RowId) "Err A01"
	s ret=""
	/*&sql(update DHC_PE_PreIADM
		set  PIADM_DiscountedAmount = :DiscountedAmount
		where PIADM_RowId = :RowId
		)*/
	i ((SQLCODE'=0)&&(SQLCODE'=100)) s ret=SQLCODE
	q ret
}

/// 预约人员 列表
Query UserList(Desc As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "姓名:%String,HIDDEN:%String,工号:%String")
{
	select SSUSR_Name,SSUSR_RowId,SSUSR_Initials 
	from SS_User
	where SSUSR_Name %STARTSWITH :Desc 
		  and SSUSR_Active='Y'
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADM","UserListNew")
Query UserListNew(Desc, Type As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "HIDDEN:%String,姓名:%String,工号:%String")
{
}

ClassMethod UserListNewExecute(ByRef qHandle As %Binary, desc, Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
     //S ^TEMPDHCPE("PARA")=desc_"^"_Type_"^"_LocID_"^"_hospId
    s id=0
	f  s id=$O(^SSU("SSUSR",id)) q:id=""  d
	.s name=$p(^SSU("SSUSR",id),"^",2)
	.S Initials=$p(^SSU("SSUSR",id),"^",1)
	.s name=name_"("_Initials_")"
	.q:(desc'="")&&(name'[desc)
    .s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",id,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",id,hospId)
	.q:(HOSPshowFlag="N")
	.s ^CacheTemp(repid,ind)=$lb(id,name,Initials)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 保存数据 d ##class(web.DHCPE.PreIADM).Save("","","78^110^110||1^^^^^^^^^^^1^^")
/// 
ClassMethod ISave2()
{
	s ReturnFlag=""
	
	q:(""'=ReturnFlag) ReturnFlag

	// 插入团体患者时，察看是否已存在
	i (0=$D(PLIST(1))) d
	.s ReturnFlag=..GroupIsExistIADM(PLIST(2), PLIST(3), PLIST(4))
	Q:(1=ReturnFlag) "Err 07" // 患者在团体或团体组已存在

	i (0=$D(PLIST(1))) {
		TStart
		s ReturnFlag=..Insert2()
		s SQLCODE=$p(ReturnFlag,"^",1)
		Q:("0"'=SQLCODE) ReturnFlag
		
		s PLIST(1)=$p(ReturnFlag,"^",2)
		
		i ((""'=PLIST(3))||(""'=PLIST(4))) {
			
			s Ret=##class(web.DHCPE.PreGTeam).IsValidGTeamIADM(PLIST(2), PLIST(4),PLIST(1))
			i ""'=Ret goto ISaveErr
			
			s Ret=##Class(web.DHCPE.PreItemList).IInsOrd4NewPat(PLIST(4), PLIST(1), PLIST(22))
			i ""'=Ret goto ISaveErr
			
			/*0331//															PIADM_UpdateUser_DR
			s Ret=##Class(web.DHCPE.PreItemList).IInsOrd4NewPat(PLIST(4), PLIST(1), PLIST(22))
			i ""'=Ret goto ISaveErr
			
			// 保存由于新增团体成员，团体新增的团体应收费用
			s Ret=##Class(web.DHCPE.PreItemList).UpdateAmount(PLIST(1), "PERSON")
			i ""'=Ret goto ISaveErr*/
		}
		d ##class(web.DHCPE.AdmRecordManager).Insert(PLIST(1),"P","PREInsert",PLIST(22),"")
		TCOMMIT
		q ReturnFlag
	}
	else{
		//i (""'=PLIST(1))&("0"=(..IsADMModfiy(PLIST(1))))
		//{
		//	s ReturnFlag="Err 05"  //不是预登记登记状态，不能修改
			
		//}
		//else
		//{
			s ReturnFlag=..Update2()
		//}
		q ReturnFlag
	}
	
	
ISaveErr
	//Insert Team's orderItems Error
	Trollback
	q "Err 09"_"^"_Ret
}

ClassMethod Insert2()
{
	new RowID
	k PLIST(1)				// PIADM_RowId
	
	s NewHPNo=##class(web.DHCPE.PreIADMEx).GetNewHPNo(PLIST(29), PLIST(19), PLIST(3), PLIST(27))
	s PLIST(28)=NewHPNo
	
	&SQL(
			Insert Into SQLUSER.DHC_PE_PreIADM Values :PLIST()
		)
	i SQLCODE q SQLCODE_"^"_%ROWID	
	s RowID=%ROWID
	i PLIST(4)'=""
	{
		s ^DHCPEDataEx("DHCPEPreIADM","GTEAM",PLIST(4))=+$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM",PLIST(4)))+1
		s ^DHCPEDataEx("DHCPEPreIADM","GTEAM","IADM",RowID)=$G(^DHCPEDataEx("DHCPEPreIADM","GTEAM",PLIST(4)))
	}
	
	i PLIST(3)="" d
	.q:PLIST(29)="Y"
	.i PLIST(19)="" d
	..;s PLIST(19)=$G(^DHCPEVIPLevel("VIPapprove"))
	..s PLIST(19)=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(PLIST(27))  //获取默认VIP等级（多院区）
	.q:PLIST(19)=""
	.;s OrdSetsDR=$P(^DHCPEVIPLevel("VIP",PLIST(19)),"^",11)
	.s OrdSetsDR=""
	.s VIPSetID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_PLIST(27),PLIST(19),0))
	.i VIPSetID'="" s OrdSetsDR=$lg($g(^CF.PE.LocVIPLevelD(VIPSetID)),9) 
	.q:OrdSetsDR=""
	.d ##class(web.DHCPE.PreItemList).IInsertItem(RowID,"PERSON","PRE","",OrdSetsDR,PLIST(22))

	s ^DHCPEDataEx("DHCPEPreIADM","PayType",RowID)=PayType
	s ^DHCPEDataEx("DHCPEPreIADM","Percent",RowID)=Percent
	s ^DHCPEDataEx("DHCPEPreIADM","DietFlag",RowID)=DietFlag
	s ^DHCPEDataEx("DHCPEPreIADM","GiftFlag",RowID)=GiftFlag
	s ^DHCPEDataEx("DHCPEPreIADM","InsureUnit",RowID)=InsureUnit  //add by zl20100207
	s ^DHCPEDataEx("DHCPEPreIADM","PatType",RowID)=PatType
	s ^DHCPEDataEx("DHCPEPreIADM","CheckRoom",RowID)=CheckRoom
	s ^DHCPEDataEx("DHCPEPreIADM","Position",RowID)=Position
	s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",RowID)=ADMFeeType
	s ^DHCPEDataEx("DHCPEPreIADM","RoomPlace",RowID)=RoomPlace
	i GetReportDate'=""
	{
		s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowID)=GetReportDate_"^"_GetReportTime
		s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",GetReportDate,GetReportTime,RowID)=""
	}
	s SQLCODE=..InsertPreAudit(RowID,1)
	q SQLCODE_"^"_RowID
}

ClassMethod NumToChar(Num)
{
	i Num>26 q ""
	s Str="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	q $E(Str,Num)
}

/// 不要使用 使用 Update2
/// 预约更新 
/// 不能更新 应收金额	PIADM_AccountAmount、PIADM_DiscountedAmount
/// 不能更新 审核人和审核日期	PIADM_AuditUser_DR、PIADM_AuditDate
/// 不能更新 预约的状态(由其他功能函数处理)		PIADM_Status
ClassMethod Update(RowId As %String, PIBIDR As %String, PGADMDR As %String, PGTeamDR As %String, PEDate As %String, PETime As %String, PEDeskClerk As %String, Status As %String, AsCharged As %String, AccountAmount As %String, DiscountedAmount As %String, SaleAmount As %String, FactAmount As %String, AuditUserDR As %String, AuditDate As %String, UpdateUserDR As %String, UpdateDate As %String)
{
	s OldLimitFee=$p(^DHCPEPreIADM(RowId),"^",11)
	&SQL(Update SQLUSER.DHC_PE_PreIADM Values :PLIST() 
		where PIADM_RowId = :RowId)
	q:SQLCODE SQLCODE
	i OldLimitFee'=PLIST(12) d
	.s gId=$p(^DHCPEPreIADM(RowId),"^",2)
	.i gId'="" d
	..s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(RowId,"LimitFee")
	..q:SQLCODE'=0
	..s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(gId)
	q SQLCODE
}

/// 验证设置预约状态
ClassMethod ValidateIADMStatus()
{
	s ret=""
	// PIADM_Status
	s Status=$P($G(^DHCPEPreIADM(PLIST(1))), "^", 7)
	
	// 预约
	i "PREREG"=Status d
	.
	.
	.i ("NOCHECKED"=PLIST(41))||("PREREG"=Status) d
	.
	.i (""'=PLIST(41))&(""'=PLIST(24))&(PLIST(24)=PLIST(41)) d
	..s PLIST(32)="NOCHECKED"	// 当销售金额等于应收金额时，无需审核
	.e  d
	..s PLIST(32)="UNCHECKED"	// 未审核
	.
	.
	.// 当销售和硬收金额为零 设为预约
	.i (0=+PLIST(41))&(+PLIST(41)=+PLIST(24)) d
	..s PLIST(32)="UNCHECKED"	// 未审核
	.
	
	// 登记
	i "REGISTERED"=Status d
	.
	.s ret="Status Err:REGISTERED"
	
	// 取消预约
	i "CANCELPREREG"=Status d
	.
	.s ret="Status Err:CANCELPREREG"
	Q ret
}

/// 预约更新 
/// 不能更新 应收金额	PIADM_AccountAmount、PIADM_DiscountedAmount
/// 不能更新 审核人和审核日期	PIADM_AuditUser_DR、PIADM_AuditDate
/// 不能更新 预约的状态(由其他功能函数处理)		PIADM_Status
ClassMethod Update2()
{
	new RowId
	// 验证预约状态 
	//Q:(""'=..ValidateIADMStatus())
	s RowId=PLIST(1)		// PIADM_RowId
	k PLIST(1)
	s ADMTypeChangeFlag=""
	s ADMTypeChangeFlag=##class(web.DHCPE.PreGADM).GetADMTypeChargedFlag(RowId,ADMFeeType,"I")
	Q:ADMTypeChangeFlag'="" ADMTypeChangeFlag
	s OldChargedMode=$p(^DHCPEPreIADM(RowId),"^",17)                 	
	s OldAsCharged=$p($g(^DHCPEPreIADM(RowId)),"^",9)
	s SQLCODE=0
	i OldAsCharged'=PLIST(10)
	{
		s SQLCODE=..UpdateItemAsCharged(RowId,PLIST(10),"I")
	}
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q SQLCODE_"AsCharged"
	s OldLimitFee=$p(^DHCPEPreIADM(RowId),"^",12)
    s OldAddOrdItem=$p(^DHCPEPreIADM(RowId),"^",10)
    
    
    //更新原体检号，是否可以考虑不修改，登记以后的感觉就不修改体检号了
	s OldInfo=##class(web.DHCPE.PreIADMEx).GetInfo(RowId)
	s NewInfo=PLIST(29)_"^"_PLIST(19)_"^"_PLIST(3)
	i OldInfo'=NewInfo d
	.s NewHPNo=##class(web.DHCPE.PreIADMEx).GetNewHPNo(PLIST(29), PLIST(19), PLIST(3), PLIST(27))
	.s PLIST(28)=NewHPNo
	&SQL(Update SQLUSER.DHC_PE_PreIADM Values :PLIST() 
		where PIADM_RowId = :RowId
		)
	q:SQLCODE SQLCODE_"ADM"
	
	s ^DHCPEDataEx("DHCPEPreIADM","PayType",RowId)=PayType
	s ^DHCPEDataEx("DHCPEPreIADM","Percent",RowId)=Percent
	s ^DHCPEDataEx("DHCPEPreIADM","DietFlag",RowId)=DietFlag
	s ^DHCPEDataEx("DHCPEPreIADM","GiftFlag",RowId)=GiftFlag
	s ^DHCPEDataEx("DHCPEPreIADM","InsureUnit",RowId)=InsureUnit
	s ^DHCPEDataEx("DHCPEPreIADM","PatType",RowId)=PatType 
	s ^DHCPEDataEx("DHCPEPreIADM","CheckRoom",RowId)=CheckRoom
	s ^DHCPEDataEx("DHCPEPreIADM","Position",RowId)=Position
	s OldADMFeeType=$g(^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",RowId))
	s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",RowId)=ADMFeeType
	s OldRoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",RowId))
	s ^DHCPEDataEx("DHCPEPreIADM","RoomPlace",RowId)=RoomPlace

	s ReportDate=$G(^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowId))
	i ReportDate'=""
	{
		k ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowId)
		k ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",+ReportDate,$P(ReportDate,"^",2),RowId)
	}
	i GetReportDate'=""
	{
		s ^DHCPEDataEx("DHCPEPreIADM","GetReportDateTime","I",RowId)=GetReportDate_"^"_GetReportTime
		s ^DHCPEDataExi("DHCPEPreIADM","GetReportDateTime","I",GetReportDate,GetReportTime,RowId)=""
	}
	
	

	i OldLimitFee'=PLIST(13)||(OldAddOrdItem'=PLIST(11)) d
	.s gId=$p(^DHCPEPreIADM(RowId),"^",2)
	.i gId'="" d
	..s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(RowId,"LimitFee")
	..q:SQLCODE'=0
	..s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(gId)
	i OldChargedMode'=PLIST(18) d ..UpdateChargedMode(RowId,PLIST(18))        //add
	//修改就诊类型处理个人和团体费用
	//修改个人体检者项目或套餐对应的就诊类型
	i OldADMFeeType'=ADMFeeType  d
    .s SQLCODE=..UpdateItemFeeType(RowId,"PERSON",ADMFeeType)

	i SQLCODE q SQLCODE_"Other"
	q SQLCODE
}

/// /d ##class(web.DHCPE.PreIADM).UpdateItemFeeType("76||10","TEAM","8")
ClassMethod UpdateItemFeeType(ADMRowId, PersonType, ADMFeeType)
{
   
	s SQLCODE=0
	TSTART
	k ^DHCPETMP("PIOIOrdEnt")
	s SQLCODE=0
    i PersonType="PERSON"  d
    .s PIADMRowId=ADMRowId
    .s SQLCODE=..SetPersonADMFeeType(PIADMRowId,ADMFeeType)
    i PersonType="TEAM"  d
    .s PGTRowID=ADMRowId
    .d ..SetGTADMFeeType(PGTRowID,ADMFeeType)
	.s PIADMRowId=0
	.f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGTeam",PGTRowID,PIADMRowId)) q:PIADMRowId=""  d
	..s SQLCODE=..SetPersonADMFeeType(PIADMRowId,ADMFeeType)
    i PersonType="GROUP"  d
    .s PGTChildSub=0
    .s PGADMRowId=ADMRowId
    .f  s PGTChildSub=$o(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub)) q:PGTChildSub=""  d
    ..s PGTRowID=PGADMRowId_"||"_PGTChildSub
    ..d ..SetGTADMFeeType(PGTRowID,ADMFeeType)
    ..s PIADMRowId=0
    ..f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGTeam",PGTRowID,PIADMRowId)) q:PIADMRowId=""  d
    ...s SQLCODE=..SetPersonADMFeeType(PIADMRowId,ADMFeeType)
   
    
 i SQLCODE
 {
 	TROLLBACK
 	q SQLCODE
 }			  
 TCOMMIT
 q SQLCODE
}

// d ##class(web.DHCPE.PreIADM).SetGTADMFeeType("47||1","6")

ClassMethod SetGTADMFeeType(PGTRowID, ADMFeeType)
{
  
  
	s SQLCODE=0
    d ..SetTeamItemADMFeeType(PGTRowID, ADMFeeType)  //先设置global
	s PGADMRowId=$p(PGTRowID,"||",1)
	s PGTChildSub=$p(PGTRowID,"||",2)
	s PGTOIChildSub=""
	f  s PGTOIChildSub=$o(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub,"ORDITEM",PGTOIChildSub)) q:PGTOIChildSub=""  d
	.s PGTOIOrdEntDR=$p($G(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub,"ORDITEM",PGTOIChildSub)),"^",2)
    .s PGTOIItemStat=$p($G(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub,"ORDITEM",PGTOIChildSub)),"^",13)
    .s PGTOIOrdItemDR=PGADMRowId_"||"_PGTChildSub_"||"_PGTOIChildSub
    .q:PGTOIItemStat'=1
    .s ItemType="Item"
    .i PGTOIOrdEntDR'=""  d
    ..s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Ent",PGTOIOrdEntDR)=ADMFeeType
    ..s ItemType="Ent"
    .q:(PGTOIOrdEntDR'="")&&($D(^DHCPETMP("PIOIOrdEnt",PGTOIOrdEntDR)))
    .s SQLCODE=..UpdateTAmountByItemFeeType(PGTOIOrdItemDR)
    .i PGTOIOrdEntDR'=""  s ^DHCPETMP("PIOIOrdEnt",PGTOIOrdEntDR)=1
    q SQLCODE
}

ClassMethod SetTeamItemADMFeeType(PGTRowID, ADMFeeType)
{
  
	s PGADMRowId=$p(PGTRowID,"||",1)
	s PGTChildSub=$p(PGTRowID,"||",2)
	s PGTOIChildSub=""
	f  s PGTOIChildSub=$o(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub,"ORDITEM",PGTOIChildSub)) q:PGTOIChildSub=""  d
	.s PGTOIOrdEntDR=$p($G(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub,"ORDITEM",PGTOIChildSub)),"^",2)
    .s PGTOIItemStat=$p($G(^DHCPEPreGADM(PGADMRowId,"Team",PGTChildSub,"ORDITEM",PGTOIChildSub)),"^",13)
    .s PGTOIOrdItemDR=PGADMRowId_"||"_PGTChildSub_"||"_PGTOIChildSub
    .q:PGTOIItemStat'=1
	.s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PGTOIOrdItemDR)=ADMFeeType
}

ClassMethod SetPersonADMFeeType(PIADM, ADMFeeType)
{
	s SQLCODE=0
	d ..SetPersonItemADMFeeType(PIADM, ADMFeeType)  //先设置global
 	s ChildSub=0
	f  s ChildSub=$o(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub)) q:ChildSub=""  d
  	.s PIOIRowID=PIADM_"||"_ChildSub
  	.s PIOIOrdEnt=""
   	.s Qty=$G(^DHCPEDataEx("DHCPEPreIOrdItem","Qty",PIOIRowID))
   	.i +Qty'=0 s Qty=1
   	.s PIOIOrdEnt=$p(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub),"^",2)
   	.s PIOIItemStat=$p(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub),"^",16)
	.q:PIOIItemStat'=1
  	.s ItemType="Item"
    .i PIOIOrdEnt'=""  d
  	..s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Ent",PIOIOrdEnt)=ADMFeeType
    ..s ItemType="Ent"
    .q:(PIOIOrdEnt'="")&&($D(^DHCPETMP("PIOIOrdEnt",PIOIOrdEnt)))
	.s SQLCODE=##class(web.DHCPE.PreItemList).UpdateAmountByItemFeeType("PERSON",ItemType,PIOIRowID,Qty)
    .i PIOIOrdEnt'="" s ^DHCPETMP("PIOIOrdEnt",PIOIOrdEnt)=1
    q SQLCODE
}

ClassMethod SetPersonItemADMFeeType(PIADM, ADMFeeType)
{
	
 	s ChildSub=0
	f  s ChildSub=$o(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub)) q:ChildSub=""  d
  	.s PIOIRowID=PIADM_"||"_ChildSub
   	.s PIOIOrdEnt=$p(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub),"^",2)
   	.s PIOIItemStat=$p(^DHCPEPreIADM(PIADM,"ORDITEM",ChildSub),"^",16)
	.q:PIOIItemStat'=1
    .s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType","Item",PIOIRowID)=ADMFeeType
}

/// /d ##class(web.DHCPE.PreIADM).UpdateTAmountByItemFeeType("78||5||3")
ClassMethod UpdateTAmountByItemFeeType(PGTOIOrdItemDR)
{
    n PGTChildSub
	s PAuditID="",FactAmount="",PAprivilegeMode="",Rate=""
    s PGOEDR=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",2)
	s ItmMastDR=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",1)
	s PAprivilegeMode=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",5)
	s Rate=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",$p(PGTOIOrdItemDR,"||",3)),"^",6)
	i PGOEDR'="" d
	.s PGOISub=0  //得到医嘱套有效医嘱的费用累加
	.f  s PGOISub=$o(^DHCPEPreGADM(0,"OrdEnt",PGOEDR,$p(PGTOIOrdItemDR,"||",1),$p(PGTOIOrdItemDR,"||",2),PGOISub))  q:PGOISub=""  d
	..s PGOIDR=$p(PGTOIOrdItemDR,"||",1)_"||"_$p(PGTOIOrdItemDR,"||",2)_"||"_PGOISub
	..s PGTOIItemStat=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",PGOISub),"^",13)
    ..q:PGTOIItemStat'=1
    ..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PGOIDR))
    ..s ItmMastDR=$p(^DHCPEPreGADM($p(PGTOIOrdItemDR,"||",1),"Team",$p(PGTOIOrdItemDR,"||",2),"ORDITEM",PGOISub),"^",1)
    ..s PGOIFactAmount=##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR_"&O","","",ADMFeeType)
    ..s PGOIFactAmount=$p(PGOIFactAmount,"^",1)
    ..s Qty=$G(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",PGOIDR))
    ..i +Qty=0 s Qty=1
    ..s FactAmount=FactAmount+PGOIFactAmount*Qty
	else  d
	.s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType","Item",PGTOIOrdItemDR))
	.s FactAmount=##class(web.DHCPE.PreItemList).GetOrderPrice(ItmMastDR_"&O","","",ADMFeeType)	
	.s Qty=$G(^DHCPEDataEx("DHCPEPreGTOrdItem","Qty",PGTOIOrdItemDR))
	.i +Qty=0 s Qty=1
	.s FactAmount=$p(FactAmount,"^",1)*Qty
	
    s AccountAmount=FactAmount
    if PAprivilegeMode="OR" s FactAmount=FactAmount*Rate/100
    i PGOEDR=""  d
    .&SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_FactAmount=:FactAmount,PGTOI_AccountAmount=:AccountAmount where PGTOI_RowId=:PGTOIOrdItemDR)
	else  d
    .;&SQL(update sqluser.DHC_PE_PreGTOrdEnt set PGTOE_FactAmount=:FactAmount,PGTOE_AccountAmount=:AccountAmount where PGTOE_RowId=:PGOEDR)
	.s SQLCODE=##class(web.DHCPE.PreItemList).ChangedTOrdItem(PGOEDR) //更新团体医嘱套里医嘱项目的金额

	q SQLCODE
}

/// 获取客户有关信息
/// w ##class(web.DHCPE.PreIADM).GetPreIADMInfor()
ClassMethod GetPreIADMInfor(AdmId As %String = "")
{
	Q:(""=AdmId) ""
	s CurData=$g(^DHCPEPreIADM(AdmId))
	/*
	i ""=CurData d
	.s iLLoop=2
	.// PIADM_PGADM_DR 对应团体的ADM 2
	.s PIADMPGADMDR=$p(CurData,"^",iLLoop)
	.Q:(""'=PIADMPGADMDR)  //只查询个人登记信息
	.s PIADMPGADMDRName=""
	.i ""'=PIADMPGADMDR  d
	..//PGADM_PGBI_DR DHC_PE_PreGADM
	..s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PIADMPGADMDR)),"",1)
	..i ""'=PGADMPGBIDR d
	...//DHC_PE_PreGBaseInfo 2.1
	...s PIADMPGADMDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"",2)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PGTeam_DR 对应组ADM	 3 DHC_PE_PreGTeam
	.s PIADMPGTeamDR=$p(CurData,"^",iLLoop)
	.//PGT_ParRef
	.s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	.//PGT_ChildSub
	.s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	.i ""'=PIADMPGTeamDR  d  //3.1
	..s PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	.e  d
	..s PIADMPGTeamDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDateBegin	预约体检日期 4
	.s PIADMPEDateBegin=$p(CurData,"^",iLLoop)
	.Q:(""'=PEDate)&(+PEDate<+PIADMPEDateBegin)
	.i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PETime	预约体检时间 5
	.s PIADMPETime=$p(CurData,"^",iLLoop)
	.Q:(""'=PETime)&(PETime'=PIADMPETime)
	.i ""'=PIADMPETime s PIADMPETime=$ZT(PIADMPETime,2)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDeskClerk_DR	预约接待人员 6
	.s PIADMPEDeskClerkDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMPEDeskClerkDR d
	..s PIADMPEDeskClerkDRName=$p($g(^SSU("SSUSR",PIADMPEDeskClerkDR)),"^",2)
	.e  d
	..s PIADMPEDeskClerkDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_Status	登记状态 7
	.s PIADMStatus=$p(CurData,"^",iLLoop)
	.Q:(""'=Status)&(Status'[("^"_PIADMStatus))
	.s PIADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PIADMStatus)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AsCharged	视同收费 8
	.s PIADMAsCharged=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AccountAmount	应收金额 9
	.s PIADMAccountAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_DiscountedAmount	打折后金额 10
	.s PIADMDiscountedAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_FactAmount	最终金额 11
	.s PIADMFactAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AuditUser_DR	审核人 12
	.s PIADMAuditUserDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMAuditUserDR d
	..s PIADMAuditUserDRName=$p($g(^SSU("SSUSR",PIADMAuditUserDR)),"^",2)
	.e  d
	..s PIADMAuditUserDRName=""
	.s iLLoop=iLLoop+1
	.
	.// PIADM_AuditDate	审核日期 13
	.s PIADMAuditDate=$p(CurData,"^",iLLoop)
	.i ""'=PIADMAuditDate s PIADMAuditDate=$ZD(PIADMAuditDate,4)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_UpdateUser_DR 14
	.s PIADMUpdateUserDR=$p(CurData,"^",iLLoop)
	.i ""'=PIADMUpdateUserDR d
	..s PIADMUpdateUserDRName=$p($g(^SSU("SSUSR",PIADMUpdateUserDR)),"^",2)
	.e  d
	..s PIADMUpdateUserDRName=""
	.Q:(""'=UpdateUser)&(UpdateUser'=PIADMUpdateUserDRName)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_UpdateDate 15
	.s PIADMUpdateDate=$p(CurData,"^",iLLoop)
	.Q:(""'=UpdateDate)&(UpdateDate'=PIADMUpdateDate)
	.i ""'=PIADMUpdateDate s PIADMUpdateDate=$ZD(PIADMUpdateDate,4)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_SaleAmount	销售金额 16
	.s PIADMSaleAmount=$p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.	
	.// 收费状态	PIADM_ChargedStatus	17
	.s PIADMChargedStatus = $p(CurData,"^",iLLoop)
	.Q:(""'=ChargedStatus)&(ChargedStatus'[("^"_PIADMChargedStatus))
	.s:(""'=PIADMChargedStatus) PIADMChargedStatusDesc=""
	.s:(""'=PIADMChargedStatus) PIADMChargedStatusDesc=##Class(web.DHCPE.PreCommon).TransChargedStatus(PIADMChargedStatus)
	.s iLLoop=iLLoop+1
	.
	.// 审核状态	PIADM_CheckedStatus	18
	.s PIADMCheckedStatus = $p(CurData,"^",iLLoop)
	.Q:(""'=CheckedStatus)&(Status[("^PREREG"))&(CheckedStatus'[("^"_PIADMCheckedStatus))
	.s:(""'=PIADMCheckedStatus) PIADMCheckedStatusDesc=""
	.s:(""'=PIADMCheckedStatus) PIADMCheckedStatusDesc=##Class(web.DHCPE.PreCommon).TransCheckedStatus(PIADMCheckedStatus)
	.s iLLoop=iLLoop+1
	.
	.// 允许加项	PIADM_AddOrdItem	19
	.s PIADMAddOrdItem = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 加项金额限制	PIADM_AddOrdItemLimit 20
	.s PIADMAddOrdItemLimit = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加项金额	PIADM_AddOrdItemAmount 21
	.s PIADMAddOrdItemAmount = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加药	PIADM_AddPhcItem 22
	.s PIADMAddPhcItem = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 加药金额限制	PIADM_AddPhcItemLimit 23
	.s PIADMAddPhcItemLimit = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 允许加药金额	PIADM_AddPhcItemAmount 24
	.s PIADMAddPhcItemAmount = $p(CurData,"^",iLLoop)
	.s iLLoop=iLLoop+1
	.
	.// 个人报告发送	PIADM_IReportSend 25
	.s PIADMIReportSend = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMIReportSend) PIADMIReportSendDesc=""
	.s:(""'=PIADMIReportSend) PIADMIReportSendDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMIReportSend)
	.s iLLoop=iLLoop+1
	.
	.// 结算方式	PIADM_DisChargedMode 26
	.s PIADMDisChargedMode = $p(CurData,"^",iLLoop)
	.s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=""
	.s:(""'=PIADMDisChargedMode) PIADMDisChargedModeDesc=##Class(web.DHCPE.PreCommon).TransDisChargedMode(PIADMDisChargedMode)
	.s iLLoop=iLLoop+1
	.
	.// PIADM_PEDateEnd	预约体检日期 27
	.s PIADMPEDateEnd=$p(CurData,"^",iLLoop)
	.Q:(""'=PEDate)&(+PEDate>+PIADMPEDateEnd)
	.i ""'=PIADMPEDateEnd s PIADMPEDateEnd=$ZD(PIADMPEDateEnd,4)
	.s iLLoop=iLLoop+1
	*/
	s Data=""
	Q Data
}

/// w ##class(web.DHCPE.PreIADM).GetGADMInfo(21)
ClassMethod GetGADMInfo(GADMID)
{
	new GStartDate,GEndDate,GDelayDate
	S (GStartDate,GEndDate,GDelayDate)=""
	i GADMID'=""
	{
		/*
		S GStartDate=..GetMaskDate($p($G(^DHCPEPreGADM(GADMID)),"^",2),4)
		S GEndDate=..GetMaskDate($p($G(^DHCPEPreGADM(GADMID)),"^",3),4)
		S GDelayDate=..GetMaskDate($p($G(^DHCPEPreGADM(GADMID)),"^",17),4)
		*/
		S GStartDate=##class(websys.Conversions).DateLogicalToHtml($p($G(^DHCPEPreGADM(GADMID)),"^",2))
		S GEndDate=##class(websys.Conversions).DateLogicalToHtml($p($G(^DHCPEPreGADM(GADMID)),"^",3))
		S GDelayDate=##class(websys.Conversions).DateLogicalToHtml($p($G(^DHCPEPreGADM(GADMID)),"^",17))

	}
	q GStartDate_"^"_GEndDate_"^"_GDelayDate
}

ClassMethod GetMaskDate(Date, Type)
{
	i Date="" q ""
	q $ZD(Date,Type)
}

ClassMethod GetDateByMaskDate(Date, Type)
{
	i Date="" q ""
	//q $ZDH(Date,Type)
	q ##class(websys.Conversions).DateHtmlToLogical(Date)
}

/// Adm  ADM号   Type:Item 团体  Pre 个人
/// w ##class(web.DHCPE.PreIADM).UpdateDelayDate(21,"Item","31/03/2007")
ClassMethod UpdateDelayDate(Adm, Type, Date)
{
	new IADM,IDelayDate
	s IADM=""
	s Date=..GetDateByMaskDate(Date,4)
	i Type="I"
	{
		d UpdatePresonDelayDate(Adm)
		q SQLCODE
	}	
	i Type="G"
	{
		TSTART
		&SQL(update sqluser.DHC_PE_PreGADM set PGADM_DelayDate=:Date where PGADM_RowId=:Adm)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		i Date="" s Date=0
		f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",Adm,IADM)) q:(IADM=""||SQLCODE'=0)  d
		.s IDelayDate=$p($G(^DHCPEPreIADM(IADM)),"^",19)
		.i IDelayDate="" s IDelayDate=0
		.q:Date<IDelayDate
		.d UpdatePresonDelayDate(IADM)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		TCOMMIT
		q SQLCODE
	}
	q
UpdatePresonDelayDate(ADM)
	&SQL(update sqluser.DHC_PE_PreIADM set PIADM_DelayDate=:Date where PIADM_RowId=:ADM)
	Quit
}

/// 删除审核表内容Type 1:预约个人 2:预约团体 3:到达个人 4:到达团体
ClassMethod DeletePreAudit(ADM, Type)
{
	new GIType
	i ((Type=1)||(Type=3))
	{
		s GIType="I"
	}
	else
	{
		s GIType="G"
	}
	i ((Type=1)||(Type=2))
	{
		&SQL(delete from sqluser.DHC_PE_PreAudit where PA_ADMType=:GIType and PA_CRMADM=:ADM)
	}
	else
	{
		&SQL(delete from sqluser.DHC_PE_PreAudit where PA_ADMType=:GIType and PA_GIADM=:ADM)
	}
	i SQLCODE=100 s SQLCODE=0
	q SQLCODE
}

/// 插入审核表内容Type 1:预约个人 2:预约团体 3:到达个人 4:到达团体
ClassMethod InsertPreAudit(ADM, Type)
{
	q 0
	new APLIST
	s APLIST(2)="G"
	i ((Type=1)||(Type=3)) s APLIST(2)="I" 
	i ((Type=1)||(Type=2)) s APLIST(3)=ADM
	i ((Type=3)||(Type=4)) s APLIST(4)=ADM
	s APLIST(11)="NoAudited"
	s APLIST(15)="UNCHARGED"
	s APLIST(20)="NP"
	s APLIST(21)="PRE"
	s APLIST(22)="U"
	&SQL(insert into sqluser.DHC_PE_PreAudit values :APLIST())
	i SQLCODE q SQLCODE
	s APLIST(21)="ADD"
	&SQL(insert into sqluser.DHC_PE_PreAudit values :APLIST())
	q SQLCODE
}

/// 团体分组里面插入个人信息
/// w ##class(web.DHCPE.PreIADM).InsertIADMInGTeam()
ClassMethod InsertIADMInGTeam(IBaseInfoID, GADM, GTeamADM, ZhiWu As %String = "", VipLevel As %String = "")
{
    new DataStr,OneData,TCurData,ChildSub,GCurData,Data,DelayDate
    s ChildSub=$p(GTeamADM,"||",2)
    s DataStr=""
    i VipLevel="" s VipLevel=$g(^DHCPECBVIPLevel("PGT",GTeamADM))
    //s DataStr=DataStr_"^"_VipLevel
    s DataStr=DataStr_"^"_IBaseInfoID
    s DataStr=DataStr_"^"_GADM
    s DataStr=DataStr_"^"_GTeamADM
    s TCurData=$G(^DHCPEPreGADM(GADM,"Team",ChildSub))
    s GCurData=$G(^DHCPEPreGADM(GADM))
    s OneData=$p(TCurData,"^",2,5)
    s Data=$p(OneData,"^",1)
    s $p(OneData,"^",1)=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEPreGADM(GADM,"Team",ChildSub),"^",2))
    ;i Data'="" s $p(OneData,"^",1)=$ZD(Data,4)
    s Data=$p(OneData,"^",2)
    s DelayDate=$p(GCurData,"^",17)
    i DelayDate="" s DelayDate=0
    i (Data'="")&&(Data<DelayDate) s Date=DelayDate
    ;i Data'="" s $p(OneData,"^",2)=$ZD(Data,4)
    s $p(OneData,"^",2)=##class(websys.Conversions).DateLogicalToHtml($p(^DHCPEPreGADM(GADM,"Team",ChildSub),"^",3))
    s Data=$p(OneData,"^",3)
    s $p(OneData,"^",3)=$P($H,",",2)
    ;i Data'="" s $p(OneData,"^",3)=$ZT(Data,2)
    s DataStr=DataStr_"^"_OneData_"^"_"PREREG"
    s OneData=$p(GCurData,"^",7)
    s DataStr=DataStr_"^"_OneData
    s OneData=$p(TCurData,"^",6,11)
    s DataStr=DataStr_"^"_OneData
    s OneData=$p(GCurData,"^",15)
    s DataStr=DataStr_"^"_OneData
    //统结、自结
    s OneData=$p(TCurData,"^",19) 
    i OneData="" d
    .s OneData=$p(GCurData,"^",16)
    
    i OneData="ID" d
    .s $P(DataStr,"^",10)="N"
    
    s DataStr=DataStr_"^"_OneData
    s DataStr=DataStr_"^^^"
    s Sales=$p(GCurData,"^",22)
    s Type=$G(^DHCPEDataEx("DHCPEPreGADM","ADMType",GADM))
    s DataStr=DataStr_"^"_Sales_"^"_Type
    s GetDate=$G(^DHCPEDataEx("DHCPEPreGADM","GetReportDateTime","G",GADM))
    i GetDate=""
    {
        s GetDate="^"
    }
    else
    {
        s $P(GetDate,"^",1)=$ZD($P(GetDate,"^",1),4)
        s $P(GetDate,"^",2)=$ZT($P(GetDate,"^",2))
    }
    s DataStr=DataStr_"^"_GetDate
    s $p(DataStr,"^",19)=VipLevel
    s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",GTeamADM))
    ;s DataStr=DataStr_"^^^^^^^^^"_ADMFeeType
    s DataStr=DataStr_"^"_ZhiWu_"^^^^^^^^"_ADMFeeType //26字段是职务
    s RoomPlace=$G(^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",GTeamADM))
    s DataStr=DataStr_"^"_"N"  ;复检
    s DataStr=DataStr_"^"_RoomPlace  ;诊室位置
    s Return=..Save("","",DataStr)
    ;b ;2
    q Return
}

/// Type G:团体  I:个人
ClassMethod UpdateItemAsCharged(ID, AsCharged, Type)
{
	new ItemID,Sub
	i Type="I"
	{
		d UpdateChargedByPerson(ID)
	}
	i Type="G"
	{
		d UpdateChargedByGroup(ID)
	}
	i SQLCODE=100 s SQLCODE=0
	q SQLCODE
UpdateChargedByGroup(IID)
	//更新团体项目
	&SQL(update sqluser.DHC_PE_PreGTOrdItem set PGTOI_AsCharged=:AsCharged where PGTOI_ParRef->PGT_ParRef=:IID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE q
	//循环更新团体中的个人
	s IADM=0
	f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",IID,IADM)) q:(IADM="")||(SQLCODE'=0)  d
	.d UpdateChargedByPerson(IADM)
	q
UpdateChargedByPerson(IID)
	//更新预约人员
	&SQL(Update sqluser.DHC_PE_PreIADM set PIADM_AsCharged=:AsCharged where PIADM_RowId=:IID)
	q:SQLCODE'=0
	//更新登记后人员
	&SQL(Update sqluser.DHC_PE_IADM set IADM_AsCharged=:AsCharged where IADM_CRMADM=:IID)
	s:SQLCODE=100 SQLCODE=0
	q:SQLCODE'=0
	//更新预约项目
	&SQL(Update sqluser.DHC_PE_PreIOrdItem set PIOI_AsCharged=:AsCharged where PIOI_ParRef=:IID)
	s:SQLCODE=100 SQLCODE=0
	q:SQLCODE'=0
	
	s Sub=0
	f  s Sub=$o(^DHCPEPreIADM(IID,"ORDITEM",Sub)) q:(Sub="")||(SQLCODE'=0)  d
	.s PreItemID=IID_"||"_Sub
	.s Stat=$p($G(^DHCPEPreIADM(IID,"ORDITEM",Sub)),"^",16)
	.q:Stat'="1"
	.s crmID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
	.i crmID'="" d
	..s ChargeStatus=$p(^DHCPECRMO(crmID),"^",4)
	..//已付费退出
	..q:(ChargeStatus="P")
	..//未付费
	..i AsCharged="N" d
	...s ChargeStatus="NP"
	...s OEChargeStatus="TB"
	..e  d
	...s ChargeStatus="OC"
	...s OEChargeStatus="P"
	..//更新DHC_PE_CRMOrder
	..&SQL(update sqluser.DHC_PE_CRMOrder set CRMO_BillStatus=:ChargeStatus where CRMO_RowID=:crmID)
	..q:SQLCODE'=0
	..s OEORDID=$p(^DHCPECRMO(crmID),"^",1)
	..//更新OE_OrdItem
	..&SQL(update sqluser.OE_OrdItem set OEORI_Billed=:OEChargeStatus where OEORI_RowID=:OEORDID)
	..//i AsCharged="Y" d ##class(web.DHCPE.CRM.RisGateway).SendInfo("R",OEORDID)    //add 20100307
	..//i AsCharged="N" d ##class(web.DHCPE.CRM.RisGateway).SendInfo("D",OEORDID)    //add 20100307
	
	s iadm=$O(^DHCPEIADM(0,"CRMADM",IID,0))
	i iadm'="" d
	.s PAADM=$P(^DHCPEIADM(iadm),"^",1)
	.i AsCharged="Y" d ##class(web.DHCPE.CRM.RisGateway).GetPAADM(PAADM,"ARRIVED")
	
	q
}

ClassMethod AuditItem(PreIADM)
{
	s User=%session.Get("LOGON.USERID")
	i User'="" s User=$p($g(^SSU("SSUSR",User)),"^",2)
	&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Remark=:User where PIADM_RowId=:PreIADM)
	q SQLCODE
}

ClassMethod GetChargedStatus(Type, ADM)
{
	new NoChargedFlag,HadChargedFlag,AuditID,ChargedStatus,UseFlag,Total,Amount
	s NoChargedFlag=0
	s HadChargedFlag=0
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM",Type,ADM,AuditID)) q:AuditID=""  d
	.s UseFlag=$P(^DHCPEPreA(AuditID),"^",21)
	.q:UseFlag="NU"
	.s Amount=$P(^DHCPEPreA(AuditID),"^",9)
	.i Amount="" s Amount=0
	.q:Amount=0
	.s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
	.s:ChargedStatus="CHARGED" HadChargedFlag=2
	.s:ChargedStatus="UNCHARGED" NoChargedFlag=1
	s Total=NoChargedFlag+HadChargedFlag
	q:Total=0 "无收费记录"
	q:Total=1 "未收费"
	q:Total=2 "已收费"
	q:Total=3 "部分收费"
}

/// Description: 获取个人/团体收费状态
/// Input: Type（I：个人， G：团体）, ADM（预约ID）
/// Debug:w ##class(web.DHCPE.PreIADM).GetChargedStatusNew()
ClassMethod GetChargedStatusNew(Type, ADM)
{
	new NoChargedFlag,HadChargedFlag,AuditID,ChargedStatus,UseFlag,Total,Amount
	s NoChargedFlag=0
	s HadChargedFlag=0
	s yjf=""
	s AuditID=0
	f  s AuditID=$o(^DHCPEPreA(0,"CRMADM",Type,ADM,AuditID)) q:AuditID=""  d
	.s UseFlag=$P(^DHCPEPreA(AuditID),"^",21)
	.q:UseFlag="NU"
	.s Amount=$P(^DHCPEPreA(AuditID),"^",9)
	.i Amount="" s Amount=0
	.q:Amount=0
	.s ChargedStatus=$P(^DHCPEPreA(AuditID),"^",14)
	.s:ChargedStatus="CHARGED" HadChargedFlag=2
	.s:ChargedStatus="UNCHARGED" NoChargedFlag=1
	.s yjf=##class(web.DHCPE.CashierEx).IsYJSByAuditDr(AuditID)
	s Total=NoChargedFlag+HadChargedFlag
	s:yjf=1 Total= "4"
	q Total
}

/// Description: 获取个人/团体收费状态描述
/// Debug:w ##class(web.DHCPE.PreIADM).GetChargedStatusDesc()
ClassMethod GetChargedStatusDesc(Total)
{
	q:Total=0 "无收费记录"
	q:Total=1 "未收费"
	q:Total=2 "已收费"
	q:Total=3 "部分收费"
	q:Total=4 "预结算"
}

ClassMethod EQUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod EQUserExecute(ByRef qHandle As %Binary, name As %String = "", ChartID As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	Set StationID=##class(web.DHCPE.ResultEdit).GetPEStation($g(ChartID))	
	s UserStrings=""
	i StationID'="" s UserStrings=$G(^DHCPETempUser(StationID))
	s rowid=0
	f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
	.s username=$p(^SSU("SSUSR",rowid),"^",2)
	.;s userloc=$p(^SSU("SSUSR",rowid),"^",4)
	.s usergroup=$p(^SSU("SSUSR",rowid),"^",5)
	.
	.;q:usergroup'=ssgroup
	.q:username'[name
	.s GH=$p(^SSU("SSUSR",rowid),"^",1)
	.s Temp="^"_GH_"^"
	.q:(UserStrings'="")&&(UserStrings'[Temp)
	.s rowid0=rowid
 	.Do OutputRowEQUser	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowEQUser
	set Data=$lb(username,rowid0,$G(GH))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EQUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQUserExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCPE.PreIADM","EQUser","王","")
Query EQUser(name As %String = "", ChartID As %String = "") As %Query(ROWSPEC = "姓名:%String, HIDDEN:%String, 工号:%String")
{
}

/// Add 2008-02-01  取检查日期
/// w ##class(web.DHCPE.PreIADM).GetCheckDate("433312","PAADM")
/// w ##class(web.DHCPE.PreIADM).GetCheckDate("108","PEADM")
/// w ##class(web.DHCPE.PreIADM).GetCheckDate("302","PreADM")
ClassMethod GetCheckDate(ADMID, Type)
{
	i ADMID="" q ""
	s Date=""
	i Type="PAADM"
	{
		d GetCheckDate(ADMID)
	}
	i Type="PreADM"
	{
		s PEADM=$o(^DHCPEIADM(0,"CRMADM",ADMID,0))
		i PEADM'="" d
		.s PAADM=$p($G(^DHCPEIADM(PEADM)),"^",1)
		.i PAADM'="" d GetCheckDate(PAADM)
	}
	i Type="PEADM"
	{
		s PAADM=$p($G(^DHCPEIADM(ADMID)),"^",1)
		d GetCheckDate(PAADM)
	}
	//i Date'="" s Date=$ZD(Date,3)
	i Date'="" s Date=##class(websys.Conversions).DateLogicalToHtml(Date)
	q Date
	
GetCheckDate(RowID)
	s RID=$o(^DHCPERLT(0,"ADM",RowID,0))
	i RID'="" s Date=$p($G(^DHCPERLT(RID)),"^",6)
	q
}

Query SearchUserList(Saler As %Library.String = "") As %Query(ROWSPEC = "name:%String, demo:%String")
{
}

ClassMethod SearchUserListExecute(ByRef qHandle As %Binary, Saler) As %Status
{
   Set repid=$I(^CacheTemp)
 	s ind=1
    s DefaultDeptID=##class(web.DHCPE.Public.Setting).GetSalesDefaultDept()
	s Saler=##class(web.DHCPE.DHCPECommon).UnEscape(Saler)
	s UserID=0
	f  s UserID=$o(^SSU("SSUSR",UserID))   q:UserID=""  d
	.s DefaultDeptDR=$p($g(^SSU("SSUSR",UserID)),"^",4) 
	.q:(DefaultDeptID'="")&&(DefaultDeptDR'=DefaultDeptID)
	.s SSUserInitials=$p($g(^SSU("SSUSR",UserID)),"^",1) 
	.s SSUserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
	.q:(Saler'="")&&(SSUserName'[Saler) 	
	.s SSUserActive=$p($g(^SSU("SSUSR",UserID)),"^",19) 
	.q:SSUserActive'="Y"								
    .set Data=$lb(SSUserName,SSUserInitials)
    .d OutPut
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchUserListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchUserListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPhotoFlag(PreIADM)
{
	s PhotoArcID="18758||1"
	s Flag=0
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",PhotoArcID,PreIADM,ItemSub)) q:(ItemSub="")||(Flag=1)  d
	.s Status=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",16)
	.q:Status'="1"
	.s Flag=1
	q:Flag=1 Flag
	s PhotoArcID="32580||1"
	s Flag=0
	s ItemSub=0
	f  s ItemSub=$O(^DHCPEPreIADM(0,"ItmMast",PhotoArcID,PreIADM,ItemSub)) q:(ItemSub="")||(Flag=1)  d
	.s Status=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",ItemSub),"^",16)
	.q:Status'="1"
	.s Flag=1
	q Flag
}

/// ##class(web.DHCPE.PreIADM).GetDietFlagByID(PreIADM)
ClassMethod GetDietFlagByID(PreIADM, Type As %String = "I")
{
	q:(+PreIADM=0)&&(Type="G") "1"
	q:(+PreIADM=0)&&(Type="I") ""
	s retFlag=""
	i Type="I"
	{
		s DietItem=$G(^DHCPESetting("DHCPE","DietItem"))
		if DietItem'=""{
			s DietType=..GetDietType(PreIADM,DietItem)
			q:DietType'="" 1
			q 0
		}
		s GID=$p($G(^DHCPEPreIADM(PreIADM)),"^",2)
		i GID'=""
		{
			d GetGDietFlag(GID)
		}
		else
		{
			s retFlag=$G(^DHCPEDataEx("DHCPEPreIADM","DietFlag",PreIADM))
		}
	}
	else
	{
		d GetGDietFlag(PreIADM)
	}
	q retFlag
GetGDietFlag(ID)
	s retFlag=$G(^DHCPEDataEx("DHCPEPreGADM","DietFlag",ID))
	q
}

ClassMethod GetDietType(PreIADM, DietItem)
{
	;w ##class(web.DHCPE.PreIADM).GetDietType(PreIADMID)
	q:DietItem="" ""
	s DietDesc=""
	//免费早餐A
	s DietItem1=$P(DietItem,"^",1)
	s sub=0
	f  s sub=$O(^DHCPEPreIADM(0,"ItmMast",DietItem1,PreIADM,sub)) q:(sub="")||(DietDesc'="")  d
	.s stat=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",sub),"^",16)
	.q:stat'="1"
	.s DietDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(DietItem1)
	q:DietDesc'="" DietDesc
	//免费早餐B
	s DietItem2=$P(DietItem,"^",2)
	q:DietItem2="" DietDesc
	s sub=0
	f  s sub=$O(^DHCPEPreIADM(0,"ItmMast",DietItem2,PreIADM,sub)) q:(sub="")||(DietDesc'="")  d
	.s stat=$P(^DHCPEPreIADM(PreIADM,"ORDITEM",sub),"^",16)
	.q:stat'="1"
	.s DietDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(DietItem2)
	q:DietDesc'="" DietDesc
	/*
	s TotalFee=##class(web.DHCPE.PreItemList).IGetOrdAmount(PreIADM,"PERSON") 
	s i=$l(TotalFee,$C(13))
	s TotalFee=$p(TotalFee,$C(13),4)  
	i ((TotalFee>=1000)&&(TotalFee<2000)) d 
	.s ArcimID=DietItem1
	.s DietDesc=$P($G(^ARCIM(+ArcimID,1,1)),"^",2)
	i (TotalFee>=2000) d
	.s ArcimID=DietItem2
	.s DietDesc=$P($G(^ARCIM(+ArcimID,1,1)),"^",2)
	*/
	q DietDesc
}

ClassMethod GetGiftFlagByID(PreIADM, Type As %String = "I")
{
	n (PreIADM,Type)
	q:+PreIADM=0 0
	s retFlag="0"
	i Type="I"
	{
		s GID=$p(^DHCPEPreIADM(PreIADM),"^",2)
		i GID'=""
		{
			d GetGGiftFlag(GID)
		}
		else
		{
			
			s retFlag=$G(^DHCPEDataEx("DHCPEPreIADM","GiftFlag",PreIADM))
		}
	}
	else
	{
		d GetGGiftFlag(PreIADM)
	}
	q retFlag
GetGGiftFlag(ID)
	s retFlag=$G(^DHCPEDataEx("DHCPEPreGADM","GiftFlag",ID))
	
	q
}

ClassMethod UpdateChargedMode(RowId, ChargedMode)
{
	s SQLCODE=0
	q:(RowId="")||(ChargedMode="") SQLCODE
	s PIADMRowId=RowId
	s GRowId=$p(^DHCPEPreIADM(RowId),"^",2)
	q:GRowId="" SQLCODE
    //审核表中对应整个团体的PRE类型的审核记录
	s GPAID=0,NGPAID=""
	f  s GPAID=$o(^DHCPEPreA(0,"CRMADM","G",GRowId,GPAID)) q:(GPAID="")||(SQLCODE'=0)  d
	.s ChargedStatus=$p(^DHCPEPreA(GPAID),"^",14)
	.q:ChargedStatus="CHARGED"
	.s Status=$p(^DHCPEPreA(GPAID),"^",21)
	.q:Status="NU"
	.s GPAType=$p(^DHCPEPreA(GPAID),"^",20)
	.q:GPAType="ADD"
	.s NGPAID=GPAID
	i NGPAID="" s NGPAID=##class(web.DHCPE.PreItemList).GetPARowId("G",GRowId,"ADD")
	//项目
	s PIOIChildSub=0
	f  s PIOIChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)) q:(PIOIChildSub="")||(SQLCODE'=0)  d
	.s PIOIType=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub)),"^",15)
    .//审核表中对应这个项目类型的审核记录
	.s IPAID=0,NIPAID=""
	.f  s IPAID=$o(^DHCPEPreA(0,"CRMADM","I",PIADMRowId,IPAID)) q:(IPAID="")||(SQLCODE'=0)  d
	..s IPAType=$p(^DHCPEPreA(IPAID),"^",20)
	..q:IPAType'=PIOIType
	..s ChargedStatus=$p(^DHCPEPreA(IPAID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s NIPAID=IPAID
	.i NIPAID="" s NIPAID=##class(web.DHCPE.PreItemList).GetPARowId("I",PIADMRowId,"ADD")
	.//项目的收费记录
	.s PIOIFChildSub=0
	.f  s PIOIFChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub)) q:(PIOIFChildSub="")||(SQLCODE'=0)  d
	..s PAID=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub)),"^",5)
	..q:PAID=""
	..s ChargedStatus=$p(^DHCPEPreA(PAID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Status=$p(^DHCPEPreA(PAID),"^",21)
	..q:Status="NU"
	..//由统结变自结,对应审核记录类型为"I"的不变
	..i ChargedMode="ID" d
	...s ADMType=$p(^DHCPEPreA(PAID),"^",1)
	...q:ADMType="I"
	...s FeeId=PIADMRowId_"||"_PIOIChildSub_"||"_PIOIFChildSub
	...d UpdateItemFeeAudit(FeeId,NIPAID)
	
	...//s $p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub),"^",5)=NIPAID
	..//由自结变统结,对应审核记录类型为"ADD"的不变
	..i ChargedMode="GD" d
	...s PAType=$p(^DHCPEPreA(PAID),"^",20)
	...q:PAType="ADD"
	...s FeeId=PIADMRowId_"||"_PIOIChildSub_"||"_PIOIFChildSub
	...d UpdateItemFeeAudit(FeeId,NGPAID)
	...//s $p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",PIOIChildSub,"FEE",PIOIFChildSub),"^",5)=NGPAID
	q:SQLCODE'=0 SQLCODE
	//套餐部分
	s PIOEChildSub=0
	f  s PIOEChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub)) q:(PIOEChildSub="")||(SQLCODE'=0)  d
	.s PIOEType=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub)),"^",8)
	.
    .s IPAID=0,NIPAID=""
	.f  s IPAID=$o(^DHCPEPreA(0,"CRMADM","I",PIADMRowId,IPAID)) q:(IPAID="")||(SQLCODE'=0)  d
	..s ChargedStatus=$p(^DHCPEPreA(IPAID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Status=$p(^DHCPEPreA(IPAID),"^",21)
	..q:Status="NU"
	..s IPAType=$p(^DHCPEPreA(IPAID),"^",20)
	..q:IPAType'=PIOEType
	..s NIPAID=IPAID
	.
	.s PIOEFChildSub=0
	.f  s PIOEFChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub)) q:(PIOEFChildSub="")||(SQLCODE'=0)  d
	..s PAID=$p($g(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub)),"^",5)
	..q:PAID=""
	..s ChargedStatus=$p(^DHCPEPreA(PAID),"^",14)
	..q:ChargedStatus="CHARGED"
	..s Status=$p(^DHCPEPreA(PAID),"^",21)
	..q:Status="NU"
	..i ChargedMode="ID" d
	...s ADMType=$p(^DHCPEPreA(PAID),"^",1)
	...q:ADMType="I"
	...s FeeId=PIADMRowId_"||"_PIOEChildSub_"||"_PIOEFChildSub
	...d UpdateSetFeeAudit(FeeId,NIPAID)
	...//s $p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub),"^",5)=NIPAID
	..i ChargedMode="GD" d
	...s PAType=$p(^DHCPEPreA(PAID),"^",20)
	...q:PAType="ADD"
	...s FeeId=PIADMRowId_"||"_PIOEChildSub_"||"_PIOEFChildSub
	...d UpdateSetFeeAudit(FeeId,NGPAID)
	
	...//s $p(^DHCPEPreIADM(PIADMRowId,"ORDENT",PIOEChildSub,"FEE",PIOEFChildSub),"^",5)=NGPAID
	q:SQLCODE'=0 SQLCODE
	s SQLCODE=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(GRowId,"")
	q SQLCODE
UpdateItemFeeAudit(FeeId,AuditId)
	&SQL(update DHC_PE_PreIOrdItemFee set PIOIF_PAudit_DR=:AuditId where PIOIF_RowId=:FeeId)
	q SQLCODE
UpdateSetFeeAudit(FeeId,AuditId)
	&SQL(update DHC_PE_PreIOrdEntFee set PIOEF_PAudit_DR=:AuditId where PIOEF_RowId=:FeeId)
	q SQLCODE
}

// d ##class(web.DHCPE.PreIADM).test("1||1",2,3,1)

ClassMethod test(oeitm, qty, defaultuom, User)
{
	s DPLIST(2)=oeitm
	s DPLIST(3)=qty
	s DPLIST(5)=1
	s DPLIST(6)=qty
	s DPLIST(7)=defaultuom
	s DPLIST(8)="TC"
	s DPLIST(12)=qty
	s DPLIST(13)=$g(User)
	s DPLIST(16)=+$H
	s DPLIST(17) = $p($h,",",2)
	&sql(Insert into DHC_OEDispensing values :DPLIST())	
	q SQLCODE
}

ClassMethod GetStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", PreIADM As %Library.String = "")
{
	
	s PreStatus=""
	i ""'=PreIADM d
	s PreStatus=$p($g(^DHCPEPreIADM(PreIADM)),"^",8)
	
	Q PreStatus
}

// d ##class(web.DHCPE.PreIADM).ModifyCheckDate("22")

ClassMethod ModifyCheckDate(GADM)
{
   

    s GTeamDR=0
    f  s GTeamDR=$o(^DHCPEIADM(0,"GADM",GADM,GTeamDR))  q:GTeamDR=""  d
    .s IADMRowId=0
    .f  s IADMRowId=$o(^DHCPEIADM(0,"GADM",GADM,GTeamDR,IADMRowId))  q:IADMRowId=""  d
    ..s PAADMDR=$p(^DHCPEIADM(IADMRowId),"^",1)
    ..s LocID=$P($G(^PAADM(PAADMDR)),"^",4)
    ..s RLTRowId=0
    ..f  s RLTRowId=$o(^DHCPERLT(0,"ADM",PAADMDR,RLTRowId))  q:RLTRowId=""  d
    ...s RLTARCIMDR=$p(^DHCPERLT(RLTRowId),"^",2)
    ...s RLTUpdateDate=$p(^DHCPERLT(RLTRowId),"^",6)
	...Q:(""=RLTARCIMDR)
	...s STRowId=0
	...s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",RLTARCIMDR, STRowId))
    ...;Q:($G(^DHCPESetting("DHCPE","StationId_Lab"))=STRowId)					// 检验科室
	...;Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")[("^"_STRowId_"^"))	// 检查科室
	...;Q:($G(^DHCPESetting("DHCPE","StationId_Other"))=STRowId)				// 其它科室
	...Q:($G(^DHCPESetting("DHCPE","StationId_Lab",LocID))=STRowId) // 检验科室
	...Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris",LocID)_"^")[("^"_STRowId_"^")) // 检查科室
	...Q:($G(^DHCPESetting("DHCPE","StationId_Other",LocID))=STRowId) 
	...i (RLTUpdateDate="61884") ||(RLTUpdateDate="61885")  d
	....s $p(^DHCPERLT(RLTRowId),"^",6)="61883"
}

/// 获取团体组的人员列表
Query SearchGIADM(ID As %String = "") As %Query(ROWSPEC = "TRegNo:%String, TName:%String, TDateBegin:%String, TDateEnd:%String, TStatusDesc:%String, TPIADMItem:%String, TPIADMRowId:%String,TTeamName:%String")
{
}

ClassMethod SearchGIADMExecute(ByRef qHandle As %Binary, ID As %String = "") As %Status
{
    
	Set repid=$I(^CacheTemp)
	if (""=ID) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ind=1	
 	s id="0"	//不能使用空字符串开始 s id="" ,否则会取到 0
	f  s id=$o(^DHCPEPreIADM(0,"PGADM",ID,id)) q:id=""  d
	.s CurData=$G(^DHCPEPreIADM(id))
	.s iLLoop=1
	.s PIADMPIBIDR=$p(CurData,"^",iLLoop)
	.q:PIADMPIBIDR=""
	.s PIBIPAPMINo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
    .s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	.s PIADMPEDateBegin=$p(CurData,"^",4)
	.i PIADMPEDateBegin'=""  s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	.s PIADMPEDateEnd=$p(CurData,"^",5)
	.i PIADMPEDateEnd'=""  s PIADMPEDateEnd=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateEnd)
	.s PIADMStatus=$p(CurData,"^",8)
	.q:(PIADMStatus="CANCELPE")||(PIADMStatus="CANCELPREREG")
	.s PIADMStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(PIADMStatus)
	.s Amount=##class(web.DHCPE.HandlerPreOrds).IGetAmount4Person(id)
	.s Amount=$p(Amount,"^",2)
	.s PGTeamDR=$p(CurData,"^",3)
	.i PGTeamDR'=""  s PGTDesc =$p(^DHCPEPreGADM($p(PGTeamDR,"||",1),"Team",$p(PGTeamDR,"||",2)),"^",1) 
	.d GPersonListOutput
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GPersonListOutput      
	set Data=$lb(PIBIPAPMINo,PIADMPIBIDRName,PIADMPEDateBegin,PIADMPEDateEnd,PIADMStatusDesc,Amount,id,PGTDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGIADMExecute ]
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

ClassMethod SearchGIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod UpdateAppointDate(Adm, Type, Date)
{

	s IADM=""
	s Date=..GetDateByMaskDate(Date,4)
	i Type="I"
	{
		d UpdateUpdateAppointDate(Adm)
		q 
	}	
	i Type="G"
	{
		
		i Date="" s Date=0
		f  s IADM=$o(^DHCPEPreIADM(0,"PGADM",Adm,IADM)) q:IADM=""  d
		.s ^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","GADM",Adm)=Date
		.d UpdateUpdateAppointDate(IADM)
	}
	q
UpdateUpdateAppointDate(ADM)
    i $d(^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","ADM",ADM))  d
    .s OldDate=$g(^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","ADM",ADM))
    .k ^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","Date",OldDate,ADM) 
	s ^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","ADM",ADM)=Date
	s ^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","Date",Date,ADM)=1
	Quit
}

ClassMethod GetAppointDate(Adm, Type)
{
	S Date="",AppointDate=""
	i Adm="" q ""
	i Type="I"
	{
		S AppointDate=$g(^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","ADM",Adm))
	}
	i Type="G"
	{
	S AppointDate=$g(^DHCPEDataEx("DHCPEPreIADM","AppointArriveDate","GADM",Adm))
	}
	i AppointDate'="" s Date=AppointDate
	i Date'="" s Date=$ZD(Date,4)
	q Date
}

// d ##class(web.DHCPE.PreIADM).GetTarItemInfo(29)

ClassMethod GetTarItemInfo(Adm, Type As %String = "CRM")
{
	i Type'="CRM"
	{
		s Adm=$P(^DHCPEIADM(Adm),"^",4)
	}
	s baseinfo=$P(^DHCPEPreIADM(Adm),"^",1)
	s name=$P(^DHCPEPreIBI(baseinfo),"^",2)
	s regno=$P(^DHCPEPreIBI(baseinfo),"^",1)
	s baseinfo=name_"^"_regno
	s job=$J
	k ^TempDHCPE("TarItem",job)
	s sub=0
	f  s sub=$O(^DHCPEPreIADM(Adm,"ORDITEM",sub)) q:sub=""  d
	.s stat=$P(^DHCPEPreIADM(Adm,"ORDITEM",sub),"^",16)
	.q:stat'="1"
	.s arcim=$P(^DHCPEPreIADM(Adm,"ORDITEM",sub),"^",1)
	.s date=$P(^DHCPEPreIADM(Adm,"ORDITEM",sub),"^",12)
	.s tarInfo=##class(web.DHCPE.Cashier).ArcItem2TarItem("","",arcim,date,"","","","")
	.s i=$L(tarInfo,"&")
	.f j=1:1:i d
	..s oneInfo=$P(tarInfo,"&",j)
	..q:+oneInfo=0
	..s tarItemID=$p(oneInfo,"^",1)
	..s price=+$p(oneInfo,"^",3)
	..s count=+$p(oneInfo,"^",2)
	..s ^TempDHCPE("TarItem",job,arcim,tarItemID,"count")=+$G(TempDHCPE("TarItem",job,arcim,tarItemID,"count"))+count
	..s ^TempDHCPE("TarItem",job,arcim,tarItemID,"price")=price
	s ret=""
	s c1=$C(1)
	s c2=$C(2)
	s totalAmt=0
	s arcim=""
	f  s arcim=$O(^TempDHCPE("TarItem",job,arcim)) q:arcim=""  d
	.s arcimDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(arcim)
	.s arcimDesc=##class(web.DHCPE.Public.Setting).Replace(arcimDesc,$C(10),"")
	.s arcimDesc=##class(web.DHCPE.Public.Setting).Replace(arcimDesc,$C(9),"")
	.s arcimDesc=##class(web.DHCPE.Public.Setting).Replace(arcimDesc,$C(13),"")
	
	.s tarItemID=""
	.f  s tarItemID=$O(^TempDHCPE("TarItem",job,arcim,tarItemID)) q:tarItemID=""  d
	..s desc=$P(^DHCTARI(tarItemID),"^",2)
	..s count=$G(^TempDHCPE("TarItem",job,arcim,tarItemID,"count"))
	..s price=$G(^TempDHCPE("TarItem",job,arcim,tarItemID,"price"))
	..s uom=$P(^DHCTARI(tarItemID),"^",3)
	..i uom'="" s uom=$P(^CT("UOM",uom),"^",2)
	..s amt=count*price
	..s totalAmt=totalAmt+amt
	..s oneInfo=arcimDesc_"^"_desc_"^"_uom_"^"_price_"^"_count_"^"_amt
	..s arcimDesc=""
	..i ret="" d
	...s ret=oneInfo
	..e  d
	...s ret=ret_c1_oneInfo
	s oneInfo="合计^^^^^"_totalAmt
	i ret="" d
	.s ret=oneInfo
	e  d
	.s ret=ret_c1_oneInfo
	s ret=baseinfo_c2_ret
	k ^TempDHCPE("TarItem",job)
	
	q ret
}

ClassMethod GetPatientID(PAPMINo As %Library.String = "")
{
	
	s PatientID=""
    i PAPMINo'=""  d
    .s PatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
	Q PatientID
}

/// d ##class(web.DHCPE.PreIADM).GetStatusByRegNo("40695337")
ClassMethod GetStatusByRegNo(RegNo)
{
	q:((RegNo="")&&(+RegNo=0)) ""
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PIBI="" ""
	s PIADM=""
	s CurStatus=""
	b ;PIBI
	for  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")||(CurStatus'="")  d
	.s Status=$p(^DHCPEPreIADM(PIADM),"^",8)
	.q:Status="CANCELPE"
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)
	.q:LocFlag="1"
	.s CurStatus=Status
	q CurStatus
}

ClassMethod GetStatusByPAADM(PAADM)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	Q:IADM="" ""
	s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
	s PreIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
	s PIBI=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
	s RegNo=$P($g(^DHCPEPreIBI(PIBI)),"^",1)
	q Status_"^"_PreIADM_"^"_RegNo
}

ClassMethod GetPIADMByRegNo(RegNo)
{
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PIBI="" ""
	s PIADM=""
	s CurStatus=""
	for  Set PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")||(CurStatus'="")  d
	.s Status=$p(^DHCPEPreIADM(PIADM),"^",8)
	.q:Status'="REGISTERED"
	.
	.s IADM=PIADM
	.s CurStatus=Status
	q IADM
}

ClassMethod GetIfPccu(VIP)
{
	
	q:(VIP="") ""
	s cspfile=""
	s cspfile=$p($g(^DHCPEVIPLevel("VIP",VIP)),"^",10)
	q cspfile
}

ClassMethod UpdateRoomPlace(Type, ID, RoomPlace)
{
	s $ZT="UpdateRoomPlaceErr"
	i Type="I" d
	.;&SQL(update sqluser.DHC_PE_PreIADM set PIADM_PEDeskClerk_DR=:RoomPlace where PIADM_RowID=:ID)
	.s OldRoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",ID))
	.;s $P(^DHCPEPreIADM(ID),"^",7)=RoomPlace
	.s ^DHCPEDataEx("DHCPEPreIADM","RoomPlace",ID)=RoomPlace
	e  d  ;分组
	.s IADM=0
	.f  s IADM=$O(^DHCPEPreIADM(0,"PGTeam",ID,IADM)) q:IADM=""  d
	..d ..UpdateRoomPlace("I",IADM,RoomPlace)
	q 0
UpdateRoomPlaceErr
	q -1_"^"_$zerror
}

ClassMethod IsCanCheck(RoomID, PAADM)
{
	s $ZT="IsCanCheckErr"
	s CurTime=$P($H,",",2)
	q:CurTime>43200 1
	s CurDate=+$H
	s RoomID=$P(RoomID,"$",1)
	q:RoomID="" "1"
	s PAdm=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s AdmDate=$P(^DHCPEIADM(PAdm),"^",5)
	q:AdmDate<CurDate 1
	s PreAdm=$P(^DHCPEIADM(PAdm),"^",4)
	s AdmRoomPlace=$G(^DHCPEDataEx("DHCPEPreIADM","RoomPlace",PreAdm))
	q:AdmRoomPlace="" "0"
	s:AdmRoomPlace="" AdmRoomPlace=$O(^DHCPECTDataEx("RoomPlace",0))
	s AreaID=$P(RoomID,"||",1)
	s Sub=$P(RoomID,"||",2)
	;s RoomPlace=$LG(^User.DHCPEAreaD(AreaID,"ChildRoom",Sub),17)
	;q:(RoomPlace'="")&&(RoomPlace'=AdmRoomPlace) 0
	q:'$D(^User.DHCPERoomRoomPlaceI("RoomPlaceIndex",AreaID,Sub," "_AdmRoomPlace)) 0
	q 1
IsCanCheckErr
	q $ZERROR
}

/// d ##class(web.DHCPE.PreIADM).JudgeIGByRegNo(RegNo)
ClassMethod JudgeIGByRegNo(RegNo)
{
   
	S flag=""
	if ($d(^DHCPEPreIBI(0,"PAPMINo",RegNo))) s flag="I"
	If ($d(^DHCPEPreGBI(0,"PAPAMINo",RegNo))) s flag="G"
	If ('$d(^PAPERi("PAPMI_PatNo",RegNo))) s flag="N"
	Q flag
}

/// d ##class(web.DHCPE.PreIADM).IsExistDefaultOrdSet()
ClassMethod IsExistDefaultOrdSet(PreIAdm)
{
	s OrdSetsDR=""
	s Vip=$p($g(^DHCPEPreIADM(PreIAdm)),"^",18)
	//s OrdSetsDR=$P($g(^DHCPEVIPLevel("VIP",Vip)),"^",11)
	
	/***多院区***/
	s LocID=$p($g(^DHCPEPreIADM(PreIAdm)),"^",26)
	s VIPSetID=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,Vip,0))
	i VIPSetID'="" s OrdSetsDR=$lg($g(^CF.PE.LocVIPLevelD(VIPSetID)),9)
	/***多院区***/

	q OrdSetsDR
}

ClassMethod UpDateMark(PIADM, Mark)
{
	//s ^DHCPEDataEx("Mark","I",PIADM)=Mark
    //q $g(^DHCPEDataEx("Mark","I",PIADM))
    s flag=""
    q:Mark="" flag
    if ($p($g(^DHCPEPreIADM(PIADM)),"^",20)'=Mark) s flag=0
    S $p(^DHCPEPreIADM(PIADM),"^",20)=Mark
    q flag
}

/// Creator:     xueying
/// CreateDate:  2018-03-13
/// Descript:    获取病理检查医嘱rowid 多个参数之间使用;分割 
/// Debug:   d ##class(web.DHCPE.PreIADM).GetPISOrdRowId("975")
ClassMethod GetPISOrdRowId(PAADM, Type)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
    s Status=$p($g(^DHCPEIADM(IADM)),"^",8)
    ;Q:Status'="ARRIVED" "" 
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s PIADM=$P($g(^DHCPEIADM(IADM)),"^",4)
    s LocID=$P($g(^DHCPEPreIADM(PIADM)),"^",26) //就诊科室ID
	s oeord=$O(^OEORD(0,"Adm",PAADM,0))
	q:oeord="" ""
	s ordInfo=""
	s Ord=$O(^OEORD(0,"Adm",PAADM,0))
	q:Ord="" ""
	s OrdItemID=""
	s OrdItemIDNew=""
	s Sub=0
	f  s Sub=$O(^OEORD(Ord,"I",Sub)) q:Sub=""  d
	.s OrdItemID=Ord_"||"_Sub
	.s markid=$p($G(^OEORD(Ord,"I",Sub,1)),"^",2)
	.q:markid=""
	.s ordtype=$p($G(^OEORD(Ord,"I",Sub,1)),"^",13)
	.q:ordtype'="1"
	.;s PISTypeID=$g(^DHCPECTDataEx("DHCPEStationOrder","PISCodeType",markid))
	.;s stationid=$o(^DHCPEST(0,"STORD_ARCIM",markid,"")) 
	.s StaOrderID=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(markid,LocID)
	.q:StaOrderID=""
	.s stationid=$p(StaOrderID,"||",1)
	.s STDesc=""
	.I stationid'="" s STDesc=$p($g(^DHCPEST(stationid)),"^",2)
	.q:STDesc'["病理"
	.s StatOrdSetID=$o(^CF.PE.StationOrderSetI("IdxOfLocOrder"," "_LocID,StaOrderID,0))
	.q:StatOrdSetID=""
	.s PISTypeID=$lg($g(^CF.PE.StationOrderSetD(StatOrdSetID)),16)
	.q:(Type="T")&&(PISTypeID="")
	.q:'$d(^DHCAPPPM(0,"OrdItem",OrdItemID)) //未发送病理申请单
	.i OrdItemIDNew="" d
	..s OrdItemIDNew=OrdItemID
	.e  d
	..s OrdItemIDNew=OrdItemIDNew_";"_OrdItemID 
    q OrdItemIDNew
}

ClassMethod HISUIGetPatientID(PAPMINo As %Library.String = "")
{
	
	s PatientID=""
    i PAPMINo'=""  d
    .s PatientID=$o(^PAPERi("PAPMI_PatNo",PAPMINo,0))
	q "{""PatientID"":"""_PatientID_"""}"
}

ClassMethod HISUISave(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "", User As %String = "", DepLoc As %String = "")
{
	new Date,Time,StartDate,EndDate,IID,GID
	s NetPreID=$P(InString,"$$",2)
	s InString=$P(InString,"$$",1)
	;"^1261^^^14/10/70^14/10/70^^^PREREG^N^N^N^^N^N^^DC^ID^1^^^^^^^^^0^0^^1^^^6"
	k PLIST
	i User="" d
	.s:$d(%session) User=%session.Get("LOGON.USERID")
	.s:'$d(%session) User=5918
	s Date=+$H
	s Time=$P($H,",",2)
	s iLLoop=1
	
	// PIADM_RowId 1
	s value=$p(InString,"^",iLLoop)
	s:(""'=value) PLIST(iLLoop)=value
	s IID=value
	s iLLoop=iLLoop+1
	
	//预登记个人基本信息号 PIADM_PIBIDR	2
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//对应团体的ADM PIADM_PGADMDR	3
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s GID=value
	s iLLoop=iLLoop+1
	/*
	i (GID'="")&&(IID="")
	{
		q:..IsNoUseAudit(GID,"PRE","G","CRM") "Err Audit"
	}
	*/
	//对应组ADM PIADM_PGTeamDR	4
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	//i value'=""  s 
	//预约体检日期 PIADM_PEDateBegin	5
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=##class(websys.Conversions).DateHtmlToLogical(value)
	s PLIST(iLLoop)=value
	s StartDate=value
	s iLLoop=iLLoop+1
	
	// 预约体检日期结束 PIADM_PEDateEnd 6
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=##class(websys.Conversions).DateHtmlToLogical(value)
	s PLIST(iLLoop)=value
	s EndDate=value
	s iLLoop=iLLoop+1
	
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=0
	//i StartDate>EndDate q "Err Date"
	
	//预约体检时间 PIADM_PETime	7
	s value=$p(InString,"^",iLLoop)
	;i (""'=value) s value=$ZTH(value)
	s value = $P(value,"-",1)
	i (""'=value) s value=##class(websys.Conversions).TimeHtmlToLogical(value)
	i value="" s value=$p($H,",",2)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//预约接待人员 PIADM_PEDeskClerk_DR	8
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// PIADM_Status	9  
	s value=$p(InString,"^",iLLoop)
	i '($D(PLIST(1))) s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//视同收费 PIADM_AsCharged	10
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加项	PIADM_AddOrdItem	11
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 加项金额限制	PIADM_AddOrdItemLimit 12
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加项金额	PIADM_AddOrdItemAmount 13
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加药	PIADM_AddPhcItem 14
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 加药金额限制	PIADM_AddPhcItemLimit 15
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 允许加药金额	PIADM_AddPhcItemAmount 16
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 个人报告发送	PIADM_IReportSend 17
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// 结算方式	PIADM_DisChargedMode 18
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// VIP PIADM_VIP 19
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	// PIADM_DelayDate20
	s value=$p(InString,"^",iLLoop)
	i (""'=value) s value=$ZTH(value,2)
	//s PLIST(iLLoop)=value
	s iLLoop=iLLoop+1
	
	//PIADM_Remark21
	s value=$p(InString,"^",iLLoop)
	s PLIST(iLLoop)=value
	
	s iLLoop=iLLoop+1
	
	s Sales=$p(InString,"^",iLLoop) //22
	
	s PLIST(iLLoop)=User    
	s iLLoop=iLLoop+1   
	s Type=$p(InString,"^",iLLoop) //23
	
	s PLIST(iLLoop)=Date
	s iLLoop=iLLoop+1
	s GetReportDate=$p(InString,"^",iLLoop)  //24
	i GetReportDate'="" s GetReportDate=##class(websys.Conversions).DateHtmlToLogical(GetReportDate)
	
	s PLIST(iLLoop)=Time
	s iLLoop=iLLoop+1
	s GetReportTime=$p(InString,"^",iLLoop)  //25
	i GetReportTime'="" s GetReportTime=$ZTH(GetReportTime)
	i GetReportTime="" s GetReportTime=$p($H,",",2)
	
	
	s PLIST(iLLoop)=Sales 
	//类型
	s iLLoop=iLLoop+1
	s PayType=$p(InString,"^",iLLoop)  //26
	s PLIST(iLLoop)=PayType 
	///付款百分比
	;s PLIST(iLLoop)=Type
	s iLLoop=iLLoop+1
	s Percent=$p(InString,"^",iLLoop)  //27
	i DepLoc="" d
	.s:$d(%session) DepLoc=%session.Get("LOGON.CTLOCID")      //add 2009-08-05
	.s:'$d(%session) DepLoc=572
	s PLIST(iLLoop)=DepLoc                
	
	
	//是否给客人吃饭
    s iLLoop=iLLoop+1
	s DietFlag=$p(InString,"^",iLLoop)  //28
    //是否给客人赠品
    s iLLoop=iLLoop+1
    s GiftFlag=$p(InString,"^",iLLoop) //29
    
    s iLLoop=iLLoop+1                    //add by zl20100207  保险公司
    s InsureUnit=$p(InString,"^",iLLoop)  //30
    s iLLoop=iLLoop+1                    //add by zl20100222  病人类型
    s PatType=$p(InString,"^",iLLoop)  //31
  	i PatType="" s PatType=$p($G(^DHCPEPreIBI(PLIST(2))),"^",5)
    s iLLoop=iLLoop+1
    s CheckRoom=$p(InString,"^",iLLoop) //32
    s iLLoop=iLLoop+1
    s Position=$p(InString,"^",iLLoop)  //33
    i Position="" s Position=$p($G(^DHCPEPreIBI(PLIST(2))),"^",11)
    s iLLoop=iLLoop+1
    s ADMFeeType=$p(InString,"^",iLLoop) //34
    s iLLoop=iLLoop+1
	s ReCheckFlag=$p(InString,"^",iLLoop) //35 复检	
	s ReCheckRecord=$p(ReCheckFlag,"@@",2)
	s ReCheckFlag=$p(ReCheckFlag,"@@",1)
	s PLIST(29)=ReCheckFlag
	s PLIST(30)=ReCheckRecord
    
    s iLLoop=iLLoop+1
    s RoomPlace=$p(InString,"^",iLLoop) //36  检查位置
    //s PLIST(8)=RoomPlace
    
    s iLLoop=iLLoop+1
    s DetailID=$p(InString,"^",iLLoop) //37  排班ID
   	s PLIST(31)=DetailID
   	
   	i DetailID'=""
   	{
	   	s sexId = $P(^DHCPEPreIBI(PLIST(2)),"^",3)
	   	s pmType = $CASE(PLIST(3)'="",1:"G",:"I")
	   	s availNum = ##class(web.DHCPE.SourceManager).GetAvailNum(DetailID,sexId,pmType,PLIST(19))
	   	q:availNum<=0 "{""ret"":""无可用号源，请重新选择体检时间！""}"
   	}
   	
    s ret=..ISave2()
    
    i NetPreID'="" d
    .i $P(ret,"^",1)=0 d
    ..s NetSetsID=$lG(^User.DHCPENetPreRecordD(NetPreID),8)
    ..s PreIADMDR=$P(ret,"^",2)
    ..d:PreIADMDR'="" ##class(web.DHCPE.PreItemList).IInsertItem(PreIADMDR,"PERSON","PRE","",NetSetsID,User)
    ..s InString="1^"_User_"^"_PreIADMDR
    ..d ##class(web.DHCPE.NetPre.GetPreInfo).UpdateStatus(NetPreID,InString)
	
	q "{""ret"":"""_ret_"""}"
}

// added by xy 20180427

// function:判断转组人员是否满足分组条件

ClassMethod IsSatisfyTeamInfo(PreIADM, PreTeamID, TaamInfo, PIBIName)
{
	
	new ret
	s PIBIDR=$p($g(^DHCPEPreIADM(PreIADM)),"^",1)
	s PIBIName=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
	S PGTeamDR=$p($g(^DHCPEPreIADM(PreIADM)),"^",3)
	s SexDesc=""
	s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
	i SexDR'="" s SexDesc=$p($g(^CT("SEX",SexDR)),"^",2)
	s DOB=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4)
	s Age=##class(web.DHCLCNUREXCUTE).CalAge(DOB,+$h)
	s Age=$P(Age,"Y",1)
	s MarriedDesc=""
	s MarriedDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",17)
	i MarriedDR'="" s MarriedDesc=$p($g(^CT("MAR",MarriedDR)),"^",2)
	
	s TeamSex="",TeamMarried="",TeamUpperLimit="",TeamLowerLimit=""
	s TeamSex=$p(TaamInfo,"^",1)
	s TeamMarried=$p(TaamInfo,"^",2)
	s TeamUpperLimit=$p(TaamInfo,"^",3)
	s TeamLowerLimit=$p(TaamInfo,"^",4)
	
	s ret=0
	s flag=0
	
   	I (PreTeamID=PGTeamDR) d
   	.s ret=ret_","_"同一个分组不需要进行转组"
   	.s flag=2
   	
	i (""'=TeamLowerLimit)&&(" "'=TeamLowerLimit)&&(Age<TeamLowerLimit) d
	.s ret=ret_","_"客户年龄小于分组维护的年龄下限"
	.s flag=1

	i (""'=TeamUpperLimit)&&(" "'=TeamUpperLimit)&&(Age>TeamUpperLimit) d
	.s ret=ret_","_"客户年龄大于分组维护的年龄上限"
	.s flag=1
	
	i (TeamMarried'="")&&(TeamMarried'=MarriedDesc)&&(TeamMarried'="不限") d
	.s ret=ret_","_"客户婚姻状况与分组婚姻状况不符"
	.s flag=1
	
	i (TeamSex'="")&&(TeamSex'=SexDesc)&&(TeamSex'="不限") d
	.s ret=ret_","_"客户性别与分组性别不符"
	.s flag=1
	
	i flag=1 d
	.s $P(ret,",",1)="-1"
	.s ret=ret_","_"是否继续增加?"
	
	i flag=2 d
	.s $P(ret,",",1)="-2"
	
	i flag=0 d
	.s $P(ret,",",1)="0"
	
	q ret
}

ClassMethod GetPIBIByPIADM(PIADM)
{
	s PIBIDR=$p($g(^DHCPEPreIADM(PIADM)),"^",1)
	q PIBIDR
}

ClassMethod IsHaveResultByPAADM(PAADM As %String = "")
{
	q:'$d(^DHCPERLT(0,"ADM",PAADM)) "0"
	q:$d(^DHCPERLT(0,"ADM",PAADM)) "1"
}

/// 功能：计算个人未交费的自费项目的实际总金额
/// w ##class(web.DHCPE.PreIADM).IsZFItemUPFee(11394)
ClassMethod IsZFItemUPFee(AdmId As %Library.String = "")
{
	
 	s AuditId="",FactAmountTotal=0	
 	f  s AuditId=$o(^DHCPEPreA(0,"CRMADM","I",AdmId,AuditId))  q:AuditId=""  d
    .s Flag=$p($g(^DHCPEPreA(AuditId)),"^",21)
	.q:Flag="NU"
	.s AuditType=$p($g(^DHCPEPreA(AuditId)),"^",1)
	.q:AuditType'="I"
	.s ChargedStatus=$p($g(^DHCPEPreA(AuditId)),"^",14)
	.q:ChargedStatus="CHARGED" 
	.s FactAmount=$p($g(^DHCPEPreA(AuditId)),"^",9)
	.s FactAmountTotal=FactAmountTotal+FactAmount
	
	q FactAmountTotal
}

/// 功能：获取个人基本信息
/// w ##class(web.DHCPE.PreIADM).GetPreIBaseInfo()
ClassMethod GetPreIBaseInfo(PIBIRowId As %Library.String = "")
{
	q:PIBIRowId="" ""
	s Data=$g(^DHCPEPreIBI(PIBIRowId))
	q Data
}

/// Creator：    xy 
/// CreatDate：  20220920
/// Description: 获取病人部分信息
/// Input:       RegNo(登记号),LocID(科室ID)
/// Return：     职业^公司^邮编^民族^电子邮箱^血型
/// debug:  w ##class(web.DHCPE.PreIADM).GetPatBaseInfo()
ClassMethod GetPatBaseInfo(RegNo As %String = "", LocID As %String = "")
{
	q:(RegNo="")||(LocID="") "^^^^^"
	s (Vocation,Company,Postalcode,NationDR,Email,BloodDR)=""
	i RegNo'="" d
	.s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,LocID)
	.S RegNo=$$ALPHAUP^SSUTIL4(RegNo)
	.s PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	.s NationDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1) //民族
    .s Vocation=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",6)        //职业
	.s Postalcode=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",19) //邮编
	.s Company=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18)  //公司
	.s BloodDR=$p($g(^PAPER(PAPMIRowId,"PER",5)),"^",32)  //血型 
	.s Email=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",19)  //电子邮箱
	q Vocation_"^"_Company_"^"_Postalcode_"^"_NationDR_"^"_Email_"^"_BloodDR
}

/// 获取是否可以同时加项的标志
/// 标志：1 个人团体不能同时加项
///       2 不是同一个团体不能同时加项
///       3 不是同一个状态不能同时加项
///       4 不是同一个VIP等级的不能同时加项
///       5 某个人已收表不允许加项
///       6 不是登记或者到达状态，不能同时加项
/// w ##class(web.DHCPE.PreIADM).GetPreFlag("1044^919","0","1")
ClassMethod GetPreFlag(IDs, IFlag As %Library.String = "0", GFlag As %Library.String = "0")
{
	s GNumFlag=0,iPGADM="",StatusFlag=0,iStatus="",VIPFlag=0,iVIP="",IsAddItemFlag=0,RecPaperStr=""
	i $l(IDs,"^")=1 q "0"
	i ((IFlag=1)&&(GFlag=1)) q "1"
	s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
	s:'$D(%session) LocID=304
	s IsAddItem=$G(^DHCPESetting("DHCPE","IsAddItem",LocID))
	s iRowID=+IDs
	s iPGADM=$p(^DHCPEPreIADM(iRowID),"^",2)
	s iStatus=$p(^DHCPEPreIADM(iRowID),"^",8)
	q:((iStatus'="ARRIVED")&&(iStatus'="REGISTERED")) "6"
	s iVIP=$p(^DHCPEPreIADM(iRowID),"^",18)
	f i=1:1:$L(IDs,"^") d
	.s PreIADM=$p(IDs,"^",i)
	.s PreGADM=$p(^DHCPEPreIADM(PreIADM),"^",2)
	.i PreGADM'=iPGADM s GNumFlag=1
	.s Status=$p(^DHCPEPreIADM(PreIADM),"^",8)
	.i Status'=iStatus s StatusFlag=1
	.s VIPLevel=$p(^DHCPEPreIADM(PreIADM),"^",18)
	.i VIPLevel'=iVIP s VIPFlag=1
	.i ($d(^DHCPEDataEx("ConfirmRecPaper",PreIADM)))&&(IsAddItem'="Y") d
	..s IsAddItemFlag=1
	..s PIBI=$p(^DHCPEPreIADM(PreIADM),"^",1)
	..s Name=$p(^DHCPEPreIBI(PIBI),"^",2)
	..i RecPaperStr="" d
	...s RecPaperStr=Name
	..e  d
	...s RecPaperStr=RecPaperStr_"、"_Name
	
	q:GNumFlag=1 "2"
	q:StatusFlag=1 "3"
	q:VIPFlag=1 "4"
	q:IsAddItemFlag=1 "5"_"^"_RecPaperStr
	q "0"
}

/// Creator:		jinlei	
/// CreatDate:		2019-12-20
/// Description:	判断批量转组是否符合新组的条件
/// Table:		
/// Input:		PIADMStr
/// Output:		
/// Return:		
/// Debug:		w ##class(web.DHCPE.PreIADM).IsAllSatisfyTeamInfo("11643","311||6","男^不限^100^40")        
ClassMethod IsAllSatisfyTeamInfo(PreIADMStr, PreTeamID, TaamInfo)
{
	s ^TMPDHCPEJL("IsAllSatisfyTeamInfo")=$LB(PreIADMStr, PreTeamID, TaamInfo)
	s Len=$L(PreIADMStr,"^")
	s ret=""
    for i=1:1:Len d
    .s PreIADM=$P(PreIADMStr,"^",i)
    .s PIBIName=""
    .s oneflag=..IsSatisfyTeamInfo(PreIADM, PreTeamID, TaamInfo,.PIBIName)
    .i $P(oneflag,",",1)'=0 d
    ..i ret'="" s ret=ret_$C(10)_PIBIName_$P(oneflag,",",2)
    ..e  s ret=PIBIName_$P(oneflag,",",2)
    
    s flag=0
    i ret'="" s flag="-1"
    q flag_"^"_ret
}

/// function:获取VIP
/// d ##class(web.DHCPE.PreIADM).GetVIPByPIAdm()
ClassMethod GetVIPByPIAdm(PreIAdm)
{
	q:PreIAdm="" ""
	S VipDesc=""
	s VipId=$p($g(^DHCPEPreIADM(PreIAdm)),"^",18)
	//i VipId'="" s VipDesc=$p($g(^DHCPEVIPLevel("VIP",VipId)),"^",2)
	i VipId'="" s VipDesc=$lg($g(^CT.PE.VIPLevelD(VipId)),3) 
	q VipDesc
}

/// Creator：    xueying
/// CreatDate：  20220610
/// Description: 个人预约查询界面项目明细
/// Input:       EpisodeID(就诊ID)
/// Debug: d ##Class(%ResultSet).RunQuery("web.DHCPE.PreIADM","OrdItemStatus","1169")
Query OrdItemStatus(EpisodeID As %String = "", CSPName As %String = "") As %Query(ROWSPEC = "Ord_ItemID:%String,Ord_ItemDesc:%String,Ord_ItemStatus:%String,Ord_Doctor:%String,Ord_Date:%String,Bill_Status:%String")
{
}

ClassMethod OrdItemStatusExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", CSPName As %String = "") As %Status
{
	s ^tempdhcpe("OrdItemStatus")=EpisodeID
	Set repid=$I(^CacheTemp)
    s ind=1
 	i ""=EpisodeID {	
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	
	s LocID=$p($g(^PAADM(EpisodeID)),"^",4)
	s OtherStation=$g(^DHCPESetting("DHCPE","StationId_Other",LocID))
	s MedStation=$g(^DHCPESetting("DHCPE","StationId_Medical",LocID))
	
	s PEIAdmId=$o(^DHCPEIADM(0,"PAADM",EpisodeID,""))
	
	s Stations=""
	s SortNum=0
	
	s OEOrder=$O(^OEORD(0,"Adm",EpisodeID,0))  
	q:OEOrder="" ""
	
	s OEOrdItem=0
	f  s OEOrdItem=$O(^OEORD(OEOrder,"I",OEOrdItem))  q:OEOrdItem=""  d
	.s RealORIStat=$p($g(^OEORD(OEOrder,"I",OEOrdItem,1)),"^",13)
	.q:(RealORIStat="4")
	.s ORIStat=RealORIStat
	.s OEORIRowId=OEOrder_"||"_OEOrdItem
	.//q:$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId))   //放弃状态
	.s BillStatus=""
	.s CRMOId=$o(^DHCPECRMO(0,"OEORI",OEORIRowId,0))   
	.q:CRMOId=""
	.s CRMOrI=$p($g(^DHCPECRMO(CRMOId)),"^",2)
	.q:CRMOrI=""
	.s BillStatus=$p($g(^DHCPECRMO(CRMOId)),"^",4)
	.s BillStatus=..GetBillStatu(BillStatus)
	.s ItemMastId=$p($G(^DHCPEPreIADM($p(CRMOrI,"||",1),"ORDITEM",$p(CRMOrI,"||",2))),"^",1)
	.q:ItemMastId=""
    .s StatusDesc="未检"
    .s ORIStat=0
	.s Flag=1
	.s Station="",StationDesc=""
	.s StatOrderDR=##class(web.DHCPE.CT.HISUICommon).GetStatOrderIDByARCIM(ItemMastId,LocID)
    .s Station=$p(StatOrderDR,"||",1)            //站点ID
	.q:(OtherStation=Station)||(MedStation=Station)  //过滤其他站点、药品站点
	.s:Station'="" StationDesc=$P($g(^DHCPEST(Station)),"^",2)
	.s ArcDesc=$p($g(^ARCIM(+ItemMastId,$P(ItemMastId,"||",2),1)),"^",2)
	.s OEORILabEpisodeNo=$p($G(^OEORD(OEOrder,"I",OEOrdItem,3)),"^",20)
	.i $d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEORIRowId)) d
	..s StatusDesc="弃检"
	..s ORIStat="2"
	.e  i $d(^User.DHCPEDelayRecordI("FlagADMOEORIIndex","Y",EpisodeID," "_OEORIRowId)) d
	..s DelayRecordID=$O(^User.DHCPEDelayRecordI("OEORIIndex"," "_OEORIRowId,0))
	..s DelayFlag=$lg($g(^User.DHCPEDelayRecordD(DelayRecordID)),4)
	..i DelayFlag="Y" d
	...s StatusDesc="延期"
	...s ORIStat="3"
	.e  i ((OEORILabEpisodeNo'="")&&($D(^DHCPETempLabEpisodeScan(OEORILabEpisodeNo))))  d
	..s StatusDesc="已采"
	..s ORIStat="4"
	.e  i $D(^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",OEORIRowId))  d
	..s StatusDesc="已检"
	..s ORIStat="5"
	.;e  i (StationDesc["病理") d
	.;.s ReqItmStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(OEORIRowId,"","")  //Ens_StatusCode
	.;.i ReqItmStatus'="" d
	.;..s StatusDesc="已检"
	.;..s ORIStat="5"
	.i RealORIStat="6" d
	..s StatusDesc="已执行"
	..s ORIStat=RealORIStat
	
	.s Doctor="",RELDate=""
	.s RLT="" 
	.f  s RLT=$O(^DHCPERLT(0,"OEORI",OEORIRowId,RLT)) q:((RLT="")||(Doctor'=""))  d
	..s Doctor=$P($g(^DHCPERLT(RLT)),"^",5)
    ..i Doctor'="" s Doctor=$P($g(^SSU("SSUSR",Doctor)),"^",2)
    ..s RELDate=$P($g(^DHCPERLT(RLT)),"^",6)
    ..i RELDate'="" s RELDate=##class(websys.Conversions).DateLogicalToHtml(RELDate)
    .d OrdItemStatus
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OrdItemStatus 
	/***翻译 start***/
    s BillStatus=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,BillStatus)
    s StatusDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc(CSPName,StatusDesc)
	s ArcDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ArcDesc,"ARCIMDesc","cls")
    /***翻译 end***/       
	set Data=$lb(OEORIRowId,ArcDesc,StatusDesc,Doctor,RELDate,BillStatus)
 	Set ^CacheTemp(repid,((ORIStat*10000000)+(Station*10000))+ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod OrdItemStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrdItemStatusExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OrdItemStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrdItemStatusExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 得到账单状态
ClassMethod GetBillStatu(Statu)
{
	s StatuDesc=""
	i Statu="NP" s StatuDesc="未付费"
	i Statu="OC" s StatuDesc="挂帐"
	i Statu="P" s StatuDesc="付费"
	i Statu="PP" s StatuDesc="部分付费"
	q StatuDesc
}

/// Creator： 	 xy 
/// CreatDate：  20220620
/// Description: 视同收费的项目是否已经执行
/// Input:       RowID:预约ID,Type:G/I
/// Return：     1/0
/// debug: w ##class(web.DHCPE.PreIADM).IsExcuteByAsCharged("I","353")
ClassMethod IsExcuteByAsCharged(Type, RowID)
{
	s ^tempdhcpe("IsExcuteByAsCharged")=$lb(Type, RowID)
	S flag=0
	
	if (Type="I"){
		s PreIADM=RowID
		s Status=$p($g(^DHCPEPreIADM(PreIADM)),"^",8)
		q:Status="CANCELPE" "0"
		s IADMAsCharged=$p($g(^DHCPEPreIADM(PreIADM)),"^",9)
   	 	q:IADMAsCharged'="Y" "0"
    	s Sub=0
   	 	f  s Sub=$o(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub)) q:(Sub="")||(flag=1)  d
    	.s PreItemID=PreIADM_"||"_Sub
   		.s crmID=$o(^DHCPECRMO(0,"CRMORI",PreItemID,0))
   		.q:crmID=""
   		.s ItemAsCharged=$p($G(^DHCPEPreIADM(PreIADM,"ORDITEM",Sub)),"^",9)
    	.q:ItemAsCharged'="Y"
   		.s OEORIDR=$p($g(^DHCPECRMO(crmID)),"^",1)
   		.s ItmMastDR=$p($g(^OEORD($p(OEORIDR,"||",1),"I",$p(OEORIDR,"||",2),1)),"^",2)
        .q:ItmMastDR="" 
    	.s Stat=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),1)),"^",13)
    	.i $d(^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",OEORIDR))||(Stat="6") S flag=1
    	
	}elseif (Type="G"){
		S PGADM=RowID
		s PIADM=""
		f  s PIADM=$o(^DHCPEPreIADM(0,"PGADM",PGADM,PIADM)) q:(PIADM="")||(flag=1)  d
		.s Status=$p($g(^DHCPEPreIADM(PIADM)),"^",8)
		.q:Status="CANCELPE"
		.s IADMAsCharged=$p($g(^DHCPEPreIADM(PIADM)),"^",9)
   	 	.q:IADMAsCharged'="Y" 
		.s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,0))
		.q:IADM=""
		.s CRMORowId=0
		.f  s CRMORowId=$o(^DHCPECRMO(0,"IADM",IADM,CRMORowId)) q:(CRMORowId="")||(flag=1)  d
		..s OEORIDR=$p($g(^DHCPECRMO(CRMORowId)),"^",1)
		..s PreItemID=$p($g(^DHCPECRMO(CRMORowId)),"^",2)
		..s ItemAsCharged=$p($G(^DHCPEPreIADM(+PreItemID,"ORDITEM",$P(PreItemID,"||",2))),"^",9)
    	..q:ItemAsCharged'="Y"
		..s ItmMastDR=$p($g(^OEORD(+OEORIDR,"I",$p(OEORIDR,"||",2),1)),"^",2)
        ..q:ItmMastDR="" 
    	..s Stat=$p($g(^OEORD(+OEORIDR,"I",$P(OEORIDR,"||",2),1)),"^",13)
    	..i $d(^DHCPEDataEx("DHCPEPreIOrdItem","SubStatus",OEORIDR))||(Stat="6") S flag=1
	}
	q flag
}

/// Description：转组
/// Input:   
/// 			OriPreIADM ：DHC_PE_PreIADM	
/// 				TargetTeam: 目标分组 DHC_PE_PreGteam
/// Return:		0：成功 非0：失败
/// Creator:	wangguoying
/// CreateDate:	2022-07-06
/// Debug: w ##class(web.DHCPE.PreIADM).MoveTeam("3650","205||1")
ClassMethod MoveTeam(OriPreIADM, TargetTeam)
{
	s ^tmpwgy("MoveTeam")=$lb(OriPreIADM,TargetTeam)
	s $zt = "MoveTeamErr"
	TS
	// 先取消体检
	s ret = ##class(web.DHCPE.CancelPE).CancelPE(OriPreIADM,"I",0,1)  //,$P(^DHCPEPreIADM(OriPreIADM),"^",26))
	i ret'="0^完成取消体检操作"  Tro  q "-1^"_ret
	s pibi = $P(^DHCPEPreIADM(OriPreIADM),"^",1)
	s ret = ..InsertIADMInGTeam(pibi,+TargetTeam,TargetTeam)
	i +ret'=0  tro  q ret
	s ret = ..UpdateExtPreInfo(OriPreIADM,$P(ret,"^",2))
	i ret'=0 tro  q ret
	TC
	q 0
MoveTeamErr
	s $zt = ""
	Tro
	q "-100^"_$ZE
}

/// Description：更新预约记录信息
/// Input:   
/// 			OriPreIADM ：DHC_PE_PreIADM	
/// 				TargetPreIADM: 目标DHC_PE_PreIADM	
/// Return:		0：成功 非0：失败
/// Creator:	wangguoying
/// CreateDate:	2022-07-06
/// Debug: w ##class(BILL.EINV.BL.COM.PECommon).NeedEnv("TJYJJ")
ClassMethod UpdateExtPreInfo(OriPreIADM, TargetPreIADM)
{
	q 0
	/**  以下是全程医疗拓展字段,其他项目按需定制 **/
	s oldObj = ##class(User.DHCPEPreIADM).%OpenId(OriPreIADM,0)
	s newObj = ##class(User.DHCPEPreIADM).%OpenId(TargetPreIADM,0)
	s newObj.PIADMHealthManage = oldObj.PIADMHealthManage
	s newObj.PIADMGP  = oldObj.PIADMGP 
	s newObj.PIADMRecomme  = oldObj.PIADMRecomme 
	s newObj.PIADMExploit  = oldObj.PIADMExploit 
	s newObj.PIADMServiceGroup  = oldObj.PIADMServiceGroup 
	s newObj.PIADMExploitType  = oldObj.PIADMExploitType 
	s newObj.PIADMDetailId  = oldObj.PIADMDetailId 
	s newObj.PIADMSecrecyType  = oldObj.PIADMSecrecyType 
	s newObj.PIADMReplaceItemFlag  = oldObj.PIADMReplaceItemFlag 
	s newObj.PIADMReplaceItemUserDR  = oldObj.PIADMReplaceItemUserDR 
	s newObj.PIADMReplaceItemDate  = oldObj.PIADMReplaceItemDate 
	s newObj.PIADMReplaceItemTime  = oldObj.PIADMReplaceItemTime 
	s newObj.PIADMADMType  = oldObj.PIADMADMType 
	s newObj.PIADMRSRDR = oldObj.PIADMRSRDR 
	s newObj.PIADMBedRemark  = oldObj.PIADMBedRemark 
	s newObj.PIADMHandoverRemarks  = oldObj.PIADMHandoverRemarks 
	s newObj.PIADMChargeRemarks  = oldObj.PIADMChargeRemarks 
	s newObj.PIADMMailingAddress  = oldObj.PIADMMailingAddress 
	s newObj.PIADMReportWay  = oldObj.PIADMReportWay 
	s newObj.PIADMCaptchaCode  = oldObj.PIADMCaptchaCode 
	s newObj.PIADMTeamGroup  = oldObj.PIADMTeamGroup 
	s newObj.PIADMCustomerSource  = oldObj.PIADMCustomerSource 
	s newObj.PIADMExpressOrder  = oldObj.PIADMExpressOrder 
	s newObj.PIADMUsedLimitAmt  = oldObj.PIADMUsedLimitAmt 
	//s newObj.PIADMFinish   = oldObj.PIADMFinish  
	s newObj.PIADMSecondName  = oldObj.PIADMSecondName 
	s sc = newObj.%Save()
	d oldObj.%Close()
	d newObj.%Close()
	i $$$ISERR(sc)  q "-1"_$SYstem.Status.GetErrorText(sc)
	q 0
}

/// Creator:		zhongricheng
/// CreatDate:		2022-11-14
/// Description:	获取关联的复查记录  获取复查关联的原纪录
/// Table:		
/// Input:			PreIADM   "Original" 获取原纪录    "Review" 获取复查记录
/// Output:		
/// Return:		
/// Debug:		w ##class(web.DHCPE.PreIADM).GetReviewRecord("5291","","Original")  
/// Debug:		w ##class(web.DHCPE.PreIADM).GetReviewRecord("3772","","Review")      
ClassMethod GetReviewRecord(Id, IDType, RType)
{
	q:((Id="")||(RType="")) ""
	s PreIADM=""
	if IDType="PAADM" {
		s IADM=$o(^DHCPEIADM(0,"PAADM",Id,0))
		q:IADM="" ""
		s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	} elseif IDType="IADM" {
		s PreIADM=$p($g(^DHCPEIADM(Id)),"^",4)
	} else {
		s PreIADM=Id
	}
	q:PreIADM="" ""
	q:'$d(^DHCPEPreIADM(PreIADM)) ""
	
	s RId=""
	if (RType="Original") {
		s ReFlag=$p($g(^DHCPEPreIADM(PreIADM)),"^",28)
		q:ReFlag'="Y" ""
		s RId=$p($g(^DHCPEPreIADM(PreIADM)),"^",29)
	} elseif (RType="Review") {
		s RId=$o(^DHCPEPreIADM(0,"ReCheckRecord",PreIADM,0))
		q:$p($g(^DHCPEPreIADM(RId)),"^",28)'="Y" ""
	}
	q RId
}

/// Creator:		zhongricheng
/// CreatDate:		2022-11-14
/// Description:	获取已总检的记录
/// Table:		
/// Input:			RegNo    IDCard    CardType    VIPLevel
/// Output:			预约记录ID  登记号 体检号 姓名 性别 年龄 联系电话 证件号 证件类型 单位 分组 部门 总检日期 总检结果 总检医生 总检建议
/// Return:			
/// Debug:			d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADM","GetHadSummaryList","28","","",3,2,105)
Query GetHadSummaryList(RegNo = "", IDCard = "", CardType = "", VIPLevel = "", HospID = "", LocID = "") As websys.Query(ROWSPEC = "PreIADM:%String,RegNo:%String,HPNo:%String,Name:%String,Sex:%String,Age:%String,PatTel:%String,PAIDCard:%String,PACCardType:%String,PACCardDesc:%String,GName:%String,TName:%String,Position:%String,VIPDesc:%String,SumDate:%String,SumDoc:%String,SumResult:%String,SumAdvice:%String")
{
}

ClassMethod GetHadSummaryListExecute(ByRef qHandle As %Binary, RegNo = "", IDCard = "", CardType = "", VIPLevel = "", HospID = "", LocID = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	if ((RegNo="")&&(IDCard="")) {
		Quit $$$OK
	}
	if RegNo="" {
		s RegNo=""
	}
	Quit:RegNo="" $$$OK
	Quit:VIPLevel="" $$$OK
	
	s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s PreIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	Quit:PreIBI="" $$$OK
	s PAPMI=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	Quit:PAPMI="" $$$OK
	s PreIBIData=$g(^DHCPEPreIBI(PreIBI))
	
	s PreIADM=""
	f {
		s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PreIBI,PreIADM),-1)
		q:((PreIADM="")||(PreIADM="0"))
		s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PreIADM,LocID)
  		continue:LocFlag=1
		s TReCheck=$p($g(^DHCPEPreIADM(PreIADM)),"^",28)
		;continue:TReCheck="Y"  //过滤复查记录
		
		continue:VIPLevel'=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
	
		s IADM=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
		continue:IADM=""
		s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
		continue:PAADM=""
		s:LocID="" LocID=$p($g(^PAADM(PAADM)),"^",4)
		continue:##class(web.DHCPE.ResultPermission).GetReportStatus(PAADM)'="Audited"
		i $g(^DHCPESetting("DHCPE","MainDoctorGroup",LocID))="Y" {
			continue:$g(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))=""
		}
		
		// 登记号 体检号 姓名 性别 年龄
		s HPNo=$p($g(^DHCPEPreIADM(PreIADM)),"^",27)
		s Name=$p(PreIBIData,"^",2)
		s Sex=$p(PreIBIData,"^",3)
		s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
		s Age=$p(PreIBIData,"^",4)
		s Age=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMI,HospID,LocID)
		// 联系电话
		s PatTel=$p(PreIBIData,"^",8)
		s:PatTel="" PatTel=$p(PreIBIData,"^",6)
		s:PatTel="" PatTel=$p(PreIBIData,"^",7)
		// 证件号 证件类型
		s PAIDCard=$p($g(^PAPER(PAPMI,"PAT",3)),"^",6),PACCardDesc=""
		s PACCardType=$p($g(^PAPER(PAPMI,"PAT",3)),"^",7)
		s:PACCardType'="" PACCardDesc=$p($g(^PAC("CARD",PACCardType)),"^",2)
		
		// 单位 分组 部门 VIP
		s GName=""
		s PreGADM=$p($g(^DHCPEPreIADM(PreIADM)),"^",2)
		i PreGADM'="" {
			s PreGBI=$p($g(^DHCPEPreGADM(PreGADM)),"^",1)
			i PreGBI'="" {
				s GName=$p($g(^DHCPEPreGBI(PreGBI)),"^",2)
			}
		}
		s TName=""
		s PreTeam=$p($g(^DHCPEPreIADM(PreIADM)),"^",3)
		i PreTeam'="" {
			s TName=$p($g(^DHCPEPreGADM(+PreTeam,"Team",$p(PreTeam,"||",2))),"^",1)
		}
		s Position=##class(web.DHCPE.PreCommon).GetPosition("PreADM",PreIADM)
		
		s VIPDesc=$lg($g(^CT.PE.VIPLevelD(VIPLevel)),3)
		s VIPType=""
		if (VIPLevel'="") {
	    	s ID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevel,0))
	    	if (ID'="") {
		    	s VIPType=$lg($g(^CF.PE.LocVIPLevelD(ID)),14)
	    	}
		}
		
		// 总检日期 总检结果 总检医生 总检建议
		s GSID=$o(^DHCPEGS(0,"IADM",IADM,0))
		s SumDate="",SumDoc="",SumResult="",SumAdvice=""
		if GSID'="" {
			s SumDoc=$p($g(^DHCPEGS(GSID,1)),"^",5)  // 总检医生
			s:SumDoc'="" SumDoc=$p($g(^SSU("SSUSR",SumDoc)),"^",2)
			s SumDate=$p($g(^DHCPEGS(GSID,1)),"^",6)  // 总检日期
			s:SumDate'="" SumDate=##class(websys.Conversions).DateLogicalToHtml(SumDate)
			
			set conclision="",suggestions=""
			if (VIPType="ZYTJ") {
				set retJson=##class(web.DHCPE.GeneralSummarizeEx).GetGSExInfoNew(GSID,"OC","","Text")
				if retJson.%Size()>0 {
					set num=0
					for tmpi=0:1:(retJson.%Size()-1) {
						set retObj=retJson.%Get(tmpi)
						set:conclision'="" conclision=conclision_"、"_retObj.ConcDesc
						set:conclision="" conclision=retObj.ConcDesc
						
						set:suggestions'="" suggestions=suggestions_"、"_retObj.Suggestions
						set:suggestions="" suggestions=retObj.Suggestions
					}
				}
			} else {
				s Sort=""
				f {
					s Sort=$o(^DHCPEGS(0,"GSDSort",GSID,Sort))
					q:Sort=""
					s Sub=0
					f {
						s Sub=$o(^DHCPEGS(0,"GSDSort",GSID,Sort,Sub))
						q:Sub=""
						
						s GSData=$g(^DHCPEGS(GSID,"Diagnosis",Sub))
		 				continue:GSData=""
		 				s GSRId=GSID_"||"_Sub
						s EDID=$p(GSData,"^",1)
						continue:EDID=""
						i $d(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSRId)) {
							s DisplayDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSRId))
						} else {
							s DisplayDesc=$p($g(^DHCPEED(EDID,"1")),"^",1)
						}
						s:conclision'="" conclision=conclision_$c(10)_DisplayDesc
						s:conclision="" conclision=DisplayDesc
						s Advice=$p(GSData,"^",9)
						s:suggestions'="" suggestions=suggestions_$c(10)_Advice
						s:suggestions="" suggestions=Advice
					}
				}
			}
			s SumResult=conclision
			s SumAdvice=suggestions
		}
		d OutHadSummaryList
	}
	
	Quit $$$OK

OutHadSummaryList 
	/***翻译 start***/
	s Sex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",Sex,"CTSEXDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
    s VIPDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VIPDesc,"VLDesc","cls")
    /***翻译 end***/
	set Data=$lb(PreIADM,RegNo,HPNo,Name,Sex,Age,PatTel,PAIDCard,PACCardType,PACCardDesc,GName,TName,Position,VIPDesc,SumDate,SumDoc,SumResult,SumAdvice)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// 查询就诊记录
/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADM","FindRecord",11,"")
Query FindRecord(RegNo As %String = "", IDCard As %String = "") As websys.Query(ROWSPEC = "PIADM:%String,Status:%String,StatusDesc:%String,AdmDate:%String")
{
}

ClassMethod FindRecordExecute(ByRef qHandle As %Binary, RegNo As %String = "", IDCard As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    
    if ((""=RegNo) && (""=IDCard) ){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	s PIBIDR=""
 	i RegNo'="" d
 	.s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
 	.s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
 	.q:PIBI=""
 	.s PIBIDR=PIBI
 	.d SetRecord
 	
 	i (PIBIDR="")&&(IDCard'="") d
 	.s PIBI=""
 	.f  s PIBI=$o(^DHCPEPreIBI(0,"IDCard",IDCard,PIBI)) q:PIBI=""  d
 	..d SetRecord
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
SetRecord
    s PIADM=""
    f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM)) q:PIADM=""  d
    .s Status=$p(^DHCPEPreIADM(PIADM),"^",8)
    .q:Status="CANCELPE"
    .s IADM=$o(^DHCPEIADM(0,"CRMADM",PIADM,0))
    .q:IADM=""
    .s AdmDate=$p(^DHCPEIADM(IADM),"^",5)
    .s:AdmDate'="" AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
    .s StatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(Status)
    .d OutRecord

    q	
OutRecord      
	set Data=$lb(PIADM,Status,StatusDesc,AdmDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
