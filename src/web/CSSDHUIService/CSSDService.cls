/// web.CSSDHUIService.CSSDService
Class web.CSSDHUIService.CSSDService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "CSSDService";

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

/// Description:接口方法
/// Creator:	why
/// CreateDate:	2021-06-22
/// Input:		RequestCode:请求代码, Input:json串
/// w ##class(web.CSSDHUIService.CSSDService).RequestMethod("LogOn","<Request><UserCode>demo</UserCode><UserPassWord>1</UserPassWord></Request>")
/// w ##class(web.CSSDHUIService.CSSDService).RequestMethod("GetPsDetail","<Request><SxNo>202009300002</SxNo><HVFlag>N</HVFlag><needCheck>0</needCheck></Request>")
ClassMethod RequestMethod(RequestCode As %String, Input As %String = "") As %String [ WebMethod ]
{
	s ^TMPCSSD(28,$zdt($h,3,1))=$lb(RequestCode, Input)
	q:RequestCode="" ""
	s Ret=##class(web.CSSDHUIService.CSSDServiceImpl).CSSDService(RequestCode,Input)
	s ^TMPCSSD(28,$zdt($h,3,1),1)=Ret
	q Ret
}

}
