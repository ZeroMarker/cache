Class dhc.ca.cache.report.uBalanceOfPaymentQuery Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("dhc.ca.cache.report.uBalanceOfPaymentQuery","ListBlanceofPaymentQuery","1","1,2","2")

/// Creator：wang ying
/// CreatDate：2009-02-24
/// Description: 生成报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, costResultDataId 分摊结果id
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod GetReportData(repid, ind, costDistSetId, costResultDataId, itemSetDr, month, incomeDataId) As %String
{
	i (costDistSetId'="")&&(costResultDataId'="") d
	.;s reportDataRow = ..GetCostReportDataObj(costDistSetId,costResultDataId,itemSetDr)
	.d ..GetCostReportDataObj(costDistSetId,costResultDataId,itemSetDr)
	i incomeDataId'="" d
    .;s reportDataRow = ..GetIncomeReportDataObj(incomeDataId,itemSetDr,month)
    .d ..GetIncomeReportDataObj(incomeDataId,itemSetDr,month)
	
	//生成成本数据
	s deptTypeDr = 0
	f  s deptTypeDr=$o(^TMPDHCCABLANCEOFPAYMENT($j,"cost",deptTypeDr)) q:deptTypeDr=""  d
	.s itemTypeDr = ""
	.f  s itemTypeDr=$o(^TMPDHCCABLANCEOFPAYMENT($j,"cost",deptTypeDr,itemTypeDr)) q:itemTypeDr=""  d
	..s monthDr = ""
	..f  s monthDr = $o(^TMPDHCCABLANCEOFPAYMENT($j,"cost",deptTypeDr,itemTypeDr,monthDr)) q:monthDr=""  d
	...s fee = ^TMPDHCCABLANCEOFPAYMENT($j,"cost",deptTypeDr,itemTypeDr,monthDr)
	...;s reportDataRow=..PrepareOutput(monthDr,"cost",deptTypeDr,itemTypeDr,fee)
	...;s ind = ..OutputReportRow(repid, ind, reportDataRow)

	//生成收入数据
	s deptTypeDr = 0
	f  s deptTypeDr = $o(^TMPDHCCABLANCEOFPAYMENT($j,"income",deptTypeDr)) q:deptTypeDr=""  d
	.s itemTypeDr = ""
	.f  s itemTypeDr = $o(^TMPDHCCABLANCEOFPAYMENT($j,"income",deptTypeDr,itemTypeDr)) q:itemTypeDr=""  d
	..s month = ""
	..f  s month = $o(^TMPDHCCABLANCEOFPAYMENT($j,"income",deptTypeDr,itemTypeDr,month)) q:month=""  d
	...s fee = ^TMPDHCCABLANCEOFPAYMENT($j,"income",deptTypeDr,itemTypeDr,month)
	...;s reportDataRow=..PrepareOutput(month,"income",deptTypeDr,itemTypeDr,fee)
	...;s ind = ..OutputReportRow(repid, ind, reportDataRow)

	//Kill reportDataRow
	
	Quit ind
}

