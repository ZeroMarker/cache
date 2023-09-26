/// Creator: Zhao LiGuo
/// CreatDate: 2011-01-29
/// Description: 获取奖金核算期间查询类别
Class dhc.bonus.comm.BonusPeriodQuery Extends %SerialObject [ ClassType = serial, Not ProcedureBlock, StorageStrategy = "" ]
{

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-1-26
/// Description:期间Query
/// Table:
/// Others:
ClassMethod GetPeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...i m<10 s PeriodDr="0"_m
	...e  s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr="0"_n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr="0"_l
	...i PeriodDr="01" s PeriodName="上半年"
	...i PeriodDr="02" s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr="00"
	..s PeriodName="全年"
	..d OutputRowPeriod

 q $$$OK
OutputRowPeriod
	
 s Data=$lb(Freq,PeriodDr,PeriodName)
 s ^CacheTemp(repid,ind)=Data	
 s ind=ind+1
	q
}

/// Creator:刘洋
/// CreatDate:2011-1-26
/// Description:期间Query
/// Table:
/// Others:
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

/// Creator:刘洋
/// CreatDate:2011-1-26
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.comm.BonusPeriodQuery","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.c55E.BonusPeriodQ680S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
