/// Creator:
/// Desctiptions:移动护管webservice
/// Date:
Class DHCINM.WebService.INMAppServer Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "INMAppServer";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://www.mediway.com.cn";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %GlobalCharacterStream [ WebMethod ]
{
	q ##class(DHCINM.WebService.INMAppCommon).ReturnMsgJson("测试","1")
}

/// 测试：method  param  type
/// APPLoginID：用户id，APPPerID:用户人员档案id。此两个元素必填，在param中
/// 返回值为字符串
/// web.INMLoginComm:GetNursePassword;{"usercode":"demo","password":"1","APPLoginID":"0","APPPerID":"0"};Method
/// 返回值为对象
/// web.INMSetComm:GetModule;{"id":"1","APPLoginID":"0","APPPerID":"0"};RecMethod
/// 数组json
/// web.INMSetComm:FindModuleList;{"parr":"","APPLoginID":"0","APPPerID":"0"};RecQuery
/// 数组jsonQeury
/// web.INMPersonCountComm:FindPubCode;{"type":"职工性质","APPLoginID":"0","APPPerID":"0"};Query
ClassMethod RequestData(method, params, type) As %GlobalCharacterStream [ WebMethod ]
{
	s ^TMPAppNM("RequestData")=$lb(method, params, type)
	q ##class(DHCINM.WebService.INMAppUtilComm).RequestData(method, params, type)
}

}
