Class dhcserviceclient.monitor.ECP138.dhcInterfaceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "https://172.18.18.138:1443/imedical/web/dhcservice.Interface.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "dhcInterface";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method invoke(methodCode As %String, p1 As %String, p2 As %String, p3 As %String, p4 As %String, p5 As %String, p6 As %String, p7 As %String, p8 As %String, p9 As %String, p10 As %String, p11 As %String, p12 As %String, p13 As %String, p14 As %String, p15 As %String, p16 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("invoke").Invoke($this,"http://tempuri.org/dhcservice.Interface.invoke",.methodCode,.p1,.p2,.p3,.p4,.p5,.p6,.p7,.p8,.p9,.p10,.p11,.p12,.p13,.p14,.p15,.p16)
}

}
