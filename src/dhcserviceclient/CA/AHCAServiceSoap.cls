Class dhcserviceclient.CA.AHCAServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://117.71.58.70:86/svs-fes-fordh/webservice/SvsService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://webservice.svsfes.aheca.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "SvsService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method CreateTimeStamp(in0 As %String, in1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke($this,"",.in0,.in1)
}

Method CreateTimeStampRequest(in0 As %String, in1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampRequest").Invoke($this,"",.in0,.in1)
}

Method CreateTimeStampAHCA(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampAHCA").Invoke($this,"",.in0)
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke($this,"")
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCert").Invoke($this,"")
}

Method P7SignData(in0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("P7SignData").Invoke($this,"",.in0)
}

Method P7VerifyCertAndSignedData(in0 As %String, in1 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("P7VerifyCertAndSignedData").Invoke($this,"",.in0,.in1)
}

Method P7VerifySignedData(in0 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("P7VerifySignedData").Invoke($this,"",.in0)
}

Method SignData(in0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SignData").Invoke($this,"",.in0)
}

Method VerifyCertAndSignedData(in0 As %String, in1 As %String, in2 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke($this,"",.in0,.in1,.in2)
}

Method VerifySignedData(in0 As %String, in1 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke($this,"",.in0,.in1)
}

Method VerifyTimeStamp(in0 As %String, in1 As %String, in2 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke($this,"",.in0,.in1,.in2)
}

Method VerifyTimeStampAHCA(in0 As %String, in1 As %String) As %xsd.int(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStampAHCA").Invoke($this,"",.in0,.in1)
}

}
