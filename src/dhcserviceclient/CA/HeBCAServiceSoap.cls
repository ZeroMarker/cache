Class dhcserviceclient.CA.HeBCAServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://121.28.49.158:8081/HebcaHisWebserviceV3/CAServicePort";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://caservice.hebca.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "CAServiceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke($this,"")
}

Method VerifyCertAndSignedData(arg0 As %String, arg1 As %String, arg2 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method VerifySignedData(arg0 As %String, arg1 As %String, arg2 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method VerifyTimeStamp(arg0 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke($this,"",.arg0)
}

}
