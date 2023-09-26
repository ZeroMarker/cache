Class web.DHCENS.STBLL.DICTNew.Soap.PUB0001Soap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.19.19.100/csp/mdm/DHC.Published.PUB0001.BS.PUB0001.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "PUB0001";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method AcceptDicInfo(input1 As %String, input2 As %GlobalCharacterStream) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("AcceptDicInfo").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.PUB0001.BS.PUB0001.AcceptDicInfo",.input1,.input2)
}

}
