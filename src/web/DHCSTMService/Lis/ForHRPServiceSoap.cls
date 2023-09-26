Class web.DHCSTMService.Lis.ForHRPServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://IP地址(需修改)/imedicallis//LIS.Service.RG.WebService.ForHRPService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "ForHRPService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method OfferInterface(Flag As %String, xml As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("OfferInterface").Invoke($this,"http://tempuri.org/LIS.Service.RG.WebService.ForHRPService.OfferInterface",.Flag,.xml)
}

}
