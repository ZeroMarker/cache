/// Creator: 李明忠
/// CreatDate: 2011-12-21
/// Description: 华西科室奖酬金明细报表
Class dhc.bonus.report.uHXHospJCJDetailReport Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-12-21
/// Description:年度Query
/// Table:dhc_bonus_data.UnitBonusDetail
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospJCJDetailReport","GetCycle")
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
/// CreatDate:2011-12-21
/// Description:期间Query
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospJCJDetailReport","GetPeriod")
Query GetPeriod() As %Query(ROWSPEC = "Freq:%String,PeriodDr:%String,PeriodName:%String")
{
}

/// Creator:李明忠
/// CreatDate:2011-12-21
/// Description:获取科室奖酬金方案下的科室
/// Table:dhc_bonus_data.BonusUnit
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospJCJDetailReport","GetDept")
Query GetDept() As %SQLQuery(CONTAINID = 1)
{
	select BonusUnitID,BonusUnitName from dhc_bonus_data.BonusUnit where BonusUnitID in (select BonusUnitID from dhc_bonus_data.BonusSchemeUnit where BonusSchemeID=4)
}

/// Creator：李明忠
/// CreatDate：2011-12-21
/// Description: 获取科室奖酬金方案下的科室
/// Table：dhc.bonus.data.BonusUnit
/// Others：w ##class(dhc.bonus.report.uHXHospJCJDetailReport).GetDept()
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
/// CreatDate:2011-12-21
/// Description:获取科室奖酬金方案下的科室
/// Table:dhc_bonus_data.BonusUnit
/// Others:w ##class(dhc.bonus.report.uHXHospJCJDetailReport).GetDeptList()
ClassMethod GetDeptList(deptId) As %Library.ListOfDataTypes
{
	s deptList=##class(%Library.ListOfDataTypes).%New()
	
	i deptId'="" d
	.d deptList.Insert(deptId)
	e  d
	.s deptList=..GetDept(deptList)
	
	q deptList
}

/// Creator:李明忠
/// CreatDate:2011-12-21
/// Description:获取科室奖酬金方案下的指标
/// Table:dhc_bonus_data.BonusTarget
/// Others:w ##class(dhc.bonus.report.uHXHospJCJDetailReport).GetTargetInfo()
ClassMethod GetTargetInfo() As %Library.ListOfDataTypes
{
	s targetList=##class(%Library.ListOfDataTypes).%New()
	
	//========说明============================
	;医疗收入^69T1^70T2^72T3
	;医疗收入:指标
	;69:指标ID
	;1:在报表中显示的列顺序
	//========================================
	
	s targetInfoStr="医疗收入^69T1^70T2^72T3||平均住院日^55T1^56T2^58T3||出院人数^60T1^61T2^63T3"
	s count = $L(targetInfoStr,"||")
	f index=1:1:count d
	.s targetInfo=$P(targetInfoStr,"||",index)
	.i targetInfo'="" d
	..d targetList.Insert(targetInfo)
	
	q targetList
}

/// Creator:李明忠
/// CreatDate:2011-12-21
/// Description:获取科室奖酬金方案下的指标值
/// Table:dhc_bonus_data.BonusTarget
/// Others:w ##class(dhc.bonus.report.uHXHospJCJDetailReport).getCJCDetailValue(248,60)
ClassMethod getCJCDetailValue(year, paramPeriod, deptId, targetId) As %String
{
	n (year,paramPeriod,deptId,targetId)
	
	s value=0.00
	q:year="" value
	q:paramPeriod="" value
	q:deptId="" value
	q:targetId="" value
	
	s sqlStr = "select TargetValue from dhc_bonus_data.BonusTargetCollect where BonusYear='"_year_"' and BonusPeriod='"_paramPeriod_"' and BonusTargetID="_targetId_" and BonusUnitID="_deptId
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	While(result.Next()){
		s value = result.Data("TargetValue")
	}
	
	q value
}

ClassMethod GetReportExecute(ByRef qHandle As %Binary, year As %String, fre As %String, fromPeriod As %Integer) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	q:year="" $$$OK
 	q:fre="" $$$OK
 	q:fromPeriod="" $$$OK
 	
 	k ^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j)
 	
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

 	//查询科室
 	s deptList = ..GetDeptList("")
 	s deptCount = deptList.Count()
 	//查询科室奖酬金方案相关指标数据
 	f j=1:1:deptCount d
 	.s deptId=deptList.GetAt(j)
 	.s targetList = ..GetTargetInfo()
 	.s targetCount = targetList.Count()
 	.f index = 1:1:targetCount d
 	..s targetInfo = targetList.GetAt(index)
 	..s targetName = $P(targetInfo,"^",1)
 	..i targetName'="" d
 	...s targetLen = $L(targetInfo,"^")
 	...f i = 2:1:targetLen d
 	....s targetId = $P($P(targetInfo,"^",i),"T",1)
 	....s orders = $P($P(targetInfo,"^",i),"T",2)
 	....s value = ..getCJCDetailValue(year,paramPeriod,deptId,targetId)
 	....i $D(^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders,targetId)) d
 	.....s ^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders,targetId)=^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders,targetId)+value
 	....e  d
 	.....s ^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders,targetId)=value
 	....;w deptId_"^"_targetName_"^"_orders_"^"_targetId_"^"_value,!
 	
 	//处理数据
 	i $D(^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j)) d
 	.s deptId=0
 	.f  s deptId=$O(^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId)) q:deptId=""  d
 	..s deptCode="",deptName="未知科室"
 	..i $D(^dhcbsBonusUnitD(deptId)) d
 	...s deptCode = $List(^dhcbsBonusUnitD(deptId),2)
 	...s deptName = $List(^dhcbsBonusUnitD(deptId),3)
 	..s targetName=""
 	..f  s targetName=$O(^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName)) q:targetName=""  d
 	...s orders=0
 	...f  s orders=$O(^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders)) q:orders=""  d
 	....s targetId=0
 	....f  s targetId=$O(^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders,targetId)) q:targetId=""  d
 	.....s value = ^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j,deptId,targetName,orders,targetId)
 	.....;w periodList.GetAt(1)_"^"_deptCode_"^"_deptName_"^"_targetName_"^"_orders_"^"_targetId_"^"_value,!
 	.....d OutputReport
 	
 	k ^DHCBSHXHospJCJDetailReport("dhc","bs","hxHospJCJDetail",$j)
 	q $$$OK
 	
 	
OutputReport
	
 	s Data=$lb(period,deptId,deptCode,deptName,targetName,orders,targetId,value)
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
/// CreatDate:2011-12-21
/// Description:科室奖酬金明细报表
/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uHXHospJCJDetailReport","GetReport","2011","M",11)
Query GetReport(year As %String, fre As %String, fromPeriod As %String) As %Query(ROWSPEC = "period:%String,deptId:%Integer,deptCode:%String,deptName:%String,targetName:%String,orders:%Integer,targetId:%Integer,value:%Float")
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uHXHospJCJDe855S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
