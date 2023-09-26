/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 科室分配规则
Class dhc.ca.cache.udata.uInDeptRules Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InDeptRules
/// Input: parRef-收入分配规则ID;deptDr-部门ID;percent-比率
/// Output: 
/// Return: 执行SQL语句返回SQLCODE
/// Others: 
ClassMethod InsertRec(parRef, deptDr, percent) As %String
{
	n (parRef, deptDr, percent)
	s resultStr=0
	&SQL(INSERT INTO dhc_ca_cache_data.InDeptRules (InDeptRules_parRef,InDeptRules_deptDr,InDeptRules_percent) VALUES (:parRef, :deptDr, :percent))
	s total=0
	s tmpDr=""
	f  s tmpDr=$o(^DHCCAINDISTRULE(parRef,"InDRules",tmpDr)) q:tmpDr=""  d
	.s total=total+$p($g(^DHCCAINDISTRULE(parRef,"InDRules",tmpDr)),"^",2)
	s resultStr=total
	i SQLCODE'=0 s resultStr="error"
	q resultStr
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InDeptRules
/// Input: parRef-收入分配规则ID,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: 
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, parRef)
	
	s sqlStr="SELECT InDeptRules_rowid,InDeptRules_deptDr,InDeptRules_percent FROM dhc_ca_cache_data.InDeptRules"
	
	s whereStr=" WHERE InDeptRules_childSub>0"
	i parRef'="" s whereStr=whereStr_" AND InDeptRules_parRef='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InDeptRules_rowid"
	.i sortField="deptName" s sortField1="InDeptRules_deptDr"
	.i sortField="percent" s sortField1="InDeptRules_percent"
	
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
	s jsonTitle="rowid^deptDr^deptName^percent"
	
	While(result.Next())
	{
		s rowid=result.Data("InDeptRules_rowid")
		s percent=result.Data("InDeptRules_percent")
		s deptDr=result.Data("InDeptRules_deptDr")
		s deptName=""
		i deptDr'="" d
		.i $d(^DHCCAUNITDEPTS(deptDr)) d
		..s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		
		s tmp=rowid_"^"_deptDr_"^"_deptName_"^"_percent
		
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2010-03-10
/// Description: 删除记录
/// Table: dhc.ca.cache.data.InDeptRules
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: 
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InDeptRules WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.UnitDepts
/// Input:  parRef-收入分配规则ID,unitDr-单元ID,active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUnitDepts).ListRec(1,"Y","","","","",0,25)
ClassMethod GetDepts(parRef, unitDr, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (parRef, unitDr,active, searchField, searchValue, sortField, sortDir, start, limit)
	
	i unitDr="" d
	.s unitId=0, flag=0
	.f  s unitId=$o(^DHCCAUNITS(unitId)) q:unitId=""  d
	..i flag=0 d
	...s unitDr=unitDr_"("_unitId
	...s flag=1
	..e  d
	...s unitDr=unitDr_","_unitId
	.s unitDr=unitDr_")"
	e  d
	.s unitDr="("_unitDr_")"
	s sqlStr="SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts"
	
	s whereStr=" WHERE %ID>0 AND UnitDepts_unitDr in"_unitDr
	i (active="Y")||(active="N") s whereStr=whereStr_" AND UnitDepts_active='"_active_"'"
	
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
	.s sortStr=" ORDER BY %ID DESC"
	
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
		
		s tmpDeptDr=""
		s tmpDeptDr=$o(^DHCCAINDISTRULE(0,"InDept",parRef,rowId,""))
		
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
		.i (count>=start)&(count<=end)&(tmpDeptDr="") d
		..d json.InsertRowData(tmp)
		..s count=count+1
		e  d
		.i (count>=start)&(count<=end)&(tmpDeptDr="") d
		..d json.InsertRowData(tmp)
		..s count=count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uInDeptRulesS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
