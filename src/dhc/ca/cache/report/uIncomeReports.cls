Class dhc.ca.cache.report.uIncomeReports Extends (%Persistent, %Populate, %XML.Adaptor) [ ClassType = persistent, Inheritance = right, ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-01-27
/// Description: 生成临时表IncomeReports数据
/// Table: dhc.ca.cache.report.IncomeReports
/// Input: intervalDr-月份区间; patType-病人类型; itemDr-业务项ID; fDeptDr-开单科室; tDeptDr-接收科室; patDeptDr-病人科室; incomeLayer-项目层; deptLayer-部门层; deptType-科室类型
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.report.uIncomeReports).ListRec("1","","134","","","","","6","F")
ClassMethod ListRec(intervalDr, patType, itemDr, fDeptDr, tDeptDr, patDeptDr, incomeLayer, deptLayer, deptType)
{
	//w intervalDr_"[#]"_patType_"[#1]"_itemDr_"[#2]"_fDeptDr_"[#3]"_tDeptDr_"[#4]"_patDeptDr_"[#5]"_incomeLayer_"[#6]"_deptLayer_"[#7]"_deptType,!
	TSTART
	s sqlStr="SELECT IncomeDatas_inDate, IncomeDatas_rowid,IncomeDatas_intervalDr, IncomeDatas_feeDate, IncomeDatas_patType, IncomeDatas_itemCode, IncomeDatas_itemName, IncomeDatas_itemDr, IncomeDatas_fee, IncomeDatas_cost, IncomeDatas_fDeptCode, IncomeDatas_fDeptName, IncomeDatas_fDeptDr, IncomeDatas_tDeptCode, IncomeDatas_tDeptName, IncomeDatas_tDeptDr, IncomeDatas_patDeptCode, IncomeDatas_patDeptName, IncomeDatas_patDeptDr, IncomeDatas_inType, IncomeDatas_inPersonDr, IncomeDatas_remark FROM dhc_ca_cache_data.IncomeDatas "
	
	s whereStr=" WHERE %ID>0 "
	
	i intervalDr'="" s whereStr=whereStr_"AND IncomeDatas_intervalDr in ("_intervalDr_") "
	i patType'="" s whereStr=whereStr_"AND IncomeDatas_patType = '"_patType_"' "
	i itemDr'="" s whereStr=whereStr_"AND IncomeDatas_itemDr = '"_itemDr_"' "
	i fDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_fDeptDr = '"_fDeptDr_"' "
	i tDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_tDeptDr = '"_tDeptDr_"' "
	i patDeptDr'="" s whereStr=whereStr_"AND IncomeDatas_patDeptDr = '"_patDeptDr_"' "
	
	s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s resultString=0
	
	While(result.Next())
	{
		s rowid=result.Data("IncomeDatas_rowid")
		s intervalDr=result.Data("IncomeDatas_intervalDr")
		s intervalName=""
		i intervalDr'="" d
		.s intervalName=$p($g(^DHCCAACCOUNTMONTHS(intervalDr)),"^",2)
		
		s feeDate=result.Data("IncomeDatas_feeDate")
		i feeDate'="" s feeDate=$zd(feeDate,3)
		
		s patType=result.Data("IncomeDatas_patType")
		
		s itemCode=result.Data("IncomeDatas_itemCode")
		s itemName=result.Data("IncomeDatas_itemName")
		
		s itemDr=result.Data("IncomeDatas_itemDr")
		s inItemName=""
		s inItemCode=""
		i itemDr'="" d
		.s inItemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s inItemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s fee=result.Data("IncomeDatas_fee")
		s cost=result.Data("IncomeDatas_cost")
		s fDeptCode=result.Data("IncomeDatas_fDeptCode")
		s fDeptName=result.Data("IncomeDatas_fDeptName")
		
		s fDeptDr=result.Data("IncomeDatas_fDeptDr")
		s inFDeptCode=""
		s inFDeptName=""
		i fDeptDr'="" d
		.s inFDeptCode=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",1)
		.s inFDeptName=$p($g(^DHCCAUNITDEPTS(fDeptDr)),"^",2)
		
		s tDeptCode=result.Data("IncomeDatas_tDeptCode")
		s tDeptName=result.Data("IncomeDatas_tDeptName")
		
		s tDeptDr=result.Data("IncomeDatas_tDeptDr")
		s inTDeptCode=""
		s inTDeptName=""
		i tDeptDr'="" d
		.s inTDeptCode=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",1)
		.s inTDeptName=$p($g(^DHCCAUNITDEPTS(tDeptDr)),"^",2)
		
		s patDeptCode=result.Data("IncomeDatas_patDeptCode")
		s patDeptName=result.Data("IncomeDatas_patDeptName")
		
		s patDeptDr=result.Data("IncomeDatas_patDeptDr")
		s inPatDeptCode=""
		s inPatDeptName=""
		i patDeptDr'="" d
		.s inPatDeptCode=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",1)
		.s inPatDeptName=$p($g(^DHCCAUNITDEPTS(patDeptDr)),"^",2)
		
		s inType=result.Data("IncomeDatas_inType")
		
		s personDr=result.Data("IncomeDatas_inPersonDr")
		s personName=""
		i personDr'="" d
		.s personName=$p($g(^DHCCAUNITPERSONS(personDr)),"^",2)
		
		s remark=result.Data("IncomeDatas_remark")
		s inDate=result.Data("IncomeDatas_inDate")
		i inDate'="" s inDate=$zd(inDate,3)
		//按项目分层
		i incomeLayer'="" d
		.i $d(^DHCCADATALEVELSETS(incomeLayer)) d
		..s tmpItemDr=""
		..s tmpItemDr=..GetIdByItem(itemDr)
		..i tmpItemDr'="" s tmpItemDr=$p(tmpItemDr,"||",1)_"^"_$p(tmpItemDr,"||",2)
		..//w tmpItemDr,!
		..s tmpLayer=""
		..s tmpLayer=##class(dhc.ca.cache.report.comm.itemLevelSetTree).getItemClassInId(tmpItemDr)
		..i tmpLayer=incomeLayer d
		...&SQL(INSERT INTO dhc_ca_cache_report.IncomeReports (IncomeDatas_intervalDr,IncomeDatas_intervalName,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_fDeptName,IncomeDatas_tDeptDr,IncomeDatas_tDeptName,IncomeDatas_patDeptDr,IncomeDatas_patDeptName,IncomeDatas_inType) VALUES (:intervalDr,:intervalName,:patType,:itemDr,:inItemName,:fee,:cost,:fDeptDr,:inFDeptName,:tDeptDr,:inTDeptName,:patDeptDr,:inPatDeptName,:inType))
		...i SQLCODE'=0 s resultString=SQLCODE
		e  i deptLayer'="" d
		.i $d(^DHCCADEPTLEVELSETS(deptLayer)) d
		..s deptLevelSetsDr=""
		..//没有返回他的套
		..s deptLevelSetsDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(deptLayer)
		..s deptLayerName=""
		..s deptLayerName=$p($g(^DHCCADEPTLEVELSETS(deptLayer)),"^",2)
		..s tmpDeptId=""
		..i deptType="F" s tmpDeptId=fDeptDr
		..i deptType="T" s tmpDeptId=tDeptDr
		..i deptType="Pat" s tmpDeptId=patDeptDr
		..s tmpString=""
		..s tmpString=##class(dhc.ca.cache.report.comm.deptLevelSetTree).getDeptLevelNumAndClassInDept(deptLevelSetsDr,tmpDeptId)
		..i deptLayerName=$p(tmpString,"||",2) d
		...&SQL(INSERT INTO dhc_ca_cache_report.IncomeReports (IncomeDatas_intervalDr,IncomeDatas_intervalName,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_fDeptName,IncomeDatas_tDeptDr,IncomeDatas_tDeptName,IncomeDatas_patDeptDr,IncomeDatas_patDeptName,IncomeDatas_inType) VALUES (:intervalDr,:intervalName,:patType,:itemDr,:inItemName,:fee,:cost,:fDeptDr,:inFDeptName,:tDeptDr,:inTDeptName,:patDeptDr,:inPatDeptName,:inType))
		...i SQLCODE'=0 s resultString=SQLCODE
		e  d
		.&SQL(INSERT INTO dhc_ca_cache_report.IncomeReports (IncomeDatas_intervalDr,IncomeDatas_intervalName,IncomeDatas_patType,IncomeDatas_itemDr,IncomeDatas_itemName,IncomeDatas_fee,IncomeDatas_cost,IncomeDatas_fDeptDr,IncomeDatas_fDeptName,IncomeDatas_tDeptDr,IncomeDatas_tDeptName,IncomeDatas_patDeptDr,IncomeDatas_patDeptName,IncomeDatas_inType) VALUES (:intervalDr,:intervalName,:patType,:itemDr,:inItemName,:fee,:cost,:fDeptDr,:inFDeptName,:tDeptDr,:inTDeptName,:patDeptDr,:inPatDeptName,:inType))
		.i SQLCODE'=0 s resultString=SQLCODE
	}
	i resultString=0 TCOMMIT
	e  TROLLBACK
	d result.Close()
	q resultString
}