/// Creator：wang ying
/// CreatDate：2009-02-24
/// Description: 生成一条报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, costResultDataId 分摊结果id
/// Output：
/// Return：返回dhc.ca.cache.report.CostResultData对象
/// Others：w ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).GetCostReportDataObj("1","7192","2")
ClassMethod GetCostReportDataObj(costDistSetId, costResultDataId, itemSetDr) As dhc.ca.cache.report.Balanceofpayments
{
	Set costDistSetName = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",3)   //成本分摊套名
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId)),"^",5)        //部门分层套ID
	s costResultDataIntervalDr = $p($g(^DHCCACOSTDISTSETS(costDistSetId,"CostResultData",costResultDataId)), "^", 1) // 核算区间
 	i costResultDataIntervalDr'="" d
 	.s intervalName = $p($g(^DHCCAACCOUNTMONTHS(costResultDataIntervalDr)),"^",2)
 	
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
 	Set distLocTypeName = ""
    Set distLocTypeDr = ""
    Set sortNum = -costResultDataDistDeptDr
    Set levelNum = -1
    Set tmpResult = ..GetLocTypeSortNum(deptSetDr,costResultDataDistDeptDr)
    i tmpResult'="" d
    .Set sortNum = $p(tmpResult,"^",3)
 	.Set distLocTypeName = $p(tmpResult,"^",1)
 	.Set distLocTypeDr = $p(tmpResult,"^",5)
 	.;w distLocTypeDr,!
 	.Set levelNum = $p(tmpResult,"^",4)-1
 	.FOR reps=levelNum:-1:1 {
	.	Set distDeptName = "  "_distDeptName
	.} 
	
	Set distItemTypeName = ""
	Set distItemTypeDr = ""
    Set sortItemNum = -costResultDataItemDr
    Set levelItemNum = -1
    Set tmpItemResult = ..GetItemTypeSortNum(itemSetDr,costResultDataItemDr)
    i tmpItemResult'="" d
    .Set sortItemNum = $p(tmpItemResult,"^",3)
 	.Set distItemTypeName = $p(tmpItemResult,"^",1)
 	.Set distItemTypeDr = $p(tmpItemResult,"^",5)
 	.;w distItemTypeDr,!
 	.Set levelItemNum = $p(tmpItemResult,"^",4)-1
 	.FOR reps=levelItemNum:-1:1 {
	.	Set itemName = "  "_itemName
	.} 
	
 	/*
 	//s Balanceofpayments=##class(dhc.ca.cache.report.Balanceofpayments).%New()
	Set reportData = ##class(dhc.ca.cache.report.Balanceofpayments).%New()
	Set reportData.deptType = distLocTypeName  //科室类别
	Set reportData.deptName = distDeptName  //科室名称
	Set reportData.itemName = itemName  //项目名称
	Set reportData.itemType = distItemTypeName  //项目类别
	Set reportData.money = costResultDataFee //金额
	Set reportData.monthName = intervalName  //月份名称
	Set reportData.month = costResultDataIntervalDr  //月份id
	Set reportData.type = "成本"        //费用类别
    */
	
	if ((distLocTypeDr'="")&&(distItemTypeDr'="")) d
	.if ($d(^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr,costResultDataIntervalDr)))  d
	..Set ^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr,costResultDataIntervalDr) = costResultDataFee + ^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr,costResultDataIntervalDr)
	.else  d
	..Set ^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr,costResultDataIntervalDr) = costResultDataFee

	//Quit reportData
}

