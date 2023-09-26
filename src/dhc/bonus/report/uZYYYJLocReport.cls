/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description: 北京中医院医技科室报表
Class dhc.bonus.report.uZYYYJLocReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description:年度Query
/// Table:dhc_bonus_data.SchemePeriod
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uZYYYJLocReport","GetCycle")
Query GetCycle() As %SQLQuery(CONTAINID = 1)
{
	select SchemePeriodID,BonusYear from dhc_bonus_data.SchemePeriod where SchemePeriodID>0 and BonusPeriod='Y00'  order by BonusYear desc
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

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uZYYYJLocReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String") [ SqlProc ]
{
}

/// Creator:李明忠
/// CreatDate:2012-3-13
/// Description:奖金方案查询
/// Table:dhc_bonus_data.BonusScheme
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uZYYYJLocReport","GetBonusScheme")
Query GetBonusScheme() As %SQLQuery(CONTAINID = 1)
{
	select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where IsValid=1 and  SchemeState=1 and SchemeType=3
}

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description: 获取医技方案
/// w ##class(dhc.bonus.report.uZYYYJLocReport).Find()
ClassMethod Find(list, mappStr) As %String
{
	n (list,mappStr)
	
	s flag="false"
	s count=list.Count()
	q:count=0 flag
	q:mappStr="" flag
	
	f i=1:1:count q:flag="true"  d
	.s str=list.GetAt(i)
	.i str=mappStr d
	..s flag="true"
	
	q flag
}

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description: 获取医技方案
/// w ##class(dhc.bonus.report.uZYYYJLocReport).getDeptOfUser("register")
ClassMethod getDeptOfUser(userCode) As %String
{
	n (userCode)
	q:userCode="" ""
	s str=""
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusUnitID from dhc_bonus_data.BonusUnit where BonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusEmployeeUnit where BonusEmployeeID=(select BonusEmployeeID from dhc_bonus_data.BonusEmployee where EmployeeCode='"_userCode_"'))"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next()){
		s id = result.Data("BonusUnitID")
		i str="" s str=id
		e  s str=str_"^"_id
	}
	
	q str
}

ClassMethod GetDeptExecute(ByRef qHandle As %Binary, userCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	q:userCode="" $$$OK
	
	//定义存储小科的集合List
	s deptList=##class(%Library.ListOfDataTypes).%New()
	s deptDrStr=..getDeptOfUser(userCode)
	s length=$L(deptDrStr,"^")
	f j=1:1:length d
	.d deptList.Insert($P(deptDrStr,"^",j))
	
	//1.获取方案
	s schemStr=..getYJSchems()
	q:schemStr="" $$$OK
	
	s Len=$L(schemStr,"^")
	f i=1:1:Len d
	.s schemDr=$P(schemStr,"^",i)
	.s deptStr=..getDepts(schemDr)
	.s deptLen=$L(deptStr,"^")
	.f k=1:1:deptLen d
	..s deptDr=$P(deptStr,"^",k)
	..;根据用户对科室的权限进行科室帅选
	..w deptDr,!
	..s flag=..Find(deptList,deptDr)
	..i flag="true" d
	...s deptName=$List(^dhcbsBonusUnitD(deptDr),3)
	...d OutPutDept
	
 	q $$$OK
OutPutDept
	
 	s Data=$lb(schemDr,deptDr,deptName)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDeptExecute ]
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

ClassMethod GetDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDeptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description: 科室Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uZYYYJLocReport","GetDept","register")
Query GetDept(userCode) As %Query(ROWSPEC = "schemDr:%Integer,deptDr:%Integer,deptName:%String") [ SqlProc ]
{
}

/// Creator:李明忠
/// CreatDate:2012-3-13
/// Description:获取有效方案
/// Others:w ##class(dhc.bonus.report.uZYYYJLocReport).getSchems()
ClassMethod getSchems() As %String
{
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusSchemeID,BonusSchemeName from dhc_bonus_data.BonusScheme where IsValid=1 and  SchemeState=1")
	d result.Execute()	

	s str=""
	//取结构
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		i rowid'="" d
		.i str="" d
		..s str=rowid
		.e  d
		..s str=str_"^"_rowid
	}
	
	q str
}

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description: 获取医技方案
/// w ##class(dhc.bonus.report.uZYYYJLocReport).getYJSchems()
ClassMethod getYJSchems()
{
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusSchemeID from dhc_bonus_data.BonusScheme where IsValid=1 and  SchemeState=1 and SchemeType=3")
	d result.Execute()	

	s str=""
	//取结构
	While(result.Next()){
		s rowid = result.Data("BonusSchemeID")
		i rowid'="" d
		.i str="" d
		..s str=rowid
		.e  d
		..s str=str_"^"_rowid
	}
	
	q str
}

