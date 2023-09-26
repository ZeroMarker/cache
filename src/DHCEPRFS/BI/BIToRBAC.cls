Class DHCEPRFS.BI.BIToRBAC Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	获取病历是否扫描过
/// Input:	AEpisodeID : 就诊rowid
/// Debug:	w ##Class(DHCEPRFS.BI.BIToRBAC).GetMedRecordStatus("1")
ClassMethod HasScanned(AEpisodeID As %String) As %String
{
	s ret = ##Class(DHCEPRFS.BL.BLMRLog).HasScannedByEpisodeID(AEpisodeID)
	q ret
}

}
