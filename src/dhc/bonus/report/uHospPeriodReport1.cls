/// Creator: 李明忠
/// CreatDate: 2011-08-18
/// Description: 全院期间报表（不分期）
Class dhc.bonus.report.uHospPeriodReport1 Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer, toPeriod As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	q:toPeriod="" $$$OK
 	
 	k ^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j)
 	k ^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j)
 	
 	//获取科室
 	s deptList=..getAllDept()
 	s Count=deptList.Count()
 	q:Count=0 $$$OK
 	
 	//获取日期,规整所有要查询数据的期间值
 	s periodList=##class(%Library.ListOfDataTypes).%New()
 	s periodHOSP="未知期间"
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
 	
 	//查询奖金项目明细数据^dhcbsUnitBonusDetailI("YearPeriodItem",2011,"M01",5,1,48,1171) = ""
 	s reportId=2
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
 	........s orders=..getOrder(reportId,itemDr) //获取序号
 	........s rowid=0
 	........f  s rowid=$O(^dhcbsUnitBonusDetailI("YearPeriodItem",year,periodName,locDr,schemDr,itemDr,rowid)) q:rowid=""  d
 	.........i $D(^dhcbsUnitBonusDetailD(rowid)) d
 	..........s itemValue=$fn($List(^dhcbsUnitBonusDetailD(rowid),8),"",4)
 	..........s ^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year,periodName,locDr,orders,itemName)=itemValue
 		
 	//处理临时Global中的数据
  	s count=0,totalItemValue=0
 	i $D(^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j)) d
 	.s year=0
 	.f  s year=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year)) q:year=""  d
 	..s periodName="" 
 	..f  s periodName=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year,periodName)) q:periodName=""  d
 	...s count=count+1
 	...s periodStr=$E(periodName,2)
 	...i periodStr=0 s periodDr=$E(periodName,3)
 	...i periodStr'=0 s periodDr=$E(periodName,2,3)
 	...s locDr=0
 	...f  s locDr=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year,periodName,locDr)) q:locDr=""  d
 	....s locName=$List(^dhcbsBonusUnitD(locDr),3)
 	....s orders=0
 	....f  s orders=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year,periodName,locDr,orders)) q:orders=""  d
 	.....s itemName="" 
 	.....f  s itemName=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year,periodName,locDr,orders,itemName)) q:itemName=""  d
 	......s itemValue=^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j,year,periodName,locDr,orders,itemName)
 	......i $D(^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)) d
 	.......s ^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)=^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)+itemValue
 	......e  d
 	.......s ^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)=itemValue
	
	//处理临时Global
	s periodDr=13,periodName="合计",period=period
	s locDr=0
	f  s locDr=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr)) q:locDr=""  d
	.s locName=$List(^dhcbsBonusUnitD(locDr),3)
	.s orders=0
	.f  s orders=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders)) q:orders=""  d
	..s itemName=""
	..f  s itemName=$O(^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)) q:itemName=""  d
	...i (itemName="预发比例")||(itemName="人数")||(itemName="分配比例")||(itemName="人平") d //该项目为比例项目
	....s itemValue=^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)/count
	...e  d
	....s itemValue=^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j,locDr,orders,itemName)
	...d OutputReport
	
	
	k ^DHCBSHospPeriodReport("dhc","bs","hospperiod1",$j)
	k ^DHCBSHospPeriodReport("dhc","bs","hospperiod1","total",$j)
 	q $$$OK
 		
OutputReport
	
 	s Data=$lb(periodDr,periodName,period,locDr,locName,itemName,orders,$fn(itemValue,"",4))
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
/// CreatDate:2011-08-18
/// Description:获取全院报表（不分期）
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHospPeriodReport1","GetReport","2011","M",1,1)
Query GetReport(year As %String, fre As %String, fromPeriod As %String, toPeriod As %String) As %Query(ROWSPEC = "periodDr:%Integer,periodName:%String,period:%String,locDr:%Integer,locName:%String,itemName:%String,orders:%Integer,itemValue:%Float")
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

ClassMethod getOrder(ReportId, itemDr) As %Integer
{
	n (ReportId,itemDr)
	
	s orders=0
	
	i $D(^dhcbsReportCellI("ReportItem",ReportId,itemDr)) d
	.s rowid=0
	.f  s rowid=$O(^dhcbsReportCellI("ReportItem",ReportId,itemDr,rowid)) q:rowid=""  d
	..s orders=$List(^dhcbsReportCellD(rowid),4)
	
	q orders
}

ClassMethod getAllDept() As %Library.ListOfDataTypes
{
	
	s deptList=##class(%Library.ListOfDataTypes).%New()
	
	s sqlStr="select BonusUnitID from dhc_bonus_data.BonusUnit where %ID>0 and superiorUnitID>0"
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
<StreamLocation>^dhc.bonus.r64E.uHospPeriodR71FS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}