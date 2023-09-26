Class dhcserviceclient.CA.XJCAServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default attributeFormQualified for types XML namespace.
Parameter ATTRIBUTEQUALIFIED = 1;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.31.9.104/webservice/services/SecurityEngineDeal";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.xjgzinfo.com/xjcasso/ssoService";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "ssoService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method XJCAAppGet(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_AppGet").Invoke($this,"",.in0)
}

Method XJCACertAuth(in0 As %String, in1 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_CertAuth").Invoke($this,"",.in0,.in1)
}

Method XJCACertCheck(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_CertCheck").Invoke($this,"",.in0)
}

Method XJCACertGet(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_CertGet").Invoke($this,"",.in0)
}

Method XJCAUserCode(in0 As %String, in1 As %String) As %Boolean(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_UserCode").Invoke($this,"",.in0,.in1)
}

Method XJCAdelayAllApp(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_delayAllApp").Invoke($this,"",.in0)
}

Method XJCAdelayApp(in0 As %String, in1 As %String, in2 As %xsd.int(REQUIRED=1)) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_delayApp").Invoke($this,"",.in0,.in1,.in2)
}

Method XJCAdelayAppGS(in0 As %String, in1 As %String, in2 As %xsd.int(REQUIRED=1)) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("XJCA_delayAppGS").Invoke($this,"",.in0,.in1,.in2)
}

}
