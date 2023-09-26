Class dhc.pa.report.uKPISortDeptScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2014-03-11
/// Description:查询报表数据记录(按指标排名)
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uKPISortDeptScore","getKPIDeptScoreSort","4","1","M","4||1","2","171")
Query getKPIDeptScoreSort(cycleDr As %String, period As %String, periodType As %String, schemDr As %String, type As %String, KPIDr As %String) As %Query(ROWSPEC = "schemDr:%String,schemName:%String,jxUnitDr:%String,jxUnitName:%String,score:%Float") [ SqlProc ]
{
}

ClassMethod getKPIDeptScoreSortExecute(ByRef qHandle As %Binary, cycleDr As %String, period As %String, periodType As %String, schemDr As %String, type As %String, KPIDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:cycleDr="" $$$OK
	q:period="" $$$OK
 	q:periodType="" $$$OK
 	q:KPIDr="" $$$OK
 	q:schemDr="" $$$OK
 	q:type="" $$$OK

 	s newPeriod=##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(4,1)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitResult_jxUnitDr,JXUnit_code,UnitResult_schemDr,Schem_name,UnitResultDetail_KPIDr,UnitResultDetail_tValue,UnitResultDetail_actValue,UnitResultDetail_score,JXUnit_name  from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail,dhc_pa_data.JXUnit,dhc_pa_data.Schem"
	i type=2 s sqlStr=sqlStr_",dhc_pa_data.KPIIndex1" 
	i type=1 s sqlStr=sqlStr_",dhc_pa_data.DimensType" 
	s whereStr=" where UnitResult_rowid=UnitResultDetail_parRef and UnitResult_jxUnitDr=JXUnit_rowid  and UnitResult_schemDr=Schem_rowid "
	i type=2 s whereStr=whereStr_" and UnitResultDetail_KPIDr=KPIIndex1_rowid  and UnitResultDetail_isTarget=2"
	i type=1 s whereStr=whereStr_" and UnitResultDetail_KPIDr=DimensType_rowid  and UnitResultDetail_isTarget=1"
	
	i period'=""   s whereStr=whereStr_" and UnitResult_period ='"_newPeriod_"'"
	i KPIDr'=""  s whereStr=whereStr_" and UnitResultDetail_KPIDr ='"_KPIDr_"'"
	i periodType'=""   s whereStr=whereStr_" and Schem_frequency='"_periodType_"'"
    i schemDr'="" s whereStr=whereStr_" and UnitResult_schemDr='"_schemDr_"'"
    
    s sortStr=" order by UnitResultDetail_score desc"
	s sqlStr=sqlStr_whereStr_sortStr
	
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	//select UnitResult_schemDr,UnitResult_jxUnitDr,JXUnit_name,UnitResult_period,UnitResult_totalScore,UnitResultDetail_KPIDr,UnitResultDetail_isTarget,UnitResultDetail_tValue,UnitResultDetail_rate,UnitResultDetail_actValue,UnitResultDetail_score,UnitResultDetail_parent from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail,dhc_pa_data.JXUnit where UnitResult_rowid=UnitResultDetail_parRef and UnitResult_jxUnitDr=JXUnit_Rowid and UnitResult_period='201402' and UnitResult_schemDr='4||1' and UnitResultDetail_KPIDr=13 and UnitResultDetail_isTarget=2 order by UnitResultDetail_score desc
	While(result.Next()){
	
		s jxUnitDr =result.Data("UnitResult_jxUnitDr")
		s jxUnitCode = result.Data("JXUnit_code")
		s jxUnitName = result.Data("JXUnit_name")
		s schemDr =result.Data("UnitResult_schemDr")
		s flag="N"
		i schemDr'="" d
		.q:$g(^DHCCJXPASTRATAGEM($p(schemDr,"||",1),"Schem",$p(schemDr,"||",1)))=""
		.s flag=$p(^DHCCJXPASTRATAGEM($p(schemDr,"||",1),"Schem",$p(schemDr,"||",1)),"^",12)
		s schemName = result.Data("Schem_name")
		s score =result.Data("UnitResultDetail_score")
		i flag="N" d
		.d OutputRowDate
	}
	
	d result.Close()

 	q $$$OK
 	
OutputRowDate
	
 	s Data=$lb(schemDr,schemName,jxUnitCode,jxUnitName,$fn(score,"",2))
 	
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod getKPIDeptScoreSortClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getKPIDeptScoreSortExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getKPIDeptScoreSortFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getKPIDeptScoreSortExecute ]
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
<StreamLocation>^dhc.pa.report.uKPISortDept68AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
