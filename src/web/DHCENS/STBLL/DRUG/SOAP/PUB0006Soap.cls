Class web.DHCENS.STBLL.DRUG.SOAP.PUB0006Soap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.18.18.113/csp/hsb/DHC.Published.PUB0006.BS.PUB0006.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "PUB0006";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method HIPMessageServer(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.PUB0006.BS.PUB0006.HIPMessageServer",.input1,.input2)
}

}
