/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uAllDataItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uAllDataItems).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAALLDATAITEMS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uAllDataItems).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAALLDATAITEMS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uAllDataItems).IfRepName("工资费用")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCAALLDATAITEMS(0,"Order",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uAllDataItems).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(order, code, name, remark, unit) As %String
{
	n (order, code, name, remark, unit)
	
	q:order="" "EmptyOrder"
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=0
	s rowid=..IfRepOrder(order)
	q:rowid>0 "RepOrder"
	s active="Y"
	s shortcut=code_"-"_name
	&SQL(INSERT INTO dhc_ca_cache_data.AllDataItems (AllDataItems_order,AllDataItems_code,AllDataItems_name,AllDataItems_shortcut,AllDataItems_remark,AllDataItems_active,AllDataItems_unit) VALUES (:order,:code,:name,:shortcut,:remark,:active,:unit))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 更新记录
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uAllDataItems).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, order, code, name, remark, active, unit) As %String
{
	n (rowid, order, code, name, remark, active, unit)
	
	q:order="" "EmptyOrder"
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(order)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepOrder"
	s shortcut=code_"-"_name

	&SQL(UPDATE dhc_ca_cache_data.AllDataItems SET AllDataItems_order=:order,AllDataItems_code=:code,AllDataItems_name=:name,AllDataItems_shortcut=:shortcut,AllDataItems_remark=:remark,AllDataItems_active=:active,AllDataItems_unit=:unit WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uAllDataItems).ListRec("Y","sear","a","sort","sss",0,25)
/// 字段排序刷新：w ##class(dhc.ca.cache.udata.uAllDataItems).ListRec("","","order","ASC","0",25,"")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
 
    ;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_active
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT AllDataItems_rowid,AllDataItems_unit,AllDataItems_order,AllDataItems_code,AllDataItems_name,AllDataItems_shortcut,AllDataItems_remark,AllDataItems_active FROM dhc_ca_cache_data.AllDataItems"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND AllDataItems_active='"_active_"'"
	
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
	.i sortField="unit" s sortField1="AllDataItems_unit"
	
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
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="active")&(active'[searchValue)
		.q:(searchField="unit")&(unit'[searchValue)
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
/// CreatDate: 2009-10-13
/// Description: 删除记录
/// Table: dhc.ca.cache.data.AllDataItems
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.AllDataItems WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uAllDataItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
