/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 用户角色码表维护
Class dhc.ca.cache.udata.uURoles Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 角色是否存在
/// Table: dhc.ca.cache.data.URoles
/// Input: userDr-用户ID;RoleDr-角色ID
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:
ClassMethod IfRepRole(userDr, RoleDr) As %String
{
	n (userDr, RoleDr)
	s rowid=0
	s rowid=$o(^DHCCAUSERS(0,"URole",userDr,RoleDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.URoles
/// Input: userDr-用户ID; order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepOrder(userDr, order) As %String
{
	n (userDr, order)
	s rowid=0
	s rowid=$o(^DHCCAUSERS(0,"UROrder",userDr,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.URoles
/// Input: userDr-用户ID; order-序号;RoleDr-角色ID
/// Output: 
/// Return: 序号为空,返回"EmptyOrder";序号存在,返回"RepOrder";角色为空,返回"EmptyRole";角色存在,返回"RepRole";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uUsers).InsertRec("003","测试医院","Y","N","Y")
ClassMethod InsertRec(userDr, order, roleDr) As %String
{
	n (userDr, order, roleDr)
	
	q:order="" "EmptyOrder"
	q:roleDr="" "EmptyRole"
	
	s rowid=0
	s rowid=..IfRepOrder(userDr,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepRole(userDr,roleDr)
	q:rowid>0 "RepRole"

	&SQL(INSERT INTO dhc_ca_cache_data.URoles (URoles_parRef,URoles_order,URoles_roleDr) VALUES (:userDr,:order,:roleDr))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 更新记录
/// Table: dhc.ca.cache.data.URoles
/// Input: rowid-数据行号;userDr-用户ID; order-序号;RoleDr-角色ID
/// Output: 
/// Return: 序号为空,返回"EmptyOrder";序号存在,返回"RepOrder";角色为空,返回"EmptyRole";角色存在,返回"RepRole";执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, userDr, order, roleDr) As %String
{
	n (rowid, userDr, order, roleDr)
	
	q:order="" "EmptyOrder"
	q:roleDr="" "EmptyRole"
	
	s tmpRowid=0
	s tmpRowid=..IfRepRole(userDr,roleDr)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowid,"||",2)) "RepRole"
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(userDr,order)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowid,"||",2)) "RepOrder"

	&SQL(UPDATE dhc_ca_cache_data.URoles SET URoles_order=:order,URoles_roleDr=:roleDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.URoles
/// Input: userDr-用户Dr,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uURoles).ListRec("","","rowid","DESC",0,25,1)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, userDr)
{
	;q searchField_"^"_ searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_userDr
	n (userDr, searchField, searchValue, sortField, sortDir, start, limit)
	s sqlStr="SELECT URoles_rowid,URoles_order,URoles_parRef,URoles_roleDr FROM dhc_ca_cache_data.URoles"
	
	s whereStr=" WHERE URoles_childSub>0"
	i userDr'="" s whereStr=whereStr_" AND URoles_parRef='"_userDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="URoles_rowid"
	.i sortField="roleName" s sortField1="URoles_roleDr"
	.i sortField="order" s sortField1="URoles_order"
	
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
	s jsonTitle="rowid^order^roleDr^roleCode^roleName"
	
	While(result.Next())
	{
		s rowid=result.Data("URoles_rowid")
		s order=result.Data("URoles_order")
		s roleDr=result.Data("URoles_roleDr")
		s roleCode=""
		s roleName=""
		i roleDr'="" d
		.s roleCode=$p($g(^DHCCAROLES(roleDr)),"^",2)
		.s roleName=$p($g(^DHCCAROLES(roleDr)),"^",3)

		
		s tmp=rowid_"^"_order_"^"_roleDr_"^"_roleCode_"^"_roleName
		
		i searchValue'="" d
		.i (searchField="active") d
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="roleName")&(roleName'[searchValue)
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
/// CreatDate: 2009-9-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.URoles
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uDataItems).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.URoles WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uURolesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
