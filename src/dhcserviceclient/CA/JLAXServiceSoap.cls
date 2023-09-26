Class dhcserviceclient.CA.JLAXServiceSoap Extends %SOAP.WebClient [ ClassType = "", ProcedureBlock ]
{

//Parameter LOCATION = "http://175.17.252.152:8000/Service";

/// 吉林安信服务代理类
/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "Service";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method CreateTimeStamp(timeStampRequest As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke(##this,"",.timeStampRequest)
}

Method CreateTimeStampRequest(originalData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampRequest").Invoke(##this,"",.originalData)
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke(##this,"")
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCert").Invoke(##this,"")
}

Method SignData(InData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SignData").Invoke(##this,"",.InData)
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke(##this,"",.bstrCert,.inData,.signedData)
}

Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke(##this,"",.bstrCert,.inData,.signedData)
}

Method VerifyTimeStamp(timeStampString As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke(##this,"",.timeStampString)
}

}
