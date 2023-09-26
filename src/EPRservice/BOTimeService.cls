/// EPRservice.BOTimeService
Class EPRservice.BOTimeService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "TimeService";

/// TODO: add arguments and implementation.
ClassMethod GetServerDay() As %String [ WebMethod ]
{
	Quit $ZDATE($HOROLOG,3)
}

ClassMethod GetServerTime() As %String [ WebMethod ]
{
	Quit $ZTIME($PIECE($HOROLOG,",",2),1)
}

/// the methods below are only for test by gjb 2007-12-27
ClassMethod GetInt(argInt As %Integer) As %Integer [ WebMethod ]
{
	q argInt*3
}

ClassMethod GetBool(argInt As %Integer) As %Boolean [ WebMethod ]
{
	q:(argInt>3) 1
	q 0
}

ClassMethod GetVoid(argString As %String) [ WebMethod ]
{
	s ^gjbtest("void")=argString
}

}
