/// 取病人本次就诊的相关信息
Class web.DHCFBAdmInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// 根据本诊就诊的诊断ID取诊断相关信息
ClassMethod GetDiagById(Para As %String) As %String
{
	q:$g(Para)="" ""
	s del="^"
	s MrAdmId=$p(Para,del,1),MrDiagId=$p(Para,del,2)
	q:$g(MrAdmId)="" ""
	q:$g(MrDiagId)="" ""
	s RetStr=""
	s MrDescOther=""  //诊断的其他描述
	s DiagDoctorCode="",DiagDoctorDesc=""
	s MrDiagStr=$g(^MR(MrAdmId,"DIA",MrDiagId))
	s IcdId=$p(MrDiagStr,del,1)
	q:('$d(^MRC("ID",IcdId))) ""
	s MrStr=$g(^MRC("ID",IcdId))
	s MrCode=$p(MrStr,del,4),MrDesc=$p(MrStr,del,2) //诊断代码?名称
	IF $D(^MR(MrAdmId,"DIA",MrDiagId,"DES",0)) S MrDescOther=^MR(MrAdmId,"DIA",MrDiagId,"DES",1),MrDescOther=$TR(MrDescOther,$C(10,13),""),MrDescOther=$TR(MrDescOther,$C(13,10),"")
	s DescOther=$p(MrStr,del,23),DescOther=$tr(DescOther,$c(10,13),""),DescOther=$tr(DescOther,$c(13,10),"")
	s DiagDate=$p(MrDiagStr,del,7),DiagDate=$zd(DiagDate,3)
	s DiagTime=$p(MrDiagStr,del,8),DiagDate=$zdt(DiagDate)
	s DiagType="",DiagTypeDr="",MrDiagTypeId=""
	for  s MrDiagTypeId=$o(^MR(MrAdmId,"DIA",MrDiagId,"TYP",MrDiagTypeId)) q:MrDiagTypeId=""  d
	.s DiagTypeDr=$p(^MR(MrAdmId,"DIA",MrDiagId,"TYP",MrDiagTypeId),del,1)
	.s DiagType=$p(^MRC("DTYP",DiagTypeDr),del,2)
	S DiagDoctorDr=$p(^MR(MrAdmId,"DIA",MrDiagId),del,4)
	if $g(DiagDoctorDr)'=""  d
	.s:$d(^CTPCP($g(DiagDoctorDr))) DiagDoctorCode=$p(^CTPCP(DiagDoctorDr,1),del,1),DiagDoctorDesc=$p(^CTPCP(DiagDoctorDr,1),del,2)
	s RetStr=DiagType_del_MrCode_del_MrDesc_del_MrDescOther_del_DiagDate_del_DiagTime_del_DiagDoctorCode_del_DiagDoctorDesc_del_DescOther
	q RetStr
}

}
