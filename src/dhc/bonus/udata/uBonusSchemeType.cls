Class dhc.bonus.udata.uBonusSchemeType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: wang ying
/// CreatDate: 2011-05-25
/// Description: 查询
/// Table：dhc_bonus_data.BonusSchemeType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusSchemeType).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT BonusSchemeTypeID,SchemeTypeCode,SchemeTypeName "_
	" from dhc_bonus_data.BonusSchemeType where  IsValid =1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusSchemeTypeID"
	.i sortField="code" s sortField1="SchemeTypeCode"
	.i sortField="name" s sortField1="SchemeTypeName"
	.i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY cast(SchemeTypeCode as int)"

	s sqlStr=sqlStr_sortStr
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
		
		s rowid = result.Data("BonusSchemeTypeID")
		s code = result.Data("SchemeTypeCode")
		s name = result.Data("SchemeTypeName")
		
		s tmp=rowid_"^"_code_"^"_name
		
		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
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

/// Creator: wang ying
/// CreatDate: 2011-05-25
/// Description: 插入一条新数据
/// Table： dhc_bonus_data.BonusSchemeType
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeType).InsertRec("1","科室核算方案")
ClassMethod InsertRec(code, name) As %String
{
	
	n (code,name)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	set isValid =1

	&sql(insert into dhc_bonus_data.BonusSchemeType (SchemeTypeCode,SchemeTypeName,IsValid) values(:code,:name,:isValid))
	q SQLCODE
}

ClassMethod IfRepName(name)
{
	new (name)
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusSchemeType
	WHERE SchemeTypeName=:name and IsValid=1)
	i sum="" d  s sum=0
	q sum
}

ClassMethod IfRepCode(code)
{
	new (code)
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusSchemeType
	WHERE SchemeTypeCode=:code and IsValid=1)
	i sum="" d  s sum=0
	q sum
}

ClassMethod UpRepName(rowId, name)
{
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusSchemeType
	WHERE SchemeTypeName=:name and IsValid=1 and BonusSchemeTypeID not in(:rowId))
	i sum="" d  s sum=0
	q sum
}

ClassMethod UpRepCode(rowId, code)
{
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusSchemeType
	WHERE SchemeTypeCode=:code and IsValid=1 and BonusSchemeTypeID not in(:rowId))
	i sum="" d  s sum=0
	q sum
}

/// Creator: wang ying
/// CreatDate: 2011-05-25
/// Description: 更新记录
/// Table： dhc_bonus_data.BonusSchemeType
/// Input：rowId-所在行号;code-代码;name-名称;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusSchemeType).UpdateRec(1,"01","科室核算方案","1")
ClassMethod UpdateRec(rowId, code, name) As %String
{
	
	n (rowId,code,name)
	
	s tmpRowid=0
	s tmpRowid=..UpRepCode(rowId,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..UpRepName(rowId,name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	&sql(update dhc_bonus_data.BonusSchemeType set SchemeTypeCode=:code,SchemeTypeName=:name where %ID=:rowId)
	q SQLCODE
}

/// Creator: guojing
/// CreatDate: 2016-08-08
/// Table：dhc_bonus_data.BonusScheme
ClassMethod IfRepSchemeType(schemetype) As %String
{
	new (schemetype)
	s sqlStr="SELECT * FROM dhc_bonus_data.BonusScheme WHERE SchemeType ='"_schemetype_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("BonusSchemeID")
	}
	q rowid
}

/// Creator: wang ying
/// CreatDate: 2011-05-25
/// Description: 删除记录
/// Table：dhc.bonus.udata.uBonusSchemeType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusSchemeType).Delete(1)
ClassMethod Delete(rowId) As %String
{
	s SchemeType=0
	s SchemeType=..IfRepSchemeType(rowId)
	q:SchemeType>0 "RepSchemeType"
	&sql(update dhc_bonus_data.BonusSchemeType set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusScheme673S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
