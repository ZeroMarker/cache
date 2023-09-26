Class dhc.ca.cache.report.uReportDeptVSDeptType Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

// 分摊套^核算区间^核算区间列表^科室^科室列表^数据分层套^成本项^成本项列表^报表左栏标记

/// Creator：秦虎
/// CreatDate：2009-03-04
/// Description: 生成报表
/// Table：data.CostResultData
/// Input：argList 参数列表
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod GetReport(repid, ind, argList) As %String
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

	//生成报表数据临时Global
	s costResultDataId=0
	f  s costResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",costDistSetId,accountMonthId,costResultDataId)) q:costResultDataId=""  d
	.i $d(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)) d
	..set reportDataRow = ..GetCostReportDataObj(argList, costResultDataId, "本期")
	..set result = ..GetParentDeptReportData(argList, costResultDataId, reportDataRow)
	..Kill reportDataRow
	
	//生成末级节点数据
	s deptId = 0
	f  s deptId=$o(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",deptId)) q:deptId=""  d
	.s deptType = ""
	.f  s deptType=$o(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",deptId,deptType)) q:deptType=""  d
	..s distFlag = ""
	..f  s distFlag=$o(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",deptId,deptType,distFlag)) q:distFlag=""  d
	...s fee = ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",deptId,deptType,distFlag)
	...s reportDataRow=..PrepareOutput(argList,"leaf",deptId,deptType,distFlag,fee)
	...s ind = ..OutputReportRow(repid, ind, reportDataRow)

	//生成非末级节点汇总数据
	s deptId = 0
	f  s deptId=$o(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",deptId)) q:deptId=""  d
	.s deptType = ""
	.f  s deptType=$o(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",deptId,deptType)) q:deptType=""  d
	..s distFlag = ""
	..f  s distFlag=$o(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",deptId,deptType,distFlag)) q:distFlag=""  d
	...s fee = ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",deptId,deptType,distFlag)
	...s reportDataRow=..PrepareOutput(argList,"trunk",deptId,deptType,distFlag,fee)
	...s ind = ..OutputReportRow(repid, ind, reportDataRow)

	Quit ind
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成当前分摊结果所有父级科室的报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod GetParentDeptReportData(argList, costResultDataId, reportDataRow) As %String
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	
	Set costResultDataDistFlag = reportDataRow.CostResultDatadistFlag
	Set costResultDataFee = reportDataRow.CostResultDatafee
	s distedDeptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 2) // 分摊科室
    Set distedLocTypeDr = -1
    i (costResultDataDistFlag="dist")&&(distedDeptDr'="") d
    .Set tmpResult = ..GetLocTypeSortNum(deptSetDr,distedDeptDr)
    .i tmpResult'="" d
 	..Set distedLocTypeDr = $p(tmpResult,"^",5)  //被分摊科室类别
 	Set deptDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 3) // 接收科室
	Set allParentId=$p($g(^tmpdhccadeptleveltree($j,"leaf",deptDr)), "||", 2)
 	i (allParentId'="") d
 	.SET delim="^"
    .SET countdown=$LENGTH(allParentId,delim)-1
    .SET countup=1
    .FOR reps=countdown:-1:1 {
    .  SET extract=$PIECE(allParentId,delim,countup)
    .  Set parentDistDeptName = $p(^DHCCADEPTLEVELSETS(extract),"^",2)
 	.  FOR nameReps=reps-1:-1:1 {
	.  	   Set parentDistDeptName = "  "_parentDistDeptName
	.  }  
    .  Set reportDataRow.CostResultDatadistDeptName = parentDistDeptName  //父级科室名称
    .  Set reportDataRow.levelNum = reps-1  //父级科室分层套层级
    .  Set sortNum = 0
    .  Set tmpLocTypeResult=$g(^tmpdhccadeptleveltree($j,"trunk",extract))
 	.  if tmpLocTypeResult'="" d
 	.  .Set sortNum = $p(tmpLocTypeResult,"||",1)
    .  Set reportDataRow.sortNum = sortNum  //科室分层套树结构排序
	.  i ($d(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",extract,distedLocTypeDr,costResultDataDistFlag))) d
	.  .s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",extract,distedLocTypeDr,costResultDataDistFlag)=costResultDataFee + ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",extract,distedLocTypeDr,costResultDataDistFlag)
	.  e  d
	.  .s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",extract,distedLocTypeDr,costResultDataDistFlag)=costResultDataFee
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
/// Return：返回状态
/// Others：
ClassMethod GetCostReportDataObj(argList, costResultDataId, dataTypeFlag) As dhc.ca.cache.report.CostResultData
{
	Set costDistSetId = $p($g(argList),"^",1)
	Set dataSetId = $p($g(argList),"^",6)
	
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
 	s distedLocTypeDr = -1
 	s locTypesortNum = 0
 	i costResultDataDistFlag="self" d
    .Set distedLocTypeName = "直接计入"
    .Set locTypesortNum = -1
    //被分摊科室类别和科室分层套层级
    i (costResultDataDistFlag="dist")&&(costResultDataDistedDeptDr'="") d
    .Set tmpResult = ..GetLocTypeSortNum(deptSetDr,costResultDataDistedDeptDr)
    .Set distedLocTypeDr = $p(tmpResult,"^",5)
    .;w "distedLocTypeDr=",distedLocTypeDr,!
    .i tmpResult'="" d
    ..Set distedLocTypeName = $p(tmpResult,"^",1)
    ..Set locTypesortNum = $p(tmpResult,"^",2)
    //接收科室类别和科室分层套层级
    Set distLocTypeName = ""
    Set distLocTypeDr = -costResultDataDistDeptDr
    Set sortNum = -costResultDataDistDeptDr
    Set levelNum = -1
    Set tmpResult = ..GetLocTypeSortNum(deptSetDr,costResultDataDistDeptDr)
    i tmpResult'="" d
    .Set sortNum = $p(tmpResult,"^",3)
 	.Set distLocTypeName = $p(tmpResult,"^",1)
 	.Set levelNum = $p(tmpResult,"^",4)
 	.Set distLocTypeDr = $p(tmpResult,"^",5)
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
		
	i ($d(^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",costResultDataDistDeptDr,distedLocTypeDr,costResultDataDistFlag))) d
	.s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",costResultDataDistDeptDr,distedLocTypeDr,costResultDataDistFlag)=costResultDataFee + ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",costResultDataDistDeptDr,distedLocTypeDr,costResultDataDistFlag)
	e  d
	.s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",costResultDataDistDeptDr,distedLocTypeDr,costResultDataDistFlag)=costResultDataFee
		
	Quit reportData
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 科室分层套, deptDr 科室码表
/// Output：
/// Return：返回科室类别, 科室类别在科室分层套中的排序, 科室分层套排序, 科室分层套层级和科室类别Id,以"^"号分割
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
 	..Set result = locTypeName_"^"_locTypeSortNum_"^"_sortNum_"^"_levelNum_"^"_locTypeId
 	
	Quit result
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 科室分层套, deptDr 科室码表
/// Output：
/// Return：返回科室类别, 科室类别在科室分层套中的排序, 科室分层套排序, 科室分层套层级和科室类别Id,以"^"号分割
/// Others：
ClassMethod GetLocTypeSortNumTrunk(deptSetDr, deptDr) As %String
{
	Set result=""
 	Set tmpResult=$g(^tmpdhccadeptleveltree($j,"trunk",deptDr))
 	if tmpResult'="" d
 	.Set sortNum = $p(tmpResult,"||",1)
 	.Set tmpParentIds = $p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")-1
 	.Set locLevelNum=levelNum-1
 	.Set locTypeId = $p(tmpParentIds,"^",levelNum)
 	.Set locTypeName = $p($g(^DHCCADEPTLEVELSETS(locTypeId)),"^",2)
 	.Set tmpLocTypeResult=$g(^tmpdhccadeptleveltree($j,"trunk",locTypeId))
 	.if tmpLocTypeResult'="" d
 	..Set locTypeSortNum = $p(tmpLocTypeResult,"||",1)
 	..Set result = locTypeName_"^"_locTypeSortNum_"^"_sortNum_"^"_locLevelNum_"^"_locTypeId
 	 	
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
    	
	//科室分层套中所有科室类别
	Set result = ..GetLocTypeNullObj(deptSetDr)
	// 根据临时global生成报表科室树结构
 	Set sortNum = ..getDeptLevelTreeNullData(deptSetDr,-1,0)
 	 	
 	QUIT ind
}

/// Creator：秦虎
/// CreatDate：2010-1-26
/// Description: 科室分层套中所有科室类别(空数据)
/// Table：CostResultData
/// Input：deptSetDr---科室分层套RowId, RowId in DHCCAACCOUNTMONTHS table
/// Output：
/// Return：返回状态
/// Others：
ClassMethod GetLocTypeNullObj(deptSetDr As %Integer) As %String
{
	
	//科室分层套中所有科室类别
	s chidrenId=0
	s distLocTypeName=""
 	f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,chidrenId)) q:(chidrenId="")  d
 	.s distLocTypeName=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",2)  //科室类别名称
 	.s activeStatus=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",9)  //激活状态
 	.i (activeStatus="Y")||(activeStatus="y") d
 	..s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",chidrenId,chidrenId,"self")=0
 	
 	QUIT 1
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
 	.f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"Parent",deptSetDr,chidrenId)) q:(chidrenId="")||(flag=1)  d
 	..s deptTypeName=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",2)
 	..s activeStatus=$p($g(^DHCCADEPTLEVELSETS(chidrenId)),"^",9)  //激活状态
 	..Set deptSortNum = $p($g(^tmpdhccadeptleveltree($j,"trunk",chidrenId)),"||",1)
 	..i (activeStatus="Y")||(activeStatus="y") d
 	...s flag=1
 	...s result = chidrenId_"^"_deptTypeName_"^"_deptSortNum
	
	Quit result
}

/// Creator: 秦虎
/// CreatDate: 2010-1-16
/// Description: 生成临时报表空结构
/// Table：DeptLevelSets
/// Input: deptSetDr---科室分层套RowId
/// Output: 树形结构临时global,值为金额,^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",科室id,分摊科室类别id,"self")
/// Return：返回序号
/// Others: 
ClassMethod getDeptLevelTreeNullData(deptSetDr As %Integer, deptTypeDr As %Integer, sortNum As %Integer) As %String
{
	
 	s order=""
 	f  s order=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order)) q:(order="")  d
 	.s chidrenId=0
 	.f  s chidrenId=$o(^DHCCADEPTLEVELSETS(0,"ParentOrder",deptSetDr,order,chidrenId)) q:(chidrenId="")  d
 	..s sortNum=sortNum+1
 	..s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"trunk",chidrenId,deptTypeDr,"self")=0
 	..s sortNum=..getDeptLevelTreeNullData(chidrenId,deptTypeDr,sortNum)
 	..s leafId = 0
 	..f  s leafId=$o(^DHCCADEPTLEVELSETS(0,"Dept",chidrenId,leafId)) q:(leafId="")  d
 	...s sortNum=sortNum+1
 	...s ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j,"leaf",leafId,deptTypeDr,"self")=0

 	q sortNum
}

/// Creator：秦虎
/// CreatDate：2009-02-11
/// Description: 生成报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod PrepareOutput(argList, flag, deptId, deptTypeId, distFlag, fee) As dhc.ca.cache.report.CostResultData
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

	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)  //分摊套
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
    //核算期间
    s intervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)
	i (deptTypeId<=0) Set distedLocTypeName="直接计入"
	e  Set distedLocTypeName = $p($g(^DHCCADEPTLEVELSETS(deptTypeId)),"^",2)  //被分摊科室类别
	
	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
	
	Set distDeptName = ""  //接收科室
	i flag="leaf" d
	.Set distDeptName = $p($g(^DHCCAUNITDEPTS(deptId)),"^",2)
	e  i flag="trunk" d
	.Set distDeptName = $p($g(^DHCCADEPTLEVELSETS(deptId)),"^",2)
	//接收科室类别和科室分层套层级
    Set distLocTypeName = ""
    Set distLocTypeDr = -1
    Set sortNum = -deptId
    Set levelNum = -1
    Set tmpResult = ""
    i flag="leaf" d
    .Set tmpResult = ..GetLocTypeSortNum(deptSetDr,deptId)
    e  i flag="trunk" d
    .Set tmpResult = ..GetLocTypeSortNumTrunk(deptSetDr,deptId)
    i tmpResult'="" d
    .Set sortNum = $p(tmpResult,"^",3)
 	.Set distLocTypeName = $p(tmpResult,"^",1)
 	.Set levelNum = $p(tmpResult,"^",4)
 	.Set distLocTypeDr = $p(tmpResult,"^",5)
 	.FOR reps=levelNum:-1:1 {
	.	Set distDeptName = "  "_distDeptName
	.}
	//被分摊科室科室类别排序
	i (deptTypeId<0) Set locTypeSortNum = deptTypeId
	e  Set locTypeSortNum = -deptTypeId
	Set tmpLocTypeResult=$g(^tmpdhccadeptleveltree($j,"trunk",deptTypeId))
 	if tmpLocTypeResult'="" d
 	.Set locTypeSortNum = $p(tmpLocTypeResult,"||",1)
	
	Set reportData.CostResultDataintervalName = intervalName  //核算区间
	Set reportData.CostResultDatadistedDeptName = ""  //分摊科室
	Set reportData.CostResultDatadistDeptName = distDeptName  //接收科室
	Set reportData.CostResultDataitemName = ""  //成本项
	Set reportData.CostItemTypeName = ""  //成本项类别
	Set reportData.CostResultDatafee = fee //金额
	Set reportData.CostResultDatadistFlag = distFlag  //分摊标记
	Set reportData.CostResultDatadealFlag = ""  //CostResultData_dealFlag
	Set reportData.CostDistSetsName = costDistSetName  //分摊套
	Set reportData.distedLocTypeName = distedLocTypeName  //被分摊科室类别
	Set reportData.distLocTypeName = ""  //接收科室类别
	Set reportData.levelNum = levelNum  //科室分层套层级
	Set reportData.sortNum = sortNum  //科室分层套树结构排序
	Set reportData.locTypesortNum = locTypeSortNum  //被分摊科室科室类别排序
	Set reportData.dataTypeFlag = ""  //数据类型标记
	Set reportData.itemSortNum = 0  //数据分层套树结构排序
	Set reportData.itemLevelNum = 0 //数据分层套层级
	Set reportData.dataTypeSortNum = 0 //成本项类别排序
	
	&SQL(INSERT INTO dhc_ca_cache_data.ReportResult (ReportResult_repType,ReportResult_intervalDr,ReportResult_distSetDr,ReportResult_dataSetDr,ReportResult_fee,ReportResult_deptName,ReportResult_deptLayer,ReportResult_deptOrder,ReportResult_deptType,ReportResult_itemName,ReportResult_itemLayer,ReportResult_itemOrder,ReportResult_itemType,ReportResult_dataType,ReportResult_deptDr,ReportResult_itemDr,ReportResult_FDName,ReportResult_FDDr,ReportResult_FDTName,ReportResult_FDTDr,ReportResult_FDTOrder) VALUES ('cbfpgzfx',:accountMonthId,:costDistSetId,:dataSetId,:fee,:distDeptName,:levelNum,:sortNum,'','',0,0,'','',:deptId,0,'',0,:distedLocTypeName,:deptTypeId,:locTypeSortNum))
	
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
	Do resultSet.Prepare("SELECT * FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType = ? AND ReportResult_intervalDr = ? AND ReportResult_distSetDr = ?")
	Do resultSet.Execute("cbfpgzfx", accountMonthId, costDistSetId)
	Set existFlag = 0
	For  Quit:('resultSet.Next())||(existFlag=1)  Do
	. Set existFlag=1
	Do resultSet.Close()
	If existFlag=1 d
	.&SQL(DELETE FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType = 'cbfpgzfx' AND ReportResult_intervalDr = :accountMonthId AND ReportResult_distSetDr = :costDistSetId)
	
	// 生成临时global
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)
	i (unitdeptList="") Set deptCountNum = ##class(dhc.ca.cache.report.uCostResultData).getDeptlevelSetSortedTree(deptSetDr,0)
	if (dataSetId'="") Set dataCountNum = ##class(dhc.ca.cache.report.uCostResultData).getDatalevelSetSortedTree(dataSetId,0)
	
	//科室分层套中所有科室类别
	set ind = ..GetCostReportDataNullObj(repid, ind, argList)
	
	set ind = ..GetReport(repid, ind, argList)
	
	s qHandle=$lb(0,repid,0)
	
	// 删除临时global
	Kill ^tmpdhccadeptleveltree($j)
	Kill ^tmpdhccadataleveltree($j)
	Kill ^TMPDHCCAREPORTDEPTVSDEPTTYPE($j)

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
	Do resultSet.Prepare("SELECT * FROM dhc_ca_cache_data.ReportResult WHERE ReportResult_repType = ? AND ReportResult_intervalDr = ? AND ReportResult_distSetDr = ?")
	Do resultSet.Execute("cbfpgzfx", accountMonthId, costDistSetId)
	Set existFlag = 0
	Set reportData = ##class(dhc.ca.cache.report.CostResultData).%New()
	For  Quit:('resultSet.Next())  Do
	. Set existFlag=1
	. Set accountMonthId = resultSet.Data("ReportResult_intervalDr")
	. Set reportData.CostResultDataintervalName = $p($g(^DHCCAACCOUNTMONTHS(accountMonthId)),"^",2)  //核算区间
	. Set reportData.CostResultDatadistedDeptName = ""  //分摊科室
	. Set reportData.CostResultDatadistDeptName = resultSet.Data("ReportResult_deptName")  //接收科室
	. Set reportData.CostResultDataitemName = ""  //成本项
	. Set reportData.CostItemTypeName = ""  //成本项类别
	. Set reportData.CostResultDatafee = resultSet.Data("ReportResult_fee") //金额
	. Set reportData.CostResultDatadistFlag = "self"  //resultSet.Data("ReportResult_distFlag")  //分摊标记
	. Set reportData.CostResultDatadealFlag = ""  //CostResultData_dealFlag
	. Set costDistSetId = resultSet.Data("ReportResult_distSetDr")
	. Set reportData.CostDistSetsName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)  //分摊套
	. Set reportData.distedLocTypeName = resultSet.Data("ReportResult_FDTName")  //被分摊科室类别
	. Set reportData.distLocTypeName = ""  //接收科室类别
	. Set reportData.levelNum = resultSet.Data("ReportResult_deptLayer")  //科室分层套层级
	. Set reportData.sortNum = resultSet.Data("ReportResult_deptOrder")  //科室分层套树结构排序
	. Set reportData.locTypesortNum = resultSet.Data("ReportResult_FDTOrder")  //被分摊科室科室类别排序
	. Set reportData.dataTypeFlag = ""  //数据类型标记
	. Set reportData.itemSortNum = 0  //数据分层套树结构排序
	. Set reportData.itemLevelNum = 0 //数据分层套层级
	. Set reportData.dataTypeSortNum = 0 //成本项类别排序
	. s ind = ..OutputReportRow(repid, ind, reportData)
	. ;w resultSet.Data("ReportResult_repType"),!
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

Query LookupCostResult(argList As %String) As %Query(ROWSPEC = "CostResultDataintervalName:%String:核算区间,CostResultDatadistedDeptName:%String:分摊科室,CostResultDatadistDeptName:%String:接收科室,CostResultDataitemName:%String:成本项,CostItemTypeName:%String:成本项类别,CostResultDatafee:%Float:金额,CostResultDatadistFlag:%String:分摊标记,CostResultDatadealFlag:%String:CostResultDatadealFlag,CostDistSetsName:%String:分摊套,distedLocTypeName:%String:被分摊科室类别,distLocTypeName:%String:接收科室类别,levelNum:%Integer:科室分层套层级,sortNum:%Integer:科室分层套树结构排序,locTypesortNum:%Integer:被分摊科室科室类别排序,dataTypeFlag:%String:数据类型标记,itemSortNum:%Integer:数据分层套树结构排序,itemLevelNum:%Integer:数据分层套层级,dataTypeSortNum:%Integer:成本项类别排序")
{
}

Storage Default
{
<Data name="uReportDeptVSDeptTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uReportDeptVSDeptTypeD</DataLocation>
<DefaultData>uReportDeptVSDeptTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uReportDeptVSDeptTypeD</IdLocation>
<IndexLocation>^dhc.ca.c.uReportDeptVSDeptTypeI</IndexLocation>
<StreamLocation>^dhc.ca.c.uReportDeptVSDeptTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
