/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 数据类别码表维护
Class dhc.ca.cache.udata.uOutRecDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-12-16
/// Description: 查看科室是否存在
/// Table: dhc.ca.cache.data.CostDistSets
/// Input: parRef-分层套ID;
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInCostDepts).CheckCostDepts("1||11")
ClassMethod CheckRecDepts(parRef) As %String
{
	n (parRef)
	s rowid=0
	s rs="empty"
	s rowid=$o(^DHCCACOSTDISTSETS($p(parRef,"||",1),"CDM",$p(parRef,"||",2),"InRecDept",rowid))
	i rowid'="" d  s rs="inr"
	s rowid=0
	s rowid=$o(^DHCCACOSTDISTSETS($p(parRef,"||",1),"CDM",$p(parRef,"||",2),"OutRecDept",rowid))
	i rowid'="" d  s rs="outr"
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.OutRecDepts
/// Input: parRef-分层套ID;Depts-部门集合;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uOutRecDepts).InsertRec("003","测试医院","Y","N","Y")
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
	.&SQL(INSERT INTO dhc_ca_cache_data.OutRecDepts (OutRecDepts_parRef,OutRecDepts_deptDr) VALUES (:parRef, :deptDr))
	.i SQLCODE'=0 s Rs=SQLCODE
	i Rs=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	q Rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 更新记录
/// Table: dhc.ca.cache.data.OutRecDepts
/// Input: rowid-数据行号;deptDr-部门ID;
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uOutRecDepts).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, deptDr) As %String
{
	n (rowid, deptDr)

	&SQL(UPDATE dhc_ca_cache_data.OutRecDepts SET OutRecDepts_deptDr=:deptDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-13
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OutRecDepts
/// Input: parRef-分层套ID,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutRecDepts).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT OutRecDepts_rowid,OutRecDepts_deptDr FROM dhc_ca_cache_data.OutRecDepts"
	
	s whereStr=" WHERE OutRecDepts_childSub>0"
	i parRef'="" s whereStr=whereStr_" and OutRecDepts_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OutRecDepts_rowid"
	.i sortField="deptCode" s sortField1="OutRecDepts_deptDr"
	.i sortField="deptName" s sortField1="OutRecDepts_deptDr"
	
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
	s jsonTitle="rowid^deptDr^deptCode^deptName"
	
	While(result.Next())
	{
		s rowid=result.Data("OutRecDepts_rowid")
		s deptDr=result.Data("OutRecDepts_deptDr")
		s deptName=""
		s deptCode=""
		i deptDr'="" d
		.s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		.s deptCode=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",1)

		s tmp=rowid_"^"_deptDr_"^"_deptCode_"^"_deptName
		
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
/// Table：dhc.ca.cache.data.OutRecDepts
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.OutRecDepts WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-12-23
/// Description: 取得当前层以下的所有科室
/// Table：dhc.ca.cache.data.OutRecDepts
/// Input：parRef-分摊套ID;order-当前层序号;start-起始位置;limit-查询条数;searchValue-模糊查询字符串;deptLevelSetsDr-分层套ID
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uOutRecDepts).GetBranchDepts(1,9,0,10,"9")
ClassMethod GetCurrentLayerDepts(parRef, order, start, limit, searchValue, deptLevelSetsDr) As %String
{
	n (parRef, order, start, limit, searchValue,deptLevelSetsDr)
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
/// CreatDate: 2009-10-13
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.OutRecDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uOutRecDepts).ListRec("Y","sear","a","sort","sss",0,25)
ClassMethod checkExist(parRef, deptDr)
{
	n (parRef,deptDr)
	
	s sqlStr="SELECT OutRecDepts_rowid,OutRecDepts_deptDr FROM dhc_ca_cache_data.OutRecDepts"
	
	s whereStr=" WHERE OutRecDepts_childSub>0"
	i parRef'="" s whereStr=whereStr_" and OutRecDepts_parRef='"_parRef_"'"
	i deptDr'="" s whereStr=whereStr_" and OutRecDepts_deptDr='"_deptDr_"'"
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
<StreamLocation>^dhc.ca.c.uOutRecDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
