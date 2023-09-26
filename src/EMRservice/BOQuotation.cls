/// 名称：		EMRservice.BOQuotation
/// 描述：		病历引用科室配置
/// 编写者：	yejian
/// 编写时间：	2014-8-30
Class EMRservice.BOQuotation Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "QuotationInfo";

/// d ##Class(EMRservice.BOEMROrganizationScheme).SelectALL()
ClassMethod SelectMulTempIDS() As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLQuotation:SelectMulTempIDS")
	d result.SetArgs()
	q result
}

/// d ##Class(EMRservice.BOEMROrganizationScheme).SelectDataByLocID()
ClassMethod SelectDataByLocID(aCTLocID As %String) As %XML.DataSet [ WebMethod ]
{
	s result=##Class(%XML.DataSet).%New("EMRservice.BL.BLQuotation:SelectDataByLocID")
	d result.SetArgs(aCTLocID)
	q result
}

/// 增加一个项目
ClassMethod CreateQuotation(aQuotation As EMRservice.entity.EQuotationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLQuotation).CreateQuotation(aQuotation)
}

/// 删除一个项目
ClassMethod DeleteQuotationByID(aQuotationId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLQuotation).DeleteQuotationByID(aQuotationId)
}

/// 更新一个项目
ClassMethod UpdateQuotation(aQuotation As EMRservice.entity.EQuotationScheme) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLQuotation).UpdateQuotation(aQuotation)
}

}
