Class dhc.ca.cache.report.uReportItemVSDeptList Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/*
 *  成本构成表
 */
/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod GetReportData(repid, ind, argList, costResultDataId, dataTypeFlag) As %String
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set dataSetId = $p($g(argList),"^",6)
	Set leftPanelFlag = $p($g(argList),"^",9)
	
	s reportDataRow = ..GetCostReportDataObj(argList, costResultDataId, dataTypeFlag)
	s res = ..GetParentItemReportData(repid, ind, argList, costResultDataId, reportDataRow)
	Kill reportDataRow
	
	Quit ind
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成成本构成报表的数据
/// Table：data.CostResultData
/// Input：argList 参数列表
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod GetDeptCostStructure(repid, ind, argList) As %String
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set accountMonthId = $p($g(argList),"^",2)
	Set accountMonthList = $p($g(argList),"^",3)
	Set unitdeptId = $p($g(argList),"^",4)
	Set unitdeptList = $p($g(argList),"^",5)
	Set dataSetId = $p($g(argList),"^",6)
	Set itemId = $p($g(argList),"^",7)
	Set itemList = $p($g(argList),"^",8)
	Set leftPanelFlag = $p($g(argList),"^",9)
	
	//累计
	i (accountMonthList'="") d
    .SET monthCountdown=$LENGTH(accountMonthList,",")
    .SET countup=1
    .FOR reps=monthCountdown:-1:1 {
	.   SET currentMonth=$PIECE(accountMonthList,",",countup)
	.   i (currentMonth'=accountMonthId) d
	.   .//
	.	.i (unitdeptList'="") d
    .	..SET deptCountdown=$LENGTH(unitdeptList,",")
    .	..SET deptcountup=1
    .	..FOR depts=deptCountdown:-1:1 {
	.	..  SET currentUnitdept=$PIECE(unitdeptList,",",deptcountup)
	.	..	s costResultDataId=0
	.	..	f  s costResultDataId=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",costDistSetId,currentMonth,currentUnitdept,costResultDataId)) q:costResultDataId=""  d
    .	..	.i $d(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)) d
	.	..	..set ind = ..GetReportData(repid, ind, argList, costResultDataId, "")
	.	..	SET deptcountup=deptcountup+1
	.	..}
	.	SET countup=countup+1
    .}

	//本期
	i (unitdeptList'="") d
    .SET countdown=$LENGTH(unitdeptList,",")
    .SET countup=1
    .FOR reps=countdown:-1:1 {
	.   SET currentUnitdept=$PIECE(unitdeptList,",",countup)
	.	s costResultDataId=0
	.	f  s costResultDataId=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",costDistSetId,accountMonthId,currentUnitdept,costResultDataId)) q:costResultDataId=""  d
    .	.i $d(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)) d
	.	..set ind = ..GetReportData(repid, ind, argList, costResultDataId, "本期")
	.	SET countup=countup+1
	.}

	//生成末级节点数据
	s itemId = 0
	f  s itemId=$o(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf",itemId)) q:itemId=""  d
	.s unitdeptsId = ""
	.f  s unitdeptsId=$o(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf",itemId,unitdeptsId)) q:unitdeptsId=""  d
	..s distFlag = ""
	..f  s distFlag=$o(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf",itemId,unitdeptsId,distFlag)) q:distFlag=""  d
	...s fee = ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf",itemId,unitdeptsId,distFlag)
	...s reportDataRow=..PrepareOutput(argList,"leaf",itemId,unitdeptsId,distFlag,fee)
	...s ind = ..OutputReportRow(repid, ind, reportDataRow)

	//生成非末级节点汇总数据
	s itemId = 0
	f  s itemId=$o(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk",itemId)) q:itemId=""  d
	.s unitdeptsId = ""
	.f  s unitdeptsId=$o(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk",itemId,unitdeptsId)) q:unitdeptsId=""  d
	..s distFlag = ""
	..f  s distFlag=$o(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk",itemId,unitdeptsId,distFlag)) q:distFlag=""  d
	...s fee = ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk",itemId,unitdeptsId,distFlag)
	...s reportDataRow=..PrepareOutput(argList,"trunk",itemId,unitdeptsId,distFlag,fee)
	...s ind = ..OutputReportRow(repid, ind, reportDataRow)

	Quit ind
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成当前分摊结果所有父级成本科目的报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod GetParentItemReportData(repid, ind, argList, costResultDataId, reportDataRow) As %String
{
	Set costDistSetId = $p($g(argList),"^",1)
 	s costResultDataDistDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 3) // 接收科室
 	s costResultDataDistFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 6) // 分摊标志
	Set dataTypeFlag = reportDataRow.dataTypeFlag
	Set costResultDataFee = reportDataRow.CostResultDatafee
	
 	s costResultDataItemDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 4) // 成本项
	Set allParentId=$p($g(^tmpdhccadataleveltree($j,"leaf",costResultDataItemDr)), "||", 2)
 	i (allParentId'="") d
 	.SET delim="^"
    .SET countdown=$LENGTH(allParentId,delim)-1
    .SET countup=1
    .FOR reps=countdown:-1:1 {
    .  SET extract=$PIECE(allParentId,delim,countup)
	.  i ($d(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk", extract, costResultDataDistDeptDr, dataTypeFlag))) d
	.  .Set ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk", extract, costResultDataDistDeptDr, dataTypeFlag) = costResultDataFee + ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk", extract, costResultDataDistDeptDr, dataTypeFlag)
	.  e  d
	.  .Set ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk", extract, costResultDataDistDeptDr, dataTypeFlag) = costResultDataFee
    .  SET countup=countup+1
    .}

	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成一条报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, costResultDataId 分摊结果RowId
/// Output：
/// Return：返回dhc.ca.cache.report.CostResultData对象
/// Others：
ClassMethod GetCostReportDataObj(argList, costResultDataId, dataTypeFlag) As dhc.ca.cache.report.CostResultData
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set dataSetId = $p($g(argList),"^",6)
	;Set dataTypeFlag = "本期"
	
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
 	s costResultDataFee = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 5) // 金额
 	s costResultDataDistFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 6) // 分摊标志
 	s costResultDataDealFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 7) // 处理标志
 	
 	//被分摊科室类别和科室分层套层级
 	s distedLocTypeName = ""
 	s locTypesortNum = 0
 	i costResultDataDistFlag="self" d
    .Set distedLocTypeName = "直接计入"
    .Set locTypesortNum = -1
    //被分摊科室类别和科室分层套层级
    i (costResultDataDistFlag="dist")&&(costResultDataDistedDeptDr'="") d
    .Set tmpResult = ..GetLocTypeSortNum(deptSetDr,costResultDataDistedDeptDr)
    .i tmpResult'="" d
    ..Set distedLocTypeName = $p(tmpResult,"^",1)
    ..Set locTypesortNum = $p(tmpResult,"^",2)
    //接收科室类别和科室分层套层级
    Set distLocTypeName = ""
    Set sortNum = -costResultDataDistDeptDr
    Set levelNum = -1
    Set tmpResult = ..GetLocTypeSortNum(deptSetDr,costResultDataDistDeptDr)
    i tmpResult'="" d
    .Set sortNum = $p(tmpResult,"^",3)
 	.Set distLocTypeName = $p(tmpResult,"^",1)
 	.Set levelNum = $p(tmpResult,"^",4)
 	.FOR reps=levelNum:-1:1 {
	.	Set distDeptName = "  "_distDeptName
	.}  
    //成本项类别和数据分层套树结构排序
    Set dataTypeName = ""
    Set itemSortNum = -costResultDataItemDr
    Set itemLevelNum = -1
    Set dataTypesortNum = -1
    i (dataSetId'="")&&(costResultDataItemDr'="") d
    .Set tmpResult = ..GetDataTypeSortNum(dataSetId,costResultDataItemDr)
    .i tmpResult'="" d
    ..Set dataTypeName = $p(tmpResult,"^",1)
    ..Set dataTypesortNum = $p(tmpResult,"^",2)
    ..Set itemSortNum = $p(tmpResult,"^",3)
    ..Set itemLevelNum = $p(tmpResult,"^",4)
 	..FOR reps=itemLevelNum:-1:1 {
	..	Set itemName = "  "_itemName
	..}  
 	
	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
	Set reportData.CostResultDataintervalName = intervalName  //核算区间
	Set reportData.CostResultDatadistedDeptName = distedDeptName  //分摊科室
	Set reportData.CostResultDatadistDeptName = distDeptName  //接收科室
	Set reportData.CostResultDataitemName = itemName  //成本项
	Set reportData.CostItemTypeName = dataTypeName  //成本项类别
	Set reportData.CostResultDatafee = costResultDataFee //金额
	Set reportData.CostResultDatadistFlag = costResultDataDistFlag  //分摊标记
	Set reportData.CostResultDatadealFlag = costResultDataDealFlag  //CostResultData_dealFlag
	Set reportData.CostDistSetsName = costDistSetName  //分摊套
	Set reportData.distedLocTypeName = distedLocTypeName  //被分摊科室类别
	Set reportData.distLocTypeName = distLocTypeName  //接收科室类别
	Set reportData.levelNum = levelNum  //科室分层套层级
	Set reportData.sortNum = sortNum  //科室分层套树结构排序
	Set reportData.locTypesortNum = locTypesortNum  //被分摊科室科室类别排序
	Set reportData.dataTypeFlag = dataTypeFlag  //数据类型标记
	Set reportData.itemSortNum = itemSortNum  //数据分层套树结构排序
	Set reportData.itemLevelNum = itemLevelNum //数据分层套层级
	Set reportData.dataTypeSortNum = dataTypesortNum //成本项类别排序
	
	i ($d(^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf", costResultDataItemDr, costResultDataDistDeptDr, dataTypeFlag))) d
	.Set ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf", costResultDataItemDr, costResultDataDistDeptDr, dataTypeFlag) = costResultDataFee + ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf", costResultDataItemDr, costResultDataDistDeptDr, dataTypeFlag)
	e  d
	.Set ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf", costResultDataItemDr, costResultDataDistDeptDr, dataTypeFlag) = costResultDataFee

	Quit reportData
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 科室分层套, deptDr 科室码表
/// Output：
/// Return：返回科室类别, 科室类别在科室分层套中的排序, 科室分层套排序和科室分层套层级,以"^"号分割
/// Others：
ClassMethod GetLocTypeSortNum(deptSetDr, deptDr) As %String
{
	Set result=""
 	Set tmpResult=$g(^tmpdhccadeptleveltree($j,"leaf",deptDr))
 	if tmpResult'="" d
 	.Set sortNum = $p(tmpResult,"||",1)
 	.Set tmpParentIds = $p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set locTypeId = $p(tmpParentIds,"^",levelNum)
 	.Set locTypeName = $p($g(^DHCCADEPTLEVELSETS(locTypeId)),"^",2)
 	.Set tmpLocTypeResult=$g(^tmpdhccadeptleveltree($j,"trunk",locTypeId))
 	.if tmpLocTypeResult'="" d
 	..Set locTypeSortNum = $p(tmpLocTypeResult,"||",1)
 	..Set result = locTypeName_"^"_locTypeSortNum_"^"_sortNum_"^"_levelNum
 	
	Quit result
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 数据分层套, itemDr 数据项目码表
/// Output：
/// Return：返回科室类别, 数据类别在数据分层套中的排序, 数据分层套排序和数据分层套层级,以"^"号分割
/// Others：
ClassMethod GetDataTypeSortNum(dataSetId, itemDr) As %String
{
	Set result=""
 	Set tmpResult=$g(^tmpdhccadataleveltree($j,"leaf",itemDr))
 	if tmpResult'="" d
 	.Set sortNum = $p(tmpResult,"||",1)
 	.Set tmpParentIds = $p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set dataTypeId = $p(tmpParentIds,"^",levelNum)
 	.Set dataTypeName = $p($g(^DHCCADATALEVELSETS(dataTypeId)),"^",2)
 	.Set tmpDataTypeResult=$g(^tmpdhccadataleveltree($j,"trunk",dataTypeId))
 	.if tmpDataTypeResult'="" d
 	..Set dataTypeSortNum = $p(tmpDataTypeResult,"||",1)
 	..Set result = dataTypeName_"^"_dataTypeSortNum_"^"_sortNum_"^"_levelNum
 	
	Quit result
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 数据分层套, itemDr 数据项目码表
/// Output：
/// Return：返回科室类别, 数据类别在数据分层套中的排序, 数据分层套排序和数据分层套层级,以"^"号分割
/// Others：
ClassMethod GetDataTypeSortNumTrunk(dataSetId, itemDr) As %String
{
	Set result=""
 	Set tmpResult=$g(^tmpdhccadataleveltree($j,"trunk",itemDr))
 	if tmpResult'="" d
 	.Set sortNum = $p(tmpResult,"||",1)
 	.Set tmpParentIds = $p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set dataLevelNum=levelNum-1
 	.Set dataTypeId = $p(tmpParentIds,"^",levelNum)
 	.Set dataTypeName = $p($g(^DHCCADATALEVELSETS(dataTypeId)),"^",2)
 	.Set tmpDataTypeResult=$g(^tmpdhccadataleveltree($j,"trunk",dataTypeId))
 	.if tmpDataTypeResult'="" d
 	..Set dataTypeSortNum = $p(tmpDataTypeResult,"||",1)
 	..Set result = dataTypeName_"^"_dataTypeSortNum_"^"_sortNum_"^"_dataLevelNum
 	
	Quit result
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 科室分层套中所有科室类别(空数据同时设置数据项)
/// Table：CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAACCOUNTMONTHS table
/// Output：
/// Return：返回临时global的序号ind
/// Others：
ClassMethod GetCostReportDataNullObj(repid, ind, argList) As %String
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set accountMonthId = $p($g(argList),"^",2)
	Set accountMonthList = $p($g(argList),"^",3)
	Set dataSetId = $p($g(argList),"^",6)
	Set leftPanelFlag = $p($g(argList),"^",9)
	Set unitdeptList = $p($g(argList),"^",5)
	
	Set unitdeptName = ""
	Set unitdeptId = $p($g(unitdeptList),",",1)
	i (unitdeptId'="") Set unitdeptName = $p($g(^DHCCAUNITDEPTS(unitdeptId)),"^",2)
		
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)  //分摊套名称
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)
    	
 	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()

	// 根据临时global生成报表数据项树结构
 	;Set ind = ..getDeptLevelTreeNullDataItem(repid, ind, argList,"")
 	Set ind = ..getDataLevelTreeNullData(dataSetId, unitdeptId)
 	
 	Kill reportData
 	
 	QUIT ind
}

/// Creator：秦虎
/// CreatDate：2009-03-01
/// Description: 数据分层套中第一个数据类别
/// Table：data.CostResultData
/// Input：dataSetDr 数据分层套
/// Output：
/// Return：返回数据分层套中第一个数据类别ID, 数据类别名称, 数据类别在数据分层套中的排序, 以"^"号分割
/// Others：
ClassMethod GetFirstDataTypeInDataSet(dataSetDr) As %String
{
	s result = ""
    //数据项
    s dataTypeName=""
    s itemSortNum=-1
    i dataSetDr'="" d
    .s flag=0
 	.s orderNum=0
 	.f  s orderNum=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum)) q:(orderNum="")||(flag=1)  d
 	..s chidrenId=0
 	..f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum,chidrenId)) q:(chidrenId="")||(flag=1)  d
 	...s dataTypeName=$p($g(^DHCCADATALEVELSETS(chidrenId)),"^",2)
 	...Set itemSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",chidrenId)),"||",1)
 	...s flag=1
 	...s result = chidrenId_"^"_dataTypeName_"^"_itemSortNum
	
	Quit result
}

/// Creator：秦虎
/// CreatDate：2009-03-02
/// Description: 科室分层套中第一个科室类别
/// Table：data.CostResultData
/// Input：dataSetDr 科室分层套
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

/*
ClassMethod getDataLevelTreeNullData(repid, ind, argList, unitdeptsName) As %String
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set accountMonthId = $p($g(argList),"^",2)

	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    Set tmpResult = ..GetFirstDeptTypeInDeptSet(deptSetDr)
    Set deptTypeName = $p($g(tmpResult),"^",2)
    Set deptTypeSortNum = $p($g(tmpResult),"^",3)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)

 	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()

	//末层科室
	s leafId=0
	f  s leafId=$o(^tmpdhccadataleveltree($j,"leaf",leafId)) q:leafId=""  d
    .Set reportData.CostResultDataintervalName = intervalName
    .Set reportData.CostResultDatadistedDeptName = ""
    .Set reportData.CostResultDatadistDeptName = unitdeptsName
    .Set reportData.CostResultDataitemName = $p($g(^DHCCAALLDATAITEMS(leafId)),"^",3)
    .Set reportData.CostResultDatafee = 0
    .Set reportData.CostResultDatadistFlag = "self"
    .Set reportData.CostDistSetsName = costDistSetName
    .Set reportData.distedLocTypeName = "直接计入"
 	.Set reportData.distLocTypeName = ""
 	.i deptTypeSortNum'="" Set reportData.sortNum = deptTypeSortNum
 	.Set tmpParentIds = $p($g(^tmpdhccadataleveltree($j,"leaf",leafId)),"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set dataTypeId = $p(tmpParentIds,"^",levelNum)
 	.Set reportData.CostItemTypeName = $p($g(^DHCCADATALEVELSETS(dataTypeId)),"^",2)
 	.Set dataTypeSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",dataTypeId)),"||",1)
 	.i dataTypeSortNum'="" Set reportData.dataTypeSortNum = dataTypeSortNum
 	.e  Set reportData.dataTypeSortNum = -1
 	.Set sortNum=$p($g(^tmpdhccadataleveltree($j,"leaf",leafId)),"||",1)
 	.Set reportData.locTypesortNum = -1
 	.Set reportData.dataTypeFlag = "本期"
 	.Set reportData.itemSortNum = sortNum
 	.i sortNum'="" Set reportData.itemLevelNum = levelNum
 	.Set itemName = $p($g(^DHCCAALLDATAITEMS(leafId)),"^",3)
 	.FOR reps=levelNum:-1:1 {
	.	Set itemName = "  "_itemName
	.}
	.Set reportData.CostResultDataitemName = itemName
 	.Set ind = ..OutputReportRow(repid, ind, reportData)
    //非末层科室
    s trunkId=0
	f  s trunkId=$o(^tmpdhccadataleveltree($j,"trunk",trunkId)) q:trunkId=""  d
    .Set reportData.CostResultDataitemName = $p($g(^DHCCADATALEVELSETS(trunkId)),"^",2)
 	.Set tmpResult=$g(^tmpdhccadataleveltree($j,"trunk",trunkId))
 	.Set tmpParentIds=$p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set dataTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set reportData.CostItemTypeName = $p($g(^DHCCADATALEVELSETS(dataTypeId)),"^",2)
 	.Set dataTypeSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",dataTypeId)),"||",1)
 	.i dataTypeSortNum'="" Set reportData.dataTypeSortNum = dataTypeSortNum
 	.e  Set reportData.dataTypeSortNum = -1
 	.Set reportData.itemLevelNum = $LENGTH(tmpParentIds,"^")-2
 	.Set reportData.itemSortNum = $p(tmpResult,"||",1)
 	.Set itemName = $p($g(^DHCCADATALEVELSETS(trunkId)),"^",2)
 	.Set levelNum = $LENGTH(tmpParentIds,"^")-2
 	.FOR reps=levelNum:-1:1 {
	.	Set itemName = "  "_itemName
	.}
	.Set reportData.CostResultDataitemName = itemName
 	.Set ind = ..OutputReportRow(repid, ind, reportData)
 	
 	Kill reportData
 	
 	Quit ind
}
*/
/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 根据临时global生成报表数据项树结构
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 根据临时global生成报表数据项树结构
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：树形结构临时global,值为金额,^TMPDHCCAREPORTITEMVSDEPTTYPE($j,"leaf",数据项id,分摊科室类别id,"self")
/// Return：返回保存状态
/// Others：
ClassMethod getDataLevelTreeNullData(dataSetDr As %Integer, unitdeptsDr As %Integer) As %String
{
	//末层科室
	s leafId=0
	f  s leafId=$o(^tmpdhccadataleveltree($j,"leaf",leafId)) q:leafId=""  d
 	.Set ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"leaf", leafId, unitdeptsDr, "本期") = 0.0
    //非末层科室
    s trunkId=0
	f  s trunkId=$o(^tmpdhccadataleveltree($j,"trunk",trunkId)) q:trunkId=""  d
 	.Set ^TMPDHCCAREPORTITEMVSDEPTLIST($j,"trunk", trunkId, unitdeptsDr, "本期") = 0.0
 	
 	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod PrepareOutput(argList, flag, itemId, unitdeptsId, distFlag, fee) As dhc.ca.cache.report.CostResultData
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set accountMonthId = $p($g(argList),"^",2)
	Set accountMonthList = $p($g(argList),"^",3)
	Set unitdeptId = $p($g(argList),"^",4)
	Set unitdeptList = $p($g(argList),"^",5)
	Set dataSetId = $p($g(argList),"^",6)
	Set itemList = $p($g(argList),"^",8)
	Set leftPanelFlag = $p($g(argList),"^",9)

	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)  //分摊套
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)
	s distDeptName = $p($g(^DHCCAUNITDEPTS(unitdeptsId)),"^",2)  //接收科室
	
	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
	
	Set itemName = ""  //成本项
	i flag="leaf" d
	.Set itemName = $p($g(^DHCCAALLDATAITEMS(itemId)), "^", 3)
	e  i flag="trunk" d
	.Set itemName = $p($g(^DHCCADATALEVELSETS(itemId)),"^",2)

    //成本项类别和数据分层套树结构排序
    Set dataTypeName = ""
    Set itemSortNum = -itemId
    Set itemLevelNum = -1
    Set dataTypesortNum = -1
    i (dataSetId'="")&&(itemId'="") d
    .i flag="leaf" d
    ..Set tmpResult = ..GetDataTypeSortNum(dataSetId,itemId)
    .e  i flag="trunk" d
    ..Set tmpResult = ..GetDataTypeSortNumTrunk(dataSetId,itemId)
    .i tmpResult'="" d
    ..Set dataTypeName = $p(tmpResult,"^",1)
    ..Set dataTypesortNum = $p(tmpResult,"^",2)
    ..Set itemSortNum = $p(tmpResult,"^",3)
    ..Set itemLevelNum = $p(tmpResult,"^",4)
 	..FOR reps=itemLevelNum:-1:1 {
	..	Set itemName = "  "_itemName
	..}	
	
	Set reportData.CostResultDataintervalName = intervalName  //核算区间
	Set reportData.CostResultDatadistedDeptName = ""  //分摊科室
	Set reportData.CostResultDatadistDeptName = distDeptName  //接收科室
	Set reportData.CostResultDataitemName = itemName  //成本项
	Set reportData.CostItemTypeName = ""  //成本项类别
	Set reportData.CostResultDatafee = fee //金额
	Set reportData.CostResultDatadistFlag = distFlag  //分摊标记
	Set reportData.CostResultDatadealFlag = ""  //CostResultData_dealFlag
	Set reportData.CostDistSetsName = costDistSetName  //分摊套
	Set reportData.distedLocTypeName = ""  //被分摊科室类别
	Set reportData.distLocTypeName = ""  //接收科室类别
	Set reportData.levelNum = 0  //科室分层套层级
	Set reportData.sortNum = 0  //科室分层套树结构排序
	Set reportData.locTypesortNum = 0  //被分摊科室科室类别排序
	Set reportData.dataTypeFlag = distFlag  //数据类型标记
	Set reportData.itemSortNum = itemSortNum  //数据分层套树结构排序
	Set reportData.itemLevelNum = itemLevelNum //数据分层套层级
	Set reportData.dataTypeSortNum = 0 //成本项类别排序
	
	&SQL(INSERT INTO dhc_ca_cache_data.ReportResult (ReportResult_repType,ReportResult_intervalDr,ReportResult_distSetDr,ReportResult_dataSetDr,ReportResult_fee,ReportResult_deptName,ReportResult_deptLayer,ReportResult_deptOrder,ReportResult_deptType,ReportResult_itemName,ReportResult_itemLayer,ReportResult_itemOrder,ReportResult_itemType,ReportResult_dataType,ReportResult_deptDr,ReportResult_itemDr,ReportResult_FDName,ReportResult_FDDr,ReportResult_FDTName,ReportResult_FDTDr,ReportResult_FDTOrder) VALUES ("cbgcfx",:accountMonthId,:costDistSetId,:dataSetId,:fee,:distDeptName,0,0,"",:itemName,:itemLevelNum,:itemSortNum,"",:distFlag,:unitdeptsId,:itemId,"",0,"",0,0))

	Quit reportData
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出一条报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod OutputReportRow(repid, ind, reportDataRow) As %String
{
	set Data=$lb(reportDataRow.CostResultDataintervalName,reportDataRow.CostResultDatadistedDeptName,reportDataRow.CostResultDatadistDeptName,reportDataRow.CostResultDataitemName,reportDataRow.CostItemTypeName,reportDataRow.CostResultDatafee,reportDataRow.CostResultDatadistFlag,reportDataRow.CostResultDatadealFlag,reportDataRow.CostDistSetsName,reportDataRow.distedLocTypeName,reportDataRow.distLocTypeName,reportDataRow.levelNum,reportDataRow.sortNum,reportDataRow.locTypesortNum,reportDataRow.dataTypeFlag,reportDataRow.itemSortNum,reportDataRow.itemLevelNum,reportDataRow.dataTypeSortNum) ;按顺序对应Query的传出参数
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	
	Quit ind
}

ClassMethod ListCostResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListCostResultExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

// 分摊套^核算区间^核算区间列表^科室^科室列表^数据分层套^成本项^成本项列表^报表左栏标记

ClassMethod ListCostResultExecute(ByRef qHandle As %Binary, argList As %String) As %Status
{
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	
	Set costDistSetId = $p($g(argList),"^",1)
	Set accountMonthId = $p($g(argList),"^",2)
	Set accountMonthList = $p($g(argList),"^",3)
	Set unitdeptId = $p($g(argList),"^",4)
	Set unitdeptList = $p($g(argList),"^",5)
	Set dataSetId = $p($g(argList),"^",6)
	Set itemId = $p($g(argList),"^",7)
	Set itemList = $p($g(argList),"^",8)
	Set leftPanelFlag = $p($g(argList),"^",9)
	
	Set resultSet=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do resultSet.Prepare("SELECT * FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType = ? AND ReportResult_intervalDr = ? AND ReportResult_distSetDr = ? AND ReportResult_dataSetDr = ?")
	Do resultSet.Execute("cbgcfx", accountMonthId, costDistSetId, dataSetId)
	Set existFlag = 0
	For  Quit:('resultSet.Next())||(existFlag=1)  Do
	. Set existFlag=1
	Do resultSet.Close()
	If existFlag=1 d
	.&SQL(DELETE FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType = "cbgcfx" AND ReportResult_intervalDr = :accountMonthId AND ReportResult_distSetDr = :costDistSetId AND ReportResult_dataSetDr = :dataSetId)

	// 生成临时global
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	Set dataCountNum = ##class(dhc.ca.cache.report.uCostResultData).getDatalevelSetSortedTree(dataSetId,0)
	
	//科室分层套中所有科室类别
	set ind = ..GetCostReportDataNullObj(repid, ind, argList)
	
	//成本构成报表
	s ind = ..GetDeptCostStructure(repid, ind, argList)
	
	s qHandle=$lb(0,repid,0)
	
	// 删除临时global
	Kill ^tmpdhccadeptleveltree($j)
	Kill ^tmpdhccadataleveltree($j)
	Kill ^TMPDHCCAREPORTITEMVSDEPTLIST($j)

	Quit $$$OK
}

ClassMethod ListCostResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListCostResultExecute ]
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

// 分摊套^核算区间^核算区间列表^科室^科室列表^数据分层套^成本项^成本项列表^报表左栏标记

Query ListCostResult(argList As %String) As %Query(ROWSPEC = "CostResultDataintervalName:%String:核算区间,CostResultDatadistedDeptName:%String:分摊科室,CostResultDatadistDeptName:%String:接收科室,CostResultDataitemName:%String:成本项,CostItemTypeName:%String:成本项类别,CostResultDatafee:%Float:金额,CostResultDatadistFlag:%String:分摊标记,CostResultDatadealFlag:%String:CostResultDatadealFlag,CostDistSetsName:%String:分摊套,distedLocTypeName:%String:被分摊科室类别,distLocTypeName:%String:接收科室类别,levelNum:%Integer:科室分层套层级,sortNum:%Integer:科室分层套树结构排序,locTypesortNum:%Integer:被分摊科室科室类别排序,dataTypeFlag:%String:数据类型标记,itemSortNum:%Integer:数据分层套树结构排序,itemLevelNum:%Integer:数据分层套层级,dataTypeSortNum:%Integer:成本项类别排序")
{
}

ClassMethod LookupCostResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookupCostResultExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod LookupCostResultExecute(ByRef qHandle As %Binary, argList As %String) As %Status
{
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	
	Set costDistSetId = $p($g(argList),"^",1)
	Set accountMonthId = $p($g(argList),"^",2)
	Set accountMonthList = $p($g(argList),"^",3)
	Set unitdeptId = $p($g(argList),"^",4)
	Set unitdeptList = $p($g(argList),"^",5)
	Set dataSetId = $p($g(argList),"^",6)
	Set itemId = $p($g(argList),"^",7)
	Set itemList = $p($g(argList),"^",8)
	Set leftPanelFlag = $p($g(argList),"^",9)
	
	Set resultSet=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Do resultSet.Prepare("SELECT * FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType = ? AND ReportResult_intervalDr = ? AND ReportResult_distSetDr = ? AND ReportResult_dataSetDr = ?")
	Do resultSet.Execute("cbgcfx", accountMonthId, costDistSetId, dataSetId)
	Set existFlag = 0
	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
	For  Quit:('resultSet.Next())  Do
	. Set existFlag=1
	. Set accountMonthId = resultSet.Data("ReportResult_intervalDr")
	. Set reportData.CostResultDataintervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)  //核算区间
	. Set reportData.CostResultDatadistedDeptName = ""  //分摊科室
	. Set reportData.CostResultDatadistDeptName = resultSet.Data("ReportResult_deptName")  //接收科室
	. Set reportData.CostResultDataitemName = resultSet.Data("ReportResult_itemName")  //成本项
	. Set reportData.CostItemTypeName = ""  //成本项类别
	. Set reportData.CostResultDatafee = resultSet.Data("ReportResult_fee") //金额
	. Set reportData.CostResultDatadistFlag = "self"  //resultSet.Data("ReportResult_distFlag")  //分摊标记
	. Set reportData.CostResultDatadealFlag = ""  //CostResultData_dealFlag
	. Set costDistSetId = resultSet.Data("ReportResult_distSetDr")
	. Set reportData.CostDistSetsName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)  //分摊套
	. Set reportData.distedLocTypeName = ""  //被分摊科室类别
	. Set reportData.distLocTypeName = ""  //接收科室类别
	. Set reportData.levelNum = 0  //科室分层套层级
	. Set reportData.sortNum = 0  //科室分层套树结构排序
	. Set reportData.locTypesortNum = 0  //被分摊科室科室类别排序
	. Set reportData.dataTypeFlag = resultSet.Data("ReportResult_dataType")  //数据类型标记
	. Set reportData.itemSortNum = resultSet.Data("ReportResult_itemOrder")  //数据分层套树结构排序
	. Set reportData.itemLevelNum = resultSet.Data("ReportResult_itemLayer") //数据分层套层级
	. Set reportData.dataTypeSortNum = 0 //成本项类别排序
	. s ind = ..OutputReportRow(repid, ind, reportData)
	Kill reportData
	Do resultSet.Close()
	
	s qHandle=$lb(0,repid,0)

	Quit $$$OK
}

ClassMethod LookupCostResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookupCostResultExecute ]
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

