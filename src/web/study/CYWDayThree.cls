Import SQLUser

/// Function:SQL 数据操作
/// CreateDate:2023-09-14
/// Creator:蔡耀伟
Class web.study.CYWDayThree Extends %RegisteredObject
{

/// Function:数据新增
/// CreateDate:2023-09-14
/// Creator:蔡耀伟
/// Table:DHC_CourseCYW
/// Input:CrsCode,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:w ##class(web.study.CYWDayThree).InsertData()
ClassMethod InsertData(CrsCode As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsCode="" "0^Code为空"
	q:CrsDesc="" "0^Desc为空"
	q:$d(^User.DHCCourseCYWI("Code",CrsCode)) "0^学号重复"
	&sql(
		INSERT INTO DHC_CourseCYW(Crs_Code,Crs_Desc,Crs_ActiveFlag)
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
/// CreateDate:2023-09-14
/// Creator:caiyaowei
/// Table:DHC_CourseCYW
/// Input:CrsRowId,CrsDesc,CrsActiveFlag
/// Output:1: 成功,0:失败
/// Others:w ##class(web.study.CYWDayThree).UpdateData()
ClassMethod UpdateData(CrsRowId As %String, CrsDesc As %String, CrsActiveFlag As %String) As %String
{
	q:CrsRowId="" "0^CrsRowId为空"
	q:'$d(^User.DHCCourseCYWD(CrsRowId)) "0^数据不存在"
	&sql(
		UPDATE DHC_CourseCYW SET Crs_Desc = :CrsDesc,Crs_ActiveFlag = :CrsActiveFlag
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
/// CreateDate:2023-09-14
/// Creator:蔡耀伟
/// Table:DHC_CourseCYW
/// Input:
/// Output:
/// Others:d ##class(web.study.CYWDayThree).GetSQLList()
ClassMethod GetSQLList() As %String
{
	s sqlstr="SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag FROM DHC_CourseCYW"
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
/// CreateDate:2023-09-14
/// Creator:caiyaowei
/// Table:DHC_CourseCYW
/// Input:CrsRowId
/// Output:
/// Others:d ##class(web.study.CYWDayThree).GetSingleData()
ClassMethod GetSingleData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	s CrsCode="",CrsDesc="",CrsActiveFlag=""
	&sql(
		SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag INTO :CrsCode,:CrsDesc,:CrsActiveFlag
        FROM  DHC_CourseCYW    
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
/// CreateDate:2023-09-14
/// Creator:蔡耀伟
/// Table:DHC_CourseCYW
/// Input:CrsRowId
/// Output:
/// Others:d ##class(web.study.CYWDayThree).DeleteData()
ClassMethod DeleteData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	q:'$d(^User.DHCCourseCYWD(CrsRowId)) "0^数据不存在"
	&sql(
		DELETE FROM DHC_CourseCYW
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
