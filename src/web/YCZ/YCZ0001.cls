Import SQLUser

/// Function:SQL数据操作
/// CreateDate:2023-09-13
/// Creator:俞长志
Class web.YCZ.YCZ0001 Extends %RegisteredObject
{

/// Function:数据新增
/// Output: 1:成功 ,0:失败
/// others: w ##class(web.YCZ.YCZ0001).InsertData("","","","")
ClassMethod InsertData(StCode As %String, StName As %String, StSexDR As %String, StDob As %String) As %String
{
	q:StCode="" "0^学号为空"
	q:StName="" "0^姓名为空"
	q:$d(^User.DHCStudentYCZI("Code",StCode)) "0^学号重复"
	s:StDob'="" StDob=$zdh(StDob,3) //2020-01-01格式
	&SQL(
		INSERT INTO DHC_StudentYCZ (St_Code,St_Name,St_Sex_DR,St_Dob)
		VALUES (:StCode,:StName,:StSexDR,:StDob)
	)
	if (SQLCODE=0)
	{
		s result=1_"^" _%ROWID
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

}
