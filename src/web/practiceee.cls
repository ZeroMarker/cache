Class web.practiceee Extends %RegisteredObject
{

/// 方法调用
/// Others：w ##class(web.practiceee).Test(1)
ClassMethod Test(rowid As %String) As %String
{
	s result=##class(web.practiceee).GetStudentInfo(rowid)
	q result
}

}
