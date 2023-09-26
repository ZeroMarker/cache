Class DHCEPRFS.Srv.SrvMRVerItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRVerItem";

/// Desc:	注册MRVerItem并获取其RowID
ClassMethod RegMRVerItemID(AMRVersionID As %String, AMRItemID As %String, ATotCount As %String) As %String [ WebMethod ]
{
	s mrVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).RegMRVerItemID(AMRVersionID,AMRItemID,ATotCount)
	q mrVerItemID
}

/// Desc:	获取指定MRVerItem的RowID
ClassMethod GetMRVerItemID(AMRVersionID As %String, AMRItemID As %String, ATotCount As %String) As %String [ WebMethod ]
{
	s mrVerItemID = ##Class(DHCEPRFS.BL.BLMRVerItem).GetMRVerItemID(AMRVersionID,AMRItemID,ATotCount)
	q mrVerItemID
}

ClassMethod GetTotalItemDetailCount(AMREpisodeID As %String, AMRVersion As %String) As %String [ WebMethod ]
{
	s totalCount = ##Class(DHCEPRFS.BL.BLMRVerItem).GetTotalItemDetailCount(AMREpisodeID, AMRVersion)
	q totalCount
}

ClassMethod GetTotalCountByVerItemIDs(AVerItemIDs As %String) As %String [ WebMethod ]
{
	s totalCount = ##Class(DHCEPRFS.BL.BLMRVerItem).GetTotalCountByVerItemIDs(AVerItemIDs)
	q totalCount
}

ClassMethod GetMRVerSubItem(AMRVerItemID As %String) As DHCEPRFS.DataSet.ESubItemsDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.ESubItemsDS).%New()
	d ds.SetArgs(AMRVerItemID)
	q ds
}

ClassMethod GetAllByVersion(AMRVersionID As %String) As DHCEPRFS.DataSet.EMRVerItemByVersionDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.EMRVerItemByVersionDS).%New()
	d ds.SetArgs(AMRVersionID)
	q ds
}

ClassMethod GetAllByVersionString(AMRVersionID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetAllByVersionString(AMRVersionID)
	q ret
}

ClassMethod GetAllItemByVersionString(AMRVersionIDS As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetAllItemByVersionString(AMRVersionIDS)
	q ret
}

ClassMethod GetAllByVersionCor(AMRVersionID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetAllByVersionString(AMRVersionID,"Y")
	q ret
}

ClassMethod GetVerItemsByVerItemsIDs(AVerItemsIDs As %String) As DHCEPRFS.DataSet.EMRVerItemsByIDDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.EMRVerItemsByIDDS).%New()
	d ds.SetArgs(AVerItemsIDs)
	q ds
}

ClassMethod GetVerItemsEpisodeByIDs(AParam As DHCEPRFS.Entity.EMRVerItem) As DHCEPRFS.DataSet.EMRVerItemsEpisodeByIDDS [ WebMethod ]
{
	s ds = ##class(DHCEPRFS.DataSet.EMRVerItemsEpisodeByIDDS).%New()
	d ds.SetArgs(AParam)
	q ds
}

/// Desc:根据目录类型获取指定MRVersionID的病历项目
/// Creator:Candyxu 
/// Createdate:2013-06-17
/// Input:AMREpisdoeID 归档就诊号,AVersion,版本,AType 目录类型
ClassMethod GetItemByType(AMREpisdoeID As %String, AVersion As %String, AType As %String, ANeedLocPath As %String = "0") As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRVerItem:GetItemByType")
	d ds.SetArgs(AMREpisdoeID,AVersion,AType,ANeedLocPath)
	q ds
}

/// Desc:根据目录类型获取指定MRVersionID的病历项目
/// Creator:Candyxu 
/// Createdate:2013-06-17
/// Input:AMREpisdoeID 归档就诊号,AVersion,版本,AType 目录类型
ClassMethod GetCommonItemByType(AMRID As %String, AVersion As %String, AType As %String, ANeedLocPath As %String = "0", AIDType As %String = "", AUserID As %String = "") As %XML.DataSet [ WebMethod ]
{
	s:(AIDType = $c(0)) AIDType = ""
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRVerItem:GetItemByType")
	d ds.SetArgs(AMRID,AVersion,AType,ANeedLocPath,AIDType,AUserID)
	q ds
}

/// Desc: 	删除MRVerItem
ClassMethod DeleteMRVerItem(AMRVersionID As %String, AMRItemID As %String) As %String [ WebMethod ]
{
	s status = ##Class(DHCEPRFS.BL.BLMRVerItem).DeleteMRVerItem(AMRVersionID,AMRItemID)
	q status
}

/// Desc: 	删除MRVerItem
ClassMethod DeleteMRVerItemByEpisodeAndType(AEpisodeID As %String, AType As %String, ATypeParam As %String) As %String [ WebMethod ]
{
	s status = ##Class(DHCEPRFS.BL.BLMRVerItem).DeleteMRVerItemByEpisodeAndType(AEpisodeID,AType,ATypeParam)
	q status
}

/// Desc: 	删除MRVerItem
ClassMethod DeleteMRVerItemByMrEpisodeID(AMrEpisodeID As %String, AMRItemID As %String) As %String [ WebMethod ]
{
	s status = ##Class(DHCEPRFS.BL.BLMRVerItem).DeleteMRVerItemByMrEpisodeID(AMrEpisodeID,AMRItemID)
	q status
}

/// Desc: 	删除MRVerItem
ClassMethod DeleteByID(AMRVerItemID As %String) As %String [ WebMethod ]
{
	s status =  ##Class(DHCEPRFS.BL.BLMRVerItem).DeleteByID(AMRVerItemID)
	q status
}

