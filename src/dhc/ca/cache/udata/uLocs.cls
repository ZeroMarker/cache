/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 科室码表维护
Class dhc.ca.cache.udata.uLocs Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.Locs
/// Input: hosp-医院ID,code-科室代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uLocs).IfRepCode(1,"001")
ClassMethod IfRepCode(hosp, code) As %String
{
	n (hosp,code)
	s rowid=0
	s rowid=$o(^DHCCALOCS(0,"HospCode",hosp,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 名称是否存在
/// Table: dhc.ca.cache.data.Locs
/// Input: hosp-医院ID,name-科室名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uLocs).IfRepName(1,"001")
ClassMethod IfRepName(hosp, name) As %String
{
	n (hosp,name)
	s rowid=0
	s rowid=$o(^DHCCALOCS(0,"HospName",hosp,name,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.Locs
/// Input: code-代码,name-名称,tel-电话,location-位置,remark-备注,start-启用,end-停用,hosp-医院
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uLocs).InsertRec("0031","测试科室1","01062662153","门诊二楼","科室备注","1980-2-20","",1)
ClassMethod InsertRec(code, name, tel, location, remark, start, end, hosp) As %String
{
	n (code,name,tel,location,remark,start,end,hosp)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s rowid=0
	s rowid=..IfRepCode(hosp,code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(hosp,name)
	q:rowid>0 "RepName"
	
	s desc=code_"-"_name
	s active="Y"
	
	i start'="" s start=$zdh(start,3)
	i end'="" s end=$zdh(end,3)

	&SQL(INSERT INTO dhc_ca_cache_data.Locs (Locs_code,Locs_name,Locs_phones,Locs_location,Locs_remark,Locs_start_date,Locs_end_date,Locs_active,Locs_desc,Locs_hosp_dr) VALUES (:code,:name,:tel,:location,:remark,:start,:end,:active,:desc,:hosp))
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 更新记录
/// Table: dhc.ca.cache.data.Locs
/// Input: rowid-数据行号,code-代码,name-名称,tel-电话,location-位置,remark-备注,start-启用,end-停用,active-有效标志,hosp-医院
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uLocs).UpdateRec(4,"008","内科","01062662153","门诊3楼","备注","","","Y",1)
ClassMethod UpdateRec(rowid, code, name, tel, location, remark, start, end, active, hosp) As %String
{
	n (rowid,code,name,tel,location,remark,start,end,active,hosp)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(hosp,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(hosp,name)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepName"
	
	s desc=code_"-"_name
	
	i start'="" s start=$zdh(start,3)
	i end'="" s end=$zdh(end,3)
	
	&SQL(UPDATE dhc_ca_cache_data.Locs SET Locs_code=:code,Locs_name=:name,Locs_phones=:tel,Locs_location=:location,Locs_remark=:remark,Locs_start_date=:start,Locs_end_date=:end,Locs_active=:active,Locs_desc=:desc,Locs_hosp_dr=:hosp WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 删除记录
/// Table: dhc.ca.cache.data.Locs
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uLocs).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.Locs WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 许立新
/// CreatDate: 2009-8-16
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.Locs
/// Input: hosp-医院,active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uLocs).ListRec(1,"Y","sear","a","sort","sss",0,25)
ClassMethod ListRec(hosp, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	n (hosp,active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT Locs_rowid,Locs_code,Locs_name,Locs_phones,Locs_location,Locs_remark,Locs_start_date,Locs_end_date,Locs_active,Locs_desc,Locs_hosp_dr FROM dhc_ca_cache_data.Locs"
	
	s whereStr=" WHERE %ID>0 AND Locs_hosp_dr="_hosp
	i (active="Y")||(active="N") s whereStr=whereStr_" AND Locs_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="Rowid" s sortField1="Locs_rowid"
	.i sortField="Code" s sortField1="Locs_code"
	.i sortField="Name" s sortField1="Locs_name"
	.i sortField="Phone" s sortField1="Locs_phones"
	.i sortField="Addr" s sortField1="Locs_location"
	.i sortField="Remark" s sortField1="Locs_remark"
	.i sortField="Start" s sortField1="Locs_start_date"
	.i sortField="End" s sortField1="Locs_end_date"
	.i sortField="Active" s sortField1="Locs_active"
	
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
	s jsonTitle="Rowid^Code^Name^Phone^Addr^Remark^Start^End^Active^Desc^Hosp"
	
	While(result.Next())
	{
		s rowId=result.Data("Locs_rowid")
		s code=result.Data("Locs_code")
		s name=result.Data("Locs_name")
		s phone=result.Data("Locs_phones")
		s addr=result.Data("Locs_location")
		s remark=result.Data("Locs_remark")
		s startDate=result.Data("Locs_start_date")
		s endDate=result.Data("Locs_end_date")
		s active=result.Data("Locs_active")
		s desc=result.Data("Locs_desc")
		
		i startDate'="" s startDate=$zd(startDate,3)
		i endDate'="" s endDate=$zd(endDate,3)
		
		s tmp=rowId_"^"_code_"^"_name_"^"_phone_"^"_addr_"^"_remark_"^"_startDate_"^"_endDate_"^"_active_"^"_desc_"^"_hosp

		i searchValue'="" d
		.i searchField = "Active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="Code")&(code'[searchValue)
		.q:(searchField="Name")&(name'[searchValue)
		.q:(searchField="Phone")&(phone'[searchValue)
		.q:(searchField="Addr")&(addr'[searchValue)
		.q:(searchField="Remark")&(remark'[searchValue)
		.q:(searchField="Active")&(active'[searchValue)
		.q:(searchField="Desc")&(desc'[searchValue)
		.q:(searchField="Remark")&(remark'[searchValue)
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
<StreamLocation>^dhc.ca.c.uLocsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
