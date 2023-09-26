/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 接口核算部门表维护
Class dhc.ca.cache.udata.uInDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 部门是否存在
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: parRef-借口套ID;deptDr-部门ID
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:  w ##class(dhc.ca.cache.udata.uInDepts).IfRepDept(1,460)
ClassMethod IfRepDept(parRef, deptDr) As %String
{
	n (parRef, deptDr)
	s rowid=0
	s rowid=$o(^DHCCAINDEPTSETS(0,"InDept",parRef,deptDr,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.InDeptSets
/// Input: parRef-借口套ID;order-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef, order)
	s rowid=0
	s rowid=$o(^DHCCAINDEPTSETS(0,"InOrder",parRef,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDepts
/// Input: parRef-借口套ID; order-序号; deptDr-部门ID;
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.uInDepts).InsertRec(3,1,4)
ClassMethod InsertRec(parRef, order, deptDr) As %String
{
	n (parRef, order, deptDr)
	
	q:order="" "EmptyOrder"
	q:deptDr="" "EmptyDeptDr"
	
	s rowid=0
	s rowid=..IfRepOrder(parRef,order)
	q:rowid>0 "RepOrder"
	s rowid=..IfRepDept(parRef,deptDr)
	q:rowid>0 "RepDept"
	
	&SQL(INSERT INTO dhc_ca_cache_data.InDepts(InDepts_parRef,InDepts_order,InDepts_deptDr) VALUES (:parRef,:order,:deptDr))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 更新记录
/// Table: dhc.ca.cache.data.InDepts
/// Input: rowid-数据行号;parRef-借口套ID; order-序号; deptDr-部门ID;
/// Output: 
/// Return: 
/// Others：w ##class(dhc.ca.cache.udata.uInDepts).UpdateRec(1,"12","22","33","Y","Y")
ClassMethod UpdateRec(rowid, parRef, order, deptDr) As %String
{
	n (rowid, parRef, order, deptDr)
	
	q:order="" "EmptyOrder"
	q:deptDr="" "EmptyDeptDr"
	
	s tmpRowid=0
	s tmpRowid=..IfRepOrder(parRef,order)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowid,"||",2)) "RepOrder"
	s tmpRowid=0
	s tmpRowid=..IfRepDept(parRef,deptDr)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowid,"||",2)) "RepDept"

	&SQL(UPDATE dhc_ca_cache_data.InDepts SET InDepts_order=:order,InDepts_deptDr=:deptDr WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInDepts).ListRec("","","RowId","DESC",0,25,1)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_parRef
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT ind.InDepts_rowid,ind.InDepts_order,ind.InDepts_deptDr,ud.UnitDepts_rowid,ud.UnitDepts_code,ud.UnitDepts_name FROM dhc_ca_cache_data.InDepts as ind,dhc_ca_cache_data.UnitDepts as ud where ind.InDepts_deptDr=ud.UnitDepts_rowid"
	
	s whereStr=" and ind.InDepts_childSub>0"
	i parRef'="" s whereStr=whereStr_" AND ind.InDepts_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="ind.InDepts_rowid"
	.i sortField="order" s sortField1="ind.InDepts_order"
	.i sortField="deptName" s sortField1="ud.UnitDepts_name"
	.i sortField="deptCode" s sortField1="ud.UnitDepts_code"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY ind.InDepts_childSub DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	//w sqlStr,!
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^order^deptDr^deptCode^deptName^unitDr^unitName^unitTypeDr^unitTypeName"
	
	While(result.Next())
	{
		s rowid=result.Data("InDepts_rowid")
		s order=result.Data("InDepts_order")
		s deptDr=result.Data("InDepts_deptDr")
		s deptCode=""
		s deptName=""
		s shortcut=""
		s unitDr=""
		s unitName=""
		s unitTypeDr=""
		s unitTypeName=""
		i deptDr'="" d
		.s deptCode=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",1)
		.s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		.;s deptNameSZM=##class(dhc.ca.cache.udata.uCommon).GetCNCODE(deptName,4,"")  //zjw 20160108 取汉字首字母
		.s unitDr=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",8)
		.i unitDr'="" d
		..s unitName=$p($g(^DHCCAUNITS(unitDr)),"^",2)
		..s unitTypeDr=$p($g(^DHCCAUNITS(unitDr)),"^",8)
		..i unitTypeDr'="" d
		...s unitTypeName=$p($g(^DHCCAUNITTYPES(unitTypeDr)),"^",2)
	
	
		s tmp=rowid_"^"_order_"^"_deptDr_"^"_deptCode_"^"_deptName_"^"_unitDr_"^"_unitName_"^"_unitTypeDr_"^"_unitTypeName
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="order")&(order'[searchValue)
		.q:(searchField="code")&(deptCode'[searchValue)
		.q:(searchField="name")&(deptName'[searchValue)&(deptCode'[searchValue)   //&(deptNameSZM'[$ZCONVERT(searchValue,"u"))   //zjw 20151231 补加 &(deptCode'[searchValue)
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
/// CreatDate: 2009-10-22
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input: active-有效标志;parRef-借口套ID; unitDr-单位ID
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUnitDepts).ListRec(1,"Y","","","","",0,25)
ClassMethod InsertRecByUnit(parRef, unitDr, active)
{
	TSTART
	n (parRef, unitDr, active)
	
	s sqlStr="SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts"
	
	s whereStr=" WHERE %ID>0 "
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitDepts_active='"_active_"'"
	i unitDr'="" d  s whereStr=whereStr_"AND UnitDepts_unitDr ='"_unitDr_"'"
	
	s sqlStr=sqlStr_whereStr
	
	s result=##class(%Library.ResultSet).%New()
	

	d result.Prepare(sqlStr)
	d result.Execute()
	s rs=0
	
	While(result.Next())
	{
		s rowId = result.Data("UnitDepts_rowid")
		s tmpId=""
		s tmpId=$o(^DHCCAINDEPTSETS(0,"InDept",parRef,rowId,tmpId))
		i tmpId="" d
		.&SQL(INSERT INTO dhc_ca_cache_data.InDepts(InDepts_parRef,InDepts_deptDr) VALUES (:parRef,:rowId))
		.i SQLCODE'=0  s rs=SQLCODE
	}
	d result.Close()
	i rs'=0 d
	.TROLLBACK
	e  d
	.TCOMMIT
	q rs
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 删除记录
/// Table: dhc.ca.cache.data.UnitDepts
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uLocs).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDepts WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-28
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInDepts).ListInDept(1,"","Y","shortout","","","",0,10)
ClassMethod ListInDept(parRef, unitDr, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	;q parRef_"^"_unitDr_"^"_active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (parRef,unitDr,active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts"
	s whereStr=" WHERE %ID>0 "
	i unitDr'="" d
	.s whereStr=whereStr_" AND UnitDepts_unitDr ='"_unitDr_"'"
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitDepts_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	
	;w sqlStr,!
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
		s type =""
		s type = ..IfRepDept(parRef, rowId)
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_address_"^"_remark_"^"_startTime_"^"_stop_"^"_unitDr_"^"_propertyDr_"^"_active
		i searchValue'="" d
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.i (count>=start)&(count<=end)&(type=0) d
		..d json.InsertRowData(tmp)
		.i type=0 d
		..s count=count+1
		e  d
		.i (count>=start)&(count<=end)&(type=0) d
		..d json.InsertRowData(tmp)
		.i type=0 d
		..s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// 沙朋 20140916
/// Others: w ##class(dhc.ca.cache.udata.uInDepts).ListInDepts(1,"",0,10)
ClassMethod ListInDepts(parRef, str, start, limit) As %String [ SqlProc ]
{
	n (parRef,str,start,limit)
	;s ^tempzjw($j,"zjw0916")=str
	;zn "dhc-data" 
	;s str=$$ALPHAUP^SSUTIL4(str)  //s str=$$lower^SSUTIL4(str)
    ;zn "dhc-app"
	;s ^tempzjw($j,"zjw0917")=str
	s sqlStr="SELECT InDepts_rowid,InDepts_order,InDepts_deptDr,InDepts_deptDr->UnitDepts_code,InDepts_deptDr->UnitDepts_name FROM dhc_ca_cache_data.InDepts  where InDepts_deptDr>0 "
	
	s whereStr=" and InDepts_childSub>0"
	i parRef'="" s whereStr=whereStr_" AND InDepts_parRef='"_parRef_"'"
	i str'="" s whereStr=whereStr_" and lower(InDepts_deptDr->UnitDepts_code||'-'||InDepts_deptDr->UnitDepts_name) like lower('%"_str_"%')"
    s sortStr=" ORDER BY InDepts_childSub DESC"
    s sqlStr=sqlStr_whereStr_sortStr
    ;w sqlStr,!
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^shortcut"
	While(result.Next())
	{
		s rowid=result.Data("InDepts_rowid")
		s code=result.Data("UnitDepts_code")
		s name=result.Data("UnitDepts_name")
		s shortcut= code_"-"_name
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
    d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
