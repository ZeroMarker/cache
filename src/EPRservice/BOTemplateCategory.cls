Class EPRservice.BOTemplateCategory Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateCategoryInfo";

ClassMethod CreateTemplateCategory(AETemplateCategory As EPRservice.entity.ETemplateCategory) As %String [ WebMethod ]
{
	
	set objTemplateCategory = ##class(EPRmeta.TemplateCategory).%New()
 Quit:(objTemplateCategory ="") "ERROR" 
 set objTemplateCategory.Name = AETemplateCategory.Name
 set objTemplateCategory.ParentID = AETemplateCategory.ParentID
 set objTemplateCategory.Description = AETemplateCategory.Description

 set objTemplateCategory.CategoryType = AETemplateCategory.CategoryType
 set objTemplateCategory.CategoryProperty = AETemplateCategory.CategoryProperty


 set objTemplateCategory.ResChildCount = 0
	do objTemplateCategory.%Save()
	Quit objTemplateCategory.%Id()
}

ClassMethod DeleteTemplateCategory(ATemplateCategoryId As %String) As %Boolean [ WebMethod ]
{
 set objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(ATemplateCategoryId)
	Quit objTemplateCategory.%DeleteId(ATemplateCategoryId)
}

ClassMethod SelectAllTemplateCategory() As EPRservice.dataset.ETemplateCategoryDataset [ WebMethod ]
{
 New result	
 Set result=##class(EPRservice.dataset.ETemplateCategoryDataset).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectTemplateCategoryByID(AID As %String) As EPRservice.entity.ETemplateCategory [ WebMethod ]
{
	
 set objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(AID)
	q:(objTemplateCategory="") ""
 set Result = ##class(EPRservice.entity.ETemplateCategory).%New()
 set Result.ID = objTemplateCategory.%Id()
 set Result.Name = objTemplateCategory.Name
 set Result.ParentID = objTemplateCategory.ParentID
 set Result.Description = objTemplateCategory.Description
 set Result.ResChildCount = objTemplateCategory.ResChildCount

 set Result.CategoryType = objTemplateCategory.CategoryType
 set Result.CategoryProperty = objTemplateCategory.CategoryProperty




 Quit Result
}

ClassMethod UpdateTemplateCategory(AETemplateCategory As EPRservice.entity.ETemplateCategory) As %Boolean [ WebMethod ]
{
 set objTemplateCategory = ##class(EPRmeta.TemplateCategory).%OpenId(AETemplateCategory.ID)
 set objTemplateCategory.Name = AETemplateCategory.Name
 set objTemplateCategory.ParentID = AETemplateCategory.ParentID
 set objTemplateCategory.Description = AETemplateCategory.Description


 set objTemplateCategory.CategoryType = AETemplateCategory.CategoryType
 set objTemplateCategory.CategoryProperty = AETemplateCategory.CategoryProperty

 //set objPrintTemplateCategory.ResChildCount = AEPrintTemplateCategory.ResChildCount
 Quit objTemplateCategory.%Save()
}

/// Desc:按目录属性获得目录
/// Creator:Candyxu
/// Create Date:2012-07-30
/// Input: Property 目录属性
/// Output: 目录列表
ClassMethod GetPTCategoryByProperty(Property As %String) As EPRservice.dataset.EPTCategoryByPropertyDataset [ WebMethod ]
{
	if Property = $c(0) s Property = ""
	s result = ##Class(EPRservice.dataset.EPTCategoryByPropertyDataset).%New()
	d result.SetArgs(Property)
	q result
}

}
