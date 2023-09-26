/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 核算单元类别
Class dhc.bonus.udata.uBonusUnitType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 代码是否存在
/// Table：dhc.bonus.data.BonusUnitType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusUnitType).IfRepCode("05")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	;s rowid=$o(^dhcbsBonusUnitTypeI("Code",code,rowid))
	&sql(SELECT BonusUnitTypeID into :rowid FROM dhc_bonus_data.BonusUnitType
	 WHERE UnitTypeCode=:code AND IsValid=1)
	 
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 名称是否存在
/// Table：dhc.bonus.data.BonusUnitType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uBonusUnitType).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	;s rowid=$o(^dhcbsBonusUnitTypeI("Name",name,rowid))
		&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.BonusUnitType
	 WHERE UnitTypeName=:name AND IsValid=1)
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 查询
/// Table：dhc.bonus.data.BonusUnitType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uBonusUnitType).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT BonusUnitTypeID,UnitTypeCode,UnitTypeName, "_
	"  IsDeptmentType,IsMedicalGroup,IsPersonType,IsValid  "_
	" from dhc_bonus_data.BonusUnitType where  IsValid =1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="BonusUnitTypeID"
	.i sortField="code" s sortField1="UnitTypeCode"
	.i sortField="name" s sortField1="UnitTypeName"
	.i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY cast(UnitTypeCode as int)"

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1

	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^IsDeptmentType^IsMedicalGroup^IsPersonType"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("BonusUnitTypeID")
		s code = result.Data("UnitTypeCode")
		s name = result.Data("UnitTypeName")
		s IsDeptmentType=result.Data("IsDeptmentType")
		s IsMedicalGroup=result.Data("IsMedicalGroup")
		s IsPersonType=result.Data("IsPersonType")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_IsDeptmentType_"^"_IsMedicalGroup_"^"_IsPersonType
		
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

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.BonusUnitType
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusUnitType).InsertRec("","","","","","","")
ClassMethod InsertRec(code, name, IsDeptmentType, IsMedicalGroup, IsPersonType) As %String
{
	
	n (code,name,IsDeptmentType,IsMedicalGroup,IsPersonType)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	set isValid =1

	&sql(insert into dhc_bonus_data.BonusUnitType (UnitTypeCode,UnitTypeName,IsDeptmentType,IsMedicalGroup,IsPersonType,IsValid) values(:code,:name,:IsDeptmentType,:IsMedicalGroup,:IsPersonType,:isValid))
	q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 更新记录
/// Table：dhc.bonus.data.BonusUnitType
/// Input：rowId-所在行号;code-代码;name-名称;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uBonusUnitType).UpdateRec(5,"05","外聘人员","0","0","1")
ClassMethod UpdateRec(rowId, code, name, IsDeptmentType, IsMedicalGroup, IsPersonType) As %String
{
	
	n (rowId,code,name,IsDeptmentType,IsMedicalGroup,IsPersonType)
	
	s tmpRowid=0
	s tmpRowid=..UpRepCode(rowId,code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..UpRepName(rowId,name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	&sql(update dhc_bonus_data.BonusUnitType set UnitTypeCode=:code,UnitTypeName=:name,IsDeptmentType=:IsDeptmentType,IsMedicalGroup=:IsMedicalGroup,IsPersonType=:IsPersonType where %ID=:rowId)
	q SQLCODE
}

ClassMethod UpRepCode(rowId, code) As %String
{
	new (rowId,code)
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusUnitType
	 WHERE UnitTypeCode=:code AND IsValid=1 and BonusUnitTypeID not in (:rowId))
	 
	i sum="" d  s sum=0
	q sum
}

ClassMethod UpRepName(rowId, name) As %String
{
	new (rowId,name)
	s sum=0
	&sql(SELECT count (*) into :sum FROM dhc_bonus_data.BonusUnitType
	 WHERE UnitTypeName=:name AND IsValid=1 and BonusUnitTypeID not in (:rowId))
	 
	i sum="" d  s sum=0
	q sum
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 删除记录
/// Table：dhc.bonus.data.BonusUnitType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uBonusUnitType).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(update dhc_bonus_data.BonusUnitType set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.ud5C1.uBonusUnitTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
