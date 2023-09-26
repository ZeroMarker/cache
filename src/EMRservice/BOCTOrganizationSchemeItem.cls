/// 名称：		EMRservice.BOCTOrganizationSchemeItem
/// 描述：		方案项目BO层
/// 编写者：	yejian
/// 编写时间：	2014-8-28
Class EMRservice.BOCTOrganizationSchemeItem Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CTOrganSchemeItemInfo";

ClassMethod SelectALL() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLCTOrganizationSchemeItem:SelectALL")
	d result.SetArgs()
	q result
}

ClassMethod SelectALLType() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLCTOrganizationSchemeItem:SelectALLType")
	d result.SetArgs()
	q result
}

/// 增加一个项目
ClassMethod CreateItem(aECTOrganItem As EMRservice.entity.ECTOrganizationSchemeItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).CreateItem(aECTOrganItem)
}

/// 删除一个项目
ClassMethod DeleteItemByID(aECTOrganItemId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).DeleteItemByID(aECTOrganItemId)
}

/// 更新一个项目
ClassMethod UpdateItem(aECTOrganItem As EMRservice.entity.ECTOrganizationSchemeItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).UpdateItem(aECTOrganItem)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCTOrganizationSchemeItem).GetMaxCode()
}

}
