/// 谭吉善
/// 2018-12-20
/// 集合界面的有关患者的数据初始化，用于界面初始化或局部刷新时数据重定向
Class web.DHCDocViewDataInit Extends DHCDoc.Util.RegisteredObject
{

/// 住院患者医嘱信息总览护士csp,csp:ipdoc.patorderviewnurse.csp
ClassMethod InitPatOrderViewNurse(EpisodeID As %String) As %String
{
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s isNurseLogin =##class(web.DHCDocMain).isNurseLogin()
	//获取下医嘱人列表
	s OrdDoctorList=##class(web.DHCDocInPatUICommon).GetAdmInfoJson(EpisodeID)
	//用法筛选
	s ViewInstrJson=##Class(web.DHCDocInPatUICommon).GetAdmInstrJson(EpisodeID)
	//频次筛选
	s ViewFreqJson=##Class(web.DHCDocInPatUICommon).GetAdmFreqJson(EpisodeID)
	//开出科室
	s ViewLocDescJson=##Class(web.DHCDocInPatUICommon).GetViewLocDescJson(%session.Get("LOGON.USERID"),%session.Get("LOGON.GROUPID"),isNurseLogin,EpisodeID)
	s OrdrightKeyMenuHidden ="false",ExecrightKeyMenuHidden="false"
	s flag =##class(web.DHCDocMain).isHiddenMenu(EpisodeID,%session.Get("LOGON.CTLOCID"))
    if (flag'=0)&&(flag'=2){
		s OrdrightKeyMenuHidden="true"
		s ExecrightKeyMenuHidden="true"
	}
	s patData = ##Class(web.DHCDocViewDataInit).GetPatMenuFlag(EpisodeID,"JSON")
	
	s JsonData={}
	do JsonData.%Set("EpisodeID",EpisodeID)
	do JsonData.%Set("PatientID",PatientID)
	do JsonData.%Set("OrdDoctorList",[].%FromJSON(OrdDoctorList))
	do JsonData.%Set("ViewInstrJson",[].%FromJSON(ViewInstrJson))
	do JsonData.%Set("ViewFreqJson",[].%FromJSON(ViewFreqJson))
	do JsonData.%Set("ViewLocDescJson",[].%FromJSON(ViewLocDescJson))
	do JsonData.%Set("OrdrightKeyMenuHidden",OrdrightKeyMenuHidden)
	do JsonData.%Set("ExecrightKeyMenuHidden",ExecrightKeyMenuHidden)
	do JsonData.%Set("patData",[].%FromJSON(patData))
	Q JsonData.%ToJSON()
}

/*
	基于PAAdmType变化导致的前台数据变化，可以不用在js做特色处理，PAAdmType本身值的变化会强制刷新医嘱录入界面
*/
/// 住院护士补录医嘱界面csp,csp:oeorder.oplistcustom.new.csp
/// EmConsultItm会诊子表ID
/// w ##class(web.DHCDocViewDataInit).InitPatOrderViewGlobal(726,"","")
ClassMethod InitPatOrderViewGlobal(EpisodeID As %String, BillTypeID As %String = "", EmConsultItm As %String = "") As %String
{
	s ^Tempscl("gg")=EpisodeID_","_BillTypeID
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s PatName=$P($G(^PAPER(PatientID,"ALL")),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s isNurseLogin = ##class(web.DHCDocMain).isNurseLogin()
	s LogonCtLocId=%session.Get("LOGON.CTLOCID")
	s LogonUserId=%session.Get("LOGON.USERID")
	s LogonHospId=%session.Get("LOGON.HOSPID")
	i EpisodeID'="" d
	. s orderrow=$o(^OEORD(0,"Adm",+EpisodeID,"")) d:'orderrow
	. .s oeord=##class(User.OEOrder).%New()
	. .d oeord.OEORDAdmDRSetObjectId(EpisodeID)
	. .s oeord.OEORDDate=..%SysDate()
	. .s oeord.OEORDTime=..%SysTime()
	. .s save=oeord.%Save(0)
	. .s orderrow=+oeord.%Id()
	. .d oeord.%Close()
	
	s BillTypeDesc="",Epissubtype=""
	i EpisodeID {
		s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
		s Epissubtype=$P(^PAADM(EpisodeID,1),"^",6)
	}
	if BillTypeID'="" {
		Set objBillType=##class(User.PACAdmReason).%OpenId(BillTypeID)
		if $IsObject(objBillType) {
			s BillTypeDesc=objBillType.READesc
		}
	}
	;得到处方类型,门诊显示存在对应关系的所有处方类型,住院仅显示默认处方类型
	s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM(PAAdmType,BillTypeID) //"O"
	s PrescriptTypeStr=""
	if (EpisodeID) {
		s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PAAdmType)
		// ^ 分割第二个为默认
		s PrescriptTypeStr=$p(PrescriptTypeStr,"^",1)
	}
	//判断会诊申请发送过来的id，是否与本次的就诊id符合
	if (EmConsultItm'=""){
		s ECAdmDr=$P($G(^DHCEMCON(+EmConsultItm)),"^",1)
		if (ECAdmDr'=EpisodeID){
			s EmConsultItm=""
		}
	}
	
	s PatientNo=""
	if PatientID'="" {
		s PatTypeID=""
		Set objPat=##class(User.PAPerson).%OpenId(PatientID)
		if (($IsObject(objPat))&&($IsObject(objPat.PAPERSocialStatusDR))) {
			s PatTypeID=objPat.PAPERSocialStatusDR.%Id()
		}
		if PatTypeID=""  s PatTypeID=1
		s PatientNo=##Class(web.PAPatMas).GetRegistration(PatientID) 
	}
	
	;从后台获取医嘱类型
	s OrderPriorStr=##Class(web.DHCDocOrderCommon).GetOrderPrior(EpisodeID,"JSON",LogonCtLocId,..%LanguageID(),LogonUserId,%session.Get("LOGON.GROUPID"))
	;获取新医嘱录入是否可录入长期标识
	s INAdmTypeLoc=##Class(web.DHCDocOrderCommon).CheckINAdmTypeLoc(LogonCtLocId,EpisodeID,EmConsultItm)
	;判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(LogonCtLocId,EpisodeID)
	s IsShowOrdList=LoginAdmLocFlag //是否显示医嘱列表
	if (PAAdmType="I"){
		//住院患者临床科室(访问类型是住院)及科室类型是Ward的，都显示医嘱列表
		if (isNurseLogin=1)||($d(^PAC("ADMLOC",0,"AdmType","I",LogonCtLocId))){
			s IsShowOrdList="Y"
		}
	}else{
		if ($d(^PAC("ADMLOC",0,"AdmType","O",LogonCtLocId)))||($d(^PAC("ADMLOC",0,"AdmType","E",LogonCtLocId))){
			s LoginAdmLocFlag="Y"
		}
	}
	
	s CurrentDeposit=0
	if EpisodeID'="" s CurrentDeposit=##Class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)
	
	
	s EPDSYMCodeStr=##class(web.DHCDocOrderCommon).GetEPDSYMCodeStr(EpisodeID)
	s PatInIPAdmission=##class(web.DHCDocOrderCommon).CheckPatInIPAdmission(PatientID)
	
	if mradm'="" s InUseCPWRowId=$P(##class(web.DHCCPW.MR.ClinicalPathWays).GetActiveCPWByadm(mradm),"^",2)
	
	;是否医疗结算或者开出院医嘱
	s PAADMMedDischarged=0
	i EpisodeID'="" {
		s PAADMMedDischarged=##class(web.DHCDocOrderCommon).GetIsExistDischarged(EpisodeID)
	}
	;是否进行医疗结算.只有护士在医疗结算后可以录入医嘱,医生不许。
	s HaveMidDischarged=0
	i EpisodeID'="" {
		s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
	}
	;死亡标志
	s IsDeceased=##Class(web.PAPerson).CheckDeceased(PatientID)
	;获取患者当前出院状态,调用护理组接口
	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	;获取出院日期和时间
	s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
	s DischargeDate=$p(DischargeDateTime,"^",1)
	i DischargeDate'="" s DischargeDate=..%ZD(DischargeDate) //$zd(DischargeDate,3)
	s DischargeTime=$p(DischargeDateTime,"^",2)
	i DischargeTime'="" s DischargeTime=..%ZT(DischargeTime,1)
 
	
	s MRDiagnoseCount=##class(web.DHCDocOrderEntry).GetMRDiagnoseCount(mradm)
	;科研项目
	s PilotProStr=##class(web.PilotProject.DHCDocPilotProPat).GetPilotProStr(EpisodeID,LogonUserId)
	;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
	s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	;住院有主管医生才能录医嘱
	;s CFIPNeedDoctor=..%GetConfig("IPNeedDoctor")
	s IPNecessaryCatMsg=""
	if (EpisodeID'="") {
		s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		if (VisitStatus'="P") {
			s IPNecessaryCatMsg=##Class(web.DHCDocOrderCommon).GetIPNecessaryCat(EpisodeID)
			i IPNecessaryCatMsg'="" s IPNecessaryCatMsg=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","提示信息:该患者尚未录入")_IPNecessaryCatMsg_##class(websys.Translation).Get("oeorder.oplistcustom.new.csp","类医嘱.")
		}
	}
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(LogonUserId)
	s CareProvType=$zcvt(CareProvType,"U")
	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(LogonCtLocId,EpisodeID)
	s IPDefaultDurRowId=..%GetConfig("IPDefaultDuration")
	;不受就诊有效天数限制
    ;s NoAdmValidDaysLimit=..%GetConfig1("NoAdmValidDaysLimit",%session.Get("LOGON.GROUPID"))
	s EnableButton=1
	s (warning,cmpDisabled)=""
	s (PilotProCareFlag,PilotProCare,VisitStatus,PilotProCareTel,PilotProName)=""
	i EpisodeID'=""  {
		s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		s PilotAdmInfo=##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(EpisodeID)
		s IfPilotAdm=$p(PilotAdmInfo,"^",1)
		s AdmPPRowId=$p(PilotAdmInfo,"^",2)
		i AdmPPRowId'="" {
			s PilotProCareFlag=##Class(web.PilotProject.DHCDocPilotProCommon).IsPilotProCareFlag(AdmPPRowId,LogonUserId)
			s PilotProCareInfo=##Class(web.PilotProject.DHCDocPilotProCommon).GetPilotProCare(AdmPPRowId)
			s PilotProName=$P($G(^DHCDocPP(AdmPPRowId)),"^",2)
			s langid=..%LanguageID()
			s PilotProName=##class(User.DHCDocPilotProject).GetTranByDesc("PPDesc",PilotProName,langid)
			s PilotProCare=$p(PilotProCareInfo,"^",3)
			s PilotProCareTel=$p(PilotProCareInfo,"^",4)
		}
		s warning=##Class(web.DHCDocViewDataInit).GetOrdWarning(EpisodeID,..%SessionStr(),EmConsultItm)
		
		s warning=##class(web.DHCDocUtil).EvalJSON(warning)
	}
	s OnlyShortPrior="N"
	if VisitStatus="P" s OnlyShortPrior="Y"
	s PAADMMotherAdmId=$p($g(^PAADM(EpisodeID)),"^",75)
 	;是否弹出实习生审核页面
 	s PracticeShowFlag=0
 	//s PracticeLabFlag=0
 	//s PracticeCureFlag=0
 	if (CareProvType="DOCTOR"){
		s GetPracticeOrdNum=##class(web.DHCPracticeDocPreOrder).GetPracticeOrdNum(EpisodeID,"N","R^Cure^CureAdvise") //,"R"
 	 	s VerifyStyleNum=##class(web.DHCPracticeDocPreOrder).GetVerifyStyleNum(EpisodeID)
		s PracticeLabNum=##Class(web.DHCAPPExaReportQuery).QueryExaReqHisListCount("30","1",EpisodeID_"^^I^"_LogonHospId)
		//s PracticeCureFlag=##class(web.DHCPracticeDocPreOrder).GetPracticeOrdNum(EpisodeID,"N","Cure")
		s PracticeShowFlag=GetPracticeOrdNum+VerifyStyleNum+PracticeLabNum
	}else{
		 s PracticeShowFlag=0
	}
	s CPWOrdFlag=0
	if (EpisodeID) {
		;是否显示“添加临床路径医嘱”按钮
 		s CPWOrdFlag=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetPathStatusToDOC",EpisodeID)
	}
	k CopyItemArr
 	s CopyItemJson="[]"
 	d ##Class(User.DHCDocOrderCopyData).GetCopyItem(EpisodeID,LogonCtLocId,LogonUserId,.CopyItemArr)
 	if $D(CopyItemArr){
	 	s CopyItemJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.CopyItemArr)
	 	s CopyItemJson=$replace(CopyItemJson,"""","'")
	 	s CopyItemJson=$replace(CopyItemJson,"'","\'")
	}
	s InsurBillStr=##Class(web.DHCDocOrderCommon).GetInsurBillStr(PAAdmType)
	;可以录入小数的子类
 	s AllowEntryDecimalItemCat=##class(web.DHCDocOrderCommon).GetAllowEntryDecimalItemCat(EpisodeID,LogonHospId)
	;行按钮栏
	s RowBtnData=##class(DHCDoc.Util.QueryToJSON).%New("DHCDoc.OPDoc.MainFrame","QueryBtnCfg","order.entry.row.csp",EpisodeID,LogonHospId).ToArray()
 	s JsonData={}
	do JsonData.%Set("EpisodeID",EpisodeID)
	do JsonData.%Set("PatientID",PatientID)
	do JsonData.%Set("PatientNo",PatientNo)
	do JsonData.%Set("mradm",mradm)
	do JsonData.%Set("orderrow",orderrow)
	do JsonData.%Set("PAAdmType",PAAdmType)
	do JsonData.%Set("BillTypeID",BillTypeID)
	do JsonData.%Set("BillTypeDesc",BillTypeDesc)
	do JsonData.%Set("EnableButton",EnableButton)
	do JsonData.%Set("IPDefaultDurRowId",IPDefaultDurRowId)
	do JsonData.%Set("CurrentDeposit",CurrentDeposit)
	do JsonData.%Set("Epissubtype",Epissubtype)
	do JsonData.%Set("EPDSYMCodeStr",EPDSYMCodeStr)
	do JsonData.%Set("InUseCPWRowId",InUseCPWRowId)
	do JsonData.%Set("PAADMMedDischarged",PAADMMedDischarged)
	do JsonData.%Set("OrderPriorStr",OrderPriorStr)
	do JsonData.%Set("INAdmTypeLoc",INAdmTypeLoc)
	do JsonData.%Set("LoginAdmLocFlag",LoginAdmLocFlag)
	do JsonData.%Set("IsShowOrdList",IsShowOrdList)
	
	do JsonData.%Set("PatTypeID",PatTypeID)
	do JsonData.%Set("warning",warning)
	do JsonData.%Set("MRDiagnoseCount",MRDiagnoseCount)
	do JsonData.%Set("PrescriptTypes",PrescriptTypes)
	do JsonData.%Set("IsDeceased",IsDeceased)
	do JsonData.%Set("PilotProStr",PilotProStr)
	
	do JsonData.%Set("GetStayStatusFlag",GetStayStatusFlag)
	do JsonData.%Set("CurrentDischargeStatus",CurrentDischargeStatus)
	do JsonData.%Set("DischargeDate",DischargeDate)
	do JsonData.%Set("DischargeTime",DischargeTime)
	do JsonData.%Set("HaveMidDischarged",HaveMidDischarged)
	do JsonData.%Set("OnlyShortPrior",OnlyShortPrior)
	do JsonData.%Set("VisitStatus",VisitStatus)
	do JsonData.%Set("LoginAdmLocFlag",LoginAdmLocFlag)
	do JsonData.%Set("PAADMMotherAdmId",PAADMMotherAdmId)
	do JsonData.%Set("PilotProCareFlag",PilotProCareFlag)
	do JsonData.%Set("PilotProCare",PilotProCare)
	do JsonData.%Set("PilotProCareTel",PilotProCareTel)
	
	do JsonData.%Set("PatInIPAdmission",PatInIPAdmission)
	do JsonData.%Set("IPNecessaryCatMsg",IPNecessaryCatMsg)
	do JsonData.%Set("orderrow",orderrow)
	do JsonData.%Set("PrescriptTypeStr",PrescriptTypeStr)
	do JsonData.%Set("PracticeShowFlag",PracticeShowFlag)
	do JsonData.%Set("CPWOrdFlag",CPWOrdFlag)
	//do JsonData.%Set("PracticeLabFlag",PracticeLabFlag)
	//do JsonData.%Set("PracticeCureFlag",PracticeCureFlag)
	do JsonData.%Set("UserEMVirtualtLong",UserEMVirtualtLong)
	do JsonData.%Set("CopyItemJson",CopyItemJson)
	do JsonData.%Set("EmConsultItm",EmConsultItm)
	do JsonData.%Set("InsurBillStr",InsurBillStr)
	do JsonData.%Set("AllowEntryDecimalItemCat",AllowEntryDecimalItemCat)
	do JsonData.%Set("RowBtnData",RowBtnData)
	do JsonData.%Set("PilotProName",PilotProName)
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonData.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

/// 住院患者总览csp,csp:ipdoc.patinfoview.csp
/// w ##Class(web.DHCDocViewDataInit).InitPatInfoView(313)
ClassMethod InitPatInfoView(EpisodeID As %String) As %String
{
	s LogonCTLocId=%session.Get("LOGON.CTLOCID")
	s LogonUserCode=%session.Get("LOGON.USERCODE")
	s LogonGroupId=%session.Get("LOGON.GROUPID")
	s LogonHospId=%session.Get("LOGON.HOSPID")
	
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	//获取患者就诊信息 放前台异步调用
	;s PatAdmInfoJson=##Class(web.DHCDocInPatPortalCommon).GetAdmInfoJson(EpisodeID,LogonUserCode)
	//获取下医嘱人列表
	s OrdDoctorList=##class(web.DHCDocInPatUICommon).GetAdmInfoJson(EpisodeID)
	s patData = ##Class(web.DHCDocViewDataInit).GetPatMenuFlag(EpisodeID,"JSON")
	///环节质控和时效性缺陷数量
	//s EmrQualityQtyJson=##class(web.DHCDocInPatPortalCommon).GetEmrQualityQty(EpisodeID,"2_"_LogonGroupId_"_"_LogonCTLocId)
	s EmrQualityQtyJson=##class(EPRservice.Quality.Ajax.QualityInfoShow).GetEmrQualityQty(EpisodeID,"2_"_LogonGroupId_"_"_LogonCTLocId)
	s MessageMarquee=##Class(DHCAnt.KSS.MainInterface).GetAntOverTimeOrdList(EpisodeID,LogonHospId)
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	;判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(LogonCTLocId,EpisodeID)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (PAAdmType'="I"){
		if ($d(^PAC("ADMLOC",0,"AdmType","O",LogonCTLocId)))||($d(^PAC("ADMLOC",0,"AdmType","E",LogonCTLocId))){
			s LoginAdmLocFlag="Y"
		}
	}
	//用法筛选
	s ViewInstrJson=##Class(web.DHCDocInPatUICommon).GetAdmInstrJson(EpisodeID)
	//频次筛选
	s ViewFreqJson=##Class(web.DHCDocInPatUICommon).GetAdmFreqJson(EpisodeID)
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	s OrdrightKeyMenuHidden =0,ExecrightKeyMenuHidden=0
	s flag =##class(web.DHCDocMain).isHiddenMenu(EpisodeID,%session.Get("LOGON.CTLOCID"))
    if (flag'=0)&&(flag'=2){
		s OrdrightKeyMenuHidden=1
		s ExecrightKeyMenuHidden=1
	}
	s JsonData={}
	do JsonData.%Set("EpisodeID",EpisodeID)
	do JsonData.%Set("PatientID",PatientID)
	;do JsonData.%Set("PatAdmInfoJson",[].%FromJSON(PatAdmInfoJson))
	do JsonData.%Set("OrdDoctorList",[].%FromJSON(OrdDoctorList))
	do JsonData.%Set("patData",[].%FromJSON(patData))
	do JsonData.%Set("EmrQualityQtyJson",[].%FromJSON($replace(EmrQualityQtyJson,"'","""")))
	do JsonData.%Set("MessageMarquee",MessageMarquee)
	do JsonData.%Set("VisitStatus",VisitStatus)
	do JsonData.%Set("LoginAdmLocFlag",LoginAdmLocFlag)
	do JsonData.%Set("ViewInstrJson",[].%FromJSON(ViewInstrJson))
	do JsonData.%Set("ViewFreqJson",[].%FromJSON(ViewFreqJson))
	do JsonData.%Set("UserEMVirtualtLong",UserEMVirtualtLong)
	do JsonData.%Set("OrdrightKeyMenuHidden",OrdrightKeyMenuHidden)
	do JsonData.%Set("ExecrightKeyMenuHidden",ExecrightKeyMenuHidden)
	Q JsonData.%ToJSON()
}