// 分摊套^核算区间^核算区间列表^科室^科室列表^数据分层套^成本项^成本项列表^报表左栏标记

Query LookupCostResult(argList As %String) As %Query(ROWSPEC = "CostResultDataintervalName:%String:核算区间,CostResultDatadistedDeptName:%String:分摊科室,CostResultDatadistDeptName:%String:接收科室,CostResultDataitemName:%String:成本项,CostItemTypeName:%String:成本项类别,CostResultDatafee:%Float:金额,CostResultDatadistFlag:%String:分摊标记,CostResultDatadealFlag:%String:CostResultDatadealFlag,CostDistSetsName:%String:分摊套,distedLocTypeName:%String:被分摊科室类别,distLocTypeName:%String:接收科室类别,levelNum:%Integer:科室分层套层级,sortNum:%Integer:科室分层套树结构排序,locTypesortNum:%Integer:被分摊科室科室类别排序,dataTypeFlag:%String:数据类型标记,itemSortNum:%Integer:数据分层套树结构排序,itemLevelNum:%Integer:数据分层套层级,dataTypeSortNum:%Integer:成本项类别排序")
{
}

Storage Default
{
<Data name="uReportItemVSDeptListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uReportItemVSDeptListD</DataLocation>
<DefaultData>uReportItemVSDeptListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uReportItemVSDeptListD</IdLocation>
<IndexLocation>^dhc.ca.c.uReportItemVSDeptListI</IndexLocation>
<StreamLocation>^dhc.ca.c.uReportItemVSDeptListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
