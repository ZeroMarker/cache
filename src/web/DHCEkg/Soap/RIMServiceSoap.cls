Class web.DHCEkg.Soap.RIMServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method HIPMessageServer(action As %String, message As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	//tps证书配置
	s SSLName="SSLECP"
	i $l(SSLName){
		s $this.SSLConfiguration=SSLName
		s $this.SSLCheckServerIdentity=0
	}
 Quit ..WebMethod("HIPMessageServer").Invoke($this,"http://www.dhcc.com.cn/DHC.Published.RIMService.BS.RIMService.HIPMessageServer",.action,.message)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "https://172.19.19.58:1443/csp/hsb/DHC.Published.RIMService.BS.RIMService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "RIMService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