/// Creator：wang ying
/// CreatDate：2009-02-25
/// Description: 生成一条报表数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, costResultDataId 分摊结果id
/// Output：
/// Return：返回dhc.ca.cache.report.CostResultData对象
/// Others：w ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).GetIncomeReportDataObj("375","2",1)
ClassMethod GetIncomeReportDataObj(incomeDataId, itemSetDr, month) As dhc.ca.cache.report.Balanceofpayments
{
    Set reportData = ##class(dhc.ca.cache.report.Balanceofpayments).%New()
	
	s tmpfDeptDr=$p($g(^DHCCAINCOMEDATAS(incomeDataId)),"^",11)   //开单科室
	s tmptDeptDr=$p($g(^DHCCAINCOMEDATAS(incomeDataId)),"^",14)        //执行科室
	;w "tmpfDeptDr="_tmpfDeptDr,"tmptDeptDr="_tmptDeptDr,!
	i tmpfDeptDr=tmptDeptDr d
	.s tmpItemDr=$p($g(^DHCCAINCOMEDATAS(incomeDataId)),"^",6)    //项目id
	.s tmpMonth=$p(^DHCCAINCOMEDATAS(incomeDataId),"^",1)
	.;w "tmpfDeptDr="_tmpfDeptDr,"tmptDeptDr="_tmptDeptDr,!
	.i (tmpfDeptDr'="")&&(tmpItemDr'="")&&(tmpMonth=month) d
	..Set distDeptName=$p($g(^DHCCAUNITDEPTS(tmpfDeptDr)),"^",2)
	..;w "distDeptName="_distDeptName,! 
	..Set itemName=$p($g(^DHCCAALLDATAITEMS(tmpItemDr)),"^",3) 
	..Set costResultDataFee=+$p($g(^DHCCAINCOMEDATAS(incomeDataId)),"^",7)
	..Set tmpMonthName=$p($g(^DHCCAACCOUNTMONTHS(tmpMonth)),"^",2)
	..Set distLocTypeName = ""
    ..Set distLocTypeDr = ""
    ..Set sortNum = -tmpfDeptDr
    ..Set levelNum = -1
    ..;w "tmpfDeptDr="_tmpfDeptDr,!
    ..Set tmpResult = ..GetLocTypeSortNum("",tmpfDeptDr)
    ..;w "tmpResult="_tmpResult,!
    ..i tmpResult'="" d
    ...;w tmpResult
    ...Set sortNum = $p(tmpResult,"^",3)
 	...Set distLocTypeName = $p(tmpResult,"^",1)
 	...Set distLocTypeDr = $p(tmpResult,"^",5)
 	...Set levelNum = $p(tmpResult,"^",4)-1
 	...FOR reps=levelNum:-1:1 {
	...	Set distDeptName = "  "_distDeptName
	...} 
	
	..Set distItemTypeName = ""
    ..Set distItemTypeDr = ""
    ..Set sortItemNum = -tmpItemDr
    ..Set levelItemNum = -1
    ..;w "itemSetDr,tmpItemDr="_itemSetDr,"2="_tmpItemDr,!
    ..Set tmpItemResult = ..GetItemTypeSortNum(itemSetDr,tmpItemDr)
    ..;w "tmpItemResult="_tmpItemResult,!
    ..i tmpItemResult'="" d
    ...Set sortItemNum = $p(tmpItemResult,"^",3)
 	...Set distItemTypeName = $p(tmpItemResult,"^",1)
 	...Set distItemTypeDr = $p(tmpItemResult,"^",5)
 	...Set levelItemNum = $p(tmpItemResult,"^",4)-1
 	...FOR reps=levelItemNum:-1:1 {
	...	Set itemName = "  "_itemName
	...} 
	..;Set reportData.deptType = distLocTypeName  //科室类别
	..;Set reportData.deptName = distDeptName  //科室名称
	..;Set reportData.itemName = itemName  //项目名称
	..;Set reportData.itemType = distItemTypeName  //项目类别
	..;Set reportData.money = costResultDataFee //金额
	..;Set reportData.monthName = tmpMonthName  //月份名称
	..;Set reportData.month = month  //月份id
	..;Set reportData.type = "收入"        //费用类别
	..;w "1"_reportData.deptType,"2"_reportData.deptName,"3"_reportData.itemName,"4"_reportData.itemType,!
    
    ..if ((distLocTypeDr'="")&&(distItemTypeDr'="")) d
	...if ($d(^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr,month))'=0)  d
	....Set ^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr,month) = costResultDataFee+^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr,month)
	...else  d
	....Set ^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr,month) = costResultDataFee
	
	;Quit reportData
}

