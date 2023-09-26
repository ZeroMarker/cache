Class EMRservice.BOTemplateCategory Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplateCategoryInfo";

ClassMethod CreateTemplateCategory(AETemplateCategory As EMRservice.entity.ETemplateCategory) As %String [ WebMethod ]
{
	
	set objTemplateCategory = ##class(EMRmeta.TemplateCategory).%New()
 Quit:(objTemplateCategory ="") "ERROR" 
 set objTemplateCategory.Name = AETemplateCategory.Name
 set objTemplateCategory.ParentID = AETemplateCategory.ParentID
 set objTemplateCategory.Description = AETemplateCategory.Description

 set objTemplateCategory.PropertyName = AETemplateCategory.PropertyName
 set objTemplateCategory.PropertyCode = AETemplateCategory.PropertyCode


 set objTemplateCategory.ResChildCount = 0
	do objTemplateCategory.%Save()
	Quit objTemplateCategory.%Id()
}

ClassMethod DeleteTemplateCategory(ATemplateCategoryId As %String) As %Boolean [ WebMethod ]
{
 set objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(ATemplateCategoryId)
	Quit objTemplateCategory.%DeleteId(ATemplateCategoryId)
}

ClassMethod SelectAllTemplateCategory() As EMRservice.dataset.ETemplateCategoryDataset [ WebMethod ]
{
 New result	
 Set result=##class(EMRservice.dataset.ETemplateCategoryDataset).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectTemplateCategoryByID(AID As %String) As EMRservice.entity.ETemplateCategory [ WebMethod ]
{
	
 set objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(AID)
	q:(objTemplateCategory="") ""
 set Result = ##class(EMRservice.entity.ETemplateCategory).%New()
 set Result.ID = objTemplateCategory.%Id()
 set Result.Name = objTemplateCategory.Name
 set Result.ParentID = objTemplateCategory.ParentID
 set Result.Description = objTemplateCategory.Description
 set Result.ResChildCount = objTemplateCategory.ResChildCount

 set Result.PropertyName = objTemplateCategory.PropertyName
 set Result.PropertyCode = objTemplateCategory.PropertyCode




 Quit Result
}

ClassMethod UpdateTemplateCategory(AETemplateCategory As EMRservice.entity.ETemplateCategory) As %Boolean [ WebMethod ]
{
 set objTemplateCategory = ##class(EMRmeta.TemplateCategory).%OpenId(AETemplateCategory.ID)
 set objTemplateCategory.Name = AETemplateCategory.Name
 set objTemplateCategory.ParentID = AETemplateCategory.ParentID
 set objTemplateCategory.Description = AETemplateCategory.Description


 set objTemplateCategory.PropertyName = AETemplateCategory.PropertyName
 set objTemplateCategory.PropertyCode = AETemplateCategory.PropertyCode

 //set objPrintTemplateCategory.ResChildCount = AEPrintTemplateCategory.ResChildCount
 Quit objTemplateCategory.%Save()
}

}
