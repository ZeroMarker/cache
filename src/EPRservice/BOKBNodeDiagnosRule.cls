Class EPRservice.BOKBNodeDiagnosRule Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "KBNodeDiagnosRuleInfo";

/// Debug:	d ##Class(EPRservice.BOKBNodeDiagnosRule).Insert(2,6,"F","女")
ClassMethod Insert(AKBNodeDiagnosID As %String, ARuleID As %String, ARuleParamCode As %String, ARuleParamDesc As %String) As %String [ WebMethod ]
{
	s objKBNodeDiagnosRule = ##Class(EPRmeta.KBNodeDiagnosRule).%New()
	
	s objKBNodeDiagnosRule.KBNodeDiagnosID = AKBNodeDiagnosID
	s objKBNodeDiagnosRule.DiagnosRuleID = ARuleID
	s objKBNodeDiagnosRule.DiagnosRuleCode = ARuleParamCode
	s objKBNodeDiagnosRule.DiagnosRuleDesc = ARuleParamDesc
	
	if '(objKBNodeDiagnosRule.%Save())
	{
		s ret = -1	
	}
	d objKBNodeDiagnosRule.%Close()
	s ret = objKBNodeDiagnosRule.%Id()
	q ret
}

ClassMethod Delete(AKBNodeDiagnosID As %String, ARuleID As %String, ARuleParamCode As %String) As %String [ WebMethod ]
{
	s ret = 0
	q:(AKBNodeDiagnosID = "")||(ARuleID = "")||(ARuleParamCode = "") ret
	
	s rowID = $o(^DHCEPRM.KBNodeDiagnosRuleI("IdxUnique"," "_AKBNodeDiagnosID," "_ARuleID, " "_ARuleParamCode, ""))
	q:(rowID = "") ret
	
	s objKBNodeDiagnosRule = ##Class(EPRmeta.KBNodeDiagnosRule).%OpenId(rowID)
	s ret = objKBNodeDiagnosRule.%DeleteId(rowID)
	q ret
}

}
