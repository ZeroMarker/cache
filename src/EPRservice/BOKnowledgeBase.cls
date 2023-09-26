Class EPRservice.BOKnowledgeBase Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KnowledgeBaseInfo";

ClassMethod CreateKnowledgeBase(AEKnowledgeBase As EPRservice.entity.EKnowledgeBase) As %String [ WebMethod ]
{
	set objKnowledgeBase = ##class(EPRmeta.KnowledgeBase).%New()
 Quit:(objKnowledgeBase ="") "" 
 set objKnowledgeBase.Name = AEKnowledgeBase.Name
 set objKnowledgeBase.KBCategoryID = AEKnowledgeBase.KBCategoryID
 set objKnowledgeBase.Description = AEKnowledgeBase.Description
 set objKnowledgeBase.S1Name = AEKnowledgeBase.S1Name
 set objKnowledgeBase.S2Name = AEKnowledgeBase.S2Name
 set objKnowledgeBase.S3Name = AEKnowledgeBase.S3Name
 set objKnowledgeBase.SegmentNumber = AEKnowledgeBase.SegmentNumber 


 Do objKnowledgeBase.%Save()

 Set objKBCategory = ##class(EPRmeta.KBCategory).%OpenId(AEKnowledgeBase.KBCategoryID)
 Quit:(objKBCategory ="") "" 
 set objKBCategory.ResChildCount = objKBCategory.ResChildCount + 1
 Do objKBCategory.%Save()

	Quit objKnowledgeBase.%Id()
}

ClassMethod DeleteKnowledgeBase(AID As %String) As %Boolean [ WebMethod ]
{
	set objKnowledgeBase = ##class(EPRmeta.KnowledgeBase).%OpenId(AID)
 Quit:(objKnowledgeBase ="")
 Set objKBCategory = ##class(EPRmeta.KBCategory).%OpenId(objKnowledgeBase.KBCategoryID)
 Quit:(objKBCategory ="") "ERROR" 
 set objKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
 Do objKBCategory.%Save()
	Quit objKnowledgeBase.%DeleteId(AID)
}

ClassMethod SelectKnowledgeBaseBYPARENTID(ACATEID As %String) As EPRservice.dataset.EKnowledgeBaseDataset [ WebMethod ]
{
 New result	
 Set result=##class(EPRservice.dataset.EKnowledgeBaseDataset).%New()
 Do result.SetArgs(ACATEID)
 Quit result
}

ClassMethod SelectKnowledgeBaseByID(AID As %String) As EPRservice.entity.EKnowledgeBase [ WebMethod ]
{
	set objKnowledgeBase = ##class(EPRmeta.KnowledgeBase).%OpenId(AID)
	q:(objKnowledgeBase="") ""
 set Result = ##class(EPRservice.entity.EKnowledgeBase).%New()
 set Result.ID = objKnowledgeBase.%Id()
 set Result.Name = objKnowledgeBase.Name
 set Result.KBCategoryID = objKnowledgeBase.KBCategoryID
 set Result.Description = objKnowledgeBase.Description
 set Result.S1Name = objKnowledgeBase.S1Name
 set Result.S2Name = objKnowledgeBase.S2Name
 set Result.S3Name = objKnowledgeBase.S3Name
 set Result.SegmentNumber = objKnowledgeBase.SegmentNumber
 Quit Result
}

ClassMethod UpdateKnowledgeBase(AEKnowledgeBase As EPRservice.entity.EKnowledgeBase) As %Boolean [ WebMethod ]
{
	New TempKBCategoryID
	set objKnowledgeBase = ##class(EPRmeta.KnowledgeBase).%OpenId(AEKnowledgeBase.ID)
 set objKnowledgeBase.Name = AEKnowledgeBase.Name
 set objKnowledgeBase.Description = AEKnowledgeBase.Description
 Set TempKBCategoryID = objKnowledgeBase.KBCategoryID 
 set objKnowledgeBase.KBCategoryID = AEKnowledgeBase.KBCategoryID
 set objKnowledgeBase.S1Name = AEKnowledgeBase.S1Name
 set objKnowledgeBase.S2Name = AEKnowledgeBase.S2Name
 set objKnowledgeBase.S3Name = AEKnowledgeBase.S3Name
 set objKnowledgeBase.SegmentNumber = AEKnowledgeBase.SegmentNumber

 if TempKBCategoryID '= AEKnowledgeBase.KBCategoryID
 {
	 	if (TempKBCategoryID '="")
	 	{ Set objOldKBCategory = ##class(EPRmeta.KBCategory).%OpenId(objKnowledgeBase.KBCategoryID)
 Quit:(objOldKBCategory ="") "ERROR" 
 set objOldKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
 Do objOldKBCategory.%Save()
 }
 if (AEKnowledgeBase.KBCategoryID'="")
	 	{
		 	Set objOldKBCategory = ##class(EPRmeta.KBCategory).%OpenId(objKnowledgeBase.KBCategoryID)
 Quit:(objOldKBCategory ="") "ERROR" 
 set objOldKBCategory.ResChildCount = objKBCategory.ResChildCount - 1
 Do objOldKBCategory.%Save()
 }   
 }

 Quit objKnowledgeBase.%Save()
}

}
