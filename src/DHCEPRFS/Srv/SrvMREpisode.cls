Class DHCEPRFS.Srv.SrvMREpisode Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMREpisode";

ClassMethod GetMREpisodeInfo(AMREpisodeID As %String, AColumns) As %String [ WebMethod ]
{
	s:(AMREpisodeID = $c(0)) AMREpisodeID = ""
	s:(AColumns = $c(0)) AColumns = ""
	s info = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeInfo(AMREpisodeID,AColumns)
	q info
}

ClassMethod RegMREpisodeID(APatientID As %String, AEpisodeID As %String, ASysCode As %String) As %String [ WebMethod ]
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeID(APatientID, AEpisodeID, ASysCode)
	q mrEpisodeID
}

ClassMethod RegMREpisodeIDByAdm(AEpisodeID As %String, ASysCode As %String) As %String [ WebMethod ]
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegMREpisodeIDByAdm(AEpisodeID, ASysCode)
	q mrEpisodeID
}

ClassMethod RegAll(AInputParam As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).RegAll(AInputParam)
	q ret
}

ClassMethod RegAllSub(AInputParam As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).RegAllSub(AInputParam)
	q ret
}

ClassMethod RegAllScan(AInputParam As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).RegAllScan(AInputParam)
	q ret
}

ClassMethod RegWholeItem(AEpisodeID As %String, ASysCode As %String, ATypeID As %String, APrintDocID As %String, ATotalPages As %String, ALogicID As %String, ALogicPath As %String) As %String [ WebMethod ]
{
	s mrVerItemDetailID = ##Class(DHCEPRFS.BL.BLMREpisode).RegWholeItem(AEpisodeID,ASysCode,ATypeID,APrintDocID,ATotalPages,ALogicID,ALogicPath)
	q mrVerItemDetailID
}

ClassMethod GetMREpisodeIDByAdm(AEpisodeID As %String, ASysCode As %String) As %String [ WebMethod ]
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID, ASysCode)
	q mrEpisodeID
}

ClassMethod GetPatName(AMREpisodeID As %String) As %String [ WebMethod ]
{
	s name = ##Class(DHCEPRFS.BL.BLMREpisode).GetPatName(AMREpisodeID)
	q name
}

ClassMethod GetPatNameByAdm(AEpisodeID As %String, ASysCode As %String = "DHC") As %String [ WebMethod ]
{
	s name = ##Class(DHCEPRFS.BL.BLMREpisode).GetPatNameByAdm(AMREpisodeID, ASysCode)
	q name
}

ClassMethod GetChildByMRAdmID(AMREpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByMRAdmID(AMREpisodeID)
	q ret
}

ClassMethod GetChildByAdmID(ASysCode As %String, AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).GetChildByAdmID(ASysCode, AEpisodeID)
	q ret
}

ClassMethod GetMedRecordNoByMrEpisodeID(AMrEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).GetMedRecordNoByMrEpisodeID(AMrEpisodeID)
	q ret
}

ClassMethod GetMrInfo(AMrEpisodeID As %String, AColumns As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeInfo(AMrEpisodeID,AColumns)
	q ret
}

ClassMethod GetMrEpisodeInfoByMrEpisodeID(AMrEpisodeID As %String) As DHCEPRFS.Entity.EMREpisode [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLMREpisode).GetMrEpisodeInfoByMrEpisodeID(AMrEpisodeID)
	q entity
}

ClassMethod RegVirtualMREpisodeID(ARelatedMREpisodeID As %String) As %String [ WebMethod ]
{
	s mrEpisodeID = ##Class(DHCEPRFS.BL.BLMREpisode).RegVirtualMREpisodeID(ARelatedMREpisodeID)
	q mrEpisodeID
}

ClassMethod GetEpisodeList(AMRMedRecordNo As %String) As DHCEPRFS.DataSet.EMREpisodeList [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EMREpisodeList).%New()
	d result.SetArgs(AMRMedRecordNo)
	q result
}

ClassMethod AssignFSMREpisode(AMRPatientID As %String, AMRMedRecordID As %String, AAdmLocID As %String, AAdmLoc As %String, ADisLocID As %String, ADisLoc As %String, AAdmDate As %String, ADisDate As %String, ADeathDate As %String = "") As %String [ WebMethod ]
{
	s:(ADeathDate = $c(0)) ADeathDate = ""
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).AssignFSMREpisode(AMRPatientID,AMRMedRecordID,AAdmLocID,AAdmLoc,ADisLocID,ADisLoc,AAdmDate,ADisDate,ADeathDate)
	q ret
}

ClassMethod ModifyEpisode(AEpisodeID As %String, AAdmLocID As %String, AAdmLoc As %String, ADisLocID As %String, ADisLoc As %String, AAdmDate As %String, ADisDate As %String, ADeathDate As %String = "") As %String [ WebMethod ]
{
	s:(ADeathDate = $c(0)) ADeathDate = ""
	s ret = ##Class(DHCEPRFS.BL.BLMREpisode).ModifyEpisode(AEpisodeID,AAdmLocID,AAdmLoc,ADisLocID,ADisLoc,AAdmDate,ADisDate,ADeathDate)
	q ret
}

ClassMethod GetDisDateTimeByEpisode(AEpisodeID As %String) As %String [ WebMethod ]
{
	q:(AEpisodeID = "") ""
	s arrFiles = ##class(%ArrayOfDataTypes).%New()
	s arrFiles = ##Class(DHCEPRFS.BL.HISInfo.BLEpisodeInfo).GetEpisodeInfoByPAADM(AEpisodeID)
	s disDate = $p(arrFiles.GetAt("PADischgeDateTime"),",",1)
	q disDate
}

ClassMethod GetRelatedMREpisodeByType(AMREpisodeID As %String, ARelatedType As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisodeRelate).GetRelatedMREpisodeByType(AMREpisodeID,ARelatedType)
	q ret
}

ClassMethod GetEpisodeTypeByIds(AEpisodeIDs As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisode).GetEpisodeTypeByIds(AEpisodeIDs)
	q ret
}

ClassMethod CheckScanPrivilege(AMREpisodeID As %String, AQueryUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLPrivilege).CheckScanPrivilege(AMREpisodeID,AQueryUserID)
	q ret
}

ClassMethod GetHosAreaID(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMREpisode).GetHosAreaIDByAdm(AEpisodeID)
	q ret
}

}
