Class EMRservice.EMRDoc.BODocRest Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "EMRDocRes.DocRest";

ClassMethod Add(argDocRest As EMRservice.entity.EMRDocRestriction.EDocRest) As %String [ WebMethod ]
{
	q:($d(argDocRest)=0)||(argDocRest="") 0
	s objDocRest=""
	s objDocRest=##class(EMRmeta.EMRDocRestriction.DocRestriction).%New()
	q:(objDocRest="") 0
	
	s objDocRest.GroupID=argDocRest.GroupID
	s objDocRest.RuleItemIDs=argDocRest.RuleItemIDs
	s objDocRest.RuleItemDesc=argDocRest.RuleItemDesc
	
	s result=""
	s result=objDocRest.%Save()
	q objDocRest.%Id()
}

ClassMethod Modify(argDocRest As EMRservice.entity.EMRDocRestriction.EDocRest) As %String [ WebMethod ]
{
	q:($d(argDocRest)=0)||(argDocRest="") 0
	s objDocRest=""
	s objDocRest=##class(EMRmeta.EMRDocRestriction.DocRestriction).%OpenId(argDocRest.ID)
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
	s objDocRest=##class(EMRmeta.EMRDocRestriction.DocRestriction).%OpenId(argDocRestID)
	q:(objDocRest="") 0
	d objDocRest.%Close()
	s objDocRest=""
	s result=##class(EMRmeta.EMRDocRestriction.DocRestriction).%DeleteId(argDocRestID)
	q result
}

ClassMethod GetById(argDocRestID As %String) As EMRservice.entity.EMRDocRestriction.EDocRest [ WebMethod ]
{
	s result="",id="",tmpResult="" 
	s result=##class(EMRservice.entity.EMRDocRestriction.EDocRest).%New()
	
	s tmpResult=##class(EMRmeta.EMRDocRestriction.DocRestriction).%OpenId(argDocRestID)
	q:(tmpResult="") result
	
	s result.ID = argDocRestID
	s result.GroupID=tmpResult.GroupID
	s result.RuleItemIDs=tmpResult.RuleItemIDs

	q result
}

ClassMethod GetAllRest(argGroupID As %String) As EMRservice.dataset.EMRDocRestriction.AllDocRestDS [ WebMethod ]
{
	Set result=##class(EMRservice.dataset.EMRDocRestriction.AllDocRestDS).%New()
	d result.SetArgs(argGroupID)
	Quit result
}

}
