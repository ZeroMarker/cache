Class web.UDHCOPConvert Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 34;

ClassMethod DateHTMLStrToDate(StrDate As %String) As %String [ Final ]
{
	///w ##class(web.UDHCOPConvert).DateHTMLStrToDate("")
	///2005-12-08  ->  08/12/2005
	q:StrDate="" ##class(websys.Conversions).DateLogicalToHtml(+$h)
	
	s mydate=##class(websys.Conversions).DateHtmlToLogical(StrDate)
	s mydate=##class(websys.Conversions).DateLogicalToHtml(mydate)
	q mydate
}

ClassMethod DateLogToStrDate(LogDate As %String) As %String [ Final ]
{
	;w ##class(web.UDHCOPConvert).DateHTMLStrToDate("")
	;28/12/2005->2005-12-08
	q:LogDate="" ##class(websys.Conversions).DateLogicalToHtml(+$h)
	;i (LogDate["/") d
	s mydate=##class(websys.Conversions).DateHtmlToLogical(LogDate)
	s mydate=##class(websys.Conversions).DateLogicalToHtml(mydate)
	q mydate
}

ClassMethod LogicStrDateToDec(StrDate As %String) As %String [ Final ]
{
	///w ##class(web.UDHCOPConvert).LogicStrDateToDec("")
	///200
	q:StrDate="" +$H
	
	set mydate=##class(websys.Conversions).DateHtmlToLogical(StrDate)
	q mydate
}

}
