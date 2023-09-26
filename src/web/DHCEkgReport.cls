Class web.DHCEkgReport Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

// 查询历史检查测值

ClassMethod GetReportStatusDesc(Code As %String) As %String
{
	s Desc="" 
	s rowid=$o(^DHCRBCStatusi("RCode",Code,0))
	i rowid'="" s Desc=$p(^DHCRBCStatus("ReportStatus",rowid),"^",2) 
	q Desc
}

ClassMethod GetReportStatusDR(Code As %String) As %String
{
	s rowid=$o(^DHCRBCStatusi("RCode",Code,0))
	q rowid
}

}
