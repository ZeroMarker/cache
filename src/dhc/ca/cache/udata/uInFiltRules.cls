/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 收入过滤规则
Class dhc.ca.cache.udata.uInFiltRules Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.InFiltRules
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAINFILTRULE(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.InFiltRules
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInFiltRules).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAINFILTRULE(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InFiltRules
/// Input: code-代码;name-名称;itemDr-业务项ID
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(code, name, itemDr) As %String
{
	n (code, name, itemDr)
	
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
	&SQL(INSERT INTO dhc_ca_cache_data.InFiltRules (InFiltRules_code,InFiltRules_name,InFiltRules_shortcut,InFiltRules_itemDr,InFiltRules_active) VALUES (:code,:name,:shortcut,:itemDr,:active))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InFiltRules
/// Input: rowid-数据行号;code-代码;name-名称;itemDr-业务项ID;active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, code, name, itemDr, active) As %String
{
	n (rowid, code, name, itemDr, active)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	s shortcut=code_"-"_name

	&SQL(UPDATE dhc_ca_cache_data.InFiltRules SET InFiltRules_code=:code,InFiltRules_name=:name,InFiltRules_shortcut=:shortcut,InFiltRules_itemDr=:itemDr,InFiltRules_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InFiltRules
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InFiltRules_rowid,InFiltRules_code,InFiltRules_name,InFiltRules_shortcut,InFiltRules_itemDr,InFiltRules_active FROM dhc_ca_cache_data.InFiltRules"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND InFiltRules_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InFiltRules_rowid"
	.i sortField="code" s sortField1="InFiltRules_code"
	.i sortField="name" s sortField1="InFiltRules_name"
	.i sortField="shortcut" s sortField1="InFiltRules_shortcut"
	.i sortField="itemName" s sortField1="InFiltRules_itemDr"
	.i sortField="active" s sortField1="InFiltRules_active"
	
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
	s jsonTitle="rowid^code^name^shortcut^itemDr^itemName^active"
	
	While(result.Next())
	{
		s rowid=result.Data("InFiltRules_rowid")
		s code=result.Data("InFiltRules_code")
		s name=result.Data("InFiltRules_name")
		s shortcut=result.Data("InFiltRules_shortcut")
		s itemDr=result.Data("InFiltRules_itemDr")
		s itemName="" 
		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		s active=result.Data("InFiltRules_active")
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_itemDr_"^"_itemName_"^"_active
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="itemName")&(itemName'[searchValue)
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
/// Table: dhc.ca.cache.data.InFiltRules
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InFiltRules WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInFiltRulesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
