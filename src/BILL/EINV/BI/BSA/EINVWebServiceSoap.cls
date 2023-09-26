Class BILL.EINV.BI.BSA.EINVWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.101.96:57772/csp/billeinvweb//BILLEINV.WebService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://192.168.101.96:57772/csp/billeinvweb/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "EINVWebService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method InvoiceWebRequest(FactoryCode As %String, ServiceCode As %String, HISUniqueID As %String, Message As %GlobalCharacterStream, Appid As %String, Noise As %String, SecretKey As %String, Version As %String, ServerPath As %String, Server As %String, Port As %String, Timeout As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("InvoiceWebRequest").Invoke($this,"http://192.168.101.96:57772/csp/billeinvweb//BILLEINV.WebService.InvoiceWebRequest",.FactoryCode,.ServiceCode,.HISUniqueID,.Message,.Appid,.Noise,.SecretKey,.Version,.ServerPath,.Server,.Port,.Timeout)
}

Method Test() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Test").Invoke($this,"http://192.168.101.96:57772/csp/billeinvweb//BILLEINV.WebService.Test")
}

}
