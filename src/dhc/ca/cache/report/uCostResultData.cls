Class dhc.ca.cache.report.uCostResultData Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

Projection uCostResultData As %Projection.Java(ROOTDIR = "c:\temp");

/// Creator：秦虎
/// CreatDate：2009-12-31
/// Description: 查询符合条件的记录
/// Table：CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod ListDistResult(costDistSetId, accountMonthId) As %String
{
	Set startTime = $zh
	
	Set res=..ListDistResultByItem(costDistSetId, accountMonthId, "")
	
	Set soptTime = $zh

    Quit (soptTime-startTime)
}

/// Creator：秦虎
/// CreatDate：2009-12-31
/// Description: 查询符合条件的记录(包含多个核算期间汇总)
/// Table：CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod ListDistResultSumByMonth(costDistSetId, accountMonthId, dataSetDr, dataTypeFlag) As %String
{
	Quit:'$d(^DHCCACOSTDISTSETS(costDistSetId)) "-1"
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	
	;Do ##class(dhc.ca.cache.report.CostResultData).%DeleteExtent() // 删除dhc.ca.cache.report.CostResultData表中的所有数据
	
	// 生成临时global
	Set deptCountNum = ..getDeptlevelSetSortedTree(deptSetDr,0)
	Set dataCountNum = ..getDatalevelSetSortedTree(dataSetDr,0)
	// 根据临时global生成报表科室树结构
	Set res = ..getDeptLevelTreeNullDataItem(costDistSetId,accountMonthId,dataSetDr)

	s CostResultDataId=0
	f  s CostResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetId,accountMonthId,CostResultDataId)) q:CostResultDataId=""  d
	.set rec = ..SaveReportTempDataWithItemFlag(costDistSetId,CostResultDataId,dataSetDr,dataTypeFlag,"1")

	// 删除临时global
	Kill ^tmpdhccadeptleveltree($j)
	Kill ^tmpdhccadataleveltree($j)

    Quit res
}

/// Creator：秦虎
/// CreatDate：2009-12-31
/// Description: 查询符合条件的记录(按数据项归类)
/// Table：CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod ListDistResultByItem(costDistSetId, accountMonthId, dataSetDr) As %String
{
	Quit:'$d(^DHCCACOSTDISTSETS(costDistSetId)) "-1"
	
	Do ##class(dhc.ca.cache.report.CostResultData).%DeleteExtent() // 删除dhc.ca.cache.report.CostResultData表中的所有数据
	
	i dataSetDr="" Set res = ..ListDistResultSortByDept(costDistSetId, accountMonthId)
	e  Set res = ..ListDistResultSortByItem(costDistSetId, accountMonthId, dataSetDr)		
    
    Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-25
/// Description: 查询符合条件的记录, 按科室分组
/// Table：CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod ListDistResultSortByDept(costDistSetId, accountMonthId) As %String
{
	
	Quit:'$d(^DHCCACOSTDISTSETS(costDistSetId)) "-1"
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	
	// 生成临时global
	Set deptCountNum = ..getDeptlevelSetSortedTree(deptSetDr,0)
	//科室分层套中所有科室类别
	Set res = ..getLocTypeNullData(costDistSetId,accountMonthId)
	// 根据临时global生成报表科室树结构
	Set res = ..getDeptLevelTreeNullData(costDistSetId,accountMonthId)
	
	s CostResultDataId=0
	f  s CostResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetId,accountMonthId,CostResultDataId)) q:CostResultDataId=""  d
	.set rec = ..SaveReportTempData(costDistSetId,CostResultDataId)
	.;set rec = 1
	
	// 删除临时global
	Kill ^tmpdhccadeptleveltree($j)
	
	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 查询符合条件的记录, 按项目分组
/// Table：CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间, dataSetDr 数据项分层套
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod ListDistResultSortByItem(costDistSetId, accountMonthId, dataSetDr) As %String
{
	Quit:'$d(^DHCCACOSTDISTSETS(costDistSetId)) "-1"
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)

	// 生成临时global
	Set dataCountNum = ..getDatalevelSetSortedTree(dataSetDr,0)
	Set deptCountNum = ..getDeptlevelSetSortedTree(deptSetDr,0)
	//科室分层套中所有科室类别
	Set res = ..getLocTypeNullDataWithItem(costDistSetId,accountMonthId,dataSetDr)
	// 根据临时global生成报表数据项树结构
	Set res = ..getDataLevelTreeNullData(costDistSetId,accountMonthId,"")
	
	s CostResultDataId=0
	f  s CostResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetId,accountMonthId,CostResultDataId)) q:CostResultDataId=""  d
	.set rec = ..SaveReportTempDataWithItem(costDistSetId,CostResultDataId,dataSetDr)
	
	// 删除临时global
	Kill ^tmpdhccadataleveltree($j)

	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 删除dhc.ca.cache.report.CostResultData表中的所有数据
