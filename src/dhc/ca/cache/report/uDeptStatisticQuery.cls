Class dhc.ca.cache.report.uDeptStatisticQuery Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: 生成报表数据
/// Table：
/// Input：costDistSetId 分摊套, accountMonthId 核算区间,itemSetDr 数据分层套
/// Output：
/// Return：返回ind
/// Others：
ClassMethod GetReportData(repid, ind, costDistSetId, costResultDataId, accountMonthId, itemSetDr) As %String
{
	s reportDataRow = ..GetCostReportDataObj(costDistSetId, costResultDataId,itemSetDr)
	s tmpReportData = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()
	s tmpReportData.money  = reportDataRow.money 
	s tmpReportData.deptOrder  = reportDataRow.deptOrder 
	s tmpReportData.itemNum   = reportDataRow.itemNum  
	s tmpReportData.deptNum  = reportDataRow.deptNum 
	s tmpReportData.itemName  = reportDataRow.itemName 
	s tmpReportData.deptName  = reportDataRow.deptName 
	s tmpReportData.itemOrder  = reportDataRow.itemOrder 
	s ind = ..GetParentItemReportData(repid, ind, costDistSetId, costResultDataId, tmpReportData)
	s ind = ..OutputReportRow(repid, ind, reportDataRow)
	s ind = ..GetParentDeptReportData(repid, ind, costDistSetId, costResultDataId, reportDataRow)
	;s ind = ..GetParentItemReportData(repid, ind, costDistSetId, costResultDataId, reportDataRow)
	Kill reportDataRow
	
	Quit ind
}

