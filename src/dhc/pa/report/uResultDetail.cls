/// 科室医生收入
Class dhc.pa.report.uResultDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:年份
/// Table:dhc.pa.data.Cycle.
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uResultDetail","GetYears")
Query GetYears() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select Cycle_code,Cycle_name from dhc_pa_data.Cycle  where Cycle_active='Y'
}

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:科室
/// Table:dhc.pa.data.JXUnit.
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uResultDetail","GetScore","201403","6","16")
Query GetUnits() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select JXUnit_rowid,JXUnit_name from dhc_pa_data.JXUnit  where JXUnit_End='Y'
}

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uResultDetail","GetScore","201309","100","90")
Query GetScore(YearMonthDr As %String, highpoints As %Integer, lowpoints As %Integer) As %Query(ROWSPEC = "YearMonth:%String,deptname:%String,KPIName:%String,calname:%String,tValue:%Float,actValue:%Float,score:%Float") [ SqlProc ]
{
}

ClassMethod GetScoreExecute(ByRef qHandle As %Binary, YearMonthDr As %String, highpoints As %Integer, lowpoints As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	;s ^TMPLY(1)=YearMonthDr_"^"_UnitDr_"^"_KPIDr
	q:YearMonthDr="" $$$OK
	;q:UnitDr="" $$$OK
	;q:KPIDr="" $$$OK   //验证是否是 收入成本率考核收入
	s YearMonthDr=$p(YearMonthDr,"-",1)_$p(YearMonthDr,"-",2)

	
	s sqlStr="SELECT ur.UnitResult_period,ur.UnitResult_jxUnitDr->JXUnit_name,urd.UnitResultDetail_KPIDr->KPIIndex1_name,urd.UnitResultDetail_tValue,urd.UnitResultDetail_actValue, "
	_"urd.UnitResultDetail_score,urd.UnitResultDetail_KPIDr->KPIIndex1_calUnitDr->CalUnit_name "
	_"FROM dhc_pa_data.UnitResult ur, dhc_pa_data.UnitResultDetail urd "
	_"WHERE ur.UnitResult_rowid=urd.UnitResultDetail_parRef AND urd.UnitResultDetail_isTarget!=1 "
	
	
	i YearMonthDr'="" s sqlStr=sqlStr_" and ur.UnitResult_period='"_YearMonthDr_"'"
	i highpoints'="" s sqlStr=sqlStr_" and urd.UnitResultDetail_score<='"_highpoints_"'"
	i lowpoints'="" s sqlStr=sqlStr_" and urd.UnitResultDetail_score>='"_lowpoints_"'"
	s sqlStr=sqlStr_" ORDER BY ur.UnitResult_period,urd.UnitResultDetail_KPIDr,ur.UnitResult_jxUnitDr,urd.UnitResultDetail_actValue"
	
	w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;s schemStr=""
	
	While(result.Next()){

		
		s YearMonth=result.Data("UnitResult_period")
		s deptname=result.Data("JXUnit_name")
		s KPIName = result.Data("KPIIndex1_name")
		s calname=result.Data("CalUnit_name")
		s tValue= result.Data("UnitResultDetail_tValue")
		s actValue= result.Data("UnitResultDetail_actValue")
		s score=result.Data("UnitResultDetail_score")
		
		d OutputRow
	}
	d result.Close()
 
 	q $$$OK
OutputRow

 	s Data=$lb(YearMonth,deptname,KPIName,calname,tValue,actValue,score)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScoreExecute ]
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

ClassMethod GetScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScoreGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uResultDetail","GetScoreGroup","201401","100","90")
Query GetScoreGroup(YearMonthDr As %String, highpoints As %Integer, lowpoints As %Integer) As %Query(ROWSPEC = "number:%Integer,kpiname:%String") [ SqlProc ]
{
}

ClassMethod GetScoreGroupExecute(ByRef qHandle As %Binary, YearMonthDr As %String, highpoints As %Integer, lowpoints As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	;s ^TMPLY(1)=YearMonthDr_"^"_UnitDr_"^"_KPIDr
	q:YearMonthDr="" $$$OK
	;q:UnitDr="" $$$OK
	;q:KPIDr="" $$$OK   //验证是否是 收入成本率考核收入
	s YearMonthDr=$p(YearMonthDr,"-",1)_$p(YearMonthDr,"-",2)

	
	s sqlStr="SELECT count(ur.UnitResult_jxUnitDr) AS number,urd.UnitResultDetail_KPIDr->KPIIndex1_name "
	_"FROM dhc_pa_data.UnitResult ur, dhc_pa_data.UnitResultDetail urd "
	_"WHERE ur.UnitResult_rowid=urd.UnitResultDetail_parRef AND urd.UnitResultDetail_isTarget!=1 "
	
	
	i YearMonthDr'="" s sqlStr=sqlStr_" and ur.UnitResult_period='"_YearMonthDr_"'"
	i highpoints'="" s sqlStr=sqlStr_" and urd.UnitResultDetail_score<='"_highpoints_"'"
	i lowpoints'="" s sqlStr=sqlStr_" and urd.UnitResultDetail_score>='"_lowpoints_"'"
	s sqlStr=sqlStr_" GROUP BY urd.UnitResultDetail_KPIDr "
	s sqlStr=sqlStr_"ORDER BY urd.UnitResultDetail_KPIDr"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	;s schemStr=""
	
	While(result.Next()){

		
		s number=result.Data("number")
		s kpiname=result.Data("KPIIndex1_name")
		
		d OutputRow2
	}
	d result.Close()
 
 	q $$$OK
OutputRow2

 	s Data=$lb(number,kpiname)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetScoreGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetScoreGroupExecute ]
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

ClassMethod GetScoreGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetScoreGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uResultDetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
