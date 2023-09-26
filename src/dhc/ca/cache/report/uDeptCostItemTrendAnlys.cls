/// 名称:科室成本项目趋势分析报表
/// 描述: 报表打印、导出、展示
/// 编写者：李明忠
/// 编写日期:2010-4-6
Class dhc.ca.cache.report.uDeptCostItemTrendAnlys Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-4-6
/// Description: 获取实体科室
/// Table：
/// Input：SearchField-查询字段;SearchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uDeptCostItemTrendAnlys).GetEntityDepts("","","","",0,10)
ClassMethod GetEntityDepts(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select UnitDepts_rowid,UnitDepts_shortcut from dhc_ca_cache_data.UnitDepts where %ID>0 and UnitDepts_active='Y'"
	
	i sortField = "RowId" s sortField = "UnitDepts_rowid"
	i sortField = "Shortcut" s sortField = "UnitDepts_shortcut"
	
	s condition = ""
	i sortField'= "" s condition = " ORDER BY "_sortField_" "_sortDir
	
	s sqlStr = sqlStr_condition
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	While(result.Next()){
		s RowId = result.Data("UnitDepts_rowid")
		s Shortcut = result.Data("UnitDepts_shortcut")
		s tmp = RowId_"^"_Shortcut
		i searchValue '= "" d
		.q:(searchField = "Shortcut")&(Shortcut'[searchValue)
		.s count = count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		e  d
		.s count=count+1
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("id^shortcut",count)
	k json
	q resultString
}

/// Creator：李明忠
/// CreatDate：2010-4-7
/// Description: 获取所有的实体科室
/// Table：
/// Input：DeptTypeDrStr-部门类别ID字符串(格式:"6,7")
/// Output：
/// Return：返回所有实体部门ID字符串(格式:"1^2^3^4^5")
/// Others：w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).GetAllEntityDepts("6,7")
ClassMethod GetAllEntityDepts(DeptTypeDrStr) As %String
{
	n (DeptTypeDrStr)
	
	s EntityDeptDrStr=""
	s DeptTypeLen=$L(DeptTypeDrStr,",")
	
	//思路：首先获取叶子部门,其次在获取结构部门下的叶子部门
	f i=1:1:DeptTypeLen d
	.s DeptTypeDr=$P(DeptTypeDrStr,",",i)
	.i EntityDeptDrStr="" s EntityDeptDrStr=..GetLeafDepts(DeptTypeDr)
	.e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetLeafDepts(DeptTypeDr)
	.i EntityDeptDrStr="" s EntityDeptDrStr=..GetStuckDepts(DeptTypeDr)
	.e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetStuckDepts(DeptTypeDr)
	
	q EntityDeptDrStr
}

/// Creator：李明忠
/// CreatDate：2010-4-7
/// Description: 根据传入的部门类别获取该类别下的实体部门
/// Table：
/// Input：DeptTypeDr-部门类别ID
/// Output：
/// Return：实体科室ID字符串(格式:"59^60^61^62^63")
/// Others：w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).GetStuckDepts(6)
ClassMethod GetStuckDepts(DeptTypeDr) As %String
{
	n (DeptTypeDr)
	
	s rowid="",EntityDeptDrStr=""
	i $D(^DHCCADEPTLEVELSETS(0,"Parent",DeptTypeDr)) d
	.f  s rowid=$O(^DHCCADEPTLEVELSETS(0,"Parent",DeptTypeDr,rowid)) q:rowid=""  d
	..i $D(^DHCCADEPTLEVELSETS(0,"Parent",rowid)) d
	...i EntityDeptDrStr="" s EntityDeptDrStr=..GetLeafDepts(rowid)
	...e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetLeafDepts(rowid)
	...i EntityDeptDrStr="" s EntityDeptDrStr=..GetStuckDepts(rowid)
	...e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetStuckDepts(rowid)
	..e  d //直接获取实体部门
	...i EntityDeptDrStr="" s EntityDeptDrStr=..GetLeafDepts(rowid)
	...e  s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetLeafDepts(rowid)
	
	q EntityDeptDrStr
}

/// Creator：李明忠
/// CreatDate：2010-4-7
/// Description: 根据传入的部门类别获取该类别下的实体部门
/// Table：
/// Input：DeptTypeDr-部门类别ID
/// Output：
/// Return：实体科室ID字符串(格式:"59^60^61^62^63^68")
/// Others：w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).GetLeafDepts(6)
ClassMethod GetLeafDepts(DeptTypeDr) As %String
{
	n (DeptTypeDr)
	
	s LeafDrStr=""
	s childSubRowid=0 //0是党总支,所以从0以后的记录开始循环
	f  s childSubRowid=$O(^DHCCADEPTLEVELSETS(DeptTypeDr,"Depts",childSubRowid)) q:childSubRowid=""  d
	.i $P(^DHCCADEPTLEVELSETS(DeptTypeDr,"Depts",childSubRowid),"^",1)'="" d
	..s LeafDr=$P(^DHCCADEPTLEVELSETS(DeptTypeDr,"Depts",childSubRowid),"^",1) //获取实体部门的ID
	..i LeafDr'="" d
	...i LeafDrStr="" s LeafDrStr=LeafDr
	...e  s LeafDrStr=LeafDrStr_"^"_LeafDr
	
	q LeafDrStr
}

/// Creator：李明忠
/// CreatDate：2010-4-7
/// Description: 准备科室成本项目趋势分析报表数据
/// Table：
/// Input：MonthIDStr-核算月份ID字符串(格式:"1,2,3");DeptDr-单元部门ID
/// Output：
/// Return：暂不返回方法标志性值
/// Others：w ##class(dhc.ca.cache.report.uDeptCostItemTrendAnlys).ReadyDatas("2,1",6)
ClassMethod ReadyDatas(MonthIDStr, DeptDr) As %String
{
	//成本=直接成本+公用成本(直接成本标志:self,公用成本标志:dist)
	//按核算月份对直接成本、公用成本项目进行处理
	//最终的临时Global样式:^TMP("dhc","ca","dcita",$j,monthDr,ItemDr)=Fee
		
	n (MonthIDStr,DeptDr)
	
	;w "开始执行:"_$ZT($P($H,",",2)),!
	s EntityDeptList=##class(%Library.ListOfDataTypes).%New()
	i DeptDr'="" d //部门ID不为空，则添加当前部门ID
	.d EntityDeptList.Insert(DeptDr)
	e  d //部门ID为空,则添加所有部门ID
	.s rowid=0
	.f  s rowid=$O(^DHCCAUNITDEPTS(rowid)) q:rowid=""  d
	..d EntityDeptList.Insert(rowid) //获得所有科室
	
	//获取所有公用部门(格式:"1^2^3^4^5"),并装入集合
	/*
	s PublicDeptDrStr=..GetAllEntityDepts(3) 
	s PublicDeptList=##class(%Library.ListOfDataTypes).%New()
	s PublicDeptDrLen = $L(PublicDeptDrStr,"^")
	f j=1:1:PublicDeptDrLen d
	.s PublicDeptDr=$P(PublicDeptDrStr,"^",j)
	.i PublicDeptDr'="" d
	..d PublicDeptList.Insert(PublicDeptDr)
	*/
	
	s monthLen=$L(MonthIDStr,",")
	//成本分层套一的ID 
	s cdsRowid=1
	;w "第一阶段:"_$ZT($P($H,",",2)),!
	i $D(^DHCCACOSTDISTSETS(0,"DInterval",cdsRowid)) d
	.f k=1:1:monthLen d
	..s MonthDr=$P(MonthIDStr,",",k)
	..i MonthDr'="" d
	...i $D(^DHCCACOSTDISTSETS(0,"DInterval",cdsRowid,MonthDr)) d
	....s cRowid=""
	....f  s cRowid=$O(^DHCCACOSTDISTSETS(0,"DInterval",cdsRowid,MonthDr,cRowid)) q:cRowid=""  d
	.....i $D(^DHCCACOSTDISTSETS(cdsRowid,"CostResultData",cRowid)) d
	......s Curr=$G(^DHCCACOSTDISTSETS(cdsRowid,"CostResultData",cRowid))
	......s DistFlag=$P(Curr,"^",6)
	......i DistFlag="self" d //直接成本
	.......s DeptDr=$P(Curr,"^",3)
	.......i EntityDeptList.Find(DeptDr,1)'="" d
	........s ItemDr=$P(Curr,"^",4)
	........i ItemDr'="" d
	.........s SelfFee=$P(Curr,"^",5)
	.........i $D(^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)) d
	..........s ^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)=^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)+SelfFee
	.........e  d
	..........s ^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)=SelfFee
	/*
	......i DistFlag="dist" d //查询公用部门分摊给该部门成本
	.......s DistDeptDr=$P(Curr,"^",2) //被分摊部门
	.......i PublicDeptList.Find(DistDeptDr,1)'="" d
	........s DeptDr=$P(Curr,"^",3)
	........i EntityDeptList.Find(DeptDr,1)'="" d
	.........s ItemDr=$P(Curr,"^",4)
	.........i ItemDr'="" d
	..........s DistFee=$P(Curr,"^",5)
	..........i $D(^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)) d
	...........s ^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)=^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)+DistFee
	..........e  d
	...........s ^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)=DistFee
	*/
	;w "第二阶段:"_$ZT($P($H,",",2)),!
	
	d ..OutputReportRow()
}

