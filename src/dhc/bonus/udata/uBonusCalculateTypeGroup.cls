/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-14
/// Description: 奖金指标类别维护
Class dhc.bonus.udata.uBonusCalculateTypeGroup Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-14
/// Description: 代码是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusCalculateTypeGroup).IfRepCode("2014")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	
	;s rowid=$o(^dhcbsCalculateTypeGroupI("Code",code,rowid))
	
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusCalculateTypeGroup
	WHERE CalculateGrouupCode=:code AND IsValid=1)

	i rowid="" d  s rowid=0
	
	q rowid
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-14
/// Description: 名称是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetType).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	;s rowid=$o(^dhcbsCalculateTypeGroupI("Name",name,rowid))
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusCalculateTypeGroup
	WHERE CalculateGroupName=:name AND IsValid=1)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-14
/// Description: 查询
/// Table：dhc.bonus.data.TargetType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uTargetType).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT BonusCalculateTypeGroupID rowid, CalculateGrouupCode,CalculateGroupName  from dhc_bonus_data.BonusCalculateTypeGroup where  IsValid= 1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="code" s sortField1="TargetTypeCode"
	.i sortField="name" s sortField1="TargetTypeName"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY CalculateGrouupCode "

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
		
		s rowid = result.Data("rowid")
		s code = result.Data("CalculateGrouupCode")
		s name = result.Data("CalculateGroupName")
					
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

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-14
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.TargetType
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uTargetType).InsertRec("","")
ClassMethod InsertRec(code, name) As %String
{
	
	n (code, name)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	set isValid =1

	&sql(insert into dhc_bonus_data.BonusCalculateTypeGroup (CalculateGrouupCode,CalculateGroupName,IsValid) values(:code,:name,:isValid))
	q SQLCODE
}

/// Creator：Zhao LIGuo 
/// CreatDate：2011-11-14
/// Description: 更新记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uTargetType).UpdateRec(1,"","",)
ClassMethod UpdateRec(rowId, code, name) As %String
{
	
	n (rowId, code, name)
	
	//w rowId_"^"_code_"^"_name,!
	
	s tmpRowid=0
	s tmpRowid=..UpRepCode(rowId,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..UpRepName(rowId,name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	&sql(update dhc_bonus_data.BonusCalculateTypeGroup set CalculateGrouupCode=:code,CalculateGroupName=:name where %ID=:rowId)
	q SQLCODE
}

ClassMethod UpRepName(rowId, name)
{
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusCalculateTypeGroup
	WHERE CalculateGroupName=:name and IsValid=1 and BonusCalculateTypeGroupID not in(:rowId))
	i sum="" d  s sum=0
	q sum
}

ClassMethod UpRepCode(rowId, code)
{
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusCalculateTypeGroup
	WHERE CalculateGrouupCode=:code and IsValid=1 and BonusCalculateTypeGroupID not in(:rowId))
	i sum="" d  s sum=0
	q sum
}

/// Creator: Zhao LIGuo 
/// CreatDate: 2011-11-14
/// Description: 删除记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uTargetType).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(update dhc_bonus_data.BonusCalculateTypeGroup set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.u5C1.uBonusCalcul9B9S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
