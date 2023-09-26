Import SQLUser

/// Function:增删改查
/// CreateDate:2023-09-13
/// Creator:zhangyizhu
Class web.study.ZyzThirdWork Extends %RegisteredObject
{

/// Fucntion:数据新增
/// CreateDate:2023-09-13
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:Code：课程代码,Desc：课程名称,Active：有效性
/// Output: 1：成功,0：失败
/// Others: w ##class(web.study.ZyzThirdWork).AddInfo()
ClassMethod AddInfo(Code As %String, Desc As %String, Active As %String) As %String
{
	q:Code="" "课程代码为空"
	q:Desc="" "课程名称为空"
	q:$d(^User.DHCZYZCourseI("Code",Code)) "课程代码已存在"
	&SQL(
		INSERT INTO DHCZYZ_Course(Crs_Code,Crs_Desc,Crs_Active) 
		VALUES (:Code,:Desc,:Active)
	 )
	if (SQLCODE=0)
	{
		s result=1_"^"_%ROWID
	}
	else
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Fucntion:数据修改
/// CreateDate:2023-09-13
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:RowId:ID,Code：课程代码,Desc：课程名称,Active：有效性
/// Output: 1：成功,0：失败
/// Others: w ##class(web.study.ZyzThirdWork).UpdateInfo()
ClassMethod UpdateInfo(RowId As %String, Code As %String, Desc As %String, Active As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$d(^User.DHCZYZCourseD(RowId)) "数据不存在"
	&SQL(
		UPDATE DHCZYZ_Course SET Crs_Code=:Code, Crs_Desc=:Desc, Crs_Active=:Active WHERE Crs_RowId=:RowId	
	)
	if (SQLCODE=0)
	{
		
		s result=1	
	} 
	else 
	{
		s result=0_"^"_%msg
	}
	q result
}

/// Fucntion:数据查询
/// CreateDate:2023-09-13
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:
/// Output: 课程信息
/// Others: d ##class(web.study.ZyzThirdWork).GetInfo()
ClassMethod GetInfo(RowId As %String, Code As %String, Desc As %String, Active As %String) As %String
{
	s StrSql="SELECT Crs_Code, Crs_Desc, Crs_Active FROM DHCZYZ_Course"
	s rs=##class(%ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(StrSql)
		d rs.Execute()
		while (rs.Next())
		{
			s CrsCode=$g(rs.Data("Crs_Code"))
			s CrsDesc=$g(rs.Data("Crs_Desc"))
			s CrsActive=$g(rs.Data("Crs_Active"))
			w CrsCode_" "_CrsDesc_" "_CrsActive
			w !
		}
	}
}

/// Fucntion:数据删除
/// CreateDate:2023-09-13
/// Creator:zhangyizhu
/// Table:DHCZYZ_Course
/// Input:RowId:ID
/// Output: 1：成功,0：失败
/// Others: w ##class(web.study.ZyzThirdWork).DeleteInfo()
ClassMethod DeleteInfo(RowId As %String) As %String
{
	q:RowId="" "RowId为空"
	q:'$d(^User.DHCZYZCourseD(RowId)) "数据不存在"
	&SQL(
		DELETE FROM DHCZYZ_Course WHERE Crs_RowId=:RowId	
	)
	if (SQLCODE=0)
	{
		
		s result=1	
	} 
	else 
	{
		s result=0_"^"_%msg
	}
	q result
}

}
