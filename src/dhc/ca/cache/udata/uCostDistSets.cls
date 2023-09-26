/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 成本分摊套码表维护
Class dhc.ca.cache.udata.uCostDistSets Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uCostDistSets).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uCostDistSets).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uCostDistSets).IfRepName("工资费用")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS(0,"Order",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数,deptSetDr-部门分层套DR,distFlag-分摊标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uCostDistSets).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(order, code, name, deptSetDr, remark, distFlag) As %String
{
	n (order, code, name, deptSetDr, remark, distFlag)
	
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
	&SQL(INSERT INTO dhc_ca_cache_data.CostDistSets (CostDistSets_order,CostDistSets_code,CostDistSets_name,CostDistSets_shortcut,CostDistSets_deptSetDr,CostDistSets_remark,CostDistSets_active,CostDistSets_distFlag) VALUES (:order,:code,:name,:shortcut,:deptSetDr,:remark,:active,:distFlag))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 更新记录
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志,deptSetDr-部门分层套DR,distFlag-分摊标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uCostDistSets).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, order, code, name, deptSetDr, remark, active, distFlag) As %String
{
	n (rowid, order, code, name, deptSetDr, remark, active, distFlag)
	
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

	&SQL(UPDATE dhc_ca_cache_data.CostDistSets SET CostDistSets_order=:order,CostDistSets_code=:code,CostDistSets_name=:name,CostDistSets_shortcut=:shortcut,CostDistSets_deptSetDr=:deptSetDr,CostDistSets_remark=:remark,CostDistSets_active=:active,CostDistSets_distFlag=:distFlag WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uCostDistSets).ListRec("","","order","ASC",0,25,"")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_active
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT CostDistSets_rowid,CostDistSets_order,CostDistSets_code,CostDistSets_name,CostDistSets_shortcut,CostDistSets_deptSetDr,CostDistSets_remark,CostDistSets_active,CostDistSets_distFlag FROM dhc_ca_cache_data.CostDistSets"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND CostDistSets_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="CostDistSets_rowid"
	.i sortField="code" s sortField1="CostDistSets_code"
	.i sortField="name" s sortField1="CostDistSets_name"
	.i sortField="order" s sortField1="CostDistSets_order"
	.i sortField="shortcut" s sortField1="CostDistSets_shortcut"
	.i sortField="deptSetName" s sortField1="CostDistSets_deptSetDr"
	.i sortField="remark" s sortField1="CostDistSets_remark"
	.i sortField="active" s sortField1="CostDistSets_active"
	.i sortField="distFlag" s sortField1="CostDistSets_distFlag"
	
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
	s jsonTitle="rowid^order^code^name^shortcut^deptSetDr^deptSetName^remark^active^distFlag"
	
	While(result.Next())
	{
		s rowid=result.Data("CostDistSets_rowid")
		s code=result.Data("CostDistSets_code")
		s name=result.Data("CostDistSets_name")
		s shortcut=result.Data("CostDistSets_shortcut")
		s deptSetDr=result.Data("CostDistSets_deptSetDr")
		s deptSetName=""
		i deptSetDr'="" d
		.s deptSetName=$p(^DHCCADEPTLEVELSETS(deptSetDr),"^",2)
		s order=result.Data("CostDistSets_order")
		s remark=result.Data("CostDistSets_remark")
		s active=result.Data("CostDistSets_active")
		s distFlag=result.Data("CostDistSets_distFlag")
		i distFlag'="" d
		.i distFlag="layer" s distFlag="逐层"
		.i distFlag="direct" s distFlag="直接"
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_deptSetDr_"^"_deptSetName_"^"_remark_"^"_active_"^"_distFlag
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="deptSetName")&(deptSetName'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="active")&(active'[searchValue)
		.q:(searchField="distFlag")&(distFlag'[searchValue)
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
<StreamLocation>^dhc.ca.c.uCostDistSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
