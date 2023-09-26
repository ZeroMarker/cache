/// Function：数据操作
/// CreateDate：2023-09-13
/// Creator:yanghongrui
Class User.DHCCourseY Extends %RegisteredObject
{

/// Function:数据新增
ClassMethod InsertData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StCode="" "0^学号为空"
	q:StName="" "0^姓名为空"
	q:$d(^User.DHCStudentFI("Code",StCode)) "0^学号重复"
	s:StDob'="" StDob=$zdh(StDob,3) //2020-01-01格式
	&SQL(
		INSERT INTO DHC_StudentF(St_Code,St_Name,St_Sex_DR,St_Dob)
		VALUES (:StCode,:StName,:StSexDR,:StDob)
	
	)
	if (SQLCODE=0)
	{
		s result=1 //"^"_%RowId
	}
	else
	{
		s result=0 //"^"_%msg
	}
	b ;
	q result
}

}
