Class dhc.pa.udata.uIntervalMethod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// w ##class(dhc.pa.udata.uIntervalMethod).ListRec(0,25)
ClassMethod ListRec(start, limit) As %String
{
		new ( start, limit)
		
		s sqlStr1="SELECT * FROM dhc_pa_data.KPIIndex1 WHERE %ID>0 and KPIIndex1_scoreMethodCode = 'I' and KPIIndex1_isEnd='Y' ORDER BY %ID Desc"
		s result1=##class(%Library.ResultSet).%New()
		
		d result1.Prepare(sqlStr1)
		d result1.Execute()
		
		s resultString=""
		
		s jsonTitle="rowid^KPIDr^KPIName^extreMum^isPCN^equal^key^value^preEqual^preKey^count^calUnitName"
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		While(result1.Next())
		{	
			s KPIIndex1Rowid = result1.Data("KPIIndex1_rowid")
			s KPIIndex1Name = result1.Data("KPIIndex1_name")
			s KPIIndex1ExtreMum = result1.Data("KPIIndex1_extreMum")
			s tmpDirec = "DESC"
			i KPIIndex1ExtreMum="L" d
			.s tmpDirec="ASC"
			s sqlStr="SELECT IntervalMethod_KPIDr->KPIIndex1_name as KPIName,IntervalMethod_KPIDr->KPIIndex1_extreMum as extreMum,IntervalMethod_KPIDr->KPIIndex1_calUnitDr->CalUnit_name as calUnitName, * FROM dhc_pa_data.IntervalMethod WHERE %ID>0 and IntervalMethod_KPIDr ='"_KPIIndex1Rowid_"' ORDER BY cast (IntervalMethod_Key as float) "_tmpDirec
			s result=##class(%Library.ResultSet).%New()
			d result.Prepare(sqlStr)
			d result.Execute()
			
			s count=0
			s preKPIDr=""
			s preEqual=""
			s preKey=""

			While(result.Next())
			{
				s rowid   = result.Data("IntervalMethod_rowid")
				s KPIDr   = result.Data("IntervalMethod_KPIDr")
				s KPIName = result.Data("KPIName")
				s extreMum = result.Data("extreMum")
				s calUnitName = result.Data("calUnitName")
				s isPCN=""
				i calUnitName="百分比" d
				.s isPCN="Y"
				.s calUnitName="%"
				s equal   = result.Data("IntervalMethod_Equal")
				s key     = result.Data("IntervalMethod_Key")
				s value   = result.Data("IntervalMethod_Value")
					
				s count=count+1
				s tmp=rowid_"^"_KPIDr_"^"_KPIName_"^"_extreMum_"^"_isPCN_"^"_equal_"^"_key_"^"_value_"^"_preEqual_"^"_preKey_"^"_count_"^"_calUnitName
	
				d json.InsertRowData(tmp)
				
				s preEqual=equal
				s preKey=key
				s preKPIDr=KPIDr
			}
		
			d result.Close()
	
		}
		d result1.Close()
		s resultString = json.getJsonData(jsonTitle,count)
		k json
		q resultString
}

/// w ##class(dhc.pa.udata.uIntervalMethod).InsertRec("201005^2010年5月^备注")
ClassMethod InsertRec(KPIDr, equal, key, value) As %String
{
		n (KPIDr, equal, key, value)
		
		k PLIST
		
		
		s PLIST(2)=KPIDr
		s PLIST(3)=equal
		s PLIST(4)=key
		s PLIST(5)=value
	
		&sql(INSERT INTO dhc_pa_data.IntervalMethod VALUES PLIST())
		q SQLCODE
}

/// w ##class(dhc.pa.udata.uIntervalMethod).UpdateRec(4,"2011^2011年^2011-2011wdr^false")
ClassMethod UpdateRec(rowid, KPIDr, equal, key, value) As %String
{
		n (rowid, KPIDr, equal, key, value)
		
		k PLIST
		
		i KPIDr'="" s PLIST(2)=KPIDr
		i equal'="" s PLIST(3)=equal
		i key'="" s PLIST(4)=key
		i value'="" s PLIST(5)=value
		
		&SQL(UPDATE dhc_pa_data.IntervalMethod  VALUES PLIST() where %ID=:rowid)
		q SQLCODE
}

/// w ##class(dhc.pa.udata.uIntervalMethod).Delete(2)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(delete from dhc_pa_data.IntervalMethod where %ID=:rowid)
	q SQLCODE
}

/// w ##class(dhc.pa.udata.uIntervalMethod).CalcIMethod(36, 1)
ClassMethod CalcIMethod(KPIDr, key, tValue) As %String
{
	n (KPIDr, key, tValue)
	
	s val=0
	s tmpKPI = ^DHCCJXPAKPIINDEX1(KPIDr)
	s extreMum = $p(tmpKPI,"^",9)
	s calUnitDr = $p(tmpKPI,"^",8)
	s calUnitName = ""
	i calUnitDr'="" d
	.s calUnitName = $p(^DHCCJXPACALUNIT(calUnitDr),"^",2)
	i calUnitName="百分比" d
	.s key=key-tValue
	e  i (calUnitName'="")&&(tValue'=0)&&(tValue'="") d
	.s key=(key-tValue)/tValue
	s tmpDirec = "DESC"
	i extreMum="L" d
	.s tmpDirec="ASC"
	
	s sqlStr="SELECT * FROM dhc_pa_data.IntervalMethod WHERE %ID>0 and IntervalMethod_KPIDr = '"_KPIDr_"' ORDER BY cast (IntervalMethod_Key as float) "_tmpDirec

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		i val=0 d
		.s rowid=result.Data("IntervalMethod_rowid")
		.s tmpEqual=result.Data("IntervalMethod_Equal")
		.s tmpKey=result.Data("IntervalMethod_Key")
		.s tmpValue=result.Data("IntervalMethod_Value")
		.;w "a,",extreMum,",",key,",",tmpKey,",",tmpValue,!
		.i (extreMum="L")&&(key<tmpKey) d
		..;w "b,",tmpValue,!
		..s val=tmpValue
		.i (extreMum="H")&&(key>tmpKey) d
		..s val=tmpValue
		.i (tmpEqual="Y")&&((key-tmpKey)=0) d
		..s val=tmpValue
	}
	d result.Close()
	q val
}

/// w ##class(dhc.pa.udata.uIntervalMethod).IKPIListRec()
ClassMethod IKPIListRec() As %String
{
		
		s sqlStr="SELECT KPIIndex1_calUnitDr->CalUnit_name as calUnitName,* FROM dhc_pa_data.KPIIndex1 WHERE %ID>0 and KPIIndex1_scoreMethodCode = 'I' ORDER BY %ID Desc"
				
		s result=##class(%Library.ResultSet).%New()
		
		d result.Prepare(sqlStr)
		d result.Execute()
		
		s count=0
		s resultString=""
		
		s json=##class(dhc.pa.comm.JsonObj).%New()
		s jsonTitle="rowid^name^extreMum^calUnitName"

		While(result.Next())
		{
			s rowid   = result.Data("KPIIndex1_rowid")
			s KPIName = result.Data("KPIIndex1_name")
			s extreMum   = result.Data("KPIIndex1_extreMum")
			s calUnitName = result.Data("calUnitName")
			i calUnitName="百分比" d
			.s calUnitName="%"
			s tmp=rowid_"^"_KPIName_"^"_extreMum_"^"_calUnitName
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
<StreamLocation>^dhc.pa.udata.uIntervalMethodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
