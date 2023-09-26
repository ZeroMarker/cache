Class web.DHCENS.STBLL.DICTNew.Soap.HdcWebServiceImplPort Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// Non-default elementFormQualified for types XML namespace.
Parameter ELEMENTQUALIFIED = 0;

/// This is the URL used to access the web service.
Parameter LOCATION = "http://192.168.102.126:9098/hdc/service/ws";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://impl.service.portal.dhcens.com/";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HdcWebServiceImplService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// This is the namespace used for types by the Service
Parameter TYPENAMESPACE = "http://server.mediway.com.cn";

Method hosDocumentRetrieval(messageCode As %String, inputContent As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("hosDocumentRetrieval").Invoke($this,"",.messageCode,.inputContent)
}

Method hosDocumentSearch(messageCode As %String, inputContent As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("hosDocumentSearch").Invoke($this,"",.messageCode,.inputContent)
}

Method mosDocumentRetrieval(messageCode As %String, inputContent As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("mosDocumentRetrieval").Invoke($this,"",.messageCode,.inputContent)
}

Method mosDocumentSearch(messageCode As %String, inputContent As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("mosDocumentSearch").Invoke($this,"",.messageCode,.inputContent)
}

Method saveDictData(messageCode As %String, inputContent As %GlobalCharacterStream) As %GlobalCharacterStream(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveDictData").Invoke($this,"",.messageCode,.inputContent)
}

Method saveHosDocument(messageCode As %String, inputContent As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveHosDocument").Invoke($this,"",.messageCode,.inputContent)
}

Method saveMosDocument(messageCode As %String, inputContent As %String) As %String(XMLNAME="return") [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("saveMosDocument").Invoke($this,"",.messageCode,.inputContent)
}

}
