/// Creator: 王赢赢
/// CreatDate: 2009-9-25
/// Description: 单位部门
Class dhc.ca.cache.udata.uUnitDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-9-25
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.UnitDepts
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uUnitDepts).IfRepCode("1")
ClassMethod IfRepCode(unitDr, code) As %String
{
	n (unitDr,code)
	s rowid=0
	s rowid=$o(^DHCCAUNITDEPTS(0,"UnitCode",unitDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-24
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.UnitDepts
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uUnitDepts).IfRepName("ss")
ClassMethod IfRepName(unitDr, name) As %String
{
	n (unitDr,name)
	s rowid=0
	s rowid=$o(^DHCCAUNITDEPTS(0,"UnitName",unitDr,name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-9-25
/// Description: 插入一条新单位部门数据
/// Table：dhc.ca.cache.data.UnitDeptss
/// Input：code-代码;name-名称;address-地址;remark-备注;start-开始;stop-结束;unitDr-单位Dr;propertyDr-属性Dr;active-有效;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitDepts).InsertRec(1,"name","address","remark","2009-09-25","2009-09-25",1,1,"")
ClassMethod InsertRec(code, name, address, remark, start, stop, unitDr, propertyDr, active) As %String
{
	
	n (code, name, address, remark, start, stop, unitDr, propertyDr, active)
	
	s rowid=0
	s rowid=..IfRepCode(unitDr,code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(unitDr,name)
	q:rowid>0 "RepName"
	
	s shortcut =code_"-"_name
	
	i start'="" s start=$zdh(start,3)
	i stop'="" s stop=$zdh(stop,3)
	
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.UnitDepts (UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active) values(:code, :name, :shortcut, :address, :remark, :start, :stop, :unitDr, :propertyDr, :active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-9-25
/// Description: 更新记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input：rowId-所在行号;code-代码;name-名称;address-地址;remark-备注;start-开始;stop-结束;unitDr-单位Dr;propertyDr-属性Dr;active-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitDepts).UpdateRec(1,2,"name1","","","","",2,3,"N")
ClassMethod UpdateRec(rowId, code, name, address, remark, start, stop, unitDr, propertyDr, active) As %String
{
	
	n (rowId, code, name, address, remark, start, stop, unitDr, propertyDr, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(unitDr,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(unitDr,name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	i start'="" s start=$zdh(start,3)
	i stop'="" s stop=$zdh(stop,3)
	
	&sql(update dhc_ca_cache_data.UnitDepts set UnitDepts_code=:code,UnitDepts_name=:name,UnitDepts_shortcut=:shortcut,UnitDepts_address=:address,UnitDepts_remark=:remark,UnitDepts_start=:start,UnitDepts_stop=:stop,UnitDepts_unitDr=:unitDr,UnitDepts_propertyDr=:propertyDr,UnitDepts_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-25
/// Description: 删除记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uUnitDepts).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.UnitDepts WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-25
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// 角色维护: w ##class(dhc.ca.cache.udata.uUnitDepts).ListRec(1,"","shortcut","","","",0,10)
/// Others: w ##class(dhc.ca.cache.udata.uUnitDepts).ListRec(1,"","","","rowId","DESC",0,25)
ClassMethod ListRec(unitDr, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q unitDr_"^"_active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (unitDr,active, searchField, searchValue, sortField, sortDir, start, limit)
	
	//i unitDr="" d
	//.s unitId=0, flag=0
	//.f  s unitId=$o(^DHCCAUNITS(unitId)) q:unitId=""  d
	//..i flag=0 d
	//...s unitDr=unitDr_"("_unitId
	//...s flag=1
	//..e  d
	//...s unitDr=unitDr_","_unitId
	//.s unitDr=unitDr_")"
	//e  d
	//.s unitDr="("_unitDr_")"
	s sqlStr="SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts"
	
	s whereStr=" WHERE UnitDepts_rowid>0 AND UnitDepts_unitDr="_unitDr
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitDepts_active='"_active_"'"
	//s whereStr=whereStr_" AND UnitDepts_rowid NOT IN (SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_deptDr>0)"   //20140513 zjw 剔除已添加在其他角色中的科室
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="UnitDepts_rowid"
	.i sortField="code" s sortField1="UnitDepts_code"
	.i sortField="name" s sortField1="UnitDepts_name"
	.i sortField="shortcut" s sortField1="UnitDepts_shortcut"
	.i sortField="address" s sortField1="UnitDepts_address"
	.i sortField="remark" s sortField1="UnitDepts_remark"
	.i sortField="startTime" s sortField1="UnitDepts_start"
	.i sortField="stop" s sortField1="UnitDepts_stop"
	.i sortField="unitDr" s sortField1="UnitDepts_unitDr"
	.i sortField="propertyDr" s sortField1="UnitDepts_propertyDr"
	.i sortField="active" s sortField1="UnitDepts_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"  //DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^code^name^shortcut^address^remark^startTime^stop^unitDr^propertyDr^active"
	
	While(result.Next())
	{
		s rowId = result.Data("UnitDepts_rowid")
		s code = result.Data("UnitDepts_code")
		s name = result.Data("UnitDepts_name")
		s shortcut = result.Data("UnitDepts_shortcut")
		s address = result.Data("UnitDepts_address")
		s remark = result.Data("UnitDepts_remark")
		s startTime = result.Data("UnitDepts_start")
		s stop = result.Data("UnitDepts_stop")
		s unitDr = result.Data("UnitDepts_unitDr")
		s propertyDr = result.Data("UnitDepts_propertyDr")
		s active = result.Data("UnitDepts_active")
		
		i startTime'="" s startTime=$zd(startTime,3)
		i stop'="" s stop=$zd(stop,3)
		
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_address_"^"_remark_"^"_startTime_"^"_stop_"^"_unitDr_"^"_propertyDr_"^"_active
		//w searchValue
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "address")&(address'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
		.q:(searchField = "startTime")&(startTime'[searchValue)
		.q:(searchField = "stop")&(stop'[searchValue)
		.q:(searchField = "unitDr")&(unitDr'[searchValue)
		.q:(searchField = "propertyDr")&(propertyDr'[searchValue)
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

/// Creator: 王赢赢
/// CreatDate: 2009-9-25
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// 角色维护: w ##class(dhc.ca.cache.udata.uUnitDepts)ListRecR(1,"","shortcut","","","",0,10)
/// Others: w ##class(dhc.ca.cache.udata.uUnitDepts)ListRecR(1,"","","","rowId","DESC",0,25)
ClassMethod ListRecR(unitDr, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q unitDr_"^"_active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (unitDr,active, searchField, searchValue, sortField, sortDir, start, limit)
	
	//i unitDr="" d
	//.s unitId=0, flag=0
	//.f  s unitId=$o(^DHCCAUNITS(unitId)) q:unitId=""  d
	//..i flag=0 d
	//...s unitDr=unitDr_"("_unitId
	//...s flag=1
	//..e  d
	//...s unitDr=unitDr_","_unitId
	//.s unitDr=unitDr_")"
	//e  d
	//.s unitDr="("_unitDr_")"
	s sqlStr="SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts"
	
	s whereStr=" WHERE UnitDepts_rowid>0 AND UnitDepts_unitDr="_unitDr
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitDepts_active='"_active_"'"
	s whereStr=whereStr_" AND UnitDepts_rowid NOT IN (SELECT RDepts_deptDr FROM dhc_ca_cache_data.RDepts WHERE RDepts_deptDr>0)"   //20140513 zjw 剔除已添加在其他角色中的科室
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="UnitDepts_rowid"
	.i sortField="code" s sortField1="UnitDepts_code"
	.i sortField="name" s sortField1="UnitDepts_name"
	.i sortField="shortcut" s sortField1="UnitDepts_shortcut"
	.i sortField="address" s sortField1="UnitDepts_address"
	.i sortField="remark" s sortField1="UnitDepts_remark"
	.i sortField="startTime" s sortField1="UnitDepts_start"
	.i sortField="stop" s sortField1="UnitDepts_stop"
	.i sortField="unitDr" s sortField1="UnitDepts_unitDr"
	.i sortField="propertyDr" s sortField1="UnitDepts_propertyDr"
	.i sortField="active" s sortField1="UnitDepts_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"  //DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	//q sqlStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end = start + limit - 1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	
	s jsonTitle="rowId^code^name^shortcut^address^remark^startTime^stop^unitDr^propertyDr^active"
	
	While(result.Next())
	{
		s rowId = result.Data("UnitDepts_rowid")
		s code = result.Data("UnitDepts_code")
		s name = result.Data("UnitDepts_name")
		s shortcut = result.Data("UnitDepts_shortcut")
		s address = result.Data("UnitDepts_address")
		s remark = result.Data("UnitDepts_remark")
		s startTime = result.Data("UnitDepts_start")
		s stop = result.Data("UnitDepts_stop")
		s unitDr = result.Data("UnitDepts_unitDr")
		s propertyDr = result.Data("UnitDepts_propertyDr")
		s active = result.Data("UnitDepts_active")
		
		i startTime'="" s startTime=$zd(startTime,3)
		i stop'="" s stop=$zd(stop,3)
		
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_address_"^"_remark_"^"_startTime_"^"_stop_"^"_unitDr_"^"_propertyDr_"^"_active
		//w searchValue
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "address")&(address'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
		.q:(searchField = "startTime")&(startTime'[searchValue)
		.q:(searchField = "stop")&(stop'[searchValue)
		.q:(searchField = "unitDr")&(unitDr'[searchValue)
		.q:(searchField = "propertyDr")&(propertyDr'[searchValue)
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
<StreamLocation>^dhc.ca.c.uUnitDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
