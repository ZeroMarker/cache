/// Creator: wang ying
/// CreatDate: 2010-11-04
/// Description: 科室指标考核分分析（指标）
Class dhc.pa.report.uLocScoreAnlysKPI Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2010-10-11
/// Description:根据条件获取考核期间,如:201001=年+月(或季度、半年)
/// Table:
/// Input:cycleDr-考核周期Dr;period-期间
/// Output:
/// Return:返回考核期间
/// Others:w ##class(dhc.pa.report.uLocKPIScoreAnlys).GetCycle(1,1)
ClassMethod GetCycle(cycleDr, period) As %String
{
	n (cycleDr,period)
	
	q:cycleDr="" "UnCycle" //不计算
	q:period="" "UnPeriod" //不计算
	s newPeriod=""
	
	s cycleCode=""
	i $D(^DHCCJXPACYCLE(cycleDr)) d
	.i $G(^DHCCJXPACYCLE(cycleDr))'=""  d
	..s cycleCode=$P($G(^DHCCJXPACYCLE(cycleDr)),"^",1)
	q:cycleCode="" "UnCycleCode" //不计算
	
	i period<10 d
	.s period="0"_period
	s newPeriod=cycleCode_period
	
	q newPeriod
}

ClassMethod LocSorceAnlysKPIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocSorceAnlysKPIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getKPIByUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getKPIByUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod LocSorceAnlysKPIExecute(ByRef qHandle As %Binary, CycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, KPIDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:CycleDr="" "UnCycle" //不计算
	q:frequency="" "Unfrequency"
	q:startPeriod="" "UnstartPeriod"
	q:endPeriod="" "UnendPeriod"
	q:KPIDr="" "UnKPIDr"
 	
	q:startPeriod>endPeriod $$$OK
	//准备新的考核期间(1-->201001变换)
	s newPeriodList=##class(%Library.ListOfDataTypes).%New()
	i startPeriod=endPeriod d
	.d newPeriodList.Insert(..GetCycle(cycleDr,startPeriod))
	i startPeriod<endPeriod d
	.s diff=endPeriod-startPeriod+1
	.f k=1:1:diff d
	..s period=startPeriod+k-1
	..d newPeriodList.Insert(..GetCycle(cycleDr,period))
	
	
	Quit $$$OK
}

ClassMethod getKPIByUserExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	s kpiAduit=0
 	f  s kpiAduit=$o(^DHCCJXPAKPIAUDIT(kpiAduit)) q:kpiAduit=""  d
 	.s kpiAduitAll = $g(^DHCCJXPAKPIAUDIT(kpiAduit))
 	.s KPIDr = $p(kpiAduitAll,"^",1)
 	.s userDr = $p(kpiAduitAll,"^",2)
 	.i KPIDr'="" d
 	..i $d(^DHCCJXPAKPIINDEX1(KPIDr)) d
 	...s KPIName = $p($g(^DHCCJXPAKPIINDEX1(KPIDr)),"^",2)
 	.i userDr'="" d
 	..i $d(^SSU("SSUSR",userDr)) d
 	...s userCode = $p($g(^SSU("SSUSR",userDr)),"^",1)
 	...d OutputRow
 	
	q $$$OK
OutputRow
	
 	s Data=$lb(userCode,KPIDr,KPIName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod LocSorceAnlysKPIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocSorceAnlysKPIExecute ]
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

ClassMethod getKPIByUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getKPIByUserExecute ]
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

/// Creator:wang ying
/// CreatDate:2010-11-04
/// Description:根据考核期间和KPI指标获得各科室的KPI指标考核分值
/// Table:
/// Input:cycleDr-考核周期Dr;frequency-期间类型;startPeriod-开始期间;endPeriod-结束期间;KPIDr-KPI指标id
/// Output:
/// Return:返回各考核单元的单元代码、单元名称、期间、以及对应的分数
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocScoreAnlysKPI","getKPIByUser")
Query LocSorceAnlysKPI(CycleDr As %String, frequency As %String, startPeriod As %String, endPeriod As %String, KPIDr As %String) As %Query(ROWSPEC = "unitCode:%String,unitName:%String,periodName:%String,score:%Float") [ SqlProc ]
{
}

/// Creator:wang ying
/// CreatDate:2010-11-04
/// Description:得到KPI权限表对应的userCode和KPI名称
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.pa.report.uLocScoreAnlysKPI","getKPIByUser")
Query getKPIByUser() As %Query(ROWSPEC = "userCode:%String,KPIName:%String,KPIDr:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.pa.report.uLocScoreAnl67AS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
