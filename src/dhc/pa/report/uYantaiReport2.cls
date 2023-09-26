/// Creator: wyy
/// CreatDate: 2013-3-23
/// Description: 科室考核汇总报表
Class dhc.pa.report.uYantaiReport2 Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetLocSumReportExecute(ByRef qHandle As %Binary, period As %Integer, groupDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:period="" $$$OK
	q:groupDr="" $$$OK
	s ^TMPWYY(1)="222_"_period_","_groupDr
	s period=$P(period,"-",1)_$P(period,"-",2)
	s tmpGroupIDSet=$P(^DHCCJXPAJXGROUP(groupDr),"^",3)
	s tmpUnitDr=$P(^DHCCJXPAJXGROUP(groupDr),"^",6)
	s tmpUnitName=$P(^DHCCJXPAJXUNIT(tmpUnitDr),"^",3)
	;w tmpUnitDr,!
	;w tmpGroupIDSet,!
	s tmpGroupID=""
	s tmpindex=1
	f  s tmpGroupID=$P(tmpGroupIDSet,"-",tmpindex) q:tmpGroupID=""  d
	.s tmpindex=tmpindex+1
	.;w tmpGroupID,!
	.s tmpKPIName = $p(^DHCCJXPAKPIINDEX1(tmpGroupID),"^",2)
	.s tmpTypeDr = $p(^DHCCJXPAKPIINDEX1(tmpGroupID),"^",5)
	.;w tmpTypeDr,!
	.s tmpTypeName = ""
	.i tmpTypeDr = "1" d //////////////
	..s tmpTypeName = " 业务质量指标"
	.i tmpTypeDr = "9" d //////////////
	..s tmpTypeName = "管理质量指标"
	.s tmpScore = ..GetScore(period,tmpUnitDr,tmpGroupID)
	.d OutputRow
 	q $$$OK
 	
OutputRow
	
 	s Data=$lb(tmpGroupID,tmpKPIName,tmpUnitName,tmpScore,tmpTypeName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetLocSumReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocSumReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}Else{				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocSumReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocSumReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:wyy
/// CreatDate:2013-3-25
/// Description:查询科室汇总报表数据记录
/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uYantaiReport2","GetLocSumReport",1,20)
Query GetLocSumReport(period As %String, groupDr As %String) As %Query(ROWSPEC = "KPIDr:%Float,KPIName:%String,jxUnitName:%String,score:%Float,TypeName:%String") [ SqlProc ]
{
}

/// w ##class(dhc.pa.report.uYantaiReport2).GetScore("201303",81,89)
ClassMethod GetScore(month, unit, kpi) As %String
{
	n (month,unit,kpi)
	
	s score=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ScoreDirectInput_Score from dhc_pa_data.ScoreDirectInput where %ID>0"
	s whereStr=" and ScoreDirectInput_Month='"_month_"' and ScoreDirectInput_UnitDr ='"_unit_"' and ScoreDirectInput_KPIDr='"_kpi_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s score = result.Data("ScoreDirectInput_Score")
	}
	
	q score
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uYantaiReport2S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
