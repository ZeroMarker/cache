Class EMRservice.BOPrivRuleList Extends (%RegisteredObject, %SOAP.WebService) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://127.0.0.1/trakcarelive/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "Privilege.PrivRuleList";

/// Debug: d ##Class(EMRservice.BOPrivRuleList).GetPrivRuleList()
ClassMethod GetPrivRuleList() As %XML.DataSet [ WebMethod ]
{
	Set result = ##Class(%XML.DataSet).%New("EMRservice.BL.BLPrivRuleList:SelectAllRule")
	Do result.SetArgs()
	Quit result
}

}
