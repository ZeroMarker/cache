/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uInRecDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InRecDepts
/// Input: parRef-分层套ID;deptDr-部门ID;rate-比率;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uInRecDepts).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(parRef, Depts) As %String
{
	n (parRef, Depts)
	TSTART
	s Rs=0
	s tmpLength=$l(Depts,",")
	f tmpIndex=1:1:tmpLength d
	.s tmpDept=""
	.s tmpDept=$p(Depts,",",tmpIndex)
	.s deptDr=""
	.s deptDr=$p($g(tmpDept),"^",1)
	.s rate=""
	.s rate=$p($g(tmpDept),"^",2)
	.&SQL(INSERT INTO dhc_ca_cache_data.InRecDepts(InRecDepts_parRef,InRecDepts_deptDr,InRecDepts_rate) VALUES (:parRef, :deptDr, :rate))
	.i SQLCODE'=0 s Rs=SQLCODE
	i Rs=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q Rs
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InRecDepts
/// Input: rowid-数据行号;deptDr-部门ID;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";收入支出标志都选中,返回"InOut";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uInRecDepts).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, deptDr, rate) As %String
{
	n (rowid, deptDr, rate)

	&SQL(UPDATE dhc_ca_cache_data.InRecDepts SET InRecDepts_deptDr=:deptDr,InRecDepts_rate=:rate WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InRecDepts
/// Input: parRef-分层套ID,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInRecDepts).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT InRecDepts_rowid,InRecDepts_rate,InRecDepts_deptDr FROM dhc_ca_cache_data.InRecDepts"
	
	s whereStr=" WHERE InRecDepts_childSub>0"
	i parRef'="" s whereStr=whereStr_" and InRecDepts_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InRecDepts_rowid"
	.i sortField="deptCode" s sortField1="InRecDepts_deptDr"
	.i sortField="deptName" s sortField1="InRecDepts_deptDr"
	.i sortField="rate" s sortField1="InRecDepts_rate"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^deptDr^deptCode^deptName^rate"
	
	While(result.Next())
	{
		s rowid=result.Data("InRecDepts_rowid")
		s deptDr=result.Data("InRecDepts_deptDr")
		s deptName=""
		s deptCode=""
		i deptDr'="" d
		.s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		.s deptCode=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",1)
		s rate=result.Data("InRecDepts_rate")

		s tmp=rowid_"^"_deptDr_"^"_deptCode_"^"_deptName_"^"_rate
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="deptName")&(deptName'[searchValue)
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
/// Table：dhc.ca.cache.data.InRecDepts
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InRecDepts WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-12-23
/// Description: 取得当前层以下的所有科室
/// Table：dhc.ca.cache.data.CostDistMethods
/// Input：parRef-分摊套ID;order-当前层序号;start-起始位置;limit-查询条数;searchValue-模糊查询字符串;deptLevelSetsDr-分层套ID
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uOutRecDepts).GetBranchDepts(1,9,0,10,"9")
ClassMethod GetCurrentLayerDepts(parRef, order, start, limit, searchValue, deptLevelSetsDr) As %String
{
	n (parRef, order, start, limit, searchValue,deptLevelSetsDr)
	d ##class(dhc.ca.cache.udata.CostDist).GetLayers(deptLevelSetsDr)
	s layers=""
	s layers=##class(dhc.ca.cache.udata.CostDist).GetLowLayers(order)
	s tmpDepts=""
	s tmpDepts=##class(dhc.ca.cache.udata.CostDist).GetLowLayerDepts(layers)
	s depts=""
	s depts=##class(dhc.ca.cache.udata.CostDist).GetDepts(tmpDepts,2)
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="deptDr^deptDesc"
	s count=0
	s end=start+limit-1
	s deptDr=""
	f index=1:1:$l(depts,"^") d
	.s deptDr=""
	.s deptDr=$p(depts,"^",index)
	.s tmpRs=..checkExist(parRef,deptDr)
	.i (tmpRs=0) d
	..s deptDesc=""
	..i deptDr'="" d
	...s deptDesc=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",3)
	...s tmp=deptDr_"^"_deptDesc
	...i searchValue'="" d
	....q:(deptDesc'[searchValue)
	....i (count>=start)&(count<=end) d
	.....d json.InsertRowData(tmp)
	....s count=count+1
	...e  d
	....i (count>=start)&(count<=end) d
	.....d json.InsertRowData(tmp)
	....s count=count+1
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-12-23
/// Description: 查询科室是否存在
/// Table: dhc.ca.cache.data.InRecDepts
/// Input: parRef-分摊套ID;deptDr-部门ID;
/// Output: 
/// Return: 返回如果存在返回所在的ID,否则0
/// Others: w ##class(dhc.ca.cache.udata.uInRecDepts).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod checkExist(parRef, deptDr)
{
	n (parRef,deptDr)
	
	s sqlStr="SELECT InRecDepts_rowid,InRecDepts_deptDr FROM dhc_ca_cache_data.InRecDepts"
	
	s whereStr=" WHERE InRecDepts_childSub>0"
	i parRef'="" s whereStr=whereStr_" and InRecDepts_parRef='"_parRef_"'"
	i deptDr'="" s whereStr=whereStr_" and InRecDepts_deptDr='"_deptDr_"'"
	s rs=0
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()

	
	While(result.Next())
	{
		s rs=1
	}
	q rs
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInRecDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
