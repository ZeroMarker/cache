Class dhc.qm.server.MyServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method Forecast(str As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Forecast").Invoke($this,"http://tempuri.org/dhc.pa.web.MyService.Forecast",.str)
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Test").Invoke($this,"http://tempuri.org/dhc.pa.web.MyService.Test")
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://localhost/dthealth/web/dhc.pa.web.MyService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "MyService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
