/// Creator: 王赢赢
/// CreatDate: 2009-11-9
/// Description: 数据导入规则表
Class dhc.ca.cache.udata.uLoadRules Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-11-9
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.LoadRules
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uLoadRules).IfRepOrder("ss")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCALOADRULES(0,"Order",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-9
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.LoadRules
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uLoadRules).IfRepCode("1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCALOADRULES(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-9
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.LoadRules
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uLoadRules).IfRepName("ss")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCALOADRULES(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-11-9
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.LoadRules
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uLoadRules).InsertRec(1,1,"name1",1,1,1)
ClassMethod InsertRec(order, code, name, deptSetDr, itemSetDr, itemTypeDr) As %String
{
	
	n (order, code, name, deptSetDr, itemSetDr, itemTypeDr)
	
	s rowid=0
	s rowid=..IfRepOrder(order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	&sql(insert into dhc_ca_cache_data.LoadRules (LoadRules_order,LoadRules_code,LoadRules_name,LoadRules_deptSetDr,LoadRules_itemSetDr,LoadRules_itemTypeDr) values(:order, :code, :name, :deptSetDr, :itemSetDr, :itemTypeDr))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-11-9
/// Description: 更新记录
/// Table：dhc.ca.cache.data.LoadRules
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uLoadRules).UpdateRec(2,2,2,"name2",2,2,2)
ClassMethod UpdateRec(rowId, order, code, name, deptSetDr, itemSetDr, itemTypeDr) As %String
{
	
	n (rowId, order, code, name, deptSetDr, itemSetDr, itemTypeDr)
	
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(order)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepOrder"
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
		
	&sql(update dhc_ca_cache_data.LoadRules set LoadRules_order=:order,LoadRules_code=:code,LoadRules_name=:name,LoadRules_deptSetDr=:deptSetDr,LoadRules_itemSetDr=:itemSetDr,LoadRules_itemTypeDr=:itemTypeDr where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-9
/// Description: 删除记录
/// Table：dhc.ca.cache.data.LoadRules
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uLoadRules).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.LoadRules WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-9
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.LoadRules
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uLoadRules).ListRec("","","Rowid","",0,10)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT LoadRules_rowid,LoadRules_order,LoadRules_code,LoadRules_name,LoadRules_deptSetDr,LoadRules_itemSetDr,LoadRules_itemTypeDr FROM dhc_ca_cache_data.LoadRules"
	
	s whereStr=" WHERE %ID>0"
		
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="order" s sortField1="LoadRules_order"
	.i sortField="code" s sortField1="LoadRules_code"
	.i sortField="name" s sortField1="LoadRules_name"
	.i sortField="deptSetName" s sortField1="LoadRules_itemSetDr"
	.i sortField="itemTypeName" s sortField1="LoadRules_itemTypeDr"
	.i sortField="deptSetName" s sortField1="LoadRules_deptSetDr"
		
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY LoadRules_order DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^order^code^name^deptSetDr^itemSetDr^itemTypeDr^deptSetName^itemSetName^itemTypeName"
	
	While(result.Next())
	{
		s rowId = result.Data("LoadRules_rowid")
		s order = result.Data("LoadRules_order")
		s code = result.Data("LoadRules_code")
		s name = result.Data("LoadRules_name")
		s deptSetDr = result.Data("LoadRules_deptSetDr")
		s itemSetDr = result.Data("LoadRules_itemSetDr")
		s itemTypeDr = result.Data("LoadRules_itemTypeDr")
		
		s deptSetName = $p(^DHCCAINDEPTSETS(deptSetDr),"^",3)
		i itemSetDr'="" d
		.s itemSetName = $p(^DHCCAINITEMSETS(itemSetDr),"^",3)
		e  d
		.s itemSetName = ""
		i itemTypeDr'="" d
		.s itemTypeName = $p(^DHCCADATAITEMTYPES(itemTypeDr),"^",3)
		e  d
		.s itemTypeName = ""
				
		s tmp=rowId_"^"_order_"^"_code_"^"_name_"^"_deptSetDr_"^"_itemSetDr_"^"_itemTypeDr_"^"_deptSetName_"^"_itemSetName_"^"_itemTypeName
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "deptSetName")&(deptSetName'[searchValue)
		.q:(searchField = "itemSetName")&(itemSetName'[searchValue)
		.q:(searchField = "itemTypeName")&(itemTypeName'[searchValue)
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
<StreamLocation>^dhc.ca.c.uLoadRulesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
