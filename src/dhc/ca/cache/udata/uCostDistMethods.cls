/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 成本分摊套码表维护
Class dhc.ca.cache.udata.uCostDistMethods Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.CostDistMethods
/// Input: costSetsDr-成本套;layerDr-所在层;code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uCostDistMethods).IfRepCode("1001")
ClassMethod IfRepCode(costSetsDr, layerDr, code) As %String
{
	n (costSetsDr, layerDr, code)
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS(0,"CDMSLC",costSetsDr,layerDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.CostDistMethods
/// Input: costSetsDr-成本套;layerDr-所在层;name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uCostDistMethods).IfRepName("工资费用")
ClassMethod IfRepName(costSetsDr, layerDr, name) As %String
{
	n (costSetsDr, layerDr, name)
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS(0,"CDMSLN",costSetsDr,layerDr,name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 优先级是否存在
/// Table: dhc.ca.cache.data.CostDistMethods
/// Input: costSetsDr-成本套;layerDr-所在层;priority-优先级
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uCostDistMethods).IfRepName("工资费用")
ClassMethod IfRepPriority(costSetsDr, layerDr, priority) As %String
{
	n (costSetsDr, layerDr, priority)
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS(0,"CDMSLP",costSetsDr,layerDr,priority,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.CostDistMethods
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数,deptSetDr-部门分层套DR,ioFlag-分摊配比
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uCostDistMethods).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(parRef, priority, layerDr, code, name, itemDr, paramPeriDr, ioFlag) As %String
{
	n (parRef, priority, layerDr, code, name, itemDr, paramPeriDr, ioFlag)
	
	s rowid=0
	s rowid=..IfRepPriority(parRef,layerDr,priority)
	q:rowid>0 "RepPriority"
	s rowid=0
	s rowid=..IfRepCode(parRef,layerDr,code)
	q:rowid>0 "RepCode"
	s rowid=0
	s rowid=..IfRepName(parRef,layerDr,name)
	q:rowid>0 "RepName"
	s active="Y"
	&SQL(INSERT INTO dhc_ca_cache_data.CostDistMethods (CostDistMethods_parRef,CostDistMethods_priority,CostDistMethods_layerDr,CostDistMethods_code,CostDistMethods_name,CostDistMethods_itemDr,CostDistMethods_active,CostDistMethods_paramPeriDr,CostDistMethods_ioFlag) VALUES (:parRef,:priority,:layerDr,:code,:name,:itemDr,:active,:paramPeriDr,:ioFlag))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 更新记录
/// Table: dhc.ca.cache.data.CostDistMethods
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志,deptSetDr-部门分层套DR,ioFlag-分摊配比
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uCostDistMethods).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, priority, layerDr, code, name, itemDr, paramPeriDr, active, ioFlag) As %String
{
	n (rowid, priority, layerDr, code, name, itemDr, paramPeriDr, active, ioFlag)
	
	s tmpRowid=0
	s tmpRowid=..IfRepPriority($p($g(rowid),"||",1),layerDr,priority)
	q:(tmpRowid'=0)&(tmpRowid'=$p($g(rowid),"||",2)) "RepPriority"
	s tmpRowid=0
	s tmpRowid=..IfRepCode($p($g(rowid),"||",1),layerDr,code)
	q:(tmpRowid'=0)&(tmpRowid'=$p($g(rowid),"||",2)) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName($p($g(rowid),"||",1),layerDr,name)
	q:(tmpRowid'=0)&(tmpRowid'=$p($g(rowid),"||",2)) "RepName"
	
	&SQL(UPDATE dhc_ca_cache_data.CostDistMethods SET CostDistMethods_priority=:priority,CostDistMethods_layerDr=:layerDr,CostDistMethods_name=:name,CostDistMethods_code=:code,CostDistMethods_itemDr=:itemDr,CostDistMethods_paramPeriDr=:paramPeriDr,CostDistMethods_active=:active,CostDistMethods_ioFlag=:ioFlag WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.CostDistMethods
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uCostDistMethods).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active, parRef, layerDr)
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit, parRef, layerDr)
	
	s sqlStr="SELECT CostDistMethods_rowid,CostDistMethods_priority,CostDistMethods_code,CostDistMethods_name,CostDistMethods_layerDr,CostDistMethods_itemDr,CostDistMethods_paramPeriDr,CostDistMethods_active,CostDistMethods_ioFlag FROM dhc_ca_cache_data.CostDistMethods"
	
	s whereStr=" WHERE CostDistMethods_childSub>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND CostDistMethods_active='"_active_"'"
	i parRef'="" s whereStr=whereStr_" AND CostDistMethods_parRef='"_parRef_"'"
	i layerDr'="" s whereStr=whereStr_" AND CostDistMethods_layerDr='"_layerDr_"'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="CostDistMethods_rowid"
	.i sortField="code" s sortField1="CostDistMethods_code"
	.i sortField="name" s sortField1="CostDistMethods_name"
	.i sortField="priority" s sortField1="CostDistMethods_priority"
	.i sortField="layerDr" s sortField1="CostDistMethods_layerDr"
	.i sortField="itemDr" s sortField1="CostDistMethods_itemDr"
	.i sortField="paramPeriDr" s sortField1="CostDistMethods_paramPeriDr"
	.i sortField="active" s sortField1="CostDistMethods_active"
	.i sortField="ioFlag" s sortField1="CostDistMethods_ioFlag"
	
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
	s jsonTitle="rowid^priority^layerDr^layerName^code^name^itemDr^itemName^paramPeriDr^paramPeriName^active^ioFlag"
	
	While(result.Next())
	{
		s rowid=result.Data("CostDistMethods_rowid")
		s code=result.Data("CostDistMethods_code")
		s name=result.Data("CostDistMethods_name")
		s priority=result.Data("CostDistMethods_priority")
		
		s layerDr=result.Data("CostDistMethods_layerDr")
		s layerName=""
		i layerDr'="" d
		.s layerName=$p($g(^DHCCADEPTLEVELSETS(layerDr)),"^",2)
		
		s itemDr=result.Data("CostDistMethods_itemDr")
		s itemName=""
		i itemDr'="" d
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		
		s paramPeriDr=result.Data("CostDistMethods_paramPeriDr")
		s paramPeriName=""
		i paramPeriDr'="" d
		.s paramPeriName=$p($g(^DHCCAACCPERIOD(paramPeriDr)),"^",3)
		
		s active=result.Data("CostDistMethods_active")
		s ioFlag=result.Data("CostDistMethods_ioFlag")
		s tmp=rowid_"^"_priority_"^"_layerDr_"^"_layerName_"^"_code_"^"_name_"^"_itemDr_"^"_itemName_"^"_paramPeriDr_"^"_paramPeriName_"^"_active_"^"_ioFlag
		
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
		.q:(searchField="ioFlag")&(ioFlag'[searchValue)
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

/// Creator：杨旭
/// CreatDate：2009-12-23
/// Description: 删除记录
/// Table：dhc.ca.cache.data.CostDistMethods
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.CostDistMethods WHERE %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uCostDistMethodsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
