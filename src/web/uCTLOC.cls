Class web.uCTLOC Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(web.uCTLOC).List("name","西药库","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n ( searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM CT_Loc"
	s whereStr=" WHERE %ID>0"
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	
	s json=##class(web.com.JsonObj).%New()
	s jsonTitle="rowid^code^name"
	
	s end = start+limit-1
	
	While(result.Next())
	{
		s rowid = result.Data("CTLOC_RowID")
		s code = result.Data("CTLOC_Code")
		s name = result.Data("CTLOC_Desc")
		s tmp=rowid_"^"_code_"^"_name
		i searchValue'="" d
		.q:(searchField = "name")&(name'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1

	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^web.uCTLOCS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
