/// 科室医生收入
Class dhc.pa.report.uMedIncome Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:年份
/// Table:dhc.pa.data.Cycle.
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uMedIncome","GetYears")
Query GetYears() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select Cycle_code,Cycle_name from dhc_pa_data.Cycle  where Cycle_active='Y'
}

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:科室
/// Table:dhc.pa.data.JXUnit.
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uMedIncome","GetReport","201403","6","16")
Query GetUnits() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select JXUnit_rowid,JXUnit_name from dhc_pa_data.JXUnit  where JXUnit_End='Y'
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, YearMonthDr As %String, UnitDr As %String, KPIDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	;s ^TMPLY(1)=YearMonthDr_"^"_UnitDr_"^"_KPIDr
	q:YearMonthDr="" $$$OK
	q:UnitDr="" $$$OK
	q:KPIDr="" $$$OK   //验证是否是 收入成本率考核收入
	

	s YearMonth=""  s MedName="" s InCome=""  
	s sqlStr="select MedIncome_rowid,YearMonth,DeptDr,MedName,Income,KpiDr,KpiDr->KPIIndex1_name as KPIName  from  dhc_pa_data.MedIncome "
	
	i YearMonthDr'="" s sqlStr=sqlStr_" where  YearMonth ='"_YearMonthDr_"'"
	i KPIDr'="" s sqlStr=sqlStr_" and KpiDr ='"_KPIDr_"'"
	i UnitDr'="" s sqlStr=sqlStr_" and DeptDr ='"_UnitDr_"'"
	
	;w sqlStr,!
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s schemStr=""
	
	While(result.Next()){

		
		s YearMonth=result.Data("YearMonth")
		s MedName = result.Data("MedName")
		s InCome= result.Data("Income")
		s KpiDr=result.Data("KpiDr")
		s KPIName=result.Data("KPIName")
		s deptDr=result.Data("DeptDr")
		s dept=""
		i deptDr'="" d
		.i $D(^DHCCJXPAJXUNIT(deptDr)) d
		..i $G(^DHCCJXPAJXUNIT(deptDr))'="" d
		...s dept=$P(^DHCCJXPAJXUNIT(deptDr),"^",3)
		
		d OutputRow
	}
	d result.Close()
 
 	q $$$OK
OutputRow

 	s Data=$lb(YearMonth,MedName,InCome,dept,KpiDr,KPIName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportExecute ]
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

ClassMethod GetReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2012-2-7
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uMedIncome","GetReport","201201","13")
Query GetReport(YearMonthDr As %String, UnitDr As %String, KPIDr As %String) As %Query(ROWSPEC = "YearMonth:%String,MedName:%String,InCome:%Float,dept:%String,KpiDr:%String,KPIName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uMedIncomeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
