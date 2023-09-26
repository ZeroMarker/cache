/// 名称:科室收入项目趋势分析报表
/// 描述: 报表打印、导出、展示
/// 编写者：李明忠
/// 编写日期:2010-4-7
Class dhc.ca.cache.report.uDeptIncomeItemTrendAnlys Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：李明忠
/// CreatDate：2010-3-31
/// Description: 获取科室类别
/// Table：
/// Input：SearchField-查询字段;SearchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).GetDeptTypes(0, 10)
ClassMethod GetDeptTypes(Start, Limit) As %String
{
	n (Start, Limit)
	
	s Count=0,ResultString=""
	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	s rowidStr="6,7"
	f i=1:1:$L(rowidStr,",") d
	.s rowid=$P(rowidStr,",",i)
	.s Curr=$G(^DHCCADEPTLEVELSETS(rowid))
	.s Name=$P(Curr,"^",2)
	.s Tmp=rowid_"^"_Name
	.s Count=Count+1
	.i (Count>=Start)&(Count<=End) d
	..d Json.InsertRowData(Tmp)
	s ResultString = Json.getJsonData("id^name",Count)
 	k Json
	q ResultString
}

/// Creator：李明忠
/// CreatDate：2010-4-6
/// Description: 根据科室类别获取实体科室
/// Table：
/// Input：deptTypeDrStr-科室类别ID字符串;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).GetEntityDepts("6,7","","","","",0,10)
ClassMethod GetEntityDepts(deptTypeDrStr, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s EntityDeptDrStr=""
	s Len=$L(deptTypeDrStr,",")
	f i=1:1:Len d
	.s DeptTypeDr=$P(deptTypeDrStr,",",i)
	.i DeptTypeDr'="" d
	..i EntityDeptDrStr'="" d
	...s EntityDeptDrStr=EntityDeptDrStr_"^"_..GetAllEntityDepts(DeptTypeDr)
	..e  d
	...s EntityDeptDrStr=..GetAllEntityDepts(DeptTypeDr)
	
	s Len=$L(EntityDeptDrStr,"^")
	f k=1:1:Len d
	.s DeptDr=$P(EntityDeptDrStr,"^",k)
	.i DeptDr'="" d
	..s DeptDesc=""
	..i $D(^DHCCAUNITDEPTS(DeptDr)) d
	...s DeptDesc=$P(^DHCCAUNITDEPTS(DeptDr),"^",3)
	..e  s DeptDesc=""
	..s tmp = DeptDr_"^"_DeptDesc
	..i searchValue '= "" d
	...q:(searchField = "Shortcut")&(Shortcut'[searchValue)
	...s count = count+1
	...i (count>start)&(count<=end) d
	....d json.InsertRowData(tmp)
	..e  d
	...s count=count+1
	...i (count>start)&(count<=end) d
	....d json.InsertRowData(tmp)
	
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
/// Description: 准备科室收入项目趋势分析报表数据
/// Table：
/// Input：MonthIDStr-核算月份ID字符串(格式:"1,2,3"),DeptDr-单元部门ID,DeptTypeDrStr-科室类别ID字符串
/// Output：
/// Return：暂不返回方法标志性值
/// Others：w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).ReadyDatas("1",183,"6,7")
ClassMethod ReadyDatas(MonthIDStr, DeptDr, DeptTypeDrStr) As %String
{
	n (MonthIDStr,DeptDr,DeptTypeDrStr)
	s EntityDeptList=##class(%Library.ListOfDataTypes).%New()
	i DeptDr'="" d //部门ID不为空，则添加当前部门ID
	.d EntityDeptList.Insert(DeptDr)
	e  d //部门ID为空,则添加所有部门ID
	.s EntityDeptDrStr=..GetAllEntityDepts(DeptTypeDrStr)
	.f i=1:1:$L(EntityDeptDrStr,"^") d
	..i $P(EntityDeptDrStr,"^",i)'="" d
	...d EntityDeptList.Insert($P(EntityDeptDrStr,"^",i)) //获得所有科室
	
	s ZYDeptDrStr=..GetAllEntityDepts(7)  //直接医疗科室List
	s ZYDeptList=##class(%Library.ListOfDataTypes).%New()
	s ZYDeptDrLen = $L(ZYDeptDrStr,"^")
	f j=1:1:ZYDeptDrLen d
	.s ZYDeptDr=$P(ZYDeptDrStr,"^",j)
	.i ZYDeptDr'="" d
	..d ZYDeptList.Insert(ZYDeptDr)
	
	s JYDeptDrStr=..GetAllEntityDepts(6)  //医疗技术科室List
	s JYDeptList=##class(%Library.ListOfDataTypes).%New()
	s JYDeptDrLen = $L(JYDeptDrStr,"^")
	f j=1:1:JYDeptDrLen d
	.s JYDeptDr=$P(JYDeptDrStr,"^",j)
	.i JYDeptDr'="" d
	..d JYDeptList.Insert(JYDeptDr)
	
	s MonthLen=$L(MonthIDStr,",")
	f i=1:1:MonthLen d
	.s MonthDr=$P(MonthIDStr,",",i)
	.i MonthDr'="" d
	..f k=1:1:EntityDeptList.Count() d
	...s DeptDr=EntityDeptList.GetAt(k) //取得科室
	...i DeptDr'="" d
	....i ZYDeptList.Find(DeptDr,1)'="" d //判断科室是否属于直接医疗科室
	.....i $D(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",MonthDr,DeptDr)) d
	......s rowid=""
	......f  s rowid=$O(^DHCCAINCOMEDATAS(0,"IntervalFdeptdr",MonthDr,DeptDr,rowid)) q:rowid=""  d
	.......s Curr=$G(^DHCCAINCOMEDATAS(rowid))
	.......s ItemDr=$P(Curr,"^",6)
	.......i ItemDr'="" d
	........s Fee=$P(Curr,"^",7)
	........i $D(^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)) d
	.........s ^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)=^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)+Fee
	........e  d
	.........s ^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)=Fee
	....i JYDeptList.Find(DeptDr,1)'="" d //判断科室是否属于医疗技术科室
	.....i $D(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",MonthDr,DeptDr)) d
	......s rowid=""
	......f  s rowid=$O(^DHCCAINCOMEDATAS(0,"IntervalTdeptdr",MonthDr,DeptDr,rowid)) q:rowid=""  d
	.......s Curr=$G(^DHCCAINCOMEDATAS(rowid))
	.......s ItemDr=$P(Curr,"^",6)
	.......i ItemDr'="" d
	........s Fee=$P(Curr,"^",7)
	........i $D(^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)) d
	.........s ^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)=^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)+Fee
	........e  d
	.........s ^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)=Fee
	
	d ..OutputReportRow()
}

