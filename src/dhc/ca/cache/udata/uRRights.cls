/// Creator: 王赢赢
/// CreatDate: 2009-11-4
/// Description: 单位
Class dhc.ca.cache.udata.uRRights Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.RRights
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRRights).IfRepOrder("ss")
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef,order)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"RROrder",parRef,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 部门是否存在
/// Table：dhc.ca.cache.data.RRights
/// Input: order
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uRRights).IfRepOrder("ss")
ClassMethod IfRepName(parRef, name) As %String
{
	n (parRef,name)
	s rowid=0
	s rowid=$o(^DHCCAROLES(0,"RRName",parRef,name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-11-5
/// Description: 插入一条新数据
/// Table：dhc.ca.cache.data.RRights
/// Input：
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRRights).InsertRec(7,1,"n1","")
ClassMethod InsertRec(parRef, order, name, active) As %String
{
	
	n (parRef, order, name, active)
	
	s rowid=0
	s rowid=..IfRepOrder(parRef,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepName(parRef,name)
	q:rowid>0 "RepName"
	
	i (active'="Y")||(active'="N") s active="Y"

	&sql(insert into dhc_ca_cache_data.RRights (RRights_parRef,RRights_order,RRights_name,RRights_active) values(:parRef, :order, :name, :active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-11-5
/// Description: 更新记录
/// Table：dhc.ca.cache.data.RRights
/// Input：
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uRRights).UpdateRec("7||1",1,2)
ClassMethod UpdateRec(rowId, order, name, active) As %String
{
	n (rowId, order, name, active)
	
	s parR=$p(rowId,"||",1)
	s sub=$p(rowId,"||",2)
	
	s rowid=0
	s rowid=..IfRepOrder(parR,order)
	q:(rowid'=0)&(rowid'=sub) "RepOrder"
	s rowid=..IfRepName(parR,name)
	q:(rowid'=0)&(rowid'=sub) "RepName"

	&sql(update dhc_ca_cache_data.RRights set RRights_order=:order,RRights_name=:name,RRights_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table：dhc.ca.cache.data.RRights
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uRRights).DelRec("7||1")
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.RRights WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-11-5
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.RRights
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uRRights).ListRec(7,"Y","","","","",0,25)
ClassMethod ListRec(parRef, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT RRights_parRef,RRights_rowid,RRights_order,RRights_name,RRights_active FROM dhc_ca_cache_data.RRights"
	
	s whereStr=" WHERE RRights_childSub>0 AND RRights_parRef="_parRef
	i (active="Y")||(active="N") s whereStr=whereStr_" AND RRights_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="order" s sortField1="RRights_order"
	.i sortField="name" s sortField1="RRights_name"
	.i sortField="active" s sortField1="RRights_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY RRights_order ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr

	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="parRef^rowId^order^name^active"
	
	While(result.Next())
	{
		s parRef = result.Data("RRights_parRef")
		s rowId = result.Data("RRights_rowid")
		s order = result.Data("RRights_order")
		s name = result.Data("RRights_name")
		s active = result.Data("RRights_active")
		
		s tmp=parRef_"^"_rowId_"^"_order_"^"_name_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "order")&(order'[searchValue)
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
<StreamLocation>^dhc.ca.c.uRRightsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
