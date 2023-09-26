/// Creator:      qqa
/// CreatDate:    2021.08.16
/// Description:  急诊患者状态查询
Class web.DHCEMEmStateView Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Descript:获取患者信息
ClassMethod GetPatData(EpisodeID, LgHospID = "")
{
	n (EpisodeID,LgHospID)
	s PatientID=+^PAADM(EpisodeID)
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)	/// 病人登记号
	s LatestEmAdmId=##class(web.DHCEMEmStateView).GetPatLastEmAdmId(PatientID,LgHospID)
	q PatientID_"^"_PatNo_"^"_LatestEmAdmId
}

/// Descript:获取患者信息
/// w ##class(web.DHCEMEmStateView).GetPatAdmData("0000000012","2") 
ClassMethod GetPatAdmData(PatNo, LgHospID = "")
{
	n (PatNo,LgHospID)
	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatNo,""),-1)
	q:+PatientID=0 ""
	s LatestEmAdmId=##class(web.DHCEMEmStateView).GetPatLastEmAdmId(PatientID,LgHospID)
	q PatientID_"^"_LatestEmAdmId
}

/// Descript:患者最新就诊
/// w ##class(web.DHCEMEmStateView).GetPatLastEmAdmId("111","2")
ClassMethod GetPatLastEmAdmId(PatientID, LgHospID)
{
	n (PatientID,LgHospID)
	s LatestEmAdmId="",EpisodeID=""
	f  s EpisodeID=$o(^PAPERdr(PatientID,"ADM","E",EpisodeID),-1) q:(EpisodeID="")||(LatestEmAdmId'="")  d
	.s AdmHospId=##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
	.q:(LgHospID'="")&&(LgHospID'=AdmHospId)
	.s LatestEmAdmId = EpisodeID
	q LatestEmAdmId
}

/// Descript:状态ID
/// w ##class(web.DHCEMEmStateView).ListEmState()
ClassMethod ListEmState()
{
	s Count=0
	w "["
	s ID=0
	f  s ID=$o(^DHCPACVisitStatus(ID)) q:ID=""  d
	.s Text=$p(^DHCPACVisitStatus(ID),"^",2)
	.s Active=$p(^DHCPACVisitStatus(ID),"^",11)
	.q:Active="N"
	.s Text=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",Text)
	.s Tmp=ID_"^"_Text
	.s Count = Count+1
	.i Count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	.e  d
	..W ","_##class(web.DHCEMJsonCommon).getJsonData("value^text",Tmp)
	w "]"
	q ""
}

}
