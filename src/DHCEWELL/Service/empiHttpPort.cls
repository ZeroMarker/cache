Class DHCEWELL.Service.empiHttpPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method HIPMessageServer(action As %String, reqContent As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://esb.ewell.cc/HIPMessageServer",.action,.reqContent)
}

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.4.132.19:7801/empi/empi";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://esb.ewell.cc";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "empiHttpService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
