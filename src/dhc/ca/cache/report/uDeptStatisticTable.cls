Class dhc.ca.cache.report.uDeptStatisticTable Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2010-03-25
/// Description: 初始化数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS
/// Input：costDistSetId 分摊套id, accountMonthId  核算区间id, reportData 临时对象
/// Output：
/// Return：返回保存状态
/// Others：d ##class(dhc.ca.cache.report.uDeptStatisticTable).init(1,2,1)
ClassMethod init(costSetDr As %String, itemSetDr As %String, month As %String)
{
	// 生成临时global
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costSetDr)),"^",5)
	Set deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptSetDr,0)
	Set itemCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(itemSetDr,0)
	
	Set reportData = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()

	
	//末层科室
	s leafId=0
	f  s leafId=$o(^tmpdhccadeptleveltree($j,"leaf",leafId)) q:leafId=""  d
    .Set reportData.deptName = ""
    .Set costResultDatadistDeptName = $p($g(^DHCCAUNITDEPTS(leafId)),"^",2)
    .Set reportData.money = 0
    .Set tmpResult = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(deptSetDr,leafId)
 	.Set levelNum = $p(tmpResult,"||",1)
 	.Set reportData.deptNum = levelNum
 	.;w "levelNum="_levelNum,"reportData.deptNum="_reportData.deptNum,!
 	.FOR reps=levelNum:-1:1 {
	.	Set costResultDatadistDeptName = "  "_costResultDatadistDeptName
	.}
	.Set reportData.deptName = costResultDatadistDeptName
	.Set sortNum=$p($g(^tmpdhccadeptleveltree($j,"leaf",leafId)),"||",1)
 	.i sortNum'="" Set reportData.deptOrder  = sortNum
	.Set reportData.deptDr = "leaf"_"$"_leafId
	.Set reportData = ..getDataLevelTreeNullData(costSetDr,month,itemSetDr,reportData)
 	.;Set ind = ..OutputReportRow(repid, ind,reportData)
    .;d ##class(dhc.ca.cache.udata.uReportResult).Insert("报表类别",1,2,3,"4^科室名称^5^6^科室类别^项目名称^7^8^项目类别^数据类别^9^10")
    .;Set ^TMPDHCCADEPTSTATISTIC($j,"leaf",leafId,reportData.itemDr) = 0
  
    //非末层科室
    s trunkId=0
	f  s trunkId=$o(^tmpdhccadeptleveltree($j,"trunk",trunkId)) q:trunkId=""  d
	.Set costResultDatadistDeptName = $p($g(^DHCCADEPTLEVELSETS(trunkId)),"^",2)
 	.Set tmpResult=$g(^tmpdhccadeptleveltree($j,"trunk",trunkId))
 	.Set tmpParentIds=$p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set distLocTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set reportData.deptNum = levelNum
 	.Set reportData.deptOrder = $LENGTH(tmpParentIds,"^")-2
 	.FOR reps=levelNum-2:-1:1 {
	.	Set costResultDatadistDeptName = "  "_costResultDatadistDeptName
	.}
 	.Set reportData.deptName = costResultDatadistDeptName
 	.Set reportData.deptOrder = $p(tmpResult,"||",1)
 	.Set reportData.deptDr = "trunk"_"$"_trunkId
 	.Set reportData = ..getDataLevelTreeNullData(costSetDr,month,itemSetDr,reportData)
 	.;Set ind = ..OutputReportRow(repid, ind, reportData)
 	.;Set ^TMPDHCCADEPTSTATISTIC($j,"trunk",trunkId,reportData.itemDr) = 0
 	
 	;Kill ^tmpdhccadeptleveltree($j)
    ;Kill ^tmpdhccadataleveltree($j)
 	Kill reportData
}

