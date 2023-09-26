/// Class dhc.bonus.report.uDeptIncomeDetail Extends %SerialObject
Class dhc.bonus.report.uDeptIncomeDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
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
ClassMethod DeptIncomeDetailExecute(ByRef qHandle As %Binary, beginDate As %String, endDate As %String, userCode As %String) As %Status
{
	
	n (qHandle,beginDate,endDate,userCode)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
   // s userCode="fhq"
    
 	q:beginDate="" $$$OK
	q:endDate="" $$$OK
	q:userCode="" $$$OK
    s beginDate1= $p(beginDate,"-",1) _"M"_$p(beginDate,"-",2)
    s endDate1= $p(endDate,"-",1) _"M"_$p(endDate,"-",2)
    
    s ^tempzlg=beginDate_"^"_endDate_"^"_userCode
  /*
  s strsql=""
  s strsql= strsql _" select jj.* from ("
  s strsql= strsql _" SELECT BonusYear,BonusPeriod,b.SuperiorUnitID subUnitID,b.SuperiorUnitID->BonusUnitName supUnitName,b.BonusUnitName,(select BonusTargetName from dhc_bonus_data.BonusTarget"
  s strsql= strsql _" where BonusTargetCode='G99011') BonusTargetName ,sum(IncomeMoney) TargetValue "
  s strsql= strsql _" from  dhc_bonus_subs.BonusSubIncomeCollect a,dhc_bonus_data.BonusUnit b "
  s strsql= strsql _" where a.SickDeptCode =b.BonusUnitCode and b.BonusUnitTypeID in (13,19) and "
  s strsql= strsql _" IncomeItemCode='G99010'  and BonusYear _ BonusPeriod>='"_beginDate1_"' and BonusYear _ BonusPeriod<='"_endDate1_"'"
  s strsql= strsql _" group by BonusYear,BonusPeriod,b.SuperiorUnitID->BonusUnitCode,b.BonusUnitName"
  s strsql= strsql _" union all"
  s strsql= strsql _" SELECT BonusYear,BonusPeriod,c.SuperiorUnitID subUnitID,c.SuperiorUnitID->BonusUnitName supUnitName,c.BonusUnitName,(select BonusTargetName from dhc_bonus_data.BonusTarget where BonusTargetCode='G99012') BonusTargetID ,sum(IncomeMoney) TargetValue"
  s strsql= strsql _" from  dhc_bonus_subs.BonusSubIncomeCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnit c"
  s strsql= strsql _" where a.MakeBillDeptCode =b.BonusUnitCode and a.ExecuteDeptCode =c.BonusUnitCode"
  s strsql= strsql _" and b.SuperiorUnitID->BonusUnitID<>c.SuperiorUnitID->BonusUnitID"
  s strsql= strsql _" and c.BonusUnitTypeID in (13,19) and IncomeItemCode='G99010' and BonusYear _ BonusPeriod >='"_beginDate1_"' and BonusYear _ BonusPeriod <='"_endDate1_"'"
  s strsql= strsql _" group by BonusYear,BonusPeriod,c.SuperiorUnitID->BonusUnitCode,c.BonusUnitName"
  s strsql= strsql _" union all"
  s strsql= strsql _" SELECT BonusYear,BonusPeriod,b.SuperiorUnitID subUnitID,b.SuperiorUnitID->BonusUnitName supUnitName,b.BonusUnitName,(select BonusTargetName from dhc_bonus_data.BonusTarget where BonusTargetCode='G99013') BonusTargetID ,sum(IncomeMoney) TargetValue"
  s strsql= strsql _" from  dhc_bonus_subs.BonusSubIncomeCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnit c"
  s strsql= strsql _" where a.MakeBillDeptCode =b.BonusUnitCode and a.ExecuteDeptCode =c.BonusUnitCode"
  s strsql= strsql _" and b.SuperiorUnitID->BonusUnitID<>c.SuperiorUnitID->BonusUnitID"
  s strsql= strsql _" and b.BonusUnitTypeID in (13,19)   and c.BonusUnitTypeID in (13,19)   and IncomeItemCode='G99010' and BonusYear _ BonusPeriod >='"_beginDate1_"' and BonusYear _ BonusPeriod <='"_endDate1_"'"
  s strsql= strsql _" group by BonusYear,BonusPeriod,b.SuperiorUnitID->BonusUnitCode,b.BonusUnitName"
  s strsql= strsql _" ) jj ,dhc_bonus_data.BonusEmployeeUnit u where jj.subUnitID= u.BonusUnitID and u.BonusEmployeeID->EmployeeCode='"_userCode_"'"
 */
  s strsql=""
  s strsql= strsql _" select j.BonusYear, j.BonusPeriod ,j.supUnitName, j.BonusUnitName,sum( brValue) brValue, sum(bkValue) bkValue,sum(tkValue) tkValue from ("
  s strsql= strsql _" SELECT BonusYear,BonusPeriod,b.SuperiorUnitID subUnitID,b.SuperiorUnitID->BonusUnitName supUnitName,b.BonusUnitName,sum(IncomeMoney) brValue,0 bkValue,0 tkValue"
  s strsql= strsql _" from  dhc_bonus_subs.BonusSubIncomeCollect a,dhc_bonus_data.BonusUnit b "
  s strsql= strsql _" where a.SickDeptCode =b.BonusUnitCode and b.BonusUnitTypeID in (13,19) and "
  s strsql= strsql _" IncomeItemCode='G99010'  and BonusYear _ BonusPeriod>='"_beginDate1_"' and BonusYear _ BonusPeriod<='"_endDate1_"'"
  s strsql= strsql _" group by BonusYear,BonusPeriod,b.SuperiorUnitID->BonusUnitCode,b.BonusUnitName"
  s strsql= strsql _" union all"
  s strsql= strsql _" SELECT BonusYear,BonusPeriod,c.SuperiorUnitID subUnitID,c.SuperiorUnitID->BonusUnitName supUnitName,c.BonusUnitName,0 brValue ,sum(IncomeMoney) bkValue,0 tkValue"
  s strsql= strsql _" from  dhc_bonus_subs.BonusSubIncomeCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnit c"
  s strsql= strsql _" where a.MakeBillDeptCode =b.BonusUnitCode and a.ExecuteDeptCode =c.BonusUnitCode"
  s strsql= strsql _" and b.SuperiorUnitID->BonusUnitID<>c.SuperiorUnitID->BonusUnitID"
  s strsql= strsql _" and c.BonusUnitTypeID in (13,19) and IncomeItemCode='G99010' and BonusYear _ BonusPeriod >='"_beginDate1_"' and BonusYear _ BonusPeriod <='"_endDate1_"'"
  s strsql= strsql _" group by BonusYear,BonusPeriod,c.SuperiorUnitID->BonusUnitCode,c.BonusUnitName"
  s strsql= strsql _" union all"
  s strsql= strsql _" SELECT BonusYear,BonusPeriod,b.SuperiorUnitID subUnitID,b.SuperiorUnitID->BonusUnitName supUnitName,b.BonusUnitName,0 brValue,0 bkValue,sum(IncomeMoney) tkValue "
  s strsql= strsql _" from  dhc_bonus_subs.BonusSubIncomeCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnit c"
  s strsql= strsql _" where a.MakeBillDeptCode =b.BonusUnitCode and a.ExecuteDeptCode =c.BonusUnitCode"
  s strsql= strsql _" and b.SuperiorUnitID->BonusUnitID<>c.SuperiorUnitID->BonusUnitID"
  s strsql= strsql _" and b.BonusUnitTypeID in (13,19)   and c.BonusUnitTypeID in (13,19)   and IncomeItemCode='G99010' and BonusYear _ BonusPeriod >='"_beginDate1_"' and BonusYear _ BonusPeriod <='"_endDate1_"'"
  s strsql= strsql _" group by BonusYear,BonusPeriod,b.SuperiorUnitID->BonusUnitCode,b.BonusUnitName"
  s strsql= strsql _" ) j ,dhc_bonus_data.BonusEmployeeUnit u where j.subUnitID= u.BonusUnitID and u.BonusEmployeeID->EmployeeCode='"_userCode_"'"
  s strsql= strsql _" group by j.BonusYear, j.BonusPeriod ,j.supUnitName, j.BonusUnitName"

  //w strsql,!
  s result=##class(%Library.ResultSet).%New()
  d result.Prepare(strsql)
  d result.Execute()
		
 While(result.Next()){
      s BonusYear=result.Data("BonusYear")
      s BonusPeriod = result.Data("BonusPeriod")
      s BonusDate=BonusYear_"年"_$p(BonusPeriod,"M",2)_"月"
      
      s supUnitName=result.Data("supUnitName")
	  s BonusUnitName = result.Data("BonusUnitName")
	  
      // s BonusTargetName=result.Data("BonusTargetName")
      // s TargetValue=$fn(result.Data("TargetValue"),"",2)
      //0 brValue,0 bkValue,sum(IncomeMoney) tkValue
      
      s brValue=$fn(result.Data("brValue"),"",2)
      s bkValue=$fn(result.Data("bkValue"),"",2)
      s tkValue=$fn(result.Data("tkValue"),"",2)
      
	  s YearMonthName=beginDate_"至"_endDate
	  
	 d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
  	s Data=$lb(BonusDate,supUnitName,BonusUnitName,brValue,bkValue,tkValue)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod DeptIncomeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DeptIncomeDetailExecute ]
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

ClassMethod DeptIncomeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DeptIncomeDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:Zhao Liguo
/// CreatDate:2012-2-2
/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uDeptIncomeDetail","DeptIncomeDetail","2012-01","2012-02","fhq")  
Query DeptIncomeDetail(beginDate As %String, endDate As %String, userCode As %String) As %Query(ROWSPEC = "BonusDate:%String,supUnitName:%String,BonusUnitName:%String,brValue:%Float,bkValue:%Float,tkValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uDeptIncomeD6B0S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
