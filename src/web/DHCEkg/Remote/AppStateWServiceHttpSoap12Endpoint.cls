Class web.DHCEkg.Remote.AppStateWServiceHttpSoap12Endpoint Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method updateAppState(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = rpc, SoapBodyUse = literal, SoapNameSpace = "http://appstate.ws.rcm.dhcc.com/", WebMethod ]
{
 Quit ..WebMethod("updateAppState").Invoke($this,"",.arg0)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.102.13:8080/rcm/ws/appStateWService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://appstate.ws.rcm.dhcc.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "AppStateWServiceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Non-default use of element/type attribute in parts.
Parameter XMLELEMENT = 0;

}
