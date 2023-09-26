/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 不包含成本项码表维护
Class dhc.ca.cache.udata.uOutCostItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uOutCostItems).CheckCostDepts("1||11")
ClassMethod CheckCostDepts(parRef) As %String
{
	n (parRef)
	s rowid=0
	s rs="empty"
	s rowid=$o(^DHCCACOSTDISTSETS($p(parRef,"||",1),"CDM",$p(parRef,"||",2),"InCostItem",rowid))
	i rowid'="" d  s rs="in"
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS($p(parRef,"||",1),"CDM",$p(parRef,"||",2),"OutCostItem",rowid))
	i rowid'="" d  s rs="out"
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.OutCostItems
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uOutCostItems).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(parRef, itemDr) As %String
{
	n (parRef, itemDr)
	
	&SQL(INSERT INTO dhc_ca_cache_data.OutCostItems (OutCostItems_parRef,OutCostItems_itemDr) VALUES (:parRef, :itemDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 更新记录
/// Table: dhc.ca.cache.data.OutCostItems
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uOutCostItems).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, itemDr) As %String
{
	n (rowid, itemDr)

	&SQL(UPDATE dhc_ca_cache_data.OutCostItems SET OutCostItems_itemDr=:itemDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OutCostItems
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutCostItems).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT OutCostItems_rowid,OutCostItems_itemDr FROM dhc_ca_cache_data.OutCostItems"
	
	s whereStr=" WHERE OutCostItems_childSub>0"
	i parRef'="" s whereStr=whereStr_" and OutCostItems_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutCostItems_rowid"
	.i sortField="itemCode" s sortField1="OutCostItems_itemDr"
	.i sortField="itemName" s sortField1="OutCostItems_itemDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^itemDr^itemCode^itemName"
	
	While(result.Next())
	{
		s rowid=result.Data("OutCostItems_rowid")
		s itemDr=result.Data("OutCostItems_itemDr")
		s itemName=""
		s itemCode=""
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)

		s tmp=rowid_"^"_itemDr_"^"_itemCode_"^"_itemName
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
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

/// Creator：杨旭
/// CreatDate：2009-12-23
/// Description: 删除记录
/// Table：dhc.ca.cache.data.CostDistMethods
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.OutCostItems WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-28
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OutCostItems
/// Input: parRef-方法套ID, itemDr-项目ID
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutCostItems).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod checkExist(parRef, itemDr)
{
	n (parRef,itemDr)
	
	s sqlStr="SELECT OutCostItems_rowid,OutCostItems_itemDr FROM dhc_ca_cache_data.OutCostItems"
	
	s whereStr=" WHERE OutCostItems_childSub>0"
	i parRef'="" s whereStr=whereStr_" and OutCostItems_parRef='"_parRef_"'"
	i itemDr'="" s whereStr=whereStr_" and OutCostItems_itemDr='"_itemDr_"'"
	s rs=0
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()

	
	While(result.Next())
	{
		s rs=1
	}
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-14
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItemCorres
/// Input: parRef-方法套ID, dataTypeDr-业务类别ID, searchField-查询对象, searchValue-查询内容, sortField-排序字段, sortDir-顺序, start-起始行号, limit-数量
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others:
ClassMethod ListItems(parRef, dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, dataTypeDr, searchField, searchValue, sortField, sortDir, start, limit)
	
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
	s end=start+limit
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^typeDr^typeName^typeShortCut^order^itemDr^itemCode^itemName^itemShortCut^itemFlag"
	
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
		.s itemFlag=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",6)
		
		s tmpRs=0
		s tmpRs= ..checkExist(parRef, itemDr)
		
		s tmp=rowid_"^"_typeDr_"^"_typeName_"^"_typeShortCut_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemShortCut_"^"_itemFlag
		
		i searchValue'="" d
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="typeName")&(typeName'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
		.q:(searchField="itemShortCut")&(itemShortCut'[searchValue)
		.q:(searchField="itemUnit")&(itemUnit'[searchValue)
		.i (count>=start)&(count<=end)&(tmpRs=0)&(itemFlag="Y") d
		..d json.InsertRowData(tmp)
		..s count=count+1
		e  d
		.i (count>=start)&(count<=end)&(tmpRs=0)&(itemFlag="Y") d
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
<StreamLocation>^dhc.ca.c.uOutCostItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
