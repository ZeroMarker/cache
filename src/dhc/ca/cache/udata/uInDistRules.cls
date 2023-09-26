/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 收入分配规则
Class dhc.ca.cache.udata.uInDistRules Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.InDistRules
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAINDISTRULE(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.InDistRules
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInDistRules).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAINDISTRULE(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDistRules
/// Input: code-代码;name-名称;flag-业务项ID
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(code, name, flag) As %String
{
	n (code, name, flag)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=0
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	s active="Y"
	s shortcut=code_"-"_name
	s resultStr=0
	TSTART
	&SQL(INSERT INTO dhc_ca_cache_data.InDistRules (InDistRules_code,InDistRules_name,InDistRules_shortcut,InDistRules_flag,InDistRules_active) VALUES (:code,:name,:shortcut,:flag,:active))
	s inDistRulesId=$g(%ROWID)
	s resultStr =##class(dhc.ca.cache.udata.uInDeptTypeRules).InsertRec(inDistRulesId)
	i SQLCODE'=0 s rs=SQLCODE
	i resultStr=0 TCOMMIT
	e  TROLLBACK
	
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InDistRules
/// Input: rowid-数据行号;code-代码;name-名称;flag-业务项ID;active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, code, name, flag, active) As %String
{
	n (rowid, code, name, flag, active)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	s shortcut=code_"-"_name

	&SQL(UPDATE dhc_ca_cache_data.InDistRules SET InDistRules_code=:code,InDistRules_name=:name,InDistRules_shortcut=:shortcut,InDistRules_flag=:flag,InDistRules_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDistRules
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InDistRules_rowid,InDistRules_code,InDistRules_name,InDistRules_shortcut,InDistRules_flag,InDistRules_active FROM dhc_ca_cache_data.InDistRules"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND InDistRules_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDistRules_rowid"
	.i sortField="code" s sortField1="InDistRules_code"
	.i sortField="name" s sortField1="InDistRules_name"
	.i sortField="shortcut" s sortField1="InDistRules_shortcut"
	.i sortField="flag" s sortField1="InDistRules_flag"
	.i sortField="active" s sortField1="InDistRules_active"
	
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
	s jsonTitle="rowid^code^name^shortcut^flag^active"
	
	While(result.Next())
	{
		s rowid=result.Data("InDistRules_rowid")
		s code=result.Data("InDistRules_code")
		s name=result.Data("InDistRules_name")
		s shortcut=result.Data("InDistRules_shortcut")
		s flag=result.Data("InDistRules_flag")
		i flag="Locs" s flag="指定科室"
		i flag="LocType" s flag="科室类别"
		s active=result.Data("InDistRules_active")
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_flag_"^"_active
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="flag")&(flag'[searchValue)
		.q:(searchField="active")&(active'[searchValue)
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
/// Table: dhc.ca.cache.data.InDistRules
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDistRules WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDistRulesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
