Class dhc.bonus.report.uBonusRegPerson Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// 医生挂号工作量报表
/// Description:期间Query
/// Table:
/// Others:
ClassMethod GetPeriodExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s Freq="",PeriodDr="",PeriodName=""
	
	s FreqLen=4
	f k=1:1:FreqLen d
	.i k=1 d
	..s Freq="M"
	..f m=1:1:12 d
	...i m<10 s PeriodDr="0"_m
	...e  s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr="0"_n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr="0"_l
	...i PeriodDr="01" s PeriodName="上半年"
	...i PeriodDr="02" s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr="00"
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

/// Description:期间Query
/// Table:
/// Others:
ClassMethod GetPeriodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodExecute ]
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

ClassMethod GetPeriodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusRegPerson","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

//

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusRegPerson","SchemePeriod")
Query SchemePeriod() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where BonusPeriod like 'Y%'
}

/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusRegPerson","UnitType")
Query UnitType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT BonusUnitTypeID,UnitTypeName from  dhc_bonus_data.BonusUnitType WHERE BonusUnitTypeID>0 and IsValid=1
}

//and SchemeState=1

Query BonusUnit(UserCode) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select a.BonusUnitID,a.BonusUnitName from dhc_bonus_data.BonusUnit a,dhc_bonus_data.BonusEmployeeUnit b
 where b.BonusUnitID=a.BonusUnitID and upper(b.BonusEmployeeID->EmployeeCode)=upper(:UserCode) and a.IsValid=1
}

ClassMethod GetBonusRegPersonExecute(ByRef qHandle As %Binary, YearMonth As %String, BonusUnitID As %String, usercode As %String) As %Status
{
	
	n (qHandle,YearMonth,BonusUnitID,usercode)
	;s ^lwhtemp1="qq"
	;s ^lwhtemp=qHandle_"^"_BonusYear_"^"_frequency_"^"_period_"^"_BonusUnitID_"^"_usercode
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
    Set ind=1

 	q:YearMonth="" $$$OK
	;q:frequency="" $$$OK
	;q:period="" $$$OK
	;q:BonusUnitID="" $$$OK
	q:usercode="" $$$OK
     
    s BonusYear=$P(YearMonth,"-",1) 
    s PERIOD="M"_$P(YearMonth,"-",2)
    s YearMonthName=$P(YearMonth,"-",1)_"年"_$P(YearMonth,"-",2)_"月"
   
    s sqlStr=" select SuperiorUnitID->BonusUnitName as DeptName,a.BonusUnitCode as DocCode, "
    		_" a.BonusUnitName as DocName,ExpenItemName,ItemValue,ItemNum,ItemPrice from dhc_bonus_subs.BonusSubExpendCollect a, "
			_" dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusEmployeeUnit c "
			_" where a.ExecuteDeptCode=b.BonusUnitCode and b.SuperiorUnitID=c.BonusUnitID "
			_" and  upper(c.BonusEmployeeID->EmployeeCode)=upper('"_usercode_"') " 
			_" and BonusYear='"_BonusYear_"' and BonusPeriod='"_PERIOD_"' "
    i BonusUnitID'="" s sqlStr=sqlStr_" and c.BonusUnitID='"_BonusUnitID_"'"
    s sqlStr=sqlStr_" order by c.BonusUnitID asc"   
    ;w sqlStr,!
    
    s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
		
 While(result.Next()){
       s DeptName = result.Data("DeptName")
       s DocCode = result.Data("DocCode")
       s DocName = result.Data("DocName")
       s ExpenItemName = result.Data("ExpenItemName")
       s ItemValue = result.Data("ItemValue")
       s ItemNum = result.Data("ItemNum")
       s ItemPrice = result.Data("ItemPrice")


     i (DocCode'="")&&(DocName'="") d
	 .d OutputRow28
	  
	} 
   	  
  	q $$$OK
OutputRow28
	
  
  	s Data=$lb(YearMonthName,DeptName,DocCode,DocName,ExpenItemName,ItemValue,ItemNum,ItemPrice)
    s ^CacheTemp(repid,ind)=Data 
 	s ind=ind+1
	q
}

ClassMethod GetBonusRegPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBonusRegPersonExecute ]
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

ClassMethod GetBonusRegPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBonusRegPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description:查询报表数据记录
/// Table:
/// others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusRegPerson","GetBonusRegPerson","2014-03","25","6666")
Query GetBonusRegPerson(YearMonth As %String, BonusUnitID As %String, usercode As %String) As %Query(ROWSPEC = "YearMonthName:%String,DeptName:%String,DocCode:%String,DocName:%String,ExpenItemName:%String,ItemValue:%Float,ItemNum:%Integer,ItemPrice:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus7006.uBonusRegPeE171S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
