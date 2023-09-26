/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 医院码表维护
Class dhc.ca.cache.udata.uHospitals Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.Hospitals
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uHospitals).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAHOSPITALS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.Hospitals
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uHospitals).IfRepName("001")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAHOSPITALS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.Hospitals
/// Input: code-代码,name-名称,remark-备注
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uHospitals).InsertRec("003","测试医院","医院备注")
ClassMethod InsertRec(code, name, remark) As %String
{
	n (code, name, remark)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	s desc=code_"-"_name
	s active="Y"

	&SQL(INSERT INTO dhc_ca_cache_data.Hospitals (Hospitals_code,Hospitals_name,Hospitals_desc,Hospitals_remark,Hospitals_active) VALUES (:code,:name,:desc,:remark,:active))
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 更新记录
/// Table: dhc.ca.cache.data.Hospitals
/// Input: rowid-数据行号,code-代码,name-名称,remark-备注,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uHospitals).UpdateRec(1,"001","测试医院","医院备注","N")
ClassMethod UpdateRec(rowid, code, name, remark, active) As %String
{
	n (rowid, code, name, remark, active)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	
	s desc=code_"-"_name
	
	&SQL(UPDATE dhc_ca_cache_data.Hospitals SET Hospitals_code=:code,Hospitals_name=:name,Hospitals_desc=:desc,Hospitals_remark=:remark,Hospitals_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 删除记录
/// Table: dhc.ca.cache.data.Hospitals
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uHospitals).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.Hospitals WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-12
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.Hospitals
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uHospitals).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT Hospitals_rowid,Hospitals_code,Hospitals_name,Hospitals_desc,Hospitals_remark,Hospitals_active FROM dhc_ca_cache_data.Hospitals"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND Hospitals_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="Rowid" s sortField1="Hospitals_rowid"
	.i sortField="Code" s sortField1="Hospitals_code"
	.i sortField="Name" s sortField1="Hospitals_name"
	.i sortField="Remark" s sortField1="Hospitals_remark"
	.i sortField="Active" s sortField1="Hospitals_active"
	
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
	s jsonTitle="Rowid^Code^Name^Desc^Remark^Active"
	
	While(result.Next())
	{
		s rowId=result.Data("Hospitals_rowid")
		s code=result.Data("Hospitals_code")
		s name=result.Data("Hospitals_name")
		s desc=result.Data("Hospitals_desc")
		s remark=result.Data("Hospitals_remark")
		s active=result.Data("Hospitals_active")
		s tmp=rowId_"^"_code_"^"_name_"^"_desc_"^"_remark_"^"_active
		
		i searchValue'="" d
		.i searchField = "Active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="Code")&(code'[searchValue)
		.q:(searchField = "Name")&(name'[searchValue)
		.q:(searchField = "Desc")&(desc'[searchValue)
		.q:(searchField = "Remark")&(remark'[searchValue)
		.q:(searchField = "Active")&(active'[searchValue)
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
<StreamLocation>^dhc.ca.c.uHospitalsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
