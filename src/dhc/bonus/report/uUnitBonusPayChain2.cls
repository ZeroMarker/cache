/// Description: 科室奖金同比分析
Class dhc.bonus.report.uUnitBonusPayChain2 Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:年度Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayChain1","GetYear")
Query GetYear() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
}

/// Creator:侯勃
/// CreatDate:2013-12-05
/// Description:科室类别Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayChain1","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1)
{
	
	select BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where UnitFlag=1 AND LastStage=0 order by cast(BonusUnitCode as int)
}

/// 主报表
ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, rptCode As %String) As %Status
{
	
	n (qHandle,year,rptCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	;s rptCode="0903"
 	q:year="" $$$OK
 	
 	s year1 = year-1
  
	
	
				s strSql=""
				   _" select '"_year_"' BonusYear,sum(mons1) mons1, sum(mons2) mons2,sum(mons3) mons3,sum(mons4) mons4,sum(mons5) mons5,sum(mons6) mons6,"
                   _" sum(mons7) mons7,sum(mons8) mons8,sum(mons9) mons9,sum(mons10) mons10,sum(mons11) mons11,sum(mons12) mons12,"
                   _" sum(mon1) mon1, sum(mon2) mon2,sum(mon3) mon3,sum(mon4) mon4,sum(mon5) mon5,sum(mon6) mon6,"
                   _" sum(mon7) mon7,sum(mon8) mon8,sum(mon9) mon9,sum(mon10) mon10,sum(mon11) mon11,sum(mon12) mon12,CellName"
                   _" from ( select BonusYear,"
                   _" case right(BonusPeriod,2) when '01' then sum(ROUND(BonusValue,0,1)) else 0 end as mons1,"
                   _" case right(BonusPeriod,2) when '02' then sum(ROUND(BonusValue,0,1)) else 0 end as mons2,"
                   _" case right(BonusPeriod,2) when '03' then sum(ROUND(BonusValue,0,1)) else 0 end as mons3,"
                   _" case right(BonusPeriod,2) when '04' then sum(ROUND(BonusValue,0,1)) else 0 end as mons4,"
                   _" case right(BonusPeriod,2) when '05' then sum(ROUND(BonusValue,0,1)) else 0 end as mons5,"
                   _" case right(BonusPeriod,2) when '06' then sum(ROUND(BonusValue,0,1)) else 0 end as mons6,"
                   _" case right(BonusPeriod,2) when '07' then sum(ROUND(BonusValue,0,1)) else 0 end as mons7,"
                   _" case right(BonusPeriod,2) when '08' then sum(ROUND(BonusValue,0,1)) else 0 end as mons8,"
                   _" case right(BonusPeriod,2) when '09' then sum(ROUND(BonusValue,0,1)) else 0 end as mons9,"
                   _" case right(BonusPeriod,2) when '10' then sum(ROUND(BonusValue,0,1)) else 0 end as mons10,"
                   _" case right(BonusPeriod,2) when '11' then sum(ROUND(BonusValue,0,1)) else 0 end as mons11,"
                   _" case right(BonusPeriod,2) when '12' then sum(ROUND(BonusValue,0,1)) else 0 end as mons12,"
                   _" 0 mon1,0 mon2,0 mon3,0 mon4,0 mon5,0 mon6,0 mon7,0 mon8,0 mon9,0 mon10,0 mon11,0 mon12, b.CellName"
                   _" from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusReportCell b"
                   _" where  a.BonusSchemeItemID= b.BonusSchemeItemID"
                   _" AND b.BonusReportID->ReportCode='"_rptCode_"' and BonusYear ='"_year_"'"
                   _" group by BonusYear,BonusPeriod,b.CellName"
                   _" union all"
                   _" select BonusYear,0 mons1,0 mons2,0 mons3,0 mons4,0 mons5,0 mons6,0 mons7,0 mons8,0 mons9,0 mons10,0 mons11,0 mons12,"
                   _" case right(BonusPeriod,2) when '01' then sum(ROUND(BonusValue,0,1)) else 0 end as mon1,"
                   _" case right(BonusPeriod,2) when '02' then sum(ROUND(BonusValue,0,1)) else 0 end as mon2,"
                   _" case right(BonusPeriod,2) when '03' then sum(ROUND(BonusValue,0,1)) else 0 end as mon3,"
                   _" case right(BonusPeriod,2) when '04' then sum(ROUND(BonusValue,0,1)) else 0 end as mon4,"
                   _" case right(BonusPeriod,2) when '05' then sum(ROUND(BonusValue,0,1)) else 0 end as mon5,"
                   _" case right(BonusPeriod,2) when '06' then sum(ROUND(BonusValue,0,1)) else 0 end as mon6,"
                   _" case right(BonusPeriod,2) when '07' then sum(ROUND(BonusValue,0,1)) else 0 end as mon7,"
                   _" case right(BonusPeriod,2) when '08' then sum(ROUND(BonusValue,0,1)) else 0 end as mon8,"
                   _" case right(BonusPeriod,2) when '09' then sum(ROUND(BonusValue,0,1)) else 0 end as mon9,"
                   _" case right(BonusPeriod,2) when '10' then sum(ROUND(BonusValue,0,1)) else 0 end as mon10,"
                   _" case right(BonusPeriod,2) when '11' then sum(ROUND(BonusValue,0,1)) else 0 end as mon11,"
                   _" case right(BonusPeriod,2) when '12' then sum(ROUND(BonusValue,0,1)) else 0 end as mon12, b.CellName"
                   _" from dhc_bonus_data.UnitBonusDetail a,dhc_bonus_data.BonusReportCell b"
                   _" where  a.BonusSchemeItemID= b.BonusSchemeItemID"
                   _" and b.BonusReportID->ReportCode='"_rptCode_"'   and BonusYear ='"_year_"'"
                   _" group by BonusYear,BonusPeriod, b.CellName"
                   _" ) as hh   group by  CellName"

	
	;w strSql,!
	
	k ^zlgtemp
	s ^zlgtemp=strSql
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(strSql)
	d result.Execute()
		
 While(result.Next()){
	  
	    s Year=result.Data("BonusYear")
	    s supname="" 
		s UnitName=result.Data("CellName") 
		
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
		
		s Mons1=result.Data("mons1") 
		s Mons2=result.Data("mons2") 
		s Mons3=result.Data("mons3") 
		s Mons4=result.Data("mons4") 
		s Mons5=result.Data("mons5") 
		s Mons6=result.Data("mons6") 
		s Mons7=result.Data("mons7") 
		s Mons8=result.Data("mons8") 
		s Mons9=result.Data("mons9") 
		s Mons10=result.Data("mons10") 
		s Mons11=result.Data("mons11") 
		s Mons12=result.Data("mons12") 
		
		i Mons12 '= "0" d 
		.s mon1value = (Mon1-Mons12)/Mons12
		e  d
		.s mon1value = ""
		
		i Mon1 '= "0" d 
		.s mon2value = (Mon2-Mon1)/Mon1
		e  d
		.s mon2value = ""
		
		i Mon2 '= "0" d 
		.s mon3value = (Mon3-Mon2)/Mon2
		e  d
		.s mon3value = ""
		
		i Mon3 '= "0" d 
		.s mon4value = (Mon4-Mon3)/Mon3
		e  d
		.s mon4value = ""
		
		i Mon4 '= "0" d 
		.s mon5value = (Mon5-Mon4)/Mon4
		e  d
		.s mon5value = ""
		
		i Mon5 '= "0" d 
		.s mon6value = (Mon6-Mon5)/Mon5
		e  d
		.s mon6value = ""
		
		i Mon6 '= "0" d 
		.s mon7value = (Mon7-Mon6)/Mon6
		e  d
		.s mon7value = ""
		
		i Mon7 '= "0" d 
		.s mon8value = (Mon8-Mon7)/Mon7
		e  d
		.s mon8value = ""
		
		i Mon8 '= "0" d 
		.s mon9value = (Mon9-Mon8)/Mon8
		e  d
		.s mon9value = ""
		
		i Mon9 '= "0" d 
		.s mon10value = (Mon10-Mon9)/Mon9
		e  d
		.s mon10value = ""
		
		i Mon10 '= "0" d 
		.s mon11value = (Mon11-Mon10)/Mon10
		e  d
		.s mon11value = ""
		
		i Mon11 '= "0" d 
		.s mon12value = (Mon12-Mon11)/Mon11
		e  d
		.s mon12value = ""
     
	 d OutputRow3
	  
	} 
	d result.Close()
   	  
  	q $$$OK
OutputRow3
  	s Data=$lb(Year,supname,UnitName,Mon1,Mon2,Mon3,Mon4,Mon5,Mon6,Mon7,Mon8,Mon9,Mon10,Mon11,Mon12,mon1value,mon2value,mon3value,mon4value,mon5value,mon6value,mon7value,mon8value,mon9value,mon10value,mon11value,mon12value)
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
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusPayChain2","GetReport","2014","0903") 
Query GetReport(year As %Integer, rptCode As %String) As %Query(ROWSPEC = "Year:%String,supname:%String,UnitName:%String,Mon1:%Float,Mon2:%Float,Mon3:%Float,Mon4:%Float,Mon5:%Float,Mon6:%Float,Mon7:%Float,Mon8:%Float,Mon9:%Float,Mon10:%Float,Mon11:%Float,Mon12:%Float,mon1value:%Float,mon2value:%Float,mon3value:%Float,mon4value:%Float,mon5value:%Float,mon6value:%Float,mon7value:%Float,mon8value:%Float,mon9value:%Float,mon10value:%Float,mon11value:%Float,mon12value:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uUnitBonusP2368S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
