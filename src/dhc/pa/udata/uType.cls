Class dhc.pa.udata.uType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Others: w ##class(dhc.pa.udata.uType).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT * FROM dhc_pa_inter.Type"
	
	s whereStr=" WHERE %ID>0"
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
    ;w sqlStr,!
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	
	s jsonTitle="rowid^code^name"
	s patType=""
	s jxUnitName = ""
	While(result.Next())
	{
		
		s rowid=result.Data("Type_rowid")
		s code=result.Data("Type_code")
		s name=result.Data("Type_name")
		
		s tmp=rowid_"^"_code_"^"_name
		
	
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others:w ##class(dhc.pa.udata.uType).IfRepCode(1,1,"101")
ClassMethod IfRepCode(jxUniteDr, inLocSetDr, code) As %String
{
	n (jxUniteDr,inLocSetDr,code)
	s rowid=0
	s rowid=$o(^DHCCJXPAType(0,"JICode",jxUniteDr,inLocSetDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Others: w ##class(dhc.pa.udata.uType).Insert("2^名字2")
ClassMethod Insert(code, name) As %String
{
		n (code,name)
		
		k PLIST
		
		s PLIST(2)=code
		s PLIST(3)=name
			
		&sql(INSERT INTO dhc_pa_inter.Type VALUES PLIST())
		q SQLCODE
}

/// Others: w ##class(dhc.pa.udata.uType).Updata(1,"1^name")
ClassMethod Updata(rowid, code, name) As %String
{
		n (rowid,code,name)
		
		k PLIST
		
		s PLIST(2)=code
		s PLIST(3)=name
			
		&sql(UPDATE dhc_pa_inter.Type VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// Others:w ##class(dhc.pa.udata.uType).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_inter.Type where Type_rowid=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
