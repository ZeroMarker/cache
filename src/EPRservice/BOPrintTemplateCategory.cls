Class EPRservice.BOPrintTemplateCategory Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "PrintTemplateCategoryInfo";

ClassMethod CreatePrintTemplateCategory(AEPrintTemplateCategory As EPRservice.entity.EPrintTemplateCategory) As %String [ WebMethod ]
{
	set objPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%New()
 Quit:(objPrintTemplateCategory ="") "ERROR" 
 set objPrintTemplateCategory.Name = AEPrintTemplateCategory.Name
 set objPrintTemplateCategory.ParentID = AEPrintTemplateCategory.ParentID
 set objPrintTemplateCategory.Description = AEPrintTemplateCategory.Description
 set objPrintTemplateCategory.ResChildCount = 0
	do objPrintTemplateCategory.%Save()
	Quit objPrintTemplateCategory.%Id()
}

ClassMethod DeletePrintTemplateCategoryByID(AID As %String) As %Boolean [ WebMethod ]
{
	set objPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(AID)
	Quit objPrintTemplateCategory.%DeleteId(AID)
}

ClassMethod SelectAllPrintTemplateCategory() As EPRservice.dataset.EPrintTemplateCategoryDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPrintTemplateCategoryDataset).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectPrintTemplateCategoryByID(AID As %String) As EPRservice.entity.EPrintTemplateCategory [ WebMethod ]
{
	
 set objPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(AID)
	q:(objPrintTemplateCategory="") ""
 set Result = ##class(EPRservice.entity.EPrintTemplateCategory).%New()
 set Result.ID = objPrintTemplateCategory.%Id()
 set Result.Name = objPrintTemplateCategory.Name
 set Result.ParentID = objPrintTemplateCategory.ParentID
 set Result.Description = objPrintTemplateCategory.Description
 set Result.ResChildCount = objPrintTemplateCategory.ResChildCount
 Quit Result
}

ClassMethod UpdatePrintTemplateCategory(AEPrintTemplateCategory As EPRservice.entity.EPrintTemplateCategory) As %Boolean [ WebMethod ]
{
	set objPrintTemplateCategory = ##class(EPRmeta.PrintTemplateCategory).%OpenId(AEPrintTemplateCategory.ID)
 set objPrintTemplateCategory.Name = AEPrintTemplateCategory.Name
 set objPrintTemplateCategory.ParentID = AEPrintTemplateCategory.ParentID
 set objPrintTemplateCategory.Description = AEPrintTemplateCategory.Description
 //set objPrintTemplateCategory.ResChildCount = AEPrintTemplateCategory.ResChildCount
 Quit objPrintTemplateCategory.%Save()
}

}
