Class web.DHCENS.STBLL.BOOKREG.SOAP.PUB0001Soap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.91.1:3388/csp/hsb/DHC.Published.PUB0001.BS.PUB0001.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PUB0001";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method SaveDictInfo(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveDictInfo").Invoke($this,"http://tempuri.org/DHC.Published.PUB0001.BS.PUB0001.SaveDictInfo",.input1,.input2)
}

}
