/// Creator: 许立新
/// CreatDate: 2009-8-26
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uDataTypes Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 许立新
/// CreatDate: 2009-8-26
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.DataTypes
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCADATATYPES(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-8-26
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.DataTypes
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCADATATYPES(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-8-26
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.DataTypes
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(code, name, in, out, param) As %String
{
	n (code, name, in, out, param)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	q:(in="Y")&&(out="Y") "InOut"
	s desc=code_"-"_name
	s active="Y"
	&SQL(INSERT INTO dhc_ca_cache_data.DataTypes (DataTypes_code,DataTypes_name,DataTypes_desc,DataTypes_inFlag,DataTypes_outFlag,DataTypes_paramFlag,DataTypes_active) VALUES (:code,:name,:desc,:in,:out,:param,:active))
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-26
/// Description: 更新记录
/// Table: dhc.ca.cache.data.DataTypes
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uDataTypes).UpdateRec(5,"003","测试医院","Y","Y","Y","N")
ClassMethod UpdateRec(rowid, code, name, in, out, param, active) As %String
{
	n (rowid, code, name, in, out, param, active)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	q:(in="Y")&&(out="Y") "InOut"
	s desc=code_"-"_name
	&SQL(UPDATE dhc_ca_cache_data.DataTypes SET DataTypes_code=:code,DataTypes_name=:name,DataTypes_desc=:desc,DataTypes_inFlag=:in,DataTypes_outFlag=:out,DataTypes_paramFlag=:param,DataTypes_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-26
/// Description: 删除记录
/// Table: dhc.ca.cache.data.DataTypes
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.DataTypes WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-27
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.DataTypes
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uDataTypes).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT DataTypes_rowid,DataTypes_code,DataTypes_name,DataTypes_desc,DataTypes_inFlag,DataTypes_outFlag,DataTypes_paramFlag,DataTypes_active FROM dhc_ca_cache_data.DataTypes"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND DataTypes_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="Rowid" s sortField1="DataTypes_rowid"
	.i sortField="Code" s sortField1="DataTypes_code"
	.i sortField="Name" s sortField1="DataTypes_name"
	.i sortField="In" s sortField1="DataTypes_inFlag"
	.i sortField="Out" s sortField1="DataTypes_outFlag"
	.i sortField="Param" s sortField1="DataTypes_paramFlag"
	.i sortField="Active" s sortField1="DataTypes_active"
	
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
	s jsonTitle="Rowid^Code^Name^Desc^In^Out^Param^Active"
	
	While(result.Next())
	{
		s rowId=result.Data("DataTypes_rowid")
		s code=result.Data("DataTypes_code")
		s name=result.Data("DataTypes_name")
		s desc=result.Data("DataTypes_desc")
		s in=result.Data("DataTypes_inFlag")
		s out=result.Data("DataTypes_outFlag")
		s param=result.Data("DataTypes_paramFlag")
		s active=result.Data("DataTypes_active")
		s tmp=rowId_"^"_code_"^"_name_"^"_desc_"^"_in_"^"_out_"^"_param_"^"_active
		
		i searchValue'="" d
		.i (searchField="In")||(searchField="Out")||(searchField="Param")||(searchField="Active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="Code")&(code'[searchValue)
		.q:(searchField="Name")&(name'[searchValue)
		.q:(searchField="Desc")&(desc'[searchValue)
		.q:(searchField="In")&(in'[searchValue)
		.q:(searchField="Out")&(out'[searchValue)
		.q:(searchField="Param")&(param'[searchValue)
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
<StreamLocation>^dhc.ca.c.uDataTypesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
