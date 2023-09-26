Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-01-04
/// Descript: 	会诊申请
Class web.DHCEMConsultQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCEMConsultQuery).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID, %session)
	q:(+PatientID=0)&&(+EpisodeID=0) "[]"
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatSexCh=PatSex
	s PatSex=##class(web.DHCEMConsultCom).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)  /// 多语言支持
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay) //hxy 2017-03-03 $zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	;s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) /// 诊断
	s PatDiagDesc=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.diag.GetAdmDiagDesc",EpisodeID, "", "")
	i $L(PatDiagDesc)>80 s PatDiagDesc=$E(PatDiagDesc,1,50)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	  /// 就诊类型
 	//s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	//i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	;s:(PatBed'["床")&&(PatBed'="") PatBed=PatBed_"床"
	s BillType=##class(web.DHCDoc.OP.AjaxInterface).GetAdmReason(EpisodeID) ;$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	;s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s AdmReason=""
	s PAADMAdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	s:PAADMAdmReasonDR'="" AdmReason=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s MrNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID) //hxy 2021-06-23 病案号
	
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_BillType
	s ListData=ListData_"^"_AdmReason_"^"_MrNo_"^"_PatSexCh
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^PatType^PatSLv^PatLv^mradm^PatBed^PatBill^AdmReason^MrNo"
	s ListTitle=ListTitle_"^PatSexCh"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCEMConsultQuery).JsGetCstNoObj("564||1")
ClassMethod JsGetCstNoObj(ItmID, Param = "") As %String
{
	n (ItmID, Param, %session)
	s IsMain=$p(Param,"^",2) /// 会诊申请界面Main标志 2021-06-16
	
	s CstID=+ItmID
	Q:'$D(^DHCEMCON(CstID)) "{}"
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	s PatientID = $p(^PAADM(+EpisodeID),"^",1)
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	 /// 就诊类型
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CsHospID=$p(^CTLOC(CstRLocID),"^",22)  /// 医院ID
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	//s:CstRDate'="" CstRDate=$zd(CstRDate,3)
	s:CstRDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	s CstType=$p(^DHCEMCDI(CstTypeID),"^",2) /// 会诊类型
	s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	//s:CstNDate'="" CstNDate=$zd(CstNDate,3)
	s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	s IsPerAccFlag=##Class(web.DHCEMConsult).IsPermitAccept(CstID) /// 是否允许接受申请单
	s:IsMain=1 IsPerAccFlag=1 //会诊申请界面Main不允许接收 2021-06-16
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	s isExiHosFlag=..isExistCsItm("HOS",CstUnit,CsHospID)
	s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	s ShareFlag=$p(^DHCEMCON(CstID),"^",30)  /// 是否共享
	s MoreFlag=$p(^DHCEMCON(CstID),"^",31)   /// 多科标志
	s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	s CstGrpID=$p($g(^DHCEMCON(CstID,"I",1)),"^",12)   /// 会诊小组
	s CsEvaRFlag=$p(^DHCEMCON(CstID),"^",39)   /// 评价满意度
	s CsEvaRDesc=$p(^DHCEMCON(CstID),"^",40)   /// 评价内容
	s AgreeFlag=$p(^DHCEMCON(CstID),"^",35)    /// 是否同意用药
	s CsEvaRID=""
	i CsEvaRDesc'=""  d
    .s CsEvaRDesc=$$ALPHAUP^SSUTIL4(CsEvaRDesc)
    .s CsEvaRDesc=$e(CsEvaRDesc,1,245)
    .s CsEvaRID=$o(^DHCEMCDI(0,"Desc",CsEvaRDesc,""))
    s ArrDate=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",18) //hxy 2021-03-31 st
	s ArrTime=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",19)
    s:ArrDate'="" ArrDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(ArrDate)
	s:ArrTime'="" ArrTime = $zt(ArrTime,1) //ed
	s ItmCH=$p(ItmID,"||",2)
	s WriFlag=$p(Param,"^",1) //hxy 2021-03-09 st
	s:(WriFlag="Y")&&(MoreFlag="Y") ItmID=CstID //ed
	s CsEvaFlag="",CsEvaDesc="",CsEvaID="",CmpDate="",CmpTime=""
	i (ItmID["||")&((MoreFlag="Y")||(CstOutFlag'="Y")) D
	.s CmpDate=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",16) 
	.s CmpTime=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",17) 
	.s:CmpDate'="" CmpDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CmpDate)
	.s:CmpTime'="" CmpTime = $zt(CmpTime,1)
	.s Opinion=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",4)     /// 会诊意见
	.i Opinion="" s Opinion=TreMeasures
    .s CsEvaFlag=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",14)  /// 评价满意度
    .s CsEvaDesc=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",15)  /// 评价内容
    .s CsEvaID=""
    .i CsEvaDesc'="" d
    ..s CsEvaDesc=$$ALPHAUP^SSUTIL4(CsEvaDesc)
    ..s CsEvaDescCut=$e(CsEvaDesc,1,245)
    ..s:CsEvaDescCut=CsEvaDesc CsEvaID=$o(^DHCEMCDI(0,"Desc",CsEvaDesc,""))
	E  D
	.s:ItmCH="" ItmCH=$o(^DHCEMCON(CstID,"I",""))
	.s CmpDate=$p($g(^DHCEMCON(CstID,"I",ItmCH)),"^",16) 
	.s CmpTime=$p($g(^DHCEMCON(CstID,"I",ItmCH)),"^",17) 
	.s:CmpDate'="" CmpDate = ##class(web.DHCEMCommonUtil).DateLogicalToHtml(CmpDate)
	.s:CmpTime'="" CmpTime = $zt(CmpTime,1)
	.s Opinion=##Class(web.DHCEMConsultQuery).JsGetCsOpinion(CstID)
	.s CsEvaFlag=$p($g(^DHCEMCON(CstID,"I",ItmCH)),"^",14)  /// 评价满意度
    .s CsEvaDesc=$p($g(^DHCEMCON(CstID,"I",ItmCH)),"^",15)  /// 评价内容
    .s CsEvaID=""
    .i CsEvaDesc'="" s CsEvaID=$o(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(CsEvaDesc),""))
	s isOpiEditFlag=..GetOpiEditFlag(ItmID)    /// 会诊结论是可编辑
	s CstStatus=..GetCstCurStat(ItmID)         /// 取会诊记录的当前状态值
	s CstEcType = $p(^DHCEMCON(CstID),"^",19)
	s CsPropID = $p(^DHCEMCON(CstID),"^",45)   /// 会诊性质
	s IsWFCompFlag=##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(CstID)   /// 工作流是否已经审核完
	s InstanceID=$p(^DHCEMCON(CstID),"^",51)   /// 病历实例ID
	s CstRLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)
	s CstRUser=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CstRUser)
	s CstDocName=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CstDocName)
	s CstType=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",CstType)
	s CstNPlace=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CstNPlace) //此处可不加
    s ListData=EpisodeID_"^"_PatientID_"^"_PatType_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime_"^"_CstTypeID_"^"_CstType
    s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_isExiHosFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_ShareFlag_"^"_Opinion_"^"_TreMeasures_"^"_CstGrpID_"^"_isOpiEditFlag
    s ListData=ListData_"^"_CsEvaRID_"^"_CsEvaRFlag_"^"_CsEvaRDesc_"^"_CsEvaID_"^"_CsEvaFlag_"^"_CsEvaDesc_"^"_CstStatus_"^"_MoreFlag_"^"_CsHospID_"^"_IsPerAccFlag_"^"_CstEcType_"^"_AgreeFlag_"^"_CmpDate
    s ListData=ListData_"^"_CmpTime_"^"_CsPropID_"^"_ArrDate_"^"_ArrTime_"^"_IsWFCompFlag_"^"_InstanceID
	s ListTitle="EpisodeID^PatientID^PatType^CstRLocID^CstRLoc^CstRDate^CstRTime^CstUserID^CstRUser^CstTrePro^CstPurpose^CstNDate^CstNTime^CstTypeID^CstType"
	s ListTitle=ListTitle_"^CstNPlace^CstEmFlag^CstOutFlag^isExiHosFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^ShareFlag^CstOpinion^TreMeasures^CstGrpID^isOpiEditFlag"
	s ListTitle=ListTitle_"^CsEvaRID^CsEvaRFlag^CsEvaRDesc^CsEvaID^CsEvaFlag^CsEvaDesc^CstStatus^CstMorFlag^CsHospID^IsPerAccFlag^CstEcType^AgreeFlag"
	s ListTitle=ListTitle_"^CmpDate^CmpTime^CsPropID^ArrDate^ArrTime^IsWFCompFlag^InstanceID"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-09-26
