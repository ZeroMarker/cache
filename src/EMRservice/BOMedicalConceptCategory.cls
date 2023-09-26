Class EMRservice.BOMedicalConceptCategory Extends %SOAP.WebService
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "MedicalConceptCategoryInfo";

ClassMethod SELECTALL() As EMRservice.dataset.EMedConceptCategoryDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMedConceptCategoryDataSet).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectByParentID(aParentID As %String) As EMRservice.dataset.EMedConceptCateByIDDataSet [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMedConceptCateByIDDataSet).%New()
 Do result.SetArgs(aParentID)
 Quit result
}

/// 增加一个医学概念目录
ClassMethod CreateCategory(aMedConceptCategory As EMRservice.entity.EMedicalConceptCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptCategory).CreateCategory(aMedConceptCategory)
}

/// 删除一个医学概念目录
ClassMethod DeleteCategoryByID(aMedConceptCategoryId As %String) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptCategory).DeleteCategoryByID(aMedConceptCategoryId)
}

/// 更新一个医学概念目录
ClassMethod UpdateCategory(aMedConceptCategory As EMRservice.entity.EMedicalConceptCategory) As %String [ WebMethod ]
{
	q ##Class(EMRservice.BL.BLMedicalConceptCategory).UpdateCategory(aMedConceptCategory)
}

}
