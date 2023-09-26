/// Creator: 杨旭
/// CreatDate: 2010-04-08
/// Description: 收入数据梳理
Class dhc.ca.cache.udata.uInDataCarding Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-04-08
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDataCarding
/// Input: searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInDataCarding).ListRec("","","","",0,10)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InDataCarding_rowid,InDataCarding_priority,InDataCarding_code,InDataCarding_name,InDataCarding_shortcut,InDataCarding_remark,InDataCarding_Active FROM dhc_ca_cache_data.InDataCarding"
	
	s whereStr=" WHERE %ID>0"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDataCarding_rowid"
	.i sortField="code" s sortField1="InDataCarding_code"
	.i sortField="name" s sortField1="InDataCarding_name"
	.i sortField="priority" s sortField1="InDataCarding_priority"
	.i sortField="shortcut" s sortField1="InDataCarding_shortcut"
	.i sortField="remark" s sortField1="InDataCarding_remark"
	.i sortField="active" s sortField1="InDataCarding_Active"
	
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
	s jsonTitle="rowid^priority^code^name^shortcut^remark^active"
	
	While(result.Next())
	{
		s rowid=result.Data("InDataCarding_rowid")
		s code=result.Data("InDataCarding_code")
		s name=result.Data("InDataCarding_name")
		s shortcut=result.Data("InDataCarding_shortcut")
		s priority=result.Data("InDataCarding_priority")
		s remark=result.Data("InDataCarding_remark")
		s active=result.Data("InDataCarding_Active")
	
		s tmp=rowid_"^"_priority_"^"_code_"^"_name_"^"_shortcut_"^"_remark_"^"_active
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="priority")&(priority'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
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
/// CreatDate: 2010-04-08
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDataCarding
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInDataCarding).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(priority, code, name, remark) As %String
{
	n (priority, code, name, remark)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepPriority(priority)
	q:rowid>0 "RepPriority"
	
	s shortcut=""
	s shortcut=code_"-"_name
	&SQL(INSERT INTO dhc_ca_cache_data.InDataCarding (InDataCarding_priority,InDataCarding_code,InDataCarding_name,InDataCarding_shortcut,InDataCarding_remark,InDataCarding_Active) VALUES (:priority,:code,:name,:shortcut,:remark,"Y"))
	
	q SQLCODE
}

/// Creator: zjw
/// CreatDate: 2016-01-20
/// Description: 代码是否存在
/// Table:dhc.ca.cache.data.InDataCarding
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uInDataCarding).IfRepCode("1")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAINDATACARDING(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: zjw
/// CreatDate: 2016-01-20
/// Description: 优先级是否存在
/// Table:dhc.ca.cache.data.InDataCarding
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uInDataCarding).IfRepPriority("1")
ClassMethod IfRepPriority(priority) As %String
{
	n (priority)
	s rowid=0
	s rowid=$o(^DHCCAINDATACARDING(0,"Pri",priority,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-04-08
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InDataCarding
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInDataCarding).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, priority, code, name, remark, active) As %String
{
	n (rowid, priority, code, name, remark,active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid>0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=..IfRepPriority(priority)
	q:(tmpRowid>0)&(tmpRowid'=rowid) "RepPriority"
	s shortcut=""
	s shortcut=code_"-"_name
	&SQL(UPDATE dhc_ca_cache_data.InDataCarding SET InDataCarding_priority=:priority,InDataCarding_code=:code,InDataCarding_name=:name,InDataCarding_shortcut=:shortcut,InDataCarding_remark=:remark,InDataCarding_Active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-04-08
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDataCarding
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDataCarding WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<Data name="uInDataCardingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uInDataCardingD</DataLocation>
<DefaultData>uInDataCardingDefaultData</DefaultData>
<IdLocation>^dhc.ca.c.uInDataCardingD</IdLocation>
<IndexLocation>^dhc.ca.c.uInDataCardingI</IndexLocation>
<StreamLocation>^dhc.ca.c.uInDataCardingS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
