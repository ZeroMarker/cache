Class ClientService.SwitchSystemWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method SwitchSystem(Source As %String, SystemCode As %String, Input As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SwitchSystem").Invoke($this,"http://tempuri.org/DHC.SwitchSystem.BS.SwitchSystemWebService.SwitchSystem",.Source,.SystemCode,.Input)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.4/csp/i-test/DHC.SwitchSystem.BS.SwitchSystemWebService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "SwitchSystemWebService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
