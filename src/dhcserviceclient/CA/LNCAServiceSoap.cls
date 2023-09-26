Class dhcserviceclient.CA.LNCAServiceSoap Extends %SOAP.WebClient [ ClassType = "", ProcedureBlock ]
{

Method CreateTimeStamp(timeStampReq As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke(##this,"http://tempuri.org/CreateTimeStamp",.timeStampReq)
}

Method CreateTimeStampRequest(InData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampRequest").Invoke(##this,"http://tempuri.org/CreateTimeStampRequest",.InData)
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke(##this,"http://tempuri.org/GenRandom")
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCert").Invoke(##this,"http://tempuri.org/GetServerCert")
}

Method SignData(InData As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SignData").Invoke(##this,"http://tempuri.org/SignData",.InData)
}

Method VerifyCertAndSignedData(Cert As %String, InData As %String, SignedData As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke(##this,"http://tempuri.org/VerifyCertAndSignedData",.Cert,.InData,.SignedData)
}

Method VerifySignedData(Cert As %String, InData As %String, SignedData As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke(##this,"http://tempuri.org/VerifySignedData",.Cert,.InData,.SignedData)
}

Method VerifyTimeStamp(timeStamp As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke(##this,"http://tempuri.org/VerifyTimeStamp",.timeStamp)
}

//Parameter LOCATION = "http://127.0.0.1/LNCA/Service.asmx";

/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "Service";

/// This service supports both SOAP 1.1 and SOAP 1.2.
Parameter SOAPVERSION;

}
