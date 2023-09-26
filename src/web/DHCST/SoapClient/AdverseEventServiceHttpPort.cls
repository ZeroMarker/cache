Class web.DHCST.SoapClient.AdverseEventServiceHttpPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method handleBusinessData(sSystemID As %String, sFunctionCode As %String, sThirdBusinessId As %String, sOABusinessId As %String, sTitle As %String, sInitiatorId As %String, sEntityId As %String, sAuditId As %String, sActivityId As %String, iFlowFlag As %xsd.int, sOperationTime As %String, sBusinessData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("handleBusinessData").Invoke($this,"",.sSystemID,.sFunctionCode,.sThirdBusinessId,.sOABusinessId,.sTitle,.sInitiatorId,.sEntityId,.sAuditId,.sActivityId,.iFlowFlag,.sOperationTime,.sBusinessData)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.21.21.155:5566/services/AdverseEventService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.adverseevent.webservice.dhcc.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "AdverseEventService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
