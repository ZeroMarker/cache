/// Creator: 李明忠
/// CreatDate: 2011-09-25
/// Description: 全院医技科室门诊收入报表
Class dhc.bonus.report.uHospYJOutReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-09-25
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospYJOutReport","GetCycle")
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
/// CreatDate:2011-09-25
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospYJOutReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer, toPeriod As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	q:toPeriod="" $$$OK
 	
 	s deptList=..getYJAllDept()
 	s Count=deptList.Count()
 	q:Count=0 $$$OK
 	
 	
 	k ^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j)
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
 	
 	//查询医技科室明细数据
 	s reportId=14
 	s itemList=..GetItemList(reportId)
 	s count = periodList.Count()
 	q:count=0 $$$OK
 	f k=1:1:Count d //遍历科室
 	.s locDr=deptList.GetAt(k)
 	.i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year)) d
 	..f i=1:1:count d
 	...s periodName = periodList.GetAt(i)
 	...i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName)) d
 	....i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,locDr)) d
 	.....s schemDr=0
 	.....f  s schemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,locDr,schemDr)) q:schemDr=""  d
 	......s itemDr=0
 	......f  s itemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,locDr,schemDr,itemDr)) q:itemDr=""  d
 	.......i itemList.Find(itemDr,1) d
 	........s itemName=$List(^dhcbsBonusSchemeItemD(itemDr),4)
 	........s orders=..getOrder(reportId,itemDr)
 	........s rowid=0
 	........f  s rowid=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,locDr,schemDr,itemDr,rowid)) q:rowid=""  d
 	.........i $D(^dhcbsUnitBonusDetailD(rowid)) d
 	..........s itemValue=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",2)
 	..........i $D(^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders,itemName)) d
 	...........s ^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders,itemName)=^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders,itemName)+itemValue
 	..........e  d
 	...........s ^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders,itemName)=itemValue
 		
 	//处理临时Global中的数据
 	i $D(^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j)) d
 	.s locDr=0
 	.f  s locDr=$O(^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr)) q:locDr=""  d
 	..s locName="未知科室"
 	..i $D(^dhcbsBonusUnitD(locDr)) d
 	...s locName = $List(^dhcbsBonusUnitD(locDr),3)
 	..s orders="" 
 	..f  s orders=$O(^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders)) q:orders=""  d
  	...s itemName="" 
 	...f  s itemName=$O(^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders,itemName)) q:itemName=""  d
 	....s itemValue=^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j,locDr,orders,itemName)
 	....d OutputReport
 
	
	k ^DHCBSHospYJOutPeriodReport("dhc","bs","hospYJOutperiod",$j)
 	q $$$OK
 	
OutputReport
	
 	s Data=$lb(period,locDr,locName,itemName,orders,itemValue)
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
/// CreatDate:2011-09-25
/// Description:获取全院医技科室门诊收入报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospYJOutReport","GetReport","2011","M",1,1)
Query GetReport(year As %String, fre As %String, fromPeriod As %String, toPeriod As %String) As %Query(ROWSPEC = "period:%String,locDr:%Integer,locName:%String,itemName:%String,orders:%Integer,itemValue:%Float")
{
}

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

ClassMethod getYJAllDept() As %Library.ListOfDataTypes
{
	
	s deptList=##class(%Library.ListOfDataTypes).%New()
	
	;s sqlStr="select BonusUnitID from dhc_bonus_data.BonusUnit where %ID>0 and superiorUnitID=2"
	s sqlStr="select BonusUnitID from dhc_bonus_data.BonusUnit where %ID>0 and superiorUnitID=2 and BonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusSchemeUnit where BonusSchemeID=6)"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s rowid=result.Data("BonusUnitID")
		d deptList.Insert(rowid)
	}
	
	q deptList
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uHospYJOutRe666S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
