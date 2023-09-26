Class EPRservice.TemplatePriv.BOBTemplatesRule Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://192.168.0.15/trakcarejst/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TemplatePriv.TemplatesRule";

ClassMethod Add(argTemplatesRule As EPRservice.entity.TemplatePriv.ETemplatesRule) As %String [ WebMethod ]
{
	q:(($d(argTemplatesRule)=0)||(argTemplatesRule="")) ""
	s aTemplatesRule=""
	s aTemplatesRule=##class(EPRmeta.TemplatePriv.TemplatesRule).%New()
	q:(aTemplatesRule="") 0
	
	s aTemplatesRule.AllConditionType=argTemplatesRule.AllConditionType
	s aTemplatesRule.AvailAction=argTemplatesRule.AvailAction
	s aTemplatesRule.TemplateGroup=##class(EPRmeta.TemplatePriv.TemplateGroup).%OpenId(argTemplatesRule.TemplateGroup)
	
	s result=""
	s result=aTemplatesRule.%Save()
	q aTemplatesRule.%Id()
}

ClassMethod Delete(argTemplatesRuleID As %String) As %String [ WebMethod ]
{
	q:($d(argTemplatesRuleID)=0)||(argTemplatesRuleID="") 0
	s aTemplatesRule="",result=""
	s aTemplatesRule=##class(EPRmeta.TemplatePriv.TemplatesRule).%OpenId(argTemplatesRuleID)
	q:(aTemplatesRule="") 0
	s aTemplatesRule=""
	s result=##class(EPRmeta.TemplatePriv.TemplatesRule).%DeleteId(argTemplatesRuleID)
	q result
}

ClassMethod Update(argTemplatesRuleID As %String, argTemplatesRule As EPRservice.entity.TemplatePriv.ETemplatesRule) As %String [ WebMethod ]
{
	q:($d(argTemplatesRuleID)=0)||($d(argTemplatesRule)=0)||(argTemplatesRuleID="")||(argTemplatesRule="") 0
	s aTemplatesRule="",result=""
	s aTemplatesRule=##class(EPRmeta.TemplatePriv.TemplatesRule).%OpenId(argTemplatesRuleID)
	q:(aTemplatesRule="") 0
	
	s aTemplatesRule.AllConditionType=argTemplatesRule.AllConditionType
	//s aTemplatesRule.AvailAction=argTemplatesRule.AvailAction
	//s aTemplatesRule.TemplateGroup=argTemplatesRule.TemplateGroup
	
	s result=""
	s result=aTemplatesRule.%Save()
	q result
}

ClassMethod GetById(argTemplatesRuleID As %String) As EPRservice.entity.TemplatePriv.ETemplatesRule [ WebMethod ]
{
	s result="",id="",tmpResult=""
	s result=##class(EPRservice.entity.TemplatePriv.ETemplatesRule).%New()
	
	s tmpResult=##class(EPRmeta.TemplatePriv.TemplatesRule).%OpenId(argTemplatesRuleID)
	q:(tmpResult="") result
	s result.ID=argTemplatesRuleID
	s result.AllConditionType=tmpResult.AllConditionType
	s result.AvailAction=tmpResult.AvailAction
	s result.TemplateGroup=tmpResult.TemplateGroup
		
	q result
}

ClassMethod GetAll() As EPRservice.dataset.TemplatePriv.ETemplatesRuleDatasetAll [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.TemplatePriv.ETemplatesRuleDatasetAll).%New()
 Quit result
}

ClassMethod GetByGroupIdAndAct(parGroupId As %String, parAction As %String) As EPRservice.dataset.TemplatePriv.ERuleByGroupAndActDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.TemplatePriv.ERuleByGroupAndActDataset).%New()
 d result.SetArgs(parGroupId,parAction)
 Quit result
}

}
