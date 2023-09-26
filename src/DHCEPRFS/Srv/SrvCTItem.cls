Class DHCEPRFS.Srv.SrvCTItem Extends %SOAP.WebService [ ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvCTItem";

ClassMethod GetCTItemByCode(ATypeCode As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLCTItem).GetCTItemByCode(ATypeCode)
}

ClassMethod GetCreateTypeSubByCode(ATypeCode As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLCTItem).GetCreateTypeSubByCode(ATypeCode)
}

ClassMethod GetAllCTItem() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCTItem:GetAllCTItem")
	d obj.SetArgs()
	q obj
}

ClassMethod GetCTItemBySchemeID(ASchemeID As %String) As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCTItem:GetCTItemBySchemeID")
	d obj.SetArgs(ASchemeID)
	q obj
}

ClassMethod GetAllCTItemInvokeType() As %XML.DataSet [ WebMethod ]
{
	s obj = ##Class(%XML.DataSet).%New("DHCEPRFS.BL.BLCTItem:GetAllCTItemInvokeType")
	d obj.SetArgs()
	q obj
}

/// Desc: 增加CTItem
/// Creator: yangpeng
/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).AddCTItem()
ClassMethod AddCTItemType(entityCTItem As DHCEPRFS.Entity.ECTItemType) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLCTItem).AddCTItemType(entityCTItem)
}

/// Desc: 增加CTItem
/// Creator: yangpeng
/// debug: w ##Class(DHCEPRFS.BL.BLCTItem).UpdateCTItemType()
ClassMethod UpdateCTItemType(entityCTItem As DHCEPRFS.Entity.ECTItemType) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLCTItem).UpdateCTItemType(entityCTItem)
}

/// debug: w ##class(DHCEPRFS.BL.BLCTItem).GetCSPPathByCode(ATypeCode)
ClassMethod GetCSPPathByCode(ATypeCode As %String) As %String [ WebMethod ]
{
	q ##class(DHCEPRFS.BL.BLCTItem).GetCSPPathByCode(ATypeCode)
}

}
