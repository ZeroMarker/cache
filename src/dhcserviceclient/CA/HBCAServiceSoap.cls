///  湖北CA服务代理类
Class dhcserviceclient.CA.HBCAServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://1.1.1.163:8080/hbcaDSS/hbcaService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://jws.back.hb.org.cn/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HbcaServiceService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method createP10(certId As %String, certName As %String, applyDn As %String, encryptAlg As %String, keyLength As %String, digestAlg As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("createP10").Invoke($this,"",.certId,.certName,.applyDn,.encryptAlg,.keyLength,.digestAlg)
}

Method createP10ForUpdate(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("createP10ForUpdate").Invoke($this,"",.arg0)
}

Method createTimeStamp(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("createTimeStamp").Invoke($this,"",.arg0)
}

Method createTimeStampRequest(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("createTimeStampRequest").Invoke($this,"",.arg0)
}

Method decryptEnvelop(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("decryptEnvelop").Invoke($this,"",.arg0,.arg1)
}

Method deleteEncCert(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deleteEncCert").Invoke($this,"",.arg0)
}

Method deleteSignCert(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("deleteSignCert").Invoke($this,"",.arg0)
}

Method encryptEnvelop(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("encryptEnvelop").Invoke($this,"",.arg0,.arg1)
}

Method genRandom() As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("genRandom").Invoke($this,"")
}

Method getEncCert(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getEncCert").Invoke($this,"",.arg0)
}

Method getSealImage(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getSealImage").Invoke($this,"",.arg0)
}

Method getServerCert() As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getServerCert").Invoke($this,"")
}

Method getServerCertEx(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getServerCertEx").Invoke($this,"",.arg0)
}

Method getSignCert(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getSignCert").Invoke($this,"",.arg0)
}

Method hello() As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("hello").Invoke($this,"")
}

Method importEncCert(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String, arg5 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("importEncCert").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4,.arg5)
}

Method importEncCertForUpdate(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String, arg5 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("importEncCertForUpdate").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4,.arg5)
}

Method importSignCert(certId As %String, certName As %String, signCertB64 As %String, certType As %String, rootCertName As %String, importType As %String, password As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("importSignCert").Invoke($this,"",.certId,.certName,.signCertB64,.certType,.rootCertName,.importType,.password)
}

Method importSignCertForUpdate(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String, arg5 As %String, arg6 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("importSignCertForUpdate").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4,.arg5,.arg6)
}

Method priKeyDecryptEx(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("priKeyDecryptEx").Invoke($this,"",.arg0,.arg1)
}

Method pubKeyEncrypt(arg0 As %String, arg1 As %xsd.base64Binary) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("pubKeyEncrypt").Invoke($this,"",.arg0,.arg1)
}

Method pubKeyEncryptEx(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("pubKeyEncryptEx").Invoke($this,"",.arg0,.arg1)
}

Method signData(inData As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signData").Invoke($this,"",.inData)
}

Method signDataByteEx(arg0 As %String, arg1 As %xsd.base64Binary) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signDataByteEx").Invoke($this,"",.arg0,.arg1)
}

Method signDataByteExraw(arg0 As %String, arg1 As %xsd.base64Binary) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signDataByteEx_raw").Invoke($this,"",.arg0,.arg1)
}

Method signDataEx(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signDataEx").Invoke($this,"",.arg0,.arg1)
}

Method signDataP7Detach(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("signDataP7Detach").Invoke($this,"",.arg0,.arg1)
}

Method sm3Hash(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("sm3Hash").Invoke($this,"",.arg0,.arg1)
}

Method sm3HashRaw(arg0 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("sm3HashRaw").Invoke($this,"",.arg0)
}

Method symmDataDec(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("symmDataDec").Invoke($this,"",.arg0,.arg1)
}

Method symmDataEnc(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("symmDataEnc").Invoke($this,"",.arg0,.arg1)
}

Method symmDataEncEx(arg0 As %String, arg1 As %xsd.base64Binary) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("symmDataEncEx").Invoke($this,"",.arg0,.arg1)
}

Method validate4GenerateP10(arg0 As %String, arg1 As %String, arg2 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("validate4GenerateP10")).Invoke($this,"",.arg0,.arg1,.arg2)
}

Method validate4IdAndName(arg0 As %String, arg1 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("validate4IdAndName")).Invoke($this,"",.arg0,.arg1)
}

Method validate4ImportEncCert(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("validate4ImportEncCert")).Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4)
}

Method validate4ImportSignCert(arg0 As %String, arg1 As %String, arg2 As %String) [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Do (..WebMethod("validate4ImportSignCert")).Invoke($this,"",.arg0,.arg1,.arg2)
}

Method verifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyCertAndSignedData").Invoke($this,"",.bstrCert,.inData,.signedData)
}

Method verifyDetachSignData(arg0 As %String, arg1 As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyDetachSignData").Invoke($this,"",.arg0,.arg1)
}

Method verifyDetachSignDataEx(arg0 As %String, arg1 As %String, arg2 As %Boolean(REQUIRED=1), arg3 As %Boolean(REQUIRED=1), arg4 As %Boolean(REQUIRED=1)) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyDetachSignDataEx").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4)
}

Method verifySignedData(arg0 As %String, arg1 As %String, arg2 As %String) As %xsd.int(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifySignedData").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method verifyTimeStamp(arg0 As %String) As %xsd.int(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyTimeStamp").Invoke($this,"",.arg0)
}

}
