Class dhcserviceclient.CA.XJCATimeStampServiceSoap Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.16.60.23:8088/webservice";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.tss.org/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "ServiceSoapImplService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method Base64Decode(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %xsd.base64Binary(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Base64Decode").Invoke($this,"http://tempuri.tss.org/Base64Decode",.appName,.inData)
}

Method Base64Encode(appName As %String(ELEMENTQUALIFIED=1), inData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Base64Encode").Invoke($this,"http://tempuri.tss.org/Base64Encode",.appName,.inData)
}

Method CreateTS(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTS").Invoke($this,"http://tempuri.tss.org/CreateTS",.appName,.inData)
}

Method CreateTSByOriginalData(appName As %String(ELEMENTQUALIFIED=1), inData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTSByOriginalData").Invoke($this,"http://tempuri.tss.org/CreateTSByOriginalData",.appName,.inData)
}

Method CreateTSByOriginalData1(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTSByOriginalData1").Invoke($this,"http://tempuri.tss.org/CreateTSByOriginalData1",.appName,.inData)
}

Method CreateTSRequest(appName As %String(ELEMENTQUALIFIED=1), inData As %xsd.base64Binary(ELEMENTQUALIFIED=1), isAttachCert As %Boolean(ELEMENTQUALIFIED=1,REQUIRED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTSRequest").Invoke($this,"http://tempuri.tss.org/CreateTSRequest",.appName,.inData,.isAttachCert)
}

Method CreateTimeStamp(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStamp").Invoke($this,"http://tempuri.tss.org/CreateTimeStamp",.appName,.inData)
}

Method CreateTimeStampNoCert(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampNoCert").Invoke($this,"http://tempuri.tss.org/CreateTimeStampNoCert",.appName,.inData)
}

Method CreateTimeStampRequest(appName As %String(ELEMENTQUALIFIED=1), inData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampRequest").Invoke($this,"http://tempuri.tss.org/CreateTimeStampRequest",.appName,.inData)
}

Method CreateTimeStampRequest1(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("CreateTimeStampRequest1").Invoke($this,"http://tempuri.tss.org/CreateTimeStampRequest1",.appName,.inData)
}

Method GetCert(appName As %String(ELEMENTQUALIFIED=1), sn As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetCert").Invoke($this,"http://tempuri.tss.org/GetCert",.appName,.sn)
}

Method GetServerCertificate(appName As %String(ELEMENTQUALIFIED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetServerCertificate").Invoke($this,"http://tempuri.tss.org/GetServerCertificate",.appName)
}

Method GetTSInfo(appName As %String(ELEMENTQUALIFIED=1), timeStamp As %String(ELEMENTQUALIFIED=1), type As %xsd.int(ELEMENTQUALIFIED=1,REQUIRED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetTSInfo").Invoke($this,"http://tempuri.tss.org/GetTSInfo",.appName,.timeStamp,.type)
}

Method GetTimeStampInfo(appName As %String(ELEMENTQUALIFIED=1), tsResponseData As %String(ELEMENTQUALIFIED=1), type As %xsd.int(ELEMENTQUALIFIED=1,REQUIRED=1)) As %String(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetTimeStampInfo").Invoke($this,"http://tempuri.tss.org/GetTimeStampInfo",.appName,.tsResponseData,.type)
}

Method VerifyTS(appName As %String(ELEMENTQUALIFIED=1), timeStamp As %String(ELEMENTQUALIFIED=1), originalData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %xsd.int(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTS").Invoke($this,"http://tempuri.tss.org/VerifyTS",.appName,.timeStamp,.originalData)
}

Method VerifyTSByCert(appName As %String(ELEMENTQUALIFIED=1), timeStamp As %String(ELEMENTQUALIFIED=1), cert As %String(ELEMENTQUALIFIED=1), originalData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %xsd.int(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTSByCert").Invoke($this,"http://tempuri.tss.org/VerifyTSByCert",.appName,.timeStamp,.cert,.originalData)
}

Method VerifyTimeStamp(appName As %String(ELEMENTQUALIFIED=1), inData As %String(ELEMENTQUALIFIED=1)) As %Boolean(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp").Invoke($this,"http://tempuri.tss.org/VerifyTimeStamp",.appName,.inData)
}

Method VerifyTimeStamp1(appName As %String(ELEMENTQUALIFIED=1), timeStamp As %String(ELEMENTQUALIFIED=1), originalData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %xsd.int(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStamp1").Invoke($this,"http://tempuri.tss.org/VerifyTimeStamp1",.appName,.timeStamp,.originalData)
}

Method VerifyTimeStampByCert(appName As %String(ELEMENTQUALIFIED=1), timeStamp As %String(ELEMENTQUALIFIED=1), cert As %String(ELEMENTQUALIFIED=1)) As %Boolean(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStampByCert").Invoke($this,"http://tempuri.tss.org/VerifyTimeStampByCert",.appName,.timeStamp,.cert)
}

Method VerifyTimeStampByCert1(appName As %String(ELEMENTQUALIFIED=1), timeStamp As %String(ELEMENTQUALIFIED=1), cert As %String(ELEMENTQUALIFIED=1), originalData As %xsd.base64Binary(ELEMENTQUALIFIED=1)) As %xsd.int(ELEMENTQUALIFIED=1,XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("VerifyTimeStampByCert1").Invoke($this,"http://tempuri.tss.org/VerifyTimeStampByCert1",.appName,.timeStamp,.cert,.originalData)
}

}
