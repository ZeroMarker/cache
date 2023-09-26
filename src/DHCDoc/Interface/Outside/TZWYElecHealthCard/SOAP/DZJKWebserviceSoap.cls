Class DHCDoc.Interface.Outside.TZWYElecHealthCard.SOAP.DZJKWebserviceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method DZJKMessager(Flag As %String, Json As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("DZJKMessager").Invoke($this,"http://tempuri.org/DHC.DZJK.BS.DZJKWebservice.DZJKMessager",.Flag,.Json)
 //Quit ..WebMethod("DZJKMessager").Invoke($this,"http://tempuri.org/DHC.DZJK.BS.DZJKWebservice",.Flag,.Json)
}

/// This is the URL used to access the web service.
/// Parameter LOCATION = "http://192.168.6.14/csp/i-pay/DHC.DZJK.BS.DZJKWebservice.cls";
/// 
Parameter LOCATION = "http://192.168.20.8/csp/i-pay/DHC.DZJK.BS.DZJKWebservice.CLS";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "DZJKWebservice";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
