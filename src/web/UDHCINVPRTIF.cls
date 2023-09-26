Import SQLUser

Class web.UDHCINVPRTIF Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod INVPRT(INVInfo As %String = "", ExpStr As %String = "") As %String
{
	n (INVInfo, ExpStr)
	s rtn=##class(web.UDHCINVPRT).INVPRT(INVInfo)
	q rtn
}

ClassMethod INVPRTCancel(INVPRTRowid As %String, sUser As %String, sFlag As %String, ExpStr As %String = "") As %String
{
	n (INVPRTRowid, sUser, sFlag, ExpStr)
	s rtn=##class(web.UDHCINVPRT).INVPRTCancel(INVPRTRowid, sUser, sFlag)
	q rtn
}

/// w ##class(web.UDHCINVPRTIF).INVPRTPayMode("1368","1^1^100^Cheque1111^1^^^03/07/2006^122222")
ClassMethod INVPRTPayMode(INVRowID As %String, PMInfo As %String = "", ExpStr As %String = "") As %String
{
	n (INVRowID, PMInfo, ExpStr)
	s rtn=##class(web.UDHCINVPRT).INVPRTPayMode(INVRowID, PMInfo)
	q rtn
}

}
