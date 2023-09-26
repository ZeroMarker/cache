/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 用户码表维护
Class dhc.ca.cache.udata.uUsers Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.Users
/// Input: loginName-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepName(loginName) As %String
{
	n (loginName)
	s rowid=0
	s rowid=$o(^DHCCAUSERS(0,"Loginname",loginName,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.Users
/// Input: order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepOrder(order) As %String
{
	n (order)
	s rowid=0
	s rowid=$o(^DHCCAUSERS(0,"Order",order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.Users
/// Input: order-序号;loginName-名称;password-密码;unitPersonDr-人员ID;remark-备注;
/// Output: 
/// Return: 序号为空,返回"EmptyOrder";序号存在,返回"RepOrder";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(order, loginName, password, unitPersonDr, remark) As %String
{
	n (order, loginName, password, unitPersonDr, remark)
	
	q:order="" "EmptyOrder"
	q:loginName="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepOrder(order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepName(loginName)
	q:rowid>0 "RepName"
	s active="Y"

	&SQL(INSERT INTO dhc_ca_cache_data.Users (Users_order,Users_loginName,Users_password,Users_unitPersonDr,Users_remark,Users_active) VALUES (:order,:loginName,:password,:unitPersonDr,:remark,:active))
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 更新记录
/// Table: dhc.ca.cache.data.Users
/// Input: rowid-数据行号; order-序号;loginName-名称;password-密码;unitPersonDr-人员ID;remark-备注;
/// Output: 
/// Return: 序号为空,返回"EmptyOrder";序号存在,返回"RepOrder";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, order, loginName, password, unitPersonDr, remark, active) As %String
{
	n (rowid, order, loginName, password, unitPersonDr, remark, active)
	
	q:order="" "EmptyOrder"
	q:loginName="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepName(loginName)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(order)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepOrder"

	&SQL(UPDATE dhc_ca_cache_data.Users SET Users_order=:order,Users_loginName=:loginName,Users_password=:password,Users_unitPersonDr=:unitPersonDr,Users_remark=:remark,Users_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-5
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.Users
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUsers).ListRec("","","rowid","desc",0,25,"Y")
/// Refresh: w ##class(dhc.ca.cache.udata.uUsers).ListRec("","","order","ASC",0,25,"")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, active)
{
	;q active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT Users_rowid,Users_order,Users_password,Users_loginName,Users_unitPersonDr,Users_remark,Users_active FROM dhc_ca_cache_data.Users"
	
	s whereStr=" WHERE %ID>0"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND Users_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="Users_rowid"
	.i sortField="password" s sortField1="Users_password"
	.i sortField="loginName" s sortField1="Users_loginName"
	.i sortField="order" s sortField1="Users_order"
	.i sortField="unitPersonName" s sortField1="Users_unitPersonDr"
	.i sortField="remark" s sortField1="Users_remark"
	.i sortField="active" s sortField1="Users_active"
	
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
	s jsonTitle="rowid^order^loginName^password^unitPersonDr^unitPersonName^remark^active^unitTypeDr^unitTypeName^unitDr^unitName^fPassword"
	
	While(result.Next())
	{
		s rowid=result.Data("Users_rowid")
		s password=result.Data("Users_password")
		s loginName=result.Data("Users_loginName")
		s unitPersonDr=result.Data("Users_unitPersonDr")
		s unitPsersonName=""
		s unitDr=""
		s unitName=""
		s unitTypeDr=""
		s unitTypeName=""
		i unitPersonDr'="" d
		.s unitPsersonName=$p($g(^DHCCAUNITPERSONS(unitPersonDr)),"^",2)
		.s unitDr=$p($g(^DHCCAUNITPERSONS(unitPersonDr)),"^",17)
		.i unitDr'="" d
		..s unitName=$p($g(^DHCCAUNITS(unitDr)),"^",2)
		..s unitTypeDr=$p($g(^DHCCAUNITS(unitDr)),"^",8)
		..i unitTypeDr'="" d
		...s unitTypeName=$p($g(^DHCCAUNITTYPES(unitTypeDr)),"^",2)
		
		s order=result.Data("Users_order")
		s remark=result.Data("Users_remark")
		s active=result.Data("Users_active")
		s tmp=rowid_"^"_order_"^"_loginName_"^"_password_"^"_unitPersonDr_"^"_unitPsersonName_"^"_remark_"^"_active_"^"_unitTypeDr_"^"_unitTypeName_"^"_unitDr_"^"_unitName_"^******"
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="password")&(password'[searchValue)
		.q:(searchField="loginName")&(loginName'[searchValue)
		.q:(searchField="unitPsersonName")&(unitPsersonName'[searchValue)
		.q:(searchField="unitName")&(unitName'[searchValue)
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
/// CreatDate: 2009-11-5
/// Description: 删除记录
/// Table: dhc.ca.cache.data.Users
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.Users).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.Users WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uUsersS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
