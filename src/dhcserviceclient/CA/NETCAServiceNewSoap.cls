Class dhcserviceclient.CA.NETCAServiceNewSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

//Parameter LOCATION = "http://14.18.158.147:18085/NetcaPKI_DongHua/NetcaPKIDonghuaPort";

/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://Service.donghua.pki.netca.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "NetcaPKIDonghuaService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method ApplyTimeStamp(arg0 As %String) As %ListOfDataTypes(ELEMENTTYPE="%String",XMLPROJECTION="element",XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("ApplyTimeStamp").Invoke($this,"",.arg0)
}

Method CreateTimeStamp(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke($this,"",.arg0)
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke($this,"")
}

Method GetServerCert() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCert").Invoke($this,"")
}

Method GetTimeStamp(arg0 As %String, arg1 As %String) As %ListOfDataTypes(ELEMENTTYPE="%String",XMLPROJECTION="element",XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetTimeStamp").Invoke($this,"",.arg0,.arg1)
}

Method SignData(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SignData").Invoke($this,"",.arg0)
}

Method VerifyCertAndSignedData(arg0 As %String, arg1 As %String, arg2 As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method VerifySignedData(arg0 As %String, arg1 As %String, arg2 As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method VerifyTimeStamp(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke($this,"",.arg0,.arg1)
}

Method VerifyTimeStampByNet(arg0 As %String) As %ListOfDataTypes(ELEMENTTYPE="%String",XMLPROJECTION="element",XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStampByNet").Invoke($this,"",.arg0)
}

}
