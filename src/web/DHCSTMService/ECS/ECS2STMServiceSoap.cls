Class web.DHCSTMService.ECS.ECS2STMServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

/// ps: 这里要注意8.5的webservice路径,和http/https版本区分
/// This is the URL used to access the web service.
/// Parameter LOCATION = "https://172.18.18.150:1443/imedical/webservice/web.DHCSTMService.FrontECS.ECS2STMService.cls";
Parameter LOCATION = "http://localhost:57772/imedical/web/web.DHCSTMService.FrontECS.ECS2STMService.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.dhcc.com.cn/dhcstmservice";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "ECS2STMService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

/// Overrides default handling of string arguments.
Parameter XMLIGNORENULL = 1;

Method ECSService(token As %String, user As %String, pwd As %String, opcode As %String, data As %String) As %GlobalCharacterStream [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
	d ..WSSecurityLogin("dhwebservice","dhwebservice")
	s $this.SSLConfiguration="SSLECP"
	s $this.SSLCheckServerIdentity=0
	Quit ..WebMethod("ECSService").Invoke($this,"http://www.dhcc.com.cn/dhcstmservice/web.DHCSTMService.FrontECS.ECS2STMService.ECSService",.token,.user,.pwd,.opcode,.data)
}

}
