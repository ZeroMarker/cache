/// Creator: 王赢赢
/// CreatDate: 2009-9-24
/// Description: 单位
Class dhc.ca.cache.udata.uUnits Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 王赢赢
/// CreatDate: 2009-9-24
/// Description: 代码是否存在
/// Table：dhc.ca.cache.data.Units
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.ca.cache.udata.uUnits).IfRepCode("1")
ClassMethod IfRepCode(unitTypeDr, code) As %String
{
	n (unitTypeDr,code)
	s rowid=0
	s rowid=$o(^DHCCAUNITS(0,"UnittypeCode",unitTypeDr,code,rowid))		//zhw 修改为新增索引  增加unitTypeDr 20160816
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-24
/// Description: 名称是否存在
/// Table：dhc.ca.cache.data.Units
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uUnits).IfRepName("ss")
ClassMethod IfRepName(unitTypeDr, name) As %String
{
	n (unitTypeDr,name)
	s rowid=0
	s rowid=$o(^DHCCAUNITS(0,"UnittypeName",unitTypeDr,name,rowid))		//zhw 修改为新增索引  增加unitTypeDr 20160816
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-9-24
/// Description: 插入一条新单位数据
/// Table：dhc.ca.cache.data.Units
/// Input：code-代码;name-名称;address-地址;phone-电话;contact-联系人;remark-备注;unitTypeDr-单位类别Dr;active-有效;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnits).InsertRec(1,"name","address",010,"contact","remark",5,"")
ClassMethod InsertRec(code, name, address, phone, contact, remark, unitTypeDr, active) As %String
{
	
	n (code, name, address, phone, contact, remark, unitTypeDr, active)
	
	s rowid=0
	s rowid=..IfRepCode(unitTypeDr,code)	//zhw  增加unitTypeDr参数 20160816
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(unitTypeDr,name)	//zhw  增加unitTypeDr参数 20160816
	q:rowid>0 "RepName"
	
	s shortcut =code_"-"_name
	
	i (active'="Y")||(active'="N") s active="Y"
	&sql(insert into dhc_ca_cache_data.Units (Units_code,Units_name,Units_shortcut,Units_address,Units_phone,Units_contact,Units_remark,Units_unitTypeDr,Units_active) values(:code,:name,:shortcut,:address,:phone,:contact,:remark,:unitTypeDr,:active))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-9-24
/// Description: 更新记录
/// Table：dhc.ca.cache.data.Units
/// Input：rowId-所在行号;code-代码;name-名称;address-地址;phone-电话;contact-联系人;remark-备注;unitTypeDr-单位类别Dr;active-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnits).UpdateRec(1,2,"name1","","","","",6,"N")
ClassMethod UpdateRec(rowId, code, name, address, phone, contact, remark, unitTypeDr, active) As %String
{
	
	n (rowId, code, name, address, phone, contact, remark, unitTypeDr, active)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(unitTypeDr,code)		//zhw  增加unitTypeDr参数 20160816
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(unitTypeDr,name)		//zhw  增加unitTypeDr参数 20160816
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	s shortcut =code_"-"_name
	
	&sql(update dhc_ca_cache_data.Units set Units_code=:code,Units_name=:name,Units_shortcut=:shortcut,Units_address=:address,Units_phone=:phone,Units_contact=:contact,Units_remark=:remark,Units_unitTypeDr=:unitTypeDr,Units_active=:active where %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-24
/// Description: 删除记录
/// Table：dhc.ca.cache.data.Units
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uUnits).DelRec(1)
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.Units WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator: 王赢赢
/// CreatDate: 2009-9-24
/// Description: 查询符合条件的记录
/// Table：dhc.ca.cache.data.Units
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUnits).ListRec(1,"","","","rowId","DESC",0,25)
ClassMethod ListRec(unitTypeDr, active, searchField, searchValue, sortField, sortDir, start, limit)
{
	
	;q unitTypeDr_"^"_active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	n (unitTypeDr,active, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="SELECT Units_rowid,Units_code,Units_name,Units_shortcut,Units_address,Units_phone,Units_contact,Units_remark,Units_unitTypeDr,Units_active FROM dhc_ca_cache_data.Units"
	
	s whereStr=" WHERE %ID>0 AND Units_unitTypeDr="_unitTypeDr
	i (active="Y")||(active="N") s whereStr=whereStr_" AND Units_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowId" s sortField1="Units_rowid"
	.i sortField="code" s sortField1="Units_code"
	.i sortField="name" s sortField1="Units_name"
	.i sortField="shortcut" s sortField1="Units_shortcut"
	.i sortField="address" s sortField1="Units_address"
	.i sortField="phone" s sortField1="Units_phone"
	.i sortField="contact" s sortField1="Units_contact"
	.i sortField="remark" s sortField1="Units_remark"
	.i sortField="unitTypeDr" s sortField1="Units_unitTypeDr"
	.i sortField="active" s sortField1="Units_active"
	
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
	
	s jsonTitle="rowId^code^name^shortcut^address^phone^contact^remark^unitTypeDr^active"
	
	While(result.Next())
	{
		s rowId = result.Data("Units_rowid")
		s code = result.Data("Units_code")
		s name = result.Data("Units_name")
		s shortcut = result.Data("Units_shortcut")
		s address = result.Data("Units_address")
		s phone = result.Data("Units_phone")
		s contact = result.Data("Units_contact")
		s remark = result.Data("Units_remark")
		s unitTypeDr = result.Data("Units_unitTypeDr")
		s active = result.Data("Units_active")
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_address_"^"_phone_"^"_contact_"^"_remark_"^"_unitTypeDr_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "shortcut")&(shortcut'[searchValue)
		.q:(searchField = "address")&(address'[searchValue)
		.q:(searchField = "phone")&(phone'[searchValue)
		.q:(searchField = "contact")&(contact'[searchValue)
		.q:(searchField = "remark")&(remark'[searchValue)
		.q:(searchField = "unitTypeDr")&(unitTypeDr'[searchValue)
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
<StreamLocation>^dhc.ca.c.uUnitsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
