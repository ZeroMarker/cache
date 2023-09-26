Class web.DHCSTMService.FrontECS.ServicePort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method ecsService(user As %String, pwd As %String, opcode As %String, data As %String, token As %String) As %GlobalCharacterStream(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ecsService").Invoke($this,"",.user,.pwd,.opcode,.data,.token)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://113.140.81.67:18080/ecs/webservice/Service";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://server.ws.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "ServiceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
