Class dhc.ca.cache.report.uBalanceofpayment Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Projection blanceofpayments As %Projection.Java(ROOTDIR = "E:\eclipseWorkSpace1\dhccashreport\src");

/// Creator: wang ying
/// CreatDate: 2009-1-14
/// Description:
/// Table：DataLevelSets,CostDistSets,CostResultData
/// Input: costDistSetId-成本分摊套id，itemClass-数据分层套id，deptClass-科室分层套id,month-区间，interval-时间段
/// Output:
/// Others: w ##class(dhc.ca.cache.report.uBalanceofpayment).ListData("1","2","1","1","")
ClassMethod ListData(costDistSetId, itemClass, deptClass, month, interval)
{
	Do ##class(dhc.ca.cache.report.Balanceofpayments).%DeleteExtent()
    n (costDistSetId,itemClass,deptClass,month,interval)
    d ..CostData(costDistSetId, itemClass, deptClass, month, interval)
    d ..IncomeDate(costDistSetId, itemClass, deptClass, month, interval)
}

//w ##class(dhc.ca.cache.report.uBalanceofpayment).CostData("1","2","1","1","")

ClassMethod CostData(costDistSetId, itemClass, deptClass, month, interval)
{
	 //^DHCCACOSTDISTSETS({CostDistSets.CostDistSets_rowid},"CostResultData",{CostResultData_childSub})
    n (costDistSetId, itemClass, deptClass, month, interval)
    s tmpCostResultSub=0
    i $d(^DHCCACOSTDISTSETS(costDistSetId)) d
    .f  s tmpCostResultSub=$o(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpCostResultSub)) q:tmpCostResultSub=""  d
    ..s tmpDeptDr=$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpCostResultSub),"^",3)
    ..s tmpItemDr=$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpCostResultSub),"^",4)
    ..s tmpMonth=$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpCostResultSub),"^",1)
    ..;w "tmpItemDr="_tmpItemDr_"tmpDeptDr="_tmpDeptDr,!
    ..s tmpDeptTypeDr=..FindDeptDr(deptClass,tmpDeptDr)
    ..s tmpItemTypeDr=..FindItemDr(itemClass,tmpItemDr)
    ..;i tmpItemTypeDr'="" d
    ...;w "tmpDeptTypeDr="_tmpDeptTypeDr_",tmpItemTypeDr="_tmpItemTypeDr,!
    ..i (tmpDeptTypeDr'="")&&(tmpItemTypeDr'="")&&(tmpMonth=month) d
    ...s Balanceofpayments=##class(dhc.ca.cache.report.Balanceofpayments).%New()
    ...s Balanceofpayments.deptName=$p(^DHCCAUNITDEPTS(tmpDeptDr),"^",2)
    ...s Balanceofpayments.deptType=$p(^DHCCADEPTLEVELSETS(tmpDeptTypeDr),"^",2)
    ...;w "tmpDeptTypeDr="_tmpDeptTypeDr_",tmpItemTypeDr="_tmpItemTypeDr,!
    ...s Balanceofpayments.itemName=$p(^DHCCAALLDATAITEMS(tmpItemDr),"^",3)
    ...s Balanceofpayments.itemType=$p(^DHCCADATALEVELSETS(tmpItemTypeDr),"^",2)
    ...s Balanceofpayments.money=+$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpCostResultSub),"^",5)
    ...s Balanceofpayments.monthName=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    ...s Balanceofpayments.month=month
    ...s Balanceofpayments.type="成本"
    ...s sc= Balanceofpayments.%Save()
    ...i $$$ISERR(sc) d
    ....Do $System.Status.DisplayError()
}

//w ##class(dhc.ca.cache.report.uBalanceofpayment).IncomeDate("1","1","1","1","")

ClassMethod IncomeDate(costDistSetId, itemClass, deptClass, month, interval)
{
	n (costDistSetId, itemClass, deptClass, month, interval)
	s tmpIncomeData=""
    s Balanceofpayments=##class(dhc.ca.cache.report.Balanceofpayments).%New()
    f  s tmpIncomeData=$o(^DHCCAINCOMEDATAS(0,"Interval",month,tmpIncomeData)) q:tmpIncomeData=""  d
    .i $d(^DHCCAINCOMEDATAS(tmpIncomeData)) d
    ..s tmpfDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeData),"^",11)
    ..s tmptDeptDr=$p(^DHCCAINCOMEDATAS(tmpIncomeData),"^",14)
    ..s tmpMonth=$p(^DHCCAINCOMEDATAS(tmpIncomeData),"^",1)
    ..i tmpfDeptDr=tmptDeptDr d
    ...s tmpItemDr=$p(^DHCCAINCOMEDATAS(tmpIncomeData),"^",6)
    ...s tmpDeptTypeDr=..FindDeptDr(deptClass,tmpfDeptDr)
    ...s tmpItemTypeDr=..FindItemDr(itemClass,tmpItemDr)
    ...i (tmpDeptTypeDr'="")&&(tmpItemTypeDr'="")&&(tmpMonth=month) d
    ....s Balanceofpayments.deptName=$p(^DHCCAUNITDEPTS(tmpfDeptDr),"^",2)
    ....s Balanceofpayments.deptType=$p(^DHCCADEPTLEVELSETS(tmpDeptTypeDr),"^",2)
    ....s Balanceofpayments.itemName=$p(^DHCCAINCOMEDATAS(tmpIncomeData),"^",5)
    ....s Balanceofpayments.itemType=$p(^DHCCADATALEVELSETS(tmpItemTypeDr),"^",2)
    ....s Balanceofpayments.money=+$p(^DHCCAINCOMEDATAS(tmpIncomeData),"^",7)
    ....s Balanceofpayments.monthName=$p(^DHCCAACCOUNTMONTHS(month),"^",2)
    ....s Balanceofpayments.month=month
    ....s Balanceofpayments.type="收入"
    ....s sc= Balanceofpayments.%Save() 
    ....i $$$ISERR(sc) d
    .....Do $System.Status.DisplayError()
}

