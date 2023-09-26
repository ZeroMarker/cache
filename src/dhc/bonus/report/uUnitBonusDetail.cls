/// Creator: 刘洋
/// CreatDate: 2011-1-26
/// Description: 绩效奖金发放报表
Class dhc.bonus.report.uUnitBonusDetail Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:刘洋
/// CreatDate:2011-1-26
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetCycle")
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

/// Creator:zhaoliguo
/// CreatDate:2011-3-24
/// Description:奖金方案查询
/// Table:dhc_bonus_data.BonusScheme
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetBonusScheme")
Query GetBonusScheme() As %SQLQuery(CONTAINID = 1)
{
	select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where IsValid=1 and  SchemeState=1
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
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

ClassMethod GetUserInfoExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	;s userCode="register"
	q:userCode="" $$$OK
	
	s userDr="",userName=""
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
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
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetUserInfo","register")
Query GetUserInfo(userCode As %String) As %Query(ROWSPEC = "userDr:%Integer,userName:%String") [ SqlProc ]
{
}

ClassMethod GetUnitInfoExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:userCode="" $$$OK
	/**
	s userDr=""
	//用户信息
	s userCode=$$ALPHAUP^SSUTIL4(userCode)
	//根据用户Code查找用户ID
	s userId=0
	s userDr=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,userDr))
	
	**/
	;s userCode="register"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusSchemeID,BonusEmployeeUnitID, BonusEmployeeID,BonusEmployeeID->EmployeeCode as code,a.BonusUnitID,a.BonusUnitID->SuperiorUnitID superUnitDr "_
	"   from dhc_bonus_data.BonusEmployeeUnit  a,dhc_bonus_data.BonusSchemeUnit b"
	s whereStr=" where a.BonusUnitID = b.BonusUnitID "	
	i userCode'="" d  s whereStr=whereStr_" and upper(BonusEmployeeID->EmployeeCode) =upper('"_userCode_"')"	
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	;w sqlStr,!
	
	While(result.Next()){
	
		s unitDr=result.Data("BonusUnitID")
		s BonusSchemeID=result.Data("BonusSchemeID")
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
	
 	s Data=$lb(BonusSchemeID,superUnitDr,unitDr,unitName)
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

ClassMethod GetUnitInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:核算单元
/// Input:userCode-用户代码
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetUnitInfo","register")
Query GetUnitInfo(userCode As %String) As %Query(ROWSPEC = "BonusSchemeID:%Integer,superUnitDr:%Integer,unitDr:%Integer,unitName:%String") [ SqlProc ]
{
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, frequency As %String, period As %Integer, unitDr As %String, BonusSID As %Integer) As %Status
{
	//BonusSchemeID As %Integer,
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:year="" $$$OK
	q:frequency="" $$$OK
	q:period="" $$$OK
	//q:BonusSupID="" $$$OK
	//q:BonusSID="" $$$OK
 	
 	s PeriodName="0"_period ,Period="",PName=""
 	
 	i frequency="M"  d
 	.i period<10 s PeriodName="0"_period
	.e  s PeriodName=period
	.s Period= frequency_PeriodName
	
	e  s Period= frequency_PeriodName
		
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select  BonusSchemeItemID,BonusYear,BonusPeriod,sum(BonusValue) BonusValue,BonusSchemeID->BonusSchemeName "
	s sqlStr = sqlStr_" ,BonusSchemeItemID->BonusFormulaDesc  ,BonusSchemeItemID->BonusType,BonusSchemeItemID->BonusItemTypeID   from dhc_bonus_data.UnitBonusDetail "
	s sqlStr = sqlStr_" WHERE %ID>0 and BonusSchemeID ='"_BonusSID_"' and BonusYear='"_year_"'and BonusPeriod='"_Period_"'"
	
	i unitDr'="" d
	.s sqlStr = sqlStr_ " and BonusUnitID='"_unitDr_"'" 
		
	s sqlStr = sqlStr_ " group by BonusSchemeItemID,BonusYear,BonusPeriod,BonusSchemeID->BonusSchemeName "
	
	s ^zlgtemp("report_sql")=sqlStr
	w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	S id=0
	
	s count=0
	s Formula=""
	s Formula=..GetFormula(year, Period, unitDr)
	;w Formula ,!
	While(result.Next()){
		s itemName=""
		s typeCode="",typeName=""
		
		s BonusSchemeName = result.Data("BonusSchemeName")
		s typeDr= result.Data("BonusItemTypeID")
		//s typeDr= result.Data("BonusSchemeItemID")
		i typeDr'="" d
		.i $D(^dhcbsBonusItemTypeD(typeDr)) d
		..i $G(^dhcbsBonusItemTypeD(typeDr))'="" d
		...s typeName=$List(^dhcbsBonusItemTypeD(typeDr),3)
		...s typeCode=$List(^dhcbsBonusItemTypeD(typeDr),2)
			
		s iDr= result.Data("BonusSchemeItemID")
	    i iDr'="" d
		.i $D(^dhcbsBonusSchemeItemD(iDr)) d
		..i $G(^dhcbsBonusSchemeItemD(iDr))'="" d
		...s itemName=$List(^dhcbsBonusSchemeItemD(iDr),4)
		
		s Value = result.Data("BonusValue")
		s count=count+1
		
		i unitDr="" s uDr = BonusSupID
		e  s uDr = unitDr
		
		i uDr'="" d
		.i $D(^dhcbsBonusUnitD(uDr)) d
		..i $G(^dhcbsBonusUnitD(uDr))'="" d
		...s unitName=$List(^dhcbsBonusUnitD(uDr),3)_BonusSchemeName_"奖金"
		
		d OutputRow
	}
	
	d result.Close()
 	q $$$OK
 	
OutputRow
	
 	s Data=$lb(typeName,itemName,Value,Formula,count,unitName)
 	
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
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetReport","2012","M","2",42,43)
Query GetReport(year As %Integer, frequency As %String, period As %Integer, unitDr As %String, BonusSID As %Integer) As %Query(ROWSPEC = "typeName:%String,itemName:%String,Value:%Float,Formula:%String,count:%Integer,unitName:%String") [ SqlProc ]
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
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetPeriodInfo","2010","Q","2")
Query GetPeriodInfo(year As %Integer, frequency As %String, period As %Integer) As %Query(ROWSPEC = "PeriodName:%String")
{
}

ClassMethod GetUnitExecute(ByRef qHandle As %Binary, unitDr As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	i unitDr'="" d
	.i $D(^dhcbsBonusUnitD(unitDr)) d
	..i $G(^dhcbsBonusUnitD(unitDr))'="" d
	...s unitName=$List(^dhcbsBonusUnitD(unitDr),3)
	
	d OutputUnitRow
	
 	q $$$OK
OutputUnitRow
	
 	s Data=$lb(unitName)
 	;w Data ,!
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnitExecute ]
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

ClassMethod GetUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:返回当前核算单元
/// Table:
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uUnitBonusDetail","GetUnit","91")
Query GetUnit(unitDr As %String) As %Query(ROWSPEC = "unitName:%String")
{
}

/// Creator:刘洋
/// CreatDate:2011-1-27
/// Description:查询公式
/// Table:dhc_bonus_data.BonusSchemeItem
/// Input:
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.report.uUnitBonusDetail).GetFormula()
ClassMethod GetFormula(year, Period, unitDr) As %String
{
	n (year, Period, unitDr)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitBonusDetailID, BonusSchemeItemID,BonusUnitID,BonusYear,BonusPeriod,BonusValue"
	s sqlStr = sqlStr_" ,BonusSchemeItemID->BonusFormulaDesc  ,BonusSchemeItemID->BonusType,BonusSchemeItemID->BonusItemTypeID   from dhc_bonus_data.UnitBonusDetail "
	
	s whereStr=" WHERE %ID>0"	
	i year'="" d  s whereStr=whereStr_" and BonusYear='"_year_"'"
	i Period'="" d  s whereStr=whereStr_" and BonusPeriod='"_Period_"'"
	i unitDr'="" d  s whereStr=whereStr_" and BonusUnitID='"_unitDr_"'"
	s sqlStr=sqlStr_whereStr
	d result.Prepare(sqlStr)
	d result.Execute()
	s name=""
	While(result.Next()){
		
		s BonusType = result.Data("BonusType")
		if (BonusType=1) d
		.s name = result.Data("BonusFormulaDesc")
		
	}
	q name
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uUnitBonusDe66FS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
