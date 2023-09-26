/// Creator: 王赢赢
/// CreatDate: 2009-12-9
/// Description: 单位
Class dhc.ca.cache.udata.uAccPeriod Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-12-9
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.AccPeriod
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uAccPeriod).IfRepCode("1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAACCPERIOD(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-9
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.AccPeriod
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uAccPeriod).IfRepName("ss")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAACCPERIOD(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-12-9
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.AccPeriod
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uAccPeriod).InsertRec(1,"name1","")
ClassMethod InsertRec(code, name, active) As %String
{
	
	n (code, name, active)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	s shortcut =code_"-"_name
	
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.AccPeriod (AccPeriod_code,AccPeriod_name,AccPeriod_shortcut,AccPeriod_active) values(:code, :name, :shortcut, :active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-12-9
/// Description: 更新记录
/// Table：dhc.ca.cache.data.AccPeriod
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uAccPeriod).UpdateRec(1,4,"name4","N")
ClassMethod UpdateRec(rowId, code, name, active) As %String
{
	
	n (rowId, code, name, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	
	&sql(update dhc_ca_cache_data.AccPeriod set AccPeriod_code=:code,AccPeriod_name=:name,AccPeriod_shortcut=:shortcut,AccPeriod_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-9
/// Description: 删除记录
/// Table：dhc.ca.cache.data.AccPeriod
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uAccPeriod).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.AccPeriod WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-12-9
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.AccPeriod
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uAccPeriod).ListRec("","","","rowId","DESC",0,25)
ClassMethod ListRec(active, searchField, searchValue, sortField, sortDir, start, limit)
{
   ;q active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT AccPeriod_rowid,AccPeriod_code,AccPeriod_name,AccPeriod_shortcut,AccPeriod_active FROM dhc_ca_cache_data.AccPeriod"
	
	s whereStr=" WHERE AccPeriod_rowid>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND AccPeriod_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="code" s sortField1="AccPeriod_code"
	.i sortField="name" s sortField1="AccPeriod_name"
	.i sortField="active" s sortField1="AccPeriod_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY AccPeriod_rowid DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^code^name^shortcut^active"
	
	While(result.Next())
	{
		s rowId = result.Data("AccPeriod_rowid")
		s code = result.Data("AccPeriod_code")
		s name = result.Data("AccPeriod_name")
		s shortcut = result.Data("AccPeriod_shortcut")
		s active = result.Data("AccPeriod_active")
		
		
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
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
<StreamLocation>^dhc.ca.c.uAccPeriodS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
