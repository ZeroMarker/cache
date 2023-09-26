/// /财务报表
Class dhc.bonus.report.uFinancialStatement Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, Period As %Integer) As %Status
{
  Set repid=$I(^CacheTemp)
  Set qHandle=$lb(0,repid,0)
  Set ind=1
  
  q:year="" $$$OK
  q:Period="" $$$OK
 
  s sqlStr="SELECT DeptName,SchemeItemName, sum(grczjx) AS grczjx,sum(kskkjj) AS kskkjj,"
          _"sum(kskhkk) AS kskhkk,sum(tzed) AS tzed,sum(tzhje) AS tzhje  FROM ( " 
  
          _"select DISTINCT BonusUnitID->SuperiorUnitID->SuperiorUnitID->bonusUnitName AS DeptName,"
          _"BonusSchemeItemID->SchemeItemName,BonusValue AS grczjx,0 AS kskkjj,0 AS kskhkk,0 AS tzed,0 AS tzhje " 
          _"from dhc_bonus_data.UnitBonusDetail "  
          _"where bonusYear='"_year_"' AND BonusPeriod='"_Period_"'  AND "
          _"BonusSchemeItemID->SchemeItemCode IN ('0306010') "  
  
          _"UNION ALL " 
          _"select DISTINCT BonusUnitID->SuperiorUnitID->SuperiorUnitID->bonusUnitName AS DeptName,"
          _"BonusSchemeItemID->SchemeItemName,BonusValue AS grczjx,0 AS kskkjj,0 AS kskhkk,0 AS tzed,0AS tzhje " 
          _"from dhc_bonus_data.UnitBonusDetail " 
          _"where bonusYear='"_year_"' AND BonusPeriod='"_Period_"' AND "
          _" BonusSchemeItemID->SchemeItemCode IN ('201071') "  
  
          _"UNION ALL "
  
          _"select DISTINCT BonusUnitID->SuperiorUnitID->SuperiorUnitID->bonusUnitName AS DeptName,"
          _"BonusSchemeItemID->SchemeItemName, BonusValue AS  grczjx,0 AS kskkjj,0 AS kskhkk,0 AS tzed,0 AS tzhje " 
          _"from dhc_bonus_data.UnitBonusDetail " 
          _"where bonusYear='"_year_"' AND BonusPeriod='M02' AND "
          _"BonusSchemeItemID->SchemeItemCode IN ('0702040') " 
  
          _"UNION ALL " 
          _"select DISTINCT BonusUnitID->SuperiorUnitID->SuperiorUnitID->bonusUnitName AS DeptName,"
          _"BonusSchemeItemID->SchemeItemName,BonusValue AS grczjx,0 AS kskkjj,0 AS kskhkk,0 AS tzed,0 AS tzhje "
          _"from dhc_bonus_data.UnitBonusDetail "
          _"where bonusYear='"_year_"' AND BonusPeriod='"_Period_"' AND "
          _"BonusSchemeItemID->SchemeItemName LIKE '科室绩效奖金' " 
          
          _"UNION ALL " 
   
          _"select DISTINCT BonusUnitID->bonusUnitName AS DeptName,BonusSchemeItemID->SchemeItemName,"
          _"0 AS grczjx,BonusValue AS kskkjj,0 AS kskhkk,0 AS tzed,0 AS tzhje "
          _"from dhc_bonus_data.UnitBonusDetail " 
          _"where bonusYear='"_year_"' AND BonusPeriod='"_Period_"' AND "
          _"BonusSchemeItemID->SchemeItemCode IN ('10114')  "
          
          _"UNION ALL "
          
          _"select DISTINCT BonusUnitID->bonusUnitName AS DeptName,BonusSchemeItemID->SchemeItemName,0 AS grczjx,"
          _"0 AS kskkjj,BonusValue AS kskhkk,0 AS tzed,0 AS tzhje "
          _"from dhc_bonus_data.UnitBonusDetail " 
          _"where bonusYear='"_year_"' AND BonusPeriod='"_Period_"' AND "
          _"BonusSchemeItemID->SchemeItemCode IN ('10118') "
           
          _"UNION ALL "
           
          _"select BonusUnitID->SuperiorUnitID->SuperiorUnitID->bonusUnitName AS DeptName,SchemeItemID->SchemeItemName,"
          _"0 AS grczjx, 0 AS kskkjj,0 AS kskhkk, sum(AdjustBonus) AS tzed,sum(ResultBonus) AS tzhje " 
          _"from dhc_bonus_data.BonusIssuedDetail "
          _"WHERE  BonusYear='"_year_"' AND BonusPeriod='"_Period_"' "
          _"GROUP BY BonusUnitID->SuperiorUnitID->SuperiorUnitID->bonusUnitName "
   
          _" ) GROUP BY DeptName "
	;w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
  While(result.Next()){
    s DeptName     = result.Data("DeptName")
    ;s bonusUnitName= result.Data("Name")
	s grczjx = result.Data("grczjx")
	s kskkjj = result.Data("kskkjj")
    s kskhkk = result.Data("kskhkk")
	s tzed   = result.Data("tzed")
	s tzhje  = result.Data("tzhje")
	  
    d OutputRow
  }
   	  
  q $$$OK
OutputRow
	
  
  ;s Data=$lb(DeptName,bonusUnitName,grczjx,ksjxje,kstb,ksjxjj,kskkjj,kskhkk,tzed,tzhje)
  s Data=$lb(DeptName,grczjx,kskkjj,kskhkk,tzed,tzhje)
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

/// Creator:
/// CreatDate:2011-08-16
/// Description:获取分科报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uFinancialStatement","GetReport","2014","M02")
Query GetReport(year As %String, Period As %String) As %Query(ROWSPEC = "DeptName:%String,grczjx:%Float,kskkjj:%Float,kskhkk:%Float,tzed:%Float,tzhje:%Float")
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uFinancialSt7AFS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
