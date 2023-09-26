/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 接口部门套码表维护
Class dhc.ca.cache.udata.uPersonSets Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPersonSets).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAPERSONSETS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPersonSets).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAPERSONSETS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPersonSets).IfRepOrder("1")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCAPERSONSETS(0,"Order",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.PersonSets
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uPersonSets).InsertRec("1","code","name","remark")
ClassMethod InsertRec(order, code, name, remark) As %String
{
	n (order, code, name, remark)
	
	q:order="" "EmptyOrder"
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	s rowid=..IfRepOrder(order)
	q:rowid>0 "RepOrder"
	s active="Y"
	s shortcut=code_"-"_name
	&SQL(INSERT INTO dhc_ca_cache_data.PersonSets (PersonSets_order,PersonSets_code,PersonSets_name,PersonSets_shortcut,PersonSets_remark,PersonSets_active) VALUES (:order,:code,:name,:shortcut,:remark,:active))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 更新记录
/// Table: dhc.ca.cache.data.PersonSets
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uPersonSets).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, order, code, name, remark, active) As %String
{
	n (rowid, order, code, name, remark, active)
	
	q:order="" "EmptyOrder"
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(order)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepOrder"
	s shortcut=code_"-"_name

	&SQL(UPDATE dhc_ca_cache_data.PersonSets SET PersonSets_order=:order,PersonSets_code=:code,PersonSets_name=:name,PersonSets_shortcut=:shortcut,PersonSets_remark=:remark,PersonSets_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.PersonSets
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uPersonSets).ListRec("","","","",0,25,"Y")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT PersonSets_rowid,PersonSets_order,PersonSets_code,PersonSets_name,PersonSets_shortcut,PersonSets_remark,PersonSets_active FROM dhc_ca_cache_data.PersonSets"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND PersonSets_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="PersonSets_rowid"
	.i sortField="code" s sortField1="PersonSets_code"
	.i sortField="name" s sortField1="PersonSets_name"
	.i sortField="order" s sortField1="PersonSets_order"
	.i sortField="shortcut" s sortField1="PersonSets_shortcut"
	.i sortField="remark" s sortField1="PersonSets_remark"
	.i sortField="active" s sortField1="PersonSets_active"
	
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
	s jsonTitle="rowid^order^code^name^shortcut^remark^active"
	
	While(result.Next())
	{
		s rowid=result.Data("PersonSets_rowid")
		s code=result.Data("PersonSets_code")
		s name=result.Data("PersonSets_name")
		s shortcut=result.Data("PersonSets_shortcut")
		s order=result.Data("PersonSets_order")
		s remark=result.Data("PersonSets_remark")
		s active=result.Data("PersonSets_active")
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_remark_"^"_active
		
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
<Data name="uPersonSetsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uPersonSetsD</DataLocation>
<DefaultData>uPersonSetsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uPersonSetsD</IdLocation>
<IndexLocation>^dhc.ca.c.uPersonSetsI</IndexLocation>
<StreamLocation>^dhc.ca.c.uPersonSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
