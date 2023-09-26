Class dhc.pa.report.uUnitScoreTotal Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod ReportExecute(ByRef qHandle As %Binary, cycleDr As %Integer, period As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	
	q:cycleDr="" $$$OK
	q:period="" $$$OK
	
	s schemDr="4||1"
	s stratagemDr=$P(schemDr,"||",1) 
	
	//获取方案的报告频率、当前月份、应用系统号、考核年度
	s currMonth="",cycleID=""
	i $D(^DHCCJXPASTRATAGEM(stratagemDr)) d
	.i $G(^DHCCJXPASTRATAGEM(stratagemDr))'="" d
	..s currMonth=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",8)
	..i currMonth'="" d
	...s frequency=$P($G(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2))),"^",5)
	...s appSysDr=$P(^DHCCJXPASTRATAGEM($P(schemDr,"||",1),"Schem",$P(schemDr,"||",2)),"^",4)
	...s cycleID=$P($G(^DHCCJXPASTRATAGEM(stratagemDr)),"^",2)
	
	//获取年度代码
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'="" s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "NoDatas"
	
	s newPeriod=""
	i period'="00" d
	.i period<10 s newPeriod=cycleCode_"0"_period
	.e  s newPeriod=cycleCode_period
	e  s newPeriod=cycleCode_period
	
	s sqlStr="select UnitResult_jxUnitDr->JXUnit_code ,UnitResult_jxUnitDr->JXUnit_name, * from dhc_pa_data.UnitResult"
	s whereStr=" where UnitResult_childSub>0 and UnitResult_parRef='"_stratagemDr_"'"
	s whereStr=whereStr_" and UnitResult_appSysDr ='"_appSysDr_"'"
	s whereStr=whereStr_" and UnitResult_period ='"_newPeriod_"'"
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s Code = result.Data("JXUnit_code")
		s Name = result.Data("JXUnit_name")
		s Score = result.Data("UnitResult_totalScore")
		
		d OutputRow
	}
	
 	q $$$OK
OutputRow
 	s Data=$lb(Code,Name,Score)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod ReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uUnitScoreTotal","Report",3,1,"4||1")
Query Report(cycleDr As %Integer, period As %Integer) As %Query(ROWSPEC = "Code:%String,Name:%String,Score:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uUnitScoreTotalS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
