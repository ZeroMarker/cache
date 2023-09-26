Class dhcserviceclient.CA.GDCASignImgServ Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://199.168.200.200/porpoise/signature.asmx";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "signature";

/// This service supports both SOAP 1.1 and SOAP 1.2.
Parameter SOAPVERSION;

Method Signature(code As %String, format As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Signature").Invoke($this,"http://tempuri.org/Signature",.code,.format)
}

}
