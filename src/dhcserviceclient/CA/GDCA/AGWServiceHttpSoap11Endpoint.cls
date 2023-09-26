Class dhcserviceclient.CA.GDCA.AGWServiceHttpSoap11Endpoint Extends %SOAP.WebClient [ ProcedureBlock ]
{

//Parameter LOCATION = "http://bswg2.95105813.cn:8080/AGW/services/AGWService.AGWServiceHttpSoap11Endpoint/";

/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://service.agw";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "AGWService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method WSArrayIBESign(req As dhcserviceclient.CA.GDCA.ax21.ArrayIBESignReq) As dhcserviceclient.CA.GDCA.ax21.IBESignResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_ArrayIBESign").Invoke($this,"urn:WS_ArrayIBESign",.req)
}

Method WSArrayIBEVerify(req As dhcserviceclient.CA.GDCA.ax21.ArrayIBEVerifyReq) As dhcserviceclient.CA.GDCA.ax21.IBEVerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_ArrayIBEVerify").Invoke($this,"urn:WS_ArrayIBEVerify",.req)
}

Method WSCheckCert(req As dhcserviceclient.CA.GDCA.ax21.CkCertReq) As dhcserviceclient.CA.GDCA.ax21.CkCertResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_CheckCert").Invoke($this,"urn:WS_CheckCert",.req)
}

Method WSGenRand(req As dhcserviceclient.CA.GDCA.ax21.RandReq) As dhcserviceclient.CA.GDCA.ax21.RandResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GenRand").Invoke($this,"urn:WS_GenRand",.req)
}

Method WSGetCert() As dhcserviceclient.CA.GDCA.ax21.CertResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GetCert").Invoke($this,"urn:WS_GetCert")
}

Method WSGetCertOIDValue(req As dhcserviceclient.CA.GDCA.ax21.CertOIDReq) As dhcserviceclient.CA.GDCA.ax21.CertOIDResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GetCertOIDValue").Invoke($this,"urn:WS_GetCertOIDValue",.req)
}

Method WSGetCertUniqueID(req As dhcserviceclient.CA.GDCA.ax21.CertUniqueIDReq) As dhcserviceclient.CA.GDCA.ax21.CertUniqueIDResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GetCertUniqueID").Invoke($this,"urn:WS_GetCertUniqueID",.req)
}

Method WSGetSeriviceInfo() As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GetSeriviceInfo").Invoke($this,"urn:WS_GetSeriviceInfo")
}

Method WSGetTime() As dhcserviceclient.CA.GDCA.ax21.TimeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GetTime").Invoke($this,"urn:WS_GetTime")
}

Method WSGetUserCert(req As dhcserviceclient.CA.GDCA.ax21.UserCertReq) As dhcserviceclient.CA.GDCA.ax21.UserCertResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_GetUserCert").Invoke($this,"urn:WS_GetUserCert",.req)
}

Method WSHashData(req As dhcserviceclient.CA.GDCA.ax21.HashReq) As dhcserviceclient.CA.GDCA.ax21.HashResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_HashData").Invoke($this,"urn:WS_HashData",.req)
}

Method WSOpenEnvelope(req As dhcserviceclient.CA.GDCA.ax21.OpEnvelopeReq) As dhcserviceclient.CA.GDCA.ax21.OpEnvelopeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_OpenEnvelope").Invoke($this,"urn:WS_OpenEnvelope",.req)
}

Method WSP1Sign(req As dhcserviceclient.CA.GDCA.ax21.P1SignReq) As dhcserviceclient.CA.GDCA.ax21.P1SignResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P1Sign").Invoke($this,"urn:WS_P1Sign",.req)
}

Method WSP1SignBytes(req As dhcserviceclient.CA.GDCA.ax21.P1SignBytesReq) As dhcserviceclient.CA.GDCA.ax21.P1SignResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P1SignBytes").Invoke($this,"urn:WS_P1SignBytes",.req)
}

Method WSP1Verify(req As dhcserviceclient.CA.GDCA.ax21.P1VerifyReq) As dhcserviceclient.CA.GDCA.ax21.P1VerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P1Verify").Invoke($this,"urn:WS_P1Verify",.req)
}

Method WSP1VerifyBySN(req As dhcserviceclient.CA.GDCA.ax21.P1VerifyBySNReq) As dhcserviceclient.CA.GDCA.ax21.P1VerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P1VerifyBySN").Invoke($this,"urn:WS_P1VerifyBySN",.req)
}

