Class web.DHCSTMService.FrontECS.ECS2STMService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// 注意高版本使用/imedical/webservice/,同时dhwebservice密码也可能有变化. 比如
/// https://58.56.200.231:1443/imedical/webservice/web.DHCSTMService.FrontECS.ECS2STMService.cls?wsdl=1&CacheUserName=dhwebservice&CachePassword=1wMu21i$9E&CacheNoRedirect=1
/// 
/// Parameter LOCATION = "https://172.18.18.150:1443/imedical/webservice/";
/// 
/// Name of the WebService.
Parameter SERVICENAME = "ECS2STMService";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/dhcstmservice";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

Method ECSService(token As %String, user As %String, pwd As %String, opcode As %String, data As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s ServiceObj=##class(web.DHCSTMService.FrontECS.ServicePort).%New()
	s ServiceObj.Timeout=600
	;2022-12-21 这个地方ecs接口参数顺序有调整, 物资内部改了,改一下这个地方的传值
	s Respone=ServiceObj.ecsService(user,pwd,opcode,data,token)
	q Respone
}

}