//w ##class(dhc.ca.cache.report.uDeptIncomeItemTrendAnlys).OutputReportRow()

ClassMethod OutputReportRow() As %String
{
	//执行前先删除临时对象表中的数据
	&SQL(delete from dhc_ca_cache_report.DeptIncomeItemTA)
	s MonthDr=""
	f  s MonthDr=$O(^TMP("dhc","ca","kssrxmfx",$j,MonthDr)) q:MonthDr=""  d
	.i $D(^DHCCAACCOUNTMONTHS(MonthDr)) d
	..s MonthName=$E($P(^DHCCAACCOUNTMONTHS(MonthDr),"^",2),6,8)
	..i MonthName'="" d
	...s ItemDr=""
	...f  s ItemDr=$O(^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)) q:ItemDr=""  d
	....i $D(^DHCCAALLDATAITEMS(ItemDr)) d
	.....s ItemName=$P(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	....e  d
	.....s ItemName="未知成本项目"
	....s ItemValue=^TMP("dhc","ca","kssrxmfx",$j,MonthDr,ItemDr)
	....s obj = ##class(dhc.ca.cache.report.DeptIncomeItemTA).%New()
	....s obj.MonthName=MonthName
	....s obj.ItemName=ItemName
	....s obj.ItemValue=$fn(ItemValue,"",2)
	....d obj.%Save()
	k ^TMP("dhc","ca","kssrxmfx",$j)
}

}
