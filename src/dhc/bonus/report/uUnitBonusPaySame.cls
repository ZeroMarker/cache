/// Creator: 刘洋
/// CreatDate: 2011-2-22
/// Description: 科室奖金同比分析
Class dhc.bonus.report.uUnitBonusPaySame Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, frequency As %String, period As %Integer, itemDr As %Integer, SchemeDr As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	/**
 	s PeriodName="0"_period ,Period="",PName=""
 	i frequency="M"  d
 	.i period<10 s PeriodName="0"_period
	.e  s PeriodName=period
	.s Period= frequency_PeriodNam
	e  s Period= frequency_PeriodName
	;w Period,!
	**/

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr=""
	s str="合计:"
	
	//全年
	i frequency="Y"  { 
	s sqlStr = "select b.BonusYear,b.BonusPeriod,c.BonusUnitID->BonusUnitName as UnitName,b.BonusSchemeItemID ,a.BonusValue as sqvalue,b.BonusValue bqvalue ,  "
   	_"  case when a.BonusValue=0 then b.BonusValue  "
   	_" else  (b.BonusValue/case a.BonusValue when 0 then  2222 else  a.BonusValue end-1)end as bonusRate "
  	_" from dhc_bonus_data.UnitBonusDetail a ,dhc_bonus_data.UnitBonusDetail b ,  dhc_bonus_data.BonusSchemeUnit  c "
  	_" where a.BonusUnitID = b.BonusUnitID and a.BonusSchemeItemID = b.BonusSchemeItemID and a.BonusUnitID = c.BonusUnitID and c.BonusUnitID = b.BonusUnitID "
  	_" and cast(a.BonusYear as integer)+1= cast(b.BonusYear as integer) "
  	_" and  cast( b.BonusYear as integer) <="_year_" AND cast( b.BonusYear as integer) >"_year_"-5 "
   	_" and left(b.BonusPeriod,1)='"_frequency_"'  and left(a.BonusPeriod,1)='"_frequency_"' "
  	_" and c.BonusSchemeID ="_SchemeDr_" and b.BonusSchemeItemID="_itemDr_" "
  	
  	_" union all "
	_" SELECT BonusYear,BonusPeriod,   '"_str_"' as UnitName , BonusSchemeItemID ,sum(sqvalue) as sqvalue,sum(bqvalue) as bsqvalue ,sum(bqvalue)/sum(sqvalue)-1 as bonusRate "
	_" from( "
	_"select b.BonusYear,b.BonusPeriod,c.BonusUnitID->BonusUnitName as UnitName,b.BonusSchemeItemID ,a.BonusValue as sqvalue,b.BonusValue bqvalue ,  "
   	_"  case when a.BonusValue=0 then b.BonusValue  "
   	_" else  (b.BonusValue/case a.BonusValue when 0 then  2222 else  a.BonusValue end-1)end as bonusRate "
  	_" from dhc_bonus_data.UnitBonusDetail a ,dhc_bonus_data.UnitBonusDetail b ,  dhc_bonus_data.BonusSchemeUnit  c "
  	_" where a.BonusUnitID = b.BonusUnitID and a.BonusSchemeItemID = b.BonusSchemeItemID and a.BonusUnitID = c.BonusUnitID and c.BonusUnitID = b.BonusUnitID "
  	_" and cast(a.BonusYear as integer)+1= cast(b.BonusYear as integer) "
  	_" and  cast( b.BonusYear as integer) <="_year_" AND cast( b.BonusYear as integer) >"_year_"-5 "
   	_" and left(b.BonusPeriod,1)='"_frequency_"'  and left(a.BonusPeriod,1)='"_frequency_"' "
  	_" and c.BonusSchemeID ="_SchemeDr_" and b.BonusSchemeItemID="_itemDr_"  "
  	
  	_" ) group by BonusYear,BonusSchemeItemID,BonusPeriod  "
	}
	//s whereStr=" WHERE %ID>0"
	;s sqlStr=sqlStr_whereStr


	//月  季度  半年
	i (frequency="Q")|| (frequency="M")|| (frequency="H"){ 
	s sqlStr = "select BonusYear,BonusPeriod, UnitName,BonusSchemeItemID ,case when sum(sqvalue) = 0 then null  else sum(sqvalue) end sqvalue, bqvalue "
	_" ,case when sum(bonusRate)=0 then null else sum(bonusRate)  end as bonusRate from ( "
	_" select b.BonusYear,b.BonusPeriod,c.BonusUnitID->SuperiorUnitID->BonusUnitName as UnitName,b.BonusSchemeItemID ,a.BonusValue as sqvalue,b.BonusValue as bqvalue , "
	_" case when a.BonusValue=0 then b.BonusValue "
	_" else (b.BonusValue/case a.BonusValue when 0 then  2222 else  a.BonusValue end-1)  end as bonusRate "
	_" from dhc_bonus_data.UnitBonusDetail a ,dhc_bonus_data.UnitBonusDetail b,dhc_bonus_data.BonusSchemeUnit  c "
	_" where a.BonusUnitID = b.BonusUnitID  and a.BonusSchemeItemID = b.BonusSchemeItemID and a.BonusUnitID=c.BonusUnitID and b.BonusUnitID=c.BonusUnitID "
	_" and a.BonusYear+1= b.BonusYear "
	_" and  cast(right(b.BonusPeriod,2) as integer) <="_period_" "
	_" and a.BonusPeriod=b.BonusPeriod "
	_" and left(a.BonusPeriod,1)='"_frequency_"' and left(b.BonusPeriod,1)='"_frequency_"' "
	_" and b.BonusSchemeItemID="_itemDr_"  and  c.BonusSchemeID="_SchemeDr_" and b.BonusYear ='"_year_"' "
	
	_" union all "
	_" select BonusYear, BonusPeriod,c.BonusUnitID->SuperiorUnitID->BonusUnitName as UnitName,BonusSchemeItemID ,0 as sqvalue,sum(BonusValue) as bqvalue , 0 as bonusRate "
	_" from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusSchemeUnit  c "
	_" where BonusYear ='"_year_"' and a.BonusUnitID=c.BonusUnitID and BonusSchemeItemID="_itemDr_" and c.BonusSchemeID="_SchemeDr_" "
	_" and left(a.BonusPeriod,1)='"_frequency_"' "
	_" and  cast(right(BonusPeriod,2) as integer) <="_period_" "
	_"  group by BonusYear, BonusPeriod,c.BonusUnitID->SuperiorUnitID->BonusUnitName "
	_" ) as TB group by BonusYear,BonusPeriod,BonusSchemeItemID, bqvalue,UnitName" 
	
	_" union all "
	_" SELECT BonusYear,BonusPeriod,   '"_str_"' as UnitName , BonusSchemeItemID ,sum(sqvalue) as sqvalue,sum(bqvalue) as bqvalue ,sum(bqvalue)/sum(sqvalue)-1 as bonusRate "
	_" from( "
	_"select BonusYear,BonusPeriod, UnitName,BonusSchemeItemID ,case when sum(sqvalue) = 0 then null  else sum(sqvalue) end sqvalue, bqvalue "
	_" ,case when sum(bonusRate)=0 then null else sum(bonusRate)  end as bonusRate from ( "
	_" select b.BonusYear,b.BonusPeriod,c.BonusUnitID->SuperiorUnitID->BonusUnitName as UnitName,b.BonusSchemeItemID ,a.BonusValue as sqvalue,b.BonusValue as bqvalue , "
	_" case when a.BonusValue=0 then b.BonusValue "
	_" else (b.BonusValue/case a.BonusValue when 0 then  2222 else  a.BonusValue end-1)  end as bonusRate "
	_" from dhc_bonus_data.UnitBonusDetail a ,dhc_bonus_data.UnitBonusDetail b,dhc_bonus_data.BonusSchemeUnit  c "
	_" where a.BonusUnitID = b.BonusUnitID  and a.BonusSchemeItemID = b.BonusSchemeItemID and a.BonusUnitID=c.BonusUnitID and b.BonusUnitID=c.BonusUnitID "
	_" and a.BonusYear+1= b.BonusYear "
	_" and  cast(right(b.BonusPeriod,2) as integer) <="_period_" "
	_" and a.BonusPeriod=b.BonusPeriod "
	_" and left(a.BonusPeriod,1)='"_frequency_"' and left(b.BonusPeriod,1)='"_frequency_"' "
	_" and b.BonusSchemeItemID="_itemDr_"  and  c.BonusSchemeID="_SchemeDr_" and b.BonusYear ='"_year_"' "
	
	_" union all "
	_" select BonusYear, BonusPeriod,c.BonusUnitID->SuperiorUnitID->BonusUnitName as UnitName,BonusSchemeItemID ,0 as sqvalue,sum(BonusValue) as bqvalue , 0 as bonusRate "
	_" from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusSchemeUnit  c "
	_" where BonusYear ='"_year_"' and a.BonusUnitID=c.BonusUnitID and BonusSchemeItemID="_itemDr_" and c.BonusSchemeID="_SchemeDr_" "
	_" and left(a.BonusPeriod,1)='"_frequency_"' "
	_" and  cast(right(BonusPeriod,2) as integer) <="_period_" "
	_"   group by BonusYear, BonusPeriod,c.BonusUnitID->SuperiorUnitID->BonusUnitName "
	_" ) as TB group by BonusYear,BonusPeriod,BonusSchemeItemID, bqvalue,UnitName" 
	_" ) group by BonusYear,BonusSchemeItemID,BonusPeriod  "
	}
	w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		
		s iDr= result.Data("BonusSchemeItemID")
	    i iDr'="" d
		.i $D(^dhcbsBonusSchemeItemD(iDr)) d
		..i $G(^dhcbsBonusSchemeItemD(iDr))'="" d
		...s itemName=$List(^dhcbsBonusSchemeItemD(iDr),4)

		/**	
		s uDr = result.Data("BonusUnitID")
		i uDr'="" d
		.i $D(^dhcbsBonusUnitD(uDr)) d
		..i $G(^dhcbsBonusUnitD(uDr))'="" d
		...s unitName=$List(^dhcbsBonusUnitD(uDr),3)
		**/
		s hbValue=result.Data("bonusRate")
		s bqValue=result.Data("bqvalue")
		s unitName=result.Data("UnitName")
		s Year=year_"年"
		
		i frequency="Y" s Period=result.Data("BonusYear")_"年"
		i frequency="M" d
		.s Per=result.Data("BonusPeriod")
		.s period=$EXTRACT(Per,2,3)
		.s Period =period_"月"
		
		i frequency="Q" d
		.s Per=result.Data("BonusPeriod")
		.s period=$EXTRACT(Per,2,3)
		.s Period =period_"季度"
		
		i frequency="H" d
		.s Per=result.Data("BonusPeriod")
		.s period=$EXTRACT(Per,3)
		.i period=1 d
		..s Period ="上半年"
		.i period=2 d
		..s Period ="下半年"
	
		d OutputRow
	}
	
	d result.Close()

 	q $$$OK
 	