/// Creator：wang ying
/// CreatDate：2009-03-09
/// Description: 生成报表的空数据
/// Table：
/// Input：costDistSetId 分摊套,accountMonthId 核算区间id， itemSetDr 数据分层套
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetReportNullData(repid, ind, costDistSetId, accountMonthId, itemSetDr) As %String
{
	s ind = ..getDeptLevelTreeNullDataItem(repid, ind,costDistSetId,accountMonthId,itemSetDr)
	
	Quit ind
}

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: 生成一条报表数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS，DHCCADEPTLEVELSETS
/// Input：costDistSetId 分摊套, costResultDataId 分摊结果id, itemDr  数据分层id
/// Output：
/// Return：返回dhc.ca.cache.report.CostResultData对象
/// Others：
ClassMethod GetCostReportDataObj(costDistSetId, costResultDataId, itemDr) As dhc.ca.cache.report.CostResultData
{
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	
	s costResultDataIntervalDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 1) // 核算区间
 	s intervalName = $p($g(^DHCCAACCOUNTMONTHS(costResultDataIntervalDr)),"^",2)
 	s costResultDataDistedDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 2) // 分摊科室
 	s distedDeptName = ""
 	i costResultDataDistedDeptDr'="" s distedDeptName = $p($g(^DHCCAUNITDEPTS(costResultDataDistedDeptDr)),"^",2)
 	s costResultDataDistDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 3) // 接收科室
 	s distDeptName = $p($g(^DHCCAUNITDEPTS(costResultDataDistDeptDr)),"^",2)
 	s costResultDataItemDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 4) // 成本项
 	s itemName = $p($g(^DHCCAALLDATAITEMS(costResultDataItemDr)), "^", 3)
 	;w "itemName="_itemName,"costResultDataItemDr="_costResultDataItemDr,!
 	s costResultDataFee = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 5) // 金额
 	s costResultDataDistFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 6) // 分摊标志
 	s costResultDataDealFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 7) // 处理标志
 	
 	Set reportData = ##class(dhc.ca.cache.report.DeptCostStatistic).%New()

    //科室类别和科室分层套层级
    Set distLocTypeName = ""
    Set sortNum = -costResultDataDistDeptDr
    Set levelNum = -1
    Set tmpResult = ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).GetLocTypeSortNum(deptSetDr,costResultDataDistDeptDr)
    ;w "tmpResult="_tmpResult,!
    i tmpResult'="" d
    .Set sortNum = $p(tmpResult,"^",3)
 	.Set distLocTypeName = $p(tmpResult,"^",1)
 	.Set levelNum = $p(tmpResult,"^",4)-1
 	.FOR reps=levelNum:-1:1 {
	.	Set distDeptName = "  "_distDeptName
	.} 
	
	
 	//项目类别和科室分层套层级
 	Set distItemTypeName = ""
    Set sortItemNum = -costResultDataItemDr
    Set levelItemNum = -1
    Set tmpItemResult = ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).GetItemTypeSortNum(itemDr,costResultDataItemDr)
    i tmpItemResult'="" d
    .Set sortItemNum = $p(tmpItemResult,"^",3)
    .;w "sortItemNum="_sortItemNum,!
 	.Set distItemTypeName = $p(tmpItemResult,"^",1)
 	.Set levelItemNum = $p(tmpItemResult,"^",4)-1
 	.FOR reps=levelItemNum:-1:1 {
	.	Set itemName = "  "_itemName
	.} 
 	;w "distDeptName="_distDeptName,!
 	
 	
 	i (distLocTypeName'="")&&(distItemTypeName'="") d
	.Set reportData.money = costResultDataFee //金额
	.Set reportData.deptName = distDeptName  //科室名称
	.Set reportData.deptNum=levelNum   //科室层级
    .Set reportData.deptOrder=sortNum  //科室排序
	.Set reportData.itemName = itemName  //成本项
	.Set reportData.itemNum=sortItemNum   //成本项层级
	.Set reportData.itemOrder=levelItemNum   //成本项排序
	.;s ind = ..GetParentItemReportData(repid, ind, costDistSetId, costResultDataId, reportDataRow)
	;w "reportData.itemNum="_reportData.itemNum,!
	Quit reportData
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成当前分摊结果所有父级科室的报表数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS，DHCCADEPTLEVELSETS
/// Input：costDistSetId 分摊套,  reportDataRow 临时对象，costResultDataId 分摊结果id
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetParentDeptReportData(repid, ind, costDistSetId, costResultDataId, reportDataRow) As %String
{
 	Set deptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 3) // 接收科室
	Set allParentId=$p($g(^tmpdhccadeptleveltree($j,"leaf",deptDr)), "||", 2)
 	i (allParentId'="") d
 	.SET delim="^"
    .SET countdown=$LENGTH(allParentId,delim)-1
    .SET countup=1
    .FOR reps=countdown:-1:1 {
    .  SET extract=$PIECE(allParentId,delim,countup)
    .  Set parentDistDeptName = $p(^DHCCADEPTLEVELSETS(extract),"^",2)
    .  ;w "parentDistDeptName ="_parentDistDeptName,"extract="_extract,"countdown="_countdown,!
 	.  FOR rep=reps-1:-1:1 {
	.  	   Set parentDistDeptName = "  "_parentDistDeptName
	.  } 
    .  Set reportDataRow.deptName = parentDistDeptName  //父级科室名称
    .  Set reportDataRow.deptNum = reps-1  //父级科室分层套层级
    .  Set sortNum = 0
    .  Set tmpLocTypeResult=$g(^tmpdhccadeptleveltree($j,"trunk",extract))
 	.  if tmpLocTypeResult'="" d
 	.  .Set sortNum = $p(tmpLocTypeResult,"||",1)
    .  Set reportDataRow.deptOrder = sortNum  //科室分层套树结构排序
    .  s ind = ..OutputReportRow(repid,ind,reportDataRow)
    .  s ind = ..GetParentItemReportData(repid, ind, costDistSetId, costResultDataId, reportDataRow)
    .  SET countup=countup+1
    .  
    .}

	Quit ind
}

