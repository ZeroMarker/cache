/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 单位
Class dhc.ca.cache.udata.uRoles Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.Roles
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRoles).IfRepOrder("ss")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"Order",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.Roles
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uRoles).IfRepCode("1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.Roles
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRoles).IfRepName("ss")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-11-4
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.Roles
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRoles).InsertRec(1,1,"name1",1,"page1","remark1","")
ClassMethod InsertRec(order, code, name, deptDr, page, remark, active) As %String
{
	
	n (order, code, name, deptDr, page, remark, active)
	
	s rowid=0
	s rowid=..IfRepOrder(order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	s shortcut =code_"-"_name
	
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.Roles (Roles_order,Roles_code,Roles_name,Roles_shortcut,Roles_deptDr,Roles_page,Roles_remark,Roles_active) values(:order, :code, :name, :shortcut, :deptDr, :page, :remark, :active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-11-4
/// Description: 更新记录
/// Table：dhc.ca.cache.data.Roles
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRoles).UpdateRec(4,4,4,"name4",4,"page4","remark4","N")
ClassMethod UpdateRec(rowId, order, code, name, deptDr, page, remark, active) As %String
{
	
	n (rowId, order, code, name, deptDr, page, remark, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(order)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepOrder"
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	
	&sql(update dhc_ca_cache_data.Roles set Roles_order=:order,Roles_code=:code,Roles_name=:name,Roles_shortcut=:shortcut,Roles_deptDr=:deptDr,Roles_page=:page,Roles_remark=:remark,Roles_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 删除记录
/// Table：dhc.ca.cache.data.Roles
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uRoles).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.Roles WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.Roles
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uRoles).ListRec("","","","order","ASC",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT Roles_rowid,Roles_order,Roles_code,Roles_name,Roles_shortcut,Roles_deptDr,Roles_page,Roles_remark,Roles_active FROM dhc_ca_cache_data.Roles"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND Roles_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="order" s sortField1="Roles_order"
	.i sortField="code" s sortField1="Roles_code"
	.i sortField="name" s sortField1="Roles_name"
	.i sortField="page" s sortField1="Roles_page"
	.i sortField="remark" s sortField1="Roles_remark"
	.i sortField="active" s sortField1="Roles_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY Roles_order DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^order^code^name^shortcut^deptDr^page^remark^active^deptName"
	
	While(result.Next())
	{
		s rowId = result.Data("Roles_rowid")
		s order = result.Data("Roles_order")
		s code = result.Data("Roles_code")
		s name = result.Data("Roles_name")
		s shortcut = result.Data("Roles_shortcut")
		s deptDr = result.Data("Roles_deptDr")
		s page = result.Data("Roles_page")
		s remark = result.Data("Roles_remark")
		s active = result.Data("Roles_active")
		
		s deptName = $p(^DHCCAUNITDEPTS(deptDr),"^",2)
		
		s tmp=rowId_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_deptDr_"^"_page_"^"_remark_"^"_active_"^"_deptName
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "page")&(page'[searchValue)
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
<StreamLocation>^dhc.ca.c.uRolesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
