/// Creator: zhaoliguo
/// CreatDate: 2011-7-10
/// Description: 科室权限设置
Class dhc.bonus.udata.uPersonOnloadFile Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhaoliguo
/// CreatDate: 2011-7-09
/// Description: 查询
/// Table：dhc.bonus.data.BonusEmployee
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uPersonOnloadFile).List("","","","",0,25)
/// Others:w ##class(dhc.bonus.udata.uPersonOnloadFile).List("EmployeeName","李强","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr=" select PersonOnloadFileID rowid,BonusEmployeeID,BonusEmployeeID->EmployeeName,OnloadFileTypeID,OnloadFileTypeID->FileTypeName,OnloadFileTypeID->ConfigName"
	s sqlStr= sqlStr _" ,case OnloadFileTypeID->FileType when 0  then'固定格式' when 1 then '指标横向扩张' when 2 then '指标纵向扩张' when 3 then '科室横向扩张'  else '无类型' end as FileTypeFlag" 
	s sqlStr= sqlStr _" from dhc_bonus_data.PersonOnloadFile where %ID>0 "
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="PersonOnloadFileID"
	.i sortField="EmployeeName" s sortField1=" BonusEmployeeID->EmployeeName"
	.i sortField="FileTypeFlag" s sortField1=" OnloadFileTypeID->FileType"
	.i sortField="FileTypeName" s sortField1=" OnloadFileTypeID->FileTypeName"
	
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" order by OnloadFileTypeID->FileType"

	s sqlStr=sqlStr_sortStr
	//w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^EmployeeID^EmployeeName^impFileID^impFileName^FileTypeName"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		s EmployeeID = result.Data("BonusEmployeeID")
		s EmployeeName = result.Data("EmployeeName")
		s impFileID = result.Data("OnloadFileTypeID")
		s impFileName=  result.Data("FileTypeName")
		s FileTypeName=  result.Data("FileTypeFlag")
		
		s ConfigName = result.Data("ConfigName")
		;OnloadFileTypeID->ConfigName
		
		s tmp=rowid_"^"_EmployeeID_"^"_EmployeeName_"^"_impFileID_"^"_impFileName_"_"_ConfigName_"^"_FileTypeName
		i searchField="name" s searchField="ConfigName"
		
		i searchValue'="" d
		.q:(searchField = "EmployeeName")&(EmployeeName'[searchValue)
		.q:(searchField = "ConfigName")&(ConfigName'[searchValue)
		
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

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusEmployee
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uPersonOnloadFile).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_data.PersonOnloadFile WHERE %ID=:rowid)
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-2-12
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusEmployee
/// Input：code-代码;name-名称;unitDr-单元Dr
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uPersonOnloadFile).InsertRec(1,5)
ClassMethod InsertRec(BonusEmpID, impFileID) As %String
{
	
	n (BonusEmpID, impFileID)
	
	s rowid=0
	s rowid=..IfRepCode(BonusEmpID, impFileID)
	q:rowid>0 "RepCode"

	&sql(insert into dhc_bonus_data.PersonOnloadFile (BonusEmployeeID, OnloadFileTypeID) values(:BonusEmpID,:impFileID))
	q SQLCODE
}

/// Creator: zhaoliguo
/// CreatDate: 2011-7-9
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusEmployee
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uPersonOnloadFile).IfRepCode(1,2)
ClassMethod IfRepCode(BonusEmpID, impFileID) As %String
{
	new (BonusEmpID, impFileID)
	s rowid=0
	s rowid=$o(^dhcbsPersonOnloadFileI("EmpFileIdx",BonusEmpID, impFileID,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: zhaoliguo
/// CreatDate: 2012-07-10
/// Description: 查询
/// Table：dhc_bonus_data.BonusScheme
/// Input：SchemeTypeID:奖金方案类型,start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uPersonOnloadFile).getimpFile(1,0,25)
ClassMethod getimpFile(fileType, start, limit) As %String
{
	n (fileType, start, limit)
	q:fileType=""

	s sqlStr="select %ID rowid,FileTypeName _'_'_ ConfigName sname from dhc_bonus_data.OnloadFileType "
		_" where FileType=  '"_fileType_"'"
		_" order by FileType"


	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("rowid")
		s code = ""
		s name = result.Data("sname")
		
		s tmp=rowid_"^"_code_"^"_name
		

		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}
		
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uPersonOnloa6C9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
