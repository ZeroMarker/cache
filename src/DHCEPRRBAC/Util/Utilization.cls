Class DHCEPRRBAC.Util.Utilization Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetEPRActionDesc(AEPRActionCode As %String) As %String
{
	q:((AEPRActionCode = "") || (AEPRActionCode = $c(0))) ""
	q:(AEPRActionCode = "FS") "病案归档"
	q:(AEPRActionCode = "FSPS") "病案归档扫描"
	q ""
}

ClassMethod GetStatusDesc(AStatusCode As %String) As %String
{
	q:((AStatusCode = "") || (AStatusCode = $c(0))) ""
	q:(AStatusCode = "N") "未授权"
	q:(AStatusCode = "F") "已授权"
	q:(AStatusCode = "R") "已拒绝"
	q:(AStatusCode = "D") "默认角色"
	q:(AStatusCode = "I") "已授权但过期"
	q ""
}

ClassMethod TrimEnter(AInput As %String) As %String
{
	s ret = $TR(AInput,$C(13),"")
	s ret = $TR(ret,$C(10),"")
	s ret = $TR(ret,$C(0),"")
	q ret
}

ClassMethod TrimBlankSpace(AInput As %String) As %String
{
	s ret = $TR(AInput," ","")
	q ret
}

/// Desc: 日期内部格式转换
/// Debug: w ##class(DHCEPRRBAC.Util.Utilization).FormatLogicalDate("2022-06-24")
ClassMethod FormatLogicalDate(ADateStr As %String) As %String
{
	s ret = "" 
	q:(ADateStr = "") ret
	s $zt = "FormatLogicalDateErr"
	s ret = ##class(websys.Conversions).DateHtmlToLogical(ADateStr)
	q ret
FormatLogicalDateErr
	s ret = ..DateHtmlToLogical(ADateStr)
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.Util.Utilization).DateHtmlToLogical("2022-06-24")
ClassMethod DateHtmlToLogical(ADateStr As %String) As %String
{
	s ret = ""
	q:(ADateStr = "") ret
	s:(ADateStr["-") ret = $zdh(ADateStr,3)
	s:(ADateStr["/") ret = $zdh(ADateStr,4)
	q ret
}

/// Desc: 日期显示格式转换
/// Debug: w ##class(DHCEPRRBAC.Util.Utilization).FormatDisplayDate("66284")
ClassMethod FormatDisplayDate(ADateStr As %String) As %String
{
	s ret = "" 
	q:(ADateStr = "") ret
	s $zt = "FormatDisplayDateErr"
	s ret = ##class(websys.Conversions).DateLogicalToHtml(ADateStr)
	q ret
FormatDisplayDateErr
	s ret = ..DateLogicalToHtml(ADateStr)
	q ret
}

/// Debug: w ##class(DHCEPRRBAC.Util.Utilization).DateLogicalToHtml("66284")
ClassMethod DateLogicalToHtml(ADateStr As %String) As %String
{
	s ret = ""
	q:(ADateStr = "") ret
	s dateFormat = ##class(websys.Conversions).DateFormat()
	s ret = $zd(ADateStr,dateFormat)
	q ret
}

}
