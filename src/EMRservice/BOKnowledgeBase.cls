Class EMRservice.BOKnowledgeBase Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KnowledgeBase";

ClassMethod CreateKnowledgeBase(AEKnowledgeBase As EMRservice.entity.EKnowledgeBase) As %String [ WebMethod ]
{
	set objKnowledgeBase = ##class(EMRmeta.KnowledgeBase).%New()
 	Quit:(objKnowledgeBase ="") "" 
 	set objKnowledgeBase.Name = AEKnowledgeBase.Name
 	set objKnowledgeBase.KBCategoryID = AEKnowledgeBase.KBCategoryID
 	set objKnowledgeBase.Description = AEKnowledgeBase.Description
 	set objKnowledgeBase.NodeType = AEKnowledgeBase.NodeType
	Do objKnowledgeBase.%Save()

 	Set objKBCategory = ##class(EMRmeta.KBCategory).%OpenId(AEKnowledgeBase.KBCategoryID)
 	Quit:(objKBCategory ="") "" 
 	set objKBCategory.ResChildCount = objKBCategory.ResChildCount + 1
 	Do objKBCategory.%Save()

	Quit objKnowledgeBase.%Id()
}

ClassMethod DeleteKnowledgeBase(AID As %String) As %Boolean [ WebMethod ]
{
	set objKnowledgeBase = ##class(EMRmeta.KnowledgeBase).%OpenId(AID)
 	Quit:(objKnowledgeBase ="") 0
 	Set objKBCategory = ##class(EMRmeta.KBCategory).%OpenId(objKnowledgeBase.KBCategoryID)
 	Quit:(objKBCategory ="") 0 
 	set objKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
 	Do objKBCategory.%Save()
	Quit objKnowledgeBase.%DeleteId(AID)
}

ClassMethod SelectKnowledgeBaseBYPARENTID(ACATEID As %String) As EMRservice.dataset.EKnowledgeBaseDataset [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EKnowledgeBaseDataset).%New()
 	Do result.SetArgs(ACATEID)
 	Quit result
}

ClassMethod SelectKnowledgeBaseByID(AID As %String) As EMRservice.entity.EKnowledgeBase [ WebMethod ]
{
	set objKnowledgeBase = ##class(EMRmeta.KnowledgeBase).%OpenId(AID)
	q:(objKnowledgeBase="") ""
 	set Result = ##class(EMRservice.entity.EKnowledgeBase).%New()
 	set Result.ID = objKnowledgeBase.%Id()
 	set Result.Name = objKnowledgeBase.Name
 	set Result.KBCategoryID = objKnowledgeBase.KBCategoryID
 	set Result.Description = objKnowledgeBase.Description
 	set Result.NodeType = objKnowledgeBase.NodeType
 	Quit Result
}

ClassMethod UpdateKnowledgeBase(AEKnowledgeBase As EMRservice.entity.EKnowledgeBase) As %Boolean [ WebMethod ]
{
	set objKnowledgeBase = ##class(EMRmeta.KnowledgeBase).%OpenId(AEKnowledgeBase.ID)
 	set objKnowledgeBase.Name = AEKnowledgeBase.Name
 	set objKnowledgeBase.Description = AEKnowledgeBase.Description
 	Set TempKBCategoryID = objKnowledgeBase.KBCategoryID 
 	set objKnowledgeBase.KBCategoryID = AEKnowledgeBase.KBCategoryID
	set objKnowledgeBase.NodeType = AEKnowledgeBase.NodeType
 	if TempKBCategoryID '= AEKnowledgeBase.KBCategoryID
 	{
		if (TempKBCategoryID '="")
	 	{ 
	 		Set objOldKBCategory = ##class(EMRmeta.KBCategory).%OpenId(objKnowledgeBase.KBCategoryID)
 			Quit:(objOldKBCategory ="") 0 
 			set objOldKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
 			Do objOldKBCategory.%Save()
 		}
 		if (AEKnowledgeBase.KBCategoryID'="")
		{
			Set objOldKBCategory = ##class(EMRmeta.KBCategory).%OpenId(objKnowledgeBase.KBCategoryID)
 			Quit:(objOldKBCategory ="") 0 
 			set objOldKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
 			Do objOldKBCategory.%Save()
 		}   
 	}

 	Quit objKnowledgeBase.%Save()
}

}
