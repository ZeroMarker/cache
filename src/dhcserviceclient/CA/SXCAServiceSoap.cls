Class dhcserviceclient.CA.SXCAServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "http://10.1.131.7/csp/hsb/DHC.Published.PUB00010.BS.PUB00010.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "PUB00010";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method HIPMessageServer(input1 As %String, input2 As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://tempuri.org/DHC.Published.PUB00010.BS.PUB00010.HIPMessageServer",.input1,.input2)
}

}
