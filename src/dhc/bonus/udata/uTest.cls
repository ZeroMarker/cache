Class dhc.bonus.udata.uTest Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others:w ##class(dhc.bonus.udata.uTest).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sel="f1,f2,f3,f4"
	
	s sqlStr="select "_sel_"  from  dhc_bonus.test3"
	
	w sqlStr,!		
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="f1^f2^f3^f4"
	

	//取结构
	While(result.Next()){
		
		//s rowid = result.Data("testid")
		//s code = result.Data("code")
		//s name = result.Data("name")
		//s age = result.Data("age")
		//s tmp=rowid_"^"_code_"^"_name_"^"_age
		s z1="f1"
		s z2="f2"
		s z3="f3"
		s z4="f4"
		//s tmp=result.Data(z1)
		s tmp=result.Data(z1)_"^"_result.Data(z2)_"^"_result.Data(z3)_"^"_result.Data(z4)

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uTestS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
