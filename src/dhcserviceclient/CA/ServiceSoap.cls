/// 北京CA服务代理类
Class dhcserviceclient.CA.ServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

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
 Quit ..WebMethod("CreateTimeStamp").Invoke(##this,"http://tempuri.org/CreateTimeStamp",.timeStampRequest)
}

Method CreateTimeStampRequest(originalData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampRequest").Invoke(##this,"http://tempuri.org/CreateTimeStampRequest",.originalData)
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke(##this,"http://tempuri.org/GenRandom")
}

Method GetCertInfo(bstrCert As %String, type As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetCertInfo").Invoke(##this,"http://tempuri.org/GetCertInfo",.bstrCert,.type)
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCert").Invoke(##this,"http://tempuri.org/GetServerCert")
}

Method GetTimeStampInfo(timeStampString As %String, informationCode As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetTimeStampInfo").Invoke(##this,"http://tempuri.org/GetTimeStampInfo",.timeStampString,.informationCode)
}

Method SignData(InData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SignData").Invoke(##this,"http://tempuri.org/SignData",.InData)
}

Method ValidateCertificate(bstrCert As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ValidateCertificate").Invoke(##this,"http://tempuri.org/ValidateCertificate",.bstrCert)
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke(##this,"http://tempuri.org/VerifyCertAndSignedData",.bstrCert,.inData,.signedData)
}

Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke(##this,"http://tempuri.org/VerifySignedData",.bstrCert,.inData,.signedData)
}

Method VerifyTimeStamp(timeStampString As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke(##this,"http://tempuri.org/VerifyTimeStamp",.timeStampString)
}

}
