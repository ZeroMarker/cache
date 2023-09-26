/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 单位人员码表维护
Class dhc.ca.cache.udata.uUnitPersons Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uUnitPersons).IfRepCode("1001")
ClassMethod IfRepCode(unitDr, code) As %String
{
	n (unitDr, code)
	s rowid=0
	s rowid=$o(^DHCCAUNITPERSONS(0,"UnitCode",unitDr,code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: code-代码; name -名称;  gender-性别; birthday-出生日期; national-国家; birthPlace-籍贯; education-学历; title-职称; duty-职务; state-状态; preparation,-编制; phone-电话; remark-备注; start-入职时间; stop-离职时间;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uUnitPersons).InsertRec(1, "0001", "测试1", "", "", "","","","","","","","","","","")
ClassMethod InsertRec(unitDr, code, name, gender, birthday, national, birthPlace, education, title, duty, state, preparation, phone, remark, start, stop) As %String
{
	n (unitDr ,code, name, gender, birthday, national,birthPlace,education,title,duty,state,preparation, phone, remark, start, stop)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	i birthday'="" s birthday=$zdh(birthday,3)
	i start'="" s start=$zdh(start,3)
	i stop'="" s stop=$zdh(stop,3)
	
	i gender="" s gender="N"
	
	s rowid=0
	s rowid=..IfRepCode(unitDr,code)
	q:rowid>0 "RepCode"
	
	s active="Y"
	
	s shortcut=code_"-"_name
	&SQL(INSERT INTO dhc_ca_cache_data.UnitPersons (UnitPersons_code,UnitPersons_name,UnitPersons_shortcut,UnitPersons_gender,UnitPersons_birthday,UnitPersons_national,UnitPersons_birthPlace,UnitPersons_education,UnitPersons_title,UnitPersons_duty,UnitPersons_state,UnitPersons_preparation,UnitPersons_phone,UnitPersons_remark,UnitPersons_start,UnitPersons_stop,UnitPersons_unitDr,UnitPersons_active) VALUES (:code,:name,:shortcut,:gender,:birthday,:national,:birthPlace,:education,:title,:duty,:state,:preparation,:phone,:remark,:start,:stop,:unitDr,:active))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;active-有效标志;unitDr-单元DR
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uUnitPersons).ListRec("","", "", "", 0,10,"", "Y", 1, "Y")
/// Refresh(acction=list): w ##class(dhc.ca.cache.udata.uUnitPersons).ListRec("","", "rowid", "ASC", 0,25,1,"","","")
/// Refresh: 刷新添加用户维护时 w ##class(dhc.ca.cache.udata.uUnitPersons).ListRec("","", "name", "DESC", 0,25,1,"","","")
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, unitDr, active, type, ownFlag)
{
	;q searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit_"^"_unitDr_"^"_active_"^"_type_"^"_ownFlag
	n (searchField, searchValue, sortField, sortDir, start, limit, unitDr, active, type, ownFlag)
	
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
		
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="code")&(code'[searchValue)
		.q:(searchField="name")&(name'[searchValue)
		.q:(searchField="shortcut")&(shortcut'[searchValue)
		.q:(searchField="gender")&(gender'[searchValue)
		.q:(searchField="birthday")&(birthday'[searchValue)
		.q:(searchField="national")&(national'[searchValue)
		.q:(searchField="birthPlace")&(birthPlace'[searchValue)
		.q:(searchField="education")&(education'[searchValue)
		.q:(searchField="title")&(title'[searchValue)
		.q:(searchField="duty")&(duty'[searchValue)
		.q:(searchField="state")&(state'[searchValue)
		.q:(searchField="preparation")&(preparation'[searchValue)
		.q:(searchField="phone")&(phone'[searchValue)
		.q:(searchField="remark")&(remark'[searchValue)
		.q:(searchField="startDate")&(startDate'[searchValue)
		.q:(searchField="endDate")&(endDate'[searchValue)
		.q:(searchField="unitName")&(unitName'[searchValue)
		.q:(searchField="active")&(active'[searchValue)
		.i (count>=start)&(count<end) d
		..d json.InsertRowData(tmp)
		.s count=count+1
		e  d
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
/// CreatDate: 2009-9-25
/// Description: 更新记录
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: rowid-数据行号;code-代码; name -名称;  gender-性别; birthday-出生日期; national-国家; birthPlace-籍贯; education-学历; title-职称; duty-职务; state-状态; preparation,-编制; phone-电话; remark-备注; start-入职时间; stop-离职时间; active-有效;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uUnitPersons).UpdateRec(1,1, "0001", "测试1", "", "", "","","","","","","","","","","","Y")
ClassMethod UpdateRec(rowid, unitDr, code, name, gender, birthday, national, birthPlace, education, title, duty, state, preparation, phone, remark, start, stop, active) As %String
{
	n (rowid, unitDr, code, name, gender, birthday, national, birthPlace, education, title, duty, state, preparation, phone, remark, start, stop, active)
	
	q:code="" "EmptyCode"
	q:name="" "EmptyName"
	
	s shortcut=code_"-"_name
	
	i birthday'="" s birthday=$zdh(birthday,3)
	i start'="" s start=$zdh(start,3)
	i stop'="" s stop=$zdh(stop,3)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(unitDr,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowid) "RepCode"

	&SQL(UPDATE dhc_ca_cache_data.UnitPersons SET UnitPersons_code=:code,UnitPersons_name=:name,UnitPersons_shortcut=:shortcut,UnitPersons_gender=:gender,UnitPersons_birthday=:birthday,UnitPersons_national=:national,UnitPersons_birthPlace=:birthPlace,UnitPersons_education=:education,UnitPersons_title=:title,UnitPersons_duty=:duty,UnitPersons_state=:state,UnitPersons_preparation=:preparation,UnitPersons_phone=:phone,UnitPersons_remark=:remark,UnitPersons_start=:start,UnitPersons_stop=:stop,UnitPersons_unitDr=:unitDr,UnitPersons_active=:active WHERE %ID=:rowid)
	
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uUnitPersonsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
