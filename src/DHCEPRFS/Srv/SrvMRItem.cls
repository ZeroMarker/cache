Class DHCEPRFS.Srv.SrvMRItem Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvMRItem";

ClassMethod GetMRItemByType(AType As %String, ATypeParams As %String) As DHCEPRFS.Entity.EMRItem [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLMRItem).GetItemByType(AType, ATypeParams)
	q entity
}

ClassMethod GetMRItemByID(AMRItemID As %String) As DHCEPRFS.Entity.EMRItem [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLMRItem).GetItemByID(AMRItemID)
	q entity
}

ClassMethod GetMRItemByCode(ACode As %String) As DHCEPRFS.Entity.EMRItem [ WebMethod ]
{
	s entity = ##Class(DHCEPRFS.BL.BLMRItem).GetItemByCode(ACode)
	q entity
}

/// Desc:获得归档目录
/// Creator:candyxu
/// CreateDate:2013-05-06
ClassMethod GetAllMRItems() As DHCEPRFS.DataSet.MRItemDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.MRItemDS).%New()
	d result.SetArgs()
	q result
}

ClassMethod ClassifyItem() As %String [ WebMethod ]
{

	q "1"
}

/// Desc:根据类型取Item
/// Debug:d ##Class(DHCEPRFS.Srv.SrvMRItem).GetMRItemsByType("PS","OutPatient")
ClassMethod GetMRItemsByType(Type As %String, SubType As %String = "") As DHCEPRFS.DataSet.MRItemDS [ WebMethod ]
{
	s:(SubType = $c(0)) SubType = ""
	s result = ##Class(DHCEPRFS.DataSet.MRItemDS).%New()
	d result.SetArgs(Type,SubType)
	q result
}

/// Desc:取默认类型的Item
/// Debug:d ##Class(DHCEPRFS.Srv.SrvMRItem).GetItemByDefaultType("ARRANGE")
ClassMethod GetItemByDefaultType(SchemeType As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRItem:GetItemByDefaultType")
	d ds.SetArgs(SchemeType)
	q ds
}

/// Desc:取继承方案的Item
/// Debug:d ##Class(DHCEPRFS.Srv.SrvMRItem).GetItemByScheme("159")
ClassMethod GetItemByScheme(AuserID As %String, ALocID As %String = "") As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRItem:GetItemByScheme")
	d ds.SetArgs(AuserID,ALocID)
	q ds
}

ClassMethod GetItemDescriptionByCode(ACode As %String) As %String [ WebMethod ]
{
	s ret = ""
	s ret = ##class(DHCEPRFS.BL.BLMRItem).GetItemDescriptionByCode(ACode)
	q ret
}

ClassMethod GetMedRecordScanList() As DHCEPRFS.DataSet.EMedRecordScanListDS [ WebMethod ]
{
	s result = ##Class(DHCEPRFS.DataSet.EMedRecordScanListDS).%New()
	d result.SetArgs()
	q result
}

/// Desc:取继承方案的ItemS
ClassMethod GetSchemeItems(AuserID As %String, ASchemeName As %String) As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRItem:GetSchemeItems")
	d ds.SetArgs(AuserID,ASchemeName)
	q ds
}

/// Debug:d ##Class(DHCEPRFS.Srv.SrvMRItem).GetOCRArrangeInfo()
ClassMethod GetOCRArrangeInfo() As %XML.DataSet [ WebMethod ]
{
	s ds = ##class(%XML.DataSet).%New("DHCEPRFS.BL.BLMRItem:GetOCRArrangeInfo")
	d ds.SetArgs()
	q ds
}

ClassMethod GetPaperSizeByMRItemID(AMRItemID As %String) As %String [ WebMethod ]
{
	s ret = ""
	s ret = ##class(DHCEPRFS.BL.BLMRItem).GetPaperSizeByMRItemID(AMRItemID)
	q ret
}

ClassMethod GetItemInfoByID(AMRIemID) As %String [ WebMethod ]
{
	s ret = ""
	s ret = ##class(DHCEPRFS.BL.BLMRItem).GetItemInfoByID(AMRIemID)
	q ret
}

ClassMethod GetHDCScanItemsShortcut(ASchemeID As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLMRItem).GetHDCScanItemsShortcut(ASchemeID)
}

}
