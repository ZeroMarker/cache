/// Creator: 李明忠
/// CreatDate: 2011-12-31
/// Description: 华西科室奖金报表
Class dhc.bonus.report.uHXHospDeptReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-12-31
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDeptReport","GetCycle")
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
/// CreatDate:2011-12-31
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDeptReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

/// Creator：李明忠
/// CreatDate:2011-12-31
/// Description: 获取科室奖金方案下的科室
/// Table：dhc.bonus.data.BonusUnit
/// Others：w ##class(dhc.bonus.report.uHXHospDeptReport).GetDept()
ClassMethod GetDept(list As %Library.ListOfDataTypes) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select BonusUnitID from dhc_bonus_data.BonusUnit where BonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusSchemeUnit where BonusSchemeID=4)"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	While(result.Next()){
		s rowid = result.Data("BonusUnitID")
		d list.Insert(rowid)
	}
	
	q list
}

/// Creator:李明忠
/// CreatDate:2011-12-31
/// Description:获取科室奖金方案下的科室
/// Table:dhc_bonus_data.BonusUnit
/// Others:w ##class(dhc.bonus.report.uHXHospDeptReport).GetDeptList()
ClassMethod GetDeptList(deptId) As %Library.ListOfDataTypes
{
	s deptList=##class(%Library.ListOfDataTypes).%New()
	
	i deptId'="" d
	.d deptList.Insert(deptId)
	e  d
	.s deptList=..GetDept(deptList)
	
	q deptList
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	
 	k ^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j)
 	
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
 	
 	
 	//查询科室奖酬金数据
 	s deptList = ..GetDeptList("")
 	s deptCount = deptList.Count()
 	
 	//获取项目
 	s reportId=5
 	s itemList=..GetItemList(reportId)
 	s count = periodList.Count()
 	q:count=0 $$$OK
 	
 	f k=1:1:deptCount d //遍历科室
 	.s deptId=deptList.GetAt(k)
 	.i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year)) d
 	..f i=1:1:count d
 	...s periodName = periodList.GetAt(i)
 	...i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName)) d
 	....i $D(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,deptId)) d
 	.....s schemDr=0
 	.....f  s schemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,deptId,schemDr)) q:schemDr=""  d
 	......s itemDr=0
 	......f  s itemDr=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,deptId,schemDr,itemDr)) q:itemDr=""  d
 	.......i itemList.Find(itemDr,1) d
 	........s itemName=$List(^dhcbsBonusSchemeItemD(itemDr),4)
 	........s orders=..getOrder(reportId,itemDr)
 	........s rowid=0
 	........f  s rowid=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,deptId,schemDr,itemDr,rowid)) q:rowid=""  d
 	.........i $D(^dhcbsUnitBonusDetailD(rowid)) d
 	..........s itemValue=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",2)
 	..........;w year_"^"_periodName_"^"_deptId_"^"_schemDr_"^"_itemDr_"^"_itemName_"^"_itemValue,!
 	..........i $D(^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders,itemName)) d
 	...........s ^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders,itemName)=^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders,itemName)+itemValue
 	..........e  d
 	...........s ^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders,itemName)=itemValue
 
 	//处理临时Global中的数据
 	i $D(^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j)) d
 	.s deptId=0
 	.f  s deptId=$O(^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId)) q:deptId=""  d
 	..s deptCode="",deptName="未知科室"
 	..i $D(^dhcbsBonusUnitD(deptId)) d
 	...s deptCode = $List(^dhcbsBonusUnitD(deptId),2)
 	...s deptName = $List(^dhcbsBonusUnitD(deptId),3)
 	...s orders="" 
 	...f  s orders=$O(^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders)) q:orders=""  d
  	....s itemName="" 
 	....f  s itemName=$O(^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders,itemName)) q:itemName=""  d
 	.....s itemValue=^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j,deptId,orders,itemName)
 	.....;w itemValue,!
 	.....d OutputReport
	
	k ^DHCBSHXHospDeptReport("dhc","bs","hxHospDept",$j)
 	q $$$OK
 	
OutputReport
	
 	s Data=$lb(period,deptId,deptCode,deptName,itemName,orders,itemValue)
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
/// CreatDate:2011-12-31
/// Description:科室奖金核算报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDeptReport","GetReport","2011","M",11)
Query GetReport(year As %String, fre As %String, fromPeriod As %String) As %Query(ROWSPEC = "period:%String,deptId:%Integer,deptCode:%String,deptName:%String,itemName:%String,orders:%Integer,itemValue:%Float")
{
}

/// w ##class(dhc.bonus.report.uHXHospDeptReport).GetItemList(1)
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

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uHXHospDeptR6B8S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
