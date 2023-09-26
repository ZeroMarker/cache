Class EMRservice.BOCommonEleCategory Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "CommonEleCategoryInfo";

ClassMethod SELECTALL() As EMRservice.dataset.ECommonEleCategoryDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECommonEleCategoryDataSet).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SELECTALLByTemCode(aTemCode As %String) As EMRservice.dataset.ECommonEleCateByCodeDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECommonEleCateByCodeDataSet).%New()
 Do result.SetArgs(aTemCode)
 Quit result
}

ClassMethod SelectByParentID(aParentID As %String) As EMRservice.dataset.ECommonEleCateByIDDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ECommonEleCateByIDDataSet).%New()
 Do result.SetArgs(aParentID)
 Quit result
}

/// 增加一个公用元素目录
ClassMethod CreateCategory(aCommonEleCategory As EMRservice.entity.ECommonEleCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleCategory).CreateCategory(aCommonEleCategory)
}

/// 删除一个公用元素目录
ClassMethod DeleteCategoryByID(aCommonEleCategoryId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleCategory).DeleteCategoryByID(aCommonEleCategoryId)
}

/// 更新一个公用元素目录
ClassMethod UpdateCategory(aCommonEleCategory As EMRservice.entity.ECommonEleCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleCategory).UpdateCategory(aCommonEleCategory)
}

/// 更新一个公用元素目录
ClassMethod SelectCategoryByID(aComID As %String) As EMRservice.entity.ECommonEleCategory [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLCommonEleCategory).SelectCategoryByID(aComID)
}

}
