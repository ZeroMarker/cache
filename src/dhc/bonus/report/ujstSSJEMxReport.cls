Class dhc.bonus.report.ujstSSJEMxReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 奖金分配汇总报表
/// Creator:ZHao LI GUO
/// CreatDate:2013-8-5
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

/// Creator:ZHao LI GUO
/// CreatDate:2013-8-5
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

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:ZHao LI GUO
/// CreatDate:2011-2-14
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

//

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPay","SchemePeriod")
Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

ClassMethod GetUnitSSJEMxExecute(ByRef qHandle As %Binary, BonusYear As %String, period As %String) As %Status
{
	
	n (qHandle,BonusYear,period)
	
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    
 
 	q:BonusYear="" $$$OK
	q:period="" $$$OK

     
    s PERIOD="M"_period
 
	s sqlStr =""
		_" select BonusYear,BonusPeriod,supName,BonusUnitName,sum(pcss) pcss,sum(zmss) zmss ,sum(txss) txss"
		_" from ("
		_" select BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,"
		_" case when BonusUnitID->SuperiorUnitID in (863,2051) then '手术室' else BonusUnitID->SuperiorUnitID->BonusUnitName end as  supName,BonusUnitID->BonusUnitName,"
		_" sum(BonusValue) pcss, 0 zmss ,0 txss"
		_" from dhc_bonus_data.UnitBonusDetail where BonusValue>0 and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"' AND BonusType=1 and BonusSchemeID IN (39,40,41)"
		_" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,BonusUnitID "
		_" union all"
		_" select BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,"
		_" case when BonusUnitID->SuperiorUnitID in (863,2051) then '手术室' else BonusUnitID->SuperiorUnitID->BonusUnitName end as  supName,BonusUnitID->BonusUnitName,"
		_" 0 pcss, sum(BonusValue)   zmss ,0 txss"
		_" from dhc_bonus_data.UnitBonusDetail where BonusValue>0 and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'  AND BonusType=1 and BonusSchemeID IN (42,43,44)"
		_" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,BonusUnitID"
		_" union all"
		_" select BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,"
		_" case when BonusUnitID->SuperiorUnitID in (863,2051) then '手术室' else BonusUnitID->SuperiorUnitID->BonusUnitName end as  supName,BonusUnitID->BonusUnitName,"
		_" 0 pcss, 0 zmss ,sum(BonusValue) txss"
		_" from dhc_bonus_data.UnitBonusDetail where BonusValue>0 and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'  AND BonusType=1 and BonusSchemeID IN (45,46,47)"
		_" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,BonusUnitID"
		_" ) group by BonusYear,BonusPeriod,supName,BonusUnitName"

    ;w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod=result.Data("BonusPeriod")
      s supName=result.Data("supName")
      s BonusUnitName=result.Data("BonusUnitName")
	  s pcss=result.Data("pcss")
	  s zmss=result.Data("zmss")
	  s txss=result.Data("txss")
	    
	  s YearMonthName=BonusYear_"年"_BonusPeriod _ "月"
	d OutputRow28
	} 
   
   	   
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(BonusYear,BonusPeriod,supName,BonusUnitName,pcss,zmss,txss)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetUnitSSJEMxFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitSSJEMxExecute ]
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

ClassMethod GetUnitSSJEMxClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitSSJEMxExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:ZHao LI GUO
/// CreatDate:2013-8-5
/// Description:查询报表数据记录
/// Table: 														
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.ujstSSJEMxReport","GetUnitSSJEMx","2013","05")
Query GetUnitSSJEMx(BonusYear As %String, period As %String) As %Query(ROWSPEC = "BonusYear:%String,BonusPeriod:%String,supName:%String,BonusUnitName:%String,pcss:%Float,zmss:%Float,txss:%Float") [ SqlProc ]
{
}

ClassMethod GetUnitSSJESumExecute(ByRef qHandle As %Binary, BonusYear As %String, period As %String) As %Status
{
	
	n (qHandle,BonusYear,period)
	
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    
    
 
 	q:BonusYear="" $$$OK
	q:period="" $$$OK

     
    s PERIOD="M"_period
   
     
	s sqlStr =""
		_" select BonusYear,BonusPeriod,supName,sum(pcss) pcss,sum(zmss) zmss ,sum(txss) txss"
		_" from ("
		_" select BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,"
		_" case when BonusUnitID->SuperiorUnitID in (863,2051) then '手术室' else BonusUnitID->SuperiorUnitID->BonusUnitName end as  supName,BonusUnitID->BonusUnitName,"
		_" sum(BonusValue) pcss, 0 zmss ,0 txss"
		_" from dhc_bonus_data.UnitBonusDetail where BonusValue>0 and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"' AND BonusType=1 and BonusSchemeID IN (39,40,41)"
		_" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,BonusUnitID "
		_" union all"
		_" select BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,"
		_" case when BonusUnitID->SuperiorUnitID in (863,2051) then '手术室' else BonusUnitID->SuperiorUnitID->BonusUnitName end as  supName,BonusUnitID->BonusUnitName,"
		_" 0 pcss, sum(BonusValue)   zmss ,0 txss"
		_" from dhc_bonus_data.UnitBonusDetail where BonusValue>0 and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'  AND BonusType=1 and BonusSchemeID IN (42,43,44)"
		_" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,BonusUnitID"
		_" union all"
		_" select BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,"
		_" case when BonusUnitID->SuperiorUnitID in (863,2051) then '手术室' else BonusUnitID->SuperiorUnitID->BonusUnitName end as  supName,BonusUnitID->BonusUnitName,"
		_" 0 pcss, 0 zmss ,sum(BonusValue) txss"
		_" from dhc_bonus_data.UnitBonusDetail where BonusValue>0 and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"'  AND BonusType=1 and BonusSchemeID IN (45,46,47)"
		_" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID,BonusUnitID"
		_" ) group by BonusYear,BonusPeriod,supName"


    ;w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod=result.Data("BonusPeriod")
      s supName=result.Data("supName")
     ; s BonusUnitName=""
	  s pcss=result.Data("pcss")
	  s zmss=result.Data("zmss")
	  s txss=result.Data("txss")
	    
	  s YearMonthName=BonusYear_"年"_BonusPeriod _ "月"
	d OutputRow2
	} 
   
   	   
  	q $$$OK
OutputRow2
	
  
  	s Data=$lb(BonusYear,BonusPeriod,supName,pcss,zmss,txss)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetUnitSSJESumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitSSJESumExecute ]
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

ClassMethod GetUnitSSJESumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitSSJESumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:ZHao LI GUO
/// CreatDate:2013-8-5
/// Description:查询报表数据记录
/// Table: 														
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.ujstSSJEMxReport","GetUnitSSJESum","2013","05")
Query GetUnitSSJESum(BonusYear As %String, period As %String) As %Query(ROWSPEC = "BonusYear:%String,BonusPeriod:%String,supName:%String,pcss:%Float,zmss:%Float,txss:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.ujstSSJEMxR375BS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
