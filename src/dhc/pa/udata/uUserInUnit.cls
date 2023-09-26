Class dhc.pa.udata.uUserInUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uUserInUnit).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select * from dhc_pa_data.UserInUnit"
	s whereStr=" where %ID>0"
	s sortStr=" order by %ID desc"
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^jxUnitDr^jxUnitName^userDr^userName"
	While(result.Next()){

		s jxUnitName="",userName=""
		
		s rowid=result.Data("UserInUnit_rowid")
		s jxUnitDr=result.Data("UserInUnit_jxUnitDr")
		i jxUnitDr'="" d
		.i $D(^DHCCJXPAKPIINDEX1(jxUnitDr)) d
		..i $G(^DHCCJXPAKPIINDEX1(jxUnitDr))'="" d
		...s jxUnitName = $P($G(^DHCCJXPAKPIINDEX1(jxUnitDr)),"^",2)
		s userDr=result.Data("UserInUnit_userDr")
		i userDr'="" d
		.i $D(^SSU("SSUSR",userDr)) d
		..i $G(^SSU("SSUSR",userDr))'="" d
		...s userName=$P(^SSU("SSUSR",userDr),"^",2)
		
		s tmp=rowid_"^"_jxUnitDr_"^"_jxUnitName_"^"_userDr_"^"_userName
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.udata.uUserInUnit).GetJXUnit(0,10,"")
ClassMethod GetJXUnit(start, limit, str) As %String
{
	n (start, limit, str)
	
	s Stratagem = ""
	s curreStratagemDr = ""
	f  s Stratagem=$o(^DHCCJXPASTRATAGEM(Stratagem)) q:Stratagem=""  d
	.i $D(^DHCCJXPASTRATAGEM(Stratagem)) d
	..i $G(^DHCCJXPASTRATAGEM(Stratagem))'="" d
	...s curreStratagem = $P(^DHCCJXPASTRATAGEM(Stratagem),"^",14)
	...i curreStratagem="Y" d
	....s curreStratagemDr = Stratagem
	
	s isEnd="Y"
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select JXUnit_rowid,JXUnit_shortcut from dhc_pa_data.JXUnit where %ID>0 and JXUnit_level=2 "
	s whereStr=" and JXUnit_stratagemDr='"_curreStratagemDr_"'"
	;w sqlStr,!
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s jxUnitDr = result.Data("JXUnit_rowid")
		s jxUnitShortCut = result.Data("JXUnit_shortcut")
		s tmp=jxUnitDr_"^"_jxUnitShortCut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("jxUnitDr^jxUnitShortCut",count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.udata.uUserInUnit).GetUser(0,10,"")
ClassMethod GetUser(start, limit, str) As %String
{
	n (start, limit, str)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SSUSR_RowId,SSUSR_Name from SS_User where %ID>0"
	i str'="" s sqlStr = sqlStr_" and SSUSR_Name like '"_str_"%'"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.pa.comm.JsonObj).%New()
	While(result.Next()){
		s rowid = result.Data("SSUSR_RowId")
		s name = result.Data("SSUSR_Name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// w ##class(dhc.pa.udata.uUserInUnit).Insert("10^47^Y^Y")
ClassMethod Insert(data) As %String
{
	n (data)
	
	q:data="" "dataEmpt"      				
	k PLIST
	
	s jxUnitDr=$p(data,"^",1)			
	i jxUnitDr'="" s PLIST(2)=jxUnitDr 
	
	s userDr=$p(data,"^",2)				
	i userDr'="" s PLIST(3)=userDr

	&SQL(insert into dhc_pa_data.UserInUnit VALUES PLIST())
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uUserInUnit).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.UserInUnit where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uUserInUnit).Update(1,"10^47^Y^Y")
ClassMethod Update(rowid, data) As %String
{
	n (rowid, data)
	
	q:rowid="" "rowidEmpt"					//错误数据
	q:data="" "dataEmpt"      				//空数据dataEmpt
	k PLIST
	
	s jxUnitDr=$p(data,"^",1)				//绩效单元
	i jxUnitDr'="" s PLIST(2)=jxUnitDr 
	
	s userDr=$p(data,"^",2)					//用户
	i userDr'="" s PLIST(3)=userDr
	
	&sql(update dhc_pa_data.UserInUnit values PLIST() where %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUserInUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
