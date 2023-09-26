Class DHCEPRFS.Prison.BL.BLThirdParty Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: OA每完成一个犯人的文档就会调用此接口(初步对OA文档不分类，统一称为"申请审批表")
/// Input:PAINumber:犯人监禁编号    CompleteDate:填表完成日期    CompleteTime:填表完成时间    FilePath:文件地址(json格式)
/// debug: w ##class(DHCEPRFS.Prison.BL.BLThirdParty).OAComplete("132","373","1^2^CG07|||2^6^CG07|||3^7^CG07")
ClassMethod OAComplete(PAINumber As %String, CompleteDate As %String, CompleteTime As %String, FilePath As %String) As %String
{
	q:(PAINumber = "") ""
	q:(CompleteDate = "") ""
	q:(CompleteTime = "") ""
	q:(FilePath = "") ""
	
	s CompleteDate = $zdh(CompleteDate,3)
	s CompleteTime = $zth(CompleteTime,3)
	
	s patientID = ""
	&sql(select PAI_PER_ParRef into :patientID from SQLUser.PAPerson_Imprison
		where PAI_Number = :PAINumber)
	q:(patientID = "") ""
	
	do ##class(DHCEPRFS.Prison.BL.BLImprisonInfo).UpdateImprisonInfo(PAINumber)
	
	s mrPatientID = ""
	s mrPatientID = $o(^DHCEPRFS.INST.MRPatientI("IdxPatientID"," DHC"," "_patientID,mrPatientID))
	if (mrPatientID = "")
	{
		s mrPatientID = ##Class(DHCEPRFS.BL.BLMRPatient).RegMRPatientID(patientID, "DHC","")
	}
	q:(mrPatientID = "") ""
	s EpisodeID = ""
	s obj = ##class(DHCEPRFS.INST.MREpisode).%New()
	S obj.DisDate = CompleteDate
	s obj.DisTime = CompleteTime
	s obj.MRPatientID = mrPatientID
	s obj.EpisodeID = "OA"+obj.%Id()
	s EpisodeID = "OA"+obj.%Id()
	s obj.Type = "OA"
	s obj.SysCode = "DHC"
	s sc = obj.%Save()
	if ($$$ISOK(sc))
	{
		s mrEpisodeID = obj.%Id()
	}
	else
	{
		q ""
	}
	
	s rowID = ""
	s rowID = $o(^DHCEPRFS.INST.AdmMRQueueI("IdxEpisodeID"," "_EpisodeID,rowID))
	if (rowID ="")
	{
		s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%New()
		s obj.EpisodeID = EpisodeID
		s obj.ActDate = $p($h , "," , 1)
		s obj.ActTime = $p($h , "," , 2)
		s obj.CreateFlag = "0"
		s obj.UserID = AUserID
		s obj.FilePath = FilePath
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			q "1"
		}
	}
	else
	{
		s obj = ##class(DHCEPRFS.INST.AdmMRStatusQueue).%OpenId(rowID)
		s obj.ActDate = $p($h , "," , 1)
		s obj.ActTime = $p($h , "," , 2)
		s obj.CreateFlag = "0"
		s obj.UserID = AUserID
		s obj.FilePath = FilePath
		s sc = obj.%Save()
		if ($$$ISOK(sc))
		{
			q "1"
		} 
	}
}

}
