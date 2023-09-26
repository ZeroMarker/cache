/// DHCHAI.IO.AppService
Class DHCHAI.IO.AppService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "AppService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// TODO:添加自变量和实施.
/// Test
Method Test() As %String [ WebMethod ]
{
	Quit "Test"
}

/// TODO:查询院区科室病区数据.
/// hospIds :1|2  不可以为空,locType E W 科室病区,start 当前开始序号,limit 返回记录数
/// QueryDepts
Method QueryDepts(aHospIDs As %String, aLocType As %String, start As %String, limit As %String) As %String [ WebMethod ]
{
	
	s jsonStr=##class(DHCHAI.BTS.LocationSrv).QueryDepts(aHospIDs,aLocType, start,limit)
	
	Quit jsonStr
}

/// TODO:查询院区科室病区用户数据.
/// QueryDepts
Method QueryUsers(hospId As %String, locId As %String) As %String [ WebMethod ]
{
	Set jsonStr = ##class(DHCHAI.BTS.SysUserSrv).QueryUsers(hospId, locId)
	Quit jsonStr
}

/// TODO:查询Query数据方法.
/// 类名
/// QueryDepts
Method QueryExec(aClassName As %String, aQueryName As %String, aArgCnt As %String, aArgStr As %String) As %String [ WebMethod ]
{
	s aClassName = $g(aClassName)
	s aQueryName = $g(aQueryName)	
	s aArgCnt = $g(aArgCnt)
	s aArgStr = $g(aArgStr)
	s ^DHCHAICJBAPP(aClassName,aQueryName,aArgCnt)=aArgStr
	s rstStr=##class(DHCHAI.IO.AppServiceImpl).QueryExecImpl(aClassName,aQueryName, aArgCnt,aArgStr)
	
	Quit rstStr
}

/// TODO:查询Query数据方法.
/// 类名
/// QueryDepts
Method MethodExec(aClassName As %String, aQueryName As %String, aArgCnt As %String, aArgStr As %String) As %String [ WebMethod ]
{
	s aClassName = $g(aClassName)
	s aQueryName = $g(aQueryName)	
	s aArgCnt = $g(aArgCnt)
	s aArgStr = $g(aArgStr)
	s ^DHCHAICJBAPP(aClassName,aQueryName,aArgCnt)=aArgStr
	s rstStr=##class(DHCHAI.IO.AppServiceImpl).QueryMethodImpl(aClassName,aQueryName, aArgCnt,aArgStr)
	
	Quit rstStr
}

}
