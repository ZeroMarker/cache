Class web.DHCENS.STBLL.EMPI.SOAP.GMDM.PublishedWebServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://114.251.193.158:57773/csp/gmdm/DHCENSLib.Service.Published.PublishedWebService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PublishedWebService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method SaveManagerDataInfo(input1 As %String, input2 As %GlobalCharacterStream) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveManagerDataInfo").Invoke($this,"http://tempuri.org/DHCENSLib.Service.Published.PublishedWebService.SaveManagerDataInfo",.input1,.input2)
}

}
