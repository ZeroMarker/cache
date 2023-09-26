/// EPRservice.BOReportCategory
Class EPRservice.BOReportCategory Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "ReportCategoryInfo";

/// TODO: add arguments and implementation.
/// CreateReportCategory
ClassMethod CreateReportCategory(AEReportCategory As EPRservice.entity.EReportCategory) As %String [ WebMethod ]
{
 set objReportCategory = ##class(EPRmeta.ReportCategory).%New()
 Quit:(objReportCategory ="") "ERROR" 
 set objReportCategory.Name = AEReportCategory.Name
 set objReportCategory.ParentID = AEReportCategory.ParentID
 set objReportCategory.Description = AEReportCategory.Description
 set objReportCategory.ResChildCount = 0
	do objReportCategory.%Save()
	Quit objReportCategory.%Id()
}

ClassMethod DeleteReportCategoryByID(AID As %String) As %Boolean [ WebMethod ]
{
	set objReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(AID)
	Quit objReportCategory.%DeleteId(AID)
}

ClassMethod SelectAllReportCategory() As EPRservice.dataset.EReportCategoryDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EReportCategoryDataset).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectReportCategoryByID(AID As %String) As EPRservice.entity.EReportCategory [ WebMethod ]
{
	
 set objReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(AID)
 q:(objReportCategory="") ""
 set Result = ##class(EPRservice.entity.EReportCategory).%New()
 set Result.ID = objReportCategory.%Id()
 set Result.Name = objReportCategory.Name
 set Result.ParentID = objReportCategory.ParentID
 set Result.Description = objReportCategory.Description
 set Result.ResChildCount = objReportCategory.ResChildCount
 Quit Result
}

ClassMethod UpdateReportCategory(AEReportCategory As EPRservice.entity.EReportCategory) As %Boolean [ WebMethod ]
{
 set objReportCategory = ##class(EPRmeta.ReportCategory).%OpenId(AEReportCategory.ID)
 set objReportCategory.Name = AEReportCategory.Name
 set objReportCategory.ParentID = AEReportCategory.ParentID
 set objReportCategory.Description = AEReportCategory.Description

 Quit objReportCategory.%Save()
}

ClassMethod testCreateCategory()
{
 s AA= ##class(EPRservice.entity.EReportCategory).%New()
 set AA.Name = "ooo"
 set AA.ParentID = "1"
 set AA.Description = "CCC"
 d ##class(EPRservice.BOReportCategory).CreateReportCategory(AA)
}

}
