Import SQLCT.YCZ

/// Function:SQL数据操作
/// CreateDate:2023-09-13
/// Creator:俞长志
Class web.YCZ.YCZ0002 Extends %RegisteredObject
{

/// Function:课程数据新增
/// Table: DHC_Course
/// Input: CrsCode:代码,CrsDesc:名称,CrsActive:有效标志
/// Output: 1:成功 ,0:失败
/// others: w ##class(web.YCZ.YCZ0002).InsertData("","","")
ClassMethod InsertData(CrsCode As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	q:CrsCode="" "0^代码为空"
	q:CrsDesc="" "0^名称为空"
	q:$d(^CT.YCZ.DHCCourseI("Code",CrsCode)) "0^代码重复"
	&SQL(
		INSERT INTO CT_YCZ.DHC_Course (Crs_Code,Crs_Desc,Crs_Active) 
		VALUES (:CrsCode,:CrsDesc,:CrsActive)
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

/// Function:修改课程数据
/// CreateDate:2023-09-13
/// Creator:俞长志
/// Table: DHC_Course
/// Input: CrsRowId, CrsDesc:名称, CrsActive:有效标志
/// Output: 1:成功 ,0:失败
/// others: w ##class(web.YCZ.YCZ0002).UpdateData("","","")
ClassMethod UpdateData(CrsRowId As %String, CrsDesc As %String, CrsActive As %String) As %String
{
	q:CrsRowId="" "0^CrsRowId为空"
	q:'$d(^CT.YCZ.DHCCourseD(CrsRowId)) "0^数据不存在"
	&SQL(
		UPDATE CT_YCZ.DHC_Course SET Crs_Desc = :CrsDesc, Crs_Active = :CrsActive 
		WHERE Crs_RowId = :CrsRowId
	)
	if (SQLCODE=0)
	{
		s result=1
	}
	else
	{
		s result =0_"^"_%msg
	}
	q result
}

/// Function: 课程数据查询
/// CreateDate:2023-09-13
/// Creator:俞长志
/// Table: DHC_Course
/// Input: 
/// Output: 
/// others: d ##class(web.YCZ.YCZ0002).GetSQLList()
ClassMethod GetSQLList() As %String
{
	s sqlstr="SELECT Crs_Code, Crs_Desc, Crs_Active FROM CT_YCZ.DHC_Course"
	s rs=##class(%ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(sqlstr)
		d rs.Execute()
		while (rs.Next())
		{
			s CrsCode=$g(rs.Data("Crs_Code"))
			s CrsDesc=$g(rs.Data("Crs_Desc"))
			s CrsActive=$g(rs.Data("Crs_Active"))
			w CrsCode_"  "_CrsDesc_"  "_CrsActive
			w !
		}
	}
}

/// Function: 查询单条课程数据
/// CreateDate:2023-09-13
/// Creator:俞长志
/// Table: DHC_Course
/// Input: CrsRowId
/// Output: CrsCode, CrsDesc, CrsActive
/// others: w ##class(web.YCZ.YCZ0002).GetSingleData()
ClassMethod GetSingleData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	s CrsCode="",CrsDesc="",CrsActive=""
	&SQL(
		SELECT Crs_Code, Crs_Desc, Crs_Active
		INTO :CrsCode,:CrsDesc,:CrsActive
		FROM CT_YCZ.DHC_Course
		WHERE Crs_RowId=:CrsRowId
	)
	if (SQLCODE=0)
	{
		s result = CrsCode_" "_CrsDesc_"  "_CrsActive
	}
	else
	{
		s result="没查到数据"
	}
	q result
}

/// Function: 查询单条课程数据
/// CreateDate:2023-09-13
/// Creator:俞长志
/// Table: DHC_Course
/// Input: CrsRowId
/// Output: CrsCode, CrsDesc, CrsActive
/// others: d ##class(web.YCZ.YCZ0002).GetSingData(3)
ClassMethod GetSingData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	k PLIST
	&SQL(
		SELECT Crs_Code, Crs_Desc, Crs_Active 
		INTO :PLIST()
		FROM CT_YCZ.DHC_Course
		WHERE Crs_RowId=:CrsRowId
	)
	if (SQLCODE=0)
	{
		s count=$O(PLIST(""),-1)
		for i=2:1:count
		{
			w PLIST(i)_" "
		}
	}
	else
	{
		s result="没查到数据"
	}
	// q result
}

/// Function: 课程数据删除
/// CreateDate:2023-09-13
/// Creator:俞长志
/// Table: DHC_Course
/// Input: CrsRowId
/// Output: 
/// others: w ##class(web.YCZ.YCZ0002).DeleteData()
ClassMethod DeleteData(CrsRowId As %String) As %String
{
	q:CrsRowId="" "CrsRowId为空"
	q:'$d(^CT.YCZ.DHCCourseD(CrsRowId)) "0^数据不存在"
	&SQL(
		DELETE FROM CT_YCZ.DHC_Course 
		WHERE Crs_RowId = :CrsRowId
	)
	if (SQLCODE=0)
	{
		s result="删除成功"
	}
	else
	{
		s result="删除失败"
	}
	q result
}

}