//w ##class(dhc.ca.cache.report.uDeptCostItemTrendAnlys).OutputReportRow()

ClassMethod OutputReportRow() As %String
{
	//执行前先删除临时对象表中的数据
	&SQL(delete from dhc_ca_cache_report.DeptCostItemTA)
	
	s MonthDr=""
	f  s MonthDr=$O(^TMP("dhc","ca","dcita",$j,MonthDr)) q:MonthDr=""  d
	.i $D(^DHCCAACCOUNTMONTHS(MonthDr)) d
	..s MonthName=$E($P(^DHCCAACCOUNTMONTHS(MonthDr),"^",2),6,8)
	..i MonthName'="" d
	...s ItemDr=""
	...f  s ItemDr=$O(^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)) q:ItemDr=""  d
	....i $D(^DHCCAALLDATAITEMS(ItemDr)) s ItemName=$P(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	....e  s ItemName="未知成本项目"
	....s ItemValue=^TMP("dhc","ca","dcita",$j,MonthDr,ItemDr)
	....s obj = ##class(dhc.ca.cache.report.DeptCostItemTA).%New()
	....s obj.MonthName=MonthName
	....s obj.ItemName=ItemName
	....s obj.ItemValue=$fn(ItemValue,"",2)
	....d obj.%Save()
	k ^TMP("dhc","ca","dcita",$j)
}

}
