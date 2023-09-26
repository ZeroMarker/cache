/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 接口部门套码表维护
Class dhc.ca.cache.udata.uInDeptSets Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).IfRepCode("1001")
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCAINDEPTSETS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).IfRepName("工资费用")
ClassMethod IfRepName(name) As %String
{
	n (name)
	s rowid=0
	s rowid=$o(^DHCCAINDEPTSETS(0,"Name",name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).IfRepName("工资费用")
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCAINDEPTSETS(0,"SetOrder",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).InsertRec("003","测试医院","Y","N","Y")
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
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptSets (InDeptSets_order,InDeptSets_code,InDeptSets_name,InDeptSets_shortcut,InDeptSets_remark,InDeptSets_active) VALUES (:order,:code,:name,:shortcut,:remark,:active))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInDeptSets).UpdateRec(1,"12","22","33","Y","Y")
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

	&SQL(UPDATE dhc_ca_cache_data.InDeptSets SET InDeptSets_order=:order,InDeptSets_code=:code,InDeptSets_name=:name,InDeptSets_shortcut=:shortcut,InDeptSets_remark=:remark,InDeptSets_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// 刷新接口部门套: w ##class(dhc.ca.cache.udata.uInDeptSets).ListRec("","","order","ASC",0,25,"")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_active
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InDeptSets_rowid,InDeptSets_order,InDeptSets_code,InDeptSets_name,InDeptSets_shortcut,InDeptSets_remark,InDeptSets_active FROM dhc_ca_cache_data.InDeptSets"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND InDeptSets_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDeptSets_rowid"
	.i sortField="code" s sortField1="InDeptSets_code"
	.i sortField="name" s sortField1="InDeptSets_name"
	.i sortField="order" s sortField1="InDeptSets_order"
	.i sortField="shortcut" s sortField1="InDeptSets_shortcut"
	.i sortField="remark" s sortField1="InDeptSets_remark"
	.i sortField="active" s sortField1="InDeptSets_active"
	
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
		s rowid=result.Data("InDeptSets_rowid")
		s code=result.Data("InDeptSets_code")
		s name=result.Data("InDeptSets_name")
		s shortcut=result.Data("InDeptSets_shortcut")
		s order=result.Data("InDeptSets_order")
		s remark=result.Data("InDeptSets_remark")
		s active=result.Data("InDeptSets_active")
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

/// Creator: 杨旭
/// CreatDate: 2009-12-1
/// Description: 查找内部科室与外部科室对照
/// Table: dhc.ca.cache.data.UnitDepts
/// Input: deptSetDr-部门套ID; deptCode-外部部门ID
/// Output: 
/// Return: 返回内部科室ID
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).DeptRelation(1,41)
ClassMethod DeptRelation(deptSetDr, deptCode) As %String
{
	n (deptSetDr,deptCode)
	s tmpId=""
	s inDeptDr=""
	s tmpId=$o(^DHCCAINDEPTSETS(0,"Outcode",deptSetDr,deptCode,tmpId))
	i tmpId'="" d
	.s inDeptDr=$p($g(^DHCCAINDEPTSETS(deptSetDr,"InDepts",tmpId)),"^",2)
	q inDeptDr
}

/// Creator: 杨旭
/// CreatDate: 2009-12-1
/// Description: 查找内部项目与外部项目对照
/// Table: dhc.ca.cache.data.AllDataItems
/// Input: itemSetDr-项目套ID, itemCode-外部项目代码
/// Output: 
/// Return: 返回内部项目ID
/// Others: w ##class(dhc.ca.cache.udata.uInDeptSets).ItemRelation(1,"0102")
ClassMethod ItemRelation(itemSetDr, itemCode) As %String
{
	n (itemSetDr, itemCode)
	s outItemDr=""
	s outItemDr=$o(^DHCCAALLDATAITEMS(0,"Code",itemCode,outItemDr))
	s tmpId=""
	s inItemDr=""
	s tmpInDr=""
	f  s tmpInDr=$o(^DHCCAINITEMSETS(0,"OutItemDr",itemSetDr,tmpInDr)) q:tmpInDr=""  d
	.i $d(^DHCCAINITEMSETS(0,"OutItemDr",itemSetDr,tmpInDr,outItemDr)) s tmpId=tmpInDr
	i tmpId'="" d
	.s inItemDr=$p($g(^DHCCAINITEMSETS(itemSetDr,"InItems",tmpId)),"^",2)
	q inItemDr
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDeptSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
