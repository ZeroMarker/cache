/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 数据项对应表维护
Class dhc.ca.cache.udata.uDataItemCorres Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDataItemCorres).ListRec("3","","","Rowid","DESC",0,25)
/// 字段排序刷新: w ##class(dhc.ca.cache.udata.uDataItemCorres).ListRec("1","","","order","DESC",0,25)
ClassMethod ListRec(dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q dataTypeDr_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT DataItemCorres_rowid,DataItemCorres_typeDr,DataItemCorres_order,DataItemCorres_itemDr FROM dhc_ca_cache_data.DataItemCorres"
	
	s whereStr=" WHERE %ID>0"
	
	i dataTypeDr'="" d
	s whereStr=whereStr_" AND DataItemCorres_typeDr='"_dataTypeDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="DataItemCorres_rowid"
	.i sortField="typeName" s sortField1="DataItemCorres_typeDr"
	.i sortField="order" s sortField1="DataItemCorres_order"
	.i sortField="itemName" s sortField1="DataItemCorres_itemDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^typeDr^typeName^typeShortCut^order^itemDr^itemCode^itemName^itemShortCut^itemUnit"
	
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
		s itemUnit=""
		i itemDr'="" d
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		.s itemShortCut=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",4)
		.s itemUnit=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",7)
		
		s tmp=rowid_"^"_typeDr_"^"_typeName_"^"_typeShortCut_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemShortCut_"^"_itemUnit
		
		i searchValue'="" d
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="typeName")&(typeName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemShortCut")&(itemShortCut'[searchValue)
		.q:(searchField="itemUnit")&(itemUnit'[searchValue)
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

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: typeDr-数据项类别DR;order-序号;itemDr-数据项DR
/// Output: 
/// Return: 数据项类别为空,返回"EmptyType";数据项为空,返回"EmptyItem";序号为空,返回"EmptyOrder";数据项重复,返回"RepItem";序号重复,返回"RepOrder";执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(typeDr, order, itemDr) As %String
{
	n (typeDr, order, itemDr)
	
	q:typeDr="" "EmptyType"
	q:order="" "EmptyOrder"
	q:itemDr="" "EmptyItem"
	
	s rowid=0
	s rowid=..IfRepItem(typeDr,itemDr)
	q:rowid>0 "RepItem"
	s rowid=..IfRepOrder(typeDr,order)
	q:rowid>0 "RepOrder"
	
	&SQL(INSERT INTO dhc_ca_cache_data.DataItemCorres (DataItemCorres_typeDr,DataItemCorres_order,DataItemCorres_itemDr) VALUES (:typeDr,:order,:itemDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: typeDr-数据项类别DR;order-序号;itemDr-数据项DR
/// Output: 
/// Return: 数据项类别为空,返回"EmptyType";数据项为空,返回"EmptyItem";序号为空,返回"EmptyOrder";数据项重复,返回"RepItem";序号重复,返回"RepOrder";执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRecs(typeDr, items) As %String
{
	n (typeDr, items)
	
	TSTART
	s rs=0
	s length=$l(items,",")
	f i=1:1:length d
	.s itemDr=""
	.s itemDr=$p(items,",",i)
	.&SQL(INSERT INTO dhc_ca_cache_data.DataItemCorres (DataItemCorres_typeDr,DataItemCorres_itemDr) VALUES (:typeDr,:itemDr))
	.i SQLCODE'= 0 s rs =SQLCODE
	i rs=0 d
	.TCOMMIT
	e  d
	.TROLLBACK 
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 数据项是否存在
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: dataTypeDr-数据项类别;dataItemDr-数据项;
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepItem(dataTypeDr, dataItemDr) As %String
{
	n (dataTypeDr,dataItemDr)
	s rowid=0
	s rowid=$o(^DHCCADATAITEMCORRES(0,"TypeItem",dataTypeDr,dataItemDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: order-代码;dataTypeDr-数据项类别;
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:
ClassMethod IfRepOrder(dataTypeDr, order) As %String
{
	n (dataTypeDr,order)
	s rowid=0
	s rowid=$o(^DHCCADATAITEMCORRES(0,"TypeOrder",dataTypeDr,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 更新记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: rowid-数据行号;typeDr-数据项类别DR;order-序号;itemDr-数据项DR
/// Output: 
/// Return: 数据项类别为空,返回"EmptyType";数据项为空,返回"EmptyItem";序号为空,返回"EmptyOrder";数据项重复,返回"RepItem";序号重复,返回"RepOrder";执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, typeDr, order, itemDr) As %String
{
	n (rowid, typeDr, order, itemDr)
	
	q:typeDr="" "EmptyType"
	q:order="" "EmptyOrder"
	q:itemDr="" "EmptyItem"
	
	s tmpRowid=0
	s tmpRowid=..IfRepItem(typeDr,itemDr)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepItem"
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(typeDr,order)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepOrder"

	&SQL(UPDATE dhc_ca_cache_data.DataItemCorres SET DataItemCorres_typeDr=:typeDr,DataItemCorres_order=:order,DataItemCorres_itemDr=:itemDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 删除记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.DataItemCorres WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-12
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数,typeDr-类别ID
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDataItemCorres).ListRemain("","","Rowid","DESC",0,25,"Y",3)
ClassMethod ListRemain(searchField, searchValue, sortField, sortDir, start, limit, active, typeDr)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit, typeDr)
	
	s sqlStr="SELECT AllDataItems_rowid,AllDataItems_unit,AllDataItems_order,AllDataItems_code,AllDataItems_name,AllDataItems_shortcut,AllDataItems_remark,AllDataItems_active FROM dhc_ca_cache_data.AllDataItems"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND AllDataItems_active='"_active_"'"
	s whereStr=whereStr_" AND AllDataItems_rowid  NOT IN (SELECT DataItemCorres_itemDr FROM dhc_ca_cache_data.DataItemCorres  WHERE DataItemCorres_itemDr>0)"   //20140513 zjw 不再显示已添加的数据分类
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="AllDataItems_rowid"
	.i sortField="code" s sortField1="AllDataItems_code"
	.i sortField="name" s sortField1="AllDataItems_name"
	.i sortField="order" s sortField1="AllDataItems_order"
	.i sortField="shortcut" s sortField1="AllDataItems_shortcut"
	.i sortField="remark" s sortField1="AllDataItems_remark"
	.i sortField="active" s sortField1="AllDataItems_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^remark^active^unit"
	
	While(result.Next())
	{
		s rowid=result.Data("AllDataItems_rowid")
		s code=result.Data("AllDataItems_code")
		s name=result.Data("AllDataItems_name")
		s shortcut=result.Data("AllDataItems_shortcut")
		s order=result.Data("AllDataItems_order")
		s remark=result.Data("AllDataItems_remark")
		s active=result.Data("AllDataItems_active")
		s unit=result.Data("AllDataItems_unit")
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_remark_"^"_active_"^"_unit
		s tmpFlag=""
		s tmpFlag=$o(^DHCCADATAITEMCORRES(0,"TypeItem",typeDr,rowid,tmpFlag))
		i tmpFlag="" d
		.i searchValue'="" d
		..i (searchField="active") d
		...i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		...e  s searchValue="N"
		..q:(searchField="order")&(order'[searchValue)
		..q:(searchField="code")&(code'[searchValue)
		..q:(searchField="name")&(name'[searchValue)
		..q:(searchField="shortcut")&(shortcut'[searchValue)
		..q:(searchField="remark")&(remark'[searchValue)
		..q:(searchField="unit")&(unit'[searchValue)
		..q:(searchField="active")&(active'[searchValue)
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

Storage Default
{
<StreamLocation>^dhc.ca.c.uDataItemCorresS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