OutputRow
	
 	s Data=$lb(itemName,unitName,bqValue,hbValue,Period,Year)
 	
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
/// CreatDate:2011-2-18
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPaySame","GetReport","2010","M","6","155","39")
Query GetReport(year As %Integer, frequency As %String, period As %Integer, itemDr As %Integer, SchemeDr As %Integer) As %Query(ROWSPEC = "itemName:%String,unitName:%String,bqValue:%Float,hbValue:%Float,Period:%String,Year:%String")
{
}

/// Creator:刘洋
/// CreatDate:2011-2-22
/// Description:查询当前条件下的单元
/// Table:dhc_bonus_data.BonusSchemeUnit
/// Input:
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.report.uUnitBonusPaySame).GetUnit(1)
ClassMethod GetUnit(SchemeDr) As %String
{
	n (SchemeDr)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr="select BonusSchemeUnitID, BonusSchemeID,BonusUnitID from dhc_bonus_data.BonusSchemeUnit where %ID>0 "
	i SchemeDr'="" s sqlStr=sqlStr_" and BonusSchemeID='"_SchemeDr_"'"	
	s str=""
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s uDr = result.Data("BonusUnitID")
		i uDr'="" d
		.i $D(^dhcbsBonusUnitD(uDr)) d
		..i $G(^dhcbsBonusUnitD(uDr))'="" d
		...s unitName=$List(^dhcbsBonusUnitD(uDr),3)
		
		i str="" s str =uDr_"^"_unitName
		e  s str=str_"|"_uDr_"^"_unitName
	}
	q str
}

/// Creator:刘洋
/// CreatDate:2011-2-22
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPaySame","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
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
	..s PeriodDr=1
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

/// Creator:刘洋
/// CreatDate:2011-2-22
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPaySame","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

/// Creator:刘洋
/// CreatDate:2011-2-22
/// Description:方案Query
/// Table:dhc_bonus_data.BonusScheme
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPaySame","GetScheme")
Query GetScheme() As %SQLQuery(CONTAINID = 1)
{
	select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where SchemeState=1
}

/// Creator:刘洋
/// CreatDate:2011-2-22
/// Description:奖金项Query
/// Table:dhc_bonus_data.BonusSchemeItem
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPaySame","GetItem")
Query GetItem() As %SQLQuery(CONTAINID = 1)
{
	select BonusSchemeItemID,BonusSchemeID,SchemeItemName from dhc_bonus_data.BonusSchemeItem
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uUnitBonusPa6CCS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
