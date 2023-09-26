/// Creator: 李明忠
/// CreatDate: 2011-11-14
/// Description: 导入文件类型
Class dhc.bonus.udata.uOnloadFileType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2011-11-14
/// Description:查询接口套记录
/// Table:dhc_bonus_data.OnloadFileType
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uOnloadFileType).List("fhq","","","","","",0,25)
ClassMethod List(userCode, fileType, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (userCode,fileType,searchField,searchValue,sortField,sortDir,start,limit)

	//s userId=47

	s sqlStr="select OnloadFileTypeID,FileTypeName,ConfigName,FileType from dhc_bonus_data.OnloadFileType"
	_" where %ID>0 AND  IsValid=1 and OnloadFileTypeID in (select OnloadFileTypeID from dhc_bonus_data.PersonOnloadFile"
	_" where %ID>0 AND UPPER(BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"'))"
	
	s sqlStr=sqlStr _" and TargetTable='dhc_bonus_data.BonusTargetCollect'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OnloadFileTypeID"
	.i sortField="name" s sortField1="FileTypeName"
	.i sortField="cfgname" s sortField1="ConfigName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	
	//w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next()){
		s rowid=result.Data("OnloadFileTypeID")
		s name=result.Data("FileTypeName")
		s cfgname=result.Data("ConfigName")
		s FileType=result.Data("FileType")
		;s name=cfgname_"-"_name
		
		s tmp=rowid_","_FileType_"^"_name
		
		i searchValue'="" d
		.q:(searchField = "name")&(name'[searchValue)
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

/// Others:w ##class(dhc.bonus.udata.uOnloadFileType).TargetList("dhc_bonus_module.BonusExpendItem","demo","1","","","","",0,25)
ClassMethod TargetList(Target, userCode, fileType, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (Target,userCode,fileType,searchField,searchValue,sortField,sortDir,start,limit)

	//s userId=47


	s sqlStr="select OnloadFileTypeID,FileTypeName,ConfigName,FileType from dhc_bonus_data.OnloadFileType"
	_" where %ID>0  and TargetTable='"_Target_"' AND  IsValid=1 and OnloadFileTypeID in (select OnloadFileTypeID from dhc_bonus_data.PersonOnloadFile"
	_" where %ID>0 AND UPPER(BonusEmployeeID->EmployeeCode)=UPPER('"_userCode_"'))"

	k ^cwtemp
	s ^cwtemp=sqlStr
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="OnloadFileTypeID"
	.i sortField="name" s sortField1="FileTypeName"
	.i sortField="cfgname" s sortField1="ConfigName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	
	s ^zlg11= sqlStr
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^name"
	
	While(result.Next()){
		s rowid=result.Data("OnloadFileTypeID")
		s name=result.Data("FileTypeName")
		s cfgname=result.Data("ConfigName")
		s FileType=result.Data("FileType")
		;s name=cfgname_"-"_name
		
		s tmp=rowid_","_FileType_"^"_name
		
		i searchValue'="" d
		.q:(searchField = "name")&(name'[searchValue)
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
<StreamLocation>^dhc.bonus.u5C1.uOnloadFileT5F4S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
