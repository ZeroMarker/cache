/// 科室奖金趋势分析
Class dhc.bonus.report.uUnitBonusPayTrends1 Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:年度Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayTrends1","GetYear")
Query GetYear() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
}

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:科室类别Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayTrends1","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1)
{
	
	select BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where UnitFlag=1 AND LastStage=0 order by cast(BonusUnitCode as int)
}

/// 主报表
ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, deptcode As %String) As %Status
{
	
	n (qHandle,year,deptcode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
    //s userCode="register"
    ;k ^zlgtemp
	;s ^zlgtemp="zlg1="_rptCode_":"_ sDate_":"_userCode
	;q:rptCode="" $$$OK
 	q:year="" $$$OK
  
	s strSql = " select BonusYear, sum(mon1) mon1, sum(mon2) mon2,sum(mon3) mon3,sum(mon4) mon4,sum(mon5) mon5,sum(mon6) mon6, "
	          _" sum(mon7) mon7,sum(mon8) mon8,sum(mon9) mon9,sum(mon10) mon10,sum(mon11) mon11,sum(mon12) mon12,supname, BonusUnitCode,UnitName "
	          _" from ( select BonusYear, "
	          _" case right(BonusPeriod,2) when '01' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon1, "
	          _" case right(BonusPeriod,2) when '02' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon2, "
	          _" case right(BonusPeriod,2) when '03' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon3, "
	          _" case right(BonusPeriod,2) when '04' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon4, "
	          _" case right(BonusPeriod,2) when '05' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon5, "
	          _" case right(BonusPeriod,2) when '06' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon6, "
	          _" case right(BonusPeriod,2) when '07' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon7, "
	          _" case right(BonusPeriod,2) when '08' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon8, "
	          _" case right(BonusPeriod,2) when '09' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon9, "
	          _" case right(BonusPeriod,2) when '10' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon10, "
	          _" case right(BonusPeriod,2) when '11' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon11, "
	          _" case right(BonusPeriod,2) when '12' then sum(ROUND(ResultBonus,0,1)) else 0 end as mon12, "
	          _" SuperiorUnitID->SuperiorUnitID->BonusUnitName supname, SuperiorUnitID->BonusUnitCode,supUnitName UnitName "
	          _" from dhc_bonus_data.BonusIssuedDetail a "
	          _" where  ResultBonus>0 and supUnitName is not null  and BonusYear ='"_year_"' "
	          _" group by BonusYear,BonusPeriod,SuperiorUnitID->SuperiorUnitID->BonusUnitName,supUnitName, SuperiorUnitID "
	          _" ) as hh "
	
	
		s strSql = " select BonusYear, sum(mon1) mon1, sum(mon2) mon2,sum(mon3) mon3,sum(mon4) mon4,sum(mon5) mon5,sum(mon6) mon6, "
	          _" sum(mon7) mon7,sum(mon8) mon8,sum(mon9) mon9,sum(mon10) mon10,sum(mon11) mon11,sum(mon12) mon12,supname, BonusUnitCode,UnitName "
	          _" from ( select BonusYear, "
	          _" case right(BonusPeriod,2) when '01' then sum(ROUND(BonusValue,0,1)) else 0 end as mon1, "
	          _" case right(BonusPeriod,2) when '02' then sum(ROUND(BonusValue,0,1)) else 0 end as mon2, "
	          _" case right(BonusPeriod,2) when '03' then sum(ROUND(BonusValue,0,1)) else 0 end as mon3, "
	          _" case right(BonusPeriod,2) when '04' then sum(ROUND(BonusValue,0,1)) else 0 end as mon4, "
	          _" case right(BonusPeriod,2) when '05' then sum(ROUND(BonusValue,0,1)) else 0 end as mon5, "
	          _" case right(BonusPeriod,2) when '06' then sum(ROUND(BonusValue,0,1)) else 0 end as mon6, "
	          _" case right(BonusPeriod,2) when '07' then sum(ROUND(BonusValue,0,1)) else 0 end as mon7, "
	          _" case right(BonusPeriod,2) when '08' then sum(ROUND(BonusValue,0,1)) else 0 end as mon8, "
	          _" case right(BonusPeriod,2) when '09' then sum(ROUND(BonusValue,0,1)) else 0 end as mon9, "
	          _" case right(BonusPeriod,2) when '10' then sum(ROUND(BonusValue,0,1)) else 0 end as mon10, "
	          _" case right(BonusPeriod,2) when '11' then sum(ROUND(BonusValue,0,1)) else 0 end as mon11, "
	          _" case right(BonusPeriod,2) when '12' then sum(ROUND(BonusValue,0,1)) else 0 end as mon12, "
	          _"  BonusUnitID->SuperiorUnitID->BonusUnitName supname, BonusUnitID->BonusUnitCode,BonusUnitID->BonusUnitName UnitName "
	          _" from dhc_bonus_data.UnitBonusDetail a "
	          _" where  BonusValue>0  and BonusSchemeItemID->BonusItemTypeID=3 and BonusYear ='"_year_"' "
	          _" group by BonusYear,BonusPeriod, BonusUnitID->SuperiorUnitID->BonusUnitName , BonusUnitID->BonusUnitCode "
	          _" ) as hh  "
	 i deptcode'="" d
	 .s strSql=strSql_" where BonusUnitCode='"_deptcode_"'"
	s strSql=strSql_" group by  supname,UnitName"
	
	w strSql,!
	k ^zlgtemp
	s ^zlgtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s Year=result.Data("BonusYear")
	    s supname=result.Data("supname") 
		s UnitName=result.Data("UnitName") 
		
		s Mon1=result.Data("mon1") 
		s Mon2=result.Data("mon2") 
		s Mon3=result.Data("mon3") 
		s Mon4=result.Data("mon4") 
		s Mon5=result.Data("mon5") 
		s Mon6=result.Data("mon6") 
		s Mon7=result.Data("mon7") 
		s Mon8=result.Data("mon8") 
		s Mon9=result.Data("mon9") 
		s Mon10=result.Data("mon10") 
		s Mon11=result.Data("mon11") 
		s Mon12=result.Data("mon12") 
     
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(Year,supname,UnitName,Mon1,Mon2,Mon3,Mon4,Mon5,Mon6,Mon7,Mon8,Mon9,Mon10,Mon11,Mon12)
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

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:查询报表数据记录
/// Table: 
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayTrends1","GetReport","2014","")
Query GetReport(year As %Integer, deptcode As %String) As %Query(ROWSPEC = "Year:%String,supname:%String,UnitName:%String,Mon1:%Float,Mon2:%Float,Mon3:%Float,Mon4:%Float,Mon5:%Float,Mon6:%Float,Mon7:%Float,Mon8:%Float,Mon9:%Float,Mon10:%Float,Mon11:%Float,Mon12:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uUnitBonusPE766S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