/// Creator: wang ying
/// CreatDate: 2009-1-15
/// Description:根据输入的分层套id和科室id，返回科室id对应的上级在分层套中的id
/// Table：DataLevelSets,CostDistSets,CostResultData
/// Input: costDistSetId-成本分摊套id，itemClass-数据分层套id，deptClass-科室分层套id,month-区间，interval-时间段
/// Output:
/// Others: w ##class(dhc.ca.cache.report.uBalanceofpayment).FindDeptDr(1,171)
ClassMethod FindDeptDr(Setid, deptDr)
{
	n (Setid,deptDr)
	s deptSetDrs=##class(dhc.ca.cache.report.comm.deptLevelSetTree).getOffspringUnleaf(Setid)
	;w "deptSetDrs="_deptSetDrs,!
	s deptSetDr=""
	s len=$l(deptSetDrs,"^")
	s i=2
	f  q:i>len  d
	.s tmpDeptDr=$p(deptSetDrs,"^",i)
	.s i=i+1
	.i $d(^DHCCADEPTLEVELSETS(tmpDeptDr,"Depts"))  d
	..s tmpDeptSub=0
	..f  s tmpDeptSub=$o(^DHCCADEPTLEVELSETS(tmpDeptDr,"Depts",tmpDeptSub)) q:tmpDeptSub=""  d
	...s tmpDept=$p(^DHCCADEPTLEVELSETS(tmpDeptDr,"Depts",tmpDeptSub),"^",1)
	...;w "tmpDept="_tmpDept,!
	...i tmpDept=deptDr d
	....s deptSetDr=##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptClassInId(tmpDeptDr)
    q deptSetDr
}

/// Creator: wang ying
/// CreatDate: 2009-1-15
/// Description:根据输入的分层套id和科室id，返回科室id对应的上级在分层套中的id
/// Table：DataLevelSets,CostDistSets,CostResultData
/// Input: costDistSetId-成本分摊套id，itemClass-数据分层套id，deptClass-科室分层套id,month-区间，interval-时间段
/// Output:
/// Others: w ##class(dhc.ca.cache.report.uBalanceofpayment).FindItemDr(2,133)
ClassMethod FindItemDr(Setid, itemDr)
{
	n (Setid,itemDr)
	s itemSetDrs=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getOffspringUnleaf(Setid)
	;w "itemSetDrs="_itemSetDrs,!
	s itemSetDr=""
	s len=$l(itemSetDrs,"^")
	;w len,!
	s i=2
	f  q:i>len  d
	.s tmpitemDr=$p(itemSetDrs,"^",i)
	.s i=i+1
	.i $d(^DHCCADATALEVELSETS(tmpitemDr,"Items"))  d
	..s tmpItemSub=0
	..f  s tmpItemSub=$o(^DHCCADATALEVELSETS(tmpitemDr,"Items",tmpItemSub)) q:tmpItemSub=""  d
	...s tmpItem=$p(^DHCCADATALEVELSETS(tmpitemDr,"Items",tmpItemSub),"^",3)
	...i tmpItem=itemDr d
	....s itemSetDr=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemClassInId(tmpitemDr)
    q itemSetDr
}

/// Creator: wang ying
/// CreatDate: 2009-1-28
/// Description:
/// Table：DataLevelSets,CostDistSets,CostResultData
/// Input: costDistSetId-成本分摊套id，itemClass-数据分层套id，deptClass-科室分层套id,month-区间，interval-时间段
/// Output:
/// Others: w ##class(dhc.ca.cache.report.uBalanceofpayment).ListDataOfMonth("1","2","1","1,2","")
ClassMethod ListDataOfMonth(costDistSetId, itemClass, deptClass, month, interval)
{
	Do ##class(dhc.ca.cache.report.Balanceofpayments).%DeleteExtent()
    n (costDistSetId,itemClass,deptClass,month,interval)
    
    s len=$l(month,",")
    s i=1
    f  q:i>len  d
    .s monthDr=$p(month,",",i)
    .;w "monthDr="_monthDr,!
    .d ..CostData(costDistSetId, itemClass, deptClass, monthDr, interval)
    .d ..IncomeDate(costDistSetId, itemClass, deptClass, monthDr, interval)
    .s i=i+1
}

Storage Default
{
<Data name="uBalanceofpaymentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uBalanceofpaymentD</DataLocation>
<DefaultData>uBalanceofpaymentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uBalanceofpaymentD</IdLocation>
<IndexLocation>^dhc.ca.c.uBalanceofpaymentI</IndexLocation>
<StreamLocation>^dhc.ca.c.uBalanceofpaymentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
