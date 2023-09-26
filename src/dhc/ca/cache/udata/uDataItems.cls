/// Creator: 许立新
/// CreatDate: 2009-9-4
/// Description: 数据项码表维护
Class dhc.ca.cache.udata.uDataItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 许立新
/// CreatDate: 2009-9-4
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.DataItems
/// Input: type-类别,code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).IfRepCode(1,"1001")
ClassMethod IfRepCode(type, code) As %String
{
	n (type, code)
	s rowid=0
	s rowid=$o(^DHCCADATAITEMS(0,"TypeCode",type,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-9-4
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.DataItems
/// Input: type-类别,name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).IfRepName(1,"工资费用")
ClassMethod IfRepName(type, name) As %String
{
	n (type, name)
	s rowid=0
	s rowid=$o(^DHCCADATAITEMS(0,"TypeName",type,name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-9-4
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.DataItems
/// Input: code-代码,name-名称,price-单价,type-数据类别
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";类别为空,返回"EmptyType";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).InsertRec("003","测试医院",12,2)
ClassMethod InsertRec(code, name, price, type) As %String
{
	n (code, name, price, type)
	
	q:type="" "EmptyType"
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(type,code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(type,name)
	q:rowid>0 "RepName"
	
	i price="" s price=0
	s desc=code_"-"_name
	s active="Y"
	
	&SQL(INSERT INTO dhc_ca_cache_data.DataItems (DataItems_code,DataItems_name,DataItems_desc,DataItems_price,DataItems_dataTypeDr,DataItems_active) VALUES (:code,:name,:desc,:price,:type,:active))
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-9-5
/// Description: 更新记录
/// Table: dhc.ca.cache.data.DataItems
/// Input: rowid-数据行号,code-代码,name-名称,price-单价,type-数据类别,active-有效标志
/// Output:
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";类别为空,返回"EmptyType";执行SQL语句返回SQLCODE 
/// Others：w ##class(dhc.ca.cache.udata.uDataItems).UpdateRec(5,"003","测试医院",10,5,"Y")
ClassMethod UpdateRec(rowid, code, name, price, type, active) As %String
{
	n (rowid, code, name, price, type, active)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	q:type="" "EmptyType"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(type,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(type,name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	
	i price="" s price=0
	s desc=code_"-"_name
	
	&SQL(UPDATE dhc_ca_cache_data.DataItems SET DataItems_code=:code,DataItems_name=:name,DataItems_desc=:desc,DataItems_price=:price,DataItems_dataTypeDr=:type,DataItems_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-9-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.DataItems
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.DataItems WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-9-5
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataItems
/// Input: type-数据类别,active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).ListRec(1,"Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(type, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (type, active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT DataItems_rowid,DataItems_code,DataItems_name,DataItems_desc,DataItems_price,DataItems_dataTypeDr,DataItems_active FROM dhc_ca_cache_data.DataItems"
	
	s whereStr=" WHERE %ID>0 AND DataItems_dataTypeDr="_type
	i (active="Y")||(active="N") s whereStr=whereStr_" AND DataItems_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="Rowid" s sortField1="DataItems_rowid"
	.i sortField="Code" s sortField1="DataItems_code"
	.i sortField="Name" s sortField1="DataItems_name"
	.i sortField="Price" s sortField1="DataItems_price"
	.i sortField="Active" s sortField1="DataItems_active"
	
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
	s jsonTitle="Rowid^Code^Name^Desc^Price^Type^Active"
	
	While(result.Next())
	{
		s rowId=result.Data("DataItems_rowid")
		s code=result.Data("DataItems_code")
		s name=result.Data("DataItems_name")
		s desc=result.Data("DataItems_desc")
		s price=result.Data("DataItems_price")
		s dataTypeDr=result.Data("DataItems_dataTypeDr")
		s active=result.Data("DataItems_active")
		s tmp=rowId_"^"_code_"^"_name_"^"_desc_"^"_price_"^"_dataTypeDr_"^"_active
		
		i searchValue'="" d
		.i searchField="Active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="Code")&(code'[searchValue)
		.q:(searchField="Name")&(name'[searchValue)
		.q:(searchField="Desc")&(desc'[searchValue)
		.q:(searchField="Price")&(price'=searchValue)
		.q:(searchField="Active")&(active'[searchValue)
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
<StreamLocation>^dhc.ca.c.uDataItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
