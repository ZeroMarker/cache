Class EPRservice.EPRDoc.BODocRest Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EPRDocRes.DocRest";

ClassMethod Add(argDocRest As EPRservice.entity.EPRDocRestriction.EDocRest) As %String [ WebMethod ]
{
	q:($d(argDocRest)=0)||(argDocRest="") 0
	s objDocRest=""
	s objDocRest=##class(EPRmeta.EPRDocRestriction.DocRestriction).%New()
	q:(objDocRest="") 0
	
	s objDocRest.GroupID=argDocRest.GroupID
	s objDocRest.RuleItemIDs=argDocRest.RuleItemIDs
	s objDocRest.RuleItemDesc=argDocRest.RuleItemDesc
	
	s result=""
	s result=objDocRest.%Save()
	q objDocRest.%Id()
}

ClassMethod Modify(argDocRest As EPRservice.entity.EPRDocRestriction.EDocRest) As %String [ WebMethod ]
{
	q:($d(argDocRest)=0)||(argDocRest="") 0
	s objDocRest=""
	s objDocRest=##class(EPRmeta.EPRDocRestriction.DocRestriction).%OpenId(argDocRest.ID)
	q:(objDocRest="") 0
	
	s objDocRest.GroupID=argDocRest.GroupID
	s objDocRest.RuleItemIDs=argDocRest.RuleItemIDs
	s objDocRest.RuleItemDesc=argDocRest.RuleItemDesc

	s result=""
	s result=objDocRest.%Save()
	q result
}

ClassMethod Delete(argDocRestID As %String) As %String [ WebMethod ]
{
	q:($d(argDocRestID)=0)||(argDocRestID="") 0
	s objDocRest="",result=""
	s objDocRest=##class(EPRmeta.EPRDocRestriction.DocRestriction).%OpenId(argDocRestID)
	q:(objDocRest="") 0
	d objDocRest.%Close()
	s objDocRest=""
	s result=##class(EPRmeta.EPRDocRestriction.DocRestriction).%DeleteId(argDocRestID)
	q result
}

ClassMethod GetById(argDocRestID As %String) As EPRservice.entity.EPRDocRestriction.EDocRest [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EPRservice.entity.EPRDocRestriction.EDocRest).%New()
	
	s tmpResult=##class(EPRmeta.EPRDocRestriction.DocRestriction).%OpenId(argDocRestID)
	q:(tmpResult="") result
	
	s result.ID = argDocRestID
	s result.GroupID=tmpResult.GroupID
	s result.RuleItemIDs=tmpResult.RuleItemIDs

	q result
}

ClassMethod GetAllRest(argGroupID As %String) As EPRservice.dataset.EPRDocRestriction.AllDocRestDS [ WebMethod ]
{
	Set result=##class(EPRservice.dataset.EPRDocRestriction.AllDocRestDS).%New()
	d result.SetArgs(argGroupID)
	Quit result
}

}
