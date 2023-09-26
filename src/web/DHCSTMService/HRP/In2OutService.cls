/// web.DHCSTMService.HRP.Out2InService
Class web.DHCSTMService.HRP.In2OutService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// 备注: 标准版发布,不使用LOCATION属性
/// Parameter LOCATION = "http://10.188.0.38/imedical/web/";
/// WebService 的名称.
Parameter SERVICENAME = "DHCSTMHRPService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://www.dhcc.com.cn/dhcstmservice";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// Descript: 与HRP交互接口
/// Creater:   lihui
/// CreateDate: 20191223
/// Input:		OperateCode(业务类型：), Input(XML对象流)
/// Output: 
/// Return:		[0:"",1:失败信息]
Method HRPinterface(OperateCode As %String, Input, HospitalCode) As %GlobalCharacterStream [ WebMethod ]
{
	s Ret=##class(%GlobalCharacterStream).%New()
	s Ret=##class(web.DHCSTMService.HRP.In2OutServiceImpl).HRPinterface(OperateCode,Input,HospitalCode)
	q Ret
}

}