/// Creator：wang ying
/// CreatDate：2010-03-09
/// Description: 根据临时global生成报表数据项树结构
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS
/// Input：costDistSetId 分摊套id, accountMonthId  核算区间id, reportData 临时对象
/// Output：
/// Return：返回保存状态
/// Others：//month,costSetDr,itemSetDr
ClassMethod getDataLevelTreeNullData(costSetDr, month, itemSetDr, reportData) As %String
{

    ;w costDistSetId,"month="_accountMonthId,"reportData="_reportData.deptDr,!
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costSetDr)),"^",3)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(month)),"^",2)
    s deptDr = reportData.deptDr
	//末层数据项
	s leafId=0
	f  s leafId=$o(^tmpdhccadataleveltree($j,"leaf",leafId)) q:leafId=""  d
    .Set reportData.month  = intervalName   //区间
    .;Set reportData.itemName  = $p($g(^DHCCAALLDATAITEMS(leafId)),"^",3) //成本项
 	.Set tmpParentIds = $p($g(^tmpdhccadataleveltree($j,"leaf",leafId)),"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set dataTypeId = $p(tmpParentIds,"^",levelNum)
 	.Set dataTypeSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",dataTypeId)),"||",1)
 	.Set sortNum=$p($g(^tmpdhccadataleveltree($j,"leaf",leafId)),"||",1)
 	.Set reportData.itemOrder  = sortNum-1  // 数据分层套树结构排序
 	.i sortNum'="" Set reportData.itemNum  = levelNum  // 数据分层套层级
 	.Set reportData.itemDr = "leaf"_"$"_leafId
 	.Set itemName = $p($g(^DHCCAALLDATAITEMS(leafId)),"^",3)
 	.FOR reps=levelNum:-1:1 {
	.	Set itemName = "  "_itemName
	.}
	.Set reportData.itemName = itemName  // 成本项
 	.Set data = reportData.money_"^"_reportData.deptName_"^"_reportData.deptNum_"^"_reportData.deptOrder_"^^"_reportData.itemName_"^"_reportData.itemNum_"^"_reportData.itemOrder_"^^^"_reportData.deptDr_"^"_reportData.itemDr
    .w data,!
    .d ##class(dhc.ca.cache.udata.uReportResult).Insert("kscbhz",month,costSetDr,itemSetDr,data)

 	.;w reportData.itemName,reportData.deptName ,!
 	.;Set ind = ..OutputReportRow(repid,ind,reportData)
   
    //非末层成本项
    s trunkId=0
	f  s trunkId=$o(^tmpdhccadataleveltree($j,"trunk",trunkId)) q:trunkId=""  d
    .;Set reportData.itemName = $p($g(^DHCCADATALEVELSETS(trunkId)),"^",2) // 成本项
 	.Set tmpResult=$g(^tmpdhccadataleveltree($j,"trunk",trunkId))
 	.Set tmpParentIds=$p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set dataTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set reportData.itemNum = $LENGTH(tmpParentIds,"^")-2   // 数据分层套层级
 	.Set reportData.itemOrder = $p(tmpResult,"||",1)-1             // 数据分层套树结构排序
 	.Set reportData.itemDr = "trunk"_"$"_trunkId
 	.Set itemName = $p($g(^DHCCADATALEVELSETS(trunkId)),"^",2)
 	.Set levelNum = $LENGTH(tmpParentIds,"^")-2
 	.FOR reps=levelNum:-1:1 {
	.	Set itemName = "  "_itemName
	.}
	.Set reportData.itemName = itemName  // 成本项
 	.Set data = reportData.money_"^"_reportData.deptName_"^"_reportData.deptNum_"^"_reportData.deptOrder_"^^"_reportData.itemName_"^"_reportData.itemNum_"^"_reportData.itemOrder_"^^^"_reportData.deptDr_"^"_reportData.itemDr
    .w data,!
    .d ##class(dhc.ca.cache.udata.uReportResult).Insert("kscbhz",month,costSetDr,itemSetDr,data)
 	.;Set ind = ..OutputReportRow(repid, ind, reportData)
 	.;Set ^TMPDHCCADEPTSTATISTIC($j,"leaf",deptDr,trunkId)=0
 	;Kill reportData
 	
 	Quit reportData
}

/// Creator：wang ying
/// CreatDate：2010-03-25
/// Description: 插入报表数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS
/// Input：costSetDr 分摊套id, month  核算区间id, reportData 临时对象
/// Output：
/// Return：返回保存状态
/// Others：d ##class(dhc.ca.cache.report.uDeptStatisticTable).insertReportData(1,1,1)
ClassMethod insertReportData(costSetDr As %String, itemSetDr As %String, month As %String)
{
	n (costSetDr,itemSetDr,month)
	Set startTime = $zt($p($h,",",2))
	d ##class(dhc.ca.cache.udata.uReportResult).Delete("kscbhz",month,costSetDr,itemSetDr)
	// 生成临时global
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costSetDr)),"^",5)
	Set deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptTreeAddLeaf(deptSetDr,0)
	Set itemCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(itemSetDr,0)
	
	d ..addDeptNum()
    d ..addItemNum()
    d ..addZero(month, costSetDr, itemSetDr)
	
	s costResultDataId=0
	f  s costResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costSetDr,month,costResultDataId)) q:costResultDataId=""  d
	.i $d(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",costResultDataId)) d
	..d ..GetReportData(costSetDr,costResultDataId,itemSetDr,month)
	
	Kill ^tmpdhccadeptleveltree($j)
    Kill ^tmpdhccadataleveltree($j)
    Set endTime = $zt($p($h,",",2))
    Set time = endTime -startTime
    w startTime,"end"_endTime,"time"_time
}

