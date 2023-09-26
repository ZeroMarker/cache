/// SQL数据操作
Class User.HXRstudy3 Extends %RegisteredObject
{

/// 查询
/// 黄欣然
/// others:w ##class(User.HXRstudy3).GetSQLList()
ClassMethod GetSQLList() As %String
{
	s StrSql ="SELECT Crs_code,Crs_Desc,Crs_ActiveFlag FROM DHC_courseHXRR"
	s rs = ##class(%Library.ResultSet).%New()
	if (rs)
	{
		d rs.Prepare(StrSql)
		d rs.Execute()
		while(rs.Next())
		{
			s Crscode = $g(rs.Data("Crs_code"))
			s CrsDesc = $g(rs.Data("Crs_Desc"))
			s CrsActiveFlag = $g(rs.Data("Crs_ActiveFlag"))
			w Crscode_""_CrsDesc_""_CrsActiveFlag,!
		}
		q ""
   }
}

/// 删除
/// 黄欣然
/// Debug:w ##class(User.HXRstudy3).DeleteCourse(1)
ClassMethod DeleteCourse(CrsRowID As %String) As %String
{
	s result=""
    q:CrsRowID="" "^CrsRowID不能为空"
    &SQL(DELETE FROM DHC_courseHXRR WHERE Crs_RowID = :CrsRowID)

    If (SQLCODE=0){Set result = "^删除成功"}
    Else {s result ="^删除失败"_%msg}

    q result
}

}
