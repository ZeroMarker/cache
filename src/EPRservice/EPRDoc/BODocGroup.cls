Class EPRservice.EPRDoc.BODocGroup Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRDocRes.DocGroup";

ClassMethod Add(argDocGroup As EPRservice.entity.EPRDocRestriction.EDocGroup) As %String [ WebMethod ]
{
	q:($d(argDocGroup)=0)||(argDocGroup="") 0
	s objDocGroup=""
	s objDocGroup=##class(EPRmeta.EPRDocRestriction.DocGroup).%New()
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
	s objDoc=##class(EPRmeta.EPRDocRestriction.DocGroup).%OpenId(argDocID)
	q:(objDoc="") 0
	s objDoc.GroupName=argDocName
	d objDoc.%Save()
	q 1
}

ClassMethod Delete(argDocGroupID As %String) As %String [ WebMethod ]
{
	q:($d(argDocGroupID)=0)||(argDocGroupID="") 0
	s objDocGroup="",result=""
	s objDocGroup=##class(EPRmeta.EPRDocRestriction.DocGroup).%OpenId(argDocGroupID)
	q:(objDocGroup="") 0
	d objDocGroup.%Close()
	s objDocGroup=""
	s result=##class(EPRmeta.EPRDocRestriction.DocGroup).%DeleteId(argDocGroupID)
	if (result = 1)
	{
		&sql(delete from EPRmeta_EPRDocRestriction.DocRestriction where GroupID = :argDocGroupID)
		&sql(delete from EPRmeta_EPRDocRestriction.DocsInGroup where GroupID = :argDocGroupID)	
	}
	q result
}

ClassMethod GetById(argDocGroupID As %String) As EPRservice.entity.EPRDocRestriction.EDocGroup [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EPRservice.entity.EPRDocRestriction.EDocGroup).%New()
	
	s tmpResult=##class(EPRmeta.EPRDocRestriction.DocGroup).%OpenId(argDocGroupID)
	q:(tmpResult="") result
	
	s result.ID = argDocGroupID
	s result.GroupName=tmpResult.GroupName

	q result
}

ClassMethod GetAllGroup() As EPRservice.dataset.EPRDocRestriction.AllDocGroupDs [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EPRDocRestriction.AllDocGroupDs).%New()
 Quit result
}

}
