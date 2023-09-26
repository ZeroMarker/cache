Class dhcserviceclient.CA.SHCAServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default attributeFormQualified for types XML namespace.
Parameter ATTRIBUTEQUALIFIED = 1;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.20.5.34:38080/services/CipherServices";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://webservice.security.openapi.sp.custle.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "CipherServices";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method decodeEnvelopeData(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("decodeEnvelopeData").Invoke($this,"",.in0)
}

Method decrypt(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("decrypt").Invoke($this,"",.in0)
}

Method decryptByPrivateKey(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("decryptByPrivateKey").Invoke($this,"",.in0)
}

Method decryptEX(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("decryptEX").Invoke($this,"",.in0)
}

Method decryptForEGE(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("decryptForEGE").Invoke($this,"",.in0)
}

Method digest(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("digest").Invoke($this,"",.in0)
}

Method encodeEnvelopeData(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("encodeEnvelopeData").Invoke($this,"",.in0)
}

Method encrypt(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("encrypt").Invoke($this,"",.in0)
}

Method encryptByPublicKey(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("encryptByPublicKey").Invoke($this,"",.in0)
}

Method encryptEX(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("encryptEX").Invoke($this,"",.in0)
}

Method generateRandom(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("generateRandom").Invoke($this,"",.in0)
}

Method getCert(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getCert").Invoke($this,"",.in0)
}

Method getCertInfo(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getCertInfo").Invoke($this,"",.in0)
}

Method getCertInfoByOid(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getCertInfoByOid").Invoke($this,"",.in0)
}

Method getPublickeyByCont(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getPublickeyByCont").Invoke($this,"",.in0)
}

Method getValidateDay(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getValidateDay").Invoke($this,"",.in0)
}

Method signByte(in0 As %xsd.base64Binary, in1 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signByte").Invoke($this,"",.in0,.in1)
}

Method signData(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signData").Invoke($this,"",.in0)
}

Method signDataByHash(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signDataByHash").Invoke($this,"",.in0)
}

Method signP7Data(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signP7Data").Invoke($this,"",.in0)
}

Method verifyByteSign(in0 As %xsd.base64Binary, in1 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyByteSign").Invoke($this,"",.in0,.in1)
}

Method verifyCertificate(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyCertificate").Invoke($this,"",.in0)
}

Method verifyP7Data(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyP7Data").Invoke($this,"",.in0)
}

Method verifySignData(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifySignData").Invoke($this,"",.in0)
}

}