/// Table：CostResultData
/// Input：
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod DeleteAllDataInCostResultData() As %String
{
	Do ##class(dhc.ca.cache.report.CostResultData).%DeleteExtent()
	
	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 查询符合条件的记录, 按项目分组
/// Table：CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间, dataSetDr 数据项分层套, unitdeptsId 单位部门码表
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod ListDistResultDeptSortByItem(costDistSetId, accountMonthId, dataSetDr, unitdeptsId, dataTypeFlag) As %String
{
	Quit:'$d(^DHCCACOSTDISTSETS(costDistSetId)) "-1"

	;Do ##class(dhc.ca.cache.report.CostResultData).%DeleteExtent() // 删除dhc.ca.cache.report.CostResultData表中的所有数据

	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)

	// 生成临时global
	Set dataCountNum = ..getDatalevelSetSortedTree(dataSetDr,0)
	Set deptCountNum = ..getDeptlevelSetSortedTree(deptSetDr,0)
	//科室分层套中所有科室类别
	Set unitdeptsName=$p($g(^DHCCAUNITDEPTS(unitdeptsId)),"^",2)
	Set res = ..getLocTypeNullDataWithItemDept(costDistSetId,accountMonthId,dataSetDr,unitdeptsName)
	// 根据临时global生成报表数据项树结构
	Set res = ..getDataLevelTreeNullData(costDistSetId,accountMonthId,unitdeptsName)
	
	s CostResultDataId=0
	f  s CostResultDataId=$o(^DHCCACOSTDISTSETS(0,"DIntDistdept",costDistSetId,accountMonthId,unitdeptsId,CostResultDataId)) q:CostResultDataId=""  d
	.set rec = ..SaveReportTempDataWithItemFlag(costDistSetId,CostResultDataId,dataSetDr,dataTypeFlag,"2")
	
	// 删除临时global
	Kill ^tmpdhccadataleveltree($j)

	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 科室分层套中所有科室类别(空数据)
/// Table：CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAACCOUNTMONTHS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getLocTypeNullData(costDistSetId, accountMonthId) As %String
{
	Set res=..getLocTypeNullDataWithItem(costDistSetId,accountMonthId,"")
 	
 	QUIT res
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 科室分层套中所有科室类别(空数据同时设置数据项)
/// Table：CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAACCOUNTMONTHS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getLocTypeNullDataWithItem(costDistSetId, accountMonthId, dataSetDr) As %String
{
	Set res=..getLocTypeNullDataWithItemDept(costDistSetId,accountMonthId,dataSetDr,"")
 	
 	QUIT res
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 科室分层套中所有科室类别(空数据同时设置数据项)
/// Table：CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAACCOUNTMONTHS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getLocTypeNullDataWithItemDept(costDistSetId, accountMonthId, dataSetDr, unitdeptsName) As %String
{
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)
    //数据项
    s dataSetName=""
    s itemSortNum=-1
    i dataSetDr'="" d
    .s flag=0
 	.s itemTypeId=0
 	.f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId)) q:(itemTypeId="")||(flag=1)  d
 	..s allDataItemsId=0
 	..f  s allDataItemsId=$o(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId,allDataItemsId)) q:(allDataItemsId="")||(flag=1)  d
 	...s dataSetName=$p($g(^DHCCAALLDATAITEMS(allDataItemsId)),"^",3)
 	...if $d(^tmpdhccadataleveltree($j,"leaf",allDataItemsId)) d
 	....Set sortLevelTmp=$g(^tmpdhccadataleveltree($j,"leaf",allDataItemsId))
 	....Set itemSortNum = $p(sortLevelTmp,"||",1)
 	...s flag=1
	.i flag=0 d
 	..s orderNum=0
 	..f  s orderNum=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum)) q:(orderNum="")||(flag=1)  d
 	...s chidrenId=0
 	...f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum,chidrenId)) q:(chidrenId="")||(flag=1)  d
 	....s dataSetName=$p($g(^DHCCADATALEVELSETS(chidrenId)),"^",2)
 	....Set itemSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",chidrenId)),"||",1)
 	....s flag=1
	
	//科室分层套中所有科室类别
	s chidrenId=0
	s distLocTypeName=""
 	f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,chidrenId)) q:(chidrenId="")  d
 	.s distLocTypeName=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",2)
 	.s activeStatus=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",6)
 	.Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .Set reportData.CostResultDataintervalName = intervalName
    .Set reportData.CostResultDatadistedDeptName = distLocTypeName
    .i unitdeptsName="" Set reportData.CostResultDatadistDeptName = distLocTypeName
    .e  Set reportData.CostResultDatadistDeptName = unitdeptsName
    .Set reportData.CostResultDataitemName = dataSetName
    .Set reportData.CostResultDatafee = 0
    .Set reportData.CostResultDatadistFlag = ""
    .Set reportData.CostDistSetsName = costDistSetName
    .Set reportData.distedLocTypeName = distLocTypeName
    .Set reportData.distLocTypeName = distLocTypeName
 	.Set reportData.levelNum = 0
 	.Set tmpResult=$g(^tmpdhccadeptleveltree($j,"trunk",chidrenId))
 	.i dataSetDr="" d
 	..Set reportData.sortNum = $p(tmpResult,"||",1)
 	.e  d
 	..Set reportData.sortNum = itemSortNum
 	.Set reportData.locTypesortNum = $p(tmpResult,"||",1)
 	.i (activeStatus="Y")||(activeStatus="y") d
 	..Set sc = reportData.%Save()
 	..i $$$ISERR(sc) d
 	...Do $System.Status.DisplayError()
 	.Kill reportData
 	
 	QUIT "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 根据临时global生成报表科室树结构
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getDeptLevelTreeNullData(costDistSetId, accountMonthId) As %String
{
	Set res = ..getDeptLevelTreeNullDataItem(costDistSetId, accountMonthId, "")
	
	Quit res
}

