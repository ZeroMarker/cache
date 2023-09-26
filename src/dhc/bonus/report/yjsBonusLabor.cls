/// 弋矶山劳务奖报表
Class dhc.bonus.report.yjsBonusLabor Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

Query BonusUnit(UserCode) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select a.BonusUnitID,a.BonusUnitName from dhc_bonus_data.BonusUnit a,dhc_bonus_data.BonusEmployeeUnit b
 where b.BonusUnitID=a.BonusUnitID and upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode) and a.IsValid=1
}

ClassMethod GetBonusLaborExecute(ByRef qHandle As %Binary, YearMonth As %String, BonusUnitID As %String, usercode As %String) As %Status
{
	
	n (qHandle,YearMonth,BonusUnitID,usercode)
	
	k ^now
	s ^now=YearMonth_"^"_BonusUnitID_"^"_usercode
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1
	
 	q:YearMonth="" $$$OK
 	q:BonusUnitID="" $$$OK
	q:usercode="" $$$OK
     
    s BonusYear=$P(YearMonth,"-",1) 
    s PERIOD="M"_$P(YearMonth,"-",2)
    
   
    s sqlStr="select a.BonusTargetID->BonusTargetCode as BonusTargetCode,a.BonusTargetID->BonusTargetName as BonusTargetName, "
			_" a.BonusUnitID->BonusUnitCode as BonusUnitCode,a.BonusUnitID->BonusUnitName as BonusUnitName, "
			_" sum(a.TargetValue) as TargetValue,a.UnitPrice,sum(a.TargetValue*a.UnitPrice) as je "
			_" from dhc_bonus_data.BonusTargetCollect a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusEmployeeUnit c "
 			_" where BonusTargetID->TargetTypeID->TargetTypeCode='02' "
			_" and a.BonusUnitID=b.BonusUnitID and b.BonusUnitID=c.BonusUnitID and a.BonusUnitID='"_BonusUnitID_"'"
			_" and upper(c.BonusEmployeeID->EmployeeCode)=upper('"_usercode_"') "
			_" and a.TargetValue<>0 and a.TargetValue is not null and a.UnitPrice <> 0 and a.UnitPrice is not null"
			_" and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"' "
    s sqlStr=sqlStr_" group by a.BonusTargetID,a.BonusUnitID,a.UnitPrice order by a.BonusUnitID asc"   
    ;w sqlStr,!
    k ^lwhtemp
    s ^lwhtemp=sqlStr
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
       s BonusTargetCode = result.Data("BonusTargetCode")
       s BonusTargetName = result.Data("BonusTargetName")
       s BonusUnitCode = result.Data("BonusUnitCode")
       s BonusUnitName = result.Data("BonusUnitName")
       s TargetValue = result.Data("TargetValue")
       s UnitPrice = result.Data("UnitPrice")
       s BonusLabor = result.Data("je")


     i (BonusTargetCode'="")&&(BonusTargetName'="") d
	 .d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(BonusTargetCode,BonusTargetName,BonusUnitCode,BonusUnitName,TargetValue,UnitPrice,BonusLabor,YearMonth)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusLaborFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusLaborExecute ]
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

ClassMethod GetBonusLaborClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusLaborExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusRegPerson","GetBonusLabor","2014-10","632","demo")
Query GetBonusLabor(YearMonth As %String, BonusUnitID As %String, usercode As %String) As %Query(ROWSPEC = "BonusTargetCode:%String,BonusTargetName:%String,BonusUnitCode:%String,BonusUnitName:%String,TargetValue:%Float,UnitPrice:%Float,BonusLabor:%Float,YearMonth:%String") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.re7006.yjsBonusLaborS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
