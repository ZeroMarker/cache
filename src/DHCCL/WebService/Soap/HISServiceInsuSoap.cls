Class DHCCL.WebService.Soap.HISServiceInsuSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "https://172.18.18.218:1443/csp/hsb/DHC.Published.HISServiceInsu.BS.HISServiceInsu.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HISServiceInsu";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method HIPMessageServer(input1 As %String, input2 As %Stream.GlobalCharacter) As %Stream.GlobalCharacter [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	set $this.SSLConfiguration="SSLECP"
	set $this.SSLCheckServerIdentity="0"
 	Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.HISServiceInsu.BS.HISServiceInsu.HIPMessageServer",.input1,.input2)
}

}