Method WSP1VerifyBytes(req As dhcserviceclient.CA.GDCA.ax21.P1VerifyBytesReq) As dhcserviceclient.CA.GDCA.ax21.P1VerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P1VerifyBytes").Invoke($this,"urn:WS_P1VerifyBytes",.req)
}

Method WSP7OpenEnvelope(req As dhcserviceclient.CA.GDCA.ax21.OpEnvelopeReq) As dhcserviceclient.CA.GDCA.ax21.OpEnvelopeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7OpenEnvelope").Invoke($this,"urn:WS_P7OpenEnvelope",.req)
}

Method WSP7OpenEnvelopeCapicom(req As dhcserviceclient.CA.GDCA.ax21.OpEnvelopeReq) As dhcserviceclient.CA.GDCA.ax21.OpEnvelopeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7OpenEnvelopeCapicom").Invoke($this,"urn:WS_P7OpenEnvelopeCapicom",.req)
}

Method WSP7SealEnvelope(req As dhcserviceclient.CA.GDCA.ax21.SeEnvelopeReq) As dhcserviceclient.CA.GDCA.ax21.SeEnvelopeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7SealEnvelope").Invoke($this,"urn:WS_P7SealEnvelope",.req)
}

Method WSP7SealEnvelopeCapicom(req As dhcserviceclient.CA.GDCA.ax21.SeEnvelopeReq) As dhcserviceclient.CA.GDCA.ax21.SeEnvelopeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7SealEnvelopeCapicom").Invoke($this,"urn:WS_P7SealEnvelopeCapicom",.req)
}

Method WSP7Sign(req As dhcserviceclient.CA.GDCA.ax21.P7SignReq) As dhcserviceclient.CA.GDCA.ax21.P7SignResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7Sign").Invoke($this,"urn:WS_P7Sign",.req)
}

Method WSP7SignCapicom(req As dhcserviceclient.CA.GDCA.ax21.P7SignReq) As dhcserviceclient.CA.GDCA.ax21.P7SignResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7SignCapicom").Invoke($this,"urn:WS_P7SignCapicom",.req)
}

Method WSP7Verify(req As dhcserviceclient.CA.GDCA.ax21.P7VerifyReq) As dhcserviceclient.CA.GDCA.ax21.P7VerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7Verify").Invoke($this,"urn:WS_P7Verify",.req)
}

Method WSP7VerifyCapicom(req As dhcserviceclient.CA.GDCA.ax21.P7VerifyReq) As dhcserviceclient.CA.GDCA.ax21.P7VerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7VerifyCapicom").Invoke($this,"urn:WS_P7VerifyCapicom",.req)
}

Method WSP7VerifyPDF(req As dhcserviceclient.CA.GDCA.ax21.P7VerifyReq) As dhcserviceclient.CA.GDCA.ax21.P7VerifyResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_P7VerifyPDF").Invoke($this,"urn:WS_P7VerifyPDF",.req)
}

Method WSSealEnvelope(req As dhcserviceclient.CA.GDCA.ax21.SeEnvelopeReq) As dhcserviceclient.CA.GDCA.ax21.SeEnvelopeResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_SealEnvelope").Invoke($this,"urn:WS_SealEnvelope",.req)
}

Method WSSealTimeStamp(req As dhcserviceclient.CA.GDCA.ax21.SeStampReq) As dhcserviceclient.CA.GDCA.ax21.SeStampResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_SealTimeStamp").Invoke($this,"urn:WS_SealTimeStamp",.req)
}

Method WSSymmDecrypt(req As dhcserviceclient.CA.GDCA.ax21.SymmDecReq) As dhcserviceclient.CA.GDCA.ax21.SymmDecResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_SymmDecrypt").Invoke($this,"urn:WS_SymmDecrypt",.req)
}

Method WSSymmEncrypt(req As dhcserviceclient.CA.GDCA.ax21.SymmEncReq) As dhcserviceclient.CA.GDCA.ax21.SymmEncResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_SymmEncrypt").Invoke($this,"urn:WS_SymmEncrypt",.req)
}

Method WSVerifyTimeStamp(req As dhcserviceclient.CA.GDCA.ax21.VeStampReq) As dhcserviceclient.CA.GDCA.ax21.VeStampResp [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("WS_VerifyTimeStamp").Invoke($this,"urn:WS_VerifyTimeStamp",.req)
}

}
