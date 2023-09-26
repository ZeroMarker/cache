/// Creator:张超
/// CreatDate: 2015-5-27
/// 自查统计查询报表
Class dhc.pa.report.uDeptSchemResult Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptSchemResult","GetDeptSchemResult")

/// 选择下拉框弹出绩效单元
Query GetDeptSchemResult() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select %ID, JXUnit_name from dhc_pa_data.JXUnit where JXUnit_rowid in (select JXUnitAudit_jxUnitDr from dhc_pa_data.JXUnitAudit) and JXUnit_isEnd =  'Y'
}

//d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptSchemResult","DeptSchemResult","","","","","","","1")

Query DeptSchemResult(DschemDr As %String, UDRrowid As %String, starttime As %String, endtime As %String, JXUnitname As %String, year As %String, UserDr As %String) As %Query(ROWSPEC = "UDRrowid:%String,DschemDr:%String,JXName:%String,period:%String,DscCode:%String,DscName:%String,submitState:%String,submiDr:%String,submiDate:%String,updateDr:%String,updateDate:%String,auditState:%String,auditDr:%String,auditDate:%String") [ SqlProc ]
{
}

ClassMethod DeptSchemResultExecute(ByRef qHandle As %Binary, DschemDr As %String, UDRrowid As %String, starttime As %String, endtime As %String, JXUnitname As %String, year As %String, UserDr As %String) As %Status
{
	n (qHandle,UDRrowid,DschemDr,starttime,endtime,JXUnitname,year,UserDr)
	;s ^tmpwytest("userDr")=UserDr
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    q:UserDr="" $$$OK
    
    
	s sqlStr = "SELECT UDR_rowid,UDR_DschemDr->DSC_frequency As DschemDr ,UDR_jxUnitDr,UDR_jxUnitDr->JXUnit_name AS JXName, "
		_"UDR_period,UDR_DschemDr->DSC_code AS DscCode,UDR_DschemDr->DSC_name AS DscName, "
	     _"UDR_submitState, UDR_submiDr, UDR_submiDate, UDR_updateDr, UDR_updateDate, UDR_auditState,UDR_auditDr, UDR_auditDate "
	     _"FROM dhc_pa_data.UnitDeptResult where 1 = 1 "
	i DschemDr '="" s sqlStr = sqlStr_" and UDR_DschemDr->DSC_frequency  = '"_DschemDr_"' "
	i JXUnitname '= "" s sqlStr = sqlStr_" and UDR_jxUnitDr = '"_JXUnitname_"' "
	i starttime '= "" s sqlStr = sqlStr_" and (substr(UDR_period,5,6)+0) >= '"_starttime_"' "
	i endtime '= "" s sqlStr = sqlStr_" and (substr(UDR_period,5,6)+0) <= '"_endtime_"' "
	i year '= "" s sqlStr= sqlStr_" and substr(UDR_period,1,4) = '"_year_"' "
	;s ^chuSql=sqlStr
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    
    d result.Execute()
    While(result.Next()){
	    s submitName="",updateName="",auditName=""
	    s UDRrowid = result.Data("UDR_rowid")
	    s DschemDr = result.Data("DschemDr")
	    s JXUnitDr = result.Data("UDR_jxUnitDr")
	    q:'$d(^DHCCJXPAJXUNITAUDIT(0,"JXUnitUser",JXUnitDr,UserDr))
	    s JXName = result.Data("JXName")
	    s period  = result.Data("UDR_period")
	    s DscCode = result.Data("DscCode")
	    s DscName = result.Data("DscName")
	    s submitState = result.Data("UDR_submitState")
	    i submitState'="" d 
	    .i submitState = 0 s submitState = "未提交"
	    .i submitState = 1 s submitState = "已提交"
	    s submiDr = result.Data("UDR_submiDr")
	    i submiDr'="" d
	    .i $d(^SSU("SSUSR",submiDr)) d
	    ..s submitName=$p($g(^SSU("SSUSR",submiDr)),"^",2)
	    s submiDate = result.Data("UDR_submiDate")
	    ;w submiDate
	    s updateDr = result.Data("UDR_updateDr")
	    i updateDr'="" d
	    .i $d(^SSU("SSUSR",updateDr)) d
	    ..s updateName=$p($g(^SSU("SSUSR",updateDr)),"^",2)
	    s updateDate = result.Data("UDR_updateDate")
	    s auditState = result.Data("UDR_auditState")
	    i auditState '= "" d 
	    .i auditState = 0 s auditState = "未审核"
	    .i auditState = 1 s auditState = "已审核"
	    s auditDr = result.Data("UDR_auditDr")
	    i auditDr'="" d
	    .i $d(^SSU("SSUSR",auditDr)) d
	    ..s auditName=$p($g(^SSU("SSUSR",auditDr)),"^",2)
	    s auditDate = result.Data("UDR_auditDate")
	    d OutputRow20
	    }
	    
	    q $$$OK
OutputRow20
		s Data = $lb(UDRrowid,DschemDr,JXName,period,DscCode,DscName,submitState,submitName,submiDate,updateName,updateDate,auditState,auditName,auditDate)
 	 	s ^CacheTemp(repid,ind)=Data	
		s ind = ind + 1
		q
}

