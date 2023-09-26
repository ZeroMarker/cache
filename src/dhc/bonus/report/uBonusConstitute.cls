/// Creator: 刘洋
/// CreatDate: 2011-2-11
/// Description: 科室奖金构成报表
Class dhc.bonus.report.uBonusConstitute Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:刘洋
/// CreatDate:2011-1-26
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusConstitute","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
}

/// Creator:赵立国
/// CreatDate:2011-5-26
/// Description:科室Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1)
{
	select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where UnitFlag=1 and LastStage=0 order by cast(BonusUnitCode as int)
}

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
	...s PeriodDr=m
	...i m<10 s PeriodName="0"_m_"月"
	...e  s PeriodName=m_"月"
	...d OutputRowPeriod 
	.i k=2 d
	..s Freq="Q"
	..f n=1:1:4 d
	...s PeriodDr=n
	...s PeriodName="0"_n_"季度"
	...d OutputRowPeriod 
	.i k=3 d
	..s Freq="H"
	..f l=1:1:2 d
	...s PeriodDr=l
	...i PeriodDr=1 s PeriodName="上半年"
	...i PeriodDr=2 s PeriodName="下半年"
	...d OutputRowPeriod
	.i k=4 d
	..s Freq="Y"
	..s PeriodDr=1
	..s PeriodName="全年"
	..d OutputRowPeriod
 
 	q $$$OK
OutputRowPeriod
	
 	s Data=$lb(Freq,PeriodDr,PeriodName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

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

/// Creator:刘洋
/// CreatDate:2011-1-26
/// Description:期间Query
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusConstitute","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

ClassMethod GetUserInfoExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:userCode="" $$$OK
	
	s userDr="",userName=""
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	;w userCode,!
	//根据用户Code查找用户ID
	s userId=0
	s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
	i userDr'="" d
	.i $D(^SSU("SSUSR",userDr)) d
	..i $G(^SSU("SSUSR",userDr))'="" d
	...s userName=$P(^SSU("SSUSR",userDr),"^",2)
	d OutputRowUserInfo
 
 	q $$$OK
OutputRowUserInfo
	
 	s Data=$lb(userDr,userName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserInfoExecute ]
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

ClassMethod GetUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:用户信息Query
/// Input:userCode-用户代码
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusConstitute","GetUserInfo","wangying")
Query GetUserInfo(userCode As %String) As %Query(ROWSPEC = "userDr:%Integer,userName:%String") [ SqlProc ]
{
}

ClassMethod GetUnitInfoExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	;s userCode="register"
	q:userCode="" $$$OK
	/**
	s userDr=""
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
	**/
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusUnitID->SuperiorUnitID superUnitDr,BonusEmployeeUnitID, BonusEmployeeID,BonusEmployeeID->EmployeeCode as code,BonusUnitID from dhc_bonus_data.BonusEmployeeUnit "
	s whereStr=" WHERE %ID>0"	
	i userCode'="" d  s whereStr=whereStr_" and BonusEmployeeID->EmployeeCode ='"_userCode_"'"	
	s sqlStr=sqlStr_whereStr
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
	
		s unitDr=result.Data("BonusUnitID")
		s superUnitDr = result.Data("superUnitDr")
		i unitDr'="" d
		.i $D(^dhcbsBonusUnitD(unitDr)) d
		..i $G(^dhcbsBonusUnitD(unitDr))'="" d
		...s unitName=$List(^dhcbsBonusUnitD(unitDr),3)
		d OutputRowUnitInfo
	}
	
	d result.Close()
 
 	q $$$OK
OutputRowUnitInfo
	
 	s Data=$lb(superUnitDr,unitDr,unitName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetUnitInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserInfoExecute ]
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

