Class web.DHCENS.STBLL.DOCU.SOAP.PUB0007Soap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.91.2/csp/hsb/DHC.Published.PUB0007.BS.PUB0007.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PUB0007";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method HIPMessageServer(input1 As %String, input2 As %String) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://tempuri.org/DHC.Published.PUB0007.BS.PUB0007.HIPMessageServer",.input1,.input2)
}

Method HOSDocumentRetrieval(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HOSDocumentRetrieval").Invoke($this,"http://tempuri.org/DHC.Published.PUB0007.BS.PUB0007.HOSDocumentRetrieval",.input1,.input2)
}

Method HOSDocumentSearch(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HOSDocumentSearch").Invoke($this,"http://tempuri.org/DHC.Published.PUB0007.BS.PUB0007.HOSDocumentSearch",.input1,.input2)
}

Method SaveHOSDocumentInfo(input1 As %String, input2 As %String) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveHOSDocumentInfo").Invoke($this,"http://tempuri.org/DHC.Published.PUB0007.BS.PUB0007.SaveHOSDocumentInfo",.input1,.input2)
}

}
