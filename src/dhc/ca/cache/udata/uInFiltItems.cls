/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 过滤项目
Class dhc.ca.cache.udata.uInFiltItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InFiltItems
/// Input: parRef-收入过滤规则ID; itemDr-业务项ID;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(parRef, itemDr) As %String
{
	n (parRef, itemDr)
	
	&SQL(INSERT INTO dhc_ca_cache_data.InFiltItems (InFiltItems_parRef,InFiltItems_Dr) VALUES (:parRef,:itemDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InFiltItems
/// Input: rowid-数据行号;itemDr-业务项ID;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, itemDr) As %String
{
	n (rowid, itemDr)

	&SQL(UPDATE dhc_ca_cache_data.InFiltItems SET InFiltItems_Dr=:itemDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InFiltItems
/// Input: parRef-收入过滤规则ID,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInFiltItems).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InFiltItems_rowid,InFiltItems_Dr FROM dhc_ca_cache_data.InFiltItems"
	
	s whereStr=" WHERE InFiltItems_childSub>0"
	i parRef'="" s whereStr=whereStr_" AND InFiltItems_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InFiltItems_rowid"
	.i sortField="itemName" s sortField1="InFiltItems_Dr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^itemDr^itemCode^itemName"
	
	While(result.Next())
	{
		s rowid=result.Data("InFiltItems_rowid")
		s itemDr=result.Data("InFiltItems_Dr")
		s itemName="" 
		s itemCode=""
		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		..s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
	
		s tmp=rowid_"^"_itemDr_"^"_itemCode_"^"_itemName
		
		i searchValue'="" d
		.q:(searchField="itemName")&(itemName'[searchValue)
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
/// CreatDate: 2010-03-10
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InFiltItems
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InFiltItems WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: parRef-收入过滤规则ID,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数,dataTypeDr-业务类别
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others:
ClassMethod GetItems(parRef, dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
	q:parRef="" ""
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
	.s sortStr=" ORDER BY %ID DESC"
	
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
		s tmpFiltItemDr=""
		s tmpFiltItemDr=$o(^DHCCAINFILTRULE(0,"Item",parRef,itemDr,""))
		s tmp=rowid_"^"_typeDr_"^"_typeName_"^"_typeShortCut_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemShortCut_"^"_itemUnit
		
		i searchValue'="" d
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="typeName")&(typeName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="itemCode")&(itemCode'[searchValue)
		.q:(searchField="itemShortCut")&(itemShortCut'[searchValue)
		.q:(searchField="itemUnit")&(itemUnit'[searchValue)
		.i (count>=start)&(count<=end)&(tmpFiltItemDr="") d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
		.i (count>=start)&(count<=end)&(tmpFiltItemDr="") d
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
<StreamLocation>^dhc.ca.c.uInFiltItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
