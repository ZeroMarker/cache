/// Creator: 杨旭
/// CreatDate: 2009-9-29
/// Description: 人员部门表维护
Class dhc.ca.cache.udata.uPersonDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 代码是否存在
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPersonDepts).IfRepDept("3","3")
ClassMethod IfRepDept(deptDr, perSon) As %String
{
	n (deptDr,perSon)
	s rowid=0
	s rowid=$o(^DHCCAUNITPERSONS(0,"DeptPersons",deptDr,perSon,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 验证百分比
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPersonDepts).CheckPercent("3")
ClassMethod CheckPercent(PersonDr) As %String
{
	n (PersonDr)
	s sqlStr="SELECT PersonDepts_parRef,PersonDepts_rowid,PersonDepts_deptDr,PersonDepts_rate,PersonDepts_inputPersonDr FROM dhc_ca_cache_data.PersonDepts WHERE %ID>0"
	
	i (PersonDr'="") s sqlStr=sqlStr_" AND PersonDepts_parRef ='"_PersonDr_"'"
	
	s result=##class(%Library.ResultSet).%New()
	
	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString=0
	
	While(result.Next())
	{
		
		s rate=result.Data("PersonDepts_rate")
		s resultString=resultString+rate
		
	}

	d result.Close()
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-9-25
/// Description: 验证行政归属是否存在
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: w ##class(dhc.ca.cache.udata.uPersonDepts).CheckOwn(2)
ClassMethod CheckOwn(PersonDr) As %String
{
	n (PersonDr)
	s sqlStr="SELECT PersonDepts_parRef,PersonDepts_rowid,PersonDepts_deptDr,PersonDepts_rate,PersonDepts_inputPersonDr,PersonDepts_own FROM dhc_ca_cache_data.PersonDepts WHERE %ID>0"
	
	i (PersonDr'="") s sqlStr=sqlStr_" AND PersonDepts_parRef ='"_PersonDr_"'"
	
	s result=##class(%Library.ResultSet).%New()

	d result.Prepare(sqlStr)
	d result.Execute()
	s resultString=1
	
	While(result.Next())
	{
		
		s own=result.Data("PersonDepts_own")
		i own="Y" d
		.s resultString=0
	}

	d result.Close()
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-9-29
/// Description: 查询符合条件的记录
/// Table: dhc.ca.cache.data.PersonDepts
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;active-有效标志;unitDr-单元DR
/// Output: 
/// Return: 返回查询到的记录的Json串
/// Others: w ##class(dhc.ca.cache.udata.uPersonDepts).ListRec("", "", "", "",0, 25, 17)
ClassMethod ListRec(searchField, searchValue, sortField, sortDir, start, limit, PersonDr)
{
	n (searchField, searchValue, sortField, sortDir, start, limit, PersonDr)
	
	s sqlStr="SELECT PersonDepts_parRef,PersonDepts_rowid,PersonDepts_deptDr,PersonDepts_rate,PersonDepts_inputPersonDr,PersonDepts_own FROM dhc_ca_cache_data.PersonDepts WHERE %ID>0"
	
	i (PersonDr'="") s sqlStr=sqlStr_" AND PersonDepts_parRef ='"_PersonDr_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="PersonDepts_rowid"
	.i sortField="deptName" s sortField1="PersonDepts_deptDr"
	.i sortField="rate" s sortField1="PersonDepts_rate"
	.i sortField="inputPersonName" s sortField1="PersonDepts_inputPersonDr"
	
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
	s jsonTitle="rowid^parRef^deptDr^deptCode^deptName^rate^inputPersonDr^inputPersonName^own"
	
	While(result.Next())
	{
		s rowid=result.Data("PersonDepts_rowid")
		s parRef=result.Data("PersonDepts_parRef")
		
		s deptDr=result.Data("PersonDepts_deptDr")
		s deptName=""
		s deptCode=""
		i deptDr'="" d
		.s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		.s deptCode=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",1)
		
		s rate=result.Data("PersonDepts_rate")
		s own=result.Data("PersonDepts_own")
		
		s inputPersonDr=result.Data("PersonDepts_inputPersonDr")
		s inputPersonName="" d
		i inputPersonDr'="" d
		.s inputPersonName=$p($g(^DHCCAUNITPERSONS(inputPersonDr)),"^",2)
	
		s tmp=rowid_"^"_parRef_"^"_deptDr_"^"_deptCode_"^"_deptName_"^"_rate_"^"_inputPersonDr_"^"_inputPersonName_"^"_own
		s count=count+1
		
		i searchValue'="" d
		.i (searchField="active") d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField="deptName")&(deptName'[searchValue)
		.q:(searchField="rate")&(rate'[searchValue)
		.q:(searchField="inputPersonName")&(inputPersonName'[searchValue)
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
		e  d
		.i (count>start)&(count<=end) d
		..d json.InsertRowData(tmp)
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator: 杨旭
/// CreatDate: 2009-9-29
/// Description: 插入新记录
/// Table: dhc.ca.cache.data.PersonDepts
/// Input: code-代码; name -名称;  gender-性别; birthday-出生日期; national-国家; birthPlace-籍贯; education-学历; title-职称; duty-职务; state-状态; preparation,-编制; phone-电话; remark-备注; start-入职时间; stop-离职时间;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.uPersonDepts).InsertRec(1, "0001", "测试1", "", "", "","","","","","","","","","","")
ClassMethod InsertRec(parRef, deptDr, rate, inputPersonDr, own) As %String
{
	n (parRef, deptDr, rate, inputPersonDr, own)
	
	q:parRef="" "EmptyParRef"
	q:deptDr="" "EmptyDeptDr"
	q:rate="" "EmptyRate"
	q:inputPersonDr="" "EmptyInputPersonDr"
	
	s rowid=0
	s rowid=..IfRepDept(deptDr,parRef)
	q:rowid>0 "RepDept"

	&SQL(INSERT INTO dhc_ca_cache_data.PersonDepts (PersonDepts_parRef,PersonDepts_deptDr,PersonDepts_rate,PersonDepts_inputPersonDr,PersonDepts_own) VALUES (:parRef, :deptDr, :rate, :inputPersonDr,:own))
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-9-29
/// Description: 更新记录
/// Table: dhc.ca.cache.data.UnitPersons
/// Input: rowid-数据行号;code-代码; name -名称;  gender-性别; birthday-出生日期; national-国家; birthPlace-籍贯; education-学历; title-职称; duty-职务; state-状态; preparation,-编制; phone-电话; remark-备注; start-入职时间; stop-离职时间; active-有效;
/// Output: 
/// Return: 代码为空,返回"EmptyCode";代码存在,返回"RepCode";名称为空,返回"EmptyName";名称存在,返回"RepName";执行SQL语句返回SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uPersonDepts).UpdateRec("3||1",3,3,1,29)
ClassMethod UpdateRec(rowid, parRef, deptDr, rate, inputPersonDr, own) As %String
{
	n (rowid, parRef, deptDr, rate, inputPersonDr, own)
	
	q:parRef="" "EmptyParRef"
	q:deptDr="" "EmptyDeptDr"
	q:rate="" "EmptyRate"
	q:inputPersonDr="" "EmptyInputPersonDr"
	
	s tmpRowid=0
	s tmpRowid=..IfRepDept(deptDr,parRef)
	q:(tmpRowid'=0)&(tmpRowid'=$p(rowid,"||",2)) "RepDept"

	&SQL(UPDATE dhc_ca_cache_data.PersonDepts SET PersonDepts_parRef=:parRef,PersonDepts_deptDr=:deptDr,PersonDepts_rate=:rate,PersonDepts_inputPersonDr=:inputPersonDr,PersonDepts_own=:own WHERE %ID=:rowid)
	
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-9-30
/// Description: 删除记录
/// Table: dhc.ca.cache.data.UnitPersons
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.ca.cache.udata.UnitPersons).DelRec(3)
ClassMethod DelRec(rowid) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.PersonDepts WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: 杨旭
/// CreatDate: 2009-11-12
/// Description: 获得用户DR
/// Table: dhc.ca.cache.data.VouchDatas
/// Input: userCode-用户代码;
/// Output: 
/// Return: 0为没有找到此用户,否则返回用户DR
/// Others: w ##class(dhc.ca.cache.udata.uVouchDatas).CheckUser(1)
ClassMethod CheckUser(userCode) As %String
{
	n (userCode)
	
	q:userCode="" 0
	s userDr =0
	s userDr=$o(^DHCCAUSERS(0,"Loginname",userCode,userDr))
	s personDr=0
	i userDr>0 d
	.s personDr=$p($g(^DHCCAUSERS(userDr)),"^",4)
	s flag="N"
	i personDr>0 d
	.s flag=$p($g(^DHCCAUNITPERSONS(personDr)),"^",18)
	i flag="" s flag="N"
	i flag="N" s personDr=0
	q personDr
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uPersonDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
