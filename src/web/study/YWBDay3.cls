Import SQLUser

/// Function:SQL 数据操作
/// CreateDate:2023-09-13
/// Creator:yiwenbo
Class web.study.YWBDay3 Extends %RegisteredObject
{

/// Function:数据新增
/// CreateDate:2023-09-13
/// Creator:yiwenbo
/// Table:DHC_CourseYWB
/// Input:CrsCode,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:w ##class(web.study.YWBDay3).InsertData()
ClassMethod InsertData(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "0^Code为空"
	q:CrsDesc="" "0^Desc为空"
	q:$d(^User.DHCCourseYWBI("Code",CrsCode)) "0^学号重复"
	&sql(
		INSERT INTO DHC_CourseYWB(Crs_Code,Crs_Desc,Crs_ActiveFlag)
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
/// CreateDate:2023-09-13
/// Creator:yiwenbo
/// Table:DHC_CourseYWB
/// Input:CrsRowId,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:w ##class(web.study.YWBDay3).UpdateData(")
ClassMethod UpdateData(CrsRowId As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsRowId="" "0^CrsRowId为空"
	q:'$d(^User.DHCCourseYWBD(CrsRowId)) "0^数据不存在"
	&sql(
		UPDATE DHC_CourseYWB SET Crs_Desc = :CrsDesc,Crs_ActiveFlag = :CrsActiveFlag
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

/// Function:数据查询
/// CreateDate:2023-09-13
/// Creator:yiwenbo
/// Table:DHC_CourseYWB
/// Input:
/// Output:
/// Others:d ##class(web.study.YWBDay3).GetSQLList()
ClassMethod GetSQLList(CrsRowId As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	s sqlstr="SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag FROM DHC_CourseYWB"
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

/// Function:单条数据查询
/// CreateDate:2023-09-13
/// Creator:yiwenbo
/// Table:DHC_CourseYWB
/// Input:CrsRowId
/// Output:
/// Others:d ##class(web.study.YWBDay3).GetSingleData()
ClassMethod GetSingleData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	s CrsCode="",CrsDesc="",CrsActiveFlag=""
	&sql(
		SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag INTO :CrsCode,:CrsDesc,:CrsActiveFlag
        FROM  DHC_CourseYWB    
		WHERE Crs_RowId = :CrsRowId
	)
	if (SQLCODE=0)
	{
		s result=CrsCode_" "_CrsDesc_" "_CrsActiveFlag
	}
	else
	{
		s result="没有查到数据"
	}
	q result
}

/// Function:数据删除
/// CreateDate:2023-09-13
/// Creator:yiwenbo
/// Table:DHC_CourseYWB
/// Input:CrsRowId
/// Output:
/// Others:d ##class(web.study.YWBDay3).DeleteData()
ClassMethod DeleteData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	q:'$d(^User.DHCCourseYWBD(CrsRowId)) "0^数据不存在"
	&sql(
		DELETE FROM DHC_CourseYWB
        WHERE Crs_RowId=:CrsRowId
	)
	if (SQLCODE=0)
	{
		s result="删除成功"
	}
	else
	{
		s result="删除失败^"_%msg
	}
	q result
}

}
