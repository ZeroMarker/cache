Class DHCEPRFS.Srv.SrvMRVerItemDetail Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRVerItemDetail";

/// Desc:	注册MRVerItemDetail并获取其RowID
ClassMethod RegMRVerItemDetailID(AMRVerItemID As %String, ADetailNum As %String, AFileMasterID As %String, AFileMasterPath As %String, ATotalCount As %String = "") As %String [ WebMethod ]
{
	s mrVerItemDetailID = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).RegMRVerItemDetailID(AMRVerItemID,ADetailNum,AFileMasterID,AFileMasterPath,ATotalCount)
	q mrVerItemDetailID
}

/// Desc:	获取指定MRVerItemDetail的RowID
ClassMethod GetMRVerItemDetailID(AMRVerItemID As %String, ADetailNum As %String) As %String [ WebMethod ]
{
	s mrVerItemDetailID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(AMRVerItemID,ADetailNum)
	q mrVerItemDetailID
}

/// Desc:	获取指定MRVerItem下的所有MRVerItemDetail信息
ClassMethod GetAllByItem(AMRVerItemIDList As %String, ANeedLocPath As %String = "0", ALastVersion As %String = "", AMRLogDetailID As %String = "") As DHCEPRFS.DataSet.EMRVerItemDetailByItemDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.EMRVerItemDetailByItemDS).%New()
	d ds.SetArgs(AMRVerItemIDList, ANeedLocPath,ALastVersion,AMRLogDetailID)
	q ds
}

/// Desc:	获取指定MRVerItem下的所有MRVerItemDetail信息
ClassMethod GetDetailByDetail(AMRVerItemIDList As %String, ADetailNum As %String, ANeedLocPath As %String = "0") As DHCEPRFS.DataSet.EMRVerItemDetailByDtlDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.EMRVerItemDetailByDtlDS).%New()
	d ds.SetArgs(AMRVerItemIDList, ADetailNum, ANeedLocPath)
	q ds
}

ClassMethod DeleteMergeDetail(AMRVerItemID As %String, AMergeDetailNum As %String) [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).DeleteMergeDetail(AMRVerItemID,AMergeDetailNum) 
	q ret
}

ClassMethod GetMaxDetailNum(AMREpisodeID As %String, AMRVerItemID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNum(AMRVerItemID) 
	q ret
}

ClassMethod GetBeforeDetailNum(AMREpisodeID As %String, AMRVerItemID As %String, ADetailNum As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetBeforeDetailNum(AMRVerItemID,ADetailNum) 
	q ret
}

ClassMethod GetNextDetailNum(AMREpisodeID As %String, AMRVerItemID As %String, ADetailNum As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetNextDetailNum(AMRVerItemID,ADetailNum) 
	q ret
}

/// w ##Class(DHCEPRFS.Srv.SrvMRVerItemDetail).GetMaxDetailNumByMRItem("2","49","")
ClassMethod GetMaxDetailNumByMRItem(AMREpisodeID As %String, AMRItemID As %String, AVersionCode As %String = "") As %String [ WebMethod ]
{
	s MRVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndMRAdmID(AMREpisodeID,AMRItemID,AVersionCode)
	q:(MRVerItemID="") "0"
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNum(MRVerItemID) 
	q ret
}

ClassMethod GetMaxDetailNumByEpisode(AEpisodeID As %String, AType As %String, ATypeParams As %String, AVersionCode As %String = "") As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetMaxDetailNumByEpisode(AEpisodeID,AType,ATypeParams,AVersionCode) 
	q ret
}

ClassMethod GetToNumList(AEpisodeID As %String, AVersionTypeCode As %String, AMRItemParamList As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumList(AEpisodeID,AVersionTypeCode,AMRItemParamList)
	q ret
}

ClassMethod GetToNumListSub(AEpisodeID As %String, AVersionTypeCode As %String, AMRItemSubParamList As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumListSub(AEpisodeID,AVersionTypeCode,AMRItemSubParamList)
	q ret
}

ClassMethod GetToNumListByMR(AMREpisodeID As %String, AVersionCode As %String, AMRItemIDList As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumListByMR(AMREpisodeID,AVersionCode,AMRItemIDList)
	q ret
}

ClassMethod GetCommonToNumListByMR(AMRID As %String, AVersionCode As %String, AMRItemIDList As %String, AType As %String = "") As %String [ WebMethod ]
{
	s:(AType = $c(0)) AType = ""
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).GetToNumListByMR(AMRID,AVersionCode,AMRItemIDList,AType)
	q ret
}

ClassMethod RegDetailList(AMREpisodeID As %String, AVersionCode As %String, AMRVerItemDetailList As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).RegDetailList(AMREpisodeID, AVersionCode, AMRVerItemDetailList)
	q ret
}

ClassMethod RegCommonDetailList(AMRID As %String, AVersionCode As %String, AMRVerItemDetailList As %String, AType As %String = "") As %String [ WebMethod ]
{
	s:(AType = $c(0)) AType = ""
	s ret = ##Class(DHCEPRFS.BL.BLMRVerItemDetail).RegDetailList(AMRID, AVersionCode, AMRVerItemDetailList,AType)
	q ret
}

}
