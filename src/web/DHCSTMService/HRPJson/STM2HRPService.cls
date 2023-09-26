Class web.DHCSTMService.HRPJson.STM2HRPService Extends %SOAP.WebService [ Not ProcedureBlock ]
{

/// Parameter LOCATION = "https://127.0.0.1/imedical/webservice/";
/// Name of the WebService.
Parameter SERVICENAME = "STM2HRPService";

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/dhcstmservice";

/// Namespaces of referenced classes will be used in the WSDL.
Parameter USECLASSNAMESPACES = 1;

/// 业务单据接口
Method BussinessService(Code As %String, Input, HospCode As %String) As %String [ WebMethod ]
{
	n (Code,Input,HospCode)
	s Ret=##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).Main(Code,Input,HospCode)
	q Ret
}

/// 数据查询接口
Method DataService(Code As %String, Input, HospCode As %String) As %String [ WebMethod ]
{
	n (Code,Input,HospCode)
	s Ret=##class(web.DHCSTMService.HRPJson.STM2HRPServiceImpl).GetData(Code,Input,HospCode)
	q Ret
}

}
