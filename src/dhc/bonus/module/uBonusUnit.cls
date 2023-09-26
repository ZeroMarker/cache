Class dhc.bonus.module.uBonusUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: zhoumabang
/// CreatDate: 2015-11-16
/// Description: 查询
/// Table：dhc_bonus_data.BonusSchemeType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.module.uBonusUnit).List("","","","",0,25,"急诊")
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit, str) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit,str)
	//SQL
	s sqlStr="SELECT BonusUnitID,BonusUnitCode,BonusUnitName "_
	" from dhc_bonus_data.BonusUnit where  IsValid =1"
	i str'="" s sqlStr = sqlStr_" and BonusUnitName like '%"_str_"%'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusUnitID"
	.i sortField="code" s sortField1="BonusUnitCode"
	.i sortField="name" s sortField1="BonusUnitName"
	.i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY cast(BonusUnitCode as int)"

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
		
		s rowid = result.Data("BonusUnitID")
		s code = result.Data("BonusUnitCode")
		s name = result.Data("BonusUnitName")
		
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
	s sl=0
	&sql(select count(*) into :sl from dhc_bonus_data.BonusSchemeType
	where  (SchemeTypeCode=:code or SchemeTypeName=:name) and IsValid=1
	)
	i sl="" s sl=0
	q:sl>0 "RepCode"
	
	set isValid =1

	&sql(insert into dhc_bonus_data.BonusSchemeType (SchemeTypeCode,SchemeTypeName,IsValid) values(:code,:name,:isValid))
	q SQLCODE
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
	//w rowId_"^"_code_"^"_name,!
	
	&sql(update dhc_bonus_data.BonusSchemeType set SchemeTypeCode=:code,SchemeTypeName=:name where %ID=:rowId)
	q SQLCODE
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
	&sql(update dhc_bonus_data.BonusSchemeType set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.module.uBonusUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