/// Creator：wang ying
/// CreatDate：2010-03-25
/// Description: 插入报表数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS
/// Input：costSetDr 分摊套id, month  核算区间id, reportData 临时对象
/// Output：
/// Return：返回保存状态
/// Others：d ##class(dhc.ca.cache.report.uDeptStatisticTable).GetReportData(1,2,1)
ClassMethod GetReportData(costSetDr As %String, costResultDataId As %String, itemSetDr As %String, month As %String) As %String
{
	s money = $p($g(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",costResultDataId)),"^",5)
	
	s deptDr = $p($g(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",costResultDataId)), "^", 3) // 接收科室id
    s itemDr = $p($g(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",costResultDataId)), "^", 4) //成本项id
	s flag = $p($g(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",costResultDataId)), "^", 6) //分摊标志
	
	i flag="self" {
	
	s deptLeaf = "leaf"_"$"_deptDr
	s itemLeaf = "leaf"_"$"_itemDr
	
	i ($d(^tmpdhccadeptleveltree($j,"leaf",deptDr)))&&($d(^tmpdhccadataleveltree($j,"leaf",itemDr))) d
	.s deptTree = ^tmpdhccadeptleveltree($j,"leaf",deptDr)
	.s itemTree = ^tmpdhccadataleveltree($j,"leaf",itemDr)
	.;b
	.;w "itemLeaf="_itemLeaf,!
	.d ..addDeptPar(month,costSetDr,itemSetDr,$p(deptTree,"||",2),money,$p(itemTree,"||",2),itemLeaf)
	.d ..addItemPar(month,costSetDr,itemSetDr,$p(itemTree,"||",2),money,deptLeaf)
	
	i ($d(^DHCCAREPORTRESULT(0,"RTIntDiDa","kscbhz",month,costSetDr,itemSetDr,deptLeaf,itemLeaf)))  d
	.s reportResultId = ""
	.s reportResultId = $o(^DHCCAREPORTRESULT(0,"RTIntDiDa","kscbhz",month,costSetDr,itemSetDr,deptLeaf,itemLeaf,reportResultId))
	.i reportResultId '="" d
	..s $p(^DHCCAREPORTRESULT(reportResultId),"^",5) = $p(^DHCCAREPORTRESULT(reportResultId),"^",5) + money
	}
	q "OK"
}

/// Creator：wang ying
/// CreatDate：2009-03-26
/// Description: 生成当前分摊结果所有父级成本科目的报表数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS，DHCCADEPTLEVELSETS
/// Input：costDistSetId 分摊套, reportDataRow 临时对象，costResultDataId 分摊结果id
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetParentItemReportData(itemDr, reportData) As %String
{
 Set allParentId = $p($g(^tmpdhccadataleveltree($j,"leaf",ItemDr)), "||", 2)
 i (allParentId'="") d
 .SET delim="^"
 .SET countdown=$LENGTH(allParentId,delim)-1
 .SET countup=1
 .FOR reps=countdown:-1:1 {
    .SET extract=$PIECE(allParentId,delim,countup)
    .SET reportData.itemDr = "trunk"_"$"_extract
    .SET countup=countup+1
 .}
}

/// Creator: wang ying
/// CreatDate: 2009-03-26
/// Description: 初始化数据，便于显示科室、数据项名称
/// Table：DeptLevelSets,DataLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatisticTable).addZero(1,1,2)
ClassMethod addZero(month, costSetDr, itemSetDr) As %String
{
  

 s itemType=""
 f  s itemType=$o(^tmpdhccadataleveltree($j,itemType)) q:itemType=""  d
 .s itemDr=""
 .f  s itemDr=$o(^tmpdhccadataleveltree($j,itemType,itemDr)) q:itemDr=""  d
 ..s itemflag = 0
 ..s tmpItemName=""
 ..i itemType="leaf" d
 ...s tmpItemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)
 ...s tmpItemDr = "leaf"_"$"_itemDr
 ..e  d
 ...s tmpItemName=$p(^DHCCADATALEVELSETS(itemDr),"^",2)
 ...s tmpItemDr = "trunk"_"$"_itemDr
 ...s active = $p($g(^DHCCADATALEVELSETS(itemDr)),"^",6)
 ...i active = "N" d
 ....s itemflag = 1
 ..i itemflag = 0 {
 ..s tmpItemNum=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",3)
 ..s tmpItemOrder=$p(^tmpdhccadataleveltree($j,itemType,itemDr),"||",1)
 ..s tmpItemSpace=..addSpace(tmpItemNum)
 ..s tmpItemName=tmpItemSpace_tmpItemName
 ..s flag = 0
 ..s deptType=""
 ..f  s deptType=$o(^tmpdhccadeptleveltree($j,deptType)) q:deptType=""  d
 ...s deptDr=""
 ...f  s deptDr=$o(^tmpdhccadeptleveltree($j,deptType,deptDr)) q:deptDr=""  d
 ....s tmpDeptName=""
 ....i deptType="leaf" d
 .....s tmpDeptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
 .....s tmpDeptDr = "leaf"_"$"_deptDr
 ....e  d
 .....s tmpDeptName=$p($g(^DHCCADEPTLEVELSETS(deptDr)),"^",2)
 .....s tmpDeptDr = "trunk"_"$"_deptDr
 .....s active = $p($g(^DHCCADEPTLEVELSETS(deptDr)),"^",6)
 .....i active = "N"  d
 ......s flag = 1
 ....i flag = 0 d
 .....s tmpDeptNum=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",3)
 .....s tmpDeptOrder=$p(^tmpdhccadeptleveltree($j,deptType,deptDr),"||",1)
 .....s tmpDeptSpace=..addSpace(tmpDeptNum)
 .....s tmpDeptName=tmpDeptSpace_tmpDeptName
 .....s data = 0_"^"_tmpDeptName_"^"_tmpDeptNum_"^"_tmpDeptOrder_"^^"_tmpItemName_"^"_tmpItemNum_"^"_tmpItemOrder_"^^^"_tmpDeptDr_"^"_tmpItemDr
 .....d ##class(dhc.ca.cache.udata.uReportResult).Insert("kscbhz",month,costSetDr,itemSetDr,data)
 ..}
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
 n (tmpNum)
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

ClassMethod addDeptPar(month, costSetDr, itemSetDr, par, money, itemPar, itemLeaf) As %String
{
 n (month,costSetDr,itemSetDr,par, money,itemPar,itemLeaf)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadeptleveltree($j,"trunk",tmpPar)) d
 ..s tmpDept=^tmpdhccadeptleveltree($j,"trunk",tmpPar)
 ..s tmpDeptDr = "trunk"_"$"_tmpPar
 ..;w "tmpDeptDr="_tmpDeptDr,!
 ..;w "m="_month,"cost="_costSetDr,"i="_itemSetDr,"dept="_tmpDeptDr,"item="_itemLeaf
 ..i ($d(^DHCCAREPORTRESULT(0,"RTIntDiDa","kscbhz",month,costSetDr,itemSetDr,tmpDeptDr,itemLeaf))) d
 ...;b
 ...s reportResultId = ""
 ...s reportResultId = $o(^DHCCAREPORTRESULT(0,"RTIntDiDa","kscbhz",month,costSetDr,itemSetDr,tmpDeptDr,itemLeaf,reportResultId))
 ...i reportResultId '="" d
 ....s $p(^DHCCAREPORTRESULT(reportResultId),"^",5) = $p(^DHCCAREPORTRESULT(reportResultId),"^",5) + money
 ..d ..addItemPar(month,costSetDr,itemSetDr,itemPar,money,tmpDeptDr)
 
 q "OK"
}

/// Creator: wang ying
/// CreatDate: 2009-02-04
/// Description:添加科室的父级科室 
/// Table：DeptLevelSets  
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addDeptPar(" 电话费", 1, 2,"3^1",154099.79,"3^2")
/// Creator: wang ying
/// CreatDate: 2009-02-04
/// Description: 添加数据项的父级数据
/// Table：DataLevelSets   
/// Input:
/// Output: 
/// Others: w ##class(dhc.ca.cache.report.uDeptStatistic).addItemPar(" 公用成本",1,2,"3^2","154099.79")
ClassMethod addItemPar(month, costSetDr, itemSetDr, par, money, deptLeaf) As %String
{
 n (month,costSetDr,itemSetDr, par, money,deptLeaf)
 s tmpNum=1
 f  s tmpPar=$p(par,"^",tmpNum) q:tmpPar=""  d
 .s tmpNum=tmpNum+1 
 .i $d(^tmpdhccadataleveltree($j,"trunk",tmpPar)) d
 ..s tmpItemDr = "trunk"_"$"_tmpPar
 ..i $d(^DHCCAREPORTRESULT(0,"RTIntDiDa","kscbhz",month,costSetDr,itemSetDr,deptLeaf,tmpItemDr)) d
 ...s reportResultId = ""
 ...s reportResultId = $o(^DHCCAREPORTRESULT(0,"RTIntDiDa","kscbhz",month,costSetDr,itemSetDr,deptLeaf,tmpItemDr,reportResultId))
 ...i reportResultId '="" d
 ....s $p(^DHCCAREPORTRESULT(reportResultId),"^",5) = $p(^DHCCAREPORTRESULT(reportResultId),"^",5) + money
 
 q "OK"
}

Storage Default
{
<Data name="uDeptStatisticTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cach70D.uDeptStatist7A2D</DataLocation>
<DefaultData>uDeptStatisticTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.cach70D.uDeptStatist7A2D</IdLocation>
<IndexLocation>^dhc.ca.cach70D.uDeptStatist7A2I</IndexLocation>
<StreamLocation>^dhc.ca.cach70D.uDeptStatist7A2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
