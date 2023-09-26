/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 接口核算项目表
Class dhc.ca.cache.udata.uInItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 序号是否存在
/// Table：dhc.ca.cache.data.InItems
/// Input: order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uInItems).IfRepOrder("1")
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef,order)
	s rowid=0
	s rowid=$o(^DHCCAINITEMSETS(0,"InOrder",parRef,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: itemdr是否存在
/// Table：dhc.ca.cache.data.InItems
/// Input: itemDr-项目
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uInItems).IfRepItemDr("1")
ClassMethod IfRepItemDr(parRef, itemDr) As %String
{
	n (parRef,itemDr)
	s rowid=0
	s rowid=$o(^DHCCAINITEMSETS(0,"InItem",parRef,itemDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-10-26
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.InItems
/// Input：parRef-InItemSetsDr;order-序号;itemDr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInItems).InsertRec(1,1,1)
ClassMethod InsertRec(parRef, order, itemDr) As %String
{
	
	n (parRef, order, itemDr)
	
	s rowid=0
	s rowid=..IfRepOrder(parRef,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepItemDr(parRef,itemDr)
	q:rowid>0 "RepItem"
	
	&sql(insert into dhc_ca_cache_data.InItems (InItems_parRef,InItems_order,InItems_itemDr) values(:parRef,:order,:itemDr))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-27
/// Description: 插入某一数据类中的所有数据
/// Table：dhc.ca.cache.data.InItems
/// Input：parRef-父;itemType-数据类;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInItems).InsertAllRec(parRef,itemType)
ClassMethod InsertAllRec(parRef, itemType) As %String
{
	
	n (parRef,itemType)
	
	s itemDr="0"
	s num=0
	f  s itemDr=$o(^DHCCADATAITEMCORRES(0,"TypeItem",itemType,itemDr)) q:itemDr=""  d
	.s id = ..IfRepItemDr(parRef,itemDr)
	.i id=0 d
	..&sql(insert into dhc_ca_cache_data.InItems (InItems_parRef,InItems_itemDr) values(:parRef,:itemDr))
	q num
}

/// Creator：王赢赢
/// CreatDate：2009-10-26
/// Description: 更新记录
/// Table：dhc.ca.cache.data.InItems
/// Input：rowId-所在行号;parRef-InItemSetsDr;order-序号;itemDr
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInItems).UpdateRec("1||3",1,4,4)
ClassMethod UpdateRec(rowId, parRef, order, itemDr) As %String
{
	
	n (rowId, parRef, order, itemDr)
	
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(parRef,order)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowId,"||",2)) "RepOrder"
	s tmpRowid=..IfRepItemDr(parRef,itemDr)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowId,"||",2)) "RepItem"
		
	&sql(update dhc_ca_cache_data.InItems set InItems_order=:order,InItems_itemDr=:itemDr,InItems_parRef=:parRef where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 删除记录
/// Table：dhc.ca.cache.data.InItems
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInItems).DelRec("1||3")
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InItems WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-26
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.InItems
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInItems).ListRec(1,"","","","",0,25)
ClassMethod ListRec(parRef, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InItems_rowid,InItems_order,InItems_parRef,InItems_itemDr FROM dhc_ca_cache_data.InItems"
	
	s whereStr=" WHERE InItems_childSub>0"
	
	s whereStr=whereStr_" AND InItems_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="InItems_rowid"
	.i sortField="order" s sortField1="InItems_order"
	.i sortField="itemDr" s sortField1="InItems_itemDr"
	.i sortField="itemCode" s sortField1="InItems_itemDr"
	.i sortField="itemName" s sortField1="InItems_itemDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InItems_childSub ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	;s result=##class(%Library.ResultSet).%New()
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	d result.Prepare(sqlStr)
	;w "<br>"_sqlStr_"</br>"
	s mysc= result.Execute()
	;w "<br>"_mysc_"</br>"
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^order^parRef^itemDr^itemName^itemCode"
	s mysc=""
	While(result.Next(.mysc))
	{
		;w "<br>"_mysc_"</br>"
		s rowId=result.Data("InItems_rowid")
		s order=result.Data("InItems_order")
		s parRef=result.Data("InItems_parRef")
		s itemDr=result.Data("InItems_itemDr")
		
		S itemName = $p(^DHCCAALLDATAITEMS(itemDr),"^",3)
		S itemCode = $p(^DHCCAALLDATAITEMS(itemDr),"^",2)
		
		s tmp=rowId_"^"_order_"^"_parRef_"^"_itemDr_"^"_itemName_"^"_itemCode
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "itemName")&(itemName'[searchValue)
		.q:(searchField = "itemCode")&(itemCode'[searchValue)
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
	}
	;w "<br>"_result_"</br>"
	d result.Close()
	;w result
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Others: w ##class(dhc.ca.cache.udata.uInItems).ListRemain(1,"","","","",0,10)
ClassMethod ListRemain(dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q dataTypeDr_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT DataItemCorres_rowid,DataItemCorres_typeDr,DataItemCorres_order,DataItemCorres_itemDr FROM dhc_ca_cache_data.DataItemCorres"
	
	s whereStr=" WHERE %ID>0"
	s whereStr=whereStr_" AND DataItemCorres_typeDr='"_dataTypeDr_"'"
	s whereStr=whereStr_" AND DataItemCorres_itemDr not in(SELECT InItems_itemDr FROM dhc_ca_cache_data.InItems where InItems_itemDr>0)"
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
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
		
		//zjw 20160828 屏蔽修改添加如下
		;i (count>=start)&(count<=end) d
		;.d json.InsertRowData(tmp)
		;s count=count+1
		
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

/// Others: w ##class(dhc.ca.cache.udata.uInItems).ListInItems(1,"",0,25)
ClassMethod ListInItems(parRef, str, start, limit) As %String [ SqlProc ]
{
	n (parRef, str, start, limit)
	
	s sqlStr="SELECT InItems_rowid,InItems_order,InItems_parRef,InItems_itemDr->AllDataItems_shortcut as shortcut FROM dhc_ca_cache_data.InItems"
	
	s whereStr=" WHERE InItems_childSub>0"
	
	s whereStr=whereStr_" AND InItems_parRef='"_parRef_"'"
	i str '="" s whereStr=whereStr_" AND lower(InItems_itemDr->AllDataItems_shortcut) like lower('%"_str_"%') "
	s sortStr=" ORDER BY InItems_childSub ASC"
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^shortcut"
	While(result.Next())
	{
		s rowid=result.Data("InItems_rowid")
		s shortcut=result.Data("shortcut")
		s tmp=rowid_"^"_shortcut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	
	d result.Close()
	
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
