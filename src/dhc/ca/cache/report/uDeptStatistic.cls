Class dhc.ca.cache.report.uDeptStatistic Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-02-03
/// Description: 查询符合条件的记录
/// Table：CostResultData
/// Input：costDistSetId 分摊套, month 核算区间，itemClass 数据分层套
/// Output：
/// Return：返回查询状态
/// Others：w ##class(dhc.ca.cache.report.uDeptStatistic).ListDeptCostData(1,1,2)
ClassMethod ListDeptCostData(costDistSetId, month, itemClass) As %String
{
	n (costDistSetId, month,itemClass)
	k ^tmpdhccadeptleveltree
	k ^tmpdhccadataleveltree
	d ##class(dhc.ca.cache.report.DeptCostStatistic).%DeleteExtent()
	s deptClass = $p(^DHCCACOSTDISTSETS(costDistSetId),"^",5)
	s deptNum= ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptClass,0)
	s itemNum= ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(itemClass,0)
    d ..addDeptNum()
    d ..addItemNum()
    d ..addZero()
    s tmpSub=""
    f  s tmpSub=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetId,month,tmpSub)) q:tmpSub=""  d
    .i $d(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpSub)) d
    ..s tmpDeptDr=$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpSub),"^",3)
    ..s tmpItemDr=$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpSub),"^",4)
    ..;w "tmpDeptDr="_tmpDeptDr,"tmpItemDr="_tmpItemDr,!
    ..i $d(^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr))&&$d(^tmpdhccadataleveltree($j,"leaf",tmpItemDr))  d
    ...s tmpMoney=$p(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",tmpSub),"^",5)
    ...s tmpDeptName=$p(^DHCCAUNITDEPTS(tmpDeptDr),"^",2)
    ...s tmpDeptTree=^tmpdhccadeptleveltree($j,"leaf",tmpDeptDr)
    ...s tmpDeptNum=$p(tmpDeptTree,"||",3)
    ...s tmpDeptSpace=..addSpace(tmpDeptNum)
    ...s tmpDeptName=tmpDeptSpace_tmpDeptName
    ...s tmpDeptOrder=$p(tmpDeptTree,"||",1)
    ...s tmpItemName=$p(^DHCCAALLDATAITEMS(tmpItemDr),"^",3)
    ...s tmpItemTree=^tmpdhccadataleveltree($j,"leaf",tmpItemDr)
    ...s tmpItemOrder=$p(tmpItemTree,"||",1)
    ...s tmpItemNum=$p(tmpItemTree,"||",3)
    ...s tmpItemSpace=..addSpace(tmpDeptNum)
    ...s tmpItemName=tmpItemSpace_tmpItemName
    ...;w tmpDeptName," "_tmpDeptNum," "_tmpDeptOrder," "_$p(tmpItemTree,"||",2)," "_tmpMoney,!
    ...;w tmpItemName," "_tmpItemNum," "_tmpItemOrder," "_$p(tmpDeptTree,"||",2)," "_tmpMoney," "_$p(tmpItemTree,"||",2)
    ...;b
    ...d ..addDeptPar(tmpItemName,tmpItemNum,tmpItemOrder,$p(tmpDeptTree,"||",2),tmpMoney,$p(tmpItemTree,"||",2))
    ...d ..addItemPar(tmpDeptName,tmpDeptNum,tmpDeptOrder,$p(tmpItemTree,"||",2),tmpMoney)
    ...s tmpDeptCostStatistic = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()
    ...s tmpDeptCostStatistic.money=tmpMoney
    ...s tmpDeptCostStatistic.deptName=tmpDeptName
    ...s tmpDeptCostStatistic.deptNum=tmpDeptNum
    ...s tmpDeptCostStatistic.deptOrder=tmpDeptOrder
    ...s tmpDeptCostStatistic.itemName=tmpItemName
    ...s tmpDeptCostStatistic.itemNum=tmpItemNum
    ...s tmpDeptCostStatistic.itemOrder=tmpItemOrder
    ...s sc = tmpDeptCostStatistic.%Save()
    ...i $$$ISERR(sc) d
    ....Do $System.Status.DisplayError()
}

