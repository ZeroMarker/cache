/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 单位
Class dhc.ca.cache.udata.uRDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.RDepts
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRDepts).IfRepOrder("ss")
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef,order)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"RDOrder",parRef,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 部门是否存在
/// Table：dhc.ca.cache.data.RDepts
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRDepts).IfRepOrder("ss")
ClassMethod IfRepDept(parRef, deptDr) As %String
{
	n (parRef,deptDr)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"RDDeptdr",parRef,deptDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-11-5
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.RDepts
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRDepts).InsertRec(1,12,4)
ClassMethod InsertRec(parRef, order, deptDr) As %String
{
	
	n (parRef, order, deptDr)
	
	s rowid=0
	s rowid=..IfRepOrder(parRef,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepDept(parRef,deptDr)
	q:rowid>0 "RepDept"
	
	&sql(insert into dhc_ca_cache_data.RDepts (RDepts_parRef,RDepts_order,RDepts_deptDr) values(:parRef, :order, :deptDr))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-11-5
/// Description: 更新记录
/// Table：dhc.ca.cache.data.RDepts
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRDepts).UpdateRec("7||1",1,2)
ClassMethod UpdateRec(rowId, order, deptDr) As %String
{
	n (rowId, order, deptDr)
	
	s parR=$p(rowId,"||",1)
	s sub=$p(rowId,"||",2)
	
	s rowid=0
	s rowid=..IfRepOrder(parR,order)
	q:(rowid'=0)&(rowid'=sub) "RepOrder"
	s rowid=..IfRepDept(parR,deptDr)
	q:(rowid'=0)&(rowid'=sub) "RepDept"

	&sql(update dhc_ca_cache_data.RDepts set RDepts_order=:order,RDepts_deptDr=:deptDr where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table：dhc.ca.cache.data.RDepts
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uRDepts).DelRec("7||1")
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.RDepts WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.RDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uRDepts).ListRec(7,"","","","",0,25)
ClassMethod ListRec(parRef, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT RDepts_parRef,RDepts_rowid,RDepts_order,RDepts_deptDr FROM dhc_ca_cache_data.RDepts"
	
	s whereStr=" WHERE RDepts_childSub>0 AND RDepts_parRef="_parRef
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="order" s sortField1="RDepts_order"
	.i sortField="deptName" s sortField1="RDepts_deptDr"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY RDepts_order ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="parRef^rowId^order^deptDr^deptName"
	
	While(result.Next())
	{
		s parRef = result.Data("RDepts_parRef")
		s rowId = result.Data("RDepts_rowid")
		s order = result.Data("RDepts_order")
		s deptDr = result.Data("RDepts_deptDr")

		s deptName = $p(^DHCCAUNITDEPTS(deptDr),"^",2)
		
		s tmp=parRef_"^"_rowId_"^"_order_"^"_deptDr_"^"_deptName
		
		i searchValue'="" d
		.q:(searchField = "order")&(order'[searchValue)
		.q:(searchField = "deptName")&(deptName'[searchValue)
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
<StreamLocation>^dhc.ca.c.uRDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
