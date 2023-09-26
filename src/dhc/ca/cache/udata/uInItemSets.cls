/// Creator: 王赢赢
/// CreatDate: 2009-10-23
/// Description: 单位类别
Class dhc.ca.cache.udata.uInItemSets Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-10-23
/// Description: 序号是否存在
/// Table：dhc.ca.cache.data.InItemSets
/// Input: order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uInItemSets).IfRepOrder("1")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCAINITEMSETS(0,"SetOrder",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-23
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.InItemSets
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uInItemSets).IfRepCode("1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAINITEMSETS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-23
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.InItemSets
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInItemSets).IfRepName("ss")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAINITEMSETS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-10-23
/// Description: 插入一条新单位类别数据
/// Table：dhc.ca.cache.data.InItemSets
/// Input：code-代码;name-名称;remark-备注;flag-标志;active-有效;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInItemSets).InsertRec(1,1,"name","remark","")
ClassMethod InsertRec(order, code, name, remark, active) As %String
{
	
	n (order, code, name, remark, active)
	
	s rowid=0
	s rowid=..IfRepOrder(order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	s shortcut =code_"-"_name
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.InItemSets (InItemSets_order,InItemSets_code,InItemSets_name,InItemSets_shortcut,InItemSets_remark,InItemSets_active) values(:order,:code,:name,:shortcut,:remark,:active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-23
/// Description: 更新记录
/// Table：dhc.ca.cache.data.InItemSets
/// Input：rowId-所在行号;code-代码;name-名称;remark-备注;flag-标志;active-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInItemSets).UpdateRec(2,2,2,"name2","remark2","N")
ClassMethod UpdateRec(rowId, order, code, name, remark, active) As %String
{
	
	n (rowId, order, code, name, remark, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(order)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepOrder"
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	
	&sql(update dhc_ca_cache_data.InItemSets set InItemSets_order=:order,InItemSets_code=:code,InItemSets_name=:name,InItemSets_shortcut=:shortcut,InItemSets_remark=:remark,InItemSets_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-23
/// Description: 删除记录
/// Table：dhc.ca.cache.data.InItemSets
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInItemSets).DelRec(3)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InItemSets WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-10-23
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.InItemSets
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// 刷新接口项目套码表:w ##class(dhc.ca.cache.udata.uInItemSets).ListRec("","","","order","DESC",0,25)
/// Others: w ##class(dhc.ca.cache.udata.uInItemSets).ListRec("Y","shortcut","","","",0,10)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InItemSets_rowid,InItemSets_order,InItemSets_code,InItemSets_name,InItemSets_shortcut,InItemSets_remark,InItemSets_active FROM dhc_ca_cache_data.InItemSets"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND InItemSets_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="InItemSets_rowid"
	.i sortField="order" s sortField1="InItemSets_order"
	.i sortField="code" s sortField1="InItemSets_code"
	.i sortField="name" s sortField1="InItemSets_name"
	.i sortField="shortcut" s sortField1="InItemSets_shortcut"
	.i sortField="remark" s sortField1="InItemSets_remark"
	.i sortField="active" s sortField1="InItemSets_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InItemSets_order DESC"
	//q sortStr
	s sqlStr=sqlStr_whereStr_sortStr
	//q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^order^code^name^shortcut^remark^active"
	
	While(result.Next())
	{
		s rowId=result.Data("InItemSets_rowid")
		s order=result.Data("InItemSets_order")
		s code=result.Data("InItemSets_code")
		s name=result.Data("InItemSets_name")
		s shortcut=result.Data("InItemSets_shortcut")
		s remark=result.Data("InItemSets_remark")
		s active=result.Data("InItemSets_active")
		s tmp=rowId_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_remark_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
		.q:(searchField = "active")&(active'[searchValue)
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
<StreamLocation>^dhc.ca.c.uInItemSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
