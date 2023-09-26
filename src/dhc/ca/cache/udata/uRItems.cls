/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 单位
Class dhc.ca.cache.udata.uRItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.RItems
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRItems).IfRepOrder("ss")
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef,order)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"RIOrder",parRef,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 部门是否存在
/// Table：dhc.ca.cache.data.RItems
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRItems).IfRepOrder("ss")
ClassMethod IfRepItem(parRef, itemDr) As %String
{
	n (parRef,itemDr)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"RIItemdr",parRef,itemDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-11-5
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.RItems
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRItems).InsertRec(1,1,1)
ClassMethod InsertRec(parRef, order, itemDr) As %String
{
	
	n (parRef, order, itemDr)
	
	s rowid=0
	s rowid=..IfRepOrder(parRef,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepItem(parRef,itemDr)
	q:rowid>0 "RepItem"
	
	&sql(insert into dhc_ca_cache_data.RItems (RItems_parRef,RItems_order,RItems_itemDr) values(:parRef, :order, :itemDr))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-11-5
/// Description: 更新记录
/// Table：dhc.ca.cache.data.RItems
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRItems).UpdateRec("7||1",1,2)
ClassMethod UpdateRec(rowId, order, itemDr) As %String
{
	n (rowId, order, itemDr)
	
	s parR=$p(rowId,"||",1)
	s sub=$p(rowId,"||",2)
	
	s rowid=0
	s rowid=..IfRepOrder(parR,order)
	q:(rowid'=0)&(rowid'=sub) "RepOrder"
	s rowid=..IfRepItem(parR,itemDr)
	q:(rowid'=0)&(rowid'=sub) "RepItem"

	&sql(update dhc_ca_cache_data.RItems set RItems_order=:order,RItems_itemDr=:itemDr where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table：dhc.ca.cache.data.RItems
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uRItems).DelRec("7||1")
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.RItems WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.RItems
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uRItems).ListRec(7,"","","","",0,25)
ClassMethod ListRec(parRef, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT RItems_parRef,RItems_rowid,RItems_order,RItems_itemDr FROM dhc_ca_cache_data.RItems"
	
	s whereStr=" WHERE RItems_childSub>0 AND RItems_parRef="_parRef
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="order" s sortField1="RItems_order"
	.i sortField="itemCode" s sortField1="RItems_itemDr"
	.i sortField="itemName" s sortField1="RItems_itemDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY RItems_order ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="parRef^rowId^order^itemDr^itemCode^itemName"
	
	While(result.Next())
	{
		s parRef = result.Data("RItems_parRef")
		s rowId = result.Data("RItems_rowid")
		s order = result.Data("RItems_order")
		s itemDr = result.Data("RItems_itemDr")

		s itemCode = $p(^DHCCAALLDATAITEMS(itemDr),"^",2)
		s itemName = $p(^DHCCAALLDATAITEMS(itemDr),"^",3)
		
		s tmp=parRef_"^"_rowId_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "itemCode")&(itemCode'[searchValue)
		.q:(searchField = "itemName")&(itemName'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uRItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
