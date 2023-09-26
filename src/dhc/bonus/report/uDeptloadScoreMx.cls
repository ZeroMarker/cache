/// Class dhc.bonus.report.uDeptloadScoreMx Extends %SerialObject
Class dhc.bonus.report.uDeptloadScoreMx Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
ClassMethod GetWorkloadScoreExecute(ByRef qHandle As %Binary, beginDate As %String, endDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,beginDate,endDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
	
 	q:beginDate="" $$$OK
	q:endDate="" $$$OK
	q:userCode="" $$$OK
    s beginDate1= $p(beginDate,"-",1) _"M"_$p(beginDate,"-",2)
    s endDate1= $p(endDate,"-",1) _"M"_$p(endDate,"-",2)
	/*
    s strSql=""
    s strSql=strSql_" select BonusYear , BonusPeriod, supUnitName,BonusUnitName,  sum(kdvalue*CalculateRate)+sum(zxvalue*ExecuteRate) as TargetValue"
	s strSql=strSql_" from ( SELECT BonusYear,BonusPeriod,d.SuperiorUnitID->BonusUnitName supUnitName, d.BonusUnitName,a.ItemValue,"
	s strSql=strSql_" case a.UnitType when 1 then a.ItemValue else 0 end kdvalue,CalculateRate, case a.UnitType when 2 then a.ItemValue else 0 end zxvalue,ExecuteRate ,a.UnitType"
	s strSql=strSql_" FROM dhc_bonus_subs.BonusSubExpendCollectDoc a,dhc_bonus_subs.BonusSubItem c,dhc_bonus_data.BonusUnit d,dhc_bonus_data.BonusEmployeeUnit e"
	s strSql=strSql_" where  a.ExpendItemCode = c.SubItemCode  and a.BonusUnitCode = d.BonusUnitCode  and d.BonusUnitTypeID=13 "
	s strSql=strSql_" and d.SuperiorUnitID= e.BonusUnitID and BonusEmployeeID->EmployeeCode='"_userCode_"')"
	s strSql=strSql_" where  BonusYear _ BonusPeriod >='"_beginDate1_"' AND  BonusYear _ BonusPeriod <='"_endDate1_"'"
	s strSql=strSql_" group by BonusYear , BonusPeriod, supUnitName,BonusUnitName"
	*/
	s strSql=""
	s strSql=strSql_" select BonusYear, BonusPeriod,a.BonusUnitID->BonusUnitName supUnitName,hisUnitID->BonusUnitName BonusUnitName,TargetValue"
	s strSql=strSql_" from dhc_bonus_data.DeptScoreDetail a,dhc_bonus_data.BonusEmployeeUnit b "    
	s strSql=strSql_" where  a.BonusUnitID->BonusUnitTypeID=13 "                                    
	s strSql=strSql_" and BonusYear _ BonusPeriod >='"_beginDate1_"' AND  BonusYear _ BonusPeriod <='"_endDate1_"'"
	s strSql=strSql_" and a.BonusUnitID= b.BonusUnitID and BonusEmployeeID->EmployeeCode='"_userCode_"'"
	

    //q strSql
    //w strSql,!	
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
			
 While(result.Next()){
      s supUnitName=result.Data("supUnitName")
      s BonusUnitName = result.Data("BonusUnitName")
    
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod=result.Data("BonusPeriod")
      s TargetValue=$fn(result.Data("TargetValue"),"",2)
	  s YearMonthName=BonusYear_"年"_$E(BonusPeriod,2,3)_"月"
	  //w supUnitName_":"_BonusUnitName,!
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(supUnitName,BonusUnitName,TargetValue,YearMonthName)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptloadScoreMx","GetWorkloadScore","2012-01","2012-02","register")
Query GetWorkloadScore(beginDate As %String, endDate As %String, userCode As %String) As %Query(ROWSPEC = "supUnitName:%String,BonusUnitName:%String,TargetValue:%Float,YearMonthName:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uDeptloadSco663S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
