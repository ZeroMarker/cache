Class dhcserviceclient.CA.HuNCAServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.33.236:8082/YYPHCawebservice/HuncaSVSService";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://impl.soap.service.hunca.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "HuncaSVSService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "http://service.hunan.com/";

Method CreateTimeStamp(timeStampRequest As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke($this,"",.timeStampRequest)
}

Method GenRandom() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GenRandom").Invoke($this,"")
}

Method HuncaBase64(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaBase64").Invoke($this,"",.arg0)
}

Method HuncaCertDelay(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %xsd.int) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaCertDelay").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaCreateSign(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %xsd.int, arg4 As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaCreateSign").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4)
}

Method HuncaCreateTimeStamp(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaCreateTimeStamp").Invoke($this,"",.arg0,.arg1)
}

Method HuncaDecode(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaDecode").Invoke($this,"",.arg0)
}

Method HuncaEnvelopePacket(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaEnvelopePacket").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaEnvelopeUnpack(arg0 As %String, arg1 As %String, arg2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaEnvelopeUnpack").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaGetDBdate(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetDBdate").Invoke($this,"",.arg0,.arg1)
}

Method HuncaGetFJH(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetFJH").Invoke($this,"",.arg0)
}

Method HuncaGetG(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetG").Invoke($this,"",.arg0)
}

Method HuncaGetIssuer(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetIssuer").Invoke($this,"",.arg0)
}

Method HuncaGetO(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetO").Invoke($this,"",.arg0)
}

Method HuncaGetPCSCert(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetPCSCert").Invoke($this,"",.arg0,.arg1)
}

Method HuncaGetRandom(arg0 As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetRandom").Invoke($this,"",.arg0)
}

Method HuncaGetSign(arg0 As %Integer) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetSign").Invoke($this,"",.arg0)
}

Method HuncaGetSignEx(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetSignEx").Invoke($this,"",.arg0,.arg1)
}

Method HuncaGetSignTW(arg0 As %String, arg1 As %String, arg2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetSignTW").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaGetSn(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetSn").Invoke($this,"",.arg0)
}

Method HuncaGetSubject(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetSubject").Invoke($this,"",.arg0)
}

Method HuncaGetTimeStamp(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetTimeStamp").Invoke($this,"",.arg0)
}

Method HuncaGetUsername(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaGetUsername").Invoke($this,"",.arg0,.arg1)
}

Method HuncaPriKeyDecrypt(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaPriKeyDecrypt").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaPubKeyEncrypt(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %xsd.int) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaPubKeyEncrypt").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaRemainingDay(arg0 As %String, arg1 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaRemainingDay").Invoke($this,"",.arg0,.arg1)
}

Method HuncaSaveSign(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSaveSign").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaSaveSignEx(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSaveSignEx").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4)
}

Method HuncaSaveSignEx2(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String, arg5 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSaveSignEx2").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4,.arg5)
}

Method HuncaSaveSignTW(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %String, arg5 As %String, arg6 As %String, arg7 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSaveSignTW").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4,.arg5,.arg6,.arg7)
}

Method HuncaSaveTimeStamp(arg0 As %String, arg1 As %String, arg2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSaveTimeStamp").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaSetCAUserCert(arg0 As %String, arg1 As %String, arg2 As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSetCAUserCert").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaSetCAUserCertEx(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %xsd.int) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSetCAUserCertEx").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaSetCAUserCertEx2(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String) As %Boolean [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaSetCAUserCertEx2").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method HuncaVerify(arg0 As %String, arg1 As %String, arg2 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerify").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaVerifyCert(arg0 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerifyCert").Invoke($this,"",.arg0)
}

Method HuncaVerifyEx(arg0 As %String, arg1 As %String, arg2 As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerifyEx").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaVerifyLogin(arg0 As %String, arg1 As %String, arg2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerifyLogin").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method HuncaVerifyPKCS1(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String, arg4 As %xsd.int) As %Integer [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerifyPKCS1").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4)
}

Method HuncaVerifyPKCS7(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %Boolean, arg4 As %xsd.int, arg5 As %String) As %Integer [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerifyPKCS7").Invoke($this,"",.arg0,.arg1,.arg2,.arg3,.arg4,.arg5)
}

Method HuncaVerifyTimeStamp(arg0 As %String, arg1 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HuncaVerifyTimeStamp").Invoke($this,"",.arg0,.arg1)
}

Method SM1Decrypt(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SM1Decrypt").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method SM1Encrypt(arg0 As %String, arg1 As %String, arg2 As %String, arg3 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SM1Encrypt").Invoke($this,"",.arg0,.arg1,.arg2,.arg3)
}

Method SM3Digest(arg0 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SM3Digest").Invoke($this,"",.arg0)
}

Method SM4Decrypt(arg0 As %String, arg1 As %String, arg2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SM4Decrypt").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method SM4Encrypt(arg0 As %String, arg1 As %String, arg2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SM4Encrypt").Invoke($this,"",.arg0,.arg1,.arg2)
}

Method VerifyCertAndSignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyCertAndSignedData").Invoke($this,"",.bstrCert,.inData,.signedData)
}

Method VerifySignedData(bstrCert As %String, inData As %String, signedData As %String) As %xsd.int [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifySignedData").Invoke($this,"",.bstrCert,.inData,.signedData)
}

Method VerifyTimeStamp(timeStamp As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke($this,"",.timeStamp)
}

}
