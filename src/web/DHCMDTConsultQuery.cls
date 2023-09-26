Import sqluser

/// Creator: 	  bianshuai
/// CreateDate:   2019-04-16
/// Descript: 	  mdt会诊查询类
Class web.DHCMDTConsultQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	  bianshuai
/// CreateDate:   2019-04-16
/// Descript:	  获取病人基本就诊信息
/// W ##Class(web.DHCMDTConsultQuery).GetPatEssInfo("","27233504")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatSexCH=PatSex
	s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##Class(web.DHCMDTCom).DateLogicalToHtml(PatBDay)
	//s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) /// 年龄
	//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s PatDiagDesc=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)
	s PatDiagDescAll=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y") ;##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)
	;s PatDiagDesc = $tr(PatDiagDesc,"&nbsp"," ")
	;s PatDiagDescAll="" //hxy 2020-05-06 st
	;i $L(PatDiagDesc)>80 s PatDiagDescAll=PatDiagDesc //ed
	;i $L(PatDiagDesc)>80 s PatDiagDesc=$E(PatDiagDesc,1,50)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo="" //##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	  /// 就诊类型
	//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
	s BillType=##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason(EpisodeID)    /// 费别
	s HISUIStyleCode=##class(websys.StandardTypeItem).GetIdFromCodeOrDescription("websys","HISUIDefVersion")
	s imgName=$CASE(PatSexCH,"女":"woman","男":"man",:"unman") 
	if (HISUIStyleCode="lite"){
		s imgName=imgName_"_lite"
	}
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSexCH_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_BillType_"^"_PatDiagDescAll_"^"_imgName
	
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSexCH^PatSex^PatAge^PatBDay^PatDiagDesc^PatType^PatSLv^PatLv^mradm^PatBed^PatBill^PatDiagDescAll^imgName"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-04-16
/// Descript:     取会诊申请数据
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtObj("106")
ClassMethod JsGetMdtObj(ID, IsInterface = "") As %String
{
	n (ID,IsInterface,%session)
	Q:'$D(^DHCMDTCON(ID)) ""
	s EpisodeID=$p(^DHCMDTCON(ID),"^",1)      /// 就诊ID
	s PatientID = $p(^PAADM(EpisodeID),"^",1) ///患者ID	
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    /// 病人姓名
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)      /// 姓别
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	;s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID)  /// 年龄 //hxy 2020-06-15 st
	s PatAge=##class(web.DHCMDTCom).GetPapmiAge(EpisodeID)  /// 年龄 //ed
	//s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	s Birthday=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	i Birthday'="" s Birthday=$zd(Birthday,3)
	s IdentNo=$p(^PAPER(PatientID,"ALL"),"^",9)         /// 身份证号
	s NationDr=$p($g(^PAPER(PatientID,"PER",2)),"^",1)  /// 民族
	s CountryDr=$p(^PAPER(PatientID,"PER",1),"^",8) 	/// 国家
	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s Address=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
#;	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
#;	s:BillType'="" PatBill=$p(^CT("SS",BillType),"^",2)
	s PatBill=##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason(EpisodeID)    /// 费别
	s PatCardNo=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	s:CardNoID'="" PatCardNo=$p($g(^DHCCARD("CF",PatientID)),"^",2)         /// 卡号
	s MedicalNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)       /// 病案号
	//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	s PatDiagDesc=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	s PostCode=""
	s PatType=$p(^PAADM(EpisodeID),"^",2)     /// 就诊类型
	s CstRLocID=$p(^DHCMDTCON(ID),"^",2)      /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	s CsHospID=$p(^CTLOC(CstRLocID),"^",22)  /// 医院ID
	s CstRDate=$p(^DHCMDTCON(ID),"^",3)      /// 申请日期
	s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	s CstRTime=$p(^DHCMDTCON(ID),"^",4)      /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCMDTCON(ID),"^",5)    /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	s PreDate="",PreTime=""
	s PreTime = ##Class(web.DHCMDTCom).GetPreDateInfo(ID) ///预约时间
	s PreDate = $p(PreTime,"^",1)
	s PreTimeRange = $p(PreTime,"^",2)
	s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	s PrvID=$p($g(^RB("RES",RBResID)),"^",2)
	s PrvDesc="",PrvLoc=""
	s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	s:PrvLocID'="" PrvLoc=$p(^CTLOC(PrvLocID),"^",2)
	s DisProcess=##Class(web.DHCMDTConsultQuery).JsGetCsOpinion(ID) ;$p(^DHCMDTCON(ID),"^",23)    /// 会诊讨论内容
	s suppnotes=$p(^DHCMDTCON(ID),"^",25)     /// 补充内容
	s CstStatus=$p(^DHCMDTCON(ID),"^",12)     /// 状态ID
	s:CstStatus'="" CstStatus=$P(^DHCMDTS(CstStatus),"^",2)
	s IsPerAccFlag="" //##Class(web.DHCEMConsult).IsPermitAccept(ID) /// 是否允许接受申请单
	s isOpiEditFlag="" //..GetOpiEditFlag(ItmID)    /// 会诊结论是可编辑
	s MCTimes=$p(^DHCMDTCON(ID),"^",22)    	/// 患者第几次会诊次数
	s TumStage=$p(^DHCMDTCON(ID),"^",27) 	///肿瘤状态
	s DisGroup = ##Class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2022-12-08
	s PrvDesc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("CareProv","",PrvDesc) //hxy 2022-12-08
	s CstNPlace=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDConsAddress","",CstNPlace) //hxy 2022-12-08 此处可不加
	
    s ListData=EpisodeID_"^"_PatType_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    s ListData=ListData_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_TreMeasures_"^"_DisGrpID_"^"_DisGroup_"^"_PrvDesc_"^"_isOpiEditFlag_"^"_CstStatus_"^"_CsHospID_"^"_IsPerAccFlag
	s ListData=ListData_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_Birthday_"^"_PatCardNo_"^"_MedicalNo_"^"_PatTelH_"^"_PostCode_"^"_Address_"^"_PreDate_"^"_PreTimeRange_"^"_PatDiagDesc
	s ListData=ListData_"^"_DisProcess_"^"_MCTimes_"^"_PatNo_"^"_PatBill_"^"_suppnotes_"^"_RBResID_"^"_TumStage
	q:IsInterface ListData
	s ListTitle="EpisodeID^PatType^CstRLocID^CstRLoc^CstRDate^CstRTime^CstUserID^CstRUser^mdtTrePro^mdtPurpose^CstNDate^CstNTime"
	s ListTitle=ListTitle_"^CstNPlace^CstUser^CstPhone^TreMeasures^DisGrpID^DisGroup^PrvDesc^isOpiEditFlag^CstStatus^CsHospID^IsPerAccFlag"
	s ListTitle=ListTitle_"^PatName^PatSex^PatAge^Birthday^PatCardNo^MedicalNo^PatTelH^PostCode^Address^PreDate^PreTimeRange^PatDiagDesc"
	s ListTitle=ListTitle_"^DisProcess^MCTimes^PatNo^PatBill^suppnotes^RBResID^TumStage"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtAudit("30","1","^^^^^^^^^")