/// 住院患者医嘱信息医生csp,csp:ipdoc.patorderview.csp
ClassMethod InitPatOrderView(EpisodeID As %String) As %String
{
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	//获取下医嘱人列表
	s OrdDoctorList=##class(web.DHCDocInPatUICommon).GetAdmInfoJson(EpisodeID)
	s OrdrightKeyMenuHidden =0,ExecrightKeyMenuHidden=1
	s flag =##class(web.DHCDocMain).isHiddenMenu(EpisodeID,%session.Get("LOGON.CTLOCID"))
    if (flag'=0)&&(flag'=2){
		s OrdrightKeyMenuHidden=1
		//s ExecrightKeyMenuHidden="true"
	}
	s patData = ##Class(web.DHCDocViewDataInit).GetPatMenuFlag(EpisodeID,"JSON")
	s LogonLocAdmTypeLimit=##Class(web.DHCDocOrderCommon).CheckLogonLocAdmTypeLimit(%session.Get("LOGON.CTLOCID"),PAAdmType)
	s LogonLocAdmTypeLimit=$CASE(LogonLocAdmTypeLimit,"":"Y",:"N")
	s UserEMVirtualtLong=##Class(web.DHCDocOrderVirtualLong).GetUserEMVirtualtLong(EpisodeID)
	//用法筛选
	s ViewInstrJson=##Class(web.DHCDocInPatUICommon).GetAdmInstrJson(EpisodeID)
	//频次筛选
	s ViewFreqJson=##Class(web.DHCDocInPatUICommon).GetAdmFreqJson(EpisodeID)
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s JsonData={}
	do JsonData.%Set("EpisodeID",EpisodeID)
	do JsonData.%Set("PatientID",PatientID)
	do JsonData.%Set("PAAdmType",PAAdmType)
	do JsonData.%Set("OrdDoctorList",[].%FromJSON(OrdDoctorList))
	do JsonData.%Set("OrdrightKeyMenuHidden",OrdrightKeyMenuHidden)
	do JsonData.%Set("ExecrightKeyMenuHidden",ExecrightKeyMenuHidden)
	do JsonData.%Set("patData",[].%FromJSON(patData))
	do JsonData.%Set("LogonLocAdmTypeLimit",LogonLocAdmTypeLimit)
	do JsonData.%Set("UserEMVirtualtLong",UserEMVirtualtLong)
	do JsonData.%Set("ViewInstrJson",[].%FromJSON(ViewInstrJson))
	do JsonData.%Set("ViewFreqJson",[].%FromJSON(ViewFreqJson))
	do JsonData.%Set("VisitStatus",VisitStatus)
	Q JsonData.%ToJSON()
}