/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 根据临时global生成报表科室树结构(含成本项目类别)
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getDeptLevelTreeNullDataItem(costDistSetId, accountMonthId, dataSetDr) As %String
{
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
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

	//末层科室
	s leafId=0
	f  s leafId=$o(^tmpdhccadeptleveltree($j,"leaf",leafId)) q:leafId=""  d
 	.Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .Set reportData.CostResultDataintervalName = intervalName
    .Set reportData.CostResultDatadistedDeptName = ""
    .Set reportData.CostResultDatadistDeptName = $p($g(^DHCCAUNITDEPTS(leafId)),"^",2)
    .Set reportData.CostResultDataitemName = costItemTypeName
    .Set reportData.itemSortNum = itemSortNum
    .Set reportData.CostItemTypeName = costItemTypeName
    .Set reportData.CostResultDatafee = 0
    .Set reportData.CostResultDatadistFlag = ""
    .Set reportData.CostDistSetsName = costDistSetName
    .Set reportData.distedLocTypeName = "直接计入"
    .Set tmpResult = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(deptSetDr,leafId)
 	.Set reportData.distLocTypeName = $p(tmpResult,"||",2)
 	.Set reportData.levelNum = $p(tmpResult,"||",1)
 	.Set sortNum=$p($g(^tmpdhccadeptleveltree($j,"leaf",leafId)),"||",1)
 	.i sortNum'="" Set reportData.sortNum = sortNum
 	.Set reportData.locTypesortNum = -1
 	.Set sc = reportData.%Save()
 	.i $$$ISERR(sc) d
 	..Do $System.Status.DisplayError()
 	.Kill reportData
    //非末层科室
    s trunkId=0
	f  s trunkId=$o(^tmpdhccadeptleveltree($j,"trunk",trunkId)) q:trunkId=""  d
 	.Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .Set reportData.CostResultDataintervalName = intervalName
    .Set reportData.CostResultDatadistedDeptName = ""
    .Set reportData.CostResultDatadistDeptName = $p($g(^DHCCADEPTLEVELSETS(trunkId)),"^",2)
    .Set reportData.CostResultDataitemName = costItemTypeName
    .Set reportData.itemSortNum = itemSortNum
    .Set reportData.CostItemTypeName = costItemTypeName
    .Set reportData.CostResultDatafee = 0
    .Set reportData.CostResultDatadistFlag = ""
    .Set reportData.CostDistSetsName = costDistSetName
    .Set reportData.distedLocTypeName = "直接计入"
 	.Set tmpResult=$g(^tmpdhccadeptleveltree($j,"trunk",trunkId))
 	.Set tmpParentIds=$p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set distLocTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set reportData.distLocTypeName = $p($g(^DHCCADEPTLEVELSETS(distLocTypeId)),"^",2)
 	.Set reportData.levelNum = $LENGTH(tmpParentIds,"^")-2
 	.Set reportData.sortNum = $p(tmpResult,"||",1)
 	.Set reportData.locTypesortNum = -1
 	.Set sc = reportData.%Save()
 	.i $$$ISERR(sc) d
 	..Do $System.Status.DisplayError()
 	.Kill reportData
 	
 	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-17
/// Description: 根据临时global生成报表数据项树结构
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod getDataLevelTreeNullData(costDistSetId, accountMonthId, unitdeptsName) As %String
{
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)

	//末层科室
	s leafId=0
	f  s leafId=$o(^tmpdhccadataleveltree($j,"leaf",leafId)) q:leafId=""  d
 	.Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .Set reportData.CostResultDataintervalName = intervalName
    .Set reportData.CostResultDatadistedDeptName = ""
    .Set reportData.CostResultDatadistDeptName = unitdeptsName
    .Set reportData.CostResultDataitemName = $p($g(^DHCCAALLDATAITEMS(leafId)),"^",3)
    .Set reportData.CostResultDatafee = 0
    .Set reportData.CostResultDatadistFlag = ""
    .Set reportData.CostDistSetsName = costDistSetName
    .Set reportData.distedLocTypeName = "直接计入"
 	.Set reportData.distLocTypeName = ""
 	.Set tmpParentIds = $p($g(^tmpdhccadataleveltree($j,"leaf",leafId)),"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set reportData.levelNum = levelNum
 	.Set sortNum=$p($g(^tmpdhccadataleveltree($j,"leaf",leafId)),"||",1)
 	.i sortNum'="" Set reportData.sortNum = sortNum
 	.Set reportData.locTypesortNum = -1
 	.Set sc = reportData.%Save()
 	.i $$$ISERR(sc) d
 	..Do $System.Status.DisplayError()
 	.Kill reportData
    //非末层科室
    s trunkId=0
	f  s trunkId=$o(^tmpdhccadataleveltree($j,"trunk",trunkId)) q:trunkId=""  d
 	.Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .Set reportData.CostResultDataintervalName = intervalName
    .Set reportData.CostResultDatadistedDeptName = ""
    .Set reportData.CostResultDatadistDeptName = unitdeptsName
    .Set reportData.CostResultDataitemName = $p($g(^DHCCADATALEVELSETS(trunkId)),"^",2)
    .Set reportData.CostResultDatafee = 0
    .Set reportData.CostResultDatadistFlag = ""
    .Set reportData.CostDistSetsName = costDistSetName
    .Set reportData.distedLocTypeName = "直接计入"
 	.Set tmpResult=$g(^tmpdhccadataleveltree($j,"trunk",trunkId))
 	.Set tmpParentIds=$p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set distLocTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set reportData.distLocTypeName = ""
 	.Set reportData.levelNum = $LENGTH(tmpParentIds,"^")-2
 	.Set reportData.sortNum = $p(tmpResult,"||",1)
 	.Set reportData.locTypesortNum = -1
 	.Set sc = reportData.%Save()
 	.i $$$ISERR(sc) d
 	..Do $System.Status.DisplayError()
 	.Kill reportData
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存临时报表数据
/// Table：dhc.ca.cache.report.CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod SaveReportTempData(costDistSetId, CostResultDataId) As %String
{
	Set res=..SaveReportTempDataWithItem(costDistSetId, CostResultDataId, "")
	
 	Quit res
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存临时报表数据
/// Table：dhc.ca.cache.report.CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod SaveReportTempDataWithItem(costDistSetId, CostResultDataId, dataSetDr) As %String
{
	Set res=..SaveReportTempDataWithItemFlag(costDistSetId, CostResultDataId, dataSetDr, "", "1")
	
 	Quit res
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存临时报表数据(按数据项归类)
/// Table：dhc.ca.cache.report.CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回保存状态
/// Others：
ClassMethod SaveReportTempDataWithItemFlag(costDistSetId, CostResultDataId, dataSetDr, dataTypeFlag, leftPanelFlag) As %String
{
	Quit:'$d(^DHCCACOSTDISTSETS(costDistSetId)) "-1"
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)
    Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	
	s intervalDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 1) // 核算区间
 	s intervalName = $p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
 	s distedDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 2) // 分摊科室
 	s distedDeptName = ""
 	i distedDeptDr'="" s distedDeptName = $p($g(^DHCCAUNITDEPTS(distedDeptDr)),"^",2)
 	s distDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 3) // 接收科室
 	s distDeptName = $p($g(^DHCCAUNITDEPTS(distDeptDr)),"^",2)
 	s itemDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 4) // 成本项
 	s itemName = $p($g(^DHCCAALLDATAITEMS(itemDr)), "^", 3)
 	s fee = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 5) // 金额
 	s distFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 6) // 分摊标志
 	s dealFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 7) // 处理标志
 	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    Set reportData.CostResultDataintervalName = intervalName
    Set reportData.CostResultDatadistedDeptName = distedDeptName
    Set reportData.CostResultDatadistDeptName = distDeptName
    Set reportData.CostResultDataitemName = itemName
    Set reportData.CostResultDatafee = fee
    Set reportData.CostResultDatadistFlag = distFlag
    Set reportData.CostDistSetsName = costDistSetName
    Set reportData.dataTypeFlag = dataTypeFlag
    i distFlag="self" d
    .Set reportData.distedLocTypeName = "直接计入"
    .Set reportData.locTypesortNum = -1
    //被分摊科室类别
    i (distFlag="dist")&&(distedDeptDr'="") d
    .Set tmpResult = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(deptSetDr,distedDeptDr)
    .Set reportData.distedLocTypeName = $p(tmpResult,"||",2)
    .Set tmpParentIds=..AllParentLocIdFindByUnitdeptsId(deptSetDr, distedDeptDr)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set distLocTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set tmpResult=$g(^tmpdhccadeptleveltree($j,"trunk",distLocTypeId))
 	.Set reportData.locTypesortNum = $p(tmpResult,"||",1)
 	//接收科室类别和科室分层套层级
 	Set tmpResult = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(deptSetDr,distDeptDr)
 	Set reportData.distLocTypeName = $p(tmpResult,"||",2)
 	;Set reportData.levelNum = $p(tmpResult,"||",1)
 	i (dataSetDr="")||(leftPanelFlag="1") d
 	.if $d(^tmpdhccadeptleveltree($j,"leaf",distDeptDr)) Set reportData.sortNum = $p($g(^tmpdhccadeptleveltree($j,"leaf",distDeptDr)),"||",1)
 	.e  Set reportData.sortNum = -distDeptDr
 	.Set reportData.levelNum = $p(tmpResult,"||",1)
 	.if $d(^tmpdhccadataleveltree($j,"leaf",itemDr)) d
 	..Set sortLevelTmp=$g(^tmpdhccadataleveltree($j,"leaf",itemDr))
 	..set levelNumTmp=$p(sortLevelTmp,"||",2)
 	..set levelNum=$LENGTH(levelNumTmp,"^")-1
    ..Set dataLevelSetId = $p(levelNumTmp,"^",levelNum)
 	..Set reportData.itemSortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",dataLevelSetId)),"||",1)
    ..Set costItemTypeName = $p($g(^DHCCADATALEVELSETS(dataLevelSetId)),"^",2)
    ..Set reportData.CostItemTypeName = costItemTypeName
 	.e  d
 	..Set reportData.itemSortNum = -itemDr
 	..Set reportData.CostItemTypeName = itemName
 	.//保存父级科室汇总信息
 	.Set res = ..GenParenDepttSumData(deptSetDr, distDeptDr, reportData)
 	e  d
 	.if $d(^tmpdhccadataleveltree($j,"leaf",itemDr)) d
 	..Set sortLevelTmp=$g(^tmpdhccadataleveltree($j,"leaf",itemDr))
 	..Set reportData.sortNum = $p(sortLevelTmp,"||",1)
 	..set levelNumTmp=$p(sortLevelTmp,"||",2)
 	..set levelNum=$LENGTH(levelNumTmp,"^")-1
 	..Set reportData.levelNum = levelNum
    ..Set dataLevelSetId = $p(levelNumTmp,"^",levelNum)
    ..Set costItemTypeName = $p($g(^DHCCADATALEVELSETS(dataLevelSetId)),"^",2)
    ..Set reportData.CostItemTypeName = costItemTypeName
 	.e  d
 	..Set reportData.sortNum = -itemDr
 	..Set reportData.levelNum = -1
 	..Set reportData.CostItemTypeName = itemName
 	.//保存父级科室汇总信息
 	.Set res = ..GenParenItemSumData(dataSetDr, itemDr, reportData)
 	Set sc = reportData.%Save()
 	i $$$ISERR(sc) d
 	.Do $System.Status.DisplayError()
 	
 	Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存所有父级科室汇总金额
/// Table：dhc.ca.cache.report.CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table, reportData---科室报表数据
/// Output：
/// Return：返回科室列表 RowId1^RowId2^...
/// Others：
ClassMethod GenParenDepttSumData(deptSetDr, distDeptDr, reportData) As %String
{
	Set res = ..GenParenDepttSumDataWithFlag(deptSetDr, distDeptDr, reportData, "")
	
	Quit res
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存所有父级科室汇总金额
/// Table：dhc.ca.cache.report.CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table, reportData---科室报表数据
/// Output：
/// Return：返回科室列表 RowId1^RowId2^...
/// Others：
ClassMethod GenParenDepttSumDataWithFlag(deptSetDr, distDeptDr, reportData, dataTypeFlag) As %String
{
 	//保存父级科室汇总信息
 	s distDeptCode = $p(^DHCCAUNITDEPTS(distDeptDr),"^",1)
 	Set allParentId = ..AllParentLocIdFindByUnitdeptsId(deptSetDr, distDeptDr)
 	i (allParentId'="") d
 	.SET delim="^"
    .SET countdown=$LENGTH(allParentId,delim)-1
    .SET countup=1
    .FOR reps=countdown:-1:1 {
    .  SET extract=$PIECE(allParentId,delim,countup)
    .  Set parentReportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .  Set parentReportData.CostResultDataintervalName = reportData.CostResultDataintervalName
    .  Set parentReportData.CostResultDatadistedDeptName = reportData.CostResultDatadistDeptName
    .  Set parentDistDeptName = $p(^DHCCADEPTLEVELSETS(extract),"^",2)
    .  Set parentReportData.CostResultDatadistDeptName = parentDistDeptName
    .  Set parentReportData.CostResultDataitemName = reportData.CostResultDataitemName
    .  Set parentReportData.CostItemTypeName = reportData.CostItemTypeName
    .  Set parentReportData.CostResultDatafee = reportData.CostResultDatafee
    .  Set parentReportData.CostResultDatadistFlag = reportData.CostResultDatadistFlag
    .  Set parentReportData.CostDistSetsName = reportData.CostDistSetsName
    .  Set parentReportData.distedLocTypeName = reportData.distedLocTypeName
    .  Set parentReportData.locTypesortNum = reportData.locTypesortNum
    .  Set parentReportData.distLocTypeName = reportData.distLocTypeName
    .  Set parentReportData.levelNum = reps-1
 	.  Set parentReportData.sortNum = $p($g(^tmpdhccadeptleveltree($j,"trunk",extract)),"||",1)
 	.  Set parentReportData.dataTypeFlag = reportData.dataTypeFlag
 	.  Set parentReportData.itemSortNum = reportData.itemSortNum
 	.  Set sc = parentReportData.%Save()
 	.  i $$$ISERR(sc) d
 	.  .Do $System.Status.DisplayError()
    .  SET countup=countup+1
    .}
    
    Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存所有父级数据项汇总金额
/// Table：dhc.ca.cache.report.CostResultData
/// Input：dataSetDr---数据项分层套RowId, RowId in DHCCAUNITDEPTS table, reportData---科室报表数据
/// Output：
/// Return：返回数据项列表 RowId1^RowId2^...
/// Others：
ClassMethod GenParenItemSumData(dataSetDr, itemDr, reportData) As %String
{
	Set res = ..GenParenItemSumDataWithFlag(dataSetDr, itemDr, reportData, "")
	
	Quit res
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 保存所有父级数据项汇总金额
/// Table：dhc.ca.cache.report.CostResultData
/// Input：dataSetDr---数据项分层套RowId, RowId in DHCCAUNITDEPTS table, reportData---科室报表数据
/// Output：
/// Return：返回数据项列表 RowId1^RowId2^...
/// Others：
ClassMethod GenParenItemSumDataWithFlag(dataSetDr, itemDr, reportData, dataTypeFlag) As %String
{
 	//保存父级科室汇总信息
 	Set allParentId = ..AllParentItemIdByItemsId(dataSetDr, itemDr)
 	i (allParentId'="") d
 	.SET delim="^"
    .SET countdown=$LENGTH(allParentId,delim)-1
    .SET countup=1
    .FOR reps=countdown:-1:1 {
    .  SET extract=$PIECE(allParentId,delim,countup)
    .  Set parentReportData = ##class(dhc.ca.cache.report.CostResultData).%New()
    .  Set parentReportData.CostResultDataintervalName = reportData.CostResultDataintervalName
    .  Set parentReportData.CostResultDatadistedDeptName = reportData.CostResultDatadistDeptName
    .  Set parentReportData.CostResultDatadistDeptName = reportData.CostResultDatadistDeptName
    .  Set parentItemName = $p(^DHCCADATALEVELSETS(extract),"^",2)
    .  Set parentReportData.CostResultDataitemName = parentItemName
    .  Set parentReportData.CostItemTypeName = reportData.CostItemTypeName
    .  Set parentReportData.CostResultDatafee = reportData.CostResultDatafee
    .  Set parentReportData.CostResultDatadistFlag = reportData.CostResultDatadistFlag
    .  Set parentReportData.CostDistSetsName = reportData.CostDistSetsName
    .  Set parentReportData.distedLocTypeName = reportData.distedLocTypeName
    .  Set parentReportData.locTypesortNum = reportData.locTypesortNum
    .  Set parentReportData.distLocTypeName = reportData.distLocTypeName
    .  Set parentReportData.levelNum = reps-1
 	.  Set parentReportData.sortNum = $p($g(^tmpdhccadataleveltree($j,"trunk",extract)),"||",1)
 	.  Set parentReportData.dataTypeFlag = reportData.dataTypeFlag
 	.  Set sc = parentReportData.%Save()
 	.  i $$$ISERR(sc) d
 	.  .Do $System.Status.DisplayError()
    .  SET countup=countup+1
    .}
    
    Quit "1"
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 查询所有父级科室
/// Table：DHCCAUNITDEPTS
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回科室列表 RowId1^RowId2^...
/// Others：
ClassMethod AllParentLocIdFindByUnitdeptsId(deptSetDr, unitdeptsId) As %String
{
	
	s deptlevelSetId=..getIdInDeptlevelSet(deptSetDr,unitdeptsId)

	Quit:deptlevelSetId="-1" ""

	Quit ..AllParentLocIdFindByDeptlevelId(deptlevelSetId)
}

/// Creator：秦虎
/// CreatDate：2010-1-16
/// Description: 查询所有父级科室
/// Table：DHCCADEPTLEVELSETS
/// Input：RowId in DHCCADEPTLEVELSETS table
/// Output：
/// Return：返回科室列表 RowId1^RowId2^...
/// Others：
ClassMethod AllParentLocIdFindByDeptlevelId(deptlevelSetId) As %String
{
	s parentId = deptlevelSetId
	s allParentId = deptlevelSetId
	f  s parentId = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getParentid(parentId) q:(parentId=0)||(parentId="")  d
	.Set allParentId=allParentId_"^"_parentId
	
	Quit allParentId
}

/// Creator: 秦虎
/// CreatDate: 2010-1-16
/// Description: 查询单位部门码表的科室在指定科室分层套中的父层科室
/// Table：DeptLevelSets
/// Input: deptSetDr---科室分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output: 科室rowid
/// Others: 
ClassMethod getIdInDeptlevelSet(deptSetDr, unitdeptsId) As %String
{
 s rowId="-1"
 s chidrenId=0
 s flag = 0
 s res = "-1"
 f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,chidrenId)) q:(chidrenId="")||(flag=1)||(res'="-1")  d
 .i $d(^DHCCADEPTLEVELSETS(0,"Dept",chidrenId,unitdeptsId)) d
 ..s rowId=chidrenId
 ..s flag=1
 .s res=..getIdInDeptlevelSet(chidrenId,unitdeptsId)
 i flag=0 s rowId=res
 q rowId
}

/// Creator: 秦虎
/// CreatDate: 2010-1-16
/// Description: 生成排序好的科室分层套树形结构
/// Table：DeptLevelSets
/// Input: deptSetDr---科室分层套RowId
/// Output: 树形结构临时global,值为排序号_"||"_父级科室id
/// Others: 
ClassMethod getDeptlevelSetSortedTree(deptSetDr As %Integer, sortNum As %Integer) As %String
{
 s order=""
 f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order)) q:(order="")  d
 .s chidrenId=0
 .f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order,chidrenId)) q:(chidrenId="")  d
 ..s sortNum=sortNum+1
 ..s allParentLocId=..AllParentLocIdFindByDeptlevelId(chidrenId)
 ..s ^tmpdhccadeptleveltree($j,"trunk",chidrenId)=sortNum_"||"_allParentLocId
 ..s sortNum=..getDeptlevelSetSortedTree(chidrenId,sortNum)
 ..s leafId = 0
 ..f  s leafId=$o(^DHCCADEPTLEVELSETS(0,"Dept",chidrenId,leafId)) q:(leafId="")  d
 ...s sortNum=sortNum+1
 ...s allParentLocId=..AllParentLocIdFindByUnitdeptsId(deptSetDr, leafId)
 ...s ^tmpdhccadeptleveltree($j,"leaf",leafId)=sortNum_"||"_allParentLocId
 q sortNum
}

/// Creator: 秦虎
/// CreatDate: 2010-1-26
/// Description: 生成排序好的数据分层套树形结构
/// Table：DataLevelSets
/// Input: dataSetDr---数据分层套RowId
/// Output: 树形结构临时global,值为排序号_"||"_父级数据项id
/// Others: 
ClassMethod getDatalevelSetSortedTree(dataSetDr As %Integer, sortNum As %Integer) As %String
{
 s order=""
 f  s order=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,order)) q:(order="")  d
 .s chidrenId=0
 .f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,order,chidrenId)) q:(chidrenId="")  d
 ..s sortNum=sortNum+1
 ..s allParentItemId=..AllParentItemIdByDatalevelId(chidrenId)
 ..s ^tmpdhccadataleveltree($j,"trunk",chidrenId)=sortNum_"||"_allParentItemId
 ..s sortNum=..getDatalevelSetSortedTree(chidrenId,sortNum)
 ..s itemTypeId = 0
 ..f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId)) q:(itemTypeId="")  d
 ...s leafId = 0
 ...f  s leafId=$o(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId,leafId)) q:(leafId="")  d
 ....s sortNum=sortNum+1
 ....s allParentLocId=..AllParentItemIdByItemsId(dataSetDr, leafId)
 ....s ^tmpdhccadataleveltree($j,"leaf",leafId)=sortNum_"||"_allParentLocId

 ;s itemTypeId = 0
 ;f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId)) q:(itemTypeId="")  d
 ;.s leafId = 0
 ;.f  s leafId=$o(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId,leafId)) q:(leafId="")  d
 ;..s sortNum=sortNum+1
 ;..s allParentLocId=..AllParentItemIdByItemsId(dataSetDr, leafId)
 ;..s ^tmpdhccadataleveltree($j,"leaf",leafId)=sortNum_"||"_allParentLocId

 q sortNum
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 查询所有父级数据项
/// Table：DataLevelSets
/// Input：dataSetDr---数据分层套RowId, RowId in DHCCAUNITDEPTS table
/// Output：
/// Return：返回数据项列表 RowId1^RowId2^...
/// Others：
ClassMethod AllParentItemIdByItemsId(dataSetDr, allDataItemsId) As %String
{
	
	s datalevelSetId=..getIdInDatalevelSet(dataSetDr,allDataItemsId)
	
	Quit:datalevelSetId="-1" ""

	Quit ..AllParentItemIdByDatalevelId(datalevelSetId)
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 查询所有父级数据项
/// Table：DataLevelSets
/// Input：RowId in ^DHCCADATALEVELSETS table
/// Output：
/// Return：返回数据项列表 RowId1^RowId2^...
/// Others：
ClassMethod AllParentItemIdByDatalevelId(datalevelSetId) As %String
{
	s parentId = datalevelSetId
	s allParentId = datalevelSetId
	f  s parentId = $p($g(^DHCCADATALEVELSETS(parentId)),"^",7) q:(parentId=0)||(parentId="")  d
	.Set allParentId=allParentId_"^"_parentId
	
	Quit allParentId
}

/// Creator: 秦虎
/// CreatDate: 2010-1-26
/// Description: 查询数据项码表的数据项在指定数据分层套中的父层数据
/// Table：DataLevelSets
/// Input: dataSetDr---数据分层套RowId, RowId in AllDataItems table
/// Output: 数据项rowid
/// Others: 
ClassMethod getIdInDatalevelSet(dataSetDr, allDataItemsId) As %String
{
 s rowId="-1"
 s flag = 0
 s res = "-1"
 
 s itemTypeId=0
 f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId)) q:(itemTypeId="")||(flag=1)  d
 .i $d(^DHCCADATALEVELSETS(0,"TypeItem",dataSetDr,itemTypeId,allDataItemsId)) d
 ..s rowId=dataSetDr
 ..s flag=1

 s orderNum=0
 f  s orderNum=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum)) q:(orderNum="")||(flag=1)||(res'="-1")  d
 .s chidrenId=0
 .f  s chidrenId=$o(^DHCCADATALEVELSETS(0,"Parent",dataSetDr,orderNum,chidrenId)) q:(chidrenId="")||(flag=1)||(res'="-1")  d
 ..s itemTypeId=0
 ..f  s itemTypeId=$o(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId)) q:(itemTypeId="")||(flag=1)||(res'="-1")  d
 ...i $d(^DHCCADATALEVELSETS(0,"TypeItem",chidrenId,itemTypeId,allDataItemsId)) d
 ....s rowId=chidrenId
 ....s flag=1
 ..s res=..getIdInDatalevelSet(chidrenId,allDataItemsId)
 i flag=0 s rowId=res
 q rowId
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 采用Query查询报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回java.sql.ResultSet
/// Others：
ClassMethod ListCostResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListCostResultExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod ListCostResultExecute(ByRef qHandle As %Binary, accountMonthId As %Integer, costDistSetId As %Integer) As %Status
{
	///do ResetVariables
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	s CostResultDataId=0
	f  s CostResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetId,accountMonthId,CostResultDataId)) q:CostResultDataId=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)) d
	..s CostResultDataParRef = costDistSetId
	..s CostResultDataChildSub = CostResultDataId
	..s CostResultDataIntervalDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 1) // 核算区间
 	..s intervalName = $p($g(^DHCCAACCOUNTMONTHS(CostResultDataIntervalDr)),"^",2)
 	..s CostResultDataDistedDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 2) // 分摊科室
 	..s distedDeptName = ""
 	..i CostResultDataDistedDeptDr'="" s distedDeptName = $p($g(^DHCCAUNITDEPTS(CostResultDataDistedDeptDr)),"^",2)
 	..s CostResultDataDistDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 3) // 接收科室
 	..s distDeptName = $p($g(^DHCCAUNITDEPTS(CostResultDataDistDeptDr)),"^",2)
 	..s CostResultDataItemDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 4) // 成本项
 	..s itemName = $p($g(^DHCCAALLDATAITEMS(CostResultDataItemDr)), "^", 3)
 	..s CostResultDataFee = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 5) // 金额
 	..s CostResultDataDistFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 6) // 分摊标志
 	..s CostResultDataDealFlag = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",CostResultDataId)), "^", 7) // 处理标志
	..d OutputRow
	s qHandle=$lb(0,repid,0)

	Quit $$$OK