ClassMethod JsGetMdtAudit(rows As %String, page As %String, Params As %String, LgParams = "") As %String
{
	n (rows,page,Params,LgParams,%session)
    
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s LgHospID=$p(LgParams,"^",1)
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-7
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgLocID=$p(Params,"^",3)    /// 请会诊科室
	s ArgPatNo=$p(Params,"^",4)    /// 登记号
	s ArgDisGrp=$p(Params,"^",5)   /// 疑难病种
	s ConsStatus=$p(Params,"^",6)  /// 会诊状态
	s ShowModel=$p(Params,"^",7)   /// 显示内容：1(本人发送) 2(本人接收) 其他：查询所有
	s LgUserID=$p(Params,"^",8)    /// 登录用户ID
	s ArgPatName = $p(Params,"^",9) /// 病人姓名
	s ChargeFlag=$p(Params,"^",10)  /// 收费状态
	s ConsStatus=$p(Params,"^",11)  /// 会诊状态
	s QryType=$p(Params,"^",12)     /// 查询类型
	s IndexNode=$s(QryType=2:"NDate",1:"ReqDateIndex")
	
	s IsCstUserNum=0,IsCsUserNum=0  /// 本人申请数和申请本人数
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,IndexNode,dd,ID)) Q:ID=""  D
	..s IsCstUser = "",IsCsUser=""
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..Q:(ArgPatName'="")&(PatName'[ArgPatName)
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(ArgPatNo'="")&(ArgPatNo'=PatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	..//s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ..//s PatBed=##Class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
   	..s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	..i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	..//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	..s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..Q:(ArgLocID'="")&(ArgLocID'=CstRLocID)
	..s HospitalID=$p(^CTLOC(CstRLocID),"^",22)
	..q:(LgHospID'="")&&(LgHospID'=HospitalID)  ///多院区过滤
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s:LgUserID=CstRUserID IsCstUser=1
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	..s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID 
	..s IDS="" ,CHS="" ,MakResDate=""
	..i AppScDr'="" s IDS=+AppScDr, CHS=$p(AppScDr,"||",2)
	..i IDS'="" s MakResDate=$p($g(^RBAS(IDS,CHS)),"^",1) /// 预约日期
	..s prtime=$p($h,",",1) //当前日期
	..//s:AppScDr'="" PreTime =$p(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"^",1)
	..//s:PreTime'="" PreTime=##Class(web.DHCMDTCom).DateLogicalToHtml(PreTime)
	..s PreTime=""
	..s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) /// 预约时间
	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	..s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	..s CstStatus=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:CstStatus=""
	..q:(ConsStatus'="")&&(ConsStatus'=CstStatus)
	..s CstStatusCode=$P(^DHCMDTS(CstStatus),"^",1)
	..s:CstStatus'="" CstStatus=$P(^DHCMDTS(CstStatus),"^",2)
	..;q:(ConsStatus="")&&(CstStatus="撤销")
	..//q:CstStatus="撤销"
	..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	..s McNotes=$p(^DHCMDTCON(ID),"^",24)     /// 备注yzy
	..s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..q:'$d(^DHCMDTG(DisGrpID))
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	..s mdtMakResID=$p(^DHCMDTCON(ID),"^",18)   /// 预约资源ID
	..s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	..s PrvID=$p($g(^RB("RES",+RBResID)),"^",2)
	..s PrvDesc="",PrvLoc=""
	..s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	..s:PrvLocID'="" PrvLoc=$p($g(^CTLOC(PrvLocID)),"^",2)
	..s AppAdmID = $p(^DHCMDTCON(ID),"^",20)
	..s LgNode=##Class(web.DHCMDTCom).GetCsNodeTime(ID,"80") 
	..s CstCUser=$p(LgNode,"^",2)   	/// 完成医师
	..s:CstStatusCode<80 CstCUser=""	/// 完成状态之前的完成医生为空
	..s CstPrvArr="",CstLocArr=""
	..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	...s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	...s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	...i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	...s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s:(+CsUserID'=0)&&(CsUserID=LgUserID) IsCsUser=1            /// 当前登录人是否会诊医师
	...s:+CsUserID=0 IsCsUser=+##Class(web.DHCMDTCom).IsHasLgUser(CsLocID,PrvTpID,LgUserID)
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	...s CsLocDesc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CsLocDesc)
	...s CsUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CsUser)
	...s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	...s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
	..s:PayMony=1 PayMony="Y" //"已收费"
	..s:PayMony=0 PayMony="N" //"未收费"
	..Q:(ChargeFlag'="")&(ChargeFlag="Y")&(PayMony="N") //"未收费"
	..Q:(ChargeFlag'="")&(ChargeFlag="N")&(PayMony="Y") //"已收费"
	..s:IsCstUser=1 IsCstUserNum=IsCstUserNum+1
	..s:IsCsUser=1 IsCsUserNum=IsCsUserNum+1
	..q:(ShowModel=1)&&(IsCstUser'=1)    ///本人发送
	..q:(ShowModel=2)&&(IsCsUser'=1)     ///本人接收
	..s OutHospConsDoc=##Class(web.DHCMDTConsultQuery).GetOutHospConsDoc(ID)
	..s PayMony = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.OTHER","OTHER","",PayMony)
	..s DisGroup = ##Class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2023-01-11 st
	..s CstStatus=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTConsStatus","MDDesc","",CstStatus)
	..s PrvDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",PrvDesc)
	..s CstCUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.SSUser","SSUSRName","",CstCUser) //ed
	..s Num=Num+1
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	..s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_CstLocArr_"^"_CstPrvArr_"^"_PrintFlag_"^"_DisGrpID_"^"_DisGroup_"^"_PrvDesc
	..s ListData=ListData_"^"_CstStatus_"^"_PayMony_"^"_PreTime_"^"_PatientID_"^"_AppAdmID_"^"_mdtMakResID_"^"_MakResDate_"^"_prtime_"^"_McNotes_"^"_MedicareNo_"^"_PatTelH_"^"_CstCUser
	..s ListData=ListData_"^"_OutHospConsDoc
	..s TMPListData(Num)=ListData
	..
	
	///转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUserID"
	s ListTitle=ListTitle_"^CstRUser^CstTrePro^CstPurpose^CstNDate^CstNTime^CstNPlace^CstUser^CstPhone^CstLocArr^CstPrvArr^PrintFlag^DisGrpID^DisGroup^PrvDesc"
	s ListTitle=ListTitle_"^CstStatus^PayMony^PreTime^PatientID^AppAdmID^mdtMakResID^MakResDate^prtime^McNotes^MedicareNo^PatTelH^CstCUser^OutHospConsDoc"
	s Del=""""
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	W ","
	w Del_"IsCsUserNum"_Del_":"_IsCsUserNum
	W ","
	w Del_"IsCstUserNum"_Del_":"_IsCstUserNum
	w "}"
	Q ""
}

/// Descript:取会诊申请明细内容
/// w ##Class(web.DHCMDTConsultQuery).JsonQryConsult("14","","","","I")
ClassMethod JsonQryConsult(ID As %String, GrpID As %String, QueFlg As %String = "", Params As %String, Type As %String, IsQry = "", TmpArr = "") As %String
{
	n (ID, GrpID, QueFlg, Params, Type, IsQry, TmpArr,%session)
	k TMPPisSpecArr
	/// 会诊院内专家列表
	s CH="",Num=0
	i (ID'="")&(Params="")&(Type'="E") D
	.s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)          /// 科室ID
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..s CareProv=""
	..s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	..s:CareProvID'="" CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	..s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	..s PrvTpID="",PrvTp=""
	..s PrvTpID=+$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	..i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	..s SubMarID=$p(^DHCMDTCON(ID,"I",CH),"^",13)      /// 亚专业
	..s SubMar=$p($g(^DHCMDTCON(+SubMarID)),"^",2)
	..s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	..i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	..s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(ID_"||"_CH)
	..s ConssignInDateTime=##class(web.DHCMDTCom).UserIsConssignInDateTime(ID_"||"_CH)
	..s CsDocRes=##Class(web.DHCMDTConsult).GetCsDocRes(ID_"||"_CH,CsUserID) /// 取会诊医生的操作内容
	..s Opinion=$p($g(^DHCMDTCON(ID,"I",CH)),"^",6)
	..s HasOpinion=(Opinion'="")
	..i +CsDocRes=1 s AcceptFlag=1,RefReason=""
	..E  s AcceptFlag=0,RefReason=$p(CsDocRes,"^",2)
	..s HosID="I", HosType="组内"
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..i +CsUserID'=0 D
	...i '$d(^DHCMDTG(0,"User",+CsUserID,DisGrpID)) s HosID="O", HosType="院内"
	..E  D
	...i ..isTakLocGroupRel(DisGrpID, LocID)=0 s HosID="O", HosType="院内"
	..Q:(Type'="")&(Type'=HosID)
	..s LocDesc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",LocDesc)
	..s CareProv = ##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CareProv)
	..s PrvTp = ##class(web.DHCMDTCom).GetMulLanTrsDesc("PrvTp","",PrvTp) //hxy 2022-12-08
	..s IsCaed = ##Class(web.DHCMDTSignVerify).IsgetsignmdtSIGNID(ID_"||"_CH)
	..s CaImage = ""
	..s:IsCaed=1 CaImage=##class(CA.BICAService).GetImageByUserID(CsUserID)
	..s ConssignInDateTime=##class(web.DHCMDTCom).UserIsConssignInDateTime(ID_"||"_CH)
	..s IsContact=##class(web.DHCMDTCom).LgUserIsContact(DisGrpID, CsUserID)	;当前登录人是不是这个病种的联络人
	..s AssUser=""
	..s ListData=ID_"||"_CH_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_SubMarID_"^"_SubMar_"^"_TelPhone_"^"_HosType_"^"_HosID_"^"_IsConssignIn_"^"_AcceptFlag_"^"_RefReason_"^"_HasOpinion_"^"_CsUserID_"^"_ConssignInDateTime
	..s ListData=ListData_"^"_IsContact_""_AssUser_"^"_CaImage
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData
	..s:IsQry TmpArr(Num)=ListData
	
	/// 会诊外院专家列表
	i (ID'="")&(Params="")&(Type="E") D
	.s CsExpID="0"
	.F  s CsExpID=$o(^DHCMDTCOE(0,"ParRef",ID,CsExpID)) Q:CsExpID=""  D
	..s userID=$p(^DHCMDTCOE(CsExpID),"^",2)
	..s AssUserId = $p(^DHCMDTCOE(CsExpID),"^",4)
	..Q:userID=""
	..s AssUserCode="",AssUserName="",AssUser=""
	..i AssUserId'="" d
	...s AssUserCode= $p(^SSU("SSUSR",AssUserId),"^",1)
	...s AssUserName= $p(^SSU("SSUSR",AssUserId),"^",2)
	...s AssUser=AssUserName
	..q:'$d(^DHCMDTOUTEXP(userID))
	..s userName=$p(^DHCMDTOUTEXP(userID),"^",2)   /// 姓名
	..s PrvTpID=$p(^DHCMDTOUTEXP(userID),"^",4)    /// 职称
	..s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	..s LocID=$p(^DHCMDTOUTEXP(userID),"^",6)      /// 科室ID
	..s LocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	..s TelPhone=$p(^DHCMDTOUTEXP(userID),"^",7)   /// 电话
	..s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)      /// 外院
	..Q:ParID=""
	..s HospDesc=$p(^DHCMDTDI(ParID),"^",2)        /// 外院\
	..
	..s:HospDesc'="" LocDesc=HospDesc_"-"_LocDesc
	..
	..s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(CsExpID)
	..s ConssignInDateTime=##class(web.DHCMDTCom).UserIsConssignInDateTime(CsExpID)
	..s CsDocRes=##Class(web.DHCMDTConsult).GetCsDocRes(CsExpID,userID) /// 取会诊医生的操作内容
	..i +CsDocRes=1 s AcceptFlag=1,RefReason=""
	..E  s AcceptFlag=0,RefReason=$p(CsDocRes,"^",2)
	..s HasOpinion="",CsUserID="",IsContact="",CaImage=""
	..s ListData=CsExpID_"^"_LocID_"^"_LocDesc_" - "_HospDesc_"^"_userID_"^"_userName_"^"_PrvTpID_"^"_PrvTp_"^"_""_"^"_""_"^"_TelPhone_"^"_""_"^"_""_"^"_IsConssignIn_"^"_AcceptFlag_"^"_RefReason_"^"_HasOpinion_"^"_CsUserID_"^"_ConssignInDateTime
	..s ListData=ListData_"^"_IsContact_"^"_AssUser_"^"_CaImage
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData
	..s:IsQry TmpArr(Num)=ListData
	
	k TmpExiArr

	i GrpID'="" D
	.s CH=""
	.F  s CH=$o(^DHCMDTG(GrpID,"I",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCMDTG(GrpID,"I",CH),"^",1)      /// 科室ID
	..;Q:$D(TmpExiArr(LocID))   /// 相同科室只加载一次
	..;s TmpExiArr(LocID)=""
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..s CareProvID="",CareProv="",PrvTpID="",PrvTp="",TelPhone=""
	..s userID=$p(^DHCMDTG(GrpID,"I",CH),"^",2)     /// 医生
	..s PrvTpID=$p(^DHCMDTG(GrpID,"I",CH),"^",4)    ///职称Id
	..s:PrvTpID'="" PrvTp=$p(^CT("CPT",PrvTpID),"^",2) 
	..;s Opinion=$p($g(^DHCMDTCON(ID,"I",CH)),"^",6)
	..s HasOpinion="",CsUserID=""
	..i userID'="" D
	...s CareProvID=$p(^SSU("SSUSR",userID),"^",14)
	...s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	...s PrvTpID=+$p(^CTPCP(CareProvID,1),"^",4)       /// 职称
	...i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	...s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	...i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	..s LocDesc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",LocDesc)
	..s CareProv = ##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CareProv)
	..s PrvTp = ##class(web.DHCMDTCom).GetMulLanTrsDesc("PrvTp","",PrvTp)
	..s CaImage="",ConssignInDateTime="",IsContact="",AssUser=""
	..;itmID^LocID^LocDesc^UserID^UserName^PrvTpID^PrvTp^MarID^MarDesc^TelPhone^HosType^HosID^IsConssignIn^AcceptFlag^RefReason^HasOpinion^CsUserID^ConssignInDateTime
	..s ListData=""_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_""_"^"_""_"^"_TelPhone_"^组内^I"_"^"_HasOpinion_"^"_CsUserID
	..s ListData=ListData_"^"_ConssignInDateTime_"^"_IsContact_"^"_AssUser_"^"_CaImage
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData
	..s:IsQry TmpArr(Num)=ListData
	
	/// 院内科室
	i (Params'="")&(Type'="E") D
	.F i=1:1:$L(Params,"#") D
	..s ListData=$p(Params,"#",i)  /// 科室列表
	..s LocID=$p(ListData,"^",1)   /// 科室ID
	..s CareProvID=$p(ListData,"^",2)  /// 用户ID
	..s itmID=$p(ListData,"^",3)  /// ID
	..s:LocID'="" LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..s CareProv="",PrvTp=""
	..//s CareProvID=$p(^SSU("SSUSR",userID),"^",14)
	..s MdtConsUserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	..s PrvTpID=+$p(^CTPCP(CareProvID,1),"^",4)          /// 职称
	..i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	..s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	..i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	..s LocDesc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",LocDesc)
	..s CareProv = ##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CareProv)
	..s PrvTp = ##class(web.DHCMDTCom).GetMulLanTrsDesc("PrvTp","",PrvTp)
	..s IsCaed = ##Class(web.DHCMDTSignVerify).IsgetsignmdtSIGNID(itmID)
	..s CaImage = ""
	..s:IsCaed=1 CaImage=##class(CA.BICAService).GetImageByUserID(MdtConsUserID)
	..s HosType="",HosID="",IsConssignIn="",AcceptFlag="",RefReason="",HasOpinion="",CsUserID="",ConssignInDateTime="",IsContact="",AssUser="",CaImage=""
	..s ListData=itmID_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_""_"^"_""_"^"_TelPhone_"^"_HosType_"^"_HosID_"^"_IsConssignIn_"^"_AcceptFlag_"^"_RefReason_"^"_HasOpinion_"^"_CsUserID_"^"_ConssignInDateTime
	..s ListData=ListData_"^"_IsContact_""_AssUser_"^"_CaImage
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData
	..s:IsQry TmpArr(Num)=ListData
	
	/// 外院专家
	i (Params'="")&(Type="E") D
	.F i=1:1:$L(Params,"#") D
	..s ListData=$p(Params,"#",i)  /// 科室列表
	..s expID=$p(ListData,"^",2)   /// 用户ID
	..s userName=$p(^DHCMDTOUTEXP(expID),"^",2)   /// 姓名
	..s PrvTpID=$p(^DHCMDTOUTEXP(expID),"^",4)    /// 职称
	..s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	..s LocID=$p(^DHCMDTOUTEXP(expID),"^",6)      /// 科室ID
	..s LocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	..s TelPhone=$p(^DHCMDTOUTEXP(expID),"^",7)   /// 电话
	..s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)     /// 外院
	..s HospDesc=$p(^DHCMDTDI(ParID),"^",2)
	..s:HospDesc'="" LocDesc=HospDesc_"-"_LocDesc
	..s PrvTp = ##class(web.DHCMDTCom).GetMulLanTrsDesc("PrvTp","",PrvTp)
	..s HosType="",HosID="",IsConssignIn="",AcceptFlag="",RefReason="",HasOpinion="",CsUserID="",ConssignInDateTime="",IsContact="",AssUser="",CaImage=""
	..s ListData=""_"^"_LocID_"^"_LocDesc_"^"_expID_"^"_userName_"^"_PrvTpID_"^"_PrvTp_"^"_""_"^"_""_"^"_TelPhone_"^"_HosType_"^"_HosID_"^"_IsConssignIn_"^"_AcceptFlag_"^"_RefReason_"^"_HasOpinion_"^"_CsUserID_"^"_ConssignInDateTime
	..s ListData=ListData_"^"_IsContact_""_AssUser_"^"_CaImage
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData
	..s:IsQry TmpArr(Num)=ListData
	q:IsQry ""
	
	i +QueFlg'=1 d
	.i 2>Num d
	..s Len=2-Num
	..f i=1:1:Len d
	...s Num=Num+1
	...s TMPPisSpecArr("Z"_i)=""

	s ListTitle="itmID^LocID^LocDesc^UserID^UserName^PrvTpID^PrvTp^MarID^MarDesc^TelPhone^HosType^HosID^IsConssignIn^AcceptFlag^RefReason^HasOpinion^CsUserID^ConssignInDateTime"
	s ListTitle=ListTitle_"^IsContact^AssUser^CaImage"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TMPPisSpecArr(index)) Q:index=""  D
	.s ListData=$g(TMPPisSpecArr(index))
	.//Q:ListData=""
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   修改专家查询功能:牵扯日志表
/// InPut:      
/// OutPut:     
/// w ##Class(web.DHCMDTConsultQuery).ListDocList("152")
ClassMethod ListDocList(ID As %String) As %String
{
	n (ID)

	k TmpArr
	s Num=0
	s CH=0
	f  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  d
	.s LocDesc=""
	.s LocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)          /// 科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s CareProv=""
	.s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s PrvTpID="",PrvTp=""
	.s PrvTpID=+$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	.i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s SubMarID=$p(^DHCMDTCON(ID,"I",CH),"^",13)      /// 亚专业
	.s SubMar=$p($g(^DHCMDTCON(+SubMarID)),"^",2)
	.s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	.i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	.s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(ID_"||"_CH)
	.s CsDocRes=##Class(web.DHCMDTConsult).GetCsDocRes(ID_"||"_CH,CsUserID) /// 取会诊医生的操作内容
	.s Opinion=$p($g(^DHCMDTCON(ID,"I",CH)),"^",6)
	.s HasOpinion=(Opinion'="")
	.i +CsDocRes=1 s AcceptFlag=1,RefReason=""
	.e  s AcceptFlag=0,RefReason=$p(CsDocRes,"^",2)
	.s HosID="I", HosType="组内"
	.s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	.s ListData=ID_"||"_CH_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_SubMarID_"^"_SubMar_"^"_TelPhone_"^"_HosType_"^"_HosID_"^"_IsConssignIn_"^"_AcceptFlag_"^"_RefReason_"^"_HasOpinion_"^"_CsUserID
	.s Num=Num+1
	.s TmpArr(Num)=ListData

	s ListTitle="itmID^LocID^LocDesc^UserID^UserName^PrvTpID^PrvTp^MarID^MarDesc^TelPhone^HosType^HosID^IsConssignIn^AcceptFlag^RefReason^HasOpinion^CsUserID"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   取科室电话
/// InPut:      LocID - 科室ID
/// OutPut:     电话号码
/// w ##Class(web.DHCMDTConsultQuery).GetLocTelPhone("6") 
ClassMethod GetLocTelPhone(LocID As %String) As %String
{
	n (LocID)
	Q:'$d(^CTLOC(+LocID)) ""
	s TelPhone=$p($g(^CTLOC(+LocID)),"^",40)               /// 科室电话
	Q TelPhone
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   取医生电话
/// InPut:      LocID - 科室ID
/// OutPut:     电话号码
/// w ##Class(web.DHCMDTConsultQuery).GetCareProvPhone("1802")
ClassMethod GetCareProvPhone(CareProvID As %String) As %String
{
	n (CareProvID)
    Q:'$d(^CTPCP(+CareProvID,2)) ""
	s TelPhone=$p($g(^CTPCP(+CareProvID,2)),"^",1)    /// 会诊医生电话
	Q TelPhone
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   取页面按钮设置标志值
/// w ##Class(web.DHCMDTConsultQuery).GetCstPageBtFlag("1")
ClassMethod GetCstPageBtFlag(CstID As %String, LgUserID As %String, LgLocID As %String) As %String
{
	n (CstID, LgUserID, LgLocID)
	s CstUserID=$p(^DHCMDTCON(CstID),"^",5)      /// 申请医生
	s CstStatusID=$p(^DHCMDTCON(CstID),"^",12)   /// 申请状态
	Q:(LgUserID=CstUserID)&(CstStatusID="") "1"  /// 未发送
	Q:(LgUserID=CstUserID)&(CstStatusID'="") "2" /// 已发生
	s CH="",QuitFlag=0
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:(CH="")||(QuitFlag'=0)  D
	.s UserID=""
	.s CareProvID=$p(^DHCMDTCON(CstID,"I",CH),"^",2)     /// 医生
	.i CareProvID'="" D
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	.s CsLocID=$p(^DHCMDTCON(CstID,"I",CH),"^",1)        /// 会诊科室
	.Q:(LgUserID'=UserID)&(LgLocID'=CsLocID)
	.s QuitFlag=1
	.
	Q:QuitFlag=1 "3"
	Q "4"
}

/// Creator:    qqa
/// CreateDate: 2019-05-06
/// Descript:   Print会诊申请打印函数
/// InPut:      CstID-会诊申请表ID
/// OutPut:     会诊申请打印内容
/// w ##Class(web.DHCMDTConsultQuery).GetMdtConsPrintCon("57")
ClassMethod GetMdtConsPrintCon(CstID As %String) As %String
{
	n (CstID,%session)	
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",1)		/// 就诊ID
	s PatientID=$p(^DHCMDTCON(CstID),"^",26)	/// 病人ID
	//s PatientID=$p(^PAADM(EpisodeID),"^",1)   /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatCardNo=""
	s CardNoID=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	i CardNoID'="" d
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 		/// 卡号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	s PatLoc=""
	s PatLocID=$p($g(^PAADM(+EpisodeID)),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	s PatWard=""
	s PatWardID=$p($g(^PAADM(+EpisodeID)),"^",70) 	         /// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
   	//s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)
   	s PatBed=$p($g(^PAADM(+EpisodeID)),"^",73) 		      /// 床号
	i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
   	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  ///病案号
	//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	;s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s PatDiagDesc=##class(web.DHCDocInPatientList).GetMRAdmDiagnosis(mradm)
	/// 申请单内容
	s CstRLocID=$p(^DHCMDTCON(CstID),"^",2)   /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	s CstRDate=$p(^DHCMDTCON(CstID),"^",3)    /// 申请日期
	s CstRDate=##class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)	
	s CstRTime=$p(^DHCMDTCON(CstID),"^",4)    /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCMDTCON(CstID),"^",5)   /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
    s CstTrePro=$p(^DHCMDTCON(CstID),"^",6)   /// 病情及诊疗经过
	s CstPurpose=$p(^DHCMDTCON(CstID),"^",7)  /// 会诊的理由和目的
	s CstNDate=$p(^DHCMDTCON(CstID),"^",8)    /// 会诊日期
	s CstNDate=##class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)	
	s CstNTime=$p(^DHCMDTCON(CstID),"^",9)   /// 会诊时间
	s PreDate = ##Class(web.DHCMDTCom).GetPreDate(CstID)  //预约日期
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCMDTCON(CstID),"^",10)   /// 会诊地点
	s CstOpinion=$p(^DHCMDTCON(CstID),"^",11)  /// 会诊意见
	s CstEmFlag=$p(^DHCMDTCON(CstID),"^",23)   /// 是否加急
	s CstOutFlag=$p(^DHCMDTCON(CstID),"^",24)  /// 是否院外
	s CstUnit=$p(^DHCMDTCON(CstID),"^",25)     /// 外院名称
	s CstDocName=$p(^DHCMDTCON(CstID),"^",26)  /// 外院医师
	s CstRemark=$p(^DHCMDTCON(CstID),"^",27)   /// 备注
	s CstUser=$p(^DHCMDTCON(CstID),"^",28)     /// 联系人
	s CstPhone="",OneOrMore="",MedcalTangle="",CurQuestion =""
	s MedcalTangle="",CstCstType="",TreMeasures=""
	s CsLocDescS =##Class(web.DHCMDTCom).GetConsultLocs(CstID)
	s DisGrpID=$p(^DHCMDTCON(CstID),"^",16)    /// 疑难病种
	s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	s SignImage="" //##Class(web.DHCPUECommon).GetSignImg(UserID)
	s suppnotes=$p(^DHCMDTCON(CstID),"^",25)
	s RBResID=$p(^DHCMDTCON(CstID),"^",17)       /// 资源ID
	s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	s PrvID=$p($g(^RB("RES",RBResID)),"^",2)
	s PrvDesc="",PrvLoc=""
	s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	s:PrvLocID'="" PrvLoc=$p(^CTLOC(PrvLocID),"^",2)
	s AppScDr = $p(^DHCMDTCON(CstID),"^",18)   /// 资源表ID
	s PreTime=""
	s:AppScDr'="" PreTime =$p(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"^",1)
	s:PreTime'="" PreTime=##Class(web.DHCMDTCom).DateLogicalToHtml(PreTime)
	s mdtCsLocs=..GetMdtCsLocs(CstID)          /// 会诊科室列表
	s CsDataTimeRange=##Class(web.DHCMDTCom).JsMakResDateTime(AppScDr)
	s CsDataRange=$p(CsDataTimeRange,"^",1)    /// 日期
	s CsTimeRange=$p(CsDataTimeRange,"^",2)    /// 时间
	s TimeRange=$p(CsTimeRange," ",2)
	s Time=$p(CsTimeRange," ",1)_$p(TimeRange,"-",1)
	s CsTimeWeek=$p(CsDataTimeRange,"^",3)     /// 周几
	s CsDataRange=CsDataRange_"，"_CsTimeWeek
	s HospID=$p(^CTLOC(CstRLocID),"^",22)      /// 医院
	s HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
	s ConsPrice = ##Class(web.DHCMDTCom).GetConsPrice(CstID)
	s DisGroupNotes=$p(^DHCMDTG(DisGrpID),"^",6)
	s CsOpinion="",CsLocDesc="",CsUser="",PrvTp="",CstRPhone="",CstEcType="", AgreeFlag="",CstTypeDesc="",CstTypeDr=""
	s ListTitle="PatNo^PatCardNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUser^CstTrePro^CstPurpose"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^OneOrMore^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstCstType^CsLocDesc^CsUser^CsOpinion^ConsPrvTp"
	s ListTitle=ListTitle_"^MedcalTangle^CurQuestion^CsLocDescS^CstTypeDesc^CstRPhone^PreDate^DisGroup^PrvLoc^PrvDesc^PreTime^CstOpinion^mdtCsLocs^CsDataRange^CsTimeRange^Time^SignImage^suppnotes^HospDesc^ConsPrice^DisGroupNotes"
	s ListData=PatNo_"^"_PatCardNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_OneOrMore_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser
	s ListData=ListData_"^"_CstPhone_"^"_CstCstType_"^"_CsLocDesc_"^"_CsUser_"^"_CsOpinion_"^"_PrvTp_"^"_MedcalTangle_"^"_CurQuestion_"^"_CsLocDescS
	s ListData=ListData_"^"_CstTypeDesc_"^"_CstRPhone_"^"_PreDate_"^"_DisGroup_"^"_PrvLoc_"^"_PrvDesc_"^"_PreTime_"^"_CstOpinion_"^"_mdtCsLocs_"^"_CsDataRange_"^"_CsTimeRange_"^"_Time_"^"_SignImage_"^"_suppnotes_"^"_HospDesc 
	s ListData=ListData_"^"_ConsPrice_"^"_DisGroupNotes
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:   是否允许发送MDT申请
/// w ##Class(web.DHCMDTConsultQuery).isPermitTakMdt("22")
ClassMethod isPermitTakMdt(mParams As %String) As %String
{
	n (mParams)
	s LimitTime=57600  /// 限制时间点 下午4点
	Q:$p($H,",",2)>57600 1
	Q 0
}

/**ClassMethod JsGetMdtQuery(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-7
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgLocID=$p(Params,"^",3)    /// 请会诊科室
	s ArgPatNo=$p(Params,"^",4)    /// 登记号
	s ArgDisGrp=$p(Params,"^",5)   /// 疑难病种
	s ConsStatus=$p(Params,"^",6)  /// 会诊状态
	s ShowModel=$p(Params,"^",7)   /// 显示内容：1(本人发送) 2(本人接收) 其他：查询所有
	s LgUserID=$p(Params,"^",8)    /// 登录用户ID
	s ArgPatName = $p(Params,"^",9) /// 病人姓名
	s ChargeFlag=$p(Params,"^",10)  /// 收费状态
	s IsCstUserNum=0,IsCsUserNum=0  /// 本人申请数和申请本人数
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s IsCstUser = "",IsCsUser=""
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..Q:(ArgPatName'="")&(PatName'[ArgPatName)
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(ArgPatNo'="")&(ArgPatNo'=PatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..//s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	..s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ..//s PatBed=##Class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ..s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	..i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	..s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..Q:(ArgLocID'="")&(ArgLocID'=CstRLocID)
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s:LgUserID=CstRUserID IsCstUser=1
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	..s PreTime=""
	..s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID
	..s:AppScDr'="" PreTime =$p(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"^",1)
	..s:PreTime'="" PreTime=##Class(web.DHCMDTCom).DateLogicalToHtml(PreTime)
	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	..s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	..s CstStatusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..s CstStatus=""
	..q:(ConsStatus'="")&&(ConsStatus'=CstStatusID)
	..s:CstStatusID'="" CstStatus=$P(^DHCMDTS(CstStatusID),"^",2)
	..s CsStatCode=$p($g(^DHCMDTS(+CstStatusID)),"^",1) /// 状态代码
	..;q:(ConsStatus="")&&(CstStatus="撤销")
	..;q:CstStatus="撤销"
	..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	..s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p($g(^DHCMDTG(DisGrpID)),"^",2)
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	..s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	..s PrvID=$p($g(^RB("RES",+RBResID)),"^",2)
	..s PrvDesc="",PrvLoc=""
	..s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	..s:PrvLocID'="" PrvLoc=$p($g(^CTLOC(PrvLocID)),"^",2)
	..s AppAdmID = $p(^DHCMDTCON(ID),"^",20) 
	..s CstPrvArr="",CstLocArr=""
	..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p($g(^DHCMDTCON(ID,"I",CH)),"^",1)       /// 会诊科室
	...s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",2)
	...s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	...i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",3)
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	...s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s:(+CsUserID'=0)&&(CsUserID=LgUserID) IsCsUser=1            /// 当前登录人是否会诊医师
	...s:+CsUserID=0 IsCsUser=+##Class(web.DHCMDTCom).IsHasLgUser(CsLocID,PrvTpID,LgUserID)
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	...s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	...s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
	..s:PayMony=1 PayMony="已收费"
	..s:PayMony=0 PayMony="未收费"
	..Q:(ChargeFlag'="")&(ChargeFlag="Y")&(PayMony="未收费")
	..Q:(ChargeFlag'="")&(ChargeFlag="N")&(PayMony="已收费")
	..s:IsCstUser=1 IsCstUserNum=IsCstUserNum+1
	..s:(IsCsUser=1)&(PayMony="已收费") IsCsUserNum=IsCsUserNum+1
	..q:(ShowModel=1)&(IsCstUser'=1)    /// 本人发送
	..q:(ShowModel=2)&(IsCsUser'=1)     /// 本人接收
	..Q:(ShowModel=2)&((PayMony'="已收费")||(CsStatCode<30))     /// 本人会诊仅显示已安排并且已收费
	..i (ShowModel=2)&(##Class(web.DHCMDTConsult).GetCsAcceptFlag(ID, LgUserID)=1) s CstStatus="接收"
	
	..s Num=Num+1
	
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	..s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_CstLocArr_"^"_CstPrvArr_"^"_PrintFlag_"^"_DisGrpID_"^"_DisGroup_"^"_PrvDesc
	..s ListData=ListData_"^"_CstStatus_"^"_PayMony_"^"_PreTime_"^"_PatientID_"^"_AppAdmID
	..s TMPListData(Num)=ListData
	..
	..;b ;1
	///转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUserID"
	s ListTitle=ListTitle_"^CstRUser^CstTrePro^CstPurpose^CstNDate^CstNTime^CstNPlace^CstUser^CstPhone^CstLocArr^CstPrvArr^PrintFlag^DisGrpID^DisGroup^PrvDesc"
	s ListTitle=ListTitle_"^CstStatus^PayMony^PreTime^PatientID^AppAdmID"
	s Del=""""
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	W ","
	w Del_"IsCsUserNum"_Del_":"_IsCsUserNum
	W ","
	w Del_"IsCstUserNum"_Del_":"_IsCstUserNum
	w "}"
	Q ""
}*/
/// Descript: 取会诊申请数据
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtQuery("30","1","15/07/2019^23/08/2019^^^^^3^876^")
/// 
ClassMethod JsGetMdtQuery(rows As %String, page As %String, Params As %String, IsQry = "", TmpArr = "") As %String
{
	n (rows,page,Params,IsQry,TmpArr,%session)
	
	
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-7
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgLocID=$p(Params,"^",3)    /// 请会诊科室
	s ArgPatNo=$p(Params,"^",4)    /// 登记号
	s ArgDisGrp=$p(Params,"^",5)   /// 疑难病种
	s ConsStatus=$p(Params,"^",6)  /// 会诊状态
	s ShowModel=$p(Params,"^",7)   /// 显示内容：1(本人发送) 2(本人接收) 其他：查询所有
	s LgUserID=$p(Params,"^",8)    /// 登录用户ID
	s ArgPatName = $p(Params,"^",9) /// 病人姓名
	s ChargeFlag=$p(Params,"^",10)  /// 收费状态
	s HasCenter=$p(Params,"^",11)   /// 是否有疑难病会诊中心
	s LgLocID=$p(Params,"^",12)     /// 登录科室ID
	s LgHospID=$p(Params,"^",13)    /// 登录医院ID
	s Episode=$p(Params,"^",14)    /// 就诊
	s:(LgHospID="")&&(LgLocID'="") LgHospID=##class(web.DHCEMCommonUtil).GetHospitalIDByLocID(LgLocID)
	
	s LgUserCode = $p(^SSU("SSUSR",LgUserID),"^",1)
	;外院专家控制只能看本人会诊列表
	q:(IsQry="")&&(LgUserCode["wyzj")&&(ShowModel'=2) ##class(web.DHCEMJsonCommon).getJsonEmptySign(0)
	q:(IsQry'="")&&(LgUserCode["wyzj")&&(ShowModel'=2) ""
	
	s IsCstUserNum=0,IsCstLocNum=0,IsCsUserNum=0,IsGroupUserNum=0  /// 本人申请数和申请本人数
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s IsCstUser = "",IsCsUser="",IsGroupUser="" 
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..q:(Episode'="")&&(Episode'=EpisodeID)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..Q:(ArgPatName'="")&(PatName'[ArgPatName)
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(ArgPatNo'="")&(ArgPatNo'=PatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	..//s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    	..//s PatBed=##Class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    	..s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	..i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
    	..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	..//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	..s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID,"","","","Y")  ;##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..s HospitalID=$p(^CTLOC(CstRLocID),"^",22)
	..q:(LgHospID'="")&&(LgHospID'=HospitalID)  ///多院区过滤
	..s IsCstLoc=(LgLocID=CstRLocID)
	..q:(ArgLocID'="")&(ArgLocID'=CstRLocID)
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s:LgUserID=CstRUserID IsCstUser=1
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	..s PreTime=""
	..s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID
	..//s:AppScDr'="" PreTime =$p(^RBAS(+AppScDr,$p(AppScDr,"||",2)),"^",1)
	..//s:PreTime'="" PreTime=##Class(web.DHCMDTCom).DateLogicalToHtml(PreTime)
	..s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) /// 预约时间
	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	..s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	..s CstStatusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..q:(CstStatusID'="")&&('$d(^DHCMDTS(+CstStatusID)))
	..s CstStatus=""
	..q:(ConsStatus'="")&&(ConsStatus'=CstStatusID)
	..s:CstStatusID'="" CstStatus=$P(^DHCMDTS(CstStatusID),"^",2)
	..s CsStatCode=$p($g(^DHCMDTS(+CstStatusID)),"^",1) /// 状态代码
	..;q:(ConsStatus="")&&(CstStatus="撤销")
	..;q:CstStatus="撤销"
	..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	..s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s DisGroup=$p($g(^DHCMDTG(DisGrpID)),"^",2)
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	..s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	..s PrvID=$p($g(^RB("RES",+RBResID)),"^",2)
	..s PrvDesc="",PrvLoc=""
	..s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	..s:PrvLocID'="" PrvLoc=$p($g(^CTLOC(PrvLocID)),"^",2)
	..s AppAdmID = $p(^DHCMDTCON(ID),"^",20) 
	..;是不是外院专家
	..s IsWaiYuanDoc = ##class(web.DHCMDTConsultQuery).IsWaiY(ID,LgUserID)
	..s CstPrvArr="",CstLocArr="",CsDocRes=""
	..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p($g(^DHCMDTCON(ID,"I",CH)),"^",1)       /// 会诊科室
	...s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",2)
	...s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	...i CareProvID=0 s CareProvID=+$p($g(^DHCMDTCON(ID,"I",CH)),"^",3)
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	...s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.../// 当前登录人是否会诊医师
	...s:(+CsUserID'=0)&(CsUserID=LgUserID)&(LgLocID=CsLocID) IsCsUser=1            
	.../// 未选择职称的判断下科室下是否有登录权限
	...s:(+CsUserID=0)&(IsCsUser="") IsCsUser=+##Class(web.DHCMDTCom).IsHasLgUser(CsLocID,PrvTpID,LgUserID)
	.../// 增加一个院外的判断
	...s:IsCsUser="" IsCsUser=IsWaiYuanDoc
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	...s CsLocDesc = ##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CsLocDesc)
	...s CsUser = ##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CsUser)
	...s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	...s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	...i CsUserID=LgUserID s CsDocRes=##Class(web.DHCMDTConsult).GetCsDocRes(ID_"||"_CH,LgUserID) /// 取会诊医生的操作内容
	...s CsDocRes=$p(CsDocRes,"^",2)
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
	..s:PayMony=1 PayMony="已收费"
	..s:PayMony=0 PayMony="未收费"
	..s CHS=""
	..F  s CHS=$o(^DHCMDTG(DisGrpID,"I",CHS)) Q:CHS=""  D
	...s MDUserID=$p(^DHCMDTG(DisGrpID,"I",CHS),"^",2)
	...s:LgUserID=MDUserID IsGroupUser=1
	..
	..Q:(ChargeFlag'="")&(ChargeFlag="Y")&(PayMony="未收费")
	..Q:(ChargeFlag'="")&(ChargeFlag="N")&(PayMony="已收费")
	..s:IsGroupUser=1 IsGroupUserNum=IsGroupUserNum+1
	..s:IsCstUser=1 IsCstUserNum=IsCstUserNum+1
	..s:IsCsUser=1 IsCsUserNum=IsCsUserNum+1
	..s:IsCstLoc=1 IsCstLocNum=IsCstLocNum+1
	..;q:(ShowModel=1)&&((PayMony'="已收费")||(CsStatCode<30))	;本人会诊中心模式不显示未收费和未安排的会诊
	..;Q:(ShowModel=1)&((PayMony'="已收费")||((HasCenter'=0)&(CsStatCode<30)))     /// 本人会诊仅显示已安排并且已收费
	..;s:(IsCsUser=1)&(PayMony="已收费")&((HasCenter=0)||((HasCenter'=0)&(CsStatCode>=30))) IsCsUserNum=IsCsUserNum+1
	..q:(ShowModel=1)&(IsCstUser'=1)    /// 本人发送
	..q:(ShowModel=2)&(IsCsUser'=1)     /// 本人接收
	..q:(ShowModel=3)&(IsGroupUser'=1)  /// 本组会诊
	..q:(ShowModel=4)&(IsCstLoc'=1)  	/// 本科会诊
	..s CsAcceptInfo = ##Class(web.DHCMDTConsult).GetCsAcceptNotes(ID, LgUserID)
	..;s CsAcceptFlag=##Class(web.DHCMDTConsult).GetCsAcceptFlagNew(ID, LgUserID)
	..s isAccFlag=$p(CsAcceptInfo,"^",1) 
	..;s isAccFlag=$case(isAccFlag,1:"已接收",2:"已拒绝",:"")
	..s AcceptNotes=$p(CsAcceptInfo,"^",2)
	..s isAccFlag=##class(websys.Translation).Get("dhcmdt.conslistmain.csp",isAccFlag)
	..s OutHospConsDoc=##Class(web.DHCMDTConsultQuery).GetOutHospConsDoc(ID)
	..s IsContact=##class(web.DHCMDTCom).LgUserIsContact(DisGrpID, LgUserID)	;当前登录人是不是这个病种的联络人
	..s IsContact=$case(IsContact,"Y":1,:0)
	..s DisGroup=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2022-12-07
	..s CstNPlaceNew=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDConsAddress","",CstNPlace) 
	..i CstNPlaceNew'=CstNPlace d
	...s CstNPlace=CstNPlaceNew
	..e  d
	...s CstNPlace=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTDicItem","MDDesc","",CstNPlace)
	..s Num=Num+1
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser
	..s ListData=ListData_"^"_IsCsUser_"^"_CstTrePro_"^"_CstPurpose_"^"_IsContact_"^"_IsWaiYuanDoc
	..s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_CstLocArr_"^"_CstPrvArr_"^"_PrintFlag_"^"_DisGrpID_"^"_DisGroup_"^"_PrvDesc
	..s ListData=ListData_"^"_CsStatCode_"^"_CstStatus_"^"_PayMony_"^"_PreTime_"^"_PatientID_"^"_AppAdmID_"^"_isAccFlag_"^"_CsDocRes_"^"_OutHospConsDoc
	..s ListData=ListData_"^"_AcceptNotes
	
	..s:'IsQry TMPListData(Num)=ListData
	..s:IsQry TmpArr(Num)=ListData
	q:IsQry "" ///IsQry不为空表示只是为了获取值
	
	///转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUserID"
	s ListTitle=ListTitle_"^CstRUser^IsCsUser^CstTrePro^CstPurpose^IsContact^IsWaiYuanDoc"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^CstUser^CstPhone^CstLocArr^CstPrvArr^PrintFlag^DisGrpID^DisGroup^PrvDesc"
	s ListTitle=ListTitle_"^stCode^CstStatus^PayMony^PreTime^PatientID^AppAdmID^isAccFlag^CsDocRes^OutHospConsDoc"
	s ListTitle=ListTitle_"^AcceptNotes"
	s Del=""""
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	W ","
	w Del_"IsCsUserNum"_Del_":"_IsCsUserNum
	W ","
	w Del_"IsCstUserNum"_Del_":"_IsCstUserNum
	W ","
	w Del_"IsGroupUserNum"_Del_":"_IsGroupUserNum
	W ","
	w Del_"IsCstLocNum"_Del_":"_IsCstLocNum
	w "}"
	Q ""
}

/// 判断用户是否外院专家
/// Return：1/其他
/// w ##class(web.DHCMDTConsultQuery).IsWaiY(107,19023)
ClassMethod IsWaiY(ID, LgUserID)
{
	n (ID,LgUserID)
	s Ret=""
	s MDRowID=0
	f {
		s MDRowID=$o(^DHCMDTCOE(0,"ParRef",ID,MDRowID))
		q:MDRowID=""
		continue:$p(^DHCMDTCOE(MDRowID),"^",4)'=LgUserID
		s Ret=1
		q:Ret'=""
	}
	
	q Ret
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-11
/// Descript:    MDT获取申请科室和医生
/// Input:       ID - MDT申请ID
/// OutPut:      科室、医生列表
/// W ##Class(web.DHCMDTConsultQuery).GetMdtCsLocs(73)
ClassMethod GetMdtCsLocs(ID As %String) As %String
{
	n (ID)
	s CH="",mListData=""
	f  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	.s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	.i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.i CsLocDesc["-" s CsLocDesc=$p(CsLocDesc,"-",2)
	.s PrvTpID="",PrvTp=""
	.s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.i mListData="" s mListData=CsLocDesc_"@"_CsUser
	.E  s mListData=mListData_"#"_CsLocDesc_"@"_CsUser
	
	s CsExpID="0"
	f  s CsExpID=$o(^DHCMDTCOE(0,"ParRef",ID,CsExpID)) Q:CsExpID=""  D
	.s UserID=$p(^DHCMDTCOE(CsExpID),"^",2)
	.q:UserID=""
	.q:'$d(^DHCMDTOUTEXP(UserID))
	.s UserName=$p(^DHCMDTOUTEXP(UserID),"^",2)   /// 姓名
	.s PrvTpID=$p(^DHCMDTOUTEXP(UserID),"^",4)    /// 职称
	.s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	.s LocID=$p(^DHCMDTOUTEXP(UserID),"^",6)      /// 科室ID
	.s LocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	.s TelPhone=$p(^DHCMDTOUTEXP(UserID),"^",7)   /// 电话
	.s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)      /// 外院
	.Q:ParID=""
	.s HospDesc=$p(^DHCMDTDI(ParID),"^",2)        /// 外院
	.s CsLocDesc=HospDesc_"-"_LocDesc
	.i mListData="" s mListData=CsLocDesc_"@"_UserName
	.E  s mListData=mListData_"#"_CsLocDesc_"@"_UserName
	
	Q mListData
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    患者MDT会诊次数
/// W ##Class(web.DHCMDTConsultQuery).GetMdtCsTimes(27233511)
ClassMethod GetMdtCsTimes(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s Type="", Times=1
	F  s Type=$o(^PAPERdr(PatientID,"ADM",Type)) Q:Type=""  D
	.s EpisodeID=""
	.F  s EpisodeID=$o(^PAPERdr(PatientID,"ADM",Type,EpisodeID)) Q:EpisodeID=""  D
	..s ID=""
	..F  s ID=$o(^DHCMDTCON(0,"Adm",EpisodeID,ID)) Q:ID=""  D
	...s mdtStatID=+$p(^DHCMDTCON(ID),"^",12)   /// 申请状态
	...Q:$p($g(^DHCMDTS(mdtStatID)),"^",1)<80
	...s Times=Times+1
	..
	Q Times-1
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    取申请单页面默认填写数据
/// w ##Class(web.DHCMDTConsultQuery).TakCsPatInfo("27233579","191","876")
ClassMethod TakCsPatInfo(EpisodeID As %String, LgLocID As %String, LgUserID As %String) As %String
{
	n (EpisodeID, LgLocID, LgUserID,%session)
	s LocDesc=$p(^CTLOC(LgLocID),"^",2)        /// 科室
	s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	s LocDesc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",LocDesc)  /// 多语言支持
	s HospID=$p(^CTLOC(LgLocID),"^",22)        /// 医院
	s HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
	s LgUser=$p(^SSU("SSUSR",LgUserID),"^",2)  /// 用户
	s LgUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",LgUser)  /// 多语言支持
	s LocAddr=$g(^CTLOC(LgLocID,"ADDR",1))	   /// 地址
	i LocAddr="" D
	.s LinkLocID=$o(^CTLOC(LgLocID,"LINK",0,"Loc",""))
	.s:LinkLocID'="" LocAddr=$g(^CTLOC(LinkLocID,"ADDR",1))
	s LocAddr=""
	s mdtTimes=..GetMdtCsTimes(EpisodeID)     /// 患者MDT会诊次数
    s ListData=LocDesc_"^"_LgUser_"^"_LocAddr_"^"_HospID_"^"_HospDesc_"^"_mdtTimes
	s ListTitle="LocDesc^LgUser^LocAddr^HospID^HospDesc^mdtTimes"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator:     bianshuai
/// CreateDate:  2019-07-12
/// Descript:    计算偏移量
/// w ##Class(web.DHCMDTConsultQuery).GetWeekOffset("")
ClassMethod GetWeekOffset(CstID As %String) As %Integer
{
	n (CstID)
	Q:CstID="" 0
	s CstNDate=$p(^DHCMDTCON(CstID),"^",8)     /// 会诊日期
	Q:CstNDate="" 0
	s Offset=$SYSTEM.SQL.WEEK(CstNDate) - $SYSTEM.SQL.WEEK(+$H)
	Q:Offset<0 0
	Q Offset
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-18
/// Descript:   通过会诊ID或者病种ID获取需要挂的号别
/// w ##Class(web.DHCMDTConsultQuery).JsGetResWeekPlan("93","","0")
ClassMethod JsGetResWeekPlan(CstID As %String, DisGrpID As %String, offset As %String) As %String
{
	n (CstID, DisGrpID, offset,%session)
	s StartDate=+$H+(7-$SYSTEM.SQL.DAYOFWEEK(+$H))+(7*(offset-1))+1 /// 开始日期
	s EndDate=StartDate+6 /// 结束日期
	i offset=0 s StartDate=+$H+1
	s ListTitle="",ListData=""
	F dd=StartDate:1:EndDate D
	.s Week=($SYSTEM.SQL.DAYOFWEEK(dd)-1)
	.s ListTitle=$s(ListTitle="":"Week_"_Week,1:ListTitle_"^"_"Week_"_Week)
	.s ListData=$s(ListData="":$p($zd(dd,3),"-",2,3),1:ListData_"^"_$p($zd(dd,3),"-",2,3))
	.
	w ##Class(web.DHCEMJsonCommon).getJsonChildPrefixSign(ListTitle,ListData)
	w ",""items"":"
	D ##Class(web.DHCMDTConsultQuery).JsGetWeekPlan(CstID, DisGrpID, StartDate, EndDate)
	w "}"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2019-07-18
/// Descript:   通过会诊ID或者病种ID获取需要挂的号别
/// w ##Class(web.DHCMDTConsultQuery).JsGetWeekPlan("","2")
ClassMethod JsGetWeekPlan(CstID As %String, DisGrpID As %String, StartDate As %String, EndDate As %String) As %String
{
	n (CstID, DisGrpID, StartDate, EndDate,%session)
	s:CstID'="" DisGrpID=$p(^DHCMDTCON(CstID),"^",16)
	Q:+DisGrpID=0 ""
	s ID=$o(^DHCMDTCP(0,"Group",DisGrpID,""),-1)
	i +ID=0 w "[]"
	Q:+ID=0 ""
	s LocID=$p(^DHCMDTCP(ID),"^",2)    /// 科室ID
	s PrvID=$p(^DHCMDTCP(ID),"^",3)    /// 号别ID
	//s StartDate=+$H, EndDate=+$H+7     /// 一周
	s result=##Class(%Library.ResultSet).%New("DHCDoc.Interface.Inside.MDT.Service:FindRBASList")
	Set sc=result.Execute(LocID,PrvID,StartDate,EndDate,"")   //DOC是诊间预约
 	If $$$ISERR(sc) Quit ""
    Set colNum=result.GetColumnCount() //列数
 	w "["
	s count=0,del=""""
	While(result.Next())
	{ 	
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		
		s CsDate=$p(result.%GetData(4),$C(13,10)) /// 日期
		Continue:(CsDate="")
		
		s TimeRange=$p(result.%GetData(3),$C(13,10)) /// 时间范围
		s CsDate=##class(web.DHCMDTCom).DateHtmlToLogical(CsDate)
		s Week="Week_"_($SYSTEM.SQL.DAYOFWEEK(CsDate)-1)
		s Week=Week_"_"_$s(TimeRange="上午":"AM",1:"PM")
		s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)   /// 病种专业组
		s DisGroup = ##Class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2022-12-08
		s CsTime=$p(result.%GetData(8),$C(13,10)) /// $p($p(result.%GetData(8),$C(13,10)),"-",1)
		s ret=ret_","_del_"DisGroup"_del_":"_del_DisGroup_del_","_del_"Week"_del_":"_del_Week_del_","_del_"CsTime"_del_":"_del_CsTime_del
		
		s count=count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	}
	w "]"
	Do result.Close()
	Q ""
}

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCMDTConsultQuery).JsGetPatHisCons("30","1","2020-01-20^2020-02-19^^^^604^")
ClassMethod JsGetPatHisCons(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s ArgLocID=$p(Params,"^",3)    /// 请会诊科室
	s ArgDisGrp=$p(Params,"^",4)   /// 疑难病种
	s argPatientID=$p(Params,"^",5)  /// 病人ID
	s argEpisodeID=$p(Params,"^",6)  /// 就诊ID
    s argTimesArr=$p(Params,"^",7)  /// 第几次就诊
    
    i +argPatientID=0 s argPatientID=$p(^PAADM(argEpisodeID),"^",1)
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..//Q:(argEpisodeID'="")&(argEpisodeID'=EpisodeID)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..Q:(argPatientID'="")&(argPatientID'=PatientID)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	..//s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) /// 年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
   	..s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	..i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	..//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	..s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..Q:(ArgLocID'="")&(ArgLocID'=CstRLocID)
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	..s MCTimes=$p(^DHCMDTCON(ID),"^",22)    /// 患者第几次会诊次数
	..s MCTimes=MCTimes+1
	..Q:(argTimesArr'="")&(argTimesArr'=MCTimes)
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	..s PreTime=""
	..s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID
	..s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) /// 预约时间
	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	..s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	..s CstStatusID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:CstStatusID=""
	..s CstStatusDesc=$p($g(^DHCMDTS(CstStatusID)),"^",2)
	..Q:CstStatusDesc'="完成"
	..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	..s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..Q:(ArgDisGrp'="")&(ArgDisGrp'=DisGrpID)
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	..s mdtMakResID=$p(^DHCMDTCON(ID),"^",18)   /// 预约资源ID
	..s PrvLocID=$p($g(^RB("RES",+RBResID)),"^",1)
	..s PrvID=$p($g(^RB("RES",RBResID)),"^",2)
	..s PrvDesc="",PrvLoc=""
	..s:PrvID'="" PrvDesc=$p($g(^CTPCP(PrvID,1)),"^",2)
	..s:PrvLocID'="" PrvLoc=$p(^CTLOC(PrvLocID),"^",2)
	..s AppAdmID = $p(^DHCMDTCON(ID),"^",20) 
	..s CstPrvArr="",CstLocArr=""
	..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	...s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	...s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	...i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	...s CsUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CsUser) //hxy 2023-02-10
	...s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s CsLocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",CsLocDesc) //hxy 2023-02-10
	...s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	...s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	...s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
#;	..s:PayMony=1 PayMony="已收费"
#;	..s:PayMony=0 PayMony="未收费"
	..s DisGroup=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup) //hxy 2023-02-10 st
	..s CstStatusDesc=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTConsStatus","MDDesc","",CstStatusDesc)
	..s CstNPlaceNew=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTGroup","MDConsAddress","",CstNPlace) 
	..i CstNPlaceNew'=CstNPlace d
	...s CstNPlace=CstNPlaceNew
	..e  d
	...s CstNPlace=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTDicItem","MDDesc","",CstNPlace) //ed
	..s Num=Num+1
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	..s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_CstLocArr_"^"_CstPrvArr_"^"_PrintFlag_"^"_DisGrpID_"^"_DisGroup_"^"_PrvDesc
	..s ListData=ListData_"^"_CstStatusDesc_"^"_PayMony_"^"_PreTime_"^"_PatientID_"^"_AppAdmID_"^"_mdtMakResID_"^"_TreMeasures_"^"_MCTimes  
	..s TMPListData(Num)=ListData
	..
	
	///转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUserID"
	s ListTitle=ListTitle_"^CstRUser^CstTrePro^CstPurpose^CstNDate^CstNTime^CstNPlace^CstUser^CstPhone^CstLocArr^CstPrvArr^PrintFlag^DisGrpID^DisGroup^PrvDesc"
	s ListTitle=ListTitle_"^CstStatusDesc^PayMony^PreTime^PatientID^AppAdmID^mdtMakResID^TreMeasures^MCTimes"
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2019-08-05
/// Descript:   mdt病种对应的科室专家组
/// w ##Class(web.DHCMDTConsultQuery).JsGetDisGrpLoc("5")
ClassMethod JsGetDisGrpLoc(GrpID As %String, Type As %String) As %String
{
	n (GrpID, Type,%session)
	k TmpArr

	/// 本组专家
	i Type="G" D ..GetGroupExp(GrpID, .TmpArr)
	/// 外院专家
	i Type="E" D ..GetOuterExp(GrpID, .TmpArr)

	/// 输出数据
	w "["
	s index="",num=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s id=$p($g(TmpArr(index)),"^",1)
	.s Text=$p($g(TmpArr(index)),"^",2)
	.s num=num+1
	.i num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonTreeStartSign(id,Text)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonTreeStartSign(id,Text)
	.w ",""items"":["
	.s index2="",count=0
	.F  s index2=$o(TmpArr(index,index2)) Q:index2=""  D
	..s ListData=$g(TmpArr(index,index2))
	..s count=count+1
	..i count=1 d
	...w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	..e  d
	...w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",ListData)
	.w "]}"
	w "]"
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2020-08-21
/// Descript:     本组专家
/// w ##Class(web.DHCMDTConsultQuery).GetGroupExp("30","1","")
ClassMethod GetGroupExp(GrpID As %String, TmpArr As %String) As %String
{
	n (GrpID, TmpArr,%session)
	s CH=""
	F  s CH=$o(^DHCMDTG(GrpID,"I",CH)) Q:CH=""  D
	.s LocDesc="",LocPyCode=""
	.s LocID=$p(^DHCMDTG(GrpID,"I",CH),"^",1)    /// 科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s:LocDesc["-" LocPyCode=$p(LocDesc,"-",1)
	.s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	.s userID=$p(^DHCMDTG(GrpID,"I",CH),"^",2)   /// 医生ID
	.Q:userID=""
	.s Contacts=$p(^DHCMDTG(GrpID,"I",CH),"^",3)
	.s CareProvID=$p(^SSU("SSUSR",userID),"^",14)
	.s CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	.i LocDesc'="" s LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	.i CareProv'="" s CareProv=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProv)
	.s cont=##Class(web.DHCEMCommonUtil).GetTrans("dhcmdt.makresloc.csp","联络人")
	.s:Contacts="Y" CareProv=CareProv_"("_cont_")"
	.s OtherName=$p($g(^CTPCP(CareProvID,3)),"^",28) /// OtherName
	.i '$D(TmpArr(LocID)) s TmpArr(LocID)=LocID_"^"_LocDesc
	.s TmpArr(LocID,userID)=CareProvID_"^"_CareProv
	.
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2020-08-21
/// Descript:     外院专家
/// w ##Class(web.DHCMDTConsultQuery).GetOuterExp("30","1","")
ClassMethod GetOuterExp(GrpID As %String, TmpArr As %String) As %String
{
	n (GrpID, TmpArr,%session)
	s ID="0"
	F  s ID=$o(^DHCMDTGOE(0,"ParRef",GrpID,ID)) Q:ID=""  D
	.s expID=$p(^DHCMDTGOE(ID),"^",2)
	.Q:expID=""
	.q:'$d(^DHCMDTOUTEXP(expID))
	.s userName=$p(^DHCMDTOUTEXP(expID),"^",2)    /// 姓名
	.s LocID=$p(^DHCMDTOUTEXP(expID),"^",6)       /// 科室ID
	.s LocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	.s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)
	.s HospDesc=$p(^DHCMDTDI(ParID),"^",2)
	.i userName'="" s userName=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTOuterExpert","MDName","",userName)
	.i LocDesc'="" s LocDesc=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTDicItem","MDDesc","",LocDesc)
	.i HospDesc'="" s HospDesc=##class(web.DHCMDTCom).GetTransDesc("User.DHCMDTDicItem","MDDesc","",HospDesc)

	.i '$D(TmpArr(LocID)) s TmpArr(LocID)=LocID_"^"_LocDesc_"-"_HospDesc
	.s TmpArr(LocID,expID)=expID_"^"_userName
	.
	Q ""
}

/// w ##Class(web.DHCMDTConsultQuery).JsGetLoc("100")
ClassMethod JsGetLoc(ID As %String) As %String
{
	s DisGrpID=$p(^DHCMDTCON(ID),"^",16) 
	s CH="",CstLocArr1="",Num=""
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室 
	..s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	..s PrvTpID=$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	..i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3)   
	..s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	..s:(+CsUserID'=0)&&(CsUserID=LgUserID) IsCsUser=1            /// 当前登录人是否会诊医师
	..s:+CsUserID=0 IsCsUser=+##Class(web.DHCMDTCom).IsHasLgUser(CsLocID,PrvTpID,LgUserID)
	..s CsLocDesc1="",CsLocDesc2="",CsUser1="",CsUser2=""
	..s CHS=""
	..s CHS=$o(^DHCMDTG(DisGrpID,"I",CHS)) Q:CHS=""  
	..s MDUserID=$p(^DHCMDTG(DisGrpID,"I",CHS),"^",2) 
	..s MDLocDr=$p(^DHCMDTG(DisGrpID,"I",CHS),"^",1) 
	..i MDLocDr=CsLocID d
	...q:MDLocDr'=CsLocID
	...s CsLocDesc1=$p($g(^CTLOC(+CsLocID)),"^",2) 
	...s:CsLocDesc1["-" CsLocDesc1=$p(CsLocDesc1,"-",2)   
	...s CstLocArr1=$s(CstLocArr1="":CsLocDesc1,1:CstLocArr1_"、"_CsLocDesc1)
	...b ;1
	..s Num=Num+1
	..s ListData=ID_"^"_CstLocArr1
	
	..s TMPListData(Num)=ListData
	///转换数据为Json格式
	s ListTitle="ID^CstLocArr1"
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	w "}"
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt数据统计
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtMonthMap("30","1","")
ClassMethod JsGetMdtMonthMap(rows As %String, page As %String, Params As %String, pid As %String) As %String
{
	n (rows,page,Params, pid)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"@",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=+$H-30
    s EndDate=$p(Params,"@",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=+$H
	k TmpArr
	
	i pid="" s pid=..NewPid()
    d ..killTmpGlobal(pid) /// k掉临时global
    
	s mParams=Params /// 准备下级筛查条件
	D ..GetMdtMonthMap(StartDate, EndDate, .TmpArr) /// 获取MDT会诊数据

	///转换数据为Json格式
	s ListTitle="mdtMonth^mdtDisQty^mdtParams^pid"
	W ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))_"^"_mParams_"@"_index_"^"_pid
	.Q:ListData=""
	.s ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtMonthMap",pid,index)=ListData
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json前缀串
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt月分布统计
/// w ##Class(web.DHCMDTConsultQuery).GetMdtMonthMap()
ClassMethod GetMdtMonthMap(StartDate As %String, EndDate As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, TmpArr)
  
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:StatID=""
	..Q:$p($g(^DHCMDTS(StatID)),"^",1)'=80
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s month=$SYSTEM.SQL.MONTH(CstRDate)
	..i month<10 s month=0_month
	..s month=$SYSTEM.SQL.YEAR(CstRDate)_"-"_month
	..i '$D(TmpArr(month)) s TmpArr(month)=month_"^"_1
	..E  s $p(TmpArr(month),"^",2)=$p($g(TmpArr(month)),"^",2)+1
	.
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt病种数统计
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtDisGrpMap("30","1","2019-10-28@2020-01-21@2020-11","")
ClassMethod JsGetMdtDisGrpMap(rows As %String, page As %String, Params As %String, pid As %String) As %String
{
	n (rows,page,Params,pid)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"@",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"@",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s Month=$p(Params,"@",3)     /// 月份
	k TmpArr
	
	i pid="" s pid=..NewPid()
    d ..killTmpGlobal(pid) /// k掉临时global
	
	D ..GetMdtDisGrpMap(StartDate, EndDate, Month, .TmpArr) /// 获取MDT会诊数据
	
	i Params="" D
	.s StartDate=##Class(web.DHCMDTCom).DateLogicalToHtml(StartDate)
	.s EndDate=##Class(web.DHCMDTCom).DateLogicalToHtml(EndDate)
	.s Params=StartDate_"@"_EndDate_"@"
	s mParams=Params /// 准备下级筛查条件
	
	///转换数据为Json格式
	s ListTitle="mdtDisGrpID^mdtDisGroup^mdtDisQty^mdtParams^pid"
	W ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))_"^"_mParams_"^"_pid
	.Q:ListData=""
	.s ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDisGrpMap",pid,index)=ListData
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json前缀串
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt病种数统计
/// w ##Class(web.DHCMDTConsultQuery).GetMdtDisGrpMap()
ClassMethod GetMdtDisGrpMap(StartDate As %String, EndDate As %String, Month As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, Month, TmpArr)
  
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:StatID=""
	..Q:$p($g(^DHCMDTS(StatID)),"^",1)'=80
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..Q:'..IsInTimeRanges(Month, CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)   /// 疑难病种
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..i '$D(TmpArr(DisGrpID)) s TmpArr(DisGrpID)=DisGrpID_"^"_DisGroup_"^"_1
	..E  s $p(TmpArr(DisGrpID),"^",3)=$p($g(TmpArr(DisGrpID)),"^",3)+1
	.
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     是否在指定时间范围内
/// w ##Class(web.DHCMDTConsultQuery).IsInTimeRanges("2020-01",+$h)
ClassMethod IsInTimeRanges(Month As %String, CstRDate As %String) As %String
{
	n (Month, CstRDate)
  	Q:Month="" 1
  	Q:$SYSTEM.SQL.YEAR(CstRDate)'=$p(Month,"-") 0
    Q:$SYSTEM.SQL.MONTH(CstRDate)'=+$p(Month,"-",2) 0
	Q 1
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt会诊请求科室分布统计
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtReqLocMap("30","1","")
ClassMethod JsGetMdtReqLocMap(rows As %String, page As %String, Params As %String, pid As %String) As %String
{
	n (rows,page,Params,pid)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"@",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"@",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s Month=$p(Params,"@",3)     /// 月份
	s DisGrpID=$p(Params,"@",4)  /// 病种ID
	k TmpArr
	
	i pid="" s pid=..NewPid()
    d ..killTmpGlobal(pid) /// k掉临时global
	
	D ..GetMdtReqLocMap(StartDate, EndDate, Month, DisGrpID, .TmpArr) /// 获取MDT会诊数据
	
	i Params="" D
	.s StartDate=##Class(web.DHCMDTCom).DateLogicalToHtml(StartDate)
	.s EndDate=##Class(web.DHCMDTCom).DateLogicalToHtml(EndDate)
	.s Params=StartDate_"@"_EndDate_"@@"
	s mParams=Params /// 准备下级筛查条件
	
	///转换数据为Json格式
	s ListTitle="mdtReqLocID^mdtReqLoc^mdtReqQty^mdtParams^pid"
	W ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))_"^"_mParams_"^"_pid
	.Q:ListData=""
	.s ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtReqLocMap",pid,index)=ListData
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json前缀串
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt会诊请求科室分布统计
/// w ##Class(web.DHCMDTConsultQuery).GetMdtReqLocMap()
ClassMethod GetMdtReqLocMap(StartDate As %String, EndDate As %String, Month As %String, DisGrpID As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, Month, DisGrpID, TmpArr)
  
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:StatID=""
	..Q:$p($g(^DHCMDTS(StatID)),"^",1)'=80
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..Q:'..IsInTimeRanges(Month, CstRDate)
	..Q:(DisGrpID'="")&($p(^DHCMDTCON(ID),"^",16)'=DisGrpID)    /// 疑难病种
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)
	..i '$D(TmpArr(CstRLocID)) s TmpArr(CstRLocID)=CstRLocID_"^"_CstRLoc_"^"_1
	..E  s $p(TmpArr(CstRLocID),"^",3)=$p($g(TmpArr(CstRLocID)),"^",3)+1
	.
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt会诊申请医生分布统计
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtDocMap("30","1","")
ClassMethod JsGetMdtDocMap(rows As %String, page As %String, Params As %String, pid As %String) As %String
{
	n (rows,page,Params, pid,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"@",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=+$H-30
    s EndDate=$p(Params,"@",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=+$H
	s Month=$p(Params,"@",3)     /// 月份
	s DisGrpID=$p(Params,"@",4)  /// 病种ID
	s ReqLocID=$p(Params,"@",5)  /// 科室ID
	s doctor=$p(Params,"@",6)  /// 会诊专家
	k TmpArr
		
	i pid="" s pid=..NewPid()
    d ..killTmpGlobal(pid) /// k掉临时global
	
	D ..GetMdtDocMap(StartDate, EndDate, Month, DisGrpID, ReqLocID, .TmpArr) /// 获取MDT会诊数据
	
	///转换数据为Json格式
	s ListTitle="mdtUser^mdtReqTimes^mdtCsTimes^pid"
	W ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s index="",count=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.q:(doctor'="")&&(doctor'=index)
	.s ListData=$g(TmpArr(index))_"^"_pid
	.Q:ListData=""
	.s ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDocMap",pid,index)=ListData
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCEMJsonCommon).getJsonEndConTotal(count) //输出json前缀串
	Q ""
}

/// Creator: 	  bianshuai
/// CreateDate:   2019-11-19
/// Descript:     全院mdt会诊请求科室分布统计
/// w ##Class(web.DHCMDTConsultQuery).GetMdtReqLocMap()
ClassMethod GetMdtDocMap(StartDate As %String, EndDate As %String, Month As %String, DisGrpID As %String, ReqLocID As %String, TmpArr As %String) As %String
{
	n (StartDate, EndDate, Month, DisGrpID, ReqLocID, TmpArr,%session)
  
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D
	..s StatID=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..Q:StatID=""
	..Q:$p($g(^DHCMDTS(StatID)),"^",1)'=80
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..Q:'..IsInTimeRanges(Month, CstRDate)
	..Q:(DisGrpID'="")&($p(^DHCMDTCON(ID),"^",16)'=DisGrpID)   /// 疑难病种
	..Q:(ReqLocID'="")&($p(^DHCMDTCON(ID),"^",2)'=ReqLocID)    /// 申请科室
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..i $g(TmpArr(CstRUserID))="" s TmpArr(CstRUserID)=CstRUser_"^"_1_"^"_0
	..E  s $p(TmpArr(CstRUserID),"^",2)=$p($g(TmpArr(CstRUserID)),"^",2)+1
	..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	...s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	...i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...Q:CsUserID=""
	...i $g(TmpArr(CsUserID))="" s TmpArr(CsUserID)=CsUser_"^"_0_"^"_1
	...E  s $p(TmpArr(CsUserID),"^",3)=$p($g(TmpArr(CsUserID)),"^",3)+1
	..
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-11-21
/// Descript:		MDT会诊病种分布
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtDisGrpCharts("")
ClassMethod JsGetMdtDisGrpCharts(pid As %String) As %String
{
	n (pid)
	
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	W "["
	s index="", Num=0
	F  s index=$o(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDisGrpMap",pid,index)) Q:index=""  D
	.s mdata=$g(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDisGrpMap",pid,index))
	.Q:mdata=""
	.s Key=$p(mdata,"^",2)
	.s Val=$p(mdata,"^",3)
	.s ListData=Key_"^^"_Val
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-11-21
/// Descript:		MDT会诊申请科室分布
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtReqLocCharts("")
ClassMethod JsGetMdtReqLocCharts(pid As %String) As %String
{
	n (pid)
	
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	W "["
	s index="", Num=0
	F  s index=$o(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtReqLocMap",pid,index)) Q:index=""  D
	.s mdata=$g(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtReqLocMap",pid,index))
	.Q:mdata=""
	.s Key=$p(mdata,"^",2)
	.s Val=$p(mdata,"^",3)
	.s ListData=Key_"^^"_Val
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-11-21
/// Descript:		MDT会诊专家申请会诊量分布
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtDocMapCharts("")
ClassMethod JsGetMdtDocMapCharts(pid As %String) As %String
{
	n (pid)
	
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	W "["
	s index="", Num=0
	F  s index=$o(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDocMap",pid,index)) Q:index=""  D
	.s mdata=$g(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDocMap",pid,index))
	.Q:mdata=""
	.s Key=$p(mdata,"^",1)
	.s ReVal=$p(mdata,"^",2)
	.s CsVal=$p(mdata,"^",3)
	.s ReListData=Key_"^申请次数^"_ReVal
	.s CsListData=Key_"^会诊次数^"_CsVal
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ReListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ReListData)
	.w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,CsListData)
	W "]"
	Q ""
}

/// Creator: 		bianshuai
/// CreateDate: 	2019-11-21
/// Descript:		MDT会诊专家申请会诊量分布
/// w ##Class(web.DHCMDTConsultQuery).JsGetMdtMonthMapCharts("")
ClassMethod JsGetMdtMonthMapCharts(pid As %String) As %String
{
	n (pid)
	
	/// 转换数据为Json格式
	s ListTitle="name^group^value"
	W "["
	s index="", Num=0
	F  s index=$o(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtMonthMap",pid,index)) Q:index=""  D
	.s mdata=$g(^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtMonthMap",pid,index))
	.Q:mdata=""
	.s Key=$p(mdata,"^",1)
	.s Val=$p(mdata,"^",2)
	.s ListData=Key_"^^"_Val
	.s Num=Num+1
	.I Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	W "]"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2020-03-20
/// Descritp:	取病人最后一次就诊信息
/// InPut:      PatNo - 登记号
/// OutPut:     
/// w ##Class(web.DHCMDTConsultQuery).GetPatLastEpi("0000000220")
ClassMethod GetPatLastEpi(PatNo As %String) As %Library.String
{
	n (PatNo)
	s PatientID=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
    Q:PatientID="" "{}"
    s PatType=$o(^PAPERdr(PatientID,"ADM",""),-1)
    Q:PatType="" "{}"
	s EpisodeID=$o(^PAPERdr(PatientID,"ADM",PatType,""),-1)
	Q:EpisodeID="" "{}"
	s mradm=$p(^PAADM(EpisodeID),"^",61)       /// 就诊类型
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	   /// 病人登记号
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_mradm
	s ListTitle="PatientID^EpisodeID^PatNo^mradm"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   批量修改专家查询功能
/// InPut:      开始日期^结束日期^病种ID
/// OutPut:     
/// w ##Class(web.DHCMDTConsultQuery).JsGetBatModExpQry("10","1","2020-01-01^2020-04-08")
ClassMethod JsGetBatModExpQry(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCMDTCom).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-7
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCMDTCom).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s mDisGrpID=$p(Params,"^",3)   /// 疑难病种
	s LgHospID=$p(Params,"^",4)    /// 医院ID
    /// 是否有疑难病会诊中心
	s HasCenter=##Class(web.DHCMDTCom).GetEmSysConfig("HASCENTER",LgHospID)
	
    s Num=0
	F dd=StartDate:1:EndDate D
	.s ID=""
	.F  s ID=$o(^DHCMDTCON(0,"ReqDateIndex",dd,ID)) Q:ID=""  D   /// "NDate"
	..s EpisodeID=$p(^DHCMDTCON(ID),"^",1)        /// 就诊ID
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatSex=##class(web.DHCMDTCom).GetMulLanTrsDesc("Sex","",PatSex)  /// 多语言支持
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 	  /// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s:PatLoc["-" PatLoc=$p(PatLoc,"-",2)
	..s PatLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",PatLoc)  /// 多语言支持
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ..s PatBed=##Class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCMDTCom).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCMDTCom).IGetMrNoByEpisodeID(EpisodeID)  /// 病案号
	..//s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	..s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis(EpisodeID)   /// 诊断
	..s CstRLocID=$p(^DHCMDTCON(ID),"^",2)   /// 申请科室
	..s HospitalID=$p(^CTLOC(CstRLocID),"^",22)
	..q:(LgHospID'="")&&(LgHospID'=HospitalID)  ///多院区过滤
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s:CstRLoc["-" CstRLoc=$p(CstRLoc,"-",2)
	..s CstRLoc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CstRLoc)  /// 多语言支持
	..s CstRDate=$p(^DHCMDTCON(ID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCMDTCON(ID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCMDTCON(ID),"^",5)  /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstRUser=##class(web.DHCMDTCom).GetMulLanTrsDesc("User","",CstRUser)  /// 多语言支持
	..s CstTrePro=$p(^DHCMDTCON(ID),"^",6)    /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCMDTCON(ID),"^",7)   /// 会诊的理由和目的
	..s CstNDate=$p(^DHCMDTCON(ID),"^",8)     /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCMDTCom).DateLogicalToHtml(CstNDate)
	..s AppScDr = $p(^DHCMDTCON(ID),"^",18)   /// 资源表ID 
	..s PreTime=##Class(web.DHCMDTCom).JsMakResPreTime(AppScDr) /// 预约时间
	..s CstNTime=$p(^DHCMDTCON(ID),"^",9)     /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCMDTCON(ID),"^",10)   /// 会诊地点
	..s TreMeasures=$p(^DHCMDTCON(ID),"^",11) /// 最终治疗措施
	..s CstStatus=$p(^DHCMDTCON(ID),"^",12)   /// 状态ID
	..s:CstStatus'="" CstStatus=$p(^DHCMDTS(CstStatus),"^",2)
	..Q:(CstStatus="")||(CstStatus="撤销")||(CstStatus="完成")
	..Q:(HasCenter'=0)&(CstStatus="发送")
	..s CstUser=$p(^DHCMDTCON(ID),"^",13)     /// 联系人
	..s CstPhone=$p(^DHCMDTCON(ID),"^",14)    /// 联系电话
	..s McNotes=$p(^DHCMDTCON(ID),"^",24)     /// 备注yzy
	..s PrintFlag=$p(^DHCMDTCON(ID),"^",15)   /// 打印标志
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..Q:(mDisGrpID'="")&(mDisGrpID'=DisGrpID)
	..s DisGroup=$p(^DHCMDTG(DisGrpID),"^",2)
	..s RBResID=$p(^DHCMDTCON(ID),"^",17)       /// 资源ID
	..s mdtMakResID=$p(^DHCMDTCON(ID),"^",18)   /// 预约资源ID
	..s CstPrvArr="",CstLocArr=""
	..s CH=""
	..F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	...s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	...s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	...i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	...s CsUser=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CsUser) 
	...s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s:CsLocDesc["-" CsLocDesc=$p(CsLocDesc,"-",2)
	...s CsLocDesc=##class(web.DHCMDTCom).GetMulLanTrsDesc("Loc","",CsLocDesc) 
	...s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	...s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	..s PayMony =##Class(web.DHCMDTCom).GetConsIsPayMoney(ID)
	..s:PayMony=1 PayMony="Y" //"已收费"
	..s:PayMony=0 PayMony="N" //"未收费"
	..s DisGroup=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTGroup","MDDesc","",DisGroup)
	..s CstStatus=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTConsStatus","MDDesc","",CstStatus)
	..s Num=Num+1
	..s ListData=ID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	..s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstUser_"^"_CstPhone_"^"_CstLocArr_"^"_CstPrvArr_"^"_PrintFlag_"^"_DisGrpID_"^"_DisGroup
	..s ListData=ListData_"^"_CstStatus_"^"_PayMony_"^"_PreTime_"^"_PatientID_"^"_mdtMakResID
	..s TMPListData(Num)=ListData
	..
	
	///转换数据为Json格式
	s ListTitle="ID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUserID"
	s ListTitle=ListTitle_"^CstRUser^CstTrePro^CstPurpose^CstNDate^CstNTime^CstNPlace^CstUser^CstPhone^CstLocArr^CstPrvArr^PrintFlag^DisGrpID^DisGroup"
	s ListTitle=ListTitle_"^CstStatus^PayMony^PreTime^PatientID^mdtMakResID"
	s Del=""""
	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]"
	w "}"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   批量修改专家查询功能
/// InPut:      开始日期^结束日期^病种ID
/// OutPut:     
/// w ##Class(web.DHCMDTConsultQuery).JsGetBatModExpDet("25^24^23^22^20")
ClassMethod JsGetBatModExpDet(mdtIDs As %String) As %String
{
	n (mdtIDs,%session)

	k TmpArr
	s Num=0
	F i=1:1:$L(mdtIDs,"^") D
	.s ID=$p(mdtIDs,"^",i) Q:ID=""
	.s CH=""
	.F  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)          /// 科室ID
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	..s CareProv=""
	..s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",2)     /// 医生
	..s:CareProvID'="" CareProv=$p($g(^CTPCP(CareProvID,1)),"^",2)
	..Q:CareProvID=""
	..s PrvTpID="",PrvTp=""
	..s PrvTpID=+$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	..i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	..s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	..i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	..s DisGrpID=$p(^DHCMDTCON(ID),"^",16)    /// 疑难病种
	..s LocDesc=##class(web.DHCMDTCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	..s CareProv=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProv) 
	..s PrvTp=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",PrvTp)
	..s ListData="1"_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_TelPhone
	..s Num=Num+1
	..s TmpArr(CareProvID)=ListData

	s ListTitle="ID^LocID^LocDesc^UserID^UserName^PrvTpID^PrvTp^TelPhone"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2020-04-08
/// Descript:   批量修改专家查询功能：外院专家
/// InPut:      
/// OutPut:     
/// w ##Class(web.DHCMDTConsultQuery).JsGetBatModExpOutDet("82")
ClassMethod JsGetBatModExpOutDet(mdtIDs As %String) As %String
{
	n (mdtIDs,%session)
	k TmpArr
	s Num=0
	F i=1:1:$L(mdtIDs,"^") D
	.s ID=$p(mdtIDs,"^",i) Q:ID=""
	.s CsExpID="0"
	.F  s CsExpID=$o(^DHCMDTCOE(0,"ParRef",ID,CsExpID)) Q:CsExpID=""  D
	..s userID=$p(^DHCMDTCOE(CsExpID),"^",2)
	..Q:userID=""
	..q:'$d(^DHCMDTOUTEXP(userID))
	..s CareProvID=""
	..s CareProv=$p(^DHCMDTOUTEXP(userID),"^",2)   /// 姓名
	..s PrvTpID=$p(^DHCMDTOUTEXP(userID),"^",4)    /// 职称
	..s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	..s LocID=$p(^DHCMDTOUTEXP(userID),"^",6)      /// 科室ID
	..s LocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	..s TelPhone=$p(^DHCMDTOUTEXP(userID),"^",7)   /// 电话
	..s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)      /// 外院
	..Q:ParID=""
	..s HospDesc=$p(^DHCMDTDI(ParID),"^",2)        /// 外院
	..s:HospDesc'="" LocDesc=HospDesc_"-"_LocDesc
	..s IsConssignIn=##class(web.DHCMDTCom).UserIsConssignIn(CsExpID)
	..s CsDocRes=##Class(web.DHCMDTConsult).GetCsDocRes(CsExpID,userID) /// 取会诊医生的操作内容
	..i +CsDocRes=1 s AcceptFlag=1,RefReason=""
	..E  s AcceptFlag=0,RefReason=$p(CsDocRes,"^",2)
	..s LocDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCMDTDicItem","MDDesc","",LocDesc)
	..s PrvTp=##class(web.DHCMDTCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",PrvTp)
	..
	..s ListData=userID_"^"_CsExpID_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_TelPhone
	..s Num=Num+1
	..s OrdIndex=LocID_","_+PrvTpID_","_CareProv
	..s TmpArr(OrdIndex)=ListData

	s ListTitle="ID^CsExpID^LocID^LocDesc^UserID^UserName^PrvTpID^PrvTp^TelPhone"
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	s index="",Num=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)

	w ##class(web.DHCEMJsonCommon).getJsonEndSign() //输出json结尾符
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2020-07-06
/// Descript:     病种和科室的是否关联
/// InPut:        DisGrpID - 病种ID, LocID - 科室ID
/// OutPut:       
/// w ##Class(web.DHCMDTConsultQuery).isTakLocGroupRel("2","30")
ClassMethod isTakLocGroupRel(DisGrpID As %String, LocID As %String) As %String
{
	n (DisGrpID, LocID)
	s RelFlag=0
	s CH=""
	F  s CH=$o(^DHCMDTG(DisGrpID,"I",CH)) Q:(CH="")||(RelFlag=1)  D
	.Q:$p(^DHCMDTG(DisGrpID,"I",CH),"^",1)'=LocID
	.s RelFlag=1
	Q RelFlag
}

/// Descript:取会诊申请明细内容
/// w ##Class(web.DHCMDTConsultQuery).JsCstEmrAutItem("12","1")
ClassMethod JsCstEmrAutItem(CstID As %String, TakType = "") As %String
{
	n (CstID,TakType)
	s ListTitle="itmID^LocID^LocDesc^UserID^UserName^TakFlag^TakTime^TakOrdFlag^TakOrd"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s CH="",Num=0
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:CH=""  D
	.s LocDesc=""
	.s LocID=$p(^DHCMDTCON(CstID,"I",CH),"^",1)          /// 科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s CareProv=""
	.s CareProvID=$p(^DHCMDTCON(CstID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	.s UserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s ID=##Class(web.DHCMDTConsult).GetEmrAutID(CstID_"||"_CH,TakType)
	.s TakFlag=$s(ID'="":"Y",1:"N")
	.s TakTime=$p($g(^DHCMDTCEA(+ID)),"^",9)             /// 授权时间
	.i TakTime="" s TakTime=2
	.s:TakType=1 TakOrdFlag="1", TakOrd="病历"
	.s:TakType=2 TakOrdFlag="2", TakOrd="医嘱"
	.s ListData=CstID_"||"_CH_"^"_LocID_"^"_LocDesc_"^"_UserID_"^"_CareProv_"^"_TakFlag_"^"_TakTime_"^"_TakOrdFlag_"^"_TakOrd
	.s Num=Num+1
	.i Num=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	w ##class(web.DHCEMJsonCommon).getJsonEndConTotal(Num) //输出json结尾符
	Q ""
}

/// Descript:取会诊申请明细内容
/// w ##Class(web.DHCMDTConsultQuery).JsEmrAutDet("27")
ClassMethod JsEmrAutDet(rows As %String, page As %String, CstID As %String) As %String
{
	n (rows, page, CstID)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	k TMPArrList
	s CH="", Num=0
	F  s CH=$o(^DHCMDTCON(CstID,"I",CH)) Q:CH=""  D
	.s itmID=CstID_"||"_CH
	.s ID=""
	.F  s ID=$o(^DHCMDTCEA(0,"Cst",itmID,ID),-1) Q:ID=""  D
	..s itemID=$p(^DHCMDTCEA(ID),"^",1)    /// item
	..s UserID=$p(^DHCMDTCEA(ID),"^",2)    /// 授权人
	..s User=""
	..i UserID'="" s User=$p(^SSU("SSUSR",UserID),"^",2)
	..s LocID=$p(^DHCMDTCEA(ID),"^",3)     /// 授权给予科室
	..s LocDesc=""
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s mUser=""
	..s mUserID=$p(^DHCMDTCEA(ID),"^",4)   /// 授权给予医生
	..i mUserID'="" s mUser=$p(^SSU("SSUSR",mUserID),"^",2)
	..s StartDate=$p(^DHCMDTCEA(ID),"^",5) /// 开始日期
	..s StartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(StartDate)
	..s StartTime=$p(^DHCMDTCEA(ID),"^",6) /// 开始时间
	..s:StartTime'="" StartTime=$zt(StartTime,2)
	..s EndDate=$p(^DHCMDTCEA(ID),"^",7)   /// 结束日期
	..s TakFlag="N"
	..i EndDate>+$H s TakFlag="Y"
	..s EndTime=$p(^DHCMDTCEA(ID),"^",8)   /// 结束时间
	..i (EndDate=+$H)&(EndTime>$p($H,",",2)) s TakFlag="Y"
	..s EndDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EndDate)
	..s:EndTime'="" EndTime=$zt(EndTime,2)
	..s TakOrd=$p(^DHCMDTCEA(ID),"^",10)    /// 医嘱录入权限
	..s TakOrd=$case(TakOrd,1:"病历",2:"医嘱",:"")
	..s Num=Num+1
	..s ListData=itemID_"^"_LocDesc_"^"_mUser_"^"_StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_TakFlag_"^"_TakOrd
	..s TMPArrList(TakFlag_"^"_Num)=ListData
	.

	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""

	s ListTitle="itemID^LocDesc^mUser^StartDate^StartTime^EndDate^EndTime^TakFlag^TakOrd"
	w ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPArrList(index),-1) Q:index=""  D
	.s ListData=$g(TMPArrList(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.
	w ##class(web.DHCEMJsonCommon).getJsonEndSign()    //输出json结束符
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2020-10-09
/// Descript:     病种是否关联费用
/// InPut:        DisGrpID - 病种ID
/// OutPut:       0 - 无费用，1 - 有费用
/// w ##Class(web.DHCMDTConsultQuery).isTakOrder("2")
ClassMethod isTakOrder(DisGrpID As %String) As %String
{
	n (DisGrpID)
	Q:$d(^DHCMDTOC(0,"Group",DisGrpID)) 1
	Q 0
}

/// Creator:    lvpeng
/// CreateDate: 2021-04-08
/// Descript:   会诊模板打印内容
/// InPut:      CstID-会诊申请表ID
/// OutPut:     会诊申请打印内容
/// w ##Class(web.DHCMDTConsultQuery).GetMdtConsPrintCon("106")
ClassMethod GetMdtConsPrintModel(CstID As %String) As %String
{
	n (CstID)
	s CstPurpose=$p(^DHCMDTCON(CstID),"^",7)   /// 会诊的理由和目的
	q CstPurpose
}

/// Creator:    qqa
/// CreateDate: 2021-04-08
/// Descript:   打开病历界面获取InstanceID
/// InPut:      CstID-会诊申请表ID
/// OutPut:  w ##Class(web.DHCMDTConsultQuery).OpenEmrData("110")   
ClassMethod OpenEmrData(CstID)
{
	n (CstID)
	s EpisodeID=$p(^DHCMDTCON(CstID),"^",1)      /// 就诊ID
	s AppEpisodeID=$p(^DHCMDTCON(CstID),"^",20)   /// 预约就诊ID
	i AppEpisodeID'="" d
	.s AppAdmType=$p(^PAADM(+AppEpisodeID),"^",2)
	.q:AppAdmType'="I"
	.s EpisodeID=AppEpisodeID
	s MCInstanceDr=$p(^DHCMDTCON(CstID),"^",21)
	q EpisodeID_"^"_MCInstanceDr
}

/// Creator: 	 yangyongtao
/// CreateDate:  2020-03-30
/// Descript:    每个专家获取自己的意见
/// w ##Class(web.DHCMDTConsultQuery).getCstNOpinion("108||1")
ClassMethod getCstNOpinion(ItmID, Type = "", IsOutDoc = "N")
{
	n (ItmID,Type,IsOutDoc)
	q:ItmID="" ""
	s Opinion=""
	s CstID=+ItmID
	s:IsOutDoc="Y" CstID=$p(^DHCMDTCOE(+ItmID),"^",3)	;会诊主表ID
	s CH=$p(ItmID,"||",2)
	
	
	s Opinion=""
	i Type=1 d
	.s:IsOutDoc="Y" Opinion=$p(^DHCMDTCOE(+ItmID),"^",3)	;外院意见
	.s:IsOutDoc="N" Opinion=$p($g(^DHCMDTCON(+CstID,"I",CH)),"^",6)
	i Type'=1 d
	.s Opinion=$p(^DHCMDTCON(+CstID),"^",23)
	Q Opinion
}

/// w ##class(web.DHCMDTConsultQuery).GetMdtDiscuss(25,0)
ClassMethod GetMdtDiscuss(MdtID, Type)
{
	n (MdtID,Type)
	s DisProcess=""
	s:Type'=1 DisProcess=$p(^DHCMDTCON(MdtID),"^",23) 
	s:Type=1 DisProcess=##Class(web.DHCMDTConsultQuery).JsGetCsOpinion(MdtID)
	q DisProcess
}

/// Creator: 	 yangyongtao
/// CreateDate:  2020-03-30
/// Descript:    提取会诊意见
/// w ##Class(web.DHCMDTConsultQuery).JsGetCsOpinion("110")
ClassMethod JsGetCsOpinion(CstID As %String) As %String
{
	n (CstID)
	s CsOpinion=""
	//s CsOpinion=$p(^DHCMDTCON(CstID),"^",11) /// 会诊意见
	s ID=CstID
	s CH=""
	f  s CH=$o(^DHCMDTCON(ID,"I",CH)) Q:CH=""  D
	.s CsLocID=$p(^DHCMDTCON(ID,"I",CH),"^",1)       /// 会诊科室
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	.s CareProvID=+$p(^DHCMDTCON(ID,"I",CH),"^",2)
	.i CareProvID=0 s CareProvID=$p(^DHCMDTCON(ID,"I",CH),"^",3) 
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	.s CsUserID= $o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.S PrvTp=""
	.s PrvTpID=+$p(^DHCMDTCON(ID,"I",CH),"^",4)       /// 职称
	.i PrvTpID'=0 s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s Opinion=$p($g(^DHCMDTCON(CstID,"I",CH)),"^",6)
	.q:Opinion=""
	.s:Opinion'="" Opinion=CsLocDesc_""_CsUser_""_PrvTp_":"_Opinion
	.i CsOpinion="" s CsOpinion=Opinion
	.e  s CsOpinion=CsOpinion_"<br>"_Opinion
	
	s CsExpID="0"
	f  s CsExpID=$o(^DHCMDTCOE(0,"ParRef",ID,CsExpID)) q:CsExpID=""  d
	.s UserID=$p(^DHCMDTCOE(CsExpID),"^",2)
	.q:UserID=""
	.q:'$d(^DHCMDTOUTEXP(UserID))
	.s CareProvID=""
	.s CsUser=$p(^DHCMDTOUTEXP(UserID),"^",2)   /// 姓名
	.s PrvTpID=$p(^DHCMDTOUTEXP(UserID),"^",4)    /// 职称
	.s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	.s LocID=$p(^DHCMDTOUTEXP(UserID),"^",6)      /// 科室ID
	.s CsLocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	.s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)      /// 外院
	.q:ParID=""
	.s HospDesc=$p(^DHCMDTDI(ParID),"^",2)        /// 外院
	.s:HospDesc'="" CsLocDesc=HospDesc_"-"_CsLocDesc
	.s Opinion=$p(^DHCMDTCOE(CsExpID),"^",3)
	.q:Opinion=""
	.s:Opinion'="" Opinion=CsLocDesc_""_CsUser_""_PrvTp_":"_Opinion
	.i CsOpinion="" s CsOpinion=Opinion
	.e  s CsOpinion=CsOpinion_"<br>"_Opinion
	
	Q CsOpinion
}

/// w ##Class(web.DHCMDTConsultQuery).GetOutHospConsDoc("130")
ClassMethod GetOutHospConsDoc(ID)
{
	n (ID)
	s Ret=""
	s CsExpID="0"
	f  s CsExpID=$o(^DHCMDTCOE(0,"ParRef",ID,CsExpID)) Q:CsExpID=""  D
	.s UserID=$p(^DHCMDTCOE(CsExpID),"^",2)
	.q:UserID=""
	.q:'$d(^DHCMDTOUTEXP(UserID))
	.s UserName=$p(^DHCMDTOUTEXP(UserID),"^",2)   /// 姓名
	.s PrvTpID=$p(^DHCMDTOUTEXP(UserID),"^",4)    /// 职称
	.s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)
	.s LocID=$p(^DHCMDTOUTEXP(UserID),"^",6)      /// 科室ID
	.s LocDesc=$p($g(^DHCMDTDI(+LocID)),"^",2)
	.s TelPhone=$p(^DHCMDTOUTEXP(UserID),"^",7)   /// 电话
	.s ParID=$p($g(^DHCMDTDI(+LocID)),"^",6)      /// 外院
	.q:ParID=""
	.s HospDesc=$p(^DHCMDTDI(ParID),"^",2)        /// 外院	
	.s ItmData=HospDesc_LocDesc_PrvTp_UserName
	.s:Ret'="" Ret=Ret_"、"_ItmData
	.s:Ret="" Ret=ItmData
	q Ret
}

/// 
/// 是否开启了多屏幕
/// w ##Class(web.DHCMDTConsultQuery).IsOpenMoreScreen()
ClassMethod IsOpenMoreScreen()
{
	q 0
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDisGrpMap",pid)
	k ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtReqLocMap",pid)
	k ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtDocMap",pid)
	k ^TMP("DHCEM","web.DHCMDTConsultQuery","JsGetMdtMonthMap",pid)
	q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-04-15
/// Descript:	 医生
/// Input:       LocID - 科室ID
/// OutPut:      用户列表
/// w ##Class(web.DHCMDTCom).JsonLocCareProvAll("")
ClassMethod JsonLocCareProvAll(q) As %String
{
	n (q,%session)
	s q=$$ALPHAUP^SSUTIL4(q)
	s count=0
	w "["
	
	s UserID=0
	f  s UserID=$o(^SSU("SSUSR",UserID)) q:UserID=""  d
	.s CareProvID=$p(^SSU("SSUSR",UserID),"^",14)
	.s ProvTypeID=""
	.s:CareProvID'="" ProvTypeID=$p(^CTPCP(+CareProvID,1),"^",4)
	.q:$p(^CT("CPT",+ProvTypeID),"^",3)'="Y"
	.q:$p(^CT("CPT",+ProvTypeID),"^",4)'="DOCTOR"
	.s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	.s UserName=$p(^CTPCP(CareProvID,1),"^",2)   /// 用户名
	.s OtherName=$p($g(^CTPCP(CareProvID,3)),"^",28) /// 拼音
	.S UserName=##class(web.DHCMDTCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",UserName)
	.s UserNamecode=##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(UserName))
	.q:(q'="")&(UserNamecode'[q)
	.s tmp=UserID_"^"_UserName
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

}