/// Creator：wang ying
/// CreatDate：2009-03-02
/// Description: 生成当前分摊结果所有父级成本科目的报表数据
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS，DHCCADEPTLEVELSETS
/// Input：costDistSetId 分摊套, reportDataRow 临时对象，costResultDataId 分摊结果id
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetParentItemReportData(repid, ind, costDistSetId, costResultDataId, reportDataRow) As %String
{
	Set ItemDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 4) // 成本项
	;w "costDistSetId, costResultDataId,ItemDr="_"  "_costDistSetId,"  "_ costResultDataId," "_ItemDr,!
	Set allParentId=$p($g(^tmpdhccadataleveltree($j,"leaf",ItemDr)), "||", 2)
 	i (allParentId'="") d
 	.SET delim="^"
    .SET countdown=$LENGTH(allParentId,delim)-1
    .SET countup=1
    .FOR reps=countdown:-1:1 {
    .  SET extract=$PIECE(allParentId,delim,countup)
    . ; w "extract="_extract,!
    .  Set parentDistItemName = $p(^DHCCADATALEVELSETS(extract),"^",2)
 	.  FOR rep=reps-1:-1:1 {
	.  	   Set parentDistItemName = "  "_parentDistItemName
	.  } 
	.  ;w "parentDistItemName ="_"  "_parentDistItemName,!
    .  Set reportDataRow.itemName = parentDistItemName  //父级科室名称
    .  Set reportDataRow.itemNum = reps-1  //父级科室分层套层级
    .  Set sortNum = 0
    .  Set tmpItemTypeResult=$g(^tmpdhccadataleveltree($j,"trunk",extract))
 	.  if tmpItemTypeResult'="" d
 	.  .Set sortNum = $p(tmpItemTypeResult,"||",1)
    .  Set reportDataRow.itemOrder = sortNum-1  //科室分层套树结构排序
    .  s ind = ..OutputReportRow(repid, ind, reportDataRow)
    .  SET countup=countup+1
    .}
	
	Quit ind
}

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: 输出一条报表数据
/// Table：
/// Input：reportDataRow 临时对象
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod OutputReportRow(repid, ind, reportDataRow) As %String
{
    set reportDataRow=$g(reportDataRow)
	i (reportDataRow.itemName'="")&&(reportDataRow.deptName'="") d
	.set Data=$lb(reportDataRow.money,reportDataRow.itemName,reportDataRow.itemNum,reportDataRow.itemOrder,reportDataRow.deptName,reportDataRow.deptNum,reportDataRow.deptOrder) ;按顺序对应Query的传出参数
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	Quit ind
}

/// Creator：wang ying
/// CreatDate：2010-03-08
/// Description: 根据临时global生成报表科室树结构(含成本项目类别)
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS，DHCCADEPTLEVELSETS
/// Input：costDistSetId 分摊套id, accountMonthId 核算区间id, dataSetDr 数据分层套id
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getDeptLevelTreeNullDataItem(repid, ind, costDistSetId, accountMonthId, dataSetDr) As %String
{
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    Set dataSetDr=$g(dataSetDr)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)
    //成本类别
    s costItemTypeName = ""
    s itemSortNum = -1
    i dataSetDr'="" d
    .i $d(^DHCCADATALEVELSETS(0,"Parent",dataSetDr)) d
    ..s flag = 0
	..s orderNum=0
 	..f  s orderNum=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum)) q:(orderNum="")||(flag=1)  d
 	...s chidrenId=0
 	...f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum,chidrenId)) q:(chidrenId="")||(flag=1)  d
    ....i $d(^DHCCADATALEVELSETS(chidrenId)) d
    .....Set itemSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",chidrenId)),"||",1)
    .....s costItemTypeName=$p(^DHCCADATALEVELSETS(chidrenId),"^",2)
    .....s flag = 1

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
	.Set ind= ..getDataLevelTreeNullData(repid, ind, costDistSetId,accountMonthId, reportData)
 	.;Set ind = ..OutputReportRow(repid, ind,reportData)
   
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
 	.Set ind = ..getDataLevelTreeNullData(repid, ind, costDistSetId,accountMonthId,reportData)
 	.;Set ind = ..OutputReportRow(repid, ind, reportData)
 	
 	Kill reportData
 	
 	Quit ind
}

