/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 接口项目表
Class dhc.ca.cache.udata.uOutItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 序号是否存在
/// Table：dhc.ca.cache.data.OutItems
/// Input: order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uOutItems).IfRepOrder("1||15",1)
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef,order)
	s InItemSetsRowid = $p(parRef,"||",1)
	s InItemsChildSub = $p(parRef,"||",2)
	//s InItemsChildSub = 0
	s rowid=""
	s rowid=$o(^DHCCAINITEMSETS(0,"OutOrder",InItemSetsRowid,InItemsChildSub,order,rowid))
	//f  s InItemsChildSub = $o(^DHCCAINITEMSETS(0,"OutOrder",InItemSetsRowid,InItemsChildSub)) q:(InItemsChildSub="")||(rowid'="")  d
	//.s rowid=$o(^DHCCAINITEMSETS(0,"OutOrder",InItemSetsRowid,InItemsChildSub,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: item是否存在
/// Table：dhc.ca.cache.data.OutItems
/// Input: order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uOutItems).IfRepOrder("1")
ClassMethod IfRepItemDr(parRef, itemDr) As %String
{
	n (parRef,itemDr)
	s InItemSetsRowid = $p(parRef,"||",1)
	s InItemsChildSub = $p(parRef,"||",2)
	s rowid=0
	s rowid=$o(^DHCCAINITEMSETS(0,"OutItemDr",InItemSetsRowid,InItemsChildSub,itemDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-10-26
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.OutItems
/// Input：parRef-InItemSetsDr;order-序号;itemDr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uOutItems).InsertRec("1||1",1,1,"remark")
ClassMethod InsertRec(parRef, order, itemDr, remark) As %String
{
	
	n (parRef, order, itemDr, remark)
	
	s rowid=0
	s rowid=..IfRepOrder(parRef,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepItemDr(parRef,itemDr)
	q:rowid>0 "RepItem"
	
	&sql(insert into dhc_ca_cache_data.OutItems (OutItems_parRef,OutItems_order,OutItems_itemDr,OutItems_remark) values(:parRef,:order,:itemDr,:remark))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-26
/// Description: 更新记录
/// Table：dhc.ca.cache.data.OutItems
/// Input：rowId-所在行号;parRef-InItemSetsDr;order-序号;itemDr
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uOutItems).UpdateRec("1||1||2","1||1",1,4,"re")
ClassMethod UpdateRec(rowId, parRef, itemDr, order, remark) As %String
{
	
	n (rowId, parRef, itemDr, order, remark)
	
	s tmpRowid=0
	s childSub = $p(rowId,"||",3)
	s tmpRowid=..IfRepOrder(parRef,order)
	q:(tmpRowid'=0)&(tmpRowid'=childSub) "RepOrder"
	s tmpRowid=..IfRepItemDr(parRef,itemDr)
	q:(tmpRowid'=0)&(tmpRowid'=childSub) "RepItem"
		
	&sql(update dhc_ca_cache_data.OutItems set OutItems_order=:order,OutItems_itemDr=:itemDr,OutItems_parRef=:parRef,OutItems_remark=:remark where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 删除记录
/// Table：dhc.ca.cache.data.OutItems
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uOutItems).DelRec("1||1||2")
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.OutItems WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.OutItems
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutItems).ListRec("1||1","","","","",0,25)
ClassMethod ListRec(parRef, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT OutItems_rowid,OutItems_order,OutItems_parRef,OutItems_itemDr,OutItems_remark FROM dhc_ca_cache_data.OutItems"
	
	s whereStr=" WHERE OutItems_childSub>0"
    s whereStr=whereStr_" AND OutItems_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="OutItems_rowid"
	.i sortField="order" s sortField1="OutItems_order"
	.i sortField="itemDr" s sortField1="OutItems_itemDr"
	.i sortField="remark" s sortField1="OutItems_remark"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY OutItems_order DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^order^parRef^remark^itemDr^itemName^itemCode"
	
	While(result.Next())
	{
		s rowId=result.Data("OutItems_rowid")
		s order=result.Data("OutItems_order")
		s parRef=result.Data("OutItems_parRef")
		s itemDr=result.Data("OutItems_itemDr")
		s remark=result.Data("OutItems_remark")
		
		S itemName = $p(^DHCCAALLDATAITEMS(itemDr),"^",3)
		S itemCode = $p(^DHCCAALLDATAITEMS(itemDr),"^",2)
		
		s tmp=rowId_"^"_order_"^"_parRef_"^"_remark_"^"_itemDr_"^"_itemName_"^"_itemCode
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
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

/// Others: w ##class(dhc.ca.cache.udata.uOutItems).ListRemain("2","shortcut","","","",0,10)
ClassMethod ListRemain(dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q dataTypeDr_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT DataItemCorres_rowid,DataItemCorres_typeDr,DataItemCorres_order,DataItemCorres_itemDr FROM dhc_ca_cache_data.DataItemCorres"
	
	s whereStr=" WHERE %ID>0"
	s whereStr=whereStr_" AND DataItemCorres_typeDr='"_dataTypeDr_"'"
	s whereStr=whereStr_" AND DataItemCorres_itemDr not in(SELECT OutItems_itemDr FROM dhc_ca_cache_data.OutItems where %ID>0 and OutItems_itemDr is not null )"
	s sqlStr=sqlStr_whereStr
	
	;s result=##class(%Library.ResultSet).%New()
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^typeDr^typeName^typeShortCut^order^itemDr^itemCode^itemName^itemShortCut"
	
	While(result.Next())
	{
		s rowid=result.Data("DataItemCorres_rowid")
		s typeDr=result.Data("DataItemCorres_typeDr")
		s typeName=""
		s typeShortCut=""
		i typeDr'="" d
		.s typeName=$p($g(^DHCCADATAITEMTYPES(typeDr)),"^",3)
		.s typeShortCut=$p($g(^DHCCADATAITEMTYPES(typeDr)),"^",4)
		s order=result.Data("DataItemCorres_order")
		s itemDr=result.Data("DataItemCorres_itemDr")
		s itemName=""
		s itemCode=""
		s itemShortCut=""
		i itemDr'="" d
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		.s itemShortCut=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",4)

		s tmp=rowid_"^"_typeDr_"^"_typeName_"^"_typeShortCut_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemShortCut
		i itemShortCut'="" d
		.i searchValue'="" d
		..q:(searchField = "shortcut")&(itemShortCut'[searchValue)
		..i (count>=start)&(count<=end) d
		...d json.InsertRowData(tmp)
		..s count=count+1
		.e  d
		..i (count>=start)&(count<=end) d
		...d json.InsertRowData(tmp)
		..s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others: w ##class(dhc.ca.cache.udata.uOutItems).outItemChange('1||1',"1||1||3")
ClassMethod outItemChange(parRef, rowid) As %String [ SqlProc ]
{
	n (parRef,rowid)
	q:(parRef="")||(rowid="")
	&sql(select OutItems_parRef,OutItems_order,OutItems_itemDr,OutItems_remark into :oldParRef,:order,:itemDr,:remark from dhc_ca_cache_data.OutItems where OutItems_rowid=:rowid)
    &sql(delete from dhc_ca_cache_data.OutItems where OutItems_rowid=:rowid)
    &sql(update dhc_ca_cache_data.OutItems set OutItems_order=OutItems_order-1 where OutItems_parRef=:oldParRef and OutItems_childSub>0 and OutItems_order>:order)
    &sql(select max(OutItems_order)+1 into :newOrder from dhc_ca_cache_data.OutItems where OutItems_parRef=:parRef and OutItems_childSub>0)
    i newOrder="" s newOrder=1	//zjw  针对新接口部门尚未有接口
    &sql(insert into dhc_ca_cache_data.OutItems (OutItems_parRef,OutItems_order,OutItems_itemDr,OutItems_remark) values(:parRef,:newOrder,:itemDr,:remark))
    q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uOutItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
