Class web.DHCST.Common.JsonObj Extends web.DHCST.Common.DataStore [ ClassType = serial ]
{

/// Description:根据表名Rowid,返回json数据
/// Creator:	hulihua
/// CreatDate:	2015-01-13
/// w ##class(web.DHCST.Common.JsonObj).GetValue("Inc_itm",12)
ClassMethod GetValue(tab As %String, rowid As %String) As %String
{
	s result=""
	s sql="select * from "_tab_" where %id='"_rowid_"'"
	s xs=##class(%ResultSet).%New()
	d xs.Prepare(sql)
	s ret=xs.Execute(sql)
	s colcnt=xs.GetColumnCount()
	while (xs.Next())
	{
	   f i=1:1:colcnt d
	   .s colname=xs.GetColumnName(i)
	   .s data=xs.GetData(i)
	   . i result="" d
	   . . s result="{"_colname_":"""_data
	   . e  d
	   . . s result=result_""","_colname_":"""_data
	}
	s result=result_"""}"
	d xs.Close()
	q result
}

/// Descript:	取掉数据中的特殊字符
/// Creator：	hulihua
/// CreatDate： 2015-12-18
/// Table:	
/// Input:	原数值
/// Output:
/// Return:	去除后的新数值
/// w ##class(web.DHCST.Common.JsonObj).GetData("'wo")
ClassMethod GetData(value) As %Library.String
{
	s value=$tr(value,$c(10, 13, 16)) // 替换换行回车等隐藏字符
	s value=$Replace(value,"\","\\")  // 替换转义序列,防js显示错误
	s value=$Replace(value,"'","\'")  //替换特殊符号
	q value
}

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
