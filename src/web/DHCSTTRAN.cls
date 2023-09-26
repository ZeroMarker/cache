Class web.DHCSTTRAN Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Begin() As %String
{
	tstart
	q ""
}

ClassMethod Rollback() As %String
{
	trollback 
	q ""
}

ClassMethod Commit() As %String
{
	tcommit
	q ""
}

}
