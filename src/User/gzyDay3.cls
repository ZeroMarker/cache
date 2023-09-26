Import SQLUser

Class User.gzyDay3 Extends %RegisteredObject
{

/// Function:数据查询
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:DHC_Course_GZY
/// Input:
/// Output:
/// Others:d ##class(User.gzyDay3).GetSQLList()
ClassMethod GetSQLList(CrsRowId As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	s sqlstr="SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag FROM DHC_Course_GZY123"
	s rs=##class(%ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(sqlstr)
		d rs.Execute()
		while (rs.Next())
		{
			s CrsCode=$g(rs.Data("Crs_Code"))
			s CrsDesc=$g(rs.Data("Crs_Desc"))
			s CrsActiveFlag=$g(rs.Data("Crs_ActiveFlag"))
			w CrsCode_" "_CrsDesc_" "_CrsActiveFlag
			w !
		}
	}
}

/// Function:数据新增
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:DHC_Course_GZY
/// Input:CrsCode,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:w ##class(User.gzyDay3).InsertData("1","语文","Y")
ClassMethod InsertData(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "0^Code为空"
	q:CrsDesc="" "0^Desc为空"
	q:$d(^User.DHCCourseYWBI("Code",CrsCode)) "0^学号重复"
	&sql(
		INSERT INTO DHC_Course_GZY123(Crs_Code,Crs_Desc,Crs_ActiveFlag)
		VALUES (:CrsCode,:CrsDesc,:CrsActiveFlag)
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

/// Function:数据修改
/// CreateDate:2023-09-15
/// Creator:高泽宇
/// Table:DHC_Course_GZY
/// Input:CrsRowId,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:w ##class(User.gzyDay3).UpdateData("1","数学","Y")
ClassMethod UpdateData(CrsRowId As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsRowId="" "0^CrsRowId为空"
	q:'$d(^User.DHCCourseYWBD(CrsRowId)) "0^数据不存在"
	&sql(
		UPDATE DHC_Course_GZY123 SET Crs_Desc = :CrsDesc,Crs_ActiveFlag = :CrsActiveFlag
		WHERE Crs_RowId = :CrsRowId
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
