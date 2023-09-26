Class EMRservice.BOKBCategory Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBCategory";

ClassMethod SelectAllKBCategory() As EMRservice.dataset.EKBCategoryDataset [ WebMethod ]
{
	
	q ##class(EMRservice.dataset.EKBCategoryDataset).%New()
}

ClassMethod CreateKBCategory(AEKBCategory As EMRservice.entity.EKBCategory) As %String [ WebMethod ]
{
	set objKBCategory = ##class(EMRmeta.KBCategory).%New()
 	Quit:(objKBCategory ="") "0" 
 	set objKBCategory.Name = AEKBCategory.Name
 	set objKBCategory.ParentID = AEKBCategory.ParentID
 	set objKBCategory.Description = AEKBCategory.Description
 	set objKBCategory.ResChildCount = 0
	if '(objKBCategory.%Save())
	{
		Quit "0"
	} 
	Quit objKBCategory.%Id()
}

ClassMethod DeleteKBCategory(AID As %String) As %Boolean [ WebMethod ]
{
	set objKBCategory = ##class(EMRmeta.KBCategory).%OpenId(AID)
	if '(objKBCategory.%DeleteId(AID))
	{
 		Quit 0
	} 
	Quit 1
}

ClassMethod SelectKBCategoryByID(AID As %String) As EMRservice.entity.EKBCategory [ WebMethod ]
{
	set objKBCategory = ##class(EMRmeta.KBCategory).%OpenId(AID)
	q:(objKBCategory="") ""
 	set Result = ##class(EMRservice.entity.EKBCategory).%New()
 	set Result.ID = objKBCategory.%Id()
 	set Result.Name = objKBCategory.Name
 	set Result.ParentID = objKBCategory.ParentID
 	set Result.Description = objKBCategory.Description
 	set Result.ResChildCount = objKBCategory.ResChildCount 
 	Quit Result
}

ClassMethod UpdateKBCategory(AEKBCategory As EMRservice.entity.EKBCategory) As %Boolean [ WebMethod ]
{
	set objKBCategory = ##class(EMRmeta.KBCategory).%OpenId(AEKBCategory.ID)
 	Quit:(objKBCategory="") 0
 	set objKBCategory.Name = AEKBCategory.Name
 
 	set objKBCategory.ParentID=  AEKBCategory.ParentID
 	set objKBCategory.Description = AEKBCategory.Description
	//set objKBCategory.ResChildCount = AEKBCategory.ResChildCount 
 	if '(objKBCategory.%Save()) 
 	{
		Quit 0
	} 
	Quit 1
}

}
