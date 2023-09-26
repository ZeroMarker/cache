Class EPRservice.TemplatePriv.BORuleDetails Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplatePriv.RuleDetails";

ClassMethod Add(argRuleDetails As EPRservice.entity.TemplatePriv.ERuleDetails) As %String [ WebMethod ]
{
	q:($d(argRuleDetails)=0)||(argRuleDetails="") 0
	s aRuleDetails=""
	s aRuleDetails=##class(EPRmeta.TemplatePriv.RuleDetails).%New()
	q:(aRuleDetails="") 0
	
	s aRuleDetails.Type=argRuleDetails.Type
	s aRuleDetails.ConditionValue=argRuleDetails.ConditionValue
	s aRuleDetails.ConditionDesc=argRuleDetails.ConditionDesc
	s aRuleDetails.Rules=##class(EPRmeta.TemplatePriv.TemplatesRule).%OpenId(argRuleDetails.Rules)
	
	s result=""
	s result=aRuleDetails.%Save()
	q aRuleDetails.%Id()
}

ClassMethod Delete(argRuleDetailsID As %String) As %String [ WebMethod ]
{
	q:($d(argRuleDetailsID)=0)||(argRuleDetailsID="") 0
	s aRuleDetails="",result=""
	s aRuleDetails=##class(EPRmeta.TemplatePriv.RuleDetails).%OpenId(argRuleDetailsID)
	q:(aRuleDetails="") 0
	s aRuleDetails=""
	s result=##class(EPRmeta.TemplatePriv.RuleDetails).%DeleteId(argRuleDetailsID)
	q result
}

ClassMethod Update(argRuleDetailsID As %String, argRuleDetails As EPRservice.entity.TemplatePriv.ERuleDetails) As %String [ WebMethod ]
{
	q:($d(argRuleDetailsID)=0)||($d(argRuleDetails)=0)||(argRuleDetailsID="")||(argRuleDetails="") 0
	s aRuleDetails="",result=""
	s aRuleDetails=##class(EPRmeta.TemplatePriv.RuleDetails).%OpenId(argRuleDetailsID)
	q:(aRuleDetails="") 0
	
	s aRuleDetails.Type=argRuleDetails.Type
	s aRuleDetails.ConditionValue=argRuleDetails.ConditionValue
	s aRuleDetails.Rules=argRuleDetails.Rules
	
	s result=""
	s result=aRuleDetails.%Save()
	q result
}

ClassMethod GetById(argRuleDetailsID As %String) As EPRservice.entity.TemplatePriv.ERuleDetails [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.TemplatePriv.ERuleDetails).%New()
	
	s tmpResult=##class(EPRmeta.TemplatePriv.RuleDetails).%OpenId(argRuleDetailsID)
	q:(tmpResult="") result
	s result.ID=argRuleDetailsID
	s result.Type=tmpResult.Type
	s result.ConditionValue=tmpResult.ConditionValue
	s result.Rules=tmpResult.Rules
		
	q result
}

ClassMethod GetAll() As EPRservice.dataset.TemplatePriv.ERuleDetailsDatasetAll [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.TemplatePriv.ERuleDetailsDatasetAll).%New()
 Quit result
}

ClassMethod GetAllByRuleId(parRuleId As %String) As EPRservice.dataset.TemplatePriv.ERuleDByRIdDSAll [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.TemplatePriv.ERuleDByRIdDSAll).%New()
 d result.SetArgs(parRuleId)
 Quit result
}

}