/// Creator:李明忠
/// CreatDate:2012-3-13
/// Description:根据方案获取核算科室
/// Others:w ##class(dhc.bonus.report.uZYYYJLocReport).getDepts(43)
ClassMethod getDepts(schemDr) As %String
{
	n (schemDr)
	s str=""
	q:schemDr="" str
	
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare("select BonusUnitID from dhc_bonus_data.BonusSchemeUnit where BonusSchemeID="_schemDr)
	d result.Execute()	

	s str=""
	//取结构
	While(result.Next()){
		s unitId = result.Data("BonusUnitID")
		i unitId'="" d
		.i str="" d
		..s str=unitId
		.e  d
		..s str=str_"^"_unitId
	}
	
	q str
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %Integer, fre As %String, period As %Integer, schemDr As %Integer, unitDr As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	q:year="" $$$OK
	q:fre="" $$$OK
	q:period="" $$$OK
	q:schemDr="" $$$OK
	q:unitDr="" $$$OK
	
	k ^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j)
 	
 	s toPeriod = period
 	//获取日期,规整所有要查询数据的期间值
 	s periodList=##class(%Library.ListOfDataTypes).%New()
 	s periodStr="未知期间"
 	i fre="M" d //查询期间为月份的
 	.s periodStr=year_"年"_period_"月份"
 	.i period<=toPeriod d
 	..i period<toPeriod d //期间不相等
 	...s len=toPeriod-period+1
 	...f i=1:1:len d
 	....s month=period+i-1
 	....i month<10 s newPeriod = fre_"0"_month
 	....e  s newPeriod = fre_month
 	....d periodList.Insert(newPeriod)
 	..e  d //期间相等
 	...i period<10 s newPeriod = fre_"0"_period
	...e  s newPeriod = fre_period
	...d periodList.Insert(newPeriod)
 	
 	
 	//获取项目
 	s count = periodList.Count()
 	q:count=0 $$$OK
 	s orders=0
 	
 	i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year)) d
 	.f i=1:1:count d
 	..s periodName = periodList.GetAt(i)
 	..i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName)) d
 	...i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,unitDr)) d
 	....s schemDr=0
 	....f  s schemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,unitDr,schemDr)) q:schemDr=""  d
 	.....s itemDr=0
 	.....f  s itemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,unitDr,schemDr,itemDr)) q:itemDr=""  d
 	......s itemName=$List(^dhcbsBonusSchemeItemD(itemDr),4)
 	......s orders=orders+1
 	......s rowid=0
 	......f  s rowid=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,unitDr,schemDr,itemDr,rowid)) q:rowid=""  d
 	.......i $D(^dhcbsUnitBonusDetailD(rowid)) d
 	........s itemValue=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",2)
 	........;w year_"^"_periodName_"^"_unitDr_"^"_schemDr_"^"_itemDr_"^"_itemName_"^"_itemValue,!
 	........i $D(^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders,itemName)) d
 	.........s ^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders,itemName)=^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders,itemName)+itemValue
 	........e  d
 	.........s ^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders,itemName)=itemValue
 
 
 	//处理临时Global中的数据
 	i $D(^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j)) d
 	.s unitDr=0
 	.f  s unitDr=$O(^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr)) q:unitDr=""  d
 	..s deptCode="",deptName="未知科室"
 	..i $D(^dhcbsBonusUnitD(unitDr)) d
 	...s deptName = $List(^dhcbsBonusUnitD(unitDr),3)
 	...s orders="" 
 	...f  s orders=$O(^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders)) q:orders=""  d
  	....s itemName="" 
 	....f  s itemName=$O(^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders,itemName)) q:itemName=""  d
 	.....s itemValue=^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j,unitDr,orders,itemName)
 	.....;w itemValue,!
 	.....d OutPutReport
	
	k ^DHCBSZYYYJLocReport("dhc","bs","zyyYJLoc",$j)
	
 	q $$$OK
OutPutReport
	
 	s Data=$lb(periodStr,unitDr,deptName,orders,itemName,itemValue)
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

/// Creator:李明忠
/// CreatDate: 2012-3-13
/// Description: 报表Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uZYYYJLocReport","GetReport",,,,,)
Query GetReport(year As %Integer, fre As %String, period As %Integer, schemDr As %Integer, unitDr As %Integer) As %Query(ROWSPEC = "periodStr:%String,unitDr:%Integer,deptName:%String,orders:%Integer,itemName:%String,itemValue:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uZYYYJLocRep5BES</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
