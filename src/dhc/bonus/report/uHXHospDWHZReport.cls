/// Creator: 李明忠
/// CreatDate: 2011-12-14
/// Description: 华西对外会诊报表
Class dhc.bonus.report.uHXHospDWHZReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-12-14
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDWHZReport","GetCycle")
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
/// CreatDate:2011-12-14
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDWHZReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

/// deptId ：大科ID
/// w ##class(dhc.bonus.report.uHXHospDWHZReport).getAllPerson()
ClassMethod getAllPerson(deptId) As %Library.ListOfDataTypes
{
	n (deptId)
	
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

/// w ##class(dhc.bonus.report.uHXHospDWHZReport).getDeptInfo(159)
ClassMethod getDeptInfo(deptId) As %String
{
	n (deptId)
	
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select BonusUnitCode,BonusUnitName from dhc_bonus_data.BonusUnit where %ID="_deptId
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s infoStr=""
	
	While(result.Next())
	{
		s deptInfo=result.Data("BonusUnitCode")_"^"_result.Data("BonusUnitName")
	}
	
	q deptInfo
}

/// 获取人员的上级,即末级科室
/// w ##class(dhc.bonus.report.uHXHospDWHZReport).getPersonSuper(534)
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

/// w ##class(dhc.bonus.report.uHXHospDWHZReport).getPersonSuper(534)
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
/// CreatDate:2011-12-14
/// Description:大科Query
/// Table:dhc_bonus_data.BonusUnit
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDWHZReport","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1)
{
	select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where UnitLevel=2 and SuperiorUnitID=6
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer, deptId As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	q:deptId="" $$$OK
 	
 	s personList=..getAllPerson(deptId)
 	s Count=personList.Count()
 	;w Count,!
 	q:Count=0 $$$OK
 	
 	k ^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j)
 	
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
	
 	s count = periodList.Count()
 	q:count=0 $$$OK
 	
 	s paramPeriod=fre_fromPeriod
 	
 	//查询人员对外会诊数据
 	s dwhzTargetId="40^41"
 	s targetCount=$L(dwhzTargetId,"^")
 	
 	f k=1:1:Count d //遍历人员
 	.s personDr=personList.GetAt(k)
 	.s personDWHZInfo=..getPersonDWHZInfo(personDr,dwhzTargetId,year,paramPeriod)
 	.f i=1:1:count d //遍历日期
 	..s periodName = periodList.GetAt(i)
 	..i $D(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr)) d
 	...s ^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr)=^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr)+personDWHZInfo
 	..e  d
 	...s ^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr)=personDWHZInfo
 		  		
 	//处理临时Global中的数据
 	i $D(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j)) d
 	.s deptId=0
 	.f  s deptId=$O(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId)) q:deptId=""  d
 	..s deptCode="",deptName="未知科室"
 	..i $D(^dhcbsBonusUnitD(deptId)) d
 	...s deptCode = $List(^dhcbsBonusUnitD(deptId),2)
 	...s deptName = $List(^dhcbsBonusUnitD(deptId),3)
 	..s personDr=""
 	..f  s personDr=$O(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr)) q:personDr=""  d
 	...s personCode="",personName="未知人员"
 	...i $D(^dhcbsBonusUnitD(personDr)) d
 	....s personCode = $List(^dhcbsBonusUnitD(personDr),2)
 	....s personName = $List(^dhcbsBonusUnitD(personDr),3)
 	...s dwhzrc=$P(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr),"^",1) //对外会诊人次
 	...s dwhzdj=$P(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr),"^",2) //对外会诊单价
 	...s dwhzdes=$P(^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j,deptId,personDr),"^",3) //对外会诊描述
 	...;w period_"^"_deptId_"^"_deptCode_"^"_deptName_"^"_personDr_"^"_personCode_"^"_personName_"^"_dwhzrc_"^"_dwhzdj_"^"_dwhzdes,!
 	...d OutputReport
 
	
	k ^DHCBSHXHospDWHZReport("dhc","bs","hxHospDWHZ",$j)
 	q $$$OK
 	
 	
OutputReport
	
 	s Data=$lb(period,deptId,deptCode,deptName,personDr,personCode,personName,dwhzrc,dwhzdj,dwhzdes)
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
/// CreatDate:2011-12-14
/// Description:全员科室人员对外会诊报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospDWHZReport","GetReport","2011","M",11,159)
Query GetReport(year As %String, fre As %String, fromPeriod As %String, deptId As %Integer) As %Query(ROWSPEC = "period:%String,deptId:%Integer,deptCode:%String,deptName:%String,personDr:%Integer,personCode:%String,personName:%String,dwhzrc:%Integer,dwhzdj:%Float,dwhzdes:%String")
{
}

/// w ##class(dhc.bonus.report.uHXHospDWHZReport).GetItemList(1)
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

/// w ##class(dhc.bonus.report.uHXHospDWHZReport).getPersonDWHZInfo(534,"40^41",2011,"M11")
ClassMethod getPersonDWHZInfo(personId, dwhzTargetId, year, period) As %String
{
	n (personId,dwhzTargetId,year,period)
	
	s personDWHZInfo="0^0^",value=""
	q:personId="" personDWHZInfo
	q:dwhzTargetId="" personDWHZInfo
	q:year="" personDWHZInfo
	q:period="" personDWHZInfo
	
	
	s result=##class(%Library.ResultSet).%New()
	s sqlStr="select TargetValue,Remark from dhc_bonus_data.BonusTargetCollect where BonusYear="_year_" and BonusUnitID="_personId_" and BonusPeriod='"_period_"' and BonusTargetID in ("_$P(dwhzTargetId,"^",1)_","_$P(dwhzTargetId,"^",2)_")"
	;w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		i value="" s value=result.Data("TargetValue")
		e  s value=value_"^"_result.Data("TargetValue")
		s remark=result.Data("Remark")
		
		s personDWHZInfo=value_"^"_remark
	}
	
	q personDWHZInfo
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uHXHospDWHZR668S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
