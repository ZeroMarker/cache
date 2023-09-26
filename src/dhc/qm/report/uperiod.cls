Class dhc.qm.report.uperiod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:黄凤杰
/// CreatDate:2015-6-12
/// Description:年度Query
/// Table:dhc_qm_data.Cycle
/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.uperiod","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select Cycle_rowid,Cycle_code from dhc_qm_data.Cycle where Cycle_rowid>0 and Cycle_active='Y' order by Cycle_code Asc
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

/// Creator:hfj
/// CreatDate:2015-5-25
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.qm.report.uperiod","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.qm.report.uperiodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
