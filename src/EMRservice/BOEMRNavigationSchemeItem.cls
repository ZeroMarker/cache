/// 名称：		EMRservice.BOEMRNavigationSchemeItem
/// 描述：		方案明细BO层
/// 编写者：	yejian
/// 编写时间：	2016-5-17
Class EMRservice.BOEMRNavigationSchemeItem Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRNavSchemeItemInfo";

/// w ##Class(EMRservice.BOEMRNavigationSchemeItem).SelectAllDetails("12||1")
ClassMethod SelectAllDetails(aSchemeCode As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLEMRNavigationSchemeItem:SelectAllDetails")
	d result.SetArgs(aSchemeCode)
	q result
}

/// 增加一个项目
ClassMethod CreateSchemeDetails(aOrganSchemeDetails As EMRservice.entity.EEMRNavigationSchemeItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItem).CreateSchemeDetails(aOrganSchemeDetails)
}

/// 删除一个项目
ClassMethod DeleteSchemeDetailsByID(aSchemeDetailsId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItem).DeleteSchemeDetailsByID(aSchemeDetailsId)
}

/// 更新一个项目
ClassMethod UpdateSchemeDetails(aOrganSchemeDetails As EMRservice.entity.EEMRNavigationSchemeItem) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItem).UpdateSchemeDetails(aOrganSchemeDetails)
}

/// 更新标题顺序
ClassMethod UpdateSequences(argStr As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItem).UpdateSequences(argStr)
}

/// 得到最大code编号
ClassMethod GetMaxCode() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLEMRNavigationSchemeItem).GetMaxCode()
}

}
