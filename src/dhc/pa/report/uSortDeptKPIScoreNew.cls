Class dhc.pa.report.uSortDeptKPIScoreNew Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2012-2-16
/// Description:根据期间和方案级别查询全院科室考核分
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uSortDeptKPIScoreNew","getSortKPIScore",1,1,"M",1,"1||3")
Query getSortKPIScore(cycleDr As %String, period As %String, periodType As %String, level As %String, schemDr As %String) As %Query(ROWSPEC = "schemDr:%String,schemName:%String,unitDr:%String,unitCode:%String,unitName:%String,sorce:%Float,periodName:%String") [ SqlProc ]
{
}

ClassMethod getSortKPIScoreExecute(ByRef qHandle As %Binary, cycleDr As %String, period As %String, periodType As %String, level As %String, schemDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:cycleDr="" $$$OK
  	q:periodType="" $$$OK
  	q:period="" $$$OK
  	q:level="" $$$OK
	
	i periodType="M" s Freq="月"
	i periodType="Q" s Freq="季"
	i periodType="H" s Freq="半年"
	i periodType="Y" s Freq="年"
		
	//获取新的考核周期
  	s newPeriod=$p(##class(dhc.pa.report.uUnitKpiReport).GetCycle(cycleDr, period),"^",1)
  	q:newPeriod="" $$$OK
	q:newPeriod="UnCycle" $$$OK
	q:newPeriod="UnPeriod" $$$OK
	q:newPeriod="UnCycleCode" $$$OK
	
	s result = ##class(%Library.ResultSet).%New()
	
		
	s sqlStr="select UnitResult_jxUnitDr,JXUnit_code,JXUnit_name,UnitResult_schemDr,Schem_name,UnitResult_totalScore,UnitResult_period from dhc_pa_data.UnitResult,dhc_pa_data.JXUnit,dhc_pa_data.Schem where UnitResult_jxUnitDr=JXUnit_rowid and UnitResult_schemDr=Schem_rowid"
	
	s whereStr=" and UnitResult_period='"_newPeriod_"' and Schem_frequency='"_periodType_"' and Schem_level="_level
	
	i schemDr'=""  s whereStr=whereStr_"  and UnitResult_schemDr='"_schemDr_"'"
	
	s whereStr=whereStr_" order by UnitResult_totalScore DESC"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s unitDr="",unitCode="",unitName="",schemDr="",schemName="",sorce="",period="",periodName=""
		
		s unitDr= result.Data("UnitResult_jxUnitDr")
		s unitCode = result.Data("JXUnit_code")
		s unitName = result.Data("JXUnit_name")
		s schemDr = result.Data("UnitResult_schemDr")
		s schemName = result.Data("Schem_name")
		s sorce = result.Data("UnitResult_totalScore")
		;w sorce,!
		s period = result.Data("UnitResult_period")
		s periodName = $e(period,5,6)_Freq
		d OutputRow
	}
	d result.Close()
	Quit $$$OK
	
OutputRow
 	s Data=$lb(schemDr,schemName,unitDr,unitCode,unitName,sorce,periodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getSortKPIScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getSortKPIScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getSortKPIScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getSortKPIScoreExecute ]
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

Storage Default
{
<StreamLocation>^dhc.pa.report.uSortDeptKPI7B4S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
