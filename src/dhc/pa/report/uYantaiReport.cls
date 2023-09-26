/// Creator: wyy
/// CreatDate: 2013-3-23
/// Description: 科室考核汇总报表
Class dhc.pa.report.uYantaiReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetLocSumReportExecute(ByRef qHandle As %Binary, period As %Integer, groupDr As %String, group2Dr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:period="" $$$OK
	q:groupDr="" $$$OK
	q:group2Dr="" $$$OK	
	
	s period=$P(period,"-",1)_$P(period,"-",2)
	/*
	s calUnitDr = $p(tmpKPI,"^",8)
	s calUnitName = ""
	i calUnitDr'="" d
	.s calUnitName = $p(^DHCCJXPACALUNIT(calUnitDr),"^",2)
	i calUnitName="百分比" d

	
	*/
	s tmpUnitDrSet=$P(^DHCCJXPAJXGROUP(group2Dr),"^",3)
	s tmpUnitDr=""
	s tmpindex2=1
	f  s tmpUnitDr=$P(tmpUnitDrSet,"-",tmpindex2) q:tmpUnitDr=""  d
	.s tmpindex2=tmpindex2+1
	.s tmpUnitName=$P(^DHCCJXPAJXUNIT(tmpUnitDr),"^",3)
	.;w tmpindex2,",",tmpUnitName,!
	.s tmpGroupIDSet=$P(^DHCCJXPAJXGROUP(groupDr),"^",3)
	.s tmpGroupID=""
	.s tmpindex=1
	.f  s tmpGroupID=$P(tmpGroupIDSet,"-",tmpindex) q:tmpGroupID=""  d
	..s tmpindex=tmpindex+1
	..;w tmpGroupID,!
	..s tmpKPIName = $p(^DHCCJXPAKPIINDEX1(tmpGroupID),"^",2)
	..s tmpTypeDr = $p(^DHCCJXPAKPIINDEX1(tmpGroupID),"^",5)
	..s calUnitDr = $p(^DHCCJXPAKPIINDEX1(tmpGroupID),"^",8)
	..s calUnitName = ""
	..s isInUse="Y"
	..i calUnitDr'="" d
	...s calUnitName = $p(^DHCCJXPACALUNIT(calUnitDr),"^",2)
	..;w tmpTypeDr,!
	..;w tmpindex,",",tmpKPIName,!
	..s tmpTypeName = ""
	..s tmpScore = ""
	..i tmpTypeDr = "1" d //////////////
	...s tmpTypeName = " 业务质量指标"
	...s tmpScore = ..GetScore(period,tmpUnitDr,tmpGroupID)
	..i tmpTypeDr = "9" d //////////////
	...s tmpTypeName = "管理质量指标"
	...s tmpScore = ..GetScore2(period,tmpUnitDr,tmpGroupID)
	..s tmpTV = $p(tmpScore,"^",2)
	..s tmpAV = $p(tmpScore,"^",3)
	..s isInUse = $p(tmpScore,"^",4)
	..s tmpSub = tmpAV-tmpTV
	..s tmpScore = $p(tmpScore,"^",1)
	..i tmpScore>100 d
	...s tmpScore=100
	..s tmpScore= $fn(tmpScore,"",2)
	..s isNum=tmpScore
	..i tmpTV=-1 d
	...s tmpTV=""
	...s tmpAV=""
	...s tmpSub=""
	...s tmpScore=""
	...s isNum=0
	..e  i calUnitName="百分比" d
	...s tmpTV=tmpTV*100_"%"
	...s tmpAV=tmpAV*100_"%"
	...s tmpSub=tmpSub*100_"%"
	..i (tmpAV="-1")||(tmpAV="-100%") d
	...s tmpAV="未用"
	...s tmpSub=""
	...s tmpScore="100.00"
	...s isNum=100
	..d OutputRow
 	q $$$OK
 	
OutputRow
	
 	s Data=$lb(tmpGroupID,tmpKPIName,tmpUnitName,tmpTypeName,tmpTV,tmpAV,tmpScore,tmpindex2,tmpindex-1,tmpSub,isNum,isInUse)
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
/// d ##class(%ResultSet).RunQuery("dhc.pa.report.uYantaiReport","GetLocSumReport","2013-03",18,19)
Query GetLocSumReport(period As %String, groupDr As %String, group2Dr As %String) As %Query(ROWSPEC = "KPIDr:%Float,KPIName:%String,jxUnitName:%String,TypeName:%String,tValue:%String,actValue:%String,Score:%String,UnitIndex:%Float,KPIIndex:%Float,tmpSub:%String,isNum:%Float,isInUse:%Float") [ SqlProc ]
{
}

/// w ##class(dhc.pa.report.uYantaiReport).GetScore("201302",81,89)
ClassMethod GetScore(month, unit, kpi) As %String
{
	n (month,unit,kpi)
	
	s score=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select * from dhc_pa_data.UnitResult,dhc_pa_data.UnitResultDetail  where UnitResultDetail_parRef=UnitResult_rowid "
	s whereStr=" and UnitResult_period ='"_month_"' and UnitResult_jxUnitDr ='"_unit_"' and UnitResultDetail_KPIDr ='"_kpi_"'"
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		
		s tmpScore = result.Data("UnitResultDetail_score")
		s tValue = result.Data("UnitResultDetail_tValue")
		s actValue = result.Data("UnitResultDetail_actValue")
		s isInUse = ..isInUse(unit,kpi)
		s score = tmpScore_"^"_tValue_"^"_actValue_"^"_isInUse
	}
	
	q score
}

/// w ##class(dhc.pa.report.uYantaiReport2).GetScore("201303",81,89)
ClassMethod GetScore2(month, unit, kpi) As %String
{
	n (month,unit,kpi)
	
	s score=""
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select ScoreDirectInput_Score from dhc_pa_data.ScoreDirectInput where %ID>0"
	s whereStr=" and ScoreDirectInput_Month='"_month_"' and ScoreDirectInput_UnitDr ='"_unit_"' and ScoreDirectInput_KPIDr='"_kpi_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s isInUse = ..isInUse(unit,kpi)
	While(result.Next()){
		s score = result.Data("ScoreDirectInput_Score")
	}
	
	q score_"^1^^"_isInUse
}

/// w ##class(dhc.pa.report.uYantaiReport).isInUse(81,89)
ClassMethod isInUse(unit, kpi) As %String
{
	n (unit,kpi)
	
	s score="1"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DKR_Active from dhc_pa_data.DeptKPIReport where %ID>0"
	s whereStr=" and DKR_DeptDr ='"_unit_"' and DKR_KPIDr ='"_kpi_"'"
	s sqlStr=sqlStr_whereStr
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s score = result.Data("DKR_Active")
	}
	i score="N" d  s score="0"
	e  d  s score="1"
	
	q score
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uYantaiReportS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