ClassMethod GetReleatedVerItem(AMRVersionID As %String, AMRItemID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRVerItem:GetReleatedVerItem")
	d ds.SetArgs(AMRVersionID,AMRItemID)
	q ds
}

ClassMethod GetRedundantVerItem(AMRVersionID As %String, ACorrectItemIDList As %String, ASchemeID As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRVerItem:GetRedundantVerItem")
	d ds.SetArgs(AMRVersionID,ACorrectItemIDList,ASchemeID)
	q ds
}

ClassMethod GetVerItemByItemIDAndEpisodeID(AEpisodeID As %String, AItemID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetVerItemByItemIDAndEpisodeID(AEpisodeID,AItemID)
	q ret
}

/// Desc:根据方案条目内容获得查看内容
ClassMethod GetVerItemBySchemeItemsString(ASchemeItems As %String, AMRVersionID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeItemsString(ASchemeItems,AMRVersionID)
}

/// Desc:根据方案条目内容获得查看内容
ClassMethod GetVerItemBySchemeItemsStringAndSchemeID(ASchemeItems As %String, AMRVersionID As %String, ASchemeID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLPrintScheme).GetVerItemBySchemeItemsStringAndSchemeID(ASchemeItems,AMRVersionID,ASchemeID)
}

/// Desc:根据MRVersionID获取应有的项目
/// Creator:liushuang
/// Createdate:2016-12-01
ClassMethod GetCategoryByAMRVersionID(AMRVersionID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLPrintScheme).GetCategoryByAMRVersionID(AMRVersionID)
}

ClassMethod GetMrVerItemByMRItemCode(AMREpisdoeID As %String, AVersion As %String, AMRItemCode As %String, ADetailNum As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetMrVerItemByMRItemCode(AMREpisdoeID,AVersion,AMRItemCode,ADetailNum)
	q ret
}

ClassMethod DeleteItemList(AMREpisodeID As %String, AVersionCode As %String, AMRItemIDList As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).DeleteItemList(AMREpisodeID, AVersionCode, AMRItemIDList)
	q ret
}

ClassMethod CommonDeleteItemList(AMRID As %String, AVersionCode As %String, AMRItemIDList As %String, AType As %String = "") As %String [ WebMethod ]
{
	s:(AType=$c(0)) AType = ""
	s:(AVersionCode = $c(0)) AVersionCode=""
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).DeleteItemList(AMRID, AVersionCode, AMRItemIDList,AType)
	q ret
}

ClassMethod GetMRItemIDByVerItemID(AMRVerItemID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetMRItemIDByVerItemID(AMRVerItemID)
	q ret
}

ClassMethod MRVerItemIsChecked(AMRVerItemIDS As %String, ASchemeID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).MRVerItemIsChecked(AMRVerItemIDS,ASchemeID )
	q ret
}

/// Desc:根据封存版本号得到封存项目
/// Creator:liushuang
/// Createdate:2016-10-24
/// Input:AMREpisdoeID 归档就诊号,AVersion,版本
ClassMethod GetSealUpItemByVersion(AMRID As %String, AVersion As %String) As %String [ WebMethod ]
{
	s:(AMRID = $c(0)) AMRID = ""
	s:(AVersion = $c(0)) AVersion = ""
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetSealUpItemByVersion(AMRID,AVersion )
	q ret
}

ClassMethod GetVerSubItemSuffix(AEpisodeID As %String, AMRItemID As %String, ADocIDs As %String) As %String [ WebMethod ]
{
    q ##Class(DHCEPRFS.BL.BLMRVerSubItem).GetVerSubItemSuffix(AEpisodeID,AMRItemID,ADocIDs)
}

ClassMethod GetItemVerSubPath(AEpisodeID As %String, ATypeCode As %String) As %XML.DataSet [ WebMethod ]
{
    s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRVerSubItem:GetItemVerSubPath")
    d ds.SetArgs(AEpisodeID,ATypeCode)
    q ds
}

ClassMethod GetMRVerItemsInfoByID(AMRMRVerItemsIDs As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRVerItem:GetMRVerItemsInfoByID")
	d ds.SetArgs(AMRMRVerItemsIDs)
	q ds
}

ClassMethod GetSubMRVerItemByMREpisodeID(AMREpiosdeID As %String, AVersion As %String = "0", ACorrelation As %String = "N") As %String [ WebMethod ]
{
	s:(AMREpiosdeID = $c(0)) AMREpiosdeID = ""
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetSubMRVerItemByMREpisodeID(AMREpiosdeID,AVersion,ACorrelation )
	q ret
}

ClassMethod GetSubMRVerItemBySchemeID(AMREpiosdeID As %String, ASchemeID As %String, AVersion As %String = "0", ACorrelation As %String = "N") As %String [ WebMethod ]
{
	s:(AMREpiosdeID = $c(0)) AMREpiosdeID = ""
	s:(ASchemeID = $c(0)) ASchemeID = ""
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetSubMRVerItemBySchemeID(AMREpiosdeID,ASchemeID,AVersion,ACorrelation )
	q ret
}

ClassMethod GetScanCount(AMREpisodeID As %String, AVersion As %String, AType As %String, AMRItemType As %String, AUserID As %String) As %String [ WebMethod ]
{
	s ret = ##class(DHCEPRFS.BL.BLMRVerItem).GetScanCount(AMREpisodeID,AVersion,AType,AMRItemType,AUserID)
	q ret
}

}
