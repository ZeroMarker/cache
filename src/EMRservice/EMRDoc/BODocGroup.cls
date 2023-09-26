Class EMRservice.EMRDoc.BODocGroup Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRDocRes.DocGroup";

ClassMethod Add(argDocGroup As EMRservice.entity.EMRDocRestriction.EDocGroup) As %String [ WebMethod ]
{
	q:($d(argDocGroup)=0)||(argDocGroup="") 0
	s objDocGroup=""
	s objDocGroup=##class(EMRmeta.EMRDocRestriction.DocGroup).%New()
	q:(objDocGroup="") 0
	
	s objDocGroup.GroupName=argDocGroup.GroupName
	
	s result=""
	s result=objDocGroup.%Save()
	q objDocGroup.%Id()
}

ClassMethod EditName(argDocID As %String, argDocName As %String) As %String [ WebMethod ]
{
	q:($d(argDocID)=0)||(argDocID="") 0
	s objDoc=""
	s objDoc=##class(EMRmeta.EMRDocRestriction.DocGroup).%OpenId(argDocID)
	q:(objDoc="") 0
	s objDoc.GroupName=argDocName
	d objDoc.%Save()
	q 1
}

ClassMethod Delete(argDocGroupID As %String) As %String [ WebMethod ]
{
	q:($d(argDocGroupID)=0)||(argDocGroupID="") 0
	s objDocGroup="",result=""
	s objDocGroup=##class(EMRmeta.EMRDocRestriction.DocGroup).%OpenId(argDocGroupID)
	q:(objDocGroup="") 0
	d objDocGroup.%Close()
	s objDocGroup=""
	s result=##class(EMRmeta.EMRDocRestriction.DocGroup).%DeleteId(argDocGroupID)
	if (result = 1)
	{
		&sql(delete from EMRmeta_EMRDocRestriction.DocRestriction where GroupID = :argDocGroupID)
		&sql(delete from EMRmeta_EMRDocRestriction.DocsInGroup where GroupID = :argDocGroupID)	
	}
	q result
}

ClassMethod GetById(argDocGroupID As %String) As EMRservice.entity.EMRDocRestriction.EDocGroup [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EMRservice.entity.EMRDocRestriction.EDocGroup).%New()
	
	s tmpResult=##class(EMRmeta.EMRDocRestriction.DocGroup).%OpenId(argDocGroupID)
	q:(tmpResult="") result
	
	s result.ID = argDocGroupID
	s result.GroupName=tmpResult.GroupName

	q result
}

ClassMethod GetAllGroup() As EMRservice.dataset.EMRDocRestriction.AllDocGroupDs [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.EMRDocRestriction.AllDocGroupDs).%New()
 Quit result
}

}
