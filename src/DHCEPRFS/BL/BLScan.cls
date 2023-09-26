Class DHCEPRFS.BL.BLScan Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SetScanStatus(AMREpisodeID As %String, AStatus As %String, AUserID As %String) As %String
{
	q:(AMREpisodeID ="") "0"
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(obj = "") "0"
	s episodeID = obj.EpisodeID
	s rowID =  $o(^DHCEPRFS.INST.CheckedPatListI("IdxEpisode"," "_episodeID,""))
	if (rowID = "")
	{
		s objChecked = ##class(DHCEPRFS.INST.CheckedPatList).%New()
		s episodeInfo = ##class(%ArrayOfDataTypes).%New()
		s episodeInfo = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(episodeID)
		s patientID = episodeInfo.GetAt("PatientID")
		s patientInfo = ##class(%ArrayOfDataTypes).%New()
		s patientInfo = ##class(DHCEPRFS.BL.HISInfo.BLPatientInfo).GetPatientInfoByPAPMI(patientID)
		s objChecked.MedRecordNo = patientInfo.GetAt("MedRecordNo")
		s objChecked.RegNo = patientInfo.GetAt("RegNo")
		s objChecked.EpisodeID = episodeID
		s objChecked.Name = patientInfo.GetAt("PAPMIName")
		s objChecked.PAAdmDepID = episodeInfo.GetAt("PAAdmLocID")
		s objChecked.CreateDate = $p($h,",",1)
		s objChecked.CreateTime = $p($h,",",2)
		s objChecked.CreateUserID = AUserID
		s objChecked.PAAdmType = episodeInfo.GetAt("PAAdmTypeValue")
		s objChecked.ScanStatus = AStatus
	}
	else
	{
		s objChecked = ##class(DHCEPRFS.INST.CheckedPatList).%OpenId(rowID)
		s objChecked.ScanStatus = AStatus
	}
	s sc = objChecked.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

ClassMethod ApplyScan(AMREpisodeID As %String, AUserID As %String, ADeptID As %String, ARequestComment As %String = "") As %String
{
	q:(AMREpisodeID = "") "0"
	s obj = ##class(DHCEPRFS.INST.MREpisode).%OpenId(AMREpisodeID)
	q:(obj = "") "0"
	s episodeID = obj.EpisodeID
	s rowID = $o(^DHCEPRFS.INST.AuthorizationI("IdxMREpisodeID"," "_AMREpisodeID,""))
	if (rowID = "")
	{
		s objApply = ##class(DHCEPRFS.INST.AuthorizationInfo).%New()
		s objApply.EpisodeID = episodeID
		s objApply.MREpisodeID = AMREpisodeID
		s objApply.RequestUserID = AUserID
		s objApply.RequestDept = ADeptID
		s objApply.RequestComment = ARequestComment
		s objApply.RequestDate = $p($h,",",1)
		s objApply.RequestTime = $p($h,",",2)
		s objApply.RequestType = "SCAN"
		s objApply.AppointStatus = "N"
	}
	else
	{
		s objApply = ##class(DHCEPRFS.INST.AuthorizationInfo).%OpenId(rowID)
		s objApply.EpisodeID = episodeID
		s objApply.RequestUserID = AUserID
		s objApply.RequestDept = ADeptID
		s objApply.RequestComment = ARequestComment
		s objApply.RequestDate = $p($h,",",1)
		s objApply.RequestTime = $p($h,",",2)
		s objApply.RequestType = "SCAN"
		s objApply.AppointStatus = "N"
	}
	s sc =objApply.%Save()
	if ($$$ISOK(sc))
	{
		q "1"
	}
	else
	{
		q "0"
	}
}

}
