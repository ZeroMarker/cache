/// Creator: 杨旭
/// CreatDate: 2010-03-12
/// Description: 收入分配方法
Class dhc.ca.cache.udata.uInDistMethods Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-12
/// Description: 过滤规则是否存在
/// Table: dhc.ca.cache.data.InDistMethods
/// Input: inFiltRuleDr-过滤规则
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepFiltRule(inFiltRuleDr) As %String
{
	n (inFiltRuleDr)
	s rowid=0
	s tmpDr=0
	s tmpDr=$o(^DHCCAINDISTMETHODS(0,"FD",inFiltRuleDr,tmpDr))
	i tmpDr'="" d
	.s rowid=$o(^DHCCAINDISTMETHODS(0,"FD",inFiltRuleDr,tmpDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2010-03-12
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDistMethods
/// Input: code-代码,name-名称,in-收入,out-支出,param-参数
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(priority, inFiltRuleDr, inDistRuleDr) As %String
{
	n (priority, inFiltRuleDr, inDistRuleDr)
	
	q:priority="" "EmptyPriority"
	q:inFiltRuleDr="" "EmptyInFiltRuleDr"
	q:inDistRuleDr="" "EmptyInDistRuleDr"
	
	s rowid=0
	s rowid=..IfRepFiltRule(inFiltRuleDr)
	q:rowid>0 "RepFiltRule"

	&SQL(INSERT INTO dhc_ca_cache_data.InDistMethods (InDistMethods_priority,InDistMethods_inFiltRuleDr,InDistMethods_inDistRuleDr) VALUES (:priority, :inFiltRuleDr, :inDistRuleDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-12
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InDistMethods
/// Input: rowid-数据行号,code-代码,name-名称,in-收入,out-支出,param-参数,active-有效标志
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, priority, inFiltRuleDr, inDistRuleDr) As %String
{
	n (rowid, priority, inFiltRuleDr, inDistRuleDr)
	
	q:priority="" "EmptyPriority"
	q:inFiltRuleDr="" "EmptyInFiltRuleDr"
	q:inDistRuleDr="" "EmptyInDistRuleDr"
	
	s tmpRowid=0
	s tmpRowid=..IfRepFiltRule(inFiltRuleDr)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepFiltRule"


	&SQL(UPDATE dhc_ca_cache_data.InDistMethods SET InDistMethods_priority=:priority,InDistMethods_inFiltRuleDr=:inFiltRuleDr,InDistMethods_inDistRuleDr=:inDistRuleDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2010-03-12
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDistMethods
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInDistMethods).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit)
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT InDistMethods_rowid,InDistMethods_priority,InDistMethods_inFiltRuleDr,InDistMethods_inDistRuleDr FROM dhc_ca_cache_data.InDistMethods"
	
	s whereStr=" WHERE %ID>0"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDistMethods_rowid"
	.i sortField="priority" s sortField1="InDistMethods_priority"
	.i sortField="inFiltRuleName" s sortField1="InDistMethods_inFiltRuleDr"
	.i sortField="inDistRuleName" s sortField1="InDistMethods_inDistRuleDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY InDistMethods_priority ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^priority^inFiltRuleDr^inFiltRuleName^inDistRuleDr^inDistRuleName"
	
	While(result.Next())
	{
		s rowid=result.Data("InDistMethods_rowid")
		s priority=result.Data("InDistMethods_priority")
		s inFiltRuleDr=result.Data("InDistMethods_inFiltRuleDr")
		s inFiltRuleName=""
		i inFiltRuleDr'="" d
		.i $d(^DHCCAINFILTRULE(inFiltRuleDr)) d
		..s inFiltRuleName=$p($g(^DHCCAINFILTRULE(inFiltRuleDr)),"^",2)
		
		s inDistRuleDr=result.Data("InDistMethods_inDistRuleDr")
		s inDistRuleName=""
		i inDistRuleDr'="" d
		.i $d(^DHCCAINDISTRULE(inDistRuleDr)) d
		..s inDistRuleName=$p($g(^DHCCAINDISTRULE(inDistRuleDr)),"^",2)

		s tmp=rowid_"^"_priority_"^"_inFiltRuleDr_"^"_inFiltRuleName_"^"_inDistRuleDr_"^"_inDistRuleName
		
		i searchValue'="" d
		.q:(searchField="priority")&(priority'[searchValue)
		.q:(searchField="inFiltRuleName")&(inFiltRuleName'[searchValue)
		.q:(searchField="inDistRuleName")&(inDistRuleName'[searchValue)
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
/// CreatDate: 2010-03-12
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDistMethods
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDistMethods WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDistMethodsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
