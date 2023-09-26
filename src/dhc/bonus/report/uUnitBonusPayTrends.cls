/// Creator: 刘洋
/// CreatDate: 2011-2-15
/// Description: 科室奖金趋势分析
Class dhc.bonus.report.uUnitBonusPayTrends Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:刘洋
/// CreatDate:2011-2-15
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayTrends","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
}

/// Creator:刘洋
/// CreatDate:2011-2-15
/// Description:科室类别Query
/// Table:dhc_bonus_data.BonusUnitType
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayTrends","GetUnitType")
Query GetUnitType() As %SQLQuery(CONTAINID = 1)
{
	
	select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit wherE UnitFlag=1 AND LastStage=0 order by cast(BonusUnitCode as int)
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, superUnitID As %String, schemDr As %String) As %Status
{
	//n (year,superUnitID)
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	
 	
 	q:year="" $$$OK
	//q:unitType="" $$$OK
	
 
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr=""
	
	s sqlStr = "select  BonusPeriod,BonusSchemeID->BonusSchemeName as BonusSchemeName,BonusUnitID->SuperiorUnitID BonusUnitID,sum(RealBonus) as RealBonus from dhc_bonus_data.UnitBonusPay "
	s whereStr=" WHERE %ID>0"
	
	i year'="" s whereStr=whereStr_" and BonusYear='"_year_"'"
	i superUnitID'="" s whereStr=whereStr_" and BonusUnitID->SuperiorUnitID ='"_superUnitID_"'"
	i schemDr'="" s whereStr=whereStr_" and BonusSchemeID ='"_schemDr_"'" 

	s whereStr=whereStr_" group by  BonusPeriod,BonusUnitID->SuperiorUnitID"

	i whereStr'="" s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s Mon1=0,Mon2=0,Mon3=0,Mon4=0,Mon5=0,Mon6=0,Mon7=0,Mon8=0,Mon9=0,Mon10=0,Mon11=0,Mon12=0

		s schemName=result.Data("BonusSchemeName") 
		s str=result.Data("BonusPeriod") 
		
		i str="M01" s Mon1=result.Data("RealBonus") 
		i str="M02" s Mon2=result.Data("RealBonus") 
		i str="M03" s Mon3=result.Data("RealBonus") 
		i str="M04" s Mon4=result.Data("RealBonus") 
		i str="M05" s Mon5=result.Data("RealBonus") 
		i str="M06" s Mon6=result.Data("RealBonus") 
		i str="M07" s Mon7=result.Data("RealBonus") 
		i str="M08" s Mon8=result.Data("RealBonus") 
		i str="M09" s Mon9=result.Data("RealBonus") 
		i str="M10" s Mon10=result.Data("RealBonus") 
		i str="M11" s Mon11=result.Data("RealBonus") 
		i str="M12" s Mon12=result.Data("RealBonus") 
		
		s uDr = result.Data("BonusUnitID")
		i uDr'="" d
		.i $D(^dhcbsBonusUnitD(uDr)) d
		..i $G(^dhcbsBonusUnitD(uDr))'="" d
		...s unitName=$List(^dhcbsBonusUnitD(uDr),3)
	
		s Year=year
	
		d OutputRow
	}
	d result.Close()

	
 	q $$$OK
OutputRow
	
 	s Data=$lb(Year,unitName,schemName,Mon1,Mon2,Mon3,Mon4,Mon5,Mon6,Mon7,Mon8,Mon9,Mon10,Mon11,Mon12)
 	
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
/// CreatDate:2011-2-15
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayTrends","GetReport","2011",145,39)
Query GetReport(year As %Integer, superUnitID As %String, schemDr As %String) As %Query(ROWSPEC = "Year:%String,unitName:%String,schemName:%String,Mon1:%Float,Mon2:%Float,Mon3:%Float,Mon4:%Float,Mon5:%Float,Mon6:%Float,Mon7:%Float,Mon8:%Float,Mon9:%Float,Mon10:%Float,Mon11:%Float,Mon12:%Float")
{
}

Storage Default
{
<Data name="uUnitBonusPayTrendsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.bonus.r64E.uUnitBonusPa7B6D</DataLocation>
<DefaultData>uUnitBonusPayTrendsDefaultData</DefaultData>
<IdLocation>^dhc.bonus.r64E.uUnitBonusPa7B6D</IdLocation>
<IndexLocation>^dhc.bonus.r64E.uUnitBonusPa7B6I</IndexLocation>
<StreamLocation>^dhc.bonus.r64E.uUnitBonusPa7B6S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
