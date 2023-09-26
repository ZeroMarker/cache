/// Class dhc.bonus.report.uDeptloadScore Extends %SerialObject
Class dhc.bonus.report.uEmploadScore Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
		
select distinct BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where LastStage=0 and SuperiorUnitID=114
}

/// 主报表
ClassMethod GetWorkloadScoreExecute(ByRef qHandle As %Binary, sDate As %String, SuperUnitID As %String) As %Status
{
	
	n (qHandle,sDate,SuperUnitID)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:sDate="" $$$OK

    s sYear= $p(sDate,"-",1) 
    s sMonth="M"_$p(sDate,"-",2)
    ;w sYear,!
   ; w sMonth,!
    //s ^tempzlg=beginDate_"^"_endDate
   
    s sqlStr="select BonusYear , right(BonusPeriod,2) BonusPeriod, SupUnitName,resDocCode,resDocDesc,BonusUnitCode,BonusUnitName,"
	_" sum(kdvalue*CalculateRate)+sum(zxvalue*ExecuteRate) as zj"
	_" from (SELECT BonusYear,BonusPeriod,d.SuperiorUnitID,d.SuperiorUnitID->BonusUnitName SupUnitName,d.BonusUnitCode,d.BonusUnitName ,a.ExpendItemCode,a.ExpenItemName,a.ItemValue,"
	_" case a.UnitType when 1 then a.ItemValue else 0 end kdvalue,b.CalculateRate,"
	_" case a.UnitType when 2 then a.ItemValue else 0 end zxvalue,b.ExecuteRate ,a.UnitType,resDocCode,resDocDesc"
	_" FROM dhc_bonus_subs.BonusSubExpendCollectDoc a,dhc_bonus_subs.BonusSubExpendRate b,dhc_bonus_subs.BonusSubItem c,dhc_bonus_data.BonusUnit d"
	_" where  a.ExpendItemCode = c.SubItemCode and 'D' _ c.BonusSubItemID = B.BonusSubItem and a.BonusUnitCode = d.BonusUnitCode "
	_" )where BonusYear='"_sYear_"'  and BonusPeriod='"_sMonth_"'"
	i SuperUnitID'="" d
	.s sqlStr = sqlStr_" and SuperiorUnitID ='"_SuperUnitID_"'"
	s sqlStr = sqlStr_" group by BonusYear , BonusPeriod, SupUnitName ,resDocCode,resDocDesc,BonusUnitCode,BonusUnitName"
	s sqlStr = sqlStr_" order by BonusPeriod,SupUnitName"
    
    //w sqlStr,!
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
			
 While(result.Next()){

      s BonusYear=result.Data("BonusYear")
      s BonusPeriod = result.Data("BonusPeriod")
      s SupUnitName=result.Data("SupUnitName")
	  s resDocCode = result.Data("resDocCode")
      s resDocDesc=result.Data("resDocDesc")
      s BonusUnitCode =result.Data("BonusUnitCode")
      s BonusUnitName =result.Data("BonusUnitName")
      
      s TargetValue=$fn(result.Data("zj"),"",2)
	 	  
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(BonusYear,BonusPeriod,SupUnitName,resDocCode,resDocDesc,TargetValue,BonusUnitCode,BonusUnitName)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uEmploadScore","GetWorkloadScore","2012-01","")
Query GetWorkloadScore(sDate As %String, SuperUnitID As %String) As %Query(ROWSPEC = "BonusYear:%String,BonusPeriod:%String,SupUnitName:%String,resDocCode:%String,resDocDesc:%String,TargetValue:%Float,BonusUnitCode:%String,BonusUnitName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.rep64E.uEmploadScoreS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