/// Creator：wang ying
/// CreatDate：2010-03-09
/// Description: 根据临时global生成报表数据项树结构
/// Table：DHCCACOSTDISTSETS，DHCCADATALEVELSETS
/// Input：costDistSetId 分摊套id, accountMonthId  核算区间id, reportData 临时对象
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getDataLevelTreeNullData(repid, ind, costDistSetId, accountMonthId, reportData) As %String
{


	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)

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
 	.Set itemName = $p($g(^DHCCAALLDATAITEMS(leafId)),"^",3)
 	.FOR reps=levelNum:-1:1 {
	.	Set itemName = "  "_itemName
	.}
	.Set reportData.itemName = itemName  // 成本项
 	.;w reportData.itemName,reportData.deptName ,!
 	.Set ind = ..OutputReportRow(repid,ind,reportData)
   
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
 	.Set itemName = $p($g(^DHCCADATALEVELSETS(trunkId)),"^",2)
 	.Set levelNum = $LENGTH(tmpParentIds,"^")-2
 	.FOR reps=levelNum:-1:1 {
	.	Set itemName = "  "_itemName
	.}
	.Set reportData.itemName = itemName  // 成本项
 	.Set ind = ..OutputReportRow(repid, ind, reportData)
 	
 	;Kill reportData
 	
 	Quit ind
}

/// Creator：秦虎
/// CreatDate：2009-03-02
/// Description: 科室分层套中第一个科室类别
/// Table：DHCCADeptLevelSets
/// Input：deptSetDr 科室分层套
/// Output：
/// Return：返回科室分层套中第一个科室类别ID, 科室类别名称, 科室类别在科室分层套中的排序, 以"^"号分割
/// Others：
ClassMethod GetFirstDeptTypeInDeptSet(deptSetDr) As %String
{
	s result = ""
    //科室类别
    s deptTypeName=""
    s deptSortNum=-1
    i deptSetDr'="" d
    .s flag=0
	.s chidrenId=0
 	.f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,chidrenId)) q:(chidrenId="")  d
 	..s deptTypeName=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",2)
 	..Set deptSortNum = $p($g(^tmpdhccadeptleveltree($j,"trunk",chidrenId)),"||",1)
 	..s flag=1
 	..s result = chidrenId_"^"_deptTypeName_"^"_deptSortNum
	
	Quit result
}

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: query的关闭方法
/// Table：
/// Input：
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod deptStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = deptStatisticExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: query的执行方法
/// Table：
/// Input：costSetDr 分摊套id，itemSetDr 数据分层套id ，month 月份id
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod deptStatisticExecute(ByRef qHandle As %Binary, costSetDr As %String, itemSetDr As %String, month As %String) As %Status
{
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	
	// 生成临时global
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costSetDr)),"^",5)
	Set deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptSetDr,0)
	Set itemCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(itemSetDr,0)

	s ind = ..GetReportNullData(repid, ind, costSetDr,month, itemSetDr)

	s costResultDataId=0
	f  s costResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costSetDr,month,costResultDataId)) q:costResultDataId=""  d
	.i $d(^DHCCACOSTDISTSETS(costSetDr,"CostResultData",costResultDataId)) d
	..set ind = ..GetReportData(repid, ind, costSetDr, costResultDataId,month,itemSetDr)
	s qHandle=$lb(0,repid,0)
	
	// 删除临时global
	Kill ^tmpdhccadeptleveltree($j)

	Quit $$$OK
}

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: query的取数据方法
/// Table：
/// Input：
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod deptStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = deptStatisticExecute ]
{
	// This fetch method should never have to change.
	// repid - Report ID
	// ind - sequence index which represents each row
	// Restore QHandle
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save Qhandle
	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：wang ying
/// CreatDate：2009-03-01
/// Description: query方法
/// Table：
/// Input：costSetDr 分摊套id，itemSetDr 数据分层套id ，month 月份id
/// Output：
/// Return：返回查询状态
/// Others：//d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uDeptStatisticQuery","deptStatistic","1","2","1")
Query deptStatistic(costSetDr As %String, itemSetDr As %String, month As %String) As %Query(ROWSPEC = "money:%Float,itemName:%String,itemNum:%Integer,itemOrder:%Integer,deptName:%String,deptNum:%String,deptOrder:%String")
{
}

}
