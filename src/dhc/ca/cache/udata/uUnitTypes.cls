/// Creator: 王赢赢
/// CreatDate: 2009-9-23
/// Description: 单位类别
Class dhc.ca.cache.udata.uUnitTypes Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-9-23
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.UnitTypes
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uUnitTypes).IfRepCode("1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAUNITTYPES(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-23
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.UnitTypes
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uUnitTypes).IfRepName("ss")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAUNITTYPES(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-9-23
/// Description: 插入一条新单位类别数据
/// Table：dhc.ca.cache.data.UnitTypes
/// Input：code-代码;name-名称;remark-备注;flag-标志;active-有效;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitTypes).InsertRec(1,"aaa","bbb","","")
ClassMethod InsertRec(code, name, remark, flag, active) As %String
{
	
	n (code, name, remark, flag, active)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	s shortcut =code_"-"_name
	i (flag'="Y")||(flag'="N") s flag="N"
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.UnitTypes (UnitTypes_code,UnitTypes_name,UnitTypes_shortcut,UnitTypes_remark,UnitTypes_flag,UnitTypes_active) values(:code,:name,:shortcut,:remark,:flag,:active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-9-23
/// Description: 更新记录
/// Table：dhc.ca.cache.data.UnitTypes
/// Input：rowId-所在行号;code-代码;name-名称;remark-备注;flag-标志;active-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitTypes).UpdateRec(1,2,"name","remark","N","N")
ClassMethod UpdateRec(rowId, code, name, remark, flag, active) As %String
{
	
	n (rowId, code, name, remark, flag, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	
	&sql(update dhc_ca_cache_data.UnitTypes set UnitTypes_code=:code,UnitTypes_name=:name,UnitTypes_shortcut=:shortcut,UnitTypes_remark=:remark,UnitTypes_flag=:flag,UnitTypes_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-23
/// Description: 删除记录
/// Table：dhc.ca.cache.data.UnitTypes
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uUnitTypes).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.UnitTypes WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-23
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitTypes
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// 医院：w ##class(dhc.ca.cache.udata.uUnitTypes).ListRec("Y","shortcut","","Rowid","DESC",0,10)
/// Others: w ##class(dhc.ca.cache.udata.uUnitTypes).ListRec("","","","rowId","DESC",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT UnitTypes_rowid,UnitTypes_code,UnitTypes_name,UnitTypes_shortcut,UnitTypes_remark,UnitTypes_flag,UnitTypes_active FROM dhc_ca_cache_data.UnitTypes"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitTypes_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="UnitTypes_rowid"
	.i sortField="code" s sortField1="UnitTypes_code"
	.i sortField="name" s sortField1="UnitTypes_name"
	.i sortField="shortcut" s sortField1="UnitTypes_shortcut"
	.i sortField="remark" s sortField1="UnitTypes_remark"
	.i sortField="flag" s sortField1="UnitTypes_flag"
	.i sortField="active" s sortField1="UnitTypes_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^code^name^shortcut^remark^flag^active"
	
	While(result.Next())
	{
		s rowId=result.Data("UnitTypes_rowid")
		s code=result.Data("UnitTypes_code")
		s name=result.Data("UnitTypes_name")
		s shortcut=result.Data("UnitTypes_shortcut")
		s remark=result.Data("UnitTypes_remark")
		s flag=result.Data("UnitTypes_flag")
		s active=result.Data("UnitTypes_active")
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_remark_"^"_flag_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
		.q:(searchField = "flag")&(flag'[searchValue)
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
<StreamLocation>^dhc.ca.c.uUnitTypesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
