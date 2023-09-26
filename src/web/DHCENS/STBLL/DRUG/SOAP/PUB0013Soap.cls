Class web.DHCENS.STBLL.DRUG.SOAP.PUB0013Soap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.91.2/csp/hsb/DHC.Published.PUB0013.BS.PUB0013.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// This is the name of the Service
Parameter SERVICENAME = "PUB0013";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method recieveStockAddress(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("recieveStockAddress").Invoke($this,"http://tempuri.org/DHC.Published.PUB0013.BS.PUB0013.recieveStockAddress",.input1,.input2)
}

Method recieveIPDrugInfo(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("recieveIPDrugInfo").Invoke($this,"http://tempuri.org/DHC.Published.PUB0013.BS.PUB0013.recieveIPDrugInfo",.input1,.input2)
}

Method sendDocImageInfo(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("sendDocImageInfo").Invoke($this,"http://tempuri.org/DHC.Published.PUB0013.BS.PUB0013.sendDocImageInfo",.input1,.input2)
}

}
