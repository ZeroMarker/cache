Class dhcserviceclient.CA.FAKEServiceSoap Extends %SOAP.WebClient [ Not ProcedureBlock ]
{

// FAKE服务代理类

//Parameter LOCATION = "http://172.21.21.5:8004/Service.asmx";

/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "Service";

Method CreateTimeStamp(timeStampRequest As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method CreateTimeStampRequest(originalData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit "A78B234C324D324D234E78F1"
}

Method GetCertInfo(bstrCert As %String, type As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method GetTimeStampInfo(timeStampString As %String, informationCode As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit $ZDT($h,3)
}

Method SignData(InData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method ValidateCertificate(bstrCert As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

Method VerifyTimeStamp(timeStampString As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ""
}

}