/// Creator：wang ying
/// CreatDate：2009-02-26
/// Description: 输出一条报表数据
/// Table：data.CostResultData
/// Input：reportDataRow 临时对象
/// Output：
/// Return：返回查询状态
/// Others：
ClassMethod OutputReportRow(repid, ind, reportDataRow) As %String
{

	;w "Data="_reportDataRow.deptType,reportDataRow.deptName,reportDataRow.itemName,reportDataRow.itemType,reportDataRow.money,reportDataRow.monthName,reportDataRow.month,reportDataRow.type,!
	i (reportDataRow.type'="")&&(reportDataRow.deptType'="")&&(reportDataRow.itemType'="") d
	.set Data=$lb(reportDataRow.deptType,reportDataRow.deptName,reportDataRow.itemName,reportDataRow.itemType,reportDataRow.money,reportDataRow.monthName,reportDataRow.month,reportDataRow.type) ;按顺序对应Query的传出参数
	.Set ^CacheTemp(repid,ind)=Data
	.Set ind=ind+1
	Quit ind
}

/// Creator：wang ying
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 部门分层套id, deptDr 科室id
/// Output：
/// Return：返回科室类别, 科室类别在科室分层套中的排序, 科室分层套排序和科室分层套层级,以"^"号分割
/// Others：w ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).GetLocTypeSortNum("","77")
ClassMethod GetLocTypeSortNum(deptSetDr, deptDr) As %String
{
	Set result=""
 	Set tmpResult=$g(^tmpdhccadeptleveltree($j,"leaf",deptDr))
 	if tmpResult'="" d
 	.Set sortNum = $p(tmpResult,"||",1)
 	.Set tmpParentIds = $p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set locTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set locTypeName = $p($g(^DHCCADEPTLEVELSETS(locTypeId)),"^",2)
 	.Set tmpLocTypeResult=$g(^tmpdhccadeptleveltree($j,"trunk",locTypeId))
 	.if tmpLocTypeResult'="" d
 	..Set locTypeSortNum = $p(tmpLocTypeResult,"||",1)
 	..Set result = locTypeName_"^"_locTypeSortNum_"^"_sortNum_"^"_levelNum_"^"_locTypeId
 	
	Quit result
}

/// Creator：wang ying
/// CreatDate：2009-02-11
/// Description: 输出科室类别和科室类别在科室分层套中的层级
/// Table：data.CostResultData
/// Input：deptSetDr 部门分层套id, deptDr 科室id
/// Output：
/// Return：返回科室类别, 科室类别在科室分层套中的排序, 科室分层套排序和科室分层套层级,以"^"号分割
/// Others：w ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).GetItemTypeSortNum(2,133)
ClassMethod GetItemTypeSortNum(itemSetDr, itemDr) As %String
{
	//^DHCCAALLDATAITEMS(tmpItemDr),"^",3
	Set result=""
 	Set tmpResult=$g(^tmpdhccadataleveltree($j,"leaf",itemDr))
 	if tmpResult'="" d
 	.Set sortNum = $p(tmpResult,"||",1)
 	.Set tmpParentIds = $p(tmpResult,"||",2)
 	.Set levelNum=$LENGTH(tmpParentIds,"^")
 	.Set itemTypeId = $p(tmpParentIds,"^",levelNum-1)
 	.Set itemTypeName = $p($g(^DHCCADATALEVELSETS(itemTypeId)),"^",2)
 	.Set tmpItemTypeResult=$g(^tmpdhccadataleveltree($j,"trunk",itemTypeId))
 	.if tmpItemTypeResult'="" d
 	..Set itemTypeSortNum = $p(tmpItemTypeResult,"||",1)
 	..Set result = itemTypeName_"^"_itemTypeSortNum_"^"_sortNum_"^"_levelNum_"^"_itemTypeId
 	
	Quit result
}

/// Creator：wang ying
/// CreatDate：2009-03-22
/// Description: 生成报表预输出数据
/// Table：data.CostResultData
/// Input：costDistSetId 分摊套, accountMonthId 核算区间
/// Output：
/// Return：返回临时global的序号
/// Others：
ClassMethod PrepareOutput(month, flag, deptTypeId, itemTypeId, fee) As dhc.ca.cache.report.CostResultData
{
	
	Set deptTypeId = $g(deptTypeId)
	Set deptTypeName = $p($g(^DHCCADEPTLEVELSETS(deptTypeId)),"^",2)
	Set itemTypeId = $g(itemTypeId)
	Set itemTypeId = $p($g(^DHCCADATALEVELSETS(itemTypeId)),"^",2)
	Set monthName=$p($g(^DHCCAACCOUNTMONTHS(month)),"^",2)
	if flag = "cost" d
	.Set type = "成本"
	else  d
	.Set type = "收入"
	
	Set reportData = ##class(dhc.ca.cache.report.Balanceofpayments).%New()
	Set reportData.deptType = deptTypeName  //科室类别
	Set reportData.deptName = ""  //科室名称
	Set reportData.itemName = ""  //项目名称
	Set reportData.itemType = itemTypeId  //项目类别
	Set reportData.money = fee //金额
	Set reportData.monthName = monthName  //月份名称
	Set reportData.month = month  //月份id
	Set reportData.type = type        //费用类别
	
	Quit reportData
}

ClassMethod ListBlanceofPaymentQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ListBlanceofPaymentQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	
	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod ListBlanceofPaymentQueryExecute(ByRef qHandle As %Binary, CostDistId As %String, month As %String, itemSetDr As %String) As %Status
{
		
	
	Set startTime = $zt($p($h,",",2))
	w "开始时间:"_startTime,!
	Set repid=$I(^CacheTemp)
	s ind=1
	////////////此处添加程序内容///////////////
	//若在入口处需要判断参数是否为空，需要如下格式
	//i billNo=”” s qHandle=$lb(0,repid,0) q $$$OK
	
	// 生成临时global
	Set deptSetDr = $p($g(^DHCCACOSTDISTSETS(CostDistId)),"^",5)
	Set deptCountNum = ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptSetDr,0)
	Set itemCountNum = ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(itemSetDr,0)
	
	w "第一阶段:"_$zt($p($h,",",2)),!
	
	s count=0
	s Count=0
	
	s len=$l(month,",")
	f i=1:1:len {
	  s monthDr=$p(month,",",i)
	  s costResultDataId=0
	  f  s costResultDataId=$o(^DHCCACOSTDISTSETS(0,"DInterval",CostDistId,monthDr,costResultDataId)) q:costResultDataId=""  d
	  .s count=count+1
	  .i $d(^DHCCACOSTDISTSETS(CostDistId,"CostResultData",costResultDataId)) d
	  ..d ..GetReportData(repid, ind, CostDistId, costResultDataId,itemSetDr,monthDr,"")
	  w "第二阶段:"_$zt($p($h,",",2))_"^count:"_count,!
	  s incomeDataId=""
	  f  s incomeDataId=$o(^DHCCAINCOMEDATAS(0,"Interval",monthDr,incomeDataId)) q:incomeDataId=""  d
	  .s Count=Count+1
	  .i $d(^DHCCAINCOMEDATAS(incomeDataId)) d
	  ..d ..GetReportData(repid, ind, CostDistId, costResultDataId,itemSetDr,monthDr,incomeDataId)
	  w "第三阶段:"_$zt($p($h,",",2))_"^Count:"_Count,!
	}	
	
	s distLocTypeDr=0 
	f  s distLocTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr)) q:distLocTypeDr=""  d
	.s distItemTypeDr=0
	.f  s distItemTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr)) q:distItemTypeDr=""  d
	..s costResultDataIntervalDr=0
	..f  s costResultDataIntervalDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr,costResultDataIntervalDr)) q:costResultDataIntervalDr=""  d
	...s fee=^TMPDHCCABLANCEOFPAYMENT($j,"cost",distLocTypeDr,distItemTypeDr,costResultDataIntervalDr)
	...s fee=$fn(fee,"",4)
	...s repType="szjy"
	...s dataType="成本"
	...s intervalDr=costResultDataIntervalDr
	...s distSetDr=CostDistId
	...s dataSetDr=itemSetDr
	...s deptName=""
	...s deptLayer=""
	...s deptOrder=""
	...s deptType=$p($g(^DHCCADEPTLEVELSETS(distLocTypeDr)),"^",2)
	...s itemName=""
	...s itemLayer=""
	...s itemOrder=""
	...s itemType=$p($g(^DHCCADATALEVELSETS(distItemTypeDr)),"^",2)
	...s deptDr=""
	...s itemDr=""
	...&SQL(Insert Into dhc_ca_cache_data.ReportResult(ReportResult_repType,ReportResult_intervalDr,ReportResult_distSetDr,ReportResult_dataSetDr,ReportResult_fee,ReportResult_deptName,ReportResult_deptLayer,ReportResult_deptOrder,ReportResult_deptType,ReportResult_itemName,ReportResult_itemLayer,ReportResult_itemOrder,ReportResult_itemType,ReportResult_dataType,ReportResult_deptDr,ReportResult_itemDr) VAlUES(:repType,:intervalDr,:distSetDr,:dataSetDr,:fee,:deptName,:deptLayer,:deptOrder,:deptType,:itemName,:itemLayer,:itemOrder,:itemType,:dataType,:deptDr,:itemDr))
	
	s distLocTypeDr=0 
	f  s distLocTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr)) q:distLocTypeDr=""  d
	.s distItemTypeDr=0
	.f  s distItemTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr)) q:distItemTypeDr=""  d
	..s month=0
	..f  s month=$O(^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr,month)) q:month=""  d
	...s fee=^TMPDHCCABLANCEOFPAYMENT($j,"income",distLocTypeDr,distItemTypeDr,month)
	...s fee=$fn(fee,"",4)
	...s repType="szjy"
	...s dataType="收入"
	...s intervalDr=month
	...s distSetDr=CostDistId
	...s dataSetDr=itemSetDr
	...s deptName=""
	...s deptLayer=""
	...s deptOrder=""
	...s deptType=$p($g(^DHCCADEPTLEVELSETS(distLocTypeDr)),"^",2)
	...s itemName=""
	...s itemLayer=""
	...s itemOrder=""
	...s itemType=$p($g(^DHCCADATALEVELSETS(distItemTypeDr)),"^",2)
	...s deptDr=""
	...s itemDr=""
	...&SQL(Insert Into dhc_ca_cache_data.ReportResult(ReportResult_repType,ReportResult_intervalDr,ReportResult_distSetDr,ReportResult_dataSetDr,ReportResult_fee,ReportResult_deptName,ReportResult_deptLayer,ReportResult_deptOrder,ReportResult_deptType,ReportResult_itemName,ReportResult_itemLayer,ReportResult_itemOrder,ReportResult_itemType,ReportResult_dataType,ReportResult_deptDr,ReportResult_itemDr) VAlUES(:repType,:intervalDr,:distSetDr,:dataSetDr,:fee,:deptName,:deptLayer,:deptOrder,:deptType,:itemName,:itemLayer,:itemOrder,:itemType,:dataType,:deptDr,:itemDr))
	
	
	s qHandle=$lb(0,repid,0)
	// 删除临时global
	Kill ^tmpdhccadeptleveltree($j) 
	Kill ^tmpdhccadataleveltree($j) 
	Kill ^TMPDHCCABLANCEOFPAYMENT($j) 
	Set stopTime = $zt($p($h,",",2))
	w "结束时间:"_stopTime,!
	
	Quit $$$OK
}