ClassMethod DeptSchemResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptSchemResultExecute ]
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

ClassMethod DeptSchemResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptSchemResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:张超
/// CreatDate:2015-6-12
/// Description:年度Query
/// Table:dhc_pa_data.Cycle
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptSchemResult","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select Cycle_rowid,Cycle_code from dhc_pa_data.Cycle where Cycle_rowid>0 and Cycle_active='Y' order by Cycle_code Asc
}

ClassMethod GetPeriodExecute(ByRef qHandle As %Binary, Freq As %String) As %Status
{
	n (qHandle,Freq)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr=n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr=l
	...i PeriodDr=1 s PeriodName="上半年"
	...i PeriodDr=2 s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr=0
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodExecute ]
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

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:张超
/// CreatDate:2015-5-25
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptSchemResult","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

/// Creator:张超
/// CreatDate:2015-5-25
/// Description:点击超链接弹出科室自查界面
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uDeptSchemResult","GetResultDetail","129")
Query GetResultDetail(UDRrowid As %String) As %Query(ROWSPEC = "rowid:%String,kpiname:%String,estDesc:%String,fBDesc:%String,load:%String") [ SqlProc ]
{
}

ClassMethod GetResultDetailExecute(ByRef qHandle As %Binary, UDRrowid As %String) As %Status
{
	n (qHandle,UDRrowid)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    s sqlStr = "SELECT UDRD_UDResult,UDRD_DKPIDr->DKX_name AS KPI_NAME ,UDRD_DKPIDr->DKX_level,UDRD_estDesc, UDRD_fBDesc, UDRD_load FROM dhc_pa_data.UnitDeptResultDetail "
    i sqlStr '="" s sqlStr = sqlStr_" where UDRD_UDResult = '"_UDRrowid_"'"
    i sqlStr '="" s sqlStr = sqlStr_"ORDER BY UDRD_DKPIDr->DKX_code asc" 
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    ;w sqlStr
    d result.Execute()
    While(result.Next()){
	    s rowid = result.Data("UDRD_UDResult")
	    s level = result.Data("DKX_level")
	    s kpiname = result.Data("KPI_NAME")
	    s spce=""
		f i=1:1:level d
		.s spce=spce_" "
		s kpiname=spce_kpiname
	    s estDesc = result.Data("UDRD_estDesc")
	    s fBDesc = result.Data("UDRD_fBDesc")
	    s load = result.Data("UDRD_load")
	    d OutputRow21
    }
		q $$$OK
OutputRow21
		s Data = $lb(rowid,kpiname,estDesc,fBDesc,load)
 	 	s ^CacheTemp(repid,ind)=Data	
		s ind = ind + 1
		q
}

ClassMethod GetResultDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResultDetailExecute ]
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

ClassMethod GetResultDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResultDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uDeptSchemR45E7S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