OutputRow
	set Data=$lb(CostResultDataParRef,CostResultDataChildSub,CostResultDataIntervalDr,CostResultDataDistedDeptDr,CostResultDataDistDeptDr,CostResultDataItemDr,CostResultDataFee,CostResultDataDistFlag,CostResultDataDealFlag) ;按顺序对应Query的传出参数
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
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

Query ListCostResult(accountMonthId As %Integer, costDistSetId As %Integer) As %Query(ROWSPEC = "CostResultData_parRef:%Integer,CostResultData_childSub:%Integer,CostResultData_intervalDr:%Integer,CostResultData_distedDeptDr:%Integer,CostResultData_distDeptDr:%Integer,CostResultData_itemDr:%Integer,CostResultData_fee:%Float,CostResultData_distFlag:%String,CostResultData_dealFlag:%String")
{
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetReportData(currentMonthId, otherMonthId) As %String
{
	s res = ..GetCurrentReportData()
	s res = ..GetParentDeptReportData()
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成当前分摊结果的报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetCurrentReportData(currentMonthId, otherMonthId) As %String
{
	s reportDataRow = ..GetCostReportDataObj()
	d ..OutputReportRow()
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成当前分摊结果所有父级科室的报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetParentDeptReportData(currentMonthId, otherMonthId) As %String
{
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成当前分摊结果所有父级成本科目的报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetParentItemReportData(currentMonthId, otherMonthId) As %String
{
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成一条报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetCostReportDataObj(currentMonthId, otherMonthId) As %String
{
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出一条报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod OutputReportRow(currentMonthId, otherMonthId) As %String
{
}

/// Creator：秦虎
/// CreatDate：2009-12-31
/// Description: 生成第二个核算月数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod CopyDataToOtherMonth(currentMonthId, otherMonthId) As %String
{
	// start a transaction
	TSTART
	
	Set rset = ##class(%ResultSet).%New()
 	Do rset.Prepare("SELECT * FROM dhc_ca_cache_data.CostResultData WHERE CostResultData_ChildSub>0 and CostResultData_intervalDr="_currentMonthId)

 	Do rset.Execute()

	Set columns = rset.GetColumnCount()

 	While (rset.Next()) // go to the next row of the result set
 	{
        	Set parRef = rset.Data("CostResultData_parRef")
        	Set month = 2
        	Set distedDeptDr = rset.Data("CostResultData_distedDeptDr")
        	Set distDeptDr = rset.Data("CostResultData_distDeptDr")
        	Set itemDr = rset.Data("CostResultData_itemDr")
        	Set fee = rset.Data("CostResultData_fee")
        	Set distFlag = rset.Data("CostResultData_distFlag")
        	Set dealFlag = rset.Data("CostResultData_dealFlag")
        	&sql(insert into dhc_ca_cache_data.CostResultData (CostResultData_parRef,CostResultData_intervalDr,CostResultData_distedDeptDr,CostResultData_distDeptDr,CostResultData_itemDr,CostResultData_fee,CostResultData_distFlag,CostResultData_dealFlag) values(:parRef, :month, :distedDeptDr, :distDeptDr, :itemDr, :fee, :distFlag, :dealFlag))
        	Write "sqlcode="_SQLCODE,!
        	i SQLCODE'=0 TROLLBACK
    }
	
	TCOMMIT

    Quit "1"
}

Storage Default
{
<Data name="uCostResultDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Amount</Value>
</Value>
<Value name="3">
<Value>ItemCode</Value>
</Value>
<Value name="4">
<Value>ItemName</Value>
</Value>
<Value name="5">
<Value>LocCode</Value>
</Value>
<Value name="6">
<Value>Number</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>locName</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uCostResultDataD</DataLocation>
<DefaultData>uCostResultDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uCostResultDataD</IdLocation>
<IndexLocation>^dhc.ca.c.uCostResultDataI</IndexLocation>
<StreamLocation>^dhc.ca.c.uCostResultDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