/// Descript:    提取会诊意见
/// w ##Class(web.DHCEMConsultQuery).JsGetCsOpinion("")
ClassMethod JsGetCsOpinion(CstID As %String) As %String
{
	n (CstID)
	
	s CsOpinion=""
	//s CsOpiFlag=..GetCsOpiFlag(CstID) 		 /// 提取会诊意见标志
	//i CsOpiFlag="Y" s CsOpinion=$p(^DHCEMCON(CstID),"^",34) /// 会诊意见
	s CsOpinion=$p(^DHCEMCON(CstID),"^",17) /// 会诊意见
	Q:CsOpinion'="" CsOpinion
	
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s CareProv=""
	.s CareProvID = $p(^DHCEMCON(CstID,"I",CH),"^",3) //hxy 2021-03-04 st
	.s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2) /// 医生	
	.;s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生 //ed
	.s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	.s Opinion=$p($g(^DHCEMCON(CstID,"I",CH)),"^",4)
	.Q:Opinion=""
	.s:CareProv'="" CareProv=CareProv_"：" //hxy 2021-05-07 院际多冒号
	.i CsOpinion="" s CsOpinion=CareProv_Opinion ;Opinion //hxy 2021-03-04 注释代码和应用代码调换位置 //_"："
	.E  s CsOpinion=CsOpinion_";<br>"_CareProv_Opinion ;Opinion //hxy 2021-03-04 注释代码和应用代码调换位置 //_"："
	Q CsOpinion
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-09-26
/// Descript:    提取会诊意见标志
/// Output:      Y-从主表提取会诊意见, N-从子表提取
/// w ##Class(web.DHCEMConsultQuery).GetCsOpiFlag("")
ClassMethod GetCsOpiFlag(CstID As %String) As %String
{
	n (CstID)
	s CsOpiFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	Q CsOpiFlag
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-09-30
/// Descript:    会诊结论是可编辑
/// Output:      Y-从主表提取会诊意见, N-从子表提取
/// w ##Class(web.DHCEMConsultQuery).GetOpiEditFlag("")
ClassMethod GetOpiEditFlag(ItmID As %String) As %String
{
	n (ItmID)
	s LgID="",ID=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",ItmID,LgID),-1) Q:(LgID="")||(ID'="")  D
	.s ID=$p(^DHCEMCONL(LgID),"^",3)        /// 状态
	.
	s IsOpenAccStatus=##Class(web.DHCEMConsultCom).IsOpenAccStatus()
	i ID="" D
	.s ID=$p(^DHCEMCON(+ItmID),"^",18)
	Q:($LF($LISTFROMSTRING("30,40,51"),$p($g(^DHCEMCONS(+ID)),"^",1)))&&(IsOpenAccStatus="Y") "Y"
	Q:($LF($LISTFROMSTRING("20,40,51"),$p($g(^DHCEMCONS(+ID)),"^",1)))&&(IsOpenAccStatus'="Y") "Y"
	Q "N"
}

/// Descript:取会诊申请明细内容
/// w ##Class(web.DHCEMConsultQuery).JsonQryConsult("","1")
ClassMethod JsonQryConsult(CstID As %String, GrpID As %String, LgParams = "") As %String
{
	n (CstID, GrpID ,LgParams, %session)
	k TMPPisSpecArr
	s LgUser=$p(LgParams,"^",4)
	s CstEcType=$p($g(^DHCEMCON(+CstID)),"^",19)   /// 会诊类型 2021-06-17
	
	s CH="",Num=0
	i CstID'="" D
	.F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)          /// 科室ID
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s CareProv=""
	..s CareProvID = $p(^DHCEMCON(CstID,"I",CH),"^",3)
	..s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生
	..s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	..s PrvTpID="",PrvTp=""
	..s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)       /// 职称
	..i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	..s SubMarID=$p(^DHCEMCON(CstID,"I",CH),"^",13)      /// 亚专业
	..s SubMar=$p($g(^DHCEMCDI(+SubMarID)),"^",2)
	..s LocGrpID=$p(^DHCEMCON(CstID,"I",CH),"^",12)      /// 专科小组
	..s LocGrp=$p($g(^DHCEMCG(+LocGrpID)),"^",2)         /// 专科小组
	..s isGrpFlag=##Class(web.DHCEMConsultCom).isExistUnGrpLoc(LocGrpID)
	..s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	..i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	..s LeadEditFlag=1 //医生大科修改标志 2021-06-17 st
	..s GrpLead=$p($g(^DHCEMCG(+LocGrpID)),"^",5) ///医生大科组长
	..s:(CstEcType["DOC")&&(LgUser'=GrpLead) LeadEditFlag=0 //ed
	..s PrvTp=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",PrvTp)
	..s LocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	..s CareProv=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProv)
	..s ListData=CstID_"||"_CH_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^"_SubMarID_"^"_SubMar_"^"_TelPhone_"^"_LocGrpID_"^"_LocGrp_"^"_isGrpFlag_"^"_LeadEditFlag
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData

	i GrpID'="" D
	.F  s CH=$o(^DHCEMCG(GrpID,"G",CH)) Q:CH=""  D
	..s LocDesc=""
	..s LocID=$p(^DHCEMCG(GrpID,"G",CH),"^",1)           /// 科室ID
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s CareProv=""
	..s UserID=$p(^DHCEMCG(GrpID,"G",CH),"^",2)          /// 用户ID
	..q:(LgUser'="")&&(LgUser=UserID)
	..s CareProvID=$p($g(^SSU("SSUSR",+UserID)),"^",14)  /// 医生
	..s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	..s PrvTpID="",PrvTp=""
	..s PrvTpID=$p($g(^CTPCP(+CareProvID,1)),"^",4)      /// 职称
	..i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	..s DefFlagID=$p(^DHCEMCG(GrpID,"G",CH),"^",4)       /// 默认标识
	..Q:DefFlagID'="Y"
	..s TelPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	..i TelPhone="" s TelPhone=..GetLocTelPhone(LocID)   /// 科室电话
	..s GrpDesc=$p(^DHCEMCG(GrpID),"^",2)                /// 专科小组
	..s PrvTp=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",PrvTp)
	..s LocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	..s CareProv=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProv)
	..s ListData=""_"^"_LocID_"^"_LocDesc_"^"_CareProvID_"^"_CareProv_"^"_PrvTpID_"^"_PrvTp_"^^^"_TelPhone_"^"_GrpID_"^"_GrpDesc_"^"
	..s Num=Num+1
	..s TMPPisSpecArr(Num)=ListData
	
	i (GrpID'="")&(Num=0) D
	.s GrpDesc=$p(^DHCEMCG(GrpID),"^",2)                /// 专科小组
	.s ListData=""_"^^^^^^^^^^"_GrpID_"^"_GrpDesc
	.s Num=Num+1
	.s TMPPisSpecArr(Num)=ListData
	i 2>Num d
	.s Len=2-Num
	.f i=1:1:Len d
	..s Num=Num+1
	..s TMPPisSpecArr("Z"_i)=""

	s ListTitle="itmID^LocID^LocDesc^UserID^UserName^PrvTpID^PrvTp^MarID^MarDesc^TelPhone^LocGrpID^LocGrp^isGrpFlag^LeadEditFlag"
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

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCEMConsultQuery).JsGetConsAudit("10","1","05/09/2018^27/09/2018^^^^")
ClassMethod JsGetConsAudit(rows As %String, page As %String, Params As %String) As %String
{
	n (rows, page, Params, %session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-1
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s argLocID=$p(Params,"^",3)    /// 请会诊科室
	s argPatNo=$p(Params,"^",4)    /// 登记号
	s argCstType=$p(Params,"^",5)  /// 会诊类型
	s argAudit=$p(Params,"^",6)    /// 审核状态
	s argCsType=$p(Params,"^",7)   /// 会诊单据类型
	s LgUserID=$p(Params,"^",8)    /// 用户
	s LgGroupID=$p(Params,"^",10)  /// 安全组  
	s LgLocID=$p(Params,"^",11)    /// 科室
	s LgParams=LgGroupID_"^"_LgLocID_"^"_LgUserID
	s LgHospID=$p(Params,"^",12)   /// 医院

	k TmpArr
	D ##Class(web.DHCEMConsultWorkFlow).GetUserGrant(LgParams, .TmpArr, 1) /// 用户权限
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..Q:$p(^DHCEMCON(CstID),"^",18)=""            /// 申请状态
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..s CstHospID=$p(^CTLOC(CstRLocID),"^",22)
	..s WFID=##Class(web.DHCEMConsultWorkFlow).GetCsWorkFlow(CstID,CstHospID)
	..Q:'$d(TmpArr(+WFID))
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	..q:(AdmHospID'=LgHospID)
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(argPatNo'="")&(argPatNo'=PatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	..s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ..i PatBed'["床" s PatBed=PatBed_"床"
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	..;s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	..s PatDiagDesc = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.diag.GetAdmDiagDesc",EpisodeID, "", "")
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..Q:(argLocID'="")&(argLocID'=CstRLocID)
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstRUserID=$p(^DHCEMCON(CstID),"^",5)  /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstRUserID)),"^",2)
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	..Q:(argCsType'="")&($p(^DHCEMCON(CstID),"^",19)'=$zcvt(argCsType,"U")) /// 会诊单据类型
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	..s OneOrMore=$p(^DHCEMCON(CstID),"^",31)  /// 是否多科
	..s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	..Q:(argCstType'="")&(argCstType'=CstTypeID)
	..s CstType=$p(^DHCEMCDI(CstTypeID),"^",2) /// 会诊类型
	..s isCsAuditFlag=##Class(web.DHCEMConsultCom).isCsAudit(CstTypeID)
	..//Q:(CstOutFlag'="Y")&(OneOrMore'="Y")&('isCsAuditFlag)
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	..s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	..s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	..s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	..s RefAuditFlag=..GetCsRefAuditFlag(CstID_"||1") /// 会诊是否驳回
	..s CstUserID=$p(^DHCEMCON(CstID),"^",14)    /// 审核人
	..s isTakFlag=##Class(web.DHCEMConsultWorkFlow).isTakFlag(CstID, LgParams)
	..//Q:(((argAudit="Y")&(isTakFlag=0))||((argAudit="N")&(isTakFlag=1)))
	..s EcType=$p($g(^DHCEMCON(+CstID)),"^",19)  /// 会诊类型
	..s LeadConFlag="",NextStCode=""  //会诊大科审核标志,下一个工作流状态 2021-06-22 st
	..s LeadFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("LEADERFLAG",CstHospID)  //大科是否启用配置标志
	..i (LeadFlag=1)&&(EcType="DOC")&&(CstOutFlag'="Y")  d
	...s LeadConFlag=..GetLeadConFlag(WFID,LgParams)
	...s:LeadConFlag=1 NextStCode=..GetNextStCode(CstID, CstHospID) //医生会诊启用大科时取下一个状态 (大科审核的特殊性:全部大科审核后才算审核完成)
	..Q:(((argAudit="Y")&(isTakFlag'=1)&(NextStCode'=75))||((argAudit="N")&(isTakFlag'=2)))
	..;Q:(((argAudit="Y")&(isTakFlag'=1))||((argAudit="N")&(isTakFlag'=2))) //ed
	..s AuditFlag=$s((isTakFlag=1)||(RefAuditFlag=1):"已审",1:"待审")  /// 审核状态
	..s CstStatus=..GetCstCurStat(CstID)             /// 取会诊记录的当前状态值
	..Q:(CstStatus="取消")&(RefAuditFlag'=1)
	..s AccpTime=..GetCstNodeTime(CstID_"||1","30")  /// 接收时间
	..s CompTime=..GetCstNodeTime(CstID_"||1","50")  /// 完成时间
	..s PrintFlag=$p(^DHCEMCON(CstID),"^",37)   /// 打印标志
	..s CstPrvArr="",CstLocArr="",LeadUsers="",LeadAudUsers="",LeadAll="" //医生大科的待审组长,已审组长,所有组长
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CareProvID=+$p(^DHCEMCON(CstID,"I",CH),"^",2)
	...i CareProvID=0 s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)       /// 会诊医生
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)        /// 会诊科室
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s CsUser=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CsUser)
	...s CstRLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)
	...s CstPrvArr=$s(CstPrvArr="":CsUser,1:CstPrvArr_"、"_CsUser)
	...s CstLocArr=$s(CstLocArr="":CsLocDesc,1:CstLocArr_"、"_CsLocDesc)
	...s GrpID=$p(^DHCEMCON(CstID,"I",CH),"^",12)        /// 医生大科 //hxy 2021-06-16 st
	...s GrpLeadDr=$p($g(^DHCEMCG(+GrpID)),"^",5)        /// 医生大科组长
	...s ItmSta=$p(^DHCEMCON(CstID,"I",CH),"^",6)        /// 子表状态
	...s ItmStaCode=$p($g(^DHCEMCONS(+ItmSta)),"^",1)    /// 子表状态Code
	...i (LeadConFlag=1)&&(GrpLeadDr'="") d
	....i (NextStCode=75)&&(ItmStaCode'=75) d
	.....s:LeadUsers'="" LeadUsers=LeadUsers_GrpLeadDr_"*"
	.....s:LeadUsers="" LeadUsers="*"_GrpLeadDr_"*"
	....i (NextStCode=75)&&(ItmStaCode=75) d
	.....s:LeadAudUsers'="" LeadAudUsers=LeadAudUsers_GrpLeadDr_"*"
	.....s:LeadAudUsers="" LeadAudUsers="*"_GrpLeadDr_"*"
	.....s:GrpLeadDr=LgUserID AuditFlag=AuditFlag_"(本人已审)"
	....s:LeadAll'="" LeadAll=LeadAll_GrpLeadDr_"*"
	....s:LeadAll="" LeadAll="*"_GrpLeadDr_"*"
	..q:(LeadAll'="")&&(LeadAll'[("*"_LgUserID_"*"))&&(argAudit="Y")
	..q:(NextStCode=75)&&(LeadAudUsers'[("*"_LgUserID_"*"))&&(argAudit="Y")
	..q:(NextStCode=75)&&(LeadUsers'[("*"_LgUserID_"*"))&&(argAudit="N") //ed 75:大科审核
	..i CstOutFlag="Y" s CstLocArr=CstDocName
	..s OrdIndex=$case(CstEmFlag,"Y":1,:"2")
	..s PatName=##class(web.DHCEMConsultCom).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
	..s PatSex=##class(web.DHCEMConsultCom).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	..s PatLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc)
	..s CstRLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CstRLoc)
	..s PatWard=##class(web.DHCEMConsultCom).GetTransDesc("User.PACWard","WARDDesc","",PatWard)
	..s CstType=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsDicItem","ECDesc","",CstType)
	..s CstRUser=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CstRUser)
	..s CstUser=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CstUser)
	..s CstStatus=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",CstStatus)
	..s Num=Num+1
	..s ListData=CstID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	..s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser
	..s ListData=ListData_"^"_CstPhone_"^"_CstType_"^"_CstLocArr_"^"_CstPrvArr_"^"_AuditFlag_"^"_CstStatus_"^"_AccpTime_"^"_CompTime_"^"_PrintFlag_"^"_NextStCode
	..s TMPListData(OrdIndex,Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="CstID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUserID^CstRUser^CstTrePro^CstPurpose"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstType^CstLocArr^CstPrvArr^AuditFlag^CstStatus^AccpTime^CompTime^PrintFlag^NextStCode"

	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s ordIndex="",count=0
	F  s ordIndex=$o(TMPListData(ordIndex)) Q:ordIndex=""  D
	.s index=""
	.F  s index=$o(TMPListData(ordIndex,index),-1) Q:index=""  D
	..s ListData=$g(TMPListData(ordIndex,index))
	..Q:ListData=""
	..s count = count+1
	..Q:(count<Start)||(count>End)
	..i count=Start D
	...W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	..E  D
	...W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCEMConsultQuery).JsonGetConList("30","1","^^^^12192^41^R^^0")
ClassMethod JsonGetConList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
    s CstTypeID=$p(Params,"^",3) /// 状态ID
    s CstType=$p($g(^DHCEMCONS(+CstTypeID)),"^",2)
    i StartDate="" s StartDate=+$H-1
    i EndDate="" s EndDate=+$H
    s LgUserID=$p(Params,"^",5)  /// 登录人
    s LgCPrvID=$p($g(^SSU("SSUSR",LgUserID)),"^",14)
    s LgLocID=$p(Params,"^",6)   /// 登录科室
    s QryType=$p(Params,"^",7)   /// 查询类型
    s argPatNo=$p(Params,"^",8)  /// 登记号
    s IsFiltPrvTpFlag=$p(Params,"^",9) /// 是否按职称级别过滤
    s RListByLoc=$p(Params,"^",10)     /// 会诊处理-申请列表默认查看本科室
    s EpisodeHtml=$p(Params,"^",11)    /// 会诊申请界面-申请历史 hxy 2021-06-15
    s Nature=$p(Params,"^",12)         /// 会诊性质 hxy 2022-06-23
    s DeEpisodeHtml=$p(Params,"^",13)  /// 会诊处理界面-按就诊
    k TMPListData
    s Num=0, CsHanNum=0, del=""""
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)       /// 就诊ID
	..q:EpisodeID=""
	..q:(DeEpisodeHtml'="")&(DeEpisodeHtml'=EpisodeID)
	..q:(EpisodeHtml'="")&(EpisodeHtml'=EpisodeID) //hxy 2021-06-15 st
	..s CstStaID=$p(^DHCEMCON(CstID),"^",18)           ///主表会诊状态ID
	..s CstStaCode=$p($g(^DHCEMCONS(+CstStaID)),"^",1) ///主表会诊状态code
	..q:(EpisodeHtml'="")&(CstStaCode'="")&(CstStaCode'=20) //ed
	..s CsPropID=$p(^DHCEMCON(CstID),"^",45)      /// 会诊性质 //hxy 2022-06-23 st
	..q:(Nature'="")&(Nature'=CsPropID) //ed
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	..Q:(argPatNo'="")&(argPatNo'=PatNo)
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)  /// 床号
	..s CsRLocID=$p(^DHCEMCON(CstID),"^",2)        /// 申请科室
	..s CsRLoc=$p($g(^CTLOC(CsRLocID)),"^",2)
	..s CstHospID=$p(^CTLOC(CsRLocID),"^",22)	   /// 申请科室的医院
	..s LgHospID=$p(^CTLOC(LgLocID),"^",22)      
	..q:CstHospID'=LgHospID
	..s CsRDate=$p(^DHCEMCON(CstID),"^",3)         /// 申请日期
	..s:CsRDate'="" CsRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CsRDate)
	..s CsRTime=$p(^DHCEMCON(CstID),"^",4)         /// 申请时间
	..s:CsRTime'="" CsRTime=$zt(CsRTime,2)
	..s CsRUserID=$p(^DHCEMCON(CstID),"^",5)       /// 申请医生
	..//Q:(QryType="R")&(LgUserID'=CsRUserID)
	..s CsRUser=$p($g(^SSU("SSUSR",CsRUserID)),"^",2)
	..s CsEmFlag=$p(^DHCEMCON(CstID),"^",23)       /// 是否加急
	..s CsEmFlag=$s(CsEmFlag="Y":"加急",1:"普通")
	..s CsOutFlag=$p(^DHCEMCON(CstID),"^",24)      /// 是否院外
	..s CsAUserID=$p(^DHCEMCON(CstID),"^",14)      /// 审核人
	..s StateFlag=$p(^DHCEMCON(CstID),"^",18)      /// 申请状态
	..s CsCategory=$p(^DHCEMCON(CstID),"^",19)     /// 会诊类型
	..s CstTypeDesc=""
	..s CstTypeDr=$p(^DHCEMCON(CstID),"^",8)       /// 会诊类型
	..s:CstTypeDr'="" CstTypeDesc=$p($g(^DHCEMCDI(CstTypeDr)),"^",2)
	..//s isCsAuditFlag=##Class(web.DHCEMConsultCom).isCsAudit(CstTypeDr)
	..Q:(QryType="C")&(StateFlag="")
	..s MoreFlag=$p(^DHCEMCON(CstID),"^",31)       /// 多科
	..s WFID=##Class(web.DHCEMConsultWorkFlow).GetCsWorkFlow(CstID,CstHospID) /// 当前会诊的工作流ID
	..s isWFCompFlag=##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(CstID,CstHospID) /// 当前会诊工作流是否已经审核完
	..Q:(QryType="C")&(isWFCompFlag'="Y")
	..//Q:(QryType="C")&((CsAUserID="")&(MoreFlag="Y")||((CsAUserID="")&(MoreFlag'="Y")&isCsAuditFlag))
	..s PrintFlag=$p(^DHCEMCON(CstID),"^",37)      /// 打印标志
	..s CH="",CHNum=0 //hxy 2021-04-19
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s MulStr="" //st
	...s:(MoreFlag="Y")&(QryType="R") MulStr=..GetMulStr(CstID) ///主表取全部会诊科室^会诊人^会诊状态
	...;Q:(CH>1)&(MoreFlag="Y")&(QryType="R") //hxy 2021-01-21 多科会诊申请列表只显示一个 ed //2021-03-12 注释此行，位置下移,影响了计数
	...s CPrvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)  /// CT_CareProv ID
	...i CPrvID="" s CPrvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	...s CsCUser=$p($g(^CTPCP(+CPrvID,1)),"^",2)   /// 会诊医生
	...;Q:(QryType="C")&(CPrvID'="")&(CPrvID'=LgCPrvID)
	...Q:(QryType="C")&(CPrvID'="")&(CPrvID'=LgCPrvID)&(RListByLoc'=1) //CLISTBYLOC会诊列表查看本科已处理时不按人过滤
	...s CsCLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1) /// CT_Loc ID
	...s SamLocTypeFlag=..isSameLocType(LgLocID,CsCLocID)  /// 判断两个科室是否属于同一类型
	...Q:(QryType="C")&(CsCLocID'=LgLocID)&(SamLocTypeFlag'="Y")
	...s CsCLoc=$p($g(^CTLOC(+CsCLocID)),"^",2)     /// 会诊科室
	...s CsStatCode=..GetCstCurStat(CstID_"||"_CH)  /// 取会诊记录的当前状态值
	...Q:(CstType="")&(CsStatCode="取消")
	...q:(CstType="")&(CsStatCode="驳回")&(QryType="C")
	...s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11) 
	...Q:(QryType="C")&(CPrvID="")&(PrvTpID'="")&(IsFiltPrvTpFlag=1)&($p(^CTPCP(LgCPrvID,1),"^",4)'=PrvTpID)
	...s LgPrvTpID=$p(^CTPCP(LgCPrvID,1),"^",4) //hxy 2021-03-17 st
	...s IsEqHigherPrvTp=..IsEqHigherPrvTp(PrvTpID,LgPrvTpID)
	...Q:(QryType="C")&(CPrvID="")&(PrvTpID'="")&(IsFiltPrvTpFlag=2)&('IsEqHigherPrvTp) //ed
	.../// 计算会诊列表待处理申请数
	...///i (QryType="C")&((CsStatCode="发送")||(CsStatCode="审核")) s CsHanNum=CsHanNum+1
	...s TrFlag=0
	...i (PrvTpID'="")&(IsFiltPrvTpFlag=2)&('IsEqHigherPrvTp) s TrFlag=1   /// 职称过滤条件 hxy 2021-03-17 
	...i (PrvTpID'="")&(IsFiltPrvTpFlag=1)&($p(^CTPCP(LgCPrvID,1),"^",4)'=PrvTpID) s TrFlag=1   /// 职称过滤条件 
	...i (((CPrvID'="")&(CPrvID=LgCPrvID)&(CsCLocID=LgLocID))||((CPrvID="")&((CsCLocID=LgLocID)||(SamLocTypeFlag="Y"))&(TrFlag'=1))) D   /// 用户、科室、职称
	....i ((CsStatCode="发送")&(WFID=""))||((isWFCompFlag="Y")&(WFID'="")&('..IsTakAccept(CstID_"||"_CH,30))&(CsStatCode'="驳回")&(CsStatCode'="")&(CsStatCode'="取消")) s CsHanNum=CsHanNum+1
	...;Q:(QryType="R")&(LgUserID'=CsRUserID) //hxy 2021-03-09 st
	...Q:(QryType="R")&(LgUserID'=CsRUserID)&(RListByLoc'=1)
	...Q:(QryType="R")&(LgUserID=CsRUserID)&(RListByLoc'=1)&(LgLocID'=CsRLocID) //hxy 2021-05-13 add由看本人改为看本人本科：配置(医嘱医嘱接收科室 1:会诊科室,2:申请科室,默认:当前登录科室)默认时会有问题
	...Q:(QryType="R")&(LgLocID'=CsRLocID)&(RListByLoc=1) //ed
	...Q:(CstType'="")&(CstType'=CsStatCode)
	...s CHNum=CHNum+1 //hxy 2021-04-19 st
	...Q:(CHNum>1)&(MoreFlag="Y")&(QryType="R") //hxy 2021-01-21 多科会诊申请列表只显示一个
	...;Q:(CH>1)&(MoreFlag="Y")&(QryType="R") //hxy 2021-01-21 多科会诊申请列表只显示一个 //ed
	...i CsOutFlag="Y" s CsCLoc="院际会诊"
	...s CsSurTime=..GetCsSurTime(CstID_"||"_CH)            /// 会诊剩余时间
	...s Num=Num+1
	...s CsRLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CsRLoc)
	...s CsRUser=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CsRUser)
	...s CsCLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CsCLoc)
	...s CsCUser=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CsCUser)
	...s CsStatCode=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",CsStatCode)
	...s ListData=CstID_"^"_CstID_"||"_CH_"^"_EpisodeID_"^"_PatName_"^"_PatNo_"^"_PatBed_"^"_CsRLocID_"^"_CsRLoc_"^"_CsRDate_"^"_CsRTime_"^"_CsRUserID_"^"_CsRUser_"^"_CsEmFlag_"^"_CsStatCode_"^"_CsCUser_"^"_CsCLoc_"^"_CsCategory_"^"_CstTypeDesc_"^"_CsSurTime_"^"_PrintFlag_"^"_MulStr //
	...s TMPListData(Num)=ListData
	..
	
	//i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	//Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="CstID^CstItmID^EpisodeID^PatName^PatNo^PatBed^CsRLocID^CsRLoc^CsRDate^CsRTime^CsUserID^CsRUser^CsEmFlag^CsStatCode^CsCUser^CsCLoc^CsCategory^CstTypeDesc^CsSurTime^PrintFlag^MulStr"

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
	//W ##class(web.DHCEMJsonCommon).getJsonEndSign()    //输出json结束符
	w "]"
	w ","_del_"CsHanNum"_del_":"_CsHanNum
	w "}"

	Q ""
}

/// Creator:    hxy  
/// CreateDate: 2020-01-21
/// Descript:   根据传入的CstID(主表ID)获取多科会诊科室、会诊医生、会诊状态
/// w ##class(web.DHCEMConsultQuery).GetMulStr(591)
ClassMethod GetMulStr(CstID As %String)
{
	n (CstID,%session)
	s ret=""
	s CH=""
	f  s CH=$o(^DHCEMCON(CstID,"I",CH)) Quit:CH=""  d
	.s CPrvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)  /// CT_CareProv ID
	.i CPrvID="" s CPrvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	.s CsCUser=$p($g(^CTPCP(+CPrvID,1)),"^",2)   /// 会诊医生
	.s CsCLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1) /// CT_Loc ID
	.s CsCLoc=$p($g(^CTLOC(+CsCLocID)),"^",2)     /// 会诊科室
	.s CsStatCode=..GetCstCurStat(CstID_"||"_CH)  /// 取会诊记录的当前状态值
	.s CsStatCode=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",CsStatCode)
	.i ret="" s ret=CsCLoc_","_CsCUser_","_CsStatCode
	.e  d
	..s ret=ret_"##"_CsCLoc_","_CsCUser_","_CsStatCode
	Q ret
}

/// Descript:  取会诊记录的当前状态值
/// w ##Class(web.DHCEMConsultQuery).GetCstCurStat("12")
ClassMethod GetCstCurStat(CstID As %String) As %String
{
	n (CstID)
	s LgID="",ID=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstID,LgID),-1) Q:(LgID="")||(ID'="")  D
	.q:$p($g(^DHCEMCONS(+($p(^DHCEMCONL(LgID),"^",3)))),"^",2)="到达" //hxy 2021-03-30 要想可以随时到达，必然不能让其影响流程
	.q:$p($g(^DHCEMCONS(+($p(^DHCEMCONL(LgID),"^",3)))),"^",1)="41" //hxy 2023-02-01
	.s ID=$p(^DHCEMCONL(LgID),"^",3)        /// 状态
	.
	i ID="" D
	.s ID=$p(^DHCEMCON(+CstID),"^",18)
	Q $p($g(^DHCEMCONS(+ID)),"^",2)
}

/// Descript:  取会诊明细医生列表
/// w ##Class(web.DHCEMConsultQuery).GetConsDocList("1")
ClassMethod GetConsDocList(CstID As %String) As %String
{
	n (CstID)
	s mListData=""
	s CH=""
	i CstID'="" D
	.F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	..s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..i mListData="" s mListData=UserID
	..E  s mListData=mListData_","_UserID
	.
	Q mListData
}

/// Descript:  取页面按钮设置标志值
/// w ##Class(web.DHCEMConsultQuery).GetCstPageBtFlag(85,10354,93)
ClassMethod GetCstPageBtFlag(CstID As %String, LgUserID As %String, LgLocID As %String, LgHospID = "", Param = "") As %String
{
	n (CstID, LgUserID, LgLocID,LgHospID,Param)
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)     /// 申请医生
	s CstStatusID=$p(^DHCEMCON(CstID),"^",18)  /// 申请状态
	Q:(LgUserID=CstUserID)&(CstStatusID="") "1"  /// 未发送
	s TypeFlag=$p(Param,"^",1) ///会诊列表类型 R申请 C会诊 //hxy 2021-03-22 抗菌药会诊DOCA可以申请完成同一个人 st
	s DOCAnti=$P(^DHCEMCON(CstID),"^",19) 
	s DOCACsLocID=$p(^DHCEMCON(CstID,"I",1),"^",1)
    Q:(DOCAnti="DOCA")&(TypeFlag="C")&((LgUserID=CstUserID)&(LgLocID=DOCACsLocID)&(CstStatusID'="")) "3" //ed
	Q:(LgUserID=CstUserID)&(CstStatusID'="") "2" /// 已经发送
	s CsRLocID=$p(^DHCEMCON(CstID),"^",2)      /// 申请科室 hxy 2021-03-10 st
	;s TypeFlag=$p(Param,"^",1) ///会诊列表类型 R申请 C会诊
	s DefRListByLoc=##Class(web.DHCEMConsultCom).GetEmSysConfig("DEFRLISTBYLOC",LgHospID) //会诊处理-申请列表默认查看本科室
	s RListByLocCan=##class(web.DHCEMConsultCom).GetEmSysConfig("RLISTBYLOCCAN",LgHospID) //会诊处理-申请列表默认查看本科室时，是否可取消非本人申请会诊
	Q:(TypeFlag="R")&(DefRListByLoc=1)&(RListByLocCan=1)&(LgUserID'=CstUserID)&(LgLocID=CsRLocID)&(CstStatusID'="") "20" /// 同科不同人申请会诊 已经发送(为了可以取消；申请列表是前提，因为抗菌药可申请本科室)
	s CListByLoc=##Class(web.DHCEMConsultCom).GetEmSysConfig("CLISTBYLOC",LgHospID)       //会诊处理-会诊列表能否查看本科全部
	s CListByLocCan=##class(web.DHCEMConsultCom).GetEmSysConfig("CLISTBYLOCCAN",LgHospID) //会诊处理-会诊列表能查看本科全部时，是否可取消完成、取消接收
	s CH="",QuitFlag=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:(CH="")||(QuitFlag'=0)  D
	.Q:TypeFlag="R" //hxy 2021-03-12 会诊科室里有申请科室时有问题，故申请列表时退出（会诊科室里有登陆科室时、会诊人里有登陆人时）
	.s UserID=""
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生
	.i CareProvID'="" D
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)         /// 会诊科室
	.s RealUserID="" //hxy 2022-05-27  st
	.s RealCareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)  /// 实际医生
	.s:RealCareProvID'="" RealUserID=$o(^SSU("SSUSR",0,"CTPCP",RealCareProvID,""))
	.s:(CListByLoc=1)&(CListByLocCan=1)&(RealUserID'="")&(LgUserID'=RealUserID)&(LgLocID=CsLocID) QuitFlag=2 //同科不同人会诊(为了可取消完成、取消接收)
	.Q:QuitFlag=2 
	.Q:(RealUserID'="")&(LgUserID'=RealUserID)&(LgLocID=CsLocID) //ed
	.s SamLocTypeFlag=..isSameLocType(LgLocID,CsLocID)   /// 判断两个科室是否属于同一类型
	.Q:(LgUserID'=UserID)&(LgLocID'=CsLocID)&(SamLocTypeFlag'="Y")
	.s QuitFlag=1
	.
	Q:QuitFlag=1 "3"
	Q:QuitFlag=2 "30" //hxy 2022-05-27
	Q "4"
}

/// Descript:  取会诊状态日志
/// w ##Class(web.DHCEMConsultQuery).JsonGetEmConsLog("1")
ClassMethod JsonGetEmConsLog(CstID As %String) As %String
{
	n (CstID, %session)
	s count = 0
	w "["
	s LgID=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstID,LgID)) Q:LgID=""  D
	.s CstUser=""
	.s UserID=$p(^DHCEMCONL(LgID),"^",2)    /// 操作人
	.s:UserID'="" CstUser=$p(^SSU("SSUSR",UserID),"^",2)
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.s StatusCode=$p(^DHCEMCONS(StatusID),"^",1)
	.s StatusDesc=$p(^DHCEMCONS(StatusID),"^",2)
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s StatusDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",StatusDesc)
	.s CstUser=##class(web.DHCEMConsultCom).GetTransDesc("USER.SSUSER","SSUSRNAME","",CstUser)
	.s tmp=CstUser_"^"_StatusCode_"^"_LgDate_" "_LgTime_"^"_StatusDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("User^Status^Time^StatusDesc",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("User^Status^Time^StatusDesc",tmp)
	w "]"
	q ""
}

/// Descript:  取会诊状态日志
/// w ##Class(web.DHCEMConsultQuery).JsonGetEmConsLogAndWorkFlowStauts("335||2")
ClassMethod JsonGetEmConsLogAndWorkFlowStauts(CstID As %String) As %String
{
	n (CstID, %session)
	w "{"
	w """ConsLog"":"
	w ##Class(web.DHCEMConsultQuery).JsonGetEmConsLog(CstID)
	w ","
	w """WorkFlowStauts"":"
	w """"_##Class(web.DHCEMConsultQuery).GetAuditStatusString(+CstID)_""""
	w "}"
	q ""
}

/// Descript:  按人取会诊状态日志
/// w ##Class(web.DHCEMConsultQuery).JsonGetEmConsLog("1")
ClassMethod JsonGetEmConsLogByUser(CstID As %String, UserID As %String) As %String
{
	n (CstID, UserID)
	s count = 0
	w "["
	s LgID=""
	F  s LgID=$o(^DHCEMCONL(0,"User",UserID,CstID,LgID)) Q:LgID=""  D
	.s CstUser=""
	.s UserID=$p(^DHCEMCONL(LgID),"^",2)    /// 操作人
	.s:UserID'="" CstUser=$p(^SSU("SSUSR",UserID),"^",2)
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.s StatusDesc=$p(^DHCEMCONS(StatusID),"^",2)
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s tmp=CstUser_"^"_StatusDesc_"^"_LgDate_" "_LgTime
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("User^Status^Time",tmp)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("User^Status^Time",tmp)
	w "]"
	q ""
}

/// Descript:  取页面其他内容
/// w ##Class(web.DHCEMConsultQuery).GetLgContent("","")
ClassMethod GetLgContent(LgLocID As %String, LgUserID As %String) As %String
{
	n (LgLocID, LgUserID, %session)
	s LocDesc=$p(^CTLOC(LgLocID),"^",2)        /// 科室
	s HospID=$p(^CTLOC(LgLocID),"^",22)        /// 医院
	s HospDesc=$p($g(^CT("HOSP",+HospID)),"^",2)
	s LgUser=$p(^SSU("SSUSR",LgUserID),"^",2)  /// 用户
	s LocAddr=$g(^CTLOC(LgLocID,"ADDR",1))	   /// 地址
	;i LocAddr="" D
	;.s LinkLocID=$o(^CTLOC(LgLocID,"LINK",0,"Loc",""))
	;.s:LinkLocID'="" LocAddr=$g(^CTLOC(LinkLocID,"ADDR",1))
	s LocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	s LgUser=##class(web.DHCEMConsultCom).GetTransDesc("USER.SSUSER","SSUSRNAME","",LgUser)
	s HospDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTHospital","HOSPDesc","",HospDesc)
    s ListData=LocDesc_"^"_LgUser_"^"_LocAddr_"^"_HospID_"^"_HospDesc
	s ListTitle="LocDesc^LgUser^LocAddr^HospID^HospDesc"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   Print会诊申请打印函数
/// InPut:      CstID-会诊申请表ID
/// OutPut:     会诊申请打印内容
/// w ##Class(web.DHCEMConsultQuery).GetCstPrintCons("501||1")
ClassMethod GetCstPrintCons(CstItmIDs As %String, LgHospID = "") As %String
{
	n (CstItmIDs,LgHospID,%session)
	s MulPriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("MULPRIFLAG",LgHospID) //hxy 2021-03-04 多科会诊由会诊医生分别填写结果时打印标志
	s NurMulPriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("NURMULLOCPRIFLAG",LgHospID) //hxy 2021-03-17 护士-多科室会诊打印份数标志
	s Count=0
	w "["
	s Len = $l(CstItmIDs,"^")
	s MulPriOne=0 //多科打印一份标志 hxy 2021-03-04 st
	s MoreFlag=$p($g(^DHCEMCON(+CstItmIDs)),"^",31) // 多科标志
	s CstEcType=$p($g(^DHCEMCON(+CstItmIDs)),"^",19)   /// 会诊类型
	s:((CstEcType="DOC")&(MoreFlag="Y")&(MulPriFlag=1))||((CstEcType="NUR")&(MoreFlag="Y")&(NurMulPriFlag=1)) MulPriOne=1 //打印一份
	s:((CstEcType="DOC")&(MoreFlag="Y")&(MulPriFlag=1))||((CstEcType="NUR")&(MoreFlag="Y")&(NurMulPriFlag=1)) Len=1 //是多科并且多科打印标志为1(打一份)，则只取一个 //ed
#;	s:(MoreFlag="Y")&(MulPriFlag=1) MulPriOne=1 //打印一份
#;	s:(MoreFlag="Y")&(MulPriFlag=1) Len=1 //是多科并且多科打印标志为1(打一份)，则只取一个 //ed
	f i=1:1:Len d
	.s CstItmID=$p(CstItmIDs,"^",i)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##Class(web.DHCEMConsultQuery).GetPisPrintCon(+CstItmID,CstItmID,LgHospID,MulPriOne)
	w "]"
	q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   Print会诊申请打印函数
/// InPut:      CstID-会诊申请表ID
/// OutPut:     会诊申请打印内容
/// w ##Class(web.DHCEMConsultQuery).GetPisPrintCon("300","300||1")
ClassMethod GetPisPrintCon(CstID As %String, CstItmID As %String, LgHospID = "", MulPriOne) As %String
{
	n (CstID,CstItmID,LgHospID,MulPriOne,%session)	
	
	s LgHospName=$p($g(^CT("HOSP",+LgHospID)),"^",2)
	/// 病人信息
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	         /// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
   	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)
   	s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	/// 申请单内容
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,2)
	s CstRUser=""
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstRUserImg="" //hxy 2020-09-27 st
    s SignInfo=##Class(web.DHCEMConsultCom).GetIfSignByCstItmID(CstItmID,"R")
	s SignFlag=+SignInfo
	s SignatureID = $p(SignInfo,"^",2)
    s:SignFlag=1 CstRUserImg ="data:image/png;base64,"_##class(CA.BICAService).GetImageBySignID(SignatureID) ;##class(CA.BICAService).GetImageBySignID(signatureID)
    s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,2)
	s PrintConTime=##class(web.DHCEMConsultCom).GetEmSysConfig("PRINTCONTIME",LgHospID) //2022-05-23 st
	i (PrintConTime=1)&(CstItmID'="") d
	.s CompTime=..GetCstNodeTime(CstItmID,"50") 
	.s CstNDate=$p(CompTime," ",1)
	.s CstNTime=$p(CompTime," ",2)
	.s CstNTime=$p(CstNTime,":",1,2) //ed
	s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	s OneOrMore=$p(^DHCEMCON(CstID),"^",31)   /// 是否多科
	s MedcalTangle=$p(^DHCEMCON(CstID),"^",32)  /// 是否有医疗纠纷
	s CurQuestion =$p(^DHCEMCON(CstID),"^",33)  /// 当前问题
	s MedcalTangle=$s(MedcalTangle="Y":"是",1:"否")
	s CstCstType=$s(CstEmFlag="Y":"加急",1:"普通")
	s CsPropID=$p(^DHCEMCON(CstID),"^",45)     /// 会诊性质
	s CsProp=$p($g(^DHCEMCDI(+CsPropID)),"^",2) /// 会诊性质
	s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	s CsOpinion=""							   /// 会诊意见
	s:CstItmID="" CsOpinion=$p(^DHCEMCON(CstID),"^",34)   
	s:CstItmID'="" CsOpinion=$p(^DHCEMCON(CstID,"I",$p(CstItmID,"||",2)),"^",4)
	s:MulPriOne=1 CsOpinion=..JsGetCsOpinion(CstID) //hxy 2021-03-04 st
	s OtherLocDoc="" 
	s:MulPriOne=1 OtherLocDoc=..GetOtherLocDocStr(CstID,CstItmID) //ed
	i CsOpinion="" s CsOpinion=TreMeasures
	s CstTypeDesc=""
	s CstTypeDr=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	s:CstTypeDr'="" CstTypeDesc=$p($g(^DHCEMCDI(CstTypeDr)),"^",2)
	s CsLocDesc="",CsUser="",PrvTp="",CsLocDescS="",CstRPhone=""
	i CstItmID'="" d
	.s CH = $p(CstItmID,"||",2)
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	.s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s CsUser=""
	.s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	.s CsUserImg="" //hxy 2020-09-27 st
	.s SignInfo=##Class(web.DHCEMConsultCom).GetIfSignByCstItmID(CstItmID,"C")
	.s SignFlag=+SignInfo
	.s SignatureID = $p(SignInfo,"^",2)
    .s:SignFlag=1 CsUserImg = "data:image/png;base64,"_##class(CA.BICAService).GetImageBySignID(SignatureID) ;##class(web.DHCEMConsultCom).GetImageByUserID(CsUserID) //ed
	.;s SignFlag=##Class(web.DHCEMConsultCom).GetIfSignByCstItmID(CstItmID,"C")
    .;s:SignFlag=1 CsUserImg = "data:image/png;base64,"_##class(web.DHCEMConsultCom).GetImageByUserID(CsUserID) //ed
	.s CsLocDesc=""
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	.s PrvTp=""
	.s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)       /// 职称
	.s:(PrvTpID="")&&(CareProvID'="") PrvTpID=+##Class(web.DHCEMConsultCom).GetPrvTpIDByCareProvID(CareProvID)
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s CstRPhone=..GetCareProvPhone(CareProvID)          /// 医生电话
	.i CstRPhone="" s CstRPhone=..GetLocTelPhone(CsLocID)   /// 科室电话
	;s CsLocDescS=##Class(web.DHCEMConsultQuery).GetConsultLocDesc(CstID,CstItmID)
	i CstOutFlag="Y" s CsLocDesc=CstUnit_" + "_CstDocName
	s CstEcType=$p(^DHCEMCON(CstID),"^",19)   /// 会诊类型
	s AgreeFlag=$p(^DHCEMCON(CstID),"^",35)   /// 是否同意用药
	s AgreeFlag=$s(AgreeFlag="Y":"同意用药;",AgreeFlag="N":"不同意用药;",1:"")
	i CstEcType="DOCA" s CsOpinion=AgreeFlag_"  "_CsOpinion

	s ListTitle="PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUser^CstTrePro^CstPurpose"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^OneOrMore^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstCstType^CsLocDesc^CsUser^CsOpinion^ConsPrvTp"
	s ListTitle=ListTitle_"^MedcalTangle^CurQuestion^CsLocDescS^CstTypeDesc^CstRPhone^CsProp^LgHospName^OtherLocDoc^CstRUserImg^CsUserImg"

	s count=0
	s ListData=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_OneOrMore_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser
	s ListData=ListData_"^"_CstPhone_"^"_CstCstType_"^"_CsLocDesc_"^"_CsUser_"^"_CsOpinion_"^"_PrvTp_"^"_MedcalTangle_"^"_CurQuestion_"^"_CsLocDescS
	s ListData=ListData_"^"_CstTypeDesc_"^"_CstRPhone_"^"_CsProp_"^"_LgHospName_"^"_OtherLocDoc_"^"_CstRUserImg_"^"_CsUserImg
	q ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	
	;Q ""
}

/// Creator:qqa
/// Descript:获取会诊科室以及会诊医生
/// 
ClassMethod GetConsultLocDesc(CstID As %String, CstItmID As %String)
{
	n (CstID,CstItmID)
	s:+CstItmID'=0 CstID = +CstItmID
	q:+CstID=0 ""
	s CsLocDescS=""
	s CsUser="",PrvTp="",CsLocDesc=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s CstItmDr = CstID_"||"_CH
	.q:(CstItmID'="")&&(CstItmID'=CstItmDr)
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s CsUser=""
	.s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	.s CsLocDesc=""
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	.s PrvTp=""
	.s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)       /// 职称
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.i CsLocDescS="" d
	..s CsLocDescS = CsLocDesc_$case(PrvTp,"":"",:"("_PrvTp_CsUser_")")	
	.e  d
	..s CsLocDescS = CsLocDescS_","_CsLocDesc_$case(PrvTp,"":"",:"("_PrvTp_CsUser_")")
	q CsLocDescS
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   Print会诊申请打印函数
/// InPut:      CstID-会诊申请表ID
/// OutPut:     会诊申请打印内容
/// w ##Class(web.DHCEMConsultQuery).GetPisPrintCon("69")
ClassMethod GetPisPrintCon1(mCstID As %String) As %String
{
	n (mCstID)
	s CstID=+mCstID,CH=+$p(mCstID,"||",2)
	/// 病人信息
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	         /// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)  /// 床号
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	
	/// 申请单内容
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
    s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	s ConsPrvTp=$p(^DHCEMCON(CstID),"^",9)   /// 医生级别
	s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	s CstTreMes=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	//s CstEmFlag=$s(CstEmFlag="Y":"加急",1:"普通")
	s CstMoreFlag=$o(^DHCEMCON(CstID,"I",""),-1)
	
	w "["
	s ListTitle="PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUser^CstTrePro^CstPurpose^CstTreMes"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstMoreFlag"
	s ListData=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstTreMes
	s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser
	s ListData=ListData_"^"_CstPhone_"^"_CstMoreFlag
	w ##class(web.DHCEMJsonCommon).getJsonChildPrefixSign(ListTitle,ListData)
	D ..GetCsLocItemArr(mCstID)               /// 会诊科室列表
	w "}]"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   会诊科室列表
/// InPut:      CstID - 会诊ID
/// OutPut:     会诊科室列表
/// w ##Class(web.DHCEMConsultQuery).GetCsLocItemArr("") 
ClassMethod GetCsLocItemArr(mCstID As %String) As %String
{
	n (mCstID)
	s CstID=+mCstID
	w ",""CsItemArr"":["
	s ListTitle="CsLocDesc^CsUser^ProvPhone^SubMar^CsPrvTp^CsOpinion"
	s CH="",count=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.//Q:($p(mCstID,"||",2)'="")&($p(mCstID,"||",2)'=CH)
	.s CareProvID=$p($g(^DHCEMCON(CstID,"I",CH)),"^",2)     /// 会诊医生
	.i CareProvID="" s CareProvID=$p($g(^DHCEMCON(CstID,"I",CH)),"^",2) 
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)
	.s CsLocDesc=""
	.s CsLocID=$p($g(^DHCEMCON(CstID,"I",CH)),"^",1)        /// 会诊科室
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	.s CsOpinion=$p($g(^DHCEMCON(CstID,"I",CH)),"^",4)      /// 会诊意见
	.s PrvTp=""
	.s PrvTpID=$p($g(^DHCEMCON(CstID,"I",CH)),"^",11)       /// 医生职称
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s ProvPhone=..GetCareProvPhone(CareProvID)             /// 医生电话
	.s SubMarID=$p(^DHCEMCON(CstID,"I",CH),"^",13)          /// 亚专业
	.s SubMar=$p($g(^DHCEMCDI(+SubMarID)),"^",2)
	.s ListData=CsLocDesc_"^"_CsUser_"^"_ProvPhone_"^"_SubMar_"^"_PrvTp_"^"_CsOpinion
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-12
/// Descript:   取科室电话
/// InPut:      LocID - 科室ID
/// OutPut:     电话号码
/// w ##Class(web.DHCEMConsultQuery).GetLocTelPhone("") 
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
/// w ##Class(web.DHCEMConsultQuery).GetCareProvPhone("")
ClassMethod GetCareProvPhone(CareProvID As %String) As %String
{
	n (CareProvID)
    Q:'$d(^CTPCP(+CareProvID,2)) ""
	s TelPhone=$p($g(^CTPCP(+CareProvID,2)),"^",1)    /// 会诊医生电话
	Q TelPhone
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-23
/// Descript:   取会诊病历授权链接
/// InPut:      LocID - 科室ID
/// OutPut:     会诊病历授权链接
/// w ##Class(web.DHCEMConsultQuery).GetConsAutUrl("")
ClassMethod GetConsAutUrl(CstID As %String) As %String
{
	n (CstID)
	Q:..isMulLoc(CstID)>1 ""
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	s:CstUserID'="" CstUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s ConsultType=$s(CstOutFlag="Y":"O",1:"I")
	s CH=$o(^DHCEMCON(CstID,"I",""))
	Q:CH="" ""
	s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	s ConsdocID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	s ConslocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)      /// 会诊科室
	s LinkUrl="epr.newfw.actionauthorize.csp?EpisodeID="_EpisodeID_"&ConsultID="_CstID_"&ConsdocID="_ConsdocID_"&ConslocID="_ConslocID_"&ConsultType="_ConsultType_"&AppointType=1"
    Q LinkUrl
}

/// Descript:   是否多科会诊
ClassMethod isMulLoc(CstID As %String) As %String
{
	n (CstID)
	s CH="",Num=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s Num=Num+1
	Q Num
}

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCEMConsultQuery).JsGetConsult("10","1","2018-08-29^2018-08-29")
ClassMethod JsGetConsult(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	
    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	          /// 病区ID
	..s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	..//s BedId=$p(^PAADM(EpisodeID),"^",73) 				 /// 床号ID
    ..//s PatBed=""
    ..//s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)  /// 床号
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	..s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstUserID)),"^",2)
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	..s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	..s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	..s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	..s CstType=""
	..
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CareProvID=+$p(^DHCEMCON(CstID,"I",CH),"^",2)
	...i CareProvID=0 s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)       /// 会诊医生
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)        /// 会诊科室
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s CsOpinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)      /// 会诊意见
	...s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11) 
	...s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)          /// 职称
	...s SubMarID=$p(^DHCEMCON(CstID,"I",CH),"^",13)      /// 亚专业
	...s SubMar=$p($g(^DHCEMCDI(+SubMarID)),"^",2)
	...s Num=Num+1
	...s ListData=CstID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	...s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	...s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser
	...s ListData=ListData_"^"_CstPhone_"^"_CstType_"^"_CsLocDesc_"^"_CsUser_"^"_CsOpinion_"^"_PrvTp_"^"_SubMar
	...s TMPListData(Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="CstID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUser^CstTrePro^CstPurpose"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstCstType^CstLoc^CstUser^CsOpinion^ConsPrvTp^SubMar"

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

/// Descript:	亚专业对应指征
/// w ##class(web.DHCEMConsultQuery).GetJsonSubMarInd("17")
ClassMethod GetJsonSubMarInd(CstID As %String) As %String
{
	n (CstID)
	s count=0
	w "["
	s ID=""
	F  s ID=$o(^DHCEMCONI(0,"ConsInd",CstID,ID)) Q:ID=""  D
	.s itmID=$p(^DHCEMCONI(ID),"^",2)  /// 指征
	.Q:itmID=""
	.s itmDesc=$p(^DHCEMCDI(itmID),"^",2)
	.s tmp=itmID_"^"_itmDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	.E  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",tmp)
	w "]"
	Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-01-04
/// Descript:    病人历史就诊会诊记录
/// w ##Class(web.DHCEMConsultQuery).JsGetPatHisCons("10","1","^^^^21^332")
ClassMethod JsGetPatHisCons(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params,%session)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-30
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s argLocID=$p(Params,"^",3)   /// 请会诊科室
	s argCstType=$p(Params,"^",4) /// 会诊类型
	s argPatientID=$p(Params,"^",5)  /// 病人ID
	s argEpisodeID=$p(Params,"^",6)  /// 就诊ID

    s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..Q:$p(^DHCEMCON(CstID),"^",18)=""            /// 申请状态
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	..Q:(argEpisodeID'="")&(argEpisodeID'=EpisodeID)
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(argPatientID'="")&(argPatientID'=PatientID)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	..s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	..//s BedId=$p(^PAADM(EpisodeID),"^",73) 				   /// 床号ID
    ..//s PatBed=""
    ..//s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID)  /// 床号
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	..;s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	..s PatDiagDesc = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.diag.GetAdmDiagDesc",EpisodeID, "", "")
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..Q:(argLocID'="")&(argLocID'=CstRLocID)
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s:CstRDate'="" CstRDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRTime=CstRDate_" "_CstRTime
	..s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..s CstRUser=$p($g(^SSU("SSUSR",CstUserID)),"^",2)
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	..s:CstNDate'="" CstNDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	..s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	..s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	..s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	..s CstUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	..s AuditFlag=$s(CstUserID'="":"已审",1:"待审")  /// 审核状态 
	..s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	..Q:(argCstType'="")&(argCstType'=CstTypeID)
	..s CstType=$p(^DHCEMCDI(CstTypeID),"^",2) /// 会诊类型
	..s CstStatus=..GetCstCurStat(CstID)       /// 取会诊记录的当前状态值
	..Q:CstStatus="取消"
	..s TypeCode=$p(^DHCEMCON(CstID),"^",19)
	..//s AccpTime=..GetCstNodeTime(CstID_"||1","30")  /// 接收时间
	..//s CompTime=..GetCstNodeTime(CstID_"||1","50")  /// 完成时间
	..s CstPrvArr="",CstLocArr=""
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CareProvID=+$p(^DHCEMCON(CstID,"I",CH),"^",2)
	...i CareProvID=0 s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3) 
	...s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)       /// 会诊医生
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)        /// 会诊科室
	...s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	...s CstPrvArr=CsUser
	...s CstLocArr=CsLocDesc
	...s CsOpinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)      /// 会诊意见
	...i CsOpinion="" s CsOpinion=TreMeasures
	...i CstOutFlag="Y" s CstLocArr=CstDocName
	...s AccpTime=..GetCstNodeTime(CstID_"||"_CH,"30")    /// 接收时间
	...s CompTime=..GetCstNodeTime(CstID_"||"_CH,"50")    /// 完成时间
	...s CstStatus=..GetCstCurStat(CstID_"||"_CH )        /// 取会诊记录的当前状态值
	...s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)          /// 医嘱ID
	...i Oeori=""  s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",10)
	...s CstItmID=CstID_"||"_CH
	...s Num=Num+1
	...s Languages=""
	...i $d(%session)  D //取session的语言
    ....s LanguagesDr=$g(%session.Data("LOGON.LANGID"))
    ....s:LanguagesDr'="" Languages=$p($g(^SS("LAN",LanguagesDr)),"^",1)
	...s PatName=##class(web.DHCEMConsultCom).GetTransDesc("User.PAPatMas","PAPMIName",Languages,PatName)
	...s PatSex=##class(web.DHCEMConsultCom).GetTransDesc("User.CTSex","CTSEXDesc",Languages,PatSex)
	...s PatLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,PatLoc)
	...s CstRUser=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName",Languages,CstRUser)
	...s PatWard=##class(web.DHCEMConsultCom).GetTransDesc("User.PACWard","WARDDesc",Languages,PatWard)
	...s CstRLoc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,CstRLoc)
	...s CstUser=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName",Languages,CstUser)
	...s CstType=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsDicItem","ECDesc",Languages,CstType)
	...s CstLocArr=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc",Languages,CstLocArr)
	...s CstPrvArr=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName",Languages,CstPrvArr)
	...s CstStatus=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc",Languages,CstStatus)
	...s ListData=CstID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	...s ListData=ListData_"^"_CstRLoc_"^"_BillType_"^"_MedicareNo_"^"_PatDiagDesc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose
	...s ListData=ListData_"^"_CstNDate_"^"_CstNTime_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser
	...s ListData=ListData_"^"_CstPhone_"^"_CstType_"^"_CstLocArr_"^"_CstPrvArr_"^"_CsOpinion_"^"_AuditFlag_"^"_CstStatus_"^"_AccpTime_"^"_CompTime
	...s ListData=ListData_"^"_CstItmID_"^"_Oeori_"^"_TypeCode
	...s TMPListData(Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="CstID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^CstRLoc^BillType^MedicareNo^PatDiag^CstRDate^CstRTime^CstRUser^CstTrePro^CstPurpose"
	s ListTitle=ListTitle_"^CstNDate^CstNTime^CstNPlace^CstEmFlag^CstOutFlag^CstUnit^CstDocName^CstRemark^CstUser^CstPhone^CstType^CstLocArr^CstPrvArr^CsOpinion^AuditFlag^CstStatus^AccpTime^CompTime"
	s ListTitle=ListTitle_"^CstItmID^Oeori^TypeCode"

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

/// Descript:查询主诉科室模板
/// w ##class(web.DHCEMConsultQuery).QueryCotByLoc("10","1","306")
ClassMethod QueryCotByLoc(rows As %String, page As %String, LocDr As %String) As %String
{
	n (rows, page, LocDr)
	s End = page*rows
	s Start=(page-1)*rows+1 
	i LocDr="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:LocDr="" ""
	
	s Count=0
	W "{"
	w """"_"rows"_""""_":"_"["
	s COTRowID=0
	f  s COTRowID= $o(^DHCEMCOT(0,"Loc",LocDr,COTRowID)) q:COTRowID=""  d
	.s COTText = $p(^DHCEMCOT(COTRowID),"^",1)
	.s COTLoc = $p(^DHCEMCOT(COTRowID),"^",2)
	.s COTUser = $p(^DHCEMCOT(COTRowID),"^",3)
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.i Count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonDataNoFormat("CotID^CotText^CotLoc^CotUser",COTRowID_"^"_COTText_"^"_COTLoc_"^"_COTUser)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonDataNoFormat("CotID^CotText^CotLoc^CotUser",COTRowID_"^"_COTText_"^"_COTLoc_"^"_COTUser)
	W "]"
	w ","
	w """"_"total"_""""_":"_Count
	w "}"
	q ""
}

/// Descript:查询主诉个人模板
/// w ##class(web.DHCEMConsultQuery).QueryCotByUser("10","1","10962")
ClassMethod QueryCotByUser(rows As %String, page As %String, UserDr As %String) As %String
{
	n (rows, page, UserDr)
	s End = page*rows
	s Start=(page-1)*rows+1 
	i UserDr="" w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) //输出json结尾符
	Q:UserDr="" ""
	
	s Count=0
	W "{"
	w """"_"rows"_""""_":"_"["
	s COTRowID=0
	f  s COTRowID= $o(^DHCEMCOT(0,"USER",UserDr,COTRowID)) q:COTRowID=""  d
	.s COTText = $p(^DHCEMCOT(COTRowID),"^",1)
	.s COTLoc = $p(^DHCEMCOT(COTRowID),"^",2)
	.s COTUser = $p(^DHCEMCOT(COTRowID),"^",3)
	.s Count = Count+1
	.Q:(Count<Start)||(Count>End)
	.i Count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonDataNoFormat("CotID^CotText^CotLoc^CotUser",COTRowID_"^"_COTText_"^"_COTLoc_"^"_COTUser)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonDataNoFormat("CotID^CotText^CotLoc^CotUser",COTRowID_"^"_COTText_"^"_COTLoc_"^"_COTUser)
	W "]"
	w ","
	w """"_"total"_""""_":"_Count
	w "}"
	q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     会诊申请指定节点时间
/// InPut:        CstID - 会诊ID, stCode - 状态代码
/// OutPut:       时间
/// w ##Class(web.DHCEMConsultQuery).GetCstNodeTime("2","30")
ClassMethod GetCstNodeTime(itmID As %String, stCode As %String) As %String
{
	n (itmID, stCode)
	Q:stCode="" ""
	Q:$p(^DHCEMCON(+itmID),"^",18)="" ""     /// 会诊状态
	s LgID="",LgCstTime="",QuitFlag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",itmID,LgID),-1) Q:(LgID="")||(LgCstTime'="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.i (stCode="30")&($p(^DHCEMCONS(StatusID),"^",1)="35") s QuitFlag=1
	.i (stCode="50")&($p(^DHCEMCONS(StatusID),"^",1)="51") s QuitFlag=1
	.Q:$p(^DHCEMCONS(StatusID),"^",1)'=stCode
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s LgCstTime=LgDate_" "_LgTime
	.
	Q LgCstTime
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     当前会诊是否驳回
/// InPut:        CstID - 会诊ID
/// OutPut:       1 - 驳回, 0 - 未驳回
/// w ##Class(web.DHCEMConsultQuery).GetCsRefAuditFlag("2")
ClassMethod GetCsRefAuditFlag(itmID As %String) As %String
{
	n (itmID)
	Q:$p(^DHCEMCON(+itmID),"^",18)="" ""     /// 会诊状态
	s LgID="",QuitFlag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",itmID,LgID),-1) Q:(LgID="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)   /// 状态
	.Q:$p(^DHCEMCONS(StatusID),"^",1)'="22"
	.s QuitFlag=1
	.
	Q QuitFlag
}

ClassMethod GetConsultLocs(CstID)
{
	n (CstID,%session)
	s CH="",CsLocDescS=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s CsUser=""
	.s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	.s CsLocDesc=""
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	.s PrvTp=""
	.s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)       /// 职称
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s CsLocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",CsLocDesc)
	.s PrvTp=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCarPrvTp","CTCPTDesc","",PrvTp)
	.s CsUser=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName","",CsUser)
	.i CsLocDescS="" d
	..s CsLocDescS = CsLocDesc_$case(PrvTp,"":"",:"("_PrvTp_CsUser_")")
	.e  d
	..s CsLocDescS = CsLocDescS_","_CsLocDesc_$case(PrvTp,"":"",:"("_PrvTp_CsUser_")")
	q CsLocDescS
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     会诊申请剩余时间
/// InPut:        CstID - 会诊ID
/// OutPut:       时间
/// w ##Class(web.DHCEMConsultQuery).GetCsSurTime("587||1")
ClassMethod GetCsSurTimeOld(itmID As %String) As %String
{
	n (itmID)
	s ID=$p($g(^DHCEMCON(+itmID,"I",+$p(itmID,"||",2))),"^",6)  /// 会诊状态
	i ID="" s ID=$p(^DHCEMCON(+itmID),"^",18)  /// 会诊状态
	Q:ID="" ""
	s stCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	s stDesc=$p($g(^DHCEMCONS(+ID)),"^",2)
	Q:(stCode=5)||(stCode=25)||(stCode=22) ""  /// 取消||拒绝||驳回
	Q:(stCode>=50)&(stCode'=51)&(stDesc'["审核") ""              /// 完成&取消完成
	s CstEmFlag=$p(^DHCEMCON(+itmID),"^",23)   /// 是否加急
	s CsRDate=$p(^DHCEMCON(+itmID),"^",3)      /// 申请日期
	s CsRTime=$p(^DHCEMCON(+itmID),"^",4)      /// 申请时间
	Q:(+$H-CsRDate)>1 "超时"
	i CstEmFlag="Y" D
	.i CsRDate=+$H D
	..s CrTime=7200-($p($H,",",2)-CsRTime)
	.E  D
	..;s CrTime=7200-(($p($H,",",2)+3600*24)-CsRTime) 
	..s CrTime=7200-(($p($H,",",2)+(3600*24))-CsRTime) //hxy 2019-07-17
	E  D
	.i CsRDate=+$H D
	..s CrTime=3600*24-($p($H,",",2)-CsRTime)
	.E  D
	..;s CrTime=3600*24-(($p($H,",",2)+3600*24)-CsRTime)
	..s CrTime=3600*24-(3600*24+($p($H,",",2))-CsRTime) //hxy 2019-07-17
	Q:CrTime<0 "超时"
	Q:CrTime=86400 ""
	s CrTime=$zt(CrTime,2)
	Q CrTime
}

/// Creator:      hxy
/// CreateDate:   2021-02-27
/// Descript:     会诊申请剩余时间
/// InPut:        CstID - 会诊ID
/// OutPut:       时间
/// w ##Class(web.DHCEMConsultQuery).GetCsSurTime("526||1")
ClassMethod GetCsSurTime(itmID As %String) As %String
{
	n (itmID)
	s ID=$p($g(^DHCEMCON(+itmID,"I",+$p(itmID,"||",2))),"^",6)  /// 会诊状态
	i ID="" s ID=$p(^DHCEMCON(+itmID),"^",18)  /// 会诊状态
	Q:ID="" ""
	s stCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	s stDesc=$p($g(^DHCEMCONS(+ID)),"^",2)
	Q:(stCode=5)||(stCode=25)||(stCode=22) ""  /// 取消||拒绝||驳回
	Q:(stCode>=50)&(stCode'=51)&(stDesc'["审核") ""              /// 完成&取消完成
	s CstEmFlag=$p(^DHCEMCON(+itmID),"^",23)   /// 是否加急
	s CsRDate=$p(^DHCEMCON(+itmID),"^",3)      /// 申请日期
	s CsRTime=$p(^DHCEMCON(+itmID),"^",4)      /// 申请时间
	s CsPropID = $p(^DHCEMCON(+itmID),"^",45)   /// 会诊性质
#;	s CsNDate=$p(^DHCEMCON(+itmID),"^",10)     /// 会诊日期 //hxy 2021-05-19 st 有会诊时间时，超时按会诊日期时间计算 2021-05-28注释：考虑到质控应该走统一时间，且无项目提类似需求
#;	s CsNTime=$p(^DHCEMCON(+itmID),"^",11)     /// 会诊时间 
#;	s SSCut=""
#;	s:CsNTime'="" SSCut= $SYSTEM.SQL.DATEDIFF("ss",$h,CsNDate_","_CsNTime)
#;	q:SSCut<0 "超时"
#;	q:SSCut=0 "" 
#;	q:CsNTime'="" (SSCut\3600)_":"_$p($zt(SSCut#3600,2),":",2) //ed
	s Hours=24
	i CstEmFlag="Y" s Hours=2
	s HoursConfig=..GetHoursConfig(CsPropID,"OVERTIEMHOUR")
	s:+HoursConfig'=0 Hours=HoursConfig
	;s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,$h) //hxy 2021-03-12 st
	s CstRLocID=$p(^DHCEMCON(+itmID),"^",2) /// 申请科室 
	s HospID=##Class(web.DHCEMCommonUtil).GetHospitalIDByLocID(CstRLocID)
	s OverTimeFilter=##class(web.DHCEMConsultCom).GetEmSysConfig("OVERTIMEFILTER",HospID)
	s EmArrMin=##class(web.DHCEMConsultCom).GetEmSysConfig("EMARRMIN",HospID) //2021-04-02 st 急会诊要求到达分钟数
	s ConsUseStatusCode = ##Class(web.DHCEMConsultCom).GetConsUseStatusCode(HospID) //当前启用的状态code
	s:ConsUseStatusCode'["^40^" EmArrMin=0 //状态到达启用为前提
	s ArrDate=$p($g(^DHCEMCON(+itmID,"I",+$p(itmID,"||",2))),"^",18) ///到达日期
	q:(+EmArrMin'=0)&&(CstEmFlag="Y")&&(ArrDate'="") ""
	s:(+EmArrMin'=0)&&(CstEmFlag="Y") Hours=EmArrMin/60 //ed
	i (OverTimeFilter=1)!(OverTimeFilter=2) d
	.s SSCut=..GetDateDiff(CsRDate,CsRTime,+$h,$p($h,",",2),OverTimeFilter)
	e  d
	.s SSCut= $SYSTEM.SQL.DATEDIFF("ss",CsRDate_","_CsRTime,$h) //ed
	q:SSCut<0 ""
	s CrTime=Hours*3600-SSCut
	Q:CrTime<0 "超时"
	s CrTime=(CrTime\3600)_":"_$p($zt(CrTime#3600,2),":",2)
	Q CrTime
}

/// Creator:      hxy
/// CreateDate:   2021-03-12
/// Descript:     计算日期相差毫秒数
/// InPut:        开始日期，开始时间，结束日期，结束时间，标志：1过滤节假日；2过滤节假日和周末
/// OutPut:       毫秒数
/// w ##Class(web.DHCEMConsultQuery).GetDateDiff("65815","0","65818","73635","2")
ClassMethod GetDateDiff(StDate As %String, StTime As %String, EdDate As %String, EdTime As %String, Flag = "") As %String
{
	n (StDate,StTime,EdDate,EdTime,Flag)
	q:(+StDate=0)||(+EdDate=0) 0
	s ret=0
	f date=StDate:1:EdDate d
	.s HolidayFlag=##Class(web.DHCEMConsultCom).GetHolidayFlag(date)
	.s WeekFlag=##Class(web.DHCEMConsultCom).GetWeekFlag(date)
	.q:(Flag=1)&(HolidayFlag=1)
	.q:(Flag=2)&((HolidayFlag=1)!(WeekFlag=1))
	.i date=EdDate d
	..s:date=StDate ret=ret+(EdTime-StTime)
	..s:date'=StDate ret=ret+EdTime
	.e  d
	..i date=StDate d
	...s ret=ret+(86400-StTime)
	..e  d
	...s ret=ret+86400
	..
	.
	q ret
}

/// Creator:      hxy
/// CreateDate:   2021-02-27
/// Descript:     取值DHCEmConsDicItem项目-字典属性配置
/// InPut:        DHCEmConsDicItem项目ID
/// OutPut:       配置(描述)
/// w ##Class(web.DHCEMConsultQuery).GetHoursConfig("33","OVERTIEMHOUR")
ClassMethod GetHoursConfig(CsPropID As %String, Code As %String) As %String
{
	n (CsPropID,Code)
	q:(CsPropID="")||(Code="") ""
	s ID="",Desc=""
	f  s ID=$o(^DHCEMCIP(0,"Code",$$ALPHAUP^SSUTIL4(Code),ID)) q:ID=""  d
	.s Act=$p(^DHCEMCIP(ID),"^",3) //可用标志
	.q:Act'="Y"
	.s mID=$p(^DHCEMCIP(ID),"^",4) //项目ID
	.q:mID'=CsPropID
	.s Desc=$p(^DHCEMCIP(ID),"^",5) //参数 2021-05-08 2->5
	q Desc
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-20
/// Descritp:	判断两个科室是否属于同一类型【华西需求:多科室分开申请，会诊列表时，可互看】
/// InPut:      LgLocID - 登录科室， CLocID - 会诊科室
/// OutPut:     Y-属于，N-不属于
/// w ##Class(web.DHCEMConsultQuery).isSameLocType("156","114")
ClassMethod isSameLocType(LgLocID As %String, CLocID As %String) As %String
{
	n (LgLocID, CLocID)
	s QuitFlag="N"
#;	/// 使用科室列表
#;	s LLID=""
#;	F  s LLID=$o(^CT("LL",0,"Loc1",LgLocID,LLID)) Q:(LLID="")||(QuitFlag="Y")  D
#;	.Q:'$d(^CT("LL",0,"Loc1",CLocID,LLID))
#;	.Q:$p(^CT("LL",LLID),"^",1)'["CONSULTCOMBLOC"
#;	.s QuitFlag="Y"
#;	.
	/// 使用MDT科室组
	s ID=""
	F  s ID=$o(^DHCEMCG(0,"LOC",LgLocID,ID)) Q:ID=""  D
	.Q:$p(^DHCEMCG(ID),"^",1)'["RELLOC"       /// 约定小组代码以"RELLOC"开始
	.s CH=""
	.F  s CH=$o(^DHCEMCG(ID,"G",CH)) Q:CH=""  D
	..Q:$p(^DHCEMCG(ID,"G",CH),"^",1)'=CLocID  /// 科室ID
	..Q:$p(^DHCEMCG(ID,"G",CH),"^",3)'="Y"
	..s QuitFlag="Y"
	.
	Q QuitFlag
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-11-22
/// Descript:    会诊日志列表
/// Output:      
/// w ##Class(web.DHCEMConsultQuery).JsonCsLog("10","1","95||1")
ClassMethod JsonCsLog(rows As %String, page As %String, itmID As %String, ReqFlag = "") As %String
{
	n (rows,page,itmID,ReqFlag,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	k TMPArrList 
	
	s CstID=+itmID
	i ReqFlag=1 d //1：会诊处理-申请列表
	.s MoreFlag=$p(^DHCEMCON(CstID),"^",31) // 多科标志
	.s:MoreFlag'="Y" ReqFlag=""

	s CH="",Num=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s itmIDCur=CstID_"||"_CH
	.Q:(itmIDCur'=itmID)&(ReqFlag'=1) //
	.s LgID=""
	.F  s LgID=$o(^DHCEMCONL(0,"Cst",itmIDCur,LgID)) Q:LgID=""  D
	..s LgUser=""
	..s LgUserID=$p(^DHCEMCONL(LgID),"^",2)   /// 操作人
	..i LgUserID'="" s LgUser=$p(^SSU("SSUSR",LgUserID),"^",2)
	..s StatusID=$p(^DHCEMCONL(LgID),"^",3)   /// 状态
	..s Status=$p(^DHCEMCONS(StatusID),"^",2)
	..s LgDate=$p(^DHCEMCONL(LgID),"^",4)     /// 日期
	..s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	..s LgTime=$p(^DHCEMCONL(LgID),"^",5)     /// 时间	
	..s:LgTime'="" LgTime=$zt(LgTime,1)
	..s LogNotes=$p(^DHCEMCONL(LgID),"^",6)   /// 备注
	..
	..s Num=Num+1
	..s LgUser=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName","",LgUser)
	..s Status=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",Status)
    ..s ListData=LgID_"^"_LgUser_"^"_LgDate_"^"_LgTime_"^"_Status_"^"_LogNotes
	..s TMPArrList(Num)=ListData
	.
	
	i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="LgID^LgUser^LgDate^LgTime^Status^LogNotes"

	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPArrList(index)) Q:index=""  D
	.s ListData=$g(TMPArrList(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W ##class(web.DHCEMJsonCommon).getJsonEndSign()    //输出json结束符

	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-09-04
/// Descript:     会诊申请指定节点时间
/// InPut:        CstID - 会诊ID, stCode - 状态代码
/// OutPut:       时间
/// w ##Class(web.DHCEMConsultQuery).GetCstNodeCacheTime("2","30")
ClassMethod GetCstNodeCacheTime(itmID As %String, stCode As %String) As %String
{
	n (itmID, stCode)
	Q:stCode="" ""
	Q:$p(^DHCEMCON(+itmID),"^",18)="" ""     /// 会诊状态
	s LgID="",LgCstTime="",QuitFlag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",itmID,LgID),-1) Q:(LgID="")||(LgCstTime'="")||(QuitFlag=1)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.Q:$p(^DHCEMCONS(StatusID),"^",1)'=stCode
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s LgCstTime=LgDate_"^"_LgTime
	Q LgCstTime
}

/// Descript:  取会诊记录完成时间
/// w ##Class(web.DHCEMConsultQuery).GetCstCurStatDate("12")
ClassMethod GetCstCurStatDate(CstID)
{
	n (CstID)
	s LgID="",ID=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstID,LgID),-1) Q:(LgID="")||(ID'="")  D
	.s ID=$p(^DHCEMCONL(LgID),"^",3)        /// 状态
	.s LgDate = $p(^DHCEMCONL(LgID),"^",4)  /// 日期
	.s LgTime = $p(^DHCEMCONL(LgID),"^",5)  /// 时间
	s:$p($g(^DHCEMCONS(+ID)),"^",2)'="完成" LgDate="",LgTime=""
	Q LgDate_"^"_LgTime
}

/// Descript:取会诊申请明细内容
/// w ##Class(web.DHCEMConsultQuery).JsCstEmrAutItem("27")
ClassMethod JsCstEmrAutItem(CstID As %String, TakType = "") As %String
{
	n (CstID,TakType,%session)
    s PatHospID=##Class(web.DHCEMConsultCom).GetPatHospID(+CstID) //hxy 2021-05-17 st
    s TakTimeConfig=""
    s:TakType=1 TakTimeConfig=+##Class(web.DHCEMConsultCom).GetEmSysConfig("OPENACCDEFHOUR",PatHospID) //病历
	s:TakType=2 TakTimeConfig=+##Class(web.DHCEMConsultCom).GetEmSysConfig("OPENACCORDDEFHOUR",PatHospID) //医嘱 //ed
	s ListTitle="itmID^LocID^LocDesc^UserID^UserName^TakFlag^TakTime^TakOrdFlag^TakOrd"
	w ##class(web.DHCEMJsonCommon).getJsonStartNoTotal() //输出json前缀串
	s CH="",Num=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s LocDesc=""
	.s LocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)          /// 科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s CareProv=""
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 医生
	.s:CareProvID'="" CareProv=$p(^CTPCP(CareProvID,1),"^",2)
	.s UserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s ID=##Class(web.DHCEMConsult).GetEmrAutID(CstID_"||"_CH,TakType)
	.s TakFlag=$s(ID'="":"Y",1:"N")
	.s TakTime=$p($g(^DHCEMCEA(+ID)),"^",9)             /// 授权时间
	.i (TakTime="")&&(+TakTimeConfig'=0) s TakTime=TakTimeConfig //hxy 2021-05-17
	.i TakTime="" s TakTime=2
	.s:TakType=1 TakOrdFlag="1", TakOrd="病历"
	.s:TakType=2 TakOrdFlag="2", TakOrd="医嘱"
	.s LocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	.s CareProv=##class(web.DHCEMConsultCom).GetTransDesc("User.CTCareProv","CTPCPDesc","",CareProv)
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
/// w ##Class(web.DHCEMConsultQuery).JsEmrAutDet("27")
ClassMethod JsEmrAutDet(rows As %String, page As %String, CstID As %String) As %String
{
	n (rows, page, CstID,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	
	k TMPArrList
	s CH="", Num=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s itmID=CstID_"||"_CH
	.s ID=""
	.F  s ID=$o(^DHCEMCEA(0,"Cst",itmID,ID),-1) Q:ID=""  D
	..s itemID=$p(^DHCEMCEA(ID),"^",1)    /// item
	..s UserID=$p(^DHCEMCEA(ID),"^",2)    /// 授权人
	..s User=""
	..i UserID'="" s User=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s LocID=$p(^DHCEMCEA(ID),"^",3)     /// 授权给予科室
	..s LocDesc=""
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s mUser=""
	..s mUserID=$p(^DHCEMCEA(ID),"^",4)   /// 授权给予医生
	..i mUserID'="" s mUser=$p($g(^SSU("SSUSR",mUserID)),"^",2)
	..s StartDate=$p(^DHCEMCEA(ID),"^",5) /// 开始日期
	..s StartDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(StartDate)
	..s StartTime=$p(^DHCEMCEA(ID),"^",6) /// 开始时间
	..s:StartTime'="" StartTime=$zt(StartTime,2)
	..s EndDate=$p(^DHCEMCEA(ID),"^",7)   /// 结束日期
	..s TakFlag="N"
	..i EndDate>+$H s TakFlag="Y"
	..s EndTime=$p(^DHCEMCEA(ID),"^",8)   /// 结束时间
	..i (EndDate=+$H)&(EndTime>$p($H,",",2)) s TakFlag="Y"
	..s EndDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(EndDate)
	..s:EndTime'="" EndTime=$zt(EndTime,2)
	..s TakOrd=$p(^DHCEMCEA(ID),"^",10)    /// 医嘱录入权限
	..s TakOrd=$case(TakOrd,1:"病历",2:"医嘱",:"")
	..s Num=Num+1
	..s LocDesc=##class(web.DHCEMConsultCom).GetTransDesc("User.CTLoc","CTLOCDesc","",LocDesc)
	..s mUser=##class(web.DHCEMConsultCom).GetTransDesc("User.SSUser","SSUSRName","",mUser)
	..s TakOrd=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsultFixed","TakOrd","",TakOrd)
	..s ListData=itemID_"^"_LocDesc_"^"_mUser_"^"_StartDate_"^"_StartTime_"^"_EndDate_"^"_EndTime_"^"_TakFlag_"^"_TakOrd
	..s TMPArrList(TakFlag_"^"_Num)=ListData
	.

	i Num=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(Num) //输出json结尾符
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

/// Descript: 取指定类型项目的ID
/// w ##Class(web.DHCEMConsultQuery).isExistCsItm("HOS","东华测试一院","2")
ClassMethod isExistCsItm(mCode As %String, mItmDesc As %String, HospID As %String) As %String
{
	n (mCode, mItmDesc, HospID)
	Q:mItmDesc="" ""
	s ID="", quitflag=0
	F  s ID=$o(^DHCEMCDI(0,"Desc",$$ALPHAUP^SSUTIL4(mItmDesc),HospID,ID)) Q:(ID="")||(quitflag=1)  D
	.s CsTypeID=$p(^DHCEMCDI(ID),"^",5)        /// 字典类型
	.Q:$$ALPHAUP^SSUTIL4($p(^DHCEMCDT(CsTypeID),"^",1))'=mCode    /// 代码
	.s quitflag=1
	Q quitflag
}

/// Descript:取会诊申请医嘱ID
/// Input:Type(R:发送,C:完成)
/// w ##Class(web.DHCEMConsultQuery).GetConsOrds("27","R")
ClassMethod GetConsOrds(CstID As %String, ConsType = "") As %String
{
	n (CstID,ConsType)
	s LimitNum=""
	s:ConsType="R" LimitNum=9
	s:ConsType="C" LimitNum=10
	s Ret=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s Ord=$p(^DHCEMCON(CstID,"I",CH),"^",LimitNum)     
	.s:(Ord'="")&&(Ret'="") Ret=Ret_"^"_Ord
	.s:(Ord'="")&&(Ret="") Ret=Ord
	Q Ret
}

/// Creator:    bianshuai
/// CreateDate: 2019-09-16
/// Descritp:	当前会诊是否已经接收
/// InPut:      CstID - 会诊ID
/// OutPut:     0 - 未接收 ，1 - 接收
/// w ##Class(web.DHCEMConsultQuery).IsTakAccept("154||1","30")
ClassMethod IsTakAccept(itmID As %String, stCode As %String) As %Library.String
{
	n (itmID, stCode)
	i itmID'["||" s itmID=itmID_"||"_1
	Q:stCode="" 0
	s LgID="", QuitFlag=0, Flag=0
	F  s LgID=$o(^DHCEMCONL(0,"Cst",itmID,LgID),-1) Q:(LgID="")||(QuitFlag'=0)||(Flag'=0)  D
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态
	.i (stCode="30")&($p(^DHCEMCONS(StatusID),"^",1)="35") s Flag=1
	.Q:$p(^DHCEMCONS(StatusID),"^",1)'=stCode
	.s QuitFlag=1
	.
	Q QuitFlag
}

/// Creator:    qqa
/// CreateDate: 2020-09-17
/// Descritp:	会诊工作流定义审核状态
/// InPut:      CstID - 会诊ID
/// OutPut:     审核状态串
/// w ##Class(web.DHCEMConsultQuery).GetAuditStatusString(1)
ClassMethod GetAuditStatusString(CstID) As %Library.String
{
	n (CstID, %session)
	s ParID=##Class(web.DHCEMConsultWorkFlow).GetCsWorkFlow(CstID)
	q:+ParID=0 ""
	
	s Ret=""
	s Sub=""
	f  s Sub=$o(^DHCEMCONWF(ParID,"I",Sub)) q:Sub=""  d
	.q:+Sub=0
	.s Date = ^DHCEMCONWF(ParID,"I",Sub)
	.s StatusDr=$p(Date,"^",1)
	.q:+StatusDr=0
	.s Code=$p(^DHCEMCONS(+StatusDr),"^",1)
	.s Status=$p(^DHCEMCONS(+StatusDr),"^",2)
	.q:Code=20 ;发送状态不返回
	.s Status=##class(web.DHCEMConsultCom).GetTransDesc("User.DHCEmConsStatus","ECSDesc","",Status)
	.s ItmData=Code_"^"_Status
	.s:Ret'="" Ret=Ret_"#"_ItmData
	.s:Ret="" Ret=ItmData
	Q Ret
}

/// Creator:    hxy
/// CreateDate: 2021-03-04
/// Descript:   获取其他会诊科室以及会诊医生(非||1)
/// w ##Class(web.DHCEMConsultQuery).GetOtherLocDocStr("685","685||1")
ClassMethod GetOtherLocDocStr(CstID As %String, CstItmID As %String)
{
	n (CstID,CstItmID)
	s:+CstItmID'=0 CstID=+CstItmID
	q:+CstID=0 ""
	s:+CstItmID=0 CstItmID=CstID_"||1"
	s ret=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH),-1) Q:CH=""  D
	.s CstItmDr = CstID_"||"_CH
	.q:(CstItmID'="")&&(CstItmID=CstItmDr)
	.s CsLocDesc="",CsUser="", PrvTp=""
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2) /// 会诊科室
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)    
	.s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2) /// 会诊医生
	.s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)
	.s:(PrvTpID="")&&(CareProvID'="") PrvTpID=+##Class(web.DHCEMConsultCom).GetPrvTpIDByCareProvID(CareProvID)
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2) /// 职称
	.s CsUserImg="" //hxy 2021-06-04 st
	.s SignInfo=##Class(web.DHCEMConsultCom).GetIfSignByCstItmID(CstItmDr,"C")
	.s SignFlag=+SignInfo
	.s SignatureID = $p(SignInfo,"^",2)
    .s:SignFlag=1 CsUserImg = "data:image/png;base64,"_##class(CA.BICAService).GetImageBySignID(SignatureID)
	.;s SignFlag=##Class(web.DHCEMConsultCom).GetIfSignByCstItmID(CstItmDr,"C")
    .;s:SignFlag=1 CsUserImg = "data:image/png;base64,"_##class(web.DHCEMConsultCom).GetImageByUserID(CsUserID) //ed
	.i ret="" d
	..s ret = CsLocDesc_"@"_$case(CsUser,"":"",:PrvTp_"-"_CsUser)_"@"_CsUserImg
	.e  d
	..s ret = ret_"#"_CsLocDesc_"@"_$case(CsUser,"":"",:PrvTp_"-"_CsUser)_"@"_CsUserImg
	.
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-03-17
/// Descritp:	是否是相等或者更高的职称类型:根据医护人员类型的代码（国家/地区标准编码）,代码小的职称高，默认代码为（国家/地区标准编码），若ID不等&代码非正整数，则直接返回0
/// InPut:      要求的指定职称类型，当前登陆人的职称类型
/// OutPut:     0 - 否 ，1 - 是
/// w ##Class(web.DHCEMConsultQuery).IsEqHigherPrvTp("2","1")
ClassMethod IsEqHigherPrvTp(AskPrvTpID As %String, LgPrvTpID As %String) As %Library.String
{
	n (AskPrvTpID, LgPrvTpID)
	s ret=0
	q:(+AskPrvTpID=0)!(+LgPrvTpID=0) ret
	q:AskPrvTpID=LgPrvTpID 1
	s AskPrvTpCode=+$p($g(^CT("CPT",+AskPrvTpID)),"^",1)
	s LgPrvTpCode=+$p($g(^CT("CPT",+LgPrvTpID)),"^",1)
	q:(+AskPrvTpCode=0)!(+LgPrvTpCode=0) ret
	s:LgPrvTpCode<AskPrvTpCode ret=1
	q ret
}

/// Decript:归档使用
/// w ##class(web.DHCEMConsultQuery).GetCstPrintConsByAdm("43491")
ClassMethod GetCstPrintConsByAdm(AdmID)
{
	n (AdmID)
	q:+AdmID=0 "[]"
	s Count=0
	
	s Ret="["
	s CstID=0
	f  s CstID=$o(^DHCEMCON(0,"ADM",AdmID,CstID)) q:CstID=""  d
	.s CH=0
	.f  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	..s CstItmID = CstID_"||"_CH
	..s Count=Count+1
	..s Ret=Ret_$case(Count,1:"",:",")
	..s Ret=Ret_##Class(web.DHCEMConsultQuery).GetPisPrintCon(CstID,CstItmID,"","")
	.
	s Ret=Ret_"]"
	q Ret
}

/// Creator:    hxy
/// CreateDate: 2021-06-22
/// Descritp:	取下一个会诊工作流状态Code
/// InPut:      CstID - 会诊ID
/// OutPut:     空 ，非空 - 状态代码
/// w ##Class(web.DHCEMConsultWorkFlow).GetUserGrantStCode("154")
ClassMethod GetNextStCode(CstID As %String, CstHospID As %String) As %Library.String
{
	n (CstID, CstHospID)
	s ret=""
	s NextStID=""
	s NextWFID=##Class(web.DHCEMConsultWorkFlow).GetNextWorkFlowItem(CstID,CstHospID)
	s:NextWFID'="" NextStID=$p(^DHCEMCONWF(+NextWFID,"I",$p(NextWFID,"||",2)),"^",1)
	s ret=$p($g(^DHCEMCONS(+NextStID)),"^",1)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-22
/// Descritp:	取下一个会诊工作流状态Desc
/// InPut:      CstID - 会诊ID
/// OutPut:     空 ，非空 - 状态描述
/// w ##Class(web.DHCEMConsultQuery).GetNextStDesc("154")
ClassMethod GetNextStDesc(CstID As %String, CstHospID As %String) As %Library.String
{
	n (CstID, CstHospID)
	s ret=""
	s NextStID=""
	s NextWFID=##Class(web.DHCEMConsultWorkFlow).GetNextWorkFlowItem(CstID,CstHospID)
	s:NextWFID'="" NextStID=$p(^DHCEMCONWF(+NextWFID,"I",$p(NextWFID,"||",2)),"^",1)
	s ret=$p($g(^DHCEMCONS(+NextStID)),"^",2)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-06-28
/// Descritp:	当前登录是不是大科审核权限
/// InPut:      WFID - 工作流ID,LgParams-登录信息
/// OutPut:     1 - 是
/// w ##Class(web.DHCEMConsultWorkFlow).GetLeadConFlag("4","118^203^9")
/// w ##Class(web.DHCEMConsultWorkFlow).GetLeadConFlag("4","29^113^12175")
/// w ##Class(web.DHCEMConsultWorkFlow).GetLeadConFlag("4","30^113^12175")
ClassMethod GetLeadConFlag(WFID As %String, LgParams As %String) As %Library.String
{
	n (WFID, LgParams)
	s ret=""
	s StDr=##Class(web.DHCEMConsult).GetConsStatus(75)
	q:StDr="" ""
	s ICH=$o(^DHCEMCONWF(0,"Status",StDr,WFID,""))
	q:ICH="" ""
	s WIID=WFID_"||"_ICH //大科审核的工作流itmID
	
	s LgGroupID=$p(LgParams,"^",1)  /// 安全组
	s LgLocID=$p(LgParams,"^",2)    /// 科室
	s LgUserID=$p(LgParams,"^",3)   /// 人员
	
	/// 按人取配置
	i LgUserID'=""  d
	.s:$d(^DHCEMCONG(0,"TypePointer","U",LgUserID,WIID)) ret=1

	/// 按安全组取
	i LgGroupID'=""  d
	.s:$d(^DHCEMCONG(0,"TypePointer","G",LgGroupID,WIID)) ret=1

    /// 按科室取
	i LgLocID'=""  d
	.s:$d(^DHCEMCONG(0,"TypePointer","L",LgLocID,WIID)) ret=1

	q ret
}

}
