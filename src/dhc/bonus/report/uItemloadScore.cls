/// Class dhc.bonus.report.uDeptloadScore Extends %SerialObject
Class dhc.bonus.report.uItemloadScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

/// 调整方案
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptloadScore","GetScheme")
Query GetScheme() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	select  BonusSchemeID BonusSchemeAdjustID,BonusSchemeName from dhc_bonus_data.BonusScheme WHERE IsValid=1 AND SchemeState=1
}

/// 指标
/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptloadScore","GetTarget")
Query GetLCDept() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
		
select distinct SuperiorUnitID->BonusUnitID,SuperiorUnitID->BonusUnitName from dhc_bonus_data.BonusUnit where LastStage=0 and SuperiorUnitID>0
}

/// 主报表
ClassMethod GetWorkloadScoreExecute(ByRef qHandle As %Binary, beginDate As %String, endDate As %String, SuperUnitID As %String) As %Status
{
	
	n (qHandle,beginDate,endDate,SuperUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:beginDate="" $$$OK
	q:endDate="" $$$OK
	q:SuperUnitID="" $$$OK
    s beginDate1= $p(beginDate,"-",1) _"M"_$p(beginDate,"-",2)
    s endDate1= $p(endDate,"-",1) _"M"_$p(endDate,"-",2)
    
    //s ^tempzlg=beginDate_"^"_endDate
   
    s sqlStr="select BonusUnitID->SuperiorUnitID->BonusUnitName superUnitName,BonusUnitID,BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName,BonusTargetID->BonusTargetCode,BonusTargetID->BonusTargetName,sum(TargetValue) TargetValue"
		_" from dhc_bonus_data.BonusTargetCollect "
		_" where  BonusTargetID->BonusTargetCode='G99060'"
		_" and BonusYear _ BonusPeriod >='"_beginDate1_"'" 
		_" and BonusYear _ BonusPeriod <='"_endDate1_"'" 
		
		_" and BonusUnitID->SuperiorUnitID='"_SuperUnitID_"'"
		_" group by BonusUnitID->SuperiorUnitID ,BonusUnitID,BonusTargetID"
   ///	w sqlStr,!	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
			
 While(result.Next()){
      s BonusUnitID=result.Data("BonusUnitID")
      s BonusUnitCode = result.Data("BonusUnitCode")
      s BonusUnitName=result.Data("BonusUnitName")
	  s superUnitName = result.Data("superUnitName")
      s BonusTargetName=result.Data("BonusTargetName")
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s YearMonthName=beginDate_"至"_endDate
	  
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(superUnitName,BonusUnitCode,BonusUnitName,BonusTargetName,TargetValue,YearMonthName)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetWorkloadScoreFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWorkloadScoreExecute ]
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

ClassMethod GetWorkloadScoreClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWorkloadScoreExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptloadScore","GetWorkloadScore","2011-01","2011-02","114")
Query GetWorkloadScore(beginDate As %String, endDate As %String, SuperUnitID As %String) As %Query(ROWSPEC = "superUnitName:%String,BonusUnitCode:%String,BonusUnitName:%String,BonusTargetName:%String,TargetValue:%Float,YearMonthName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.re64E.uItemloadScoreS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
