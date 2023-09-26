/// Creator：      zhouxin
/// CreatDate：    2019-06-29
/// Description:： 规则编辑器中的可以引用的规则
Class web.DHCCKBRuleParameter Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	
	s Parameters=[]
	s Parameter=##class(web.DHCCKBRuleParameter).GetParameter()
	d Parameters.%Push(Parameter)
	w Parameters.%ToJSON()
	Quit $$$OK
}

/// w ##class(web.DHCCKBRuleParameter).GetParameter().%ToJSON()
ClassMethod GetParameter()
{
	

	s parameters=[]
	s AddRuleFlag=##class(web.DHCCKBCommon).GetAddRuleFlag()
	s link="" f  s link=$o(^CT.CKB.PDSS.DicLinkAttrI("LinkAttrCode",AddRuleFlag,link)) q:link=""  d
	.s dic=$lg($g(^CT.CKB.PDSS.DicLinkAttrD(link)),2)
	.s rule="" f  s rule=$o(^CT.CKB.PDSS.RuleD(0,"codeRelation",AddRuleFlag,dic,rule)) q:rule=""  d
	..s parameter={}
    ..s parameter.name=rule
   	..s parameter.type="String"
    ..s parameter.label=$lg($g(^CT.CKB.PDSS.RuleD(rule)),8)
	..s parameter.act="InOut"
    ..d parameters.%Push(parameter)
    
    q parameters
}

}
