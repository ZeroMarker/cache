Class web.DHCENS.STBLL.LIS.SOAP.PUB0008Soap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.91.2/csp/hsb/DHC.Published.PUB0008.BS.PUB0008.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PUB0008";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method GetAmountOfTube(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("GetAmountOfTube").Invoke($this,"http://tempuri.org/DHC.Published.PUB0008.BS.PUB0008.GetAmountOfTube",.input1,.input2)
}

Method SendLISOrder(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SendLISOrder").Invoke($this,"http://tempuri.org/DHC.Published.PUB0008.BS.PUB0008.SendLISOrder",.input1,.input2)
}

}
