Class dhc.bonus.report.uDeptBonusPercent Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Query GetDeptBonusPercent(year As %String, compPeriod As %String, compUnitType As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "UnitName,UnitID,RealBonus:%Float,TargetValue:%Float,percent:%Float")
{
	 select a.UnitName,a.BonusUnitID as UnitID , a.RealBonus ,b.TargetValue ,a.RealBonus/b.TargetValue as percent from (select BonusUnitID, BonusUnitID->BonusUnitName as UnitName,RealBonus  from dhc_bonus_data.UnitBonusPay 
	 where BonusPeriod=:compPeriod and BonusYear=:year  and  BonusUnitID->BonusUnitTypeID=:compUnitType) a,
    (select BonusUnitID,TargetValue  from dhc_bonus_data.BonusTargetCollect where BonusPeriod=:compPeriod    and BonusYear=:year  and BonusTargetID->BonusTargetCode='N03' and BonusUnitID->BonusUnitTypeID=:compUnitType) b
     where a.BonusUnitID=b.BonusUnitID
}

Query GetUnitType() As %SQLQuery(CONTAINID = 1, ROWSPEC = "BonusUnitTypeID,UnitTypeName")
{
	select BonusUnitTypeID, UnitTypeName from dhc_bonus_data.BonusUnitType where %ID>0 AND IsValid=1
}

/// d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptBonusPercent","GetYearSet")	
Query GetYearSet() As %Query(ROWSPEC = "year:%String")
{
}

ClassMethod GetYearSetExecute(ByRef qHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	set currentYear =$p($zd($p($h,",",1),3),"-",1)
	b
	f i=0:1:9 d
	.s year=currentYear-i
	.d OutputRowValues
 	q $$$OK
 	 
OutputRowValues
 	s ^CacheTemp(repid,ind)=$lb(year)
 	s ind=ind+1
	q
}

ClassMethod GetYearSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetYearSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetYearSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetYearSetExecute ]
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
	
	...i m<10  d
	....s PeriodDr="M0"_m
	....s PeriodName="0"_m_"月"
	...e  d
	....s PeriodDr="M"_m
	....s PeriodName=m_"月"
	
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr="Q0"_n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr="H0"_l
	...i l=1 s PeriodName="上半年"
	...i l=2 s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr="Y00"
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

/// Creator:苏建飞
/// CreatDate:2010-9-14
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptBonusPercent","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

}
