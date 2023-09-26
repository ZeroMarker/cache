Class dhc.pa.udata.uUnitKPIMapDirectInput Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uUnitKPIMapDirectInput).ListRec("","","","","",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
		n (searchField, searchValue, sortField, sortDir, start, limit)
		
		s sqlStr="SELECT * FROM dhc_pa_data.UnitKPIMapDirectInput WHERE %ID>0"
		s sortStr="ORDER BY %ID DESC"
		
		s sqlStr=sqlStr_sortStr
		
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		s end=start+limit
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^KPIDr^KPIName^UnitDr^UnitName"
		
		While(result.Next())
		{
			
			s rowid=result.Data("UnitKPIMapDirectInput_rowid")
			s KPIDr=result.Data("UnitKPIMapDirectInput_KPIDr")
			s KPIName="",UnitName=""
			i KPIDr'="" s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
			s UnitDr=result.Data("UnitKPIMapDirectInput_UnitDr")
			i UnitDr'=""  s UnitName = $p($g(^DHCCJXPAJXUNIT(UnitDr)),"^",3)
			
			s tmp=rowid_"^"_KPIDr_"^"_KPIName_"^"_UnitDr_"^"_UnitName
			s count=count+1
			
			i (count>start)&(count<=end) d
			.d json.InsertRowData(tmp)
		}
	
		d result.Close()
		s resultString = json.getJsonData(jsonTitle,count)
	 	k json
		q resultString
}

///  w ##class(dhc.pa.udata.uUnitKPIMapDirectInput).IfRepKPI("201006")
ClassMethod IfRepKPI(KPIDr, user) As %String
{
	n (KPIDr,user)
	q:KPIDr="" ""
	q:user="" ""
	s rowid=0
	s rowid=$o(^DHCCJXPAKPIAUDIT(0,"User",user,KPIDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// w ##class(dhc.pa.udata.uUnitKPIMapDirectInput).InsertRec("21^demo")
ClassMethod InsertRec(data) As %String
{
		n (data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
		s KPIDr=$p(data,"^",1)
		s userId=$p(data,"^",2)
		

		s rowid=0
		;s rowid=..IfRepKPI(KPIDr,userId)
		q:rowid>0 "RepKPI"
		
		i KPIDr'="" s PLIST(3)=KPIDr
		i userId'="" s PLIST(2)=userId
	
		
		&sql(INSERT INTO dhc_pa_data.UnitKPIMapDirectInput VALUES PLIST())
		q SQLCODE
}

/// w ##class(dhc.pa.udata.uUnitKPIMapDirectInput).UpdateRec(1,"70^1397")
ClassMethod UpdateRec(rowid, data) As %String
{
		n (rowid,data)
		
		k PLIST
		q:data="" "EmptyRecData"
		
	
		s KPIDr=$p(data,"^",1)
		s userId=$p(data,"^",2)
		/*
		s user = $$ALPHAUP^SSUTIL4(UserCode)
		s userId = ""
		s userId = $o(^SSU("SSUSR",0,"SSUSR_Name",user,userId))
        */
		s id=0
		s id=..IfRepKPI(KPIDr, userId)
		q:(id'=0)&(id'=rowid) "RepKPI"
		
	

		s PLIST(2)=KPIDr
		s PLIST(3)=userId

		&SQL(UPDATE dhc_pa_data.UnitKPIMapDirectInput VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// w ##class(dhc.pa.udata.uUnitKPIMapDirectInput).DelRec("2")
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_pa_data.UnitKPIMapDirectInput WHERE %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uUnitKPIMapDirectInput).UnitList(0,25)
ClassMethod UnitList(start, limit) As %String
{
	n ( start, limit)
	
	s parent=65  /////////////////////////////////
	
	s sqlStr="select JXUnit_rowid,JXUnit_appSysDr,JXUnit_code,JXUnit_name,JXUnit_py,JXUnit_shortcut,JXUnit_type,JXUnit_jxLocTypeDr,JXUnit_isEnd,JXUnit_level,JXUnit_aDeptDr,JXUnit_parent,JXUnit_stratagemDr,JXUnit_End from dhc_pa_data.JXUnit"
	s whereStr=" where %ID>0"
	s whereStr=whereStr_" and JXUnit_parent ='"_parent_"'"
	s sortStr=" order by JXUnit_code asc"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s resultString=""
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
			
	s count=0
	s resultString=""
	s end=start+limit
		
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name"

	While(result.Next()){
		s rowid = result.Data("JXUnit_rowid")
		s code = result.Data("JXUnit_code")
		s name = result.Data("JXUnit_name")
		
		s tmp=rowid_"^"_code_"^"_name
		s count=count+1
			
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uUnitKPIMapD882S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