//w ##class(dhc.ca.cache.report.uIncomeReports).ListDistResult("1","","134","","","","","6","F")

ClassMethod ListDistResult(intervalDr, patType, itemDr, fDeptDr, tDeptDr, patDeptDr, incomeLayer, deptLayer, deptType) As %String
{
		
		
		Do ##class(dhc.ca.cache.report.IncomeReports).%DeleteExtent() 
		Set res = ..ListRec(intervalDr, patType, itemDr, fDeptDr, tDeptDr, patDeptDr, incomeLayer, deptLayer, deptType)	
	    Quit res
}

/// Creator：杨旭
/// CreatDate：2010-01-27
/// Description: 查询数据分层套的项目ID
/// Table：LevelItems
/// Input：itemDr-项目ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uIncomeReports).GetIdByItem("1","123")
ClassMethod GetIdByItem(itemLayer, itemDr)
{
	q:itemDr="" 0
	q:itemLayer="" 0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr,LevelItems_order from dhc_ca_cache_data.LevelItems where LevelItems_childSub>0 and LevelItems_itemDr='"_itemDr_"' "
	//w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()

	s ResultString = 0

	While(Result.Next())
	{
		
		s tmpResultString = Result.Data("LevelItems_rowid")
		//w tmpResultString,!
		s tmpRs=..checkParants(itemLayer,$p(tmpResultString,"||",1))
		i (tmpRs=0) s ResultString=tmpResultString
	
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2010-03-17
/// Description: 查看某一层是否是某层的子节点
/// Table：LevelItems
/// Input：parants-父层ID;child-待查层ID;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uIncomeReports).checkParants("1","123")
ClassMethod checkParants(parants, child)
{
 
	q:parants="" ""
	q:child="" ""
	s tmpStr=0
	s resultString=1
	q:parants=child 0
	i $d(^DHCCADATALEVELSETS(child)) d
	.s tmpParants=""
	.s tmpStr=$p($g(^DHCCADATALEVELSETS(child)),"^",7)
	.q:tmpStr=0
	.s tmpParants=tmpStr
	.i tmpParants=parants s resultString=0
	.e  s resultString=..checkParants(parants,tmpParants)
	q resultString
}

/// Creator：杨旭
/// CreatDate：2010-01-27
/// Description: 取得当前层以下的所有科室
/// Table：dhc.ca.cache.data.CostDistMethods
/// Input：order-当前层序号;start-起始位置;limit-查询条数;searchValue-模糊查询字符串;deptLevelSetsDr-分层套ID
/// Output：
/// Return：返回此层下的所有科室
/// Others：w ##class(dhc.ca.cache.report.uIncomeReports).GetCurrentLayerDepts(6,0,10,"一",1)
ClassMethod GetCurrentLayerDepts(order, start, limit, searchValue, deptLevelSetsDr) As %String
{
	q:deptLevelSetsDr="" ""
	q:order="" ""
	d ##class(dhc.ca.cache.udata.CostDist).GetLayers(deptLevelSetsDr)
	s tmpDepts=""
	s tmpDepts=##class(dhc.ca.cache.udata.CostDist).GetCurrentLayerDepts(order)
	s depts=""
	s depts=..GetDepts(tmpDepts)
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="deptDr^deptDesc"
	s count=0
	s end=start+limit-1
	s deptDr=""
	f index=1:1:$l(depts,"^") d
	.s deptDr=""
	.s deptDr=$p(depts,"^",index)
	.//s tmpRs=..checkExist(parRef,deptDr)
	.//i (tmpRs=0) d
	.s deptDesc=""
	.i deptDr'="" d
	..s deptDesc=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
	..s tmp=deptDr_"^"_deptDesc
	..i searchValue'="" d
	...q:(deptDesc'[searchValue)
	...i (count>=start)&(count<=end) d
	....d json.InsertRowData(tmp)
	...s count=count+1
	..e  d
	...i (count>=start)&(count<=end) d
	....d json.InsertRowData(tmp)
	...s count=count+1
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：杨旭
/// CreatDate: 2010-1-7
/// Description: 当前科室中指定类型的科室
/// Table: 
/// Input: depts-科室
/// Output: 
/// Return: 指定类型科室串
/// Others: 
ClassMethod GetDepts(depts) As %String
{
	
	s result=""
	q:depts="" ""
	
	f i=1:1:$l(depts,"^") d
	.s tmp=$p(depts,"^",i)
	.i tmp'="" d
	..s dept=$p(tmp,"!",1)
	..i dept'="" d
	...i result="" s result=dept
	...e  s result=result_"^"_dept
	
	q result
}

/// Creator：杨旭
/// CreatDate：2010-01-27
/// Description: 遍历所有同根节点下的所有项目
/// Table：dhc.ca.cache.report.IncomeReports
/// Input：root-根节点ID;ResultString-返回的结果变量
/// Output：
/// Return：返回项目ID串
/// Others：w ##class(dhc.ca.cache.report.uIncomeReports).GetItemByNode(4,"")
ClassMethod GetItemByNode(root, ResultString)
{
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_root_"' and DataLevelSets_active='Y'"
	s ResultString=""
	s ResultString=##class(dhc.ca.cache.udata.uDataLevelSets).GetLeaves(root)
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s Rowid = Result.Data("DataLevelSets_rowid")
		i ResultString="" d
		.s ResultString=##class(dhc.ca.cache.udata.uDataLevelSets).GetLeaves(Rowid)
		e  i (##class(dhc.ca.cache.udata.uDataLevelSets).GetLeaves(Rowid)'=0) d
		.s ResultString =ResultString_","_##class(dhc.ca.cache.udata.uDataLevelSets).GetLeaves(Rowid)
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2010-01-27
/// Description: 取得当前层以下的所有科室
/// Table：dhc.ca.cache.report.IncomeReports
/// Input：node-节点ID;start-起始位置;limit-查询条数;searchValue-模糊查询字符串;
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.report.uIncomeReports).GetLowLayerItem(4,0,20,"挂号")
ClassMethod GetLowLayerItem(node, start, limit, searchValue) As %String
{
	q:node="" ""
	s items=""
	s items=..GetItemByNode(node,"")
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="itemDr^itemDesc"
	s count=0
	s end=start+limit
	s deptDr=""
	f index=1:1:$l(items,",") d
	.s itemDr=""
	.s itemDr=$p(items,",",index)
	.s itemDesc=""
	.i itemDr'="" d
	..s itemDesc=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",4)
	..s tmp=itemDr_"^"_itemDesc
	..i searchValue'="" d
	...q:(itemDesc'[searchValue)
	...i (count>=start)&(count<=end) d
	....d json.InsertRowData(tmp)
	...s count=count+1
	..e  d
	...i (count>=start)&(count<=end) d
	....d json.InsertRowData(tmp)
	...s count=count+1
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<Data name="uIncomeReportsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uIncomeReportsD</DataLocation>
<DefaultData>uIncomeReportsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uIncomeReportsD</IdLocation>
<IndexLocation>^dhc.ca.c.uIncomeReportsI</IndexLocation>
<StreamLocation>^dhc.ca.c.uIncomeReportsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
