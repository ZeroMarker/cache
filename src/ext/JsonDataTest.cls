Class ext.JsonDataTest Extends %CSP.Page
{

ClassMethod OnPage() As %Status
{
	;w "Josn Data<br>"
	;i %session.New
	s %session.Data("LOGON.GROUPID")=1
	s %session.Data("LOGON.LANGID")=20
	;w ##Class(ext.websys.Menu).GetMainMenuJosn()
	;Quit $$$OK
	w ##class(ext.websys.Menu).ShowToolBarJosn(1073)
	
	Quit $$$OK
}

/// Specifies the default character set for the page.  This can be overriden using the
/// &lt;CSP:CONTENT CHARSET=&gt; tag, or by setting the <b>%response</b>.CharSet property
/// in the <method>OnPreHTTP</method> method.  If this parameter is not specified, then
/// for Unicode systems the default charset is utf-8 and for 8-bit systems it is the
/// system default charset.
Parameter CHARSET = "GB18030";

}
