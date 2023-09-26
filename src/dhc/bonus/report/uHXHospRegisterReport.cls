/// Creator: 李明忠
/// CreatDate: 2011-11-03
/// Description: 全院科室、人员挂号报表
Class dhc.bonus.report.uHXHospRegisterReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-11-03
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospRegisterReport","GetCycle")
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
/// CreatDate:2011-11-03
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospRegisterReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer, deptId As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	
 	s personList=..getAllPerson(deptId)
 	s Count=personList.Count()
 	q:Count=0 $$$OK
 	
 	
 	k ^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j)
 	s toPeriod = fromPeriod
 	//获取日期,规整所有要查询数据的期间值
 	s periodList=##class(%Library.ListOfDataTypes).%New()
 	s period="未知期间"
 	i fre="M" d //查询期间为月份的
 	.s period=year_"年"_fromPeriod_"月份到"_year_"年"_toPeriod_"月份"
 	.i fromPeriod<=toPeriod d
 	..i fromPeriod<toPeriod d //期间不相等
 	...s len=toPeriod-fromPeriod+1
 	...f i=1:1:len d
 	....s month=fromPeriod+i-1
 	....i month<10 s newPeriod = fre_"0"_month
 	....e  s newPeriod = fre_month
 	....d periodList.Insert(newPeriod)
 	..e  d //期间相等
 	...i fromPeriod<10 s newPeriod = fre_"0"_fromPeriod
	...e  s newPeriod = fre_fromPeriod
	...d periodList.Insert(newPeriod)
 	
 	
 	//查询人员挂号明细数据
 	s reportId=1
 	s itemList=..GetItemList(reportId)
 	s count = periodList.Count()
 	q:count=0 $$$OK
 	f k=1:1:Count d //遍历人员
 	.s personDr=personList.GetAt(k)
 	.s locDr=..getPersonSuper(personDr,deptId) //获取人员的上级
 	.i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year)) d
 	..f i=1:1:count d
 	...s periodName = periodList.GetAt(i)
 	...i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName)) d
 	....i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,personDr)) d
 	.....s schemDr=0
 	.....f  s schemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,personDr,schemDr)) q:schemDr=""  d
 	......s itemDr=0
 	......f  s itemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,personDr,schemDr,itemDr)) q:itemDr=""  d
 	.......i itemList.Find(itemDr,1) d
 	........s itemName=$List(^dhcbsBonusSchemeItemD(itemDr),4)
 	........;w year_"^"_periodName_"^"_personDr_"^"_schemDr_"^"_itemDr_"^"_itemName,!
 	........s orders=..getOrder(reportId,itemDr)
 	........s rowid=0
 	........f  s rowid=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,personDr,schemDr,itemDr,rowid)) q:rowid=""  d
 	.........i $D(^dhcbsUnitBonusDetailD(rowid)) d
 	..........s itemValue=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",2)
 	..........;w itemValue,!
 	..........i $D(^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders,itemName)) d
 	...........s ^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders,itemName)=^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders,itemName)+itemValue
 	..........e  d
 	...........s ^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders,itemName)=itemValue
 		
 	//处理临时Global中的数据
 	i $D(^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j)) d
 	.s locDr=0
 	.f  s locDr=$O(^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr)) q:locDr=""  d
 	..s locName="未知科室"
 	..i $D(^dhcbsBonusUnitD(locDr)) d
 	...s locName = $List(^dhcbsBonusUnitD(locDr),3)
 	..s personDr=""
 	..f  s personDr=$O(^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr)) q:personDr=""  d
 	...s personName="未知人员"
 	...i $D(^dhcbsBonusUnitD(personDr)) d
 	....s personName = $List(^dhcbsBonusUnitD(personDr),3)
 	...s orders="" 
 	...f  s orders=$O(^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders)) q:orders=""  d
  	....s itemName="" 
 	....f  s itemName=$O(^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders,itemName)) q:itemName=""  d
 	.....s itemValue=^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j,locDr,personDr,orders,itemName)
 	.....d OutputReport
 
	
	k ^DHCBSHXHospRegisterReport("dhc","bs","hxHospRegister",$j)
 	q $$$OK
 	