/// Creator: wang ying
/// CreatDate: 2010-02-04
/// Description: 在数据结构的临时global中添加级别数
/// Table：DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addItemNum()
ClassMethod addItemNum() As %String
{
 s i=""
 f  s i=$o(^tmpdhccadataleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadataleveltree($j,i,j)) q:j=""  d
 ..s tmpItem=^tmpdhccadataleveltree($j,i,j)
 ..s tmpPars=$p(tmpItem,"||",2)
 ..s num=1
 ..f  s tmpPar=$p(tmpPars,"^",num) q:tmpPar=""  d
 ...s num=num+1
 ..i i="leaf" d
 ...s num=num-2
 ..e  d
 ...s num=num-3
 ..s ^tmpdhccadataleveltree($j,i,j)=tmpItem_"||"_num
 q "OK"
}

/// Creator: wang ying
/// CreatDate: 2010-02-05
/// Description: 根据传过来的数值返回空格，显示出科室或数据项的树状结构
/// Table：
/// Input:tmpNum:级别数
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addSpace()
ClassMethod addSpace(tmpNum) As %String
{
 
 s num=1
 s space=""
 f  q:num>tmpNum  d
 .s space="  "_space
 .s num=num+1
 q space
}

/// Creator: wang ying
/// CreatDate: 2010-02-04
/// Description:在科室结构的临时global中添加级别数 
/// Table： 
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addDeptNum()
ClassMethod addDeptNum() As %String
{
 s i=""
 f  s i=$o(^tmpdhccadeptleveltree($j,i)) q:i=""  d
 .s j=""
 .f  s j=$o(^tmpdhccadeptleveltree($j,i,j)) q:j=""  d
 ..s tmpDept=^tmpdhccadeptleveltree($j,i,j)
 ..s tmpPars=$p(tmpDept,"||",2)
 ..s num=1
 ..f  s tmpPar=$p(tmpPars,"^",num) q:tmpPar=""  d
 ...s num=num+1
 ..i i="leaf" d
 ...s num=num-2
 ..e  d
 ...s num=num-3
 ..s ^tmpdhccadeptleveltree($j,i,j)=tmpDept_"||"_num
 q "OK"
}

/// Creator: wang ying
/// CreatDate: 2009-02-04
/// Description:添加科室的父级科室 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addDeptPar(" 电话费", 1, 2,"3^1",154099.79,"3^2")
ClassMethod addDeptPar(itemName, itemNum, itemOrder, par, money, itemPar) As %String
{
 n (itemName, itemNum, itemOrder, par, money,itemPar)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadeptleveltree($j,"trunk",tmpPar)) d
 ..s tmpDept=^tmpdhccadeptleveltree($j,"trunk",tmpPar)
 ..s tmpDeptOrder=$p(tmpDept,"||",1)
 ..s tmpDeptNum=$p(tmpDept,"||",3)
 ..s tmpDeptSpace=..addSpace(tmpDeptNum)
 ..s tmpDeptName=tmpDeptSpace_$p(^DHCCADEPTLEVELSETS(tmpPar),"^",2)
 ..d ..addItemPar(tmpDeptName, tmpDeptNum, tmpDeptOrder,itemPar,money)
 ..s tmpDeptCostStatistic = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()
 ..s tmpDeptCostStatistic.money=money
 ..s tmpDeptCostStatistic.deptName=tmpDeptName
 ..s tmpDeptCostStatistic.deptNum=tmpDeptNum
 ..s tmpDeptCostStatistic.deptOrder=tmpDeptOrder
 ..s tmpDeptCostStatistic.itemName=itemName
 ..s tmpDeptCostStatistic.itemNum=itemNum
 ..s tmpDeptCostStatistic.itemOrder=itemOrder
 ..s sc = tmpDeptCostStatistic.%Save()
 q "OK"
}

