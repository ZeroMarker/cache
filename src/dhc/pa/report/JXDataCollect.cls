/// Creator: zlg
/// CreatDate: 2014-8-15
/// Description: 
Class dhc.pa.report.JXDataCollect Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:zhaoliguo
/// CreatDate:2014-08-15
/// Description:
/// Table:绩效方案
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.JXDataCollect","GetReport")
Query GetSchem() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select Schem_rowid,Schem_name from dhc_pa_data.Schem where Schem_childSub>0
}

/// Creator:zhaoliguo
/// CreatDate:2014-08-15
/// Description:
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.JXDataCollect","GetReport")
Query GetDepts() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select JXUnit_rowid,isnull(JXUnit_shortcut,JXUnit_Name) JXUnit_Name from dhc_pa_data.JXUnit c
	where JXUnit_rowid>0 order by JXUnit_type,JXUnit_Code
}

/// Creator:zhaoliguo
/// CreatDate:2014-08-15
/// Description:
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.JXDataCollect","GetReport")
Query GetKPIs() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select KPIIndex1_rowid,KPIIndex1_shortcut from dhc_pa_data.KPIIndex1 WHERE KPIIndex1_scoreMethodCode='M'
	and KPIIndex1_parent not in (13,0)
}

/// 主报表
ClassMethod GetReportJXCollectExecute(ByRef qHandle As %Binary, syear As %String, schemDr As %String, deptDr As %String, kpiDr As %String) As %Status
{
	
	n (qHandle,syear,schemDr,deptDr,kpiDr)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1


 	q:syear="" $$$OK
	
	s yearmonth=$p(syear,"-",1) _$p(syear,"-",2)

	s strSql=""
	_" select distinct a.JXBaseData_period,c.JXUnit_rowid,JXUnit_Code,JXUnit_name,KPIIndex1_code,KPIIndex1_name,JXBaseData_parRef ,JXBaseData_KPIDr ,isnull(a.JXBaseData_actualValue,'0') tb"
	_" from dhc_pa_data.JXBaseData a,dhc_pa_data.KPIIndex1 b,dhc_pa_data.JXUnit c"
	_" ,dhc_pa_data.UnitSchem d,dhc_pa_data.SchemDetail e"
	_" where a.JXBaseData_parRef = c.JXUnit_rowid and a.JXBaseData_KPIDr=b.KPIIndex1_rowid "

	_" and b.KPIIndex1_isEnd='Y' and b.KPIIndex1_colTypeDr=1 and JXBaseData_period='"_yearmonth_"'"
	_" and d.UnitSchem_parRef=c.JXUnit_rowid and e.SchemDetail_KPIDr=a.JXBaseData_KPIDr and e.SchemDetail_parRef=d.UnitSchem_schemDr"
	i schemDr'="" d
	.s strSql=strSql_" and d.UnitSchem_schemDr='"_schemDr_"'"
	
	
	i deptDr'="" d
	.s strSql=strSql_" and JXUnit_rowid='"_deptDr_"'"
	i kpiDr'="" d
	.s strSql=strSql_" and b.KPIIndex1_rowid='"_kpiDr_"'"
	
	w strSql,!
   	k ^zlgtemp
    s ^zlgtemp= strSql	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
	s RowNo=0		
 While(result.Next()){
	  s RowNo=RowNo+1
	  
	  s ReportName=""
      s supName=""
      s UnitCode = result.Data("JXUnit_code")
      s UnitName = result.Data("JXUnit_name")
      s ItemName = result.Data("KPIIndex1_name")
      s TargetValue=$fn(result.Data("tb"),"",2)

	  s syear=result.Data("JXBaseData_period")

	 d OutputRow1
	  
	} 
   	  
  	q $$$OK
OutputRow1
  	s Data=$lb(RowNo,ReportName,UnitCode,UnitName,ItemName,TargetValue,syear)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetReportJXCollectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReportJXCollectExecute ]
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

ClassMethod GetReportJXCollectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReportJXCollectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.pa.report.JXDataCollect","GetReportJXCollect","201201","","","") 
Query GetReportJXCollect(syear As %String, schemDr As %String, deptDr As %String, kpiDr As %String) As %Query(ROWSPEC = "RowNo:%Integer,ReportName:%String,UnitCode:%String,UnitName:%String,ItemName:%String,TargetValue:%Float,syear:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.JXDataCollectS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
