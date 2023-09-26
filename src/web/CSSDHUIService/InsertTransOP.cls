/// Descript:第三方手术清点调用接口
/// Creater:why
/// CreateDate: 2021-05-10
Class web.CSSDHUIService.InsertTransOP Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

// Parameter LOCATION = "http://127.0.0.1/imedical/web/";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// WebService 的名称.
Parameter SERVICENAME = "InsertTransOP";

/// TODO:将此更改为实际 SOAP 命名空间.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 命名空间 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// Descript: 第三方手术清点调用接口
/// Creater:    why
/// CreateDate: 2021-05-10
/// Input: Json串
/// Output: 
/// Return：
Method InsertTransOp(Main As %String) As %String [ WebMethod ]
{
    New (Main)
    Set ret=##class(web.CSSDHUI.Interface.CSSDTransOP).InsertTransOp(Main)
    Quit ret
}

}