ClassMethod GetUnitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:核算单元
/// Input:userCode-用户代码
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusConstitute","GetUnitInfo","fhq")
Query GetUnitInfo(userCode As %String) As %Query(ROWSPEC = "superUnitDr:%Integer,unitDr:%Integer,unitName:%String") [ SqlProc ]
{
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, frequency As %String, period As %Integer, unitDr As %Integer, isPay As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	;q:frequency="" 
 	;q:year=""
 	;q:period=""
 	s PeriodName="0"_period ,Period="",PName=""
 	
 	i frequency="M"  d
 	.i period<10 s PeriodName="0"_period
	.e  s PeriodName=period
	.s Period= frequency_PeriodName
	
	e  s Period= frequency_PeriodName
		
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select  BonusSchemeItemID,BonusUnitID,BonusYear,BonusPeriod,BonusType,"_
	" BonusValue ,BonusSchemeID->BonusSchemeName ,BonusSchemeItemID->BonusItemTypeID->BonusItemTypeName "_
	"  from dhc_bonus_data.UnitBonusDetail "
	s sqlStr=sqlStr_" WHERE %ID>0 and BonusUnitID->LastStage=0 AND BonusUnitID->UnitFlag=1  "
	
	i isPay'=1 d  s sqlStr=sqlStr_" and BonusType !=1"	
	;i year'="" d  s sqlStr=sqlStr_" and BonusYear='"_year_"'"
	;i Period'="" d  s sqlStr=sqlStr_" and BonusPeriod='"_Period_"'"
	s sqlStr=sqlStr_" and BonusUnitID="_unitDr_""
	
	s sqlStr =sqlStr_ " union all select  BonusSchemeItemID,BonusUnitID->SuperiorUnitID BonusUnitID,BonusYear,BonusPeriod,BonusType,"_
	" sum(BonusValue) BonusValue ,BonusSchemeID->BonusSchemeName ,BonusSchemeItemID->BonusItemTypeID->BonusItemTypeName "_
	"  from dhc_bonus_data.UnitBonusDetail "
	s sqlStr=sqlStr_" WHERE %ID>0 and BonusUnitID->LastStage=0 AND BonusUnitID->UnitFlag=1 "
	
	;i isPay'=1 d  s sqlStr=sqlStr_" and BonusType !=1"	
	s sqlStr=sqlStr_" and BonusYear="_year_""
	s sqlStr=sqlStr_" and BonusPeriod='"_Period_"'"
	;i unitDr'="" d  s sqlStr=sqlStr_" and BonusUnitID='"_unitDr_"'"
	
	s sqlStr=sqlStr_" group by  BonusSchemeItemID,BonusUnitID->SuperiorUnitID ,BonusYear,BonusPeriod,BonusType,"_
	" BonusSchemeID->BonusSchemeName ,BonusSchemeItemID->BonusItemTypeID->BonusItemTypeName"
	
	//s whereStr=whereStr_" order  by BonusType desc  "


	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
			
		s iDr= result.Data("BonusSchemeItemID")
		s BonusSchemeName = result.Data("BonusSchemeName")
		s BonusItemTypeName= result.Data("BonusItemTypeName")
		s BonusType = result.Data("BonusType")
		
	    i iDr'="" d
		.i $D(^dhcbsBonusSchemeItemD(iDr)) d
		..i $G(^dhcbsBonusSchemeItemD(iDr))'="" d
		...s itemName=$List(^dhcbsBonusSchemeItemD(iDr),4)
		
		s Value = result.Data("BonusValue")
		
		s uDr = result.Data("BonusUnitID")
		i uDr'="" d
		.i $D(^dhcbsBonusUnitD(uDr)) d
		..i $G(^dhcbsBonusUnitD(uDr))'="" d
		...s unitName=$List(^dhcbsBonusUnitD(uDr),3)
		
		d OutputRow
	}
	
	d result.Close()
 	q $$$OK
 	
OutputRow
	
 	s Data=$lb(itemName,Value,uDr,unitName,BonusSchemeName,BonusItemTypeName,BonusType)
 	
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

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:查询报表数据记录
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusConstitute","GetReport",2012,"M",2,325,1)
Query GetReport(year As %Integer, frequency As %String, period As %Integer, unitDr As %Integer, isPay As %Integer) As %Query(ROWSPEC = "itemName:%String,Value:%Float,uDr:%String,unitName:%String,BonusSchemeName:%String,BonusItemTypeName:%String,BonusType:%String") [ SqlProc ]
{
}

ClassMethod GetPeriodInfoExecute(ByRef qHandle As %Binary, year As %Integer, frequency As %String, period As %Integer) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	s Period="",PName="",YName=""


	//返回期间
	i frequency="M"  d
	.i period<10 s PName="0"_period_"月",YName=year_"年"  
	.e  s PName=period_"月"  ,YName=year_"年"  
	s PeriodName =YName_PName
	
	
	i frequency="Q"  d
	.s PName="0"_period_"季度" ,YName=year_"年"  
	s PeriodName =YName_PName

	i frequency="H"  d
	.i period=1 s PName="上半年" ,YName=year_"年"  
	.i period=2 s PName="下半年" ,YName=year_"年"  
	s PeriodName =YName_PName
	
	i frequency="Y"  s PeriodName =year_"年"
	
	d OutputPeriodInfoRow
	
 	q $$$OK
OutputPeriodInfoRow
	
 	s Data=$lb(PeriodName)
 	;w Data ,!
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetPeriodInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPeriodInfoExecute ]
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

ClassMethod GetPeriodInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPeriodInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:返回当前核算区间
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusConstitute","GetPeriodInfo","2010","Q","2")
Query GetPeriodInfo(year As %Integer, frequency As %String, period As %Integer) As %Query(ROWSPEC = "PeriodName:%String")
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uBonusConsti6AES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
