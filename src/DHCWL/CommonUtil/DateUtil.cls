Class DHCWL.CommonUtil.DateUtil Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(64253) 
ClassMethod DateLogicalToHtml(h As %String) As %String
{
	n (h)
	q:$g(h)="" ""
	s $ZT="ErrL2H"
	s ret=""
	s excStr="s ret=##class(websys.Conversions).DateLogicalToHtml(h)"
	x excStr
	//w !,excStr
	if $g(ret)="" || ($g(ret)="ERROR!") {
		s ret=$zd(h,3)
	}
	q ret
	
ErrL2H
	Q $zd(h,3)
}

/// w ##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical("2016-12-1")
ClassMethod DateHtmlToLogical(d As %String) As %String
{
	n (d)
	q:$g(d)="" ""
	s $ZT="ErrH2L"
	s ret=""
	s excStr="s ret=##class(websys.Conversions).DateHtmlToLogical(d)"
	x excStr
	
	if $g(ret)="" || ($g(ret)="ERROR!") {
		s ret=$zdh(d,3)
	}
	q ret
	
ErrH2L
	Q ""
}

}
