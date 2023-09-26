/// EPRservice.BOSystemService
Class EPRservice.BOSystemService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SystemInfo";

/// TODO: add arguments and implementation.
/// SysDate
ClassMethod SysDate() As %Date [ WebMethod ]
{
	Quit $ZDATEH($ZDATE($HOROLOG))
}

/// TODO: add arguments and implementation.
/// SysTime
ClassMethod SysTime() As %Time [ WebMethod ]
{
	Quit $ZTIMEH($ZTIME($PIECE($HOROLOG,",",2),1))
}

/// add by Candyxu
/// desc:datetime
ClassMethod GetDateTime() As %String [ WebMethod ]
{
	set TDate = $zd($p($h,",",1))
	set TTime = $zt($p($h,",",2))
	q TDate_" "_TTime
}

}
