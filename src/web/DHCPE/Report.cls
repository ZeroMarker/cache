Import SQLUser

Class web.DHCPE.Report Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 370;

ClassMethod SearchIReport(RegNo As %String = "", PatName As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "")
{
	
	
	s PatName=##class(web.DHCPE.DHCPECommon).UnEscape(PatName)
 	if (""=RegNo)&(""=PatName)&(""=DateFrom)&(""=DateTo)&(""=ReportStatus) {
		Set qHandle=$lb(0,repid,0)
 		Quit $$$OK
 	}
 	s CurGroup=%session.Get("LOGON.GROUPID")
 	i ""'=RegNo s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s ReportStatus="^"_ReportStatus_"^"

	s id=0
	f  s id=$O(^DHCPERPT(id)) q:id=""  d  		//团体客户ADM表 DHC_PE_GADM
	.s CurData=$g(^DHCPERPT(id))  
	.
	.//RPT_IADM_DR 取患者信息 姓名
	.s IADMDR=$p(CurData,"^",1)					//个人ADM
	.
	.b //-- IADMDR
	.s IADMPAADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",1)			//DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	.q:(""=IADMPAADMDR)
	.b //-- IADMPAADMDR
	.s PapmiDR=$p($g(^PAADM(IADMPAADMDR)),"^",1)			//PA_ADM	PAADM_PAPMI_DR
	.q:(""=PapmiDR)
	.s IADMDRName=$p(^PAPER(PapmiDR,"ALL"),"^",1)			//姓名	PAPMI_Name PA_PatMas
	.q:(""'=PatName)&('(IADMDRName[PatName))
	.b //-- IADMDRName
	.s GADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",2)			//DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	.
	.//PA_PatMas.{PAPMI_IPNo}
	.S PAPMIIPNo=$P(^PAPER(PapmiDR,"PAT",1),"^",1)			//登记号	
	.q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	.
	.
    .// 性别 PA_PatMas.{PAPMI_Sex_DR}(CT_Sex)
    .s PAPMISex=""
    .s PAPMISexDR=$p($g(^PAPER(PapmiDR,"ALL")),"^",7)
    .i ""'=PAPMISexDR s PAPMISex=$p($g(^CT("SEX",PAPMISexDR)), "^", 2)
	.
	.// 出生日期 PA_PatMas.{PAPMI_DOB}
	.s PAPMIDOB=$p($g(^PAPER(PapmiDR,"ALL")),"^",6)
	.i ""'=PAPMIDOB s PAPMIDOB=$ZD(PAPMIDOB,3)
	.
	.//IADM_RegDate	DHC_PE_IADM	登记日期
	.s RegDate=+$p($g(^DHCPEIADM(IADMDR)),"^",5)
	.b //-   DateFrom  DateTo
	.q:(""'=DateFrom)&(RegDate<DateFrom)
	.q:(""'=DateTo)&(RegDate>DateTo)
	.i ""'=RegDate s RegDate=$ZD(RegDate,3)
	.
	.//RPT_Status
	.s Status="^"_$p(CurData,"^",2)_"^"				//报告状态
	.b //-- Status
	.q:(""'=ReportStatus)&(ReportStatus'[Status) 
	.s Status=$p(CurData,"^",2)
	.s StatusName=..GetStatusDesc(Status)
	.
	.//RPT_PrintFormat
	.s PrintFormat=$p(CurData,"^",3)			//打印格式
	.i (""=PrintFormat) s PrintFormat=+1
    .
    .//RPT_AduitUser_DR
    .s AduitUserDR=$p(CurData,"^",4)			//审核人	
  	.i (""'=AduitUserDR) d
  	..s AduitUserDRName=$p($g(^SSU("SSUSR",AduitUserDR)),"^",2)	//审核人名称
	.e  d
	..s AduitUserDRName=""
	.
	.//RPT_AduitDate
    .s AuditDate=$p(CurData,"^",5)				//审核日期
    .i (""'=AuditDate) d
    ..s AuditDate=$ZD(AuditDate,3)
    .e  d
	..s AuditDate=""
	.
    .//RPT_PrintUser_DR
    .s PrintUserDR=$p(CurData,"^",6)			//打印人
  	.i (""'=PrintUserDR) d
  	..s PrintUserDRName=$p($g(^SSU("SSUSR",PrintUserDR)),"^",2)	//打印人名称
	.e  d
	..s PrintUserDRName=""
	.
	.//RPT_PrintDate
    .s PrintDate=$p(CurData,"^",7)				//打印日期
    .i (""'=PrintDate) d
    ..s PrintDate=$ZD(PrintDate,3)
	.
 	.
 	.// DHC_PE_SendMessage
 	.s SMRowId=0
 	.f  s SMRowId=$o(^DHCPESM(0,"ReceiveType","I","ReceiveID",id,SMRowId)) Q:(""=SMRowId)  d
	..s TStatus=$p($g(^DHCPESM(SMRowId)),"^",8)
	..Q:'((TStatus["S")||(TStatus["Success"))
 	..s SendUserDR=$p($g(^DHCPESM(SMRowId)),"^",3)
 	..s:(""'=SendUserDR) SendUserDRName=$p($g(^SSU("SSUSR",SendUserDR)),"^",2)	//发送人名称
 	..s SendDate=$p($g(^DHCPESM(SMRowId)),"^",4)
    ..i (""'=SendDate) s SendDate=$ZD(SendDate,3)
    ..
}

/// 
/// 功能：查询体检客户（个人）的报告状态 
/// 使用：网站接口:DHCPENetReport.csp 组件:DHCPEIReport,DHCPEResultContrast.IADM  
/// 测试：d ##class(%ResultSet).RunQuery("web.DHCPE.Report","SearchIReport","","","","","^CHECKED^Audited^A","","","63134","63146","")
/// 字段：		　	登记号					患者姓名					登记开始日期					登记结束日期				报告状态												报告编码			体检编码					患者流水号			登记日期						登记号				患者姓名					患者性别					患者出生日期				团体编码				团体								报告状态										打印格式						审核人编码				审核日期					打印人编码				打印日期					发送人编码				发送日期				审核人名称						打印人名称						发送人名称
Query SearchIReport(RegNo As %String = "", PatName As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "", GroupID As %String = "", TeamID As %String = "", AuditDateFrom As %String = "", AuditDateEnd As %String = "", IsSecret As %String = "N", DocDR As %String = "", VIPLevel As %String = "", DepartName As %String = "", AuditTimeFrom As %String = "", AuditTimeEnd As %String = "", HospID As %String = "") As %Query(ROWSPEC = "RPT_RowId:%String, RPT_IADM_DR:%String, RPT_PAADM_DR:%String, RPT_IADM_RegDate:%String, RPT_RegNo:%String, RPT_IADM_DR_Name:%String, RPT_IADM_Sex:%String, RPT_IADM_DOB:%String, RPT_GADM_DR:%String, RPT_GADM_DR_Name:%String, RPT_Status:%String, RPT_Status_Name:%String, RPT_PrintFormat:%String, RPT_AduitUser_DR:%String, RPT_AduitDate:%String, RPT_PrintUser_DR:%String, RPT_PrintDate:%String, RPT_SendUser_DR:%String, RPT_SendDate:%String, RPT_AduitUser_DR_Name:%String, RPT_PrintUser_DR_Name:%String, RPT_SendUser_DR_Name:%String,TeamDRName:%String,UnAppedItems:%String,RPT_Age:%String,TVIPLevel:%String,Tind:%String,TDepartName:%String,THPNo:%String,TPhotoFlag:%String,FetchReportUser:%String,FetchReportDate:%String,PACCardDesc:%String,IDCard:%String,Tel:%String,ReChkFlag:%String,GSType:%String")
{
}

ClassMethod SearchIReportExecute(ByRef qHandle As %Binary, RegNo As %String = "", PatName As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "", GroupID As %String = "", TeamID As %String = "", AuditDateFrom As %String = "", AuditDateEnd As %String = "", IsSecret, DocDR As %String = "", VIPLevel As %String = "", DepartName As %String = "", AuditTimeFrom As %String = "", AuditTimeEnd As %String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	k ^tempdhcpe("SearchIReport")
	s ^tempdhcpe("SearchIReport")=$lb(RegNo, PatName , DateFrom , DateTo , ReportStatus , GroupID , TeamID , AuditDateFrom , AuditDateEnd , IsSecret , DocDR , VIPLevel , DepartName , AuditTimeFrom, AuditTimeEnd, HospID)

	s num=0
 	s CurLoc=%session.Get("LOGON.CTLOCID")
 	s CurGroup=%session.Get("LOGON.GROUPID")
 	s OPGroup=$G(^DHCPESetting("DHCPE","OPGroup"))
 	s NeedReCheck=$G(^DHCPESetting("DHCPE","MainDoctorGroup",CurLoc))  //该科室是否需求复检
 	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo,CurLoc)
	s ReportStatus="^"_ReportStatus_"^"
	
	I DateFrom'="" s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	I DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	i AuditDateFrom'=""  s AuditDateFrom=##class(websys.Conversions).DateHtmlToLogical(AuditDateFrom)
	i AuditDateEnd'=""  s AuditDateEnd=##class(websys.Conversions).DateHtmlToLogical(AuditDateEnd)
	
	s PreID=""
	if RegNo'="" d
	.//优先按照体检号进行查询，查不到数据按照登记号查询
    .s PreID=##class(web.DHCPE.HISUICommon).GetPreIDByHPNo(RegNo)
    .i PreID'=""  s PIBIDR=$P($g(^DHCPEPreIADM(PreID)),"^",1)
    .i PreID="" d
	..s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.q:PIBIDR=""
	.s PreIADM=0
	.f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	..s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	..q:IADMDR=""
	..q:((PreID'="")&&(PreID'=PreIADM)) //体检号
	..d GetOneInfo
	else  if (GroupID'="")&&(GroupID'="ALLG")&&(GroupID'="ALLI")  d
	.s TeamDR=0
	.f  s TeamDR=$o(^DHCPEIADM(0,"GADM",GroupID,TeamDR)) q:TeamDR=""  d
	..q:(TeamID'="")&&(TeamID'=TeamDR)
	..s IADMDR=0
	..f  s IADMDR=$o(^DHCPEIADM(0,"GADM",GroupID,TeamDR,IADMDR)) q:IADMDR=""  d
	...d GetOneInfo
	else  if PatName'="" d
	.s PatName=$$ALPHAUP^SSUTIL4(PatName)
	.s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatName),-1)
	.f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[PatName)  d
	..s PIBIDR=0
	..f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
	...s PreIADM=0
	...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	....s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	....q:IADMDR=""
	....d GetOneInfo
	//如果存在复检则审核时间为复检时间
	else  if (AuditDateFrom'="")||(AuditDateEnd'="") d
	.d ByAuditDate	
	else  if (DateFrom'="")||(DateTo'="") d
	.d ByArrivedDate
    else  if (""=RegNo)&(""=PatName)&(""=DateFrom)&(""=DateTo)&(GroupID="")&(AuditDateFrom="")&(AuditDateEnd="")  d
    .s AuditDateFrom=+$H
    .s AuditDateEnd=+$H
    .d ByAuditDate
    .;d ByArrivedDate
    //w "共："_(ind-1)_"人"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ByArrivedDate
	i DateFrom="" s DateFrom=0
	i DateTo="" s DateTo=+$H
	s Date=DateTo+1 
	f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date),-1) q:(Date="")||(Date<DateFrom)  d
	.s Time=0
	.f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	..s IADMDR=0
	..f  s IADMDR=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADMDR)) q:(IADMDR="")  d
	...d GetOneInfo
	q
ByAuditDate
 
	i AuditDateFrom="" s AuditDateFrom=0
	i AuditDateEnd="" s AuditDateEnd=+$H
	i NeedReCheck'="Y"  d
	.s Date=AuditDateEnd+1 
	.f  s Date=$o(^DHCPEGS(0,"AuditDateTime",Date),-1) q:(Date="")||(Date<AuditDateFrom)  d
	..s Time=0
	..f  s Time=$o(^DHCPEGS(0,"AuditDateTime",Date,Time)) q:(Time="")  d
	...q:(AuditTimeFrom'="")&&(Time<AuditTimeFrom)
	...q:(AuditTimeEnd'="")&&(Time>AuditTimeEnd)
	...s GSRowID=0
	...f  s GSRowID=$o(^DHCPEGS(0,"AuditDateTime",Date,Time,GSRowID)) q:(GSRowID="")  d
	....s IADMDR=$P($G(^DHCPEGS(GSRowID,1)),"^",1)
	....Q:IADMDR=""
	....d GetOneInfo
	
	i NeedReCheck="Y"  d
	.s Date=AuditDateEnd+1
	.f  s Date=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",Date),-1)  q:(Date="")||(Date<AuditDateFrom)  d
	..s Time=0
	..f  s Time=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",Date,Time))  q:Time=""  d
	...q:(AuditTimeFrom'="")&&(Time<AuditTimeFrom)
	...q:(AuditTimeEnd'="")&&(Time>AuditTimeEnd)
	...s PAADM=0
	...f  s PAADM=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",Date,Time,PAADM))  q:PAADM=""  d 
	....s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	....q:IADMDR=""
	....//w !,IADMDR
	....d GetOneInfo
	q
GetOneInfo

	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMDR)         //Add by 090702
  	q:LocFlag=1 
	s id=$o(^DHCPERPT(0,"IADM",IADMDR,0))
	q:id=""
	s CurPreIADM=$p($G(^DHCPEIADM(IADMDR)),"^",4)
	s TDepartName=##class(web.DHCPE.PreCommon).GetPosition("PreADM",CurPreIADM)
	q:(DepartName'="")&&(TDepartName'[DepartName)
	s ReCheckFlag=##class(web.DHCPE.PreCommon).IsReCheck(CurPreIADM,"Pre",CurLoc)	
	q:ReCheckFlag=1
	/*
	s VIP=$p($G(^DHCPEPreIADM(CurPreIADM)),"^",18)
	s:VIP="" VIP=$G(^DHCPEVIPLevel("VIPapprove"))
	q:((VIPLevel'="")&&(VIPLevel'=VIP))
	s VipDesc=""
	s:(VIP'="") VipDesc=$p($g(^DHCPEVIPLevel("VIP",VIP)),"^",2)
	i VIP'="" s VIP=$p($g(^DHCPEVIPLevel("VIP",VIP)),"^",3)
	*/
	s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",CurPreIADM)
	s TVIPLevelID=$P(PIADMVIP,"^",1)
	q:(VIPLevel'="")&&(VIPLevel'=TVIPLevelID)
	s VipDesc=$P(PIADMVIP,"^",2)
    i TVIPLevelID'="" s VIP=$lg($g(^CF.PE.LocVIPLevelD(TVIPLevelID)),4) //保密
	q:(VIP="Y")&&(IsSecret'="Y")
	q:(VIP'="Y")&&(IsSecret="Y")
	s CurData=$g(^DHCPERPT(id)) 
	s IADMStatus=$p($g(^DHCPEIADM(IADMDR)),"^",8)
	q:IADMStatus'="ARRIVED"
	s IADMPAADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",1)			//DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	q:(""=IADMPAADMDR)	
	s PapmiDR=$p($g(^PAADM(IADMPAADMDR)),"^",1)			
	q:(""=PapmiDR)	
	s TPhotoFlag=##class(web.DHCPE.Public.Common).IsHasPhoto(IADMPAADMDR)
	I TPhotoFlag="1" S TPhotoFlag="有"
	e  S TPhotoFlag="没有"
	///判断是否本院职工
	s EmploayNo=$p($G(^PAPER(PapmiDR,"EMP")),"^",5)
	q:(EmploayNo="")&&(OPGroup'="")&&(CurGroup=OPGroup)	
	s IADMDRName=$p(^PAPER(PapmiDR,"ALL"),"^",1)			//姓名	PAPMI_Name PA_PatMas
	s IADMDRNameU=$$ALPHAUP^SSUTIL4(IADMDRName)
	q:(""'=PatName)&('(IADMDRNameU[PatName))
	;q:(""'=PatName)&('(IADMDRName[PatName))
	s GADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",2)			//DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	q:(GroupID="ALLI")&&(GADMDR'="")
	q:(GroupID="ALLG")&&(GADMDR="")
	///团体判断
	q:((GroupID'="")&&(GroupID'="ALLI")&&(GroupID'="ALLG")&&(GroupID'=GADMDR))
	s ITeamDR=$p($g(^DHCPEIADM(IADMDR)),"^",3)
	q:((TeamID'="")&&(TeamID'=ITeamDR))
	s GADMDRName=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADMDR)
	s ITeamDRName=##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(ITeamDR)
	//登记号	
	S PAPMIIPNo=$P(^PAPER(PapmiDR,"PAT",1),"^",1)				
	;q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	q:(PreID="")&(""'=RegNo)&(RegNo'=PAPMIIPNo)	
    // 性别 
    s PAPMISex=""
    s PAPMISexDR=$p($g(^PAPER(PapmiDR,"ALL")),"^",7)
    i ""'=PAPMISexDR s PAPMISex=$p($g(^CT("SEX",PAPMISexDR)), "^", 2)
	//移动电话
	s CRMADM=$p($g(^DHCPEIADM(IADMDR)),"^",4)
	S PIBIDR=$P($g(^DHCPEPreIADM(CRMADM)),"^",1)
	s Tel=""
	i PIBIDR'="" s Tel=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIBIDR)
	//证件类型 证件号
	s PIBIIDCard="",PACCardDesc="",PACCardTypeDR=""
	S PACCardTypeDR=$P($G(^PAPER(PapmiDR,"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	s PIBIIDCard=$P($G(^PAPER(PapmiDR,"PAT",3)),"^",6)
	// 出生日期 PA_PatMas.{PAPMI_DOB}
	s PAPMIDOB=$p($g(^PAPER(PapmiDR,"ALL")),"^",6)
	i ""'=PAPMIDOB s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)
	s TAge=""
	//s TAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,"")
	s ADMLocID=$p($g(^DHCPEPreIADM(CRMADM)),"^",26)
	s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PapmiDR,HospID,ADMLocID)
   
    /*
	s TAge=""
	i (""'=PAPMIDOB) d                                //add by zhouli 20090427                     
    .s TAge=$p($zd(+$h,3),"-",1)-$p(PAPMIDOB,"-",1)  //add by zhouli 20090427
    */
	//IADM_RegDate	DHC_PE_IADM	登记日期
	s RegDate=+$p($g(^DHCPEIADM(IADMDR)),"^",5)	
	//过滤2007-07-12前的数据     2007-07-25
	//q:RegDate<60823	
	q:(""'=DateFrom)&(RegDate<DateFrom)
	q:(""'=DateTo)&(RegDate>DateTo)
	i ""'=RegDate s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
    //报告状态
	s Status="^"_$p(CurData,"^",2)_"^"	
	//复检者			
	i (NeedReCheck="Y")&&(Status="^A^")  d     
	.i $d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)) d
	..s Status="^A^"
	.else  d
	..s Status="^NA^"
	q:(""'=ReportStatus)&('(ReportStatus[Status)) 
	s Status=$p(CurData,"^",2)
	s StatusName=..GetStatusDesc(Status,IADMPAADMDR)
	////打印格式
	s PrintFormat=$p(CurData,"^",3)			
	i (""=PrintFormat) s PrintFormat=+1
    i NeedReCheck'="Y"  d
    .//审核人
    .s AduitUserDR=$p(CurData,"^",4)
    .//审核日期			
    .s AuditDate=$p(CurData,"^",5)		  
    else    d
    .s AduitUserDR=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)),"^",1)  //复检者
    .s AuditDate=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)),"^",2)  //复检提交日期
  	i (""'=AduitUserDR) d
  	.//审核人名称
  	.s AduitUserDRName=$p($g(^SSU("SSUSR",AduitUserDR)),"^",2)	
	e  d
	.s AduitUserDRName=""
	q:(DocDR'="")&&(DocDR'=AduitUserDR)
   	s AuditDateStart=AuditDateFrom
   	i AuditDateStart="" s AuditDateStart=0
   	s AuditDateC=AuditDateEnd
   	i AuditDateC="" s AuditDateC=+$H
   	q:(AuditDate'="")&&((AuditDate<AuditDateStart)||(AuditDate>AuditDateC))
   	i (""'=AuditDate) d
    .s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    e  d
	.s AuditDate=""
	//打印人
    s PrintUserDR=$p(CurData,"^",6)		
  	i (""'=PrintUserDR) d
  	.s PrintUserDRName=$p($g(^SSU("SSUSR",PrintUserDR)),"^",2)	//打印人名称
	e  d
	.s PrintUserDRName=""
	//打印日期
    s PrintDate=$p(CurData,"^",7)			
    i (""'=PrintDate) d
    .s PrintDate=##class(websys.Conversions).DateLogicalToHtml(PrintDate)
	s SendUserDRName="",SendDate=""
 	S FetchReportUser="",FetchReportDate=""
 	S FetchReportUser=$p($g(^DHCPEDataEx("FetchReport","Detail",id)),"^",1)
 	s FetchReportDate=$p($g(^DHCPEDataEx("FetchReport","Detail",id)),"^",5)
 	i FetchReportDate'="" s FetchReportDate=##class(websys.Conversions).DateLogicalToHtml(FetchReportDate)
 	// DHC_PE_SendMessage
 	s SMRowId=0
 	f  s SMRowId=$o(^DHCPESM(0,"ReceiveType","I","ReceiveID",id,SMRowId)) Q:(""=SMRowId)  d
	.s TStatus=$p($g(^DHCPESM(SMRowId)),"^",8)
	.Q:'((TStatus["S")||(TStatus["Success"))
 	.s SendUserDR=$p($g(^DHCPESM(SMRowId)),"^",3)
 	.s:(""'=SendUserDR) SendUserDRName=$p($g(^SSU("SSUSR",SendUserDR)),"^",2)	//发送人名称
 	.s SendDate=$p($g(^DHCPESM(SMRowId)),"^",4)
    .i (""'=SendDate) s SendDate=##class(websys.Conversions).DateLogicalToHtml(SendDate)
    
 	s UnAppedItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",IADMPAADMDR)
    s UnAppedItems=$p(UnAppedItems,"^",2)
    s THPNo=$p($G(^DHCPEPreIADM(CurPreIADM)),"^",27)

	s FCFlag=$p($G(^DHCPEPreIADM(CurPreIADM)),"^",28)  // 复查标记
	s GSType=""  // 总检类型
	s LocVIPId=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_CurLoc,TVIPLevelID,0))
	s:LocVIPId'="" GSType=$lg(^CF.PE.LocVIPLevelD(LocVIPId),14)
    
    /***翻译 start***/
	s PAPMISex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PAPMISex,"CTSEXDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
    s VipDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",VipDesc,"VLDesc","cls")
    s StatusName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpeireport.hisui.csp",StatusName)
    s TPhotoFlag=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("ddhcpeireport.hisui.csp",TPhotoFlag)
    i $d(TDepartName) s TDepartName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("ddhcpeireport.hisui.csp",TDepartName)
    /***翻译 end***/
    //				报告编码	体检编码	患者流水号	登记日期		登记号		患者姓名	患者性别		生日		团体编码		团体			报告状态					打印格式		审核人编码	审核日期		打印人编码	打印日期		发送人编码	发送日期			审核人名称		打印人名称		发送人名称
    set Data=$lb($g(id), IADMDR, IADMPAADMDR, RegDate, PAPMIIPNo, IADMDRName, PAPMISex ,PAPMIDOB, GADMDR, GADMDRName, Status, StatusName, PrintFormat, AduitUserDR, AuditDate, PrintUserDR, PrintDate, SendUserDR, SendDate, AduitUserDRName, PrintUserDRName, SendUserDRName,ITeamDRName,UnAppedItems,TAge,VipDesc,ind,$G(TDepartName),THPNo,TPhotoFlag,FetchReportUser,FetchReportDate,PACCardDesc,PIBIIDCard,Tel,FCFlag,GSType)
    d IReportOutPut  
	q 
IReportOutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1 	
 	q
}

ClassMethod SearchIReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIReportExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {			
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchIReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIReportExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query SearchIADM(RegNo As %String = "", PatName As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "", GroupID As %String = "", TeamID As %String = "", AuditDateFrom As %String = "", AuditDateEnd As %String = "", IsSecret As %String = "N") As %Query(ROWSPEC = "RPT_RowId:%String, RPT_IADM_DR:%String, RPT_PAADM_DR:%String, RPT_IADM_RegDate:%String, RPT_RegNo:%String, RPT_IADM_DR_Name:%String, RPT_IADM_Sex:%String, RPT_IADM_DOB:%String, RPT_GADM_DR:%String, RPT_GADM_DR_Name:%String, RPT_Status:%String, RPT_Status_Name:%String, RPT_PrintFormat:%String, RPT_AduitUser_DR:%String, RPT_AduitDate:%String, RPT_PrintUser_DR:%String, RPT_PrintDate:%String, RPT_SendUser_DR:%String, RPT_SendDate:%String, RPT_AduitUser_DR_Name:%String, RPT_PrintUser_DR_Name:%String, RPT_SendUser_DR_Name:%String,TeamDRName:%String,UnAppedItems:%String,RPT_IADM_Age:%String,THPNO:%String")
{
}

ClassMethod SearchIADMExecute(ByRef qHandle As %Binary, RegNo As %String = "", PatName As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "", GroupID As %String = "", TeamID As %String = "", AuditDateFrom As %String = "", AuditDateEnd As %String = "", IsSecret) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s id=0
	I DateFrom'="" S DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom) 
	I DateTo'=""  s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
    // s CurLoc="152"
 	s CurLoc=%session.Get("LOGON.CTLOCID")
 	s NeedReCheck=$G(^DHCPESetting("DHCPE","MainDoctorGroup",CurLoc))  //该科室是否需求复检
 	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	s ReportStatus="^"_ReportStatus_"^"
	
	if RegNo'="" d
	.s PIBIDR=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	.q:PIBIDR=""
	.s PreIADM=0
	.f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	..s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	..q:IADMDR=""
	..d GetOneInfo1

	else  if PatName'="" d
	.s PatNameU=$$ALPHAUP^SSUTIL4(PatName)
	.s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameU),-1)
	.f  s PatNameIndex=$o(^DHCPEPreIBI(0,"Name",PatNameIndex)) q:(PatNameIndex="")||(PatNameIndex'[PatNameU)  d
	..s PIBIDR=0
	..f  s PIBIDR=$o(^DHCPEPreIBI(0,"Name",PatNameIndex,PIBIDR)) q:PIBIDR=""  d
	...s PreIADM=0
	...f  s PreIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBIDR,PreIADM)) q:PreIADM=""  d
	....s IADMDR=$o(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	....q:IADMDR=""
	....d GetOneInfo1
	else  if (DateFrom'="")||(DateTo'="") d
	.d ByArrivedDate1
    else  if (""=RegNo)&(""=PatName)&(""=DateFrom)&(""=DateTo)&(GroupID="")&(AuditDateFrom="")&(AuditDateEnd="")  d
    .s DateFrom=+$H
    .s AuditDateFrom=+$H
    .d ByAuditDate1
    .d ByArrivedDate1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ByArrivedDate1
	i DateFrom="" s DateFrom=0
	i DateTo="" s DateTo=+$H
	s Date=DateTo+1 
	f  s Date=$o(^DHCPEIADM(0,"AdmDateTime",Date),-1) q:(Date="")||(Date<DateFrom)  d
	.s Time=0
	.f  s Time=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time)) q:(Time="")  d
	..s IADMDR=0
	..f  s IADMDR=$o(^DHCPEIADM(0,"AdmDateTime",Date,Time,IADMDR)) q:(IADMDR="")  d
	...d GetOneInfo1
	q
ByAuditDate1
 
	i AuditDateFrom="" s AuditDateFrom=0
	i AuditDateEnd="" s AuditDateEnd=+$H
	i NeedReCheck'="Y"  d
	.s Date=AuditDateEnd+1 
	.f  s Date=$o(^DHCPEGS(0,"AuditDateTime",Date),-1) q:(Date="")||(Date<AuditDateFrom)  d
	..s Time=0
	..f  s Time=$o(^DHCPEGS(0,"AuditDateTime",Date,Time)) q:(Time="")  d
	...s GSRowID=0
	...f  s GSRowID=$o(^DHCPEGS(0,"AuditDateTime",Date,Time,GSRowID)) q:(GSRowID="")  d
	....s IADMDR=$P($G(^DHCPEGS(GSRowID,1)),"^",1)
	....Q:IADMDR=""
	....d GetOneInfo1
	q
	i NeedReCheck="Y"  d
	.s Date=AuditDateEnd+1
	.f  s Date=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",Date),-1)  q:(Date="")||(Date<AuditDateFrom)  d
	..s Time=0
	..f  s Time=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",Date,Time))  q:Time=""  d
	...s PAADM=0
	...f  s PAADM=$o(^DHCPEDataEx("DHCPEGeneralSummarize","MainDate",Date,Time,PAADM))  q:PAADM=""  d 
	....s IADMDR=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	....q:IADMDR=""
	....d GetOneInfo1
	Q
GetOneInfo1

	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IADMDR)         //Add by 090702
  	q:LocFlag=1 
	s id=$o(^DHCPERPT(0,"IADM",IADMDR,0))
	q:id=""
	s CurPreIADM=$p($G(^DHCPEIADM(IADMDR)),"^",4)
	s VIP=$p($G(^DHCPEPreIADM(CurPreIADM)),"^",18)
	i VIP'="" s VIP=$p($g(^DHCPEVIPLevel("VIP",VIP)),"^",3)
	q:(VIP="Y")&&(IsSecret'="Y")
	q:(VIP'="Y")&&(IsSecret="Y")
	s THPNO=""
	S THPNO=$p($G(^DHCPEPreIADM(CurPreIADM)),"^",27)
	s CurData=$g(^DHCPERPT(id)) 
	s IADMStatus=$p($g(^DHCPEIADM(IADMDR)),"^",8)
	q:IADMStatus'="ARRIVED"
	s IADMPAADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",1)			//DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	q:(""=IADMPAADMDR)
	s PapmiDR=$p($g(^PAADM(IADMPAADMDR)),"^",1)			//PA_ADM	PAADM_PAPMI_DR
	q:(""=PapmiDR)
	s IADMDRName=$p(^PAPER(PapmiDR,"ALL"),"^",1)			//姓名	PAPMI_Name PA_PatMas
	q:(""'=PatName)&('(IADMDRName[PatName))
	s GADMDRName="",GADMDR="",ITeamDR="",ITeamDRName=""
	s GADMDR=$p($g(^DHCPEIADM(IADMDR)),"^",2)			//DHC_PE_IADM IADM_PAADM_DR Medtrak的ADM号			
	///增加团体判断
	q:((GroupID'="")&&(GroupID'=GADMDR))
	s ITeamDR=$p($g(^DHCPEIADM(IADMDR)),"^",3)
	q:((TeamID'="")&&(TeamID'=ITeamDR))
	s GADMDRName=##Class(web.DHCPE.DHCPEGAdm).GetGAdmDesc(GADMDR)
	s ITeamDRName=##Class(web.DHCPE.DHCPEGAdm).GetGTeamDesc(ITeamDR)
	S PAPMIIPNo=$P(^PAPER(PapmiDR,"PAT",1),"^",1)			//登记号	
	q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
    s PAPMISex=""
    s PAPMISexDR=$p($g(^PAPER(PapmiDR,"ALL")),"^",7)
    i ""'=PAPMISexDR s PAPMISex=$p($g(^CT("SEX",PAPMISexDR)), "^", 2)
	s PAPMIDOB=$p($g(^PAPER(PapmiDR,"ALL")),"^",6)
	i ""'=PAPMIDOB s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)
	s TAge=""
	s TAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiDR,IADMPAADMDR)
	/*
	i (""'=PAPMIDOB) d                                //add by zhouli 20090427                     
    .s TAge=$p($zd(+$h,3),"-",1)-$p(PAPMIDOB,"-",1)  //add by zhouli 20090427
    */
	s RegDate=+$p($g(^DHCPEIADM(IADMDR)),"^",5)
	
	
	//过滤2007-07-12前的数据     2007-07-25
	//q:RegDate<60823
	q:(""'=DateFrom)&(RegDate<DateFrom)
	q:(""'=DateTo)&(RegDate>DateTo)
	i ""'=RegDate s RegDate=##class(websys.Conversions).DateLogicalToHtml(RegDate)
	s Status="^"_$p(CurData,"^",2)_"^"				//报告状态
	i (NeedReCheck="Y")&&(Status'="^P^")  d      ////复检者
	.i $d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)) s Status="^A^"
	.else  s Status="^NA^"
	//q:(""'=ReportStatus)&('(ReportStatus[Status)) 
	s Status=$p(CurData,"^",2)
	s StatusName=..GetStatusDesc(Status,IADMPAADMDR)
	s PrintFormat=$p(CurData,"^",3)			//打印格式
	i (""=PrintFormat) s PrintFormat=+1
	
    i NeedReCheck'="Y"  d
    .s AduitUserDR=$p(CurData,"^",4)			//审核人
    .s AuditDate=$p(CurData,"^",5)		   //审核日期
    else    d
    .s AduitUserDR=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)),"^",1)  //复检者
    .s AuditDate=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",IADMPAADMDR)),"^",2)  //复检提交日期
  	i (""'=AduitUserDR) d
  	.s AduitUserDRName=$p($g(^SSU("SSUSR",AduitUserDR)),"^",2)	//审核人名称
	e  d
	.s AduitUserDRName=""

   	s AuditDateStart=AuditDateFrom
   	i AuditDateStart="" s AuditDateStart=0
   	s AuditDateC=AuditDateEnd
   	i AuditDateC="" s AuditDateC=+$H
   	q:(AuditDate'="")&&((AuditDate<AuditDateStart)||(AuditDate>AuditDateC))
   	i (""'=AuditDate) d
    .s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    e  d
	.s AuditDate=""
    s PrintUserDR=$p(CurData,"^",6)			//打印人
  	i (""'=PrintUserDR) d
  	.s PrintUserDRName=$p($g(^SSU("SSUSR",PrintUserDR)),"^",2)	//打印人名称
	e  d
	.s PrintUserDRName=""
    s PrintDate=$p(CurData,"^",7)				//打印日期
    i (""'=PrintDate) d
    .s PrintDate=##class(websys.Conversions).DateLogicalToHtml(PrintDate)
	s SendUserDRName=""
 	s SendDate=""
 	
 	// DHC_PE_SendMessage
 	s SMRowId=0
 	f  s SMRowId=$o(^DHCPESM(0,"ReceiveType","I","ReceiveID",id,SMRowId)) Q:(""=SMRowId)  d
	.s TStatus=$p($g(^DHCPESM(SMRowId)),"^",8)
	.Q:'((TStatus["S")||(TStatus["Success"))
 	.s SendUserDR=$p($g(^DHCPESM(SMRowId)),"^",3)
 	.s:(""'=SendUserDR) SendUserDRName=$p($g(^SSU("SSUSR",SendUserDR)),"^",2)	//发送人名称
 	.s SendDate=$p($g(^DHCPESM(SMRowId)),"^",4)
    .i (""'=SendDate) s SendDate=##class(websys.Conversions).DateLogicalToHtml(SendDate)
    .
 	s UnAppedItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",IADMPAADMDR)
    s UnAppedItems=$p(UnAppedItems,"^",2)
    //				报告编码	体检编码	患者流水号	登记日期		登记号		患者姓名	患者性别		生日		团体编码		团体			报告状态					打印格式		审核人编码	审核日期		打印人编码	打印日期		发送人编码	发送日期			审核人名称		打印人名称		发送人名称
    /***翻译 start***/
	s PAPMISex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",PAPMISex,"CTSEXDesc","cls")
    /***翻译 end***/
    set Data=$lb(	$g(id), IADMDR, IADMPAADMDR, RegDate, PAPMIIPNo, IADMDRName, PAPMISex ,PAPMIDOB, GADMDR, GADMDRName, Status, StatusName, PrintFormat, AduitUserDR, AuditDate, PrintUserDR, PrintDate, SendUserDR, SendDate, AduitUserDRName, PrintUserDRName, SendUserDRName,ITeamDRName,UnAppedItems,TAge,THPNO)
    d IADMtOutPut
	q 

IADMtOutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchIADMExecute ]
{
	Set AtEnd=$LIST($g(qHandle),1)
 	Set repid=$LIST($g(qHandle),2)
 	Set ind=$LIST($g(qHandle),3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=$g(^CacheTemp(repid,ind))
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchIADMExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 团体报告查询		团体名称					审核人							登记起始日期				登记结束日期					报告状态											报告编码				团体编码				报告状态									打印格式						审核人编码				审核日期					打印人编码				打印日期					发送人编码				发送日期						团体名称					审核人名称						打印人名称						发送人名称
Query SearchGReport(GDesc As %String = "", AduitUser As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "") As %Query(ROWSPEC = "RPT_RowId:%String, RPT_GADM_DR:%String, RPT_Status:%String, RPT_Status_Name:%String, RPT_PrintFormat:%String, RPT_AduitUser_DR:%String, RPT_AduitDate:%String, RPT_PrintUser_DR:%String, RPT_PrintDate:%String, RPT_SendUser_DR:%String, RPT_SendDate:%String, RPT_GADM_DR_Name:%String, RPT_AduitUser_DR_Name:%String, RPT_PrintUser_DR_Name:%String, RPT_SendUser_DR_Name:%String")
{
}

ClassMethod SearchGReportExecute(ByRef qHandle As %Binary, GDesc As %String = "", AduitUser As %String = "", DateFrom As %String = "", DateTo As %String = "", ReportStatus As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
 	s Gid=0 
 		
 	s GDesc=##class(web.DHCPE.DHCPECommon).UnEscape(GDesc)
 	if ((""=GDesc)&(""=AduitUser)&(""=DateFrom)&(""=DateTo)&(""=ReportStatus)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	I DateFrom'="" S DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	I DateTo'=""  S DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
	
	f  s Gid=$O(^DHCPERPT(0,"GADM",Gid)) q:(Gid="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",Gid)        //Add by 090702
  	.q:LocFlag=1 
	.//查找符合名称条件的团体
	.s GADMGBIDR=$p($g(^DHCPEGADM(Gid)),"^",1)			//DHC_PE_GADM	GADM_GBI_DR
	.q:(""=GADMGBIDR)
	.s GADMDRName=$p($g(^DHCPEGBI(GADMGBIDR)),"^",2)	//团体客户基本信息登记表 DHC_PE_GBaseInfo
	.q:(""'=GDesc)&('(GDesc[GADMDRName))
	.
	.//获取团体信息
	.s id=0
	.s id=$O(^DHCPERPT(0,"GADM",Gid,id)) 
	.q:(id="")
	.
	.s CurData=$g(^DHCPERPT(id))
	.//RPT_Status
	.s Status="^"_$p(CurData,"^",2)_"^"				//报告状态
	.q:(""'=ReportStatus)&('(ReportStatus[Status)) 
	.s PAADM=$p($g(^DHCPEGADM(Gid)),"^",3)	
	.s Status=$p(CurData,"^",2)
	.s StatusDesc=..GetStatusDesc(Status,PAADM)
	.//RPT_PrintFormat
	.s PrintFormat=$p(CurData,"^",3)			//打印格式
	.i (""=PrintFormat) s PrintFormat=1			//默认为 1
    .
    .//RPT_AduitUser_DR
    .s AduitUserDR=$p(CurData,"^",4)			//审核人	
  	.q:(""'=AduitUser)&(AduitUserDR'=AduitUser)
  	.i (""'=AduitUserDR) d
  	..s AduitUserDRName=$p($g(^SSU("SSUSR",AduitUserDR)),"^",2)	//审核人名称
	.e  d
	..s AduitUserDRName=""
	.
	.//RPT_AduitDate
    .s AuditDate=$p(CurData,"^",5)				//审核日期
    .i (""'=AuditDate) s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    .s:AduitUserDR="" AuditDate=""
    .//RPT_PrintUser_DR
    .s PrintUserDR=$p(CurData,"^",6)			//打印人
  	.i (""'=PrintUserDR) d
  	..s PrintUserDRName=$p($g(^SSU("SSUSR",PrintUserDR)),"^",2)	//打印人名称
	.e  d
	..s PrintUserDRName=""
	.
	.//RPT_PrintDate
    .s PrintDate=$p(CurData,"^",7)				//打印日期
    .i (""'=PrintDate) s PrintDate=##class(websys.Conversions).DateLogicalToHtml(PrintDate)
 	.
 	.// DHC_PE_SendMessage
 	.s SMRowId=0
 	.f  s SMRowId=$o(^DHCPESM(0,"ReceiveType","G","ReceiveID",id,SMRowId)) Q:(""=SMRowId)  d
	..s TStatus=$p($g(^DHCPESM(SMRowId)),"^",8)
	..Q:'((TStatus["S")||(TStatus["Success"))
 	..s SendUserDR=$p($g(^DHCPESM(SMRowId)),"^",3)
 	..s:(""'=SendUserDR) SendUserDRName=$p($g(^SSU("SSUSR",SendUserDR)),"^",2)	//发送人名称
 	..s SendDate=$p($g(^DHCPESM(SMRowId)),"^",4)
    ..i (""'=SendDate) s SendDate=##class(websys.Conversions).DateLogicalToHtml(SendDate)
    ..
    .//RPT_SendUser_DR
    .//s SendUserDR=$p(CurData,"^",8)				//发送人
  	.//i (""'=SendUserDR) d
  	.//.s SendUserDRName=$p($g(^SSU("SSUSR",SendUserDR)),"^",2)	//发送人名称
	.//e  d
	.//.s SendUserDRName=""
	.
	.//RPT_SendDate				
    .//s SendDate=$p(CurData,"^",9)				//发送人日期	
    .//i (""'=SendDate) s SendDate=$ZD(SendDate,3)
    .
    .//				报告编码	团体预约编码		报告状态				打印格式		审核人编码	审核日期		打印人编码	打印日期		发送人编码	发送日期	团体名称		审核人名称			??印人名称		发送人名称		登记号
    .set Data=$lb( $g(id), Gid, Status, StatusDesc, PrintFormat, AduitUserDR, AuditDate, PrintUserDR, PrintDate, SendUserDR, SendDate, GADMDRName, AduitUserDRName, PrintUserDRName, SendUserDRName, PAPMIIPNo)
    .
    .d GReportOutPut

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GReportOutPut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGReportExecute ]
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

ClassMethod SearchGReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report","SearchGReportNew","","2019-04-21","2019-04-30")
Query SearchGReportNew(GID As %String = "", DateFrom As %String = "", DateTo As %String = "", LocID As %String = "") As %Query(ROWSPEC = "RPT_ID:%String,GADM_DR:%String,Grp_Code:%String,Grp_RegNo:%String,Grp_Name:%String,PGADM_StatusDesc:%String,GADM_Date:%String,RPT_Status:%String,RPT_PrintDate:%String,RPT_PrintTime:%String,RPT_PrintUser:%String,PGBILinkman1:%String,PGBITel1:%String")
{
}

ClassMethod SearchGReportNewExecute(ByRef qHandle As %Binary, GID As %String = "", DateFrom As %String = "", DateTo As %String = "", LocID As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
 		
 	if ((""=GID)&(""=DateFrom)&(""=DateTo)) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	I DateFrom'="" S DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
	I DateTo'=""  S DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)

    i DateTo="" s DateTo=+$H
    i DateFrom=""  s DateFrom=DateFrom-30
    
	s AdmDate=DateTo+1
	f  s AdmDate=$o(^DHCPEGADM(0,"AdmDateTime",AdmDate),-1) q:(AdmDate<DateFrom)||(AdmDate="")  d
	.s Time=0
	.f  s Time=$o(^DHCPEGADM(0,"AdmDateTime",AdmDate,Time)) q:Time=""  d
	..s GADMID=""
	..f  s GADMID=$o(^DHCPEGADM(0,"AdmDateTime",AdmDate,Time,GADMID)) q:(GADMID="")||(GADMID="0")  d
	...d GetInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetInfo 
	s GADMGBIDR=$p($g(^DHCPEGADM(GADMID)),"^",1)
	q:($p($g(^DHCPEGADM(GADMID)),"^",6)'="ARRIVED")
	Q:(GADMID'=GID)&&(""'=GID)
	Q:'$D(^DHCPERPT(0,"GADM",GADMID))	
	q:(""=GADMGBIDR)
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("GADM",GADMID,LocID)     
  	q:LocFlag=1 
 
	s GADMDRName=$p($g(^DHCPEGBI(GADMGBIDR)),"^",2)	
	s Code=$p($g(^DHCPEGBI(GADMGBIDR)),"^",1)
	s PreGBIDR=$p($g(^DHCPEGBI(GADMGBIDR)),"^",19)
	s RegNo=$p($g(^DHCPEPreGBI(PreGBIDR)),"^",13)
	
	S PGBILinkman1="",PGBITel1=""
	i ""'=PreGBIDR d
	.s PGBILinkman1=$p($g(^DHCPEPreGBI(PreGBIDR)),"^",5) //联系人 
	.s PGBITel1=$p($g(^DHCPEPreGBI(PreGBIDR)),"^",8) //联系人电话

	S GAdmDate=$p($g(^DHCPEGADM(GADMID)),"^",4)
	i (""'=GAdmDate) s GAdmDate=##class(websys.Conversions).DateLogicalToHtml(GAdmDate)
	S GStatus=$p($g(^DHCPEGADM(GADMID)),"^",6)
	q:((GStatus="CANCELPREREG")||(GStatus="CANCELPE"))
	i GStatus'="" s GStatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(GStatus)
	s:(""=GStatus) GStatusDesc=""
	
	s RStatusDesc="",PrintDate="",PrintTime=""
	s id=0
	s id=$O(^DHCPERPT(0,"GADM",GADMID,id)) 
	i id'="" d
	.s CurData=$g(^DHCPERPT(id))
	.s Status="^"_$p(CurData,"^",2)_"^"				//报告状态
	.s PAADM=$p($g(^DHCPEGADM(GADMID)),"^",3)	
	.s Status=$p(CurData,"^",2)
	.s RStatusDesc=""
	.s RStatusDesc=..GetStatusDesc(Status,PAADM)
	.s PrintFormat=$p(CurData,"^",3)			//打印格式
	.i (""=PrintFormat) s PrintFormat=1			//默认为 1
    .s AduitUserDR=$p(CurData,"^",4)			//审核人	
  	.i (""'=AduitUserDR) d
  	..s AduitUserDRName=$p($g(^SSU("SSUSR",AduitUserDR)),"^",2)	//审核人名称
	.e  d
	..s AduitUserDRName=""

    .s AuditDate=$p(CurData,"^",5)				//审核日期
    .i (""'=AuditDate) s AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
    .s:AduitUserDR="" AuditDate=""
    
    .s PrintUserDR=$p(CurData,"^",6)			//打印人
  	.i (""'=PrintUserDR) d
  	..s PrintUserDRName=$p($g(^SSU("SSUSR",PrintUserDR)),"^",2)	//打印人名称
	.e  d
	..s PrintUserDRName=""
    .s PrintDate=$p(CurData,"^",7)				//打印日期
    .i (""'=PrintDate) s PrintDate=##class(websys.Conversions).DateLogicalToHtml(PrintDate)
 	.s PrintTime=$p(CurData,"^",14)	
 	.i PrintTime'="" s PrintTime=$zt(PrintTime)
 	.E  s PrintTime=""
    d GReportOutPutNew
    Q
GReportOutPutNew
    set Data=$lb($g(id),GADMID,Code,RegNo,GADMDRName,GStatusDesc,GAdmDate,RStatusDesc,PrintDate,PrintTime,PrintUserDRName,PGBILinkman1,PGBITel1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchGReportNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGReportNewExecute ]
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

ClassMethod SearchGReportNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGReportNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// **********************************************************************

/// 个人报告状态更新 
/// 使用：	DHCPEIReport
/// d ##class(web.DHCPE.Report).Save("","","71^10615^^S")
ClassMethod Save(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	//1 RPT_RowId
	s iLLoop=1
	s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(1)=value
    
    //2 RPT_IADM_DR	个人ADM
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(2)=value    
    
    //3 RPT_Status	报告状态
    s iLLoop=iLLoop+1	
	s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(3)=value
	
	//4 RPT_PrintFormat	打印格式
    s iLLoop=iLLoop+1	
	s value=$p(InString,"^",iLLoop)
	i ""'=value s PLIST(4)=value

	//5 RPT_AduitUser_DR	审核人
    s iLLoop=iLLoop+1	
	s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .s PLIST(5)=value
    .//6 RPT_AduitDate	审核日期
    .s PLIST(6)=+$H
	
	//6 RPT_AduitDate	审核日期
    s iLLoop=iLLoop+1	
    
    //7 RPT_PrintUser_DR	打印人
    s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .s PLIST(7)=value
    .//8 RPT_PrintDate	打印日期
    .s PLIST(8)=+$H
    
    //8 RPT_PrintDate	打印日期
    s iLLoop=iLLoop+1	
    
    //9 RPT_SendUser_DR	发送人
    s iLLoop=iLLoop+1	
	s value=$p(InString,"^",iLLoop)
    i ""'=value d
    .s PLIST(9)=value  
    .//10 RPT_SendDate	发送日期
	.s PLIST(10)=+$H
	
	//10 RPT_SendDate	发送日期
	s iLLoop=iLLoop+1
	
    //11 RPT_GADM_DR	团体ADM 
	s iLLoop=iLLoop+1
	s value=$p(InString,"^",iLLoop)
    i ""'=value s PLIST(11)=value

    s ret=..ISave()
	q ret
}

/// 报告状态更新 
/// w ##Class(web.DHCPE.Report).GetStatusDesc("A","245")
ClassMethod GetStatusDesc(Status As %Library.String = "", PAADM As %Library.String = "", CurrLocID As %Library.String = "")
{
 
   i CurrLocID="" s CurrLocID=%session.Get("LOGON.CTLOCID")
   
	n (Status,CurrLocID,PAADM)
	i Status="" q ""
	s NeedReCheck=$G(^DHCPESetting("DHCPE","MainDoctorGroup",CurrLocID))  //科室是否需要复检功能
	if NeedReCheck="N"  d
	.i ("UNCHECKED"=Status)||("NA"=Status)||("NoAudit"=Status) s Status="未审核"
	.i ("A"=Status)||("Audited"=Status) s Status="已审核"
	.i ("P"=Status)||("Printed"=Status) s Status="已打印"
	.;i ("S"=Status)||("Send"=Status) s Status="已发送"
	.i ("S"=Status)||("Send"=Status) s Status="已取"
	.;i ("C"=Status)||("Complete"=Status) s Status="已粘贴"
	.i ("C"=Status)||("Complete"=Status) s Status="已完成"

	else  d
	.i $d(^DHCPEIADM(0,"PAADM",PAADM))  d
    ..i ("UNCHECKED"=Status)||("NA"=Status)||("NoAudit"=Status) s Status="未初检"
    ..i ("P"=Status)||("Printed"=Status) s Status="已打印"
    ..;i ("S"=Status)||("Send"=Status) s Status="已发送"
    ..i ("S"=Status)||("Send"=Status) s Status="已取"
    ..;i ("C"=Status)||("Complete"=Status) s Status="已粘贴"
    ..i ("C"=Status)||("Complete"=Status) s Status="已完成"
	..i ("A"=Status)||("Audited"=Status)  d
    ...i $d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) s Status="已复检"
    ...i '$d(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)) s Status="已初检未复检"
    .else  d
    .i ("UNCHECKED"=Status)||("NA"=Status)||("NoAudit"=Status) s Status="未审核"
	.i ("A"=Status)||("Audited"=Status) s Status="已审核"
	.i ("P"=Status)||("Printed"=Status) s Status="已打印"
	.;i ("S"=Status)||("Send"=Status) s Status="已发送"
	.i ("S"=Status)||("Send"=Status) s Status="已取"
	.;i ("C"=Status)||("Complete"=Status) s Status="已粘贴"
	.i ("C"=Status)||("Complete"=Status) s Status="已完成"
	q Status

	q Status
}

/// 更新患者的报告状态
/// 使用组件：DHCPECallRpt
/// w ##class(web.DHCPE.Report).SetADMReportStatus("","","65^P^10615^")
ClassMethod SetReportStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s RowId=$p(InString,"^",1)
	q:(""=RowId) "Err 06"		//未找到患者报告信息
	s PLIST(1)=RowId
	s Status=$p(InString,"^",2)		//更新类型　A:审核　P:打印　S:发送  C:已完成
	s PLIST(3)=Status
	s CurStatus=$P($g(^DHCPERPT(RowId)),"^",2)
	d:"P"=Status ..SetReportLog(RowId)
	//q:(Status="P")&&(CurStatus'="A") 0

	Q:("NA"=CurStatus)&'(("NA"=PLIST(3))||("A"=PLIST(3))) "Report Err 1"	// 当报告未审核，只能执行审核操作
	Q:("A"=CurStatus)&'(("A"=PLIST(3))||("P"=PLIST(3))) "Report Err 2"	// 当报告审核状态，只能先执行打印操作
	Q:("P"=CurStatus)&'(("P"=PLIST(3))||("S"=PLIST(3)||("C"=PLIST(3)))) "Report Err 3"_PLIST(3)_CurStatus	// 当报告打印以后状态，才能执行发送操作
	

	s UserID=$p(InString,"^",3)
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	s DateUpdate=+$h
	s Time=$P($H,",",2)
	i "A"=Status d
	.s PLIST(5)=UserID
	.s PLIST(6)=DateUpdate
	.s PLIST(14)=Time
	i "P"=Status d
	.s PLIST(7)=UserID
	.s PLIST(8)=DateUpdate
	.s PLIST(15)=Time
	i "S"=Status d
	.s PLIST(9)=UserID
	.s PLIST(10)=DateUpdate
	.s PLIST(17)=Time
	i "C"=Status d
	.s PLIST(12)=UserID
	.s PLIST(13)=DateUpdate
	.s PLIST(16)=Time
    s ret=..ISave()
    i +ret=0 d
    .s IADM=$P(^DHCPERPT(RowId),"^",1)
    .q:IADM=""
    .d:("P"=Status)&&("Y"=$p(InString,"^",4)) ..SendReportMessage(RowId)
    .d ##class(web.DHCPE.AdmRecordManager).Insert(IADM,"I","ReportStatus",UserID,Status)
	q ret
}

ClassMethod SendReportMessage(PRTRowId As %Library.String = "")
{
	
	q:PRTRowId=""
	s IADM=$P(^DHCPERPT(PRTRowId),"^",1)
    q:IADM=""
	s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	q:PreIADM=""
	s PreGID=$p(^DHCPEPreIADM(PreIADM),"^",2)
	q:PreGID'=""
	s PreIBI=$p(^DHCPEPreIADM(PreIADM),"^",1)
	q:PreIBI=""
	s PAPMINo=$p(^DHCPEPreIBI(PreIBI),"^",1)
	s Name=$p(^DHCPEPreIBI(PreIBI),"^",2)
	s TelNo=$p($g(^DHCPEPreIBI(PreIBI)),"^",6)
	s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PreIBI)),"^",7)
	s:TelNo="" TelNo=$p($g(^DHCPEPreIBI(PreIBI)),"^",8)
	s MessageID=$o(^User.DHCPENewMessageTempletI("TypeDefaultIndex","西院短信",1,0))
	q:MessageID=""
	s MessageDesc=$listget(^User.DHCPENewMessageTempletD(MessageID),4)
	s MessageInfo=PRTRowId_"^"_PAPMINo_"^"_TelNo_"^"_MessageDesc
	
	d ##class(web.DHCPE.SendMessage).SaveMessage("RP",MessageInfo)
}

/// 更新患者的报告状态 不要使用
/// w ##class(web.DHCPE.Report).SetADMReportStatus("","","9642^10615^^已审核")
ClassMethod SetADMReportStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	
	
	s RowId=$p(InString,"^",1)
	q:(""=RowId) "Err 06"		//未找到患者报告信息
	
	s PLIST(1)=RowId
	s Status=$p(InString,"^",2)		//更新类型　A:审核　P:打印　S:发送  
	s PLIST(3)=Status
	
	s UserID=$p(InString,"^",3)
	
	s DateUpdate=+$h
    
    s ret=..ISave()
	q ret
}

/// 更新团体报告状态
/// d ##class(web.DHCPE.Report).SetReportStatusNew("202^P^11849")
ClassMethod SetReportStatusNew(InString As %Library.String = "")
{
	s RowId=$p(InString,"^",1)
	s PLIST(1)=RowId
	s Status=$p(InString,"^",2) 
	s PLIST(3)=Status
	s UserID=$p(InString,"^",3)
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	s DateUpdate=+$h
	s Time=$P($H,",",2)
	i "P"=Status d
	.s PLIST(7)=UserID
	.s PLIST(8)=DateUpdate
	.s PLIST(15)=Time
	
	s RPTRowId=""
	s RPTRowId=$o(^DHCPERPT(0,"GADM",RowId,0))
	i RPTRowId="" d
	.&SQL(Insert Into SQLUSER.DHC_PE_Report Values :PLIST())
	e  d
	.k PLIST(1)
	.&SQL(Update SQLUSER.DHC_PE_Report Values :PLIST() 
		where RPT_RowId = :RPTRowId)
	
	q SQLCODE
}

/// 根据paadm更新患者报告状态
/// 更新团体的报告状态 
ClassMethod SetGReportStatus(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s GBIDR=$p(InString,"^",1)
	if (""=GBIDR) q "Err 01"	//
	s GRowId=0
	s GRowId=$O(^DHCPEGADM(0,"GBI",GBIDR,GRowId) )
	q:(""=GRowId) "Err 05"	//未找到患者体检信息
	s RowId=0
	s RowId=$O(^DHCPERPT(0,"GADM",GRowId,RowId))
	q:(""=RowId) "Err 06"		//未找到患者报告信息

	s UserID=$p(InString,"^",2)
	s DateUpdate=+$h
    s Status=$p(InString,"^",4)		//更新类型　A:审核　P:打印　S:发送  
	//q RowId_":"_UserID_":"_DateUpdate_":"_Status
    s ret=..ISave(RowId, UserID, DateUpdate, Status)
	q ret
}

/// 不能使用 测试
ClassMethod showIADMInfo() As %String
{
	
	w "<TABLE style='WIDTH: 325px; HEIGHT: 114px' width=325>"
	w "<TBODY><TR><TD>"
	w "<label id='cIADM_DR_Name1' >患者姓名</label>"
	w "</TD><TD>"
	w "<input id='IADM_DR_Name1' disabled  name='IADM_DR_Name1' value=''>"
	w "</TD></TR><TR><TD>"
	w "<label id='cGADM_DR_Name1' >单位</label>"
	w "</TD><TD>"
	w "<input id='GADM_DR_Name1' disabled  name='GADM_DR_Name1' value=''>"
	w "</TD></TR><TR><TD>"
	w "<label id='cStatus1' >报告状态</label>"
	w "</TD><TD>"
	w "<input id='Status1' disabled  name='Status1' value=''>"
	w "</TD></TR><TR><TD>"
	w "<label id='cPrintFormat1' >打印格式</label>"
	w "</TD><TD>"
	w "<input id='PrintFormat1' disabled  name='PrintFormat' value=''>"
	w "</TD></TR>"
	w "</TBODY>"
	w "</TABLE>	"
	q
}

/// 获取团体报告信息
/// 
ClassMethod GetGReportInfor(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s GADM=$p(InString,"^",1)
	Q:(""=GADM) "Err 04"
	s GBIDR=$p($g(^DHCPEGADM(GADM)),"^",1)			//DHC_PE_GADM	GADM_GBI_DR
	if (""=GBIDR) q "Err 01"	//
	//s GRowId=0
	//s GRowId=$O(^DHCPEGADM(0,"GBI",GBIDR,GRowId) )
	//q:(""=GRowId) "Err 05"	//未找到患者体检信息
	s PAADM=$p($g(^DHCPEGADM(GADM)),"^",3)
	s RowId=0
	s RowId=$O(^DHCPERPT(0,"GADM",GADM,RowId))
	q:(""=RowId) "Err 06"		//未找到患者报告信息
	s CurData=$g(^DHCPERPT(RowId))	
	
	//RPT_Status
	s Status=$p(CurData,"^",2)				//报告状态
	s Status=..GetStatusDesc(Status,PAADM)
	
	//RPT_PrintFormat
	s PrintFormat=$p(CurData,"^",3)						//打印格式
	i (""=PrintFormat) s PrintFormat=1
	
	s GADMDRName=$p($g(^DHCPEGBI(GBIDR)),"^",2)	//团体客户基本信息登记表 DHC_PE_GBaseInfo

	q RowId_"^"_GADMDRName_"^"_PrintFormat_"^"_Status
}

/// 获取患者报告信息 
/// 使用：	DHCPECallRpt
ClassMethod GetIReportInfor(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s PAADM=$p(InString,"^",1)
	if (""=PAADM) q "Err 01"	//无效 Adm
	s IADMRowId=0
	s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,IADMRowId))
	q:(""=IADMRowId) "Err 05"	//未找到体检人信息
	s RowId=0
	s RowId=$O(^DHCPERPT(0,"IADM",IADMRowId,RowId))
	q:(""=RowId) "Err 06"		//未找到报告信息
	s CurData=$g(^DHCPERPT(RowId))	
	
	//RPT_Status
	s Status=$p(CurData,"^",2)				//报告状态
	s StatusDesc=..GetStatusDesc(Status)
	
	//RPT_PrintFormat
	s PrintFormat=$p(CurData,"^",3)						//打印格式
	i (""=PrintFormat) s PrintFormat=1
	
	//RPT_GADM_DR
	s GADMDR=$p(CurData,"^",10)
	i (""=GADMDR) d
	.s GADMDRName="无"
	e  d 
	.s GADMGBIDR=$p($g(^DHCPEGADM(GADMDR)),"^",1)		//DHC_PE_GADM
	.i (""'=lGADMGBIDR) d
	..s GADMDRName=$p($g(^DHCPEGBI(GADMGBIDR)),"^",2)	//团体客户基本信息登记表 DHC_PE_GBaseInfo

	s PapmiDR=$p($g(^PAADM(PAADM)),"^",1)				//PA_ADM	PAADM_PAPMI_DR
	s IADMDRName=$p(^PAPER(PapmiDR,"ALL"),"^",1)		//姓名	PAPMI_Name
	S PAPMINO=$P(^PAPER(PapmiDR,"PAT",1),"^",1)			//登记号
	
	q RowId_"^"_IADMDRName_"^"_GADMDRName_"^"_PrintFormat_"^"_Status_"^"_StatusDesc
}

/// 获取患者报告信息 不要使用
/// 
ClassMethod GetADMReportInfor(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
	s PAADM=$p(InString,"^",1)
	if (""=PAADM) q "Err 01"	//无效 Adm
	s IADMRowId=0
	s IADMRowId=$O(^DHCPEIADM(0,"PAADM",PAADM,IADMRowId))
	q:(""=IADMRowId) "Err 05"	//未找到体检人信息
	s RowId=0
	s RowId=$O(^DHCPERPT(0,"IADM",IADMRowId,RowId))
	q:(""=RowId) "Err 06"		//未找到报告信息
	s CurData=$g(^DHCPERPT(RowId))	
	
	//RPT_Status
	s Status=$p(CurData,"^",2)				//报告状态
	s StatusDesc=..GetStatusDesc(Status)
	
	//RPT_PrintFormat
	s PrintFormat=$p(CurData,"^",3)						//打印格式
	i (""=PrintFormat) s PrintFormat=1
	
	//RPT_GADM_DR
	s GADMDR=$p(CurData,"^",10)
	i (""=GADMDR) d
	.s GADMDRName="无"
	e  d 
	.s GADMGBIDR=$p($g(^DHCPEGADM(GADMDR)),"^",1)		//DHC_PE_GADM
	.i (""'=lGADMGBIDR) d
	..s GADMDRName=$p($g(^DHCPEGBI(GADMGBIDR)),"^",2)	//团体客户基本信息登记表 DHC_PE_GBaseInfo

	s PapmiDR=$p($g(^PAADM(PAADM)),"^",1)				//PA_ADM	PAADM_PAPMI_DR
	s IADMDRName=$p(^PAPER(PapmiDR,"ALL"),"^",1)		//姓名	PAPMI_Name
	S PAPMINO=$P(^PAPER(PapmiDR,"PAT",1),"^",1)			//登记号
	
	q RowId_"^"_IADMDRName_"^"_GADMDRName_"^"_PrintFormat_"^"_Status_"^"_StatusDesc
}

/// 提供一个查询审核人的列表
Query FindUser(UserDesc As %Library.String = "") As %Query(ROWSPEC = "usrname:%String:姓名, rowid:%String:ID")
{
}

ClassMethod FindUserExecute(ByRef qHandle As %Binary, UserDesc As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s rowid="0"
    f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d
    .s usrname=$p(^SSU("SSUSR",rowid),"^",2)
    .q:(""'=UserDesc)&('(usrname[UserDesc))
    .d OutputRow3
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(usrname,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Q
}

ClassMethod FindUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUserExecute ]
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

ClassMethod FindUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUserExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 更新数据接口（对象）函数 给出RowId 的更改数据 没有RowId传入的将数据插入数据库
ClassMethod ISave()
{
	s ReturnFlag=""
	i ""=PLIST(1) d
	.s ReturnFlag=..Insert()
	e  d
	.s ReturnFlag=..Update()
	q ReturnFlag
}

/// 插入新的记录
/// w ##class(web.DHCPE.Report).Insert()
ClassMethod Insert()
{
	k PLIST(1)			// RPT_RowId
	s PLIST(3)="NA"		// RPT_Status
	&SQL(Insert Into SQLUSER.DHC_PE_Report Values :PLIST())
	q SQLCODE
}

/// 更改数据
/// w ##class(web.DHCPE.Report).Update()
ClassMethod Update()
{
	s RowId=PLIST(1)	// RPT_RowId
	k PLIST(1)
	s CurStatus=$P($g(^DHCPERPT(RowId)),"^",2)

	Q:("NA"=CurStatus)&'(("NA"=PLIST(3))||("A"=PLIST(3))) "Report Err 1"	// 当报告未审核，只能执行审核操作
	Q:("A"=CurStatus)&'(("A"=PLIST(3))||("P"=PLIST(3))) "Report Err 2"	// 当报告审核状态，只能先执行打印操作
	Q:("P"=CurStatus)&'(("P"=PLIST(3))||("S"=PLIST(3))||("C"=PLIST(3))) "Report Err 3"	// 当报告打印以后状态，才能执行发送操作

	&SQL(Update SQLUSER.DHC_PE_Report Values :PLIST() 
		where RPT_RowId = :RowId)
	s ret=SQLCODE
	Q ret
}

/// 得到个人或者团体的报告状态  Adm 到达后的Adm  Type  "G":团体  "I":"个人"
ClassMethod GetReportStatus(Adm, Type As %String = "I")
{
	new (Adm, Type)
	s Flag=0
	s RType="IADM"
	i Type="G" s RType="GADM"
	i Type="PAADM"
	{
		s Adm =$O(^DHCPEIADM(0,"PAADM",Adm,0))
	}
	s RPId=$o(^DHCPERPT(0,RType,Adm,0))
	i RPId=""
	{
		d HaveAudit
	}
	else
	{
		s Status=$p(^DHCPERPT(RPId),"^",2)
		i Status="P" s Flag="Print Err"
		i Status="S" s Flag="Send Err"
		q:Flag'=0 Flag
		d HaveAudit
	}
	q Flag
	
HaveAudit
	s fFlag=##class(web.DHCPE.DHCPEGAdm).HadUsedAudit(Type,"",Adm)
	i fFlag=0 s Flag="Have Audit"
	q:Flag'=0
	i Type="G" d
	.s Team=0
	.f  s Team=$o(^DHCPEIADM(0,"GADM",Adm,Team)) q:(Team="")||(Flag'=0)  d
	..s iAdm=0
	..f  s iAdm=$o(^DHCPEIADM(0,"GADM",Adm,Team,iAdm)) q:(iAdm="")||(Flag'=0)  d
	...s fFlag=##class(web.DHCPE.DHCPEGAdm).HadUsedAudit("I","",iAdm)
	...i fFlag=0 s Flag="IHave Audit"
	q
}

/// Type "Report":报告
/// SendID  发送信息的ID
ClassMethod HadSendSMS(SendID, Type)
{
}

Query FindGetReport(RegNo As %Library.String = "", Name As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", IsGroup As %Library.String = "", LocID As %String = "") As %Query(ROWSPEC = "TName:%String,TRegNo:%String,TGroup:%String,TRegDate:%String,TGetReportDate:%String,THadOver:%String")
{
}

ClassMethod FindGetReportExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", Name As %Library.String = "", StartDate As %Library.String = "", EndDate As %Library.String = "", IsGroup As %Library.String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	i ((RegNo="")&&(Name="")&&(StartDate="")&&(EndDate=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
 	}
 	
 	
 	
 	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
 	s ind=1
 	s Table="DHCPEPreIADM"
 	s Detail="GetReportDateTime"
 	s ADMType="I"
 	i IsGroup=1
 	{
	 	s Table="DHCPEPreGADM"
	 	s ADMType="G"
 	}
	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
 	
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=$H
 	s Date=StartDate-1
 	f  s Date=$o(^DHCPEDataExi(Table,Detail,ADMType,Date)) q:(Date="")||(Date>EndDate)  d
 	.s TGetReportDate=##class(websys.Conversions).DateLogicalToHtml(Date)
 	.s Time=0
 	.f  s Time=$o(^DHCPEDataExi(Table,Detail,ADMType,Date,Time)) q:Time=""  d
 	..s ADM=0
 	..f  s ADM=$o(^DHCPEDataExi(Table,Detail,ADMType,Date,Time,ADM)) q:ADM=""  d
 	...s (TName,TRegNo,TGroup,TRegDate,THadOver)=""
 	...d GetOnfInfo
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetOnfInfo
	s THadOver=0
	s flag=0 	
	i IsGroup=1 d
	.s TRegDate=$p($G(^DHCPEPreGADM(ADM)),"^",2)
	
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",ADM,LocID) 
  	.q:LocFlag=1

	.i TRegDate'="" d
	..s TRegDate=##class(websys.Conversions).DateLogicalToHtml(TRegDate)
	.s BID=$p($G(^DHCPEPreGADM(ADM)),"^",1)
	.i BID'="" d
	..s TName=$p($G(^DHCPEPreGBI(BID)),"^",2)
	..s TGroup=TName
	..s TRegNo=$p($G(^DHCPEPreGBI(BID)),"^",13)
	.s PEADM=$o(^DHCPEGADM(0,"CRMGADM",ADM,""))
	.i PEADM'="" d
	..s ReportID=$O(^DHCPERPT(0,"GADM",PEADM,""))
	..i ReportID'=""  d
	...s Status=$p($G(^DHCPERPT(ReportID)),"^",2)
	...s:Status'="NA" THadOver=1
	e  d
	.s TRegDate=$p($G(^DHCPEPreIADM(ADM)),"^",4)
	.s PreStatus=$p($G(^DHCPEPreIADM(ADM)),"^",8)
	.i PreStatus="CANCELPE" s flag=1
	.i TRegDate'="" d
	..s TRegDate=##class(websys.Conversions).DateLogicalToHtml(TRegDate)
	.s GID=$p($G(^DHCPEPreIADM(ADM)),"^",2)
	.i GID'="" d
	..s GBID=$p($G(^DHCPEPreGADM(GID)),"^",1)
	..i GBID'="" d
	...s TGroup=$p($G(^DHCPEPreGBI(GBID)),"^",2)
	.s BID=$p($G(^DHCPEPreIADM(ADM)),"^",1)
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",ADM,LocID) 
  	.q:LocFlag=1
  	
	.i BID'="" d
	..s TName=$p($G(^DHCPEPreIBI(BID)),"^",2)
	..s TRegNo=$p($G(^DHCPEPreIBI(BID)),"^",1)
	.s PEADM=$o(^DHCPEIADM(0,"CRMADM",ADM,""))
	.i PEADM'="" d
	..s ReportID=$O(^DHCPERPT(0,"IADM",PEADM,""))
	..i ReportID'=""  d
	...s Status=$p($G(^DHCPERPT(ReportID)),"^",2)
	...s:Status'="NA" THadOver=1
	
	q:THadOver=1
	q:flag=1
	q:TName'[Name
	q:((RegNo'="")&&(TRegNo'=RegNo))
	d FindBuild
	q
FindBuild
	set Data=$lb(TName,TRegNo,TGroup,TRegDate,TGetReportDate,THadOver)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindGetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGetReportExecute ]
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

ClassMethod FindGetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SetReportLog(ReportID As %Library.String = "")
{
	q:ReportID=""
	s UserID=%session.Get("LOGON.USERID")
	s Date=$p($H,",",1)
	s Time=$p($H,",",2)
	&SQL(Insert Into SQLUSER.DHC_PE_ReportPrintRecords (RPR_ParRef,RPR_PrintUser_DR,RPR_PrintDate,RPR_PrintTime) values(:ReportID,:UserID,:Date,:Time))
	q:SQLCODE
}

Query GetPPrintPerson(RegNo As %Library.String = "", TeamID As %Library.String = "", GADMDR As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRegNo:%String,TPrintStatus:%String,TPreIADM:%String")
{
}

ClassMethod GetPPrintPersonExecute(ByRef qHandle As %Binary, RegNo As %Library.String = "", TeamID As %Library.String = "", GADMDR As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	i ((RegNo="")&&(TeamID="")&&(GADMDR=""))
 	{
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
 	}
	s (PatName,PatRegNo,StatusName)=""
 	s ind=1
 	i GADMDR'=""  d
 	.s PTeamID=""
 	.i TeamID'=""  s PTeamID=$P($G(^DHCPEGADM($P(TeamID,"||",1),"Team",$P(TeamID,"||",2))),"^",2) 
 	.s GChildSub=0
 	.s PreGADM=$P($G(^DHCPEGADM(GADMDR)),"^",2)
 	.s PIADMRowId=0
 	.f  s PIADMRowId=$o(^DHCPEPreIADM(0,"PGADM",PreGADM,PIADMRowId))  q:PIADMRowId=""  d
 	..s IADMStatus=$p($G(^DHCPEPreIADM(PIADMRowId)),"^",8)
 	..q:IADMStatus="CANCELPE" 
 	..s PIBIID=$p($G(^DHCPEPreIADM(PIADMRowId)),"^",1)
 	..s PGTeamDR=$p($G(^DHCPEPreIADM(PIADMRowId)),"^",3)
 	..Q:(PTeamID'="")&&(PTeamID'=PGTeamDR)
	..i PIBIID'="" d
	...s PatName=$p($G(^DHCPEPreIBI(PIBIID)),"^",2)
	...s PatRegNo=$p($G(^DHCPEPreIBI(PIBIID)),"^",1)
	...Q:(RegNo'="")&(RegNo'=PatRegNo)
	...s IADMRowId=$o(^DHCPEIADM(0,"CRMADM",PIADMRowId,""))
	...i IADMRowId'="" d
	....s PAADM=$P($G(^DHCPEIADM(IADMRowId)),"^",1)
	....q:PAADM=""
	....s ReportID=$O(^DHCPERPT(0,"IADM",IADMRowId,""))
	....i ReportID'=""  d
	.....s Status=$p($G(^DHCPERPT(ReportID)),"^",2)
	.....s StatusName=..GetStatusDesc(Status,PAADM)
    .....i $G(^DHCPEReportPart("GroupPartPrint","PreIADM",PIADMRowId))="Y"   S StatusName="已打印"
    ..d output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output
	set Data=$lb(PatName,PatRegNo,StatusName,PIADMRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetPPrintPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPPrintPersonExecute ]
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

ClassMethod GetPPrintPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPPrintPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SavePerson(GADM, PreIADMStr, Flag, Num)
{
 
   
    s Date=+$h
    s UserID="1"
  
 	s num=$o(^DHCPEReportPart("GroupPartPrint",GADM,""),-1)
    s num=num+1 
	i Flag="S" 
	{
    s ^DHCPEReportPart("GroupPartPrint",GADM,num)=PreIADMStr_"!"_UserID_"!"_Date_"!"_"N"
	s length=$L(PreIADMStr,"^")
	f j=2:1:length-1  d 
    .s PreIADM=$P(PreIADMStr,"^",j)
    .s ^DHCPEReportPart("GroupPartPrint","PreIADM",GADM,PreIADM)="N"
	}
	elseif Flag="P" {
	if Num=""{
			s ^DHCPEReportPart("GroupPartPrint",GADM,num)=PreIADMStr_"!"_UserID_"!"_Date_"!"_"Y"
	        s length=$L(PreIADMStr,"^")
	         f j=2:1:length-1  d 
            .s PreIADM=$P(PreIADMStr,"^",j)
            .s ^DHCPEReportPart("GroupPartPrint","PreIADM",PreIADM)="Y"
            .kill %session.Data(GADM,PreIADM)
			}
	else {
		    s ^DHCPEReportPart("GroupPartPrint",GADM,Num)=PreIADMStr_"!"_UserID_"!"_Date_"!"_"Y"
	         s length=$L(PreIADMStr,"^")
	     
	         f j=2:1:length-1 d 
            .s PreIADM=$P(PreIADMStr,"^",j)
            .s ^DHCPEReportPart("GroupPartPrint","PreIADM",PreIADM)="Y"
            .kill %session.Data(GADM,PreIADM)
		}
		
	}
	else {
		if Num=""{
			
	         s length=$L(PreIADMStr,"^")
	         f j=2:1:length-1  d 
            .s PreIADM=$P(PreIADMStr,"^",j)
          
			}
	else {
		 
	         s length=$L(PreIADMStr,"^")
	         f j=2:1:length-1 d 
            .s PreIADM=$P(PreIADMStr,"^",j)
           
	}
	}
    q
}

ClassMethod GetData(JSFunName, ListName, GADMDR, num)
{

 s rtnval=""
 s mySelFlag=0
 s myIdx=1
 s index=0
 for  set index=$O(%session.Data(GADMDR,index)) quit:index=""  do
 .set Name=$p($Get(%session.Data(GADMDR,index)),"^",1)
 .i myIdx=1 d
 ..s mySelFlag=1
 .e  d
 ..s mySelFlag=0
 .s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(Name),"O","JS")_"','"_$ZCVT($g(index),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
 .s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
 .&javascript<#(rtnval)#>
 .s myIdx=myIdx+1
 q 0
}

ClassMethod SaveSelecedData(String)
{
	
    s GADM=$p(String,"^",1)
	s PreIADM=$p(String,"^",2)
	s Name=$p(String,"^",3)
	s Regno=$p(String,"^",4)
	s Date=+$h
	set %session.Data(GADM,PreIADM)=Name_"^"_Regno
	q
}

ClassMethod Delete(String)
{
  
    s GADM=$P(String,"^",1)
    s PreIADM=$P(String,"^",2)
	k ^DHCPEReportPart("GroupPPrint","Seleced",GADM,PreIADM)
	kill %session.Data(GADM,PreIADM)
	q
}

ClassMethod DeleteSelecedData(String)
{
  
	s GADM=$p(String,"^",1)
	s PreIADM=$p(String,"^",2)
	s Name=$p(String,"^",3)
	s Regno=$p(String,"^",4)
	k ^DHCPEReportPart("GroupPPrint","Seleced",GADM,PreIADM)
	
	kill %session.Data(GADM,PreIADM)
	q
}

ClassMethod GetRowSession(GADM, Num)
{
  kill %session.Data(GADM)
  s DataStr=$g(^DHCPEReportPart("GroupPartPrint",GADM,Num))
  s PreIADMStr=$p(DataStr,"!",1)
  s length=$L(PreIADMStr,"^")
  f j=1:1:length  d 
   .s PreIADM=$P(PreIADMStr,"^",j)
   .i PreIADM'=""  d
   ..s PIBIDR=$P(^DHCPEPreIADM(PreIADM),"^",1)
   ..s PatName=$p(^DHCPEPreIBI(PIBIDR),"^",2)
   ..s Regno=$p(^DHCPEPreIBI(PIBIDR),"^",1)
   ..set %session.Data(GADM,PreIADM)=PatName_"^"_Regno

	q
}

Query FindPrintedList(GADMDR As %Library.String = "") As %Query(ROWSPEC = "TSort:%String,TPrintDate:%String,TPrinter:%String,TPrintStatus:%String,TPersonList:%String")
{
}

// w ##class(%ResultSet).RunQuery("web.DHCPE.Report","FindPrintedList","2")

ClassMethod FindPrintedListExecute(ByRef qHandle As %Binary, GADMDR As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)

	i (GADMDR="")
 	{
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
 	}
 	s ind=1
	s Num=0
	f  s Num=$O(^DHCPEReportPart("GroupPartPrint",GADMDR,Num))  Q:Num=""  d
	.s DataStr=$g(^DHCPEReportPart("GroupPartPrint",GADMDR,Num))
	.s PreIADMStr=$p(DataStr,"!",1)
	.s UserID=$p(DataStr,"!",2)
	.s PrintDate=$zd($p(DataStr,"!",3),3)
	.s PrintStatus=$p(DataStr,"!",4)
	.i PrintStatus="N"  S PrintStatus="保存未打印"
	.else  s PrintStatus="已打印"
	.s length=$L(PreIADMStr,"^")
	.s NameStr=""
	.f j=1:1:length  d 
    ..s PreIADM=$P(PreIADMStr,"^",j)
	..i PreIADM'=""  d
	...s PIBIDR=$P(^DHCPEPreIADM(PreIADM),"^",1)
	...s PatName=$p(^DHCPEPreIBI(PIBIDR),"^",2)
	...i NameStr="" s NameStr=PatName
	...e  s NameStr=NameStr_" "_PatName
    .d output1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
output1
	set Data=$lb(Num,PrintDate,UserID,PrintStatus,NameStr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPrintedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPrintedListExecute ]
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

ClassMethod FindPrintedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPrintedListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGPersonDiagnosisByRow(Num As %Library.String = "", job As %Library.String = "")
{
 
  //s job=$J
  s UserID=%session.Get("LOGON.USERID")
  s Return=$g(^DHCPETemp("GPersonDiagnosis",UserID,job,Num))

 q Return
}

ClassMethod GetReportTypeByVip(IADM)
{
  s PIADMVip="1"
  Q:IADM="" "1"
  s PIADM=$P(^DHCPEIADM(IADM),"^",4)
  q:PIADM="" "1"
  s PIADMVip=$p(^DHCPEPreIADM(PIADM),"^",18)
  q PIADMVip
}

ClassMethod GetTemplateName(PAADM)
{
	q:PAADM="" ""
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	q:IADM="" ""
	s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	q:PIADM="" ""
	s VipLevel=$p(^DHCPEPreIADM(PIADM),"^",18)
	q:VipLevel="" ""
	q $p($g(^DHCPEVIPLevel("VIP",VipLevel)),"^",6)
}

Query SearchReportPrintInfo(RPTRowId As %Library.String = "") As %Query(ROWSPEC = "TPrintUser:%String,TPrintData:%String,TPrintTime:%String,TPrintNumber:%String")
{
}

// w ##class(%ResultSet).RunQuery("web.DHCPE.Report","SearchReportPrintInfo","2")

ClassMethod SearchReportPrintInfoExecute(ByRef qHandle As %Binary, RPTRowId As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)

	i (RPTRowId="")
 	{
	 	Set qHandle=$lb(0,repid,0)
	 	Quit $$$OK
 	}
 	s ind=1
 	s Sub=0
	f  s Sub=$O(^DHCPERPT(RPTRowId,"Print",Sub)) q:Sub=""  d
	.s TPrintUser=$P(^DHCPERPT(RPTRowId,"Print",Sub),"^",1)
	.s:TPrintUser'="" TPrintUser=$P(^SSU("SSUSR",TPrintUser),"^",2)
	.s TPrintData=$P(^DHCPERPT(RPTRowId,"Print",Sub),"^",2)
	.s:TPrintData'="" TPrintData=$ZD(TPrintData,3) 
	.s TPrintTime=$P(^DHCPERPT(RPTRowId,"Print",Sub),"^",3)
	.s:TPrintTime'="" TPrintTime=$ZT(TPrintTime,3)
	.d outputRecord
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
outputRecord
	set Data=$lb(TPrintUser,TPrintData,TPrintTime,ind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchReportPrintInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchReportPrintInfoExecute ]
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

ClassMethod SearchReportPrintInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchReportPrintInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能：根据就诊ID更新个人报告状态
ClassMethod SetReportStatusByPAADM(PAADM, Status, UserID)
{
  s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
  q:IADM="" ""
  s ReportID=$O(^DHCPERPT(0,"IADM",IADM,0))
  q:ReportID="" ""
  s InString=ReportID_"^"_Status_"^"_UserID
  q ..SetReportStatus("","",InString)
}

ClassMethod GetVirtualPrinter()
{
	q $G(^DHCPESetting("DHCPE","VirtualPrinter"))
}

}
