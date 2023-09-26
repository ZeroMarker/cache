Class web.DHCENS.STBLL.RIS.SOAP.HISServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// This is the URL used to access the web service.
Parameter LOCATION = "https://172.19.19.58:1443/csp/hsb/DHC.Published.HISService.BS.HISService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "HISService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

Method HIPMessageServer(action As %Stream.GlobalCharacter, message As %Stream.GlobalCharacter) As %Stream.GlobalCharacter [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	s $this.SSLConfiguration="SSLECP"
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.HISService.BS.HISService.HIPMessageServer",.action,.message)
}

}