OutputReport
	
 	s Data=$lb(period,locDr,locName,personDr,personName,itemName,orders,itemValue)
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
/// CreatDate:2011-11-3
/// Description:获取全院科室、人员挂号报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospRegisterReport","GetReport","2011","M",9,121)
Query GetReport(year As %String, fre As %String, fromPeriod As %String, deptId As %Integer) As %Query(ROWSPEC = "period:%String,locDr:%Integer,locName:%String,personDr:%Integer,personName:%String,itemName:%String,orders:%Integer,itemValue:%Float")
{
}

/// w ##class(dhc.bonus.report.uHXHospRegisterReport).GetItemList(1)
ClassMethod GetItemList(ReportId) As %Library.ListOfDataTypes
{
	n (ReportId)
	
	s itemList=##class(%Library.ListOfDataTypes).%New()
	q:ReportId="" itemList
	
	i $D(^dhcbsReportCellI("ReportItem",ReportId)) d
	.s itemDr=0
	.f  s itemDr=$O(^dhcbsReportCellI("ReportItem",ReportId,itemDr)) q:itemDr=""  d
	..d itemList.Insert(itemDr)
	
	q itemList
}

ClassMethod getOrder(ReportId, itemDr) As %Library.ListOfDataTypes
{
	n (ReportId,itemDr)
	
	s orders=0
	
	i $D(^dhcbsReportCellI("ReportItem",ReportId,itemDr)) d
	.s rowid=0
	.f  s rowid=$O(^dhcbsReportCellI("ReportItem",ReportId,itemDr,rowid)) q:rowid=""  d
	..s orders=$List(^dhcbsReportCellD(rowid),4)
	
	q orders
}

/// deptId ：大科ID
/// w ##class(dhc.bonus.report.uHXHospRegisterReport).getAllPerson()
ClassMethod getAllPerson(deptId) As %Library.ListOfDataTypes
{
	s personList=##class(%Library.ListOfDataTypes).%New()
	s sqlStr=""
	i deptId="" d //全部查询
	.s sqlStr="select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where %ID>0 and superiorUnitID>0 and LastStage=1"
	e  d // 查询相关科室的人员
	.s sqlStr="select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where %ID>0 and superiorUnitID in (select BonusUnitID from dhc_bonus_data.BonusUnit where superiorUnitID="_deptId_") and LastStage=1"
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("BonusUnitID")
		d personList.Insert(rowid)
	}
	
	q personList
}

/// 获取人员的上级,即末级科室
/// w ##class(dhc.bonus.report.uHXHospRegisterReport).getPersonSuper(534)
ClassMethod getPersonSuper(personId, deptId) As %Library.ListOfDataTypes
{
	n (personId,deptId)
	
	s superId=0
	i deptId'="" d
	.s superId = deptId
	e  d
	.s superId = ..GetPersonUp(personId)
	
	q superId
}

/// w ##class(dhc.bonus.report.uHXHospRegisterReport).getPersonSuper(534)
ClassMethod GetPersonUp(personId) As %Library.ListOfDataTypes
{
	n (personId)
	
	s superId=0
	q:personId="" superId
	
	s sqlStr="select BonusUnitID from dhc_bonus_data.BonusUnit where BonusUnitID=(select SuperiorUnitID from dhc_bonus_data.BonusUnit where BonusUnitID=(select SuperiorUnitID from dhc_bonus_data.BonusUnit where %ID="_personId_"))"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("SuperiorUnitID")
		s superId=rowid
	}
	
	q superId
}

/// Creator:李明忠
/// CreatDate:2011-11-04
/// Description:大科Query
/// Table:dhc_bonus_data.BonusUnit
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospRegisterReport","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1)
{
	select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where UnitLevel=2 and SuperiorUnitID=6
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uHXHospRegis870S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
