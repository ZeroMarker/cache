Class EPRservice.BOKBCategory Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBCategoryInfo";

ClassMethod CreateKBCategory(AEKBCategory As EPRservice.entity.EKBCategory) As %String [ WebMethod ]
{
	TSTART 
	set objKBCategory = ##class(EPRmeta.KBCategory).%New()
 Quit:(objKBCategory ="") "0" 
 set objKBCategory.Name = AEKBCategory.Name
 set objKBCategory.ParentID = AEKBCategory.ParentID
 set objKBCategory.Description = AEKBCategory.Description
 set objKBCategory.ResChildCount = 0
	if '(objKBCategory.%Save())
	{
	  TROLLBACK
 Quit "0"
	} 
	TCOMMIT
	Quit objKBCategory.%Id()
}

ClassMethod DeleteKBCategory(AID As %String) As %Boolean [ WebMethod ]
{
	TSTART 
	set objKBCategory = ##class(EPRmeta.KBCategory).%OpenId(AID)
	if '(objKBCategory.%DeleteId(AID))
	{
	  TROLLBACK
 Quit 0
	} 
	TCOMMIT
 Quit 1
}

ClassMethod SelectAllKBCategory() As EPRservice.dataset.EKBCategoryDataset [ WebMethod ]
{
 New result	
 Set result=##class(EPRservice.dataset.EKBCategoryDataset).%New()
 ;Do result.SetArgs("")
 Quit result
}

ClassMethod SelectKBCategoryByID(AID As %String) As EPRservice.entity.EKBCategory [ WebMethod ]
{
	
	set objKBCategory = ##class(EPRmeta.KBCategory).%OpenId(AID)
	q:(objKBCategory="") ""
 set Result = ##class(EPRservice.entity.EKBCategory).%New()
 set Result.ID = objKBCategory.%Id()
 set Result.Name = objKBCategory.Name
 set Result.ParentID = objKBCategory.ParentID
 set Result.Description = objKBCategory.Description
 set Result.ResChildCount = objKBCategory.ResChildCount 
 Quit Result
}

ClassMethod UpdateKBCategory(AEKBCategory As EPRservice.entity.EKBCategory) As %Boolean [ WebMethod ]
{
	TSTART
	set objKBCategory = ##class(EPRmeta.KBCategory).%OpenId(AEKBCategory.ID)
 Quit:(objKBCategory="") 0
 set objKBCategory.Name = AEKBCategory.Name
 
 set objKBCategory.ParentID=  AEKBCategory.ParentID
 set objKBCategory.Description = AEKBCategory.Description
 //set objKBCategory.ResChildCount = AEKBCategory.ResChildCount 
 if '(objKBCategory.%Save()) {
	TROLLBACK  
	Quit 0
 } 
 TCOMMIT
 Quit 1
}

}