/// 草药录入界面csp,csp:opdoc.oeorder.cmlistcustom.csp
ClassMethod InitPatOrderViewGlobalCM(EpisodeID As %String, EmConsultItm As %String = "") As %String
{
	
	s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
    s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s LocDesc=##Class(web.PAAdm).getPatEpisLoc(EpisodeID)
	s LocID=##Class(web.CTLoc).GetIdFromCodeOrDescription(LocDesc)
	s %request.Data("CTLOC",1)=LocDesc
	Set langid=..%LanguageID()
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	i EpisodeID'="" d
	. s orderrow=$o(^OEORD(0,"Adm",+EpisodeID,"")) d:'orderrow
	. .s oeord=##class(User.OEOrder).%New()
	. .d oeord.OEORDAdmDRSetObjectId(EpisodeID)
	. .s oeord.OEORDDate=..%SysDate()
	. .s oeord.OEORDTime=..%SysTime()
	. .s save=oeord.%Save(0)
	. .s orderrow=+oeord.%Id()
	. .d oeord.%Close()
	//判断会诊申请发送过来的id，是否与本次的就诊id符合
	if (EmConsultItm'=""){
		s ECAdmDr=$P($G(^DHCEMCON(+EmConsultItm)),"^",1)
		if (ECAdmDr'=EpisodeID){
			s EmConsultItm=""
		}
	}
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(%session.Get("LOGON.USERID"))
	s CareProvType=$zcvt(CareProvType,"U")
	;判断登陆科室是否患者就诊科室及就诊科室的linklocation中的科室
	;s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(%session.Get("LOGON.CTLOCID"),EpisodeID)
	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).CheckINAdmTypeLoc(%session.Get("LOGON.CTLOCID"),EpisodeID,EmConsultItm,"Y")
	;是否进行医疗结算.只有护士在医疗结算后可以录入医嘱,医生不许。
	s HaveMidDischarged=0
	i EpisodeID'="" {
		s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
		s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	} 	
	;接收科室
	//s CNMedCookRecLocStr=##Class(web.DHCDocOrderEntryCM).GetCNMedCookRecloc(PAAdmType)
	//得到草药的接收科室
	if PAAdmType="I" {
		s PACWardID=$P($g(^PAADM(EpisodeID)),"^",70)
		s EpLoc=$P($g(^PAWARD(PACWardID)),"^",5)
	}else{
		s EpLoc=$P($g(^PAADM(EpisodeID)),"^",4)
	}
	//s CMRecLocStr=##Class(web.DHCDocOrderCommon).GetCMRecLoc(EpisodeID,"")
	;处方列表
	s PrescList=##class(web.UDHCPrescript).GetPAAdmPrescList(EpisodeID,25)
	;得到本次就诊未交费总金额
	s ToBillSumDetail=##Class(web.DHCDocOrderEntry).GetToBillSum(EpisodeID)
	s ToBillSum=$p(ToBillSumDetail,"^",1)
	;获取病人当前出院状态,调用护理组接口
	s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	;获取出院日期和时间
	s DischargeDateTime=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
	s DischargeDate=$p(DischargeDateTime,"^",1)
	i DischargeDate'="" s DischargeDate=..%ZD(DischargeDate) //$zd(DischargeDate,3)
	s DischargeTime=$p(DischargeDateTime,"^",2)
	i DischargeTime'="" s DischargeTime=..%ZT((DischargeTime-1),1)
	
	s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s PrescriptTypes=""
	s CurrOrderBillTypeRowid="",DefaultBilltype=""
	if (EpisodeID'="")&(PAAdmType'="I") {
		s PrescriptTypes=##Class(web.DHCPAADMPrescType).GetPrescTypeByPAADM(PAAdmType,BillTypeID,"",langid) //"O"
	}else{
		s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PAAdmType)
		s PrescriptTypeStr=$p(PrescriptTypeStr,"^",1)
		s DefaultBilltype=$p(PrescriptTypeStr,":",1)
	}
	s PAADMMotherAdmId=$p($g(^PAADM(EpisodeID)),"^",75)
	;是否显示“添加临床路径医嘱”按钮
	s CPWOrdFlag=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetPathStatusToDOC",EpisodeID)
 	;处方剂型串
 	s CMPrescTypeStrStr=##Class(web.DHCDocOrderCommon).GetCMPrescTypeStr(EpisodeID,%session.Get("LOGON.HOSPID"))
	s EnableButton=1
	s orderrow=$o(^OEORD(0,"Adm",+EpisodeID,""))
	s warning=##Class(web.DHCDocViewDataInit).GetOrdWarning(EpisodeID,..%SessionStr(),EmConsultItm,"Y")
	if (warning'=""){
		s EnableButton=0
	}
	//
	if (CareProvType="DOCTOR"){
		s GetPracticeOrdNum=##class(web.DHCPracticeDocPreOrder).GetPracticeOrdNum(EpisodeID,"N","C")
		s VerifyStyleNum=##class(web.DHCPracticeDocPreOrder).GetVerifyStyleNum(EpisodeID)
		s PracticeShowFlag=GetPracticeOrdNum+VerifyStyleNum
	}else{
		s PracticeShowFlag=0
	}
	//s AllowEntryDecimalItemCat=##Class(web.DHCDocOrderCommon).GetAllowEntryDecimalItemCat(EpisodeID,%session.Get("LOGON.HOSPID"))
	s JsonData={}
	do JsonData.%Set("EpisodeID",EpisodeID)
	do JsonData.%Set("PatientID",PatientID)
	do JsonData.%Set("mradm",mradm)
	do JsonData.%Set("orderrow",orderrow)
	do JsonData.%Set("PAAdmType",PAAdmType)
	
	do JsonData.%Set("LoginAdmLocFlag",LoginAdmLocFlag)
	//do JsonData.%Set("HaveMidDischarged",HaveMidDischarged)
	do JsonData.%Set("warning",warning)
	do JsonData.%Set("EnableButton",EnableButton)
	//do JsonData.%Set("CMRecLocStr",CMRecLocStr)
	do JsonData.%Set("PrescList",PrescList)
	do JsonData.%Set("ToBillSum",ToBillSum)
	do JsonData.%Set("CurrentDischargeStatus",CurrentDischargeStatus)
	do JsonData.%Set("DischargeDate",DischargeDate)
	do JsonData.%Set("DischargeTime",DischargeTime)
	do JsonData.%Set("PrescriptTypes",PrescriptTypes)
	//do JsonData.%Set("CurrOrderBillTypeRowid",CurrOrderBillTypeRowid)
	do JsonData.%Set("DefaultBilltype",DefaultBilltype)
	do JsonData.%Set("PAADMMotherAdmId",PAADMMotherAdmId)
	do JsonData.%Set("CPWOrdFlag",CPWOrdFlag)
	do JsonData.%Set("CMPrescTypeStrStr",CMPrescTypeStrStr)
	do JsonData.%Set("PracticeShowFlag",PracticeShowFlag)
	do JsonData.%Set("VisitStatus",VisitStatus)
	do JsonData.%Set("GetStayStatusFlag",GetStayStatusFlag)
	do JsonData.%Set("EmConsultItm",EmConsultItm)
	//do JsonData.%Set("AllowEntryDecimalItemCat",AllowEntryDecimalItemCat)
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonData.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	s JsonInfo=$replace(JsonInfo,"""","'")
	q JsonInfo
}

ClassMethod GetPatMenuFlag(EpisodeID As %String, type As %String = "") As %String
{
	
	s patFlag=##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(EpisodeID)
	s flagDesc=patFlag
	if (patFlag="1"){ s flagDesc="已出院" }
	elseif (patFlag="2"){ s flagDesc="医疗结算"}
	elseif (patFlag="2.5"){ s flagDesc="最终结算后,护士调整费用"}
	elseif (patFlag="3"){ s flagDesc="最终结算"}
	elseif (patFlag="4"){ s flagDesc="财务结算"}
	elseif (patFlag="5"){ s flagDesc="不是V7的患者"}
	if (type="JSON") {
		s PatJsonObj=[]
		s OneJson={}
		d OneJson.%Set("patFlag",patFlag)
		d OneJson.%Set("flagDesc",flagDesc)
		d OneJson.%Set("onlyModifyFee","N")
		do PatJsonObj.%Push(OneJson,"")
		Q PatJsonObj.%ToJSON()
	}else{
		s patData = "{'patFlag':'"_patFlag_"','flagDesc':'"_flagDesc_"','onlyModifyFee':'N'}"
		q patData
	}
}

/// Description:获取医嘱录入/草药录入提示信息
/// Input:EpisodeID:就诊ID isCMEntry:草药录入 EmConsultItm:会诊ID  NotAdmTypeLimit:是否判断访问类型限制(Y不判断)
ClassMethod GetOrdEntryWarning(EpisodeID As %String, isCMEntry = "N", EmConsultItm As %String = "", NotAdmTypeLimit As %String = "", SessionStr As %String = "", ExpStr As %String = "") As %String
{
	//会诊打开的病人，不受访问类型限制
	if EmConsultItm'=""{
		s NotAdmTypeLimit="Y"
	}
	if (SessionStr=""){
		s SessionStr=..%SessionStr()
	}
	s:EpisodeID=1189 ^tmplog("GetOrdEntryWarning")=$LB(EpisodeID, isCMEntry, EmConsultItm, NotAdmTypeLimit , SessionStr)
	if (SessionStr=""){
		s warning="未检测到有效的session信息,不允许操作!"
		Q warning
	}
	s LgUserID=$P(SessionStr,"^",1)
	s LgGroupID=$P(SessionStr,"^",2)
	s LgLoc=$P(SessionStr,"^",3)
	s LgHospID=$P(SessionStr,"^",4)
	s LgLangID=$P(SessionStr,"^",6)
	s SSUserLoginID=$P(SessionStr,"^",7)
	s LgSessionId=$P(SessionStr,"^",9)
	
	s CspName="oeorder.oplistcustom.new.csp"
	if ExpStr'=""{
		s CspName=$p(ExpStr,"^",1) 	
	}
	;Login类里面记录的数据是原Session,会存在和当前%session.SessionId不一致，改为取最新会话ID
	;s LoginInfo=##class(User.DHCClientLogin).GetInfo(SSUserLoginID)
	;s LgSessionId=$P(LoginInfo,"^",2)
	 
	s warning=""
	s LogonDoctorID=##class(web.SSUser).GetDefaultCareProvider(LgUserID)
	if (LogonDoctorID="") {
		s warning="该登录用户未对照有效的医护人员,不允许操作!"
		Q warning
	}
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(LgUserID)
	s CareProvType=$zcvt(CareProvType,"U")
	s LoginAdmLocFlag=##class(web.DHCDocOrderCommon).IsLoginAdmLoc(LgLoc,EpisodeID)
	i EpisodeID'="" {
		s PatientID=$P(^PAADM(EpisodeID),"^",1)
		s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		s FinFlag=$p($g(^PAADM(EpisodeID)),"^",45)
		s PAADMDocDR=$p($g(^PAADM(EpisodeID)),"^",9)
		s PAADMBedDR=$p($g(^PAADM(EpisodeID)),"^",73)
		s today=..%SysDate()
		s DocID=$P(^SSU("SSUSR",LgUserID),"^",14)
		s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s LogonLocAdmTypeLimitInfo=##Class(web.DHCDocOrderCommon).CheckLogonLocAdmTypeLimit(LgLoc,PAAdmType)
		if ((LogonLocAdmTypeLimitInfo'="")&(VisitStatus'="P")&(NotAdmTypeLimit'="Y")) {
			s warning=LogonLocAdmTypeLimitInfo
			s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
			Q warning
		}
		//基础的医嘱录入权限校验
		s warning=..GetOrdEntryBaseWarning(EpisodeID)
		s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
		Q:warning'="" warning
		if (PAAdmType="I") {
			;获取患者当前出院状态,调用护理组接口
			s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
			;是否存在转科申请
			s TransApp=##Class(Nur.DHCNurTransAudit).ifExistData(EpisodeID)
			if ((PAADMBedDR="")||(TransApp'=""))&&(CurrentDischargeStatus'="B")&&(VisitStatus'="P") {
				i TransApp'="" s warning="此患者正在转科途中,不允许开医嘱"
				e  s warning="此患者未分配床位,不允许开医嘱."
				s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
				Q warning
			}
			;住院有主管医生才能录医嘱
			s CFIPNeedDoctor=..%GetConfig("IPNeedDoctor")
			i (PAADMDocDR="")&&(CFIPNeedDoctor=1)&(VisitStatus'="P") {
				s warning="此患者未分配医生,不允许开医嘱." 
				s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
				Q warning
			}
			;是否进行医疗结算.只有护士在医疗结算后可以录入医嘱,医生不许。
			s HaveMidDischarged=##class(web.DHCDocOrderCommon).GetIsMidDischarged(EpisodeID)
			
			if ((HaveMidDischarged=1)&&(CareProvType="DOCTOR")&&(PAAdmType="I")&(CurrentDischargeStatus'="B")) {
				s warning="此患者已做医疗结算,不允许医生再开医嘱."
				s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
				Q warning
			}
			if ((VisitStatus="D")!(VisitStatus="C"))&(DocID'="")&(CurrentDischargeStatus'="B") {
				s warning="此患者已做最终结算,不允许医护人员再开医嘱."
				s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
				Q warning
			}
			s IPDefaultDurRowId=..%GetConfig("IPDefaultDuration")
			if PAAdmType="I",IPDefaultDurRowId="" {
				s warning="住院没有设定默认的疗程?请与系统维护部门联系."
				s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
				Q warning
			}
		}else{
			
			;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
			s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
			s warning=##class(web.DHCDocOutPatientList).CheckIsAdmissions(EpisodeID,LgUserID)
			s warning=##class(websys.Translation).Get(CspName,warning,LgLangID)
			Q:warning'="" warning
			
			;不受就诊有效天数限制
    		s NoAdmValidDaysLimit=..%GetConfig1("NoAdmValidDaysLimit",LgGroupID)
    		s LimitTimeStr=##class(web.DHCDocOrderCommon).GetVisitTimeToDay(EpisodeID)
    		;非临床科室不受就诊有效天数限制
    		s NotAdmTypeLocationFlag=0
    		s TAdmType=""
    		for {
	    		s TAdmType=$O(^PAC("ADMLOC",0,"AdmType",TAdmType))
	    		q:TAdmType=""
	    		s AdmTypeRowID=""
	    		for {
		    		s AdmTypeRowID=$O(^PAC("ADMLOC",0,"AdmType",TAdmType,LgLoc,AdmTypeRowID))
		    		q:AdmTypeRowID=""
		    		s NotAdmTypeLocationFlag=1
		    		}
	    		}
    		i ((+LimitTimeStr'=0)&&(NotAdmTypeLocationFlag=1)) { //&(PAAdmType="O")
	    		s PilotAdmInfo=##class(web.PilotProject.DHCDocPilotService).IIsPilotAdm(EpisodeID)
				s IfPilotAdm=$p(PilotAdmInfo,"^",1)
	    		if ((IfPilotAdm'=1)&&(NoAdmValidDaysLimit'=1)) {
		    		s PreWarn=##class(websys.Translation).Get(CspName,"此就诊记录的挂号日期在",LgLangID)
		    		s AfterWarn=##class(websys.Translation).Get(CspName,"以前,不允许再开医嘱.",LgLangID)
		    		s LimitTimeUnit=##class(websys.Translation).Get(CspName,$p(LimitTimeStr,"^",2),LgLangID)
		    		s LimitTime=$p(LimitTimeStr,"^",3)
		    		s warning=PreWarn_LimitTime_LimitTimeUnit_AfterWarn
		    		Q warning
		    	}
	    	}
		}
		s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		
		;查询当前患者的该次就诊是否有院感退回报告 
		s Medwarning=##Class(web.DHCMedInfService).IsReturnReport(EpisodeID)
		if (Medwarning'="") {
			s warning=warning_Medwarning
		}
	}
	Q warning
}

/***
  **Description      :校验最基本的医嘱录入管控，管控范围：医嘱录入界面、第三方接口等
  **Author           :tanjishan
  **Time             :2022/04/29
  **debugger         :w ##Class(web.DHCDocViewDataInit).GetOrdEntryBaseWarning()
  **Parameter        :EpisodeID：就诊号
  **Returns          :warning：警告信息，非空时不允许录入
***/
ClassMethod GetOrdEntryBaseWarning(EpisodeID As %String, SessionStr As %String = "") As %Library.String
{
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	s FinFlag=$p($g(^PAADM(EpisodeID)),"^",45)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s warning=""
	if (PAAdmType="I") {
		s OrderUnabled=##class(web.DHCDocOrderCommon).CheckOrderUnabled(EpisodeID)
		if OrderUnabled=1 {
			s warning="此患者正在结算中,不允许再开医嘱."
			Q warning
		}
		if FinFlag="Y" {
			s warning="此患者已结算出院,不允许再开医嘱."
			Q warning
		}
	}else{
		if (VisitStatus="C") {
			s warning="此患者已退号,不允许再开医嘱."
			Q warning
		}
		;1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
		s GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
		if (" 1 2 "[(" "_GetStayStatusFlag_" ")) {
			if (VisitStatus="D") {
				s warning="此患者已结算出院,不允许再开医嘱."
				Q warning
			}
			;死亡标志
			s IsDeceased=##Class(web.PAPerson).CheckDeceased(PatientID)
			if (IsDeceased="Y"){
				s warning="患者已故,不允许再开医嘱."
				Q warning
			}
		}
	}
	q warning
}

/// 获取医嘱录入相关界面的所有警告信息
ClassMethod GetOrdWarning(EpisodeID, SessionStr, EmConsultItm, isCMEntry = "N", NotAdmTypeLimit As %String = "") As %Status
{
	s orderrow=$o(^OEORD(0,"Adm",+EpisodeID,""))
	;Modify 20230424 不再判断登录锁，只保留审核动作的加锁,常规设置配置中已强制设置不勾选
	s LockMsg=##class(web.DHCDocOrderCommon).OrderLock(orderrow,SessionStr,"User.OEOrder.LoginIn",EmConsultItm)
	if (LockMsg'=""){
		q LockMsg
	}
	s warning=##Class(web.DHCDocViewDataInit).GetOrdEntryWarning(EpisodeID,isCMEntry,EmConsultItm,NotAdmTypeLimit,SessionStr)
	q warning
}

/*
	基于PAAdmType变化导致的前台数据变化，可以不用在js做特色处理，PAAdmType本身值的变化会强制刷新诊断录入界面
*/
/// w ##Class(web.DHCDocViewDataInit).InitPatDiagViewGlobal(87,"","","")
ClassMethod InitPatDiagViewGlobal(EpisodeID As %String, OutDisFlag As %String, SearchDiagnosTypeStr As %String, Opener As %String, CurLogonHosp As %String = "") As %String
{
	s ^Tempscl("InitPatDiagViewGlobal")=EpisodeID_","_OutDisFlag_","_SearchDiagnosTypeStr_","_Opener
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	;门诊默认诊断类型
    s OPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","OP",0))
    ;住院默认诊断类型
    s IPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","PRE",0))
    //s NotEntryNoICDDiag=1 //是否允许录入非ICD诊断
	s ShowDiagOtherInfo=1 //控制是否显示诊断其他信息框
	if (PAAdmType="I") {
		s ShowDiagOtherInfo=0
		s DedfaultDiagnosTypeID=IPDedfaultDiagnosTypeID
		i OutDisFlag="1" {
			//出院诊断id
			s DISDiagnosTypeRowId=$O(^MRC("DTYP",0,"Code","DIS",0))
			s DedfaultDiagnosTypeID=DISDiagnosTypeRowId
		}
		s DiagDelLimitFlag=+..%GetConfig("IPDiagDelLimit",CurLogonHosp) 
		//s NotEntryNoICDDiag=+..%GetConfig("IPNotEntryNoICDDiag",CurLogonHosp) 
	}else{
		s DedfaultDiagnosTypeID=OPDedfaultDiagnosTypeID
		s DiagDelLimitFlag=+..%GetConfig("OPDiagDelLimit",CurLogonHosp) 
		//s NotEntryNoICDDiag=+..%GetConfig("OPNotEntryNoICDDiag",CurLogonHosp) 
	}
	s DiagOtherInfo=##class(web.DHCDocDiagnosEntryV8).GetDiagOtherInfo(EpisodeID)
	//分床日期
	s AdmBedInfo=##Class(EMRservice.DAL.GetPaAdmDetail).AdmDateTimeInBed(EpisodeID)
	s AdmBedDate=$p(AdmBedInfo,",",1)
	s AdmBedDate=..%ZD(AdmBedDate)
	/*s DiagnosTypeStr=##class(DHCDoc.OPDoc.DiagnosEntryListCommon).GetDiagnosTypeStr(PAAdmType,"",SearchDiagnosTypeStr)
	s DiagnosTypeJson=##class(DHCDoc.OPDoc.DiagnosEntryListCommon).GetDiagnosTypeStr(PAAdmType,"JSON",SearchDiagnosTypeStr)
	if ((";"_DiagnosTypeStr)'[(";"_DedfaultDiagnosTypeID_":")){
	 	s DedfaultDiagnosTypeID=$P(DiagnosTypeStr,":",1)
	 	s DedfaultDiagnosTypeCode=$P($g(^MRC("DTYP",DedfaultDiagnosTypeID)),"^",1)
	}
	s DiagnosTypeCodeStr=""
	for i=1:1:$l(DiagnosTypeStr,";"){
		 s id=$p($p(DiagnosTypeStr,";",i),":",1)
		 s code=$P($g(^MRC("DTYP",id)),"^",1)
		 i DiagnosTypeCodeStr="" s DiagnosTypeCodeStr=code
		 e  s DiagnosTypeCodeStr=DiagnosTypeCodeStr_","_code
    }*/
	
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s SexId=$P($G(^PAPER(PatientID,"ALL")),"^",7)
	s PatSex=$p($g(^CT("SEX",SexId)),"^",2)
	;是否需要录入血压
	s NeedStolicMast=0
	s NeedStolicMastAge=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(%session.Get("LOGON.CTLOCID"),12)
	if (NeedStolicMastAge'="") {
		s NeedStolicMastAge=+NeedStolicMastAge
		s age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,"",CurLogonHosp)
		if ((age["岁")||(age["Years Old")) s age=+age
		else  s age=0
		if (age>=NeedStolicMastAge) s NeedStolicMast=1
	}
	;长效诊断数量
	s PALongICDCount=##class(web.DHCDocDiagnosEntryV8).GetPALongICDCount(EpisodeID)
 	s JsonData={}
	do JsonData.%Set("EpisodeID",EpisodeID)
	do JsonData.%Set("PatientID",PatientID)
	do JsonData.%Set("mradm",mradm)
	do JsonData.%Set("PAAdmType",PAAdmType)
	do JsonData.%Set("DiagOtherInfo",DiagOtherInfo)
	//do JsonData.%Set("DiagnosTypeStr",DiagnosTypeStr)
	//do JsonData.%Set("DiagnosTypeJson",DiagnosTypeJson)
	do JsonData.%Set("AdmBedDate",AdmBedDate)
	do JsonData.%Set("DiagDelLimitFlag",DiagDelLimitFlag)
	do JsonData.%Set("DedfaultDiagnosTypeID",DedfaultDiagnosTypeID)
	do JsonData.%Set("SearchDiagnosTypeStr",SearchDiagnosTypeStr)
	do JsonData.%Set("Opener",Opener)
	//do JsonData.%Set("NotEntryNoICDDiag",NotEntryNoICDDiag)
	do JsonData.%Set("PatSex",PatSex)
	do JsonData.%Set("NeedStolicMast",NeedStolicMast)
	do JsonData.%Set("PALongICDCount",PALongICDCount)
	Q JsonData.%ToJSON()
}

}
