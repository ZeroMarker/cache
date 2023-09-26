Class web.uACCTYearPeriod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(web.uACCTYearPeriod).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n ( searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM ACCT_YearPeriod"
	s whereStr=" WHERE %ID>0 "
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	
	s jsonTitle="rowid^name"
	
	While(result.Next())
	{
		s rowid = result.Data("ID")
		s name = result.Data("acct_month")
		s tmp=rowid_"^"_name
		d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^web.uACCTYearPeriodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