ClassMethod ListBlanceofPaymentQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListBlanceofPaymentQueryExecute ]
{
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

Query ListBlanceofPaymentQuery(CostDistId As %String, month As %String, itemSetDr As %String) As %Query(ROWSPEC = "deptType:%String:科室类别,deptName:%String:科室名称,itemName:%String:项目名称,itemType:%String:项目类别,money:%Float:金额,monthName:%String:月份名称,month:%String:月份id,type:%String:费用类别")
{
}

/// Creator：李明忠
/// CreatDate：2009-03-27
/// Description: 核对数据
/// Table：data.CostResultData
/// Input：CostDistId-成本分摊套ID;month-核算区间(格式:"1,2");itemSetDr-数据分层套
/// Output：
/// Return：返回临时global的序号
/// Others：w ##class(dhc.ca.cache.report.uBalanceOfPaymentQuery).CheckData(1,1,1)
ClassMethod CheckData(CostDistId, month, itemSetDr) As %String
{
	n (CostDistId,month,itemSetDr)
	
	;w "开始执行:"_$ZT($P($H,",",2)),!
	
	//获取部门分层套ID
	s deptSetDr = $P($G(^DHCCACOSTDISTSETS(CostDistId)),"^",5)
	d ##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptlevelSetSortedTree(deptSetDr,0)
	d ##class(dhc.ca.cache.report.comm.itemLevelSetTree).getDatalevelSetSortedTree(itemSetDr,0)
	
	//按照月份、分摊科室所属类别、分摊项目所属类别准备临时Global
	s len=$L(month,",")
	f i=1:1:len d
	.s monthDr=$P(month,",",i) //核算区间
	.s crdID=0 //成本分摊结果数据ID
	.f  s crdID=$O(^DHCCACOSTDISTSETS(0,"DInterval",CostDistId,monthDr,crdID)) q:crdID=""  d
	..i $D(^DHCCACOSTDISTSETS(CostDistId,"CostResultData",crdID)) d
	...s crddID=$P($G(^DHCCACOSTDISTSETS(CostDistId,"CostResultData",crdID)),"^",3) //分摊部门ID
 	...s crdItemDr=$P($G(^DHCCACOSTDISTSETS(CostDistId,"CostResultData",crdID)),"^",4) //成本项ID
 	...s crdFee=$P($G(^DHCCACOSTDISTSETS(CostDistId,"CostResultData",crdID)),"^",5) //成本项目金额
 	...s crdIntervalDr = $p($g(^DHCCACOSTDISTSETS(CostDistId,"CostResultData",crdID)), "^", 1) //核算区间
 	...s dLocTypeDr="" //科室类别ID
 	...s tmpResult=..GetLocTypeSortNum(deptSetDr,crddID)
 	...i tmpResult'="" s dLocTypeDr=$P(tmpResult,"^",5)
 	...s dItemTypeDr="" //项目类别ID
    ...s tmpItemResult=..GetItemTypeSortNum(itemSetDr,crdItemDr)
    ...i tmpItemResult'="" s dItemTypeDr=$P(tmpItemResult,"^",5)
 	...i ((dLocTypeDr'="")&&(dItemTypeDr'="")) d //根据条件将数据写入临时Global
 	....i ($D(^TMPDHCCABLANCEOFPAYMENT($j,"cost",crdIntervalDr,dLocTypeDr,dItemTypeDr))) d
 	.....s ^TMPDHCCABLANCEOFPAYMENT($j,"cost",crdIntervalDr,dLocTypeDr,dItemTypeDr)=^TMPDHCCABLANCEOFPAYMENT($j,"cost",crdIntervalDr,dLocTypeDr,dItemTypeDr)+crdFee
 	....e  d
 	.....s ^TMPDHCCABLANCEOFPAYMENT($j,"cost",crdIntervalDr,dLocTypeDr,dItemTypeDr)=crdFee
 	
 	//按照月份、分摊科室所属类别、分摊项目所属类别准备临时Global
 	f k=1:1:len d
 	.s MonthDr=$P(month,",",k)
 	.s idID=0 //收入数据的ID
	.f  s idID=$O(^DHCCAINCOMEDATAS(0,"Interval",MonthDr,idID)) q:idID=""  d
	..i $D(^DHCCAINCOMEDATAS(idID)) d
	...s tmpfDeptDr=$P($G(^DHCCAINCOMEDATAS(idID)),"^",11) //开单科室
	...s tmptDeptDr=$P($G(^DHCCAINCOMEDATAS(idID)),"^",14) //执行科室
 	...s tmpItemDr=$P($G(^DHCCAINCOMEDATAS(idID)),"^",6) //项目Id
 	...s tmpMonth=$P(^DHCCAINCOMEDATAS(idID),"^",1)
 	...i (tmpfDeptDr'="")&&(tmpItemDr'="")&&(tmpMonth=MonthDr) d
 	....i tmpfDeptDr=tmptDeptDr d
    .....s Fee=$P($G(^DHCCAINCOMEDATAS(idID)),"^",7) //取金额
 	.....s DLocTypeDr="" //科室类别ID
    .....s TmpResult=..GetLocTypeSortNum("",tmpfDeptDr)
    .....i TmpResult'="" s DLocTypeDr=$P(TmpResult,"^",5)
 	.....s DItemTypeDr="" //项目类别ID
    .....s TmpItemResult=..GetItemTypeSortNum(itemSetDr,tmpItemDr)
    .....i TmpItemResult'="" s DItemTypeDr=$P(TmpItemResult,"^",5)
 	.....i ((DLocTypeDr'="")&&(DItemTypeDr'="")) d //根据条件将数据写入临时Global
	......i ($D(^TMPDHCCABLANCEOFPAYMENT($j,"income",MonthDr,DLocTypeDr,DItemTypeDr)))  d
	.......s ^TMPDHCCABLANCEOFPAYMENT($j,"income",MonthDr,DLocTypeDr,DItemTypeDr)=Fee+^TMPDHCCABLANCEOFPAYMENT($j,"income",MonthDr,DLocTypeDr,DItemTypeDr)
	......e  d
	.......s ^TMPDHCCABLANCEOFPAYMENT($j,"income",MonthDr,DLocTypeDr,DItemTypeDr)=Fee
 	
 	//如果存在,则将临时Global中的数据写入报表类别表中
	i $D(^TMPDHCCABLANCEOFPAYMENT($j,"cost")) d 
 	.s MonthDr="",deptName="",deptLayer="",deptOrder="",itemName="",itemLayer="",itemOrder="",deptDr="",itemDr="",repType="szjy",dataType="成本",distSetDr=CostDistId,dataSetDr=itemSetDr
 	.f  s MonthDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"cost",MonthDr)) q:MonthDr=""  d
 	..s lTypeDr="" //科室类别ID
 	..f  s lTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"cost",MonthDr,lTypeDr)) q:lTypeDr=""  d
 	...s deptType=$P($G(^DHCCADEPTLEVELSETS(lTypeDr)),"^",2)
 	...s ITypeDr="" //项目类别ID
 	...f  s ITypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"cost",MonthDr,lTypeDr,ITypeDr)) q:ITypeDr=""  d
 	....s fee=$fn(^TMPDHCCABLANCEOFPAYMENT($j,"cost",MonthDr,lTypeDr,ITypeDr),"",4)
	....s intervalDr=MonthDr
	....s itemType=$P($G(^DHCCADATALEVELSETS(ITypeDr)),"^",2)
	....&SQL(Insert Into dhc_ca_cache_data.ReportResult(ReportResult_repType,ReportResult_intervalDr,ReportResult_distSetDr,ReportResult_dataSetDr,ReportResult_fee,ReportResult_deptName,ReportResult_deptLayer,ReportResult_deptOrder,ReportResult_deptType,ReportResult_itemName,ReportResult_itemLayer,ReportResult_itemOrder,ReportResult_itemType,ReportResult_dataType,ReportResult_deptDr,ReportResult_itemDr) VAlUES(:repType,:intervalDr,:distSetDr,:dataSetDr,:fee,:deptName,:deptLayer,:deptOrder,:deptType,:itemName,:itemLayer,:itemOrder,:itemType,:dataType,:deptDr,:itemDr))
 	
 	//如果存在,则将临时Global中的数据写入报表类别表中
 	i $D(^TMPDHCCABLANCEOFPAYMENT($j,"income")) d
 	.s monthdr="",deptName="",deptLayer="",deptOrder="",itemName="",itemLayer="",itemOrder="",deptDr="",itemDr="",repType="szjy",dataType="收入",distSetDr=CostDistId,dataSetDr=itemSetDr
 	.f  s monthdr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"income",monthdr)) q:monthdr=""  d
 	..s LTypeDr="" //科室类别ID
 	..f  s LTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"income",monthdr,LTypeDr)) q:LTypeDr=""  d
 	...s deptType=$P($G(^DHCCADEPTLEVELSETS(LTypeDr)),"^",2)
 	...s iTypeDr="" //项目类别ID
 	...f  s iTypeDr=$O(^TMPDHCCABLANCEOFPAYMENT($j,"income",monthdr,LTypeDr,iTypeDr)) q:iTypeDr=""  d
 	....s fee=$fn(^TMPDHCCABLANCEOFPAYMENT($j,"income",monthdr,LTypeDr,iTypeDr),"",4)
	....s intervalDr=monthdr
	....s itemType=$P($G(^DHCCADATALEVELSETS(iTypeDr)),"^",2)
	....&SQL(Insert Into dhc_ca_cache_data.ReportResult(ReportResult_repType,ReportResult_intervalDr,ReportResult_distSetDr,ReportResult_dataSetDr,ReportResult_fee,ReportResult_deptName,ReportResult_deptLayer,ReportResult_deptOrder,ReportResult_deptType,ReportResult_itemName,ReportResult_itemLayer,ReportResult_itemOrder,ReportResult_itemType,ReportResult_dataType,ReportResult_deptDr,ReportResult_itemDr) VAlUES(:repType,:intervalDr,:distSetDr,:dataSetDr,:fee,:deptName,:deptLayer,:deptOrder,:deptType,:itemName,:itemLayer,:itemOrder,:itemType,:dataType,:deptDr,:itemDr))	
	
	k ^TMPDHCCABLANCEOFPAYMENT($j) 
	k ^tmpdhccadeptleveltree($j) 
	k ^tmpdhccadataleveltree($j) 
	
	;w "执行结束:"_$ZT($P($H,",",2)),!
}

}
