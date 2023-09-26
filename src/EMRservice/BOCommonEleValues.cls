Class EMRservice.BOCommonEleValues Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CommonEleValuesInfo";

ClassMethod SELECTALLDATE() As EMRservice.dataset.ECommonEleValuesADataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECommonEleValuesADataSet).%New()
 Do result.SetArgs()
 Quit result
}

ClassMethod SELECTALLBYCategoryID(aTemplateCode As %String, aSectionCode As %String) As EMRservice.dataset.ECommonEleValuesDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECommonEleValuesDataSet).%New()
 Do result.SetArgs(aTemplateCode,aSectionCode)
 Quit result
}

ClassMethod SELECTALLBYCODES(aTemplateCode As %String, aSectionCode As %String, aCode As %String) As EMRservice.dataset.ECommonEleValuesByCodeDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECommonEleValuesByCodeDataSet).%New()
 Do result.SetArgs(aTemplateCode,aSectionCode,aCode)
 Quit result
}

/// 查询公用元素
ClassMethod SelectComnonEByID(AComnonEByID As %String) As EMRservice.entity.ECommonEleValues [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleValues).SelectComnonEByID(AComnonEByID)
}

/// 增加一个公用元素
ClassMethod CreateCommonEleV(aECommonEleValues As EMRservice.entity.ECommonEleValues) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleValues).CreateCommonEleV(aECommonEleValues)
}

/// 删除一个公用元素
ClassMethod DeleteCommonEleVByID(aECommonEleVId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleValues).DeleteCommonEleVByID(aECommonEleVId)
}

/// 更新一个公用元素
ClassMethod UpdateCommonEleV(aECommonEleValues As EMRservice.entity.ECommonEleValues) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleValues).UpdateCommonEleV(aECommonEleValues)
}

/// 更新一个公用元素
ClassMethod selectMaxRowID() As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleValues).selectMaxRowID()
}

}