/// Creator: wang ying
/// CreatDate: 2009-02-04
/// Description: 初始化数据，便于显示科室、数据项名称
/// Table：DeptLevelSets,DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addZero()
ClassMethod addZero() As %String
{
  
   s itemType=""
 f  s itemType=$o(^tmpdhccadataleveltree($j,itemType)) q:itemType=""  d
 .s itemDr=""
 .f  s itemDr=$o(^tmpdhccadataleveltree($j,itemType,itemDr)) q:itemDr=""  d
 ..s tmpItemName=""
 ..i itemType="leaf" d
 ...s tmpItemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)
 ..e  d
 ...s tmpItemName=$p(^DHCCADATALEVELSETS(itemDr),"^",2)
 ..s tmpItemNum=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",3)
 ..s tmpItemOrder=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",1)
 ..s tmpItemSpace=..addSpace(tmpItemNum)
 ..s tmpItemName=tmpItemSpace_tmpItemName
 ..s deptType=""
 ..f  s deptType=$o(^tmpdhccadeptleveltree($j,deptType)) q:deptType=""  d
 ...s deptDr=""
 ...f  s deptDr=$o(^tmpdhccadeptleveltree($j,deptType,deptDr)) q:deptDr=""  d
 ....s tmpDeptName=""
 ....i deptType="leaf" d
 .....s tmpDeptName=$p(^DHCCAUNITDEPTS(deptDr),"^",2)
 ....e  d
 .....s tmpDeptName=$p(^DHCCADEPTLEVELSETS(deptDr),"^",2)
 ....s tmpDeptNum=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",3)
 ....s tmpDeptOrder=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",1)
 ....s tmpDeptSpace=..addSpace(tmpDeptNum)
 ....s tmpDeptName=tmpDeptSpace_tmpDeptName
 ....s tmpDeptCostStatistic = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()
 ....s tmpDeptCostStatistic.money=0
 ....s tmpDeptCostStatistic.deptName=tmpDeptName
 ....s tmpDeptCostStatistic.deptNum=tmpDeptNum
 ....s tmpDeptCostStatistic.deptOrder=tmpDeptOrder
 ....s tmpDeptCostStatistic.itemName=tmpItemName
 ....s tmpDeptCostStatistic.itemNum=tmpItemNum
 ....s tmpDeptCostStatistic.itemOrder=tmpItemOrder
 ....s sc = tmpDeptCostStatistic.%Save()
 q "OK"
}

/// Creator: wang ying
/// CreatDate: 2009-02-04
/// Description: 添加数据项的父级数据
/// Table：DataLevelSets   
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addItemPar(" 公用成本",1,2,"3^2","154099.79")
ClassMethod addItemPar(deptName, deptNum, deptOrder, par, money) As %String
{
 n (deptName, deptNum, deptOrder, par, money)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadataleveltree($j,"trunk",tmpPar)) d
 ..s tmpItem=^tmpdhccadataleveltree($j,"trunk",tmpPar)
 ..s tmpItemOrder=$p(tmpItem,"||",1)
 ..s tmpItemNum=$p(tmpItem,"||",3)
 ..s tmpSpace=..addSpace(tmpItemNum)
 ..s tmpItemName=tmpSpace_$p(^DHCCADATALEVELSETS(tmpPar),"^",2)
 ..s tmpDeptCostStatistic = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()
 ..s tmpDeptCostStatistic.money=money
 ..s tmpDeptCostStatistic.itemName=tmpItemName
 ..s tmpDeptCostStatistic.itemNum=tmpItemNum
 ..s tmpDeptCostStatistic.itemOrder=tmpItemOrder
 ..s tmpDeptCostStatistic.deptName=deptName
 ..s tmpDeptCostStatistic.deptNum=deptNum
 ..s tmpDeptCostStatistic.deptOrder=deptOrder
 ..s sc = tmpDeptCostStatistic.%Save()
 q "OK"
}

Storage Default
{
<Data name="uDeptStatisticDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDeptStatisticD</DataLocation>
<DefaultData>uDeptStatisticDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uDeptStatisticD</IdLocation>
<IndexLocation>^dhc.ca.c.uDeptStatisticI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDeptStatisticS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
