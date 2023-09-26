Class dhcserviceclient.CA.NETCAServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke(##this,"http://tempuri.org/GenRandom")
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCert").Invoke(##this,"http://tempuri.org/GetServerCert")
}

Method SignData(inData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SignData").Invoke(##this,"http://tempuri.org/SignData",.inData)
}

Method VerifyCertAndSignedData(cert As %String, inData As %String, signData As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke(##this,"http://tempuri.org/VerifyCertAndSignedData",.cert,.inData,.signData)
}

Method VerifySignedData(cert As %String, inData As %String, signData As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke(##this,"http://tempuri.org/VerifySignedData",.cert,.inData,.signData)
}

Method CreateTimeStamp(input As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke(##this,"http://tempuri.org/CreateTimeStamp",.input)
}

Method VerifyTimeStamp(input As %String, tsaFile As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke(##this,"http://tempuri.org/VerifyTimeStamp",.input,.tsaFile)
}

/// This is the URL used to access the web service.
/// Parameter LOCATION = "http://172.21.21.31:8005/Service.asmx";
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// This is the name of the Service
Parameter SERVICENAME = "Service";

}
