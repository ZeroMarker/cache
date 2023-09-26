Class User.Study.ZyzSecondWork Extends %RegisteredObject
{

/// Fuction:根据Code获取信息（索引）
/// CreateDate:2023-09-12
/// Creator:zhangyizhu
/// Table:DHCZYZT_Student
/// Input:Code
/// Output:学生信息
/// Others:w ##class(User.Study.ZyzSecondWork).GetInfo()
ClassMethod GetInfo(Code As %String) As %String
{
		q:Code="" "Code为空"
		if ($d(^DHCZYZTStudent(0,"Code",Code)))
		{
			s RowId=$o(^DHCZYZTStudent(0,"Code",Code,0))
			q:RowId="" ""
			s StInfo=$g(^DHCZYZTStudent(RowId))
			s StName=$p(StInfo,"^",2) //姓名
			s StSex=$p(StInfo,"^",3)  
			s:StSex'="" StSex=$p($g(^CT("SEX", StSex)),"^",2) //性别
			s StDob=$p(StInfo,"^",4)
			s:StDob'="" StDob=$zdate(StDob, 3) //出生日期
		}
		q "姓名"_StName_";性别"_StSex_";出生日期"_StDob
}

/// Funciton:全遍历查询学生表信息
/// CreateDate:2023-09-12
/// Creator:zhangyizhu
/// Table:DHCZYZT_Student
/// Input:Code
/// Output:学生信息
/// Others:w ##class(User.Study.ZyzSecondWork).GetInfoByCode()
ClassMethod GetInfoByCode(Code As %String) As %String
{
	q:Code="" "Code为空"
	s count=0
	s StRowId=0
	s result=""
	for
	{
		s StRowId = $o(^DHCZYZTStudent(StRowId))
		q:StRowId=""
		s count=count+1
		s StInfo=$g(^DHCZYZTStudent(StRowId))
		s StCode=$p(StInfo,"^",1) 
		if (StCode=Code)
		{
			s StName=$p(StInfo,"^",2) //姓名
			s StSex=$p(StInfo,"^",3)  
			s:StSex'="" StSex=$p($g(^CT("SEX", StSex)),"^",2) //性别
			s StDob=$p(StInfo,"^",4)
			s:StDob'="" StDob=$zdate(StDob, 3) //出生日期
			s result="姓名"_StName_";性别"_StSex_";出生日期"_StDob
		}
		
	}
	q result_";次数"_count
}

}
