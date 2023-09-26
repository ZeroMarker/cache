Class dhcserviceclient.CA.SHCATimeStampServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default attributeFormQualified for types XML namespace.
Parameter ATTRIBUTEQUALIFIED = 1;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.20.5.34:38080/services/TimeStampServices";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://webservice.tsp.openapi.sp.custle.com";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "TimeStampServices";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method generateTimestampByHashData(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("generateTimestampByHashData").Invoke($this,"",.in0)
}

Method generateTimestampByInData(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("generateTimestampByInData").Invoke($this,"",.in0)
}

Method getTimeStampInfo(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("getTimeStampInfo").Invoke($this,"",.in0)
}

Method verifyTimeStamp(in0 As %String) As %String(XMLNAME="out") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("verifyTimeStamp").Invoke($this,"",.in0)
}

}
