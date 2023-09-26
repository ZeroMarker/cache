Import SQLUser

/// Creator: 	sufan
/// CreateDate: 2020-05-18
/// Descript: 	用药教育
Class web.DHCCKBMedEducation Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取病人基本就诊信息
/// w ##Class(web.DHCCKBMedEducation).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay) //hxy 2017-03-03 $zd(PatBDay,3)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis($g(EpisodeID)) //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	i $L(PatDiagDesc)>14 s PatDiagDesc=$E(PatDiagDesc,1,16)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	  /// 就诊类型
 	s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
	i PatBed="" s PatBed=##Class(web.DHCEMNurAddOrder).GetPatSeatNo(EpisodeID) /// 座位号
	s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)          /// 费别指针
	s PatBill=$p($g(^PAC("ADMREA",+BillTypeID)),"^",2)
	
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" PatBill=$p(^CT("SS",BillType),"^",2)
	
    s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PatType) /// 费别
    s PresTypes=$p(PrescriptTypeStr,"^",2)   /// 默认费别
	s BillTypeID=$p(PresTypes,":",1), BillType=$p(PresTypes,":",2)
	s BillType=$p($g(^PAC("ADMREA",+BillTypeID)),"^",2)

	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_PatBill_"^"_BillTypeID_"^"_BillType
	
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^PatType^PatSLv^PatLv^mradm^PatBed^PatBill^BillTypeID^BillType"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:获取病人基本就诊信息
/// w ##Class(web.DHCCKBMedEducation).GetPatPresInfo("","2")
ClassMethod GetPatPresInfo(PatientID, EpisodeID)
{
	n (PatientID,EpisodeID)
	Q 0
}

}
