Class dhc.bonus.report.uBonusAllDept Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 全院按科室分类奖金报表
/// Description:
/// Table:
/// Others:
ClassMethod GetBonusAllDeptClassifyExecute(ByRef qHandle As %Binary, YearMonth As %String, rptCode As %String) As %Status
{
	
	n (qHandle,YearMonth,rptCode)
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	;q:sDate="" $$$OK
	q:YearMonth="" $$$OK
	
	s Year = $P(YearMonth,"-",1)
  	s Month = "M"_$P(YearMonth,"-",2)
  	s sYearMonth = Year_"年"_$P(YearMonth,"-",2)_"月"
    s sqlStr=" select BonusYear,BonusPeriod,BonusUnitID->SuperiorUnitID->BonusUnitName BonusUnitClassify, sum(BonusValue) sValue " 
			_" from dhc_bonus_data.UnitBonusDetail a ,dhc_bonus_data.BonusReportCell b "
			_" where  a.BonusSchemeItemID= b.BonusSchemeItemID "
			_" AND b.BonusReportID->ReportCode='"_rptCode_"' "
			_" and BonusYear='"_Year_"' and BonusPeriod='"_Month_"' "
			_" group by BonusYear,BonusPeriod,BonusUnitID->SuperiorUnitID->BonusUnitName "
   	
    ;w sqlStr ,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
    s BonusUnit = result.Data("BonusUnitClassify")
    s sValue = result.Data("sValue")
	
	d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(sYearMonth,BonusUnit,sValue)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusAllDeptClassifyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusAllDeptClassifyExecute ]
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

ClassMethod GetBonusAllDeptClassifyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusAllDeptClassifyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusAllDept","GetBonusAllDeptClassify","2014-01","0902")
Query GetBonusAllDeptClassify(YearMonth As %String, rptCode As %String) As %Query(ROWSPEC = "sYearMonth:%String,BonusUnit:%String,sValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.re7006.uBonusAllDeptS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
