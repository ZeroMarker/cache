Class web.DHCENS.STBLL.DICT.SOAP.PublishedMDMWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://127.0.0.1/csp/hsb/hsb.DhcEns.BS.PublishedMDMWebService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PublishedMDMWebService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method SaveManagerDataInfo(messageCode As %String, inputContent As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveManagerDataInfo").Invoke($this,"http://tempuri.org/hsb.DhcEns.BS.PublishedMDMWebService.SaveManagerDataInfo",.messageCode,.inputContent)
}

Method SavePAPatientInfo(messageCode As %String, inputContent As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SavePAPatientInfo").Invoke($this,"http://tempuri.org/hsb.DhcEns.BS.PublishedMDMWebService.SavePAPatientInfo",.messageCode,.inputContent)
}

}
