Class User.HXRstudy31 Extends %RegisteredObject
{

/// 查询
/// 黄欣然
/// others:w ##class(User.HXRstudy3).GetSQLList()
ClassMethod GetSQLList() As %String
{
	q:CrsRowID="" "^CrsRowID不能为空"
	s StrSql ="SELECT Crs_Code,Crs_Desc,Crs_ActiveFlag FROM DHC_courseHXRR"
	s rs = ##class(%Library.ResultSet).%New()
	d rs.Prepare(StrSql)
	s sc=rs.Execute()
	while(rs.Next())
	{
		s CrsCode = rs.Data("Crs_Code")
		s CrsDesc = rs.Data("Crs_Desc")
		s CrsActiveFlag = rs.Data("Crs_ActiveFlag")
		w CrsCode_""_CrsDesc_""_CrsActiveFlag,!
	}
	q ""
}

}
