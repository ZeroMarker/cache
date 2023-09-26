Class dhc.qm.server.PublicServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method RequestMethod(RequestCode As %String, RequestXML As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("RequestMethod").Invoke($this,"http://tempuri.org/dhc.qm.service.PublicService.RequestMethod",.RequestCode,.RequestXML)
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Test").Invoke($this,"http://tempuri.org/dhc.qm.service.PublicService.Test")
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.160.16.30/dthealth/web/dhc.qm.service.PublicService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PublicService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
