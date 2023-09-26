/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 接口核算部门表维护
Class dhc.ca.cache.udata.uInPerson Extends %Persistent [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 序号是否存在
/// Table: dhc.ca.cache.data.PersonSets
/// Input: name-序号
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uInPerson).CheckRep(4788,2)
ClassMethod CheckRep(personDr, setDr) As %String
{
	n (personDr,setDr)
	s rowid=0
	s flag=0
	f  s rowid =$o(^DHCCAINPERSON(0,"InPerson",personDr,rowid)) q:rowid=""  d
	.s tmpSetDr=""
	.i rowid'=0 s tmpSetDr=$p($g(^DHCCAINPERSON(rowid)),"^",4)
	.i setDr=tmpSetDr s flag=tmpSetDr
	q flag
}

/// Creator: 杨旭
/// CreatDate: 2010-10-26
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.InPerson
/// Input: parRef-借口套ID; order-序号; deptDr-部门ID;
/// Output: 
/// Return: 
/// Others: w ##class(dhc.ca.cache.udata.uInPerson).InsertRec(3,1,4,1)
ClassMethod InsertRec(order, personDr, personSetsDr) As %String
{
	n (order, personDr, personSetsDr)

	&SQL(INSERT INTO dhc_ca_cache_data.InPerson(InPerson_order,InPerson_personDr,InPerson_personSetsDr) VALUES (:order, :personDr, :personSetsDr))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-10-22
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.InPerson
/// Input: active-有效标志,searchField-查询字段,searchValue-查询值,sortField-排序字段,sortDir-排序方向,Start-起始行,Limit-行数
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uInPerson).ListRec("","","","",0,25,1)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, parRef)
{
	n (parRef, searchField, searchValue, sortField, sortDir, start, limit)
	
	s sqlStr="  select InPerson_rowid,InPerson_order,InPerson_personDr,InPerson_personDr->UnitPersons_name as InPerson_personName,InPerson_personDr->UnitPersons_code as InPerson_personCode,InPerson_personSetsDr,InPerson_personSetsDr->PersonSets_name as InPerson_personSetsName,InPerson_personSetsDr->PersonSets_code as InPerson_personSetsCode,InPerson_outPersonDr,InPerson_outPersonDr->OutPerson_name as InPerson_outPersonName,InPerson_outPersonDr->OutPerson_code as InPerson_outPersonCode from dhc_ca_cache_data.InPerson"
	
	s whereStr=" where %ID>0"
	i parRef'="" s whereStr=whereStr_" AND InPerson_personSetsDr='"_parRef_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InPerson_rowid"
	.i sortField="personName" s sortField1="InPerson_personName"
	.i sortField="personCode" s sortField1="InPerson_personCode"
	
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
	s jsonTitle="rowid^order^personDr^personCode^personName^personSetsDr^personSetsCode^personSetsName^outPersonDr^outPersonCode^outPersonName"
	
	While(result.Next())
	{
		s rowid=result.Data("InPerson_rowid")
		s order=result.Data("InPerson_order")
		s personDr=result.Data("InPerson_personDr")
		s personCode=result.Data("InPerson_personCode")
		s personName=result.Data("InPerson_personName")
		s personSetsDr=result.Data("InPerson_personSetsDr")
		s personSetsCode=result.Data("InPerson_personSetsCode")
		s personSetsName=result.Data("InPerson_personSetsName")
		s outPersonDr=result.Data("InPerson_outPersonDr")
		s outPersonCode=result.Data("InPerson_outPersonCode")
		s outPersonName=result.Data("InPerson_outPersonName")
		
	
		s tmp=rowid_"^"_order_"^"_personDr_"^"_personCode_"^"_personName_"^"_personSetsDr_"^"_personSetsCode_"^"_personSetsName_"^"_outPersonDr_"^"_outPersonCode_"^"_outPersonName
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="name")&(personName'[searchValue)
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
/// CreatDate: 2009-9-25
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;active-有效标志;unitDr-单元DR
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUnitPersons).ListRec("", "", "", "",0, 25, 1, "Y")
ClassMethod UnitPerson(searchField, searchValue, sortField, sortDir, start, limit, unitDr, active, type, ownFlag, setDr)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, unitDr, active, type, ownFlag, setDr)
	
	s sqlStr="SELECT UnitPersons_rowid,UnitPersons_code,UnitPersons_name,UnitPersons_shortcut,UnitPersons_gender,UnitPersons_birthday,UnitPersons_national,UnitPersons_birthPlace,UnitPersons_education,UnitPersons_title,UnitPersons_duty,UnitPersons_state,UnitPersons_preparation,UnitPersons_phone,UnitPersons_remark,UnitPersons_start,UnitPersons_stop,UnitPersons_unitDr,UnitPersons_active FROM dhc_ca_cache_data.UnitPersons WHERE %ID>0"
	
	i (active="Y")||(active="N") s sqlStr=sqlStr_" AND UnitPersons_active ='"_active_"'"
	i (unitDr'="") s sqlStr=sqlStr_" AND UnitPersons_unitDr ='"_unitDr_"'"
	s tmpStr=""
	i ownFlag="Y" s tmpStr=" AND PersonDepts_own='Y'"
	i (type=0) s sqlStr=sqlStr_" AND %ID not in(select PersonDepts_parRef from dhc_ca_cache_data.PersonDepts where %ID>0 "_tmpStr_")"
	i (type>0) s sqlStr=sqlStr_" AND %ID in(select PersonDepts_parRef from dhc_ca_cache_data.PersonDepts where %ID>0 and PersonDepts_deptDr="_type_tmpStr_")"
	
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="UnitPersons_rowid"
	.i sortField="code" s sortField1="UnitPersons_code"
	.i sortField="name" s sortField1="UnitPersons_name"
	.i sortField="gender" s sortField1="UnitPersons_gender"
	.i sortField="birthday" s sortField1="UnitPersons_birthday"
	.i sortField="national" s sortField1="UnitPersons_national"
	.i sortField="birthPlace" s sortField1="UnitPersons_birthPlace"
	.i sortField="education" s sortField1="UnitPersons_education"
	.i sortField="title" s sortField1="UnitPersons_title"
	.i sortField="duty" s sortField1="UnitPersons_duty"
	.i sortField="state" s sortField1="UnitPersons_state"
	.i sortField="preparation" s sortField1="UnitPersons_preparation"
	.i sortField="phone" s sortField1="UnitPersons_phone"
	.i sortField="remark" s sortField1="UnitPersons_remark"
	.i sortField="start" s sortField1="UnitPersons_start"
	.i sortField="stop" s sortField1="UnitPersons_stop"
	.i sortField="unitName" s sortField1="UnitPersons_unitDr"
	.i sortField="active" s sortField1="UnitPersons_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_sortStr
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^shortcut^gender^birthday^national^birthPlace^education^title^duty^state^preparation^phone^remark^start^stop^unitDr^unitName^active"
	
	While(result.Next())
	{
		s rowid=result.Data("UnitPersons_rowid")
		s code=result.Data("UnitPersons_code")
		s name=result.Data("UnitPersons_name")
		s shortcut=result.Data("UnitPersons_shortcut")
		
		s gender=result.Data("UnitPersons_gender")
		i gender'="" d
		.i gender="M" s gender="男"
		.i gender="F" s gender="女"
		.i gender="N" s gender="未知"
		
		s birthday=result.Data("UnitPersons_birthday")
		i birthday'="" d
		.s birthday=$zd(birthday,3)
		
		s national=result.Data("UnitPersons_national")
		s birthPlace=result.Data("UnitPersons_birthPlace")
		s education=result.Data("UnitPersons_education")
		s title=result.Data("UnitPersons_title")
		s duty=result.Data("UnitPersons_duty")
		s state=result.Data("UnitPersons_state")
		s preparation=result.Data("UnitPersons_preparation")
		s phone=result.Data("UnitPersons_phone")
		s remark=result.Data("UnitPersons_remark")
		
		s startDate=result.Data("UnitPersons_start")
		i startDate'="" d
		.s startDate=$zd(startDate,3)
		
		s endDate=result.Data("UnitPersons_stop")
		i endDate'="" d
		.s endDate=$zd(endDate,3)
		
		s unitDr=result.Data("UnitPersons_unitDr")
		
		s unitName=""
		i unitDr'="" d
		.s unitName= $p($g(^DHCCAUNITS(unitDr)),"^",2)
		
		s active=result.Data("UnitPersons_active")
	
	
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_gender_"^"_birthday_"^"_national_"^"_birthPlace_"^"_education_"^"_title_"^"_duty_"^"_state_"^"_preparation_"^"_phone_"^"_remark_"^"_startDate_"^"_endDate_"^"_unitDr_"^"_unitName_"^"_active
		s tmpRs=..CheckRep(rowid,setDr)
		
		i tmpRs=0 d
		.i (count>=start)&(count<end) d
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
/// Description: 删除记录
/// Table: dhc.ca.cache.data.OutDepts
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.OutDepts).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.InPerson WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<Data name="uInPersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uInPersonD</DataLocation>
<DefaultData>uInPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.ca.c.uInPersonD</IdLocation>
<IndexLocation>^dhc.ca.c.uInPersonI</IndexLocation>
<StreamLocation>^dhc.ca.c.uInPersonS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
