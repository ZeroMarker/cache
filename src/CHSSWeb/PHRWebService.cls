/// 个人档案 web service
/// CHSSWeb.PHRWebService
Class CHSSWeb.PHRWebService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "PHRWebService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://localhost/trakcarelivess/trak/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CHSSWeb/PHRWebService";

/// TODO: add arguments and implementation.
/// Test
ClassMethod Test() As %String [ WebMethod ]
{
	Quit "Test"
}

ClassMethod PersonSearchSql(communityCode As %String, start As %Integer, limit As %Integer, sort As %String, whereStr As %String) As %String [ WebMethod ]
{
	;s ^tempPerson = whereStr
	s rtn=##class(CHSSWeb.PHRSearchService).PersonSearchSqlForBrowser(start, limit, sort, whereStr)
	
	Quit rtn
}

}
