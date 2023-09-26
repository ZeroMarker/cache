/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 奖金指标类别维护
Class dhc.bonus.udata.uTargetType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 代码是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetType).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	;s rowid=0
	;s rowid=$o(^dhcbsTargetTypeI("Code",code,rowid))
	;&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.TargetType
	;WHERE TargetTypeCode=:Code AND IsValid=1)
	;i rowid="" d  s rowid=0
	;q rowid
	s sqlStr="SELECT * FROM dhc_bonus_data.TargetType WHERE IsValid =1 AND TargetTypeCode ='"_code_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("TargetTypeID")
	}
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 名称是否存在
/// Table：dhc.bonus.data.TargetType
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetType).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	;s rowid=0
	;s rowid=$o(^dhcbsTargetTypeI("Name",name,rowid))
	;&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.TargetType
	;WHERE TargetTypeName=:name AND IsValid=1)	
	;i rowid="" d  s rowid=0
	;q rowid
	
	s sqlStr="SELECT * FROM dhc_bonus_data.TargetType WHERE IsValid =1 AND TargetTypeName ='"_name_"'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("TargetTypeID")
	}
	q rowid
}

/// Creator：刘洋
/// CreatDate：2011-1-4
/// Description: 查询
/// Table：dhc.bonus.data.TargetType
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uTargetType).List("","","","",10,10)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT TargetTypeID,TargetTypeCode,TargetTypeName from dhc_bonus_data.TargetType where  IsValid =1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="TargetTypeID"
	.i sortField="code" s sortField1="TargetTypeCode"
	.i sortField="name" s sortField1="TargetTypeName"
	.i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	;e  s sortStr=" ORDER BY TargetTypeCode "

	s sqlStr=sqlStr_sortStr
	;w sqlStr,!
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^code^name^cname"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("TargetTypeID")
		s code = result.Data("TargetTypeCode")
		s name = result.Data("TargetTypeName")
					
		s tmp=rowid_"^"_code_"^"_name_"^"_code_":"_name
		
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
/// CreatDate：2011-1-4
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

	&sql(insert into dhc_bonus_data.TargetType (TargetTypeCode,TargetTypeName,IsValid) values(:code,:name,:isValid))
	q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-1-4
/// Description: 更新记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uTargetType).UpdateRec(1,"","",)
ClassMethod UpdateRec(rowId, code, name) As %String
{
	
	n (rowId, code, name)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	&sql(update dhc_bonus_data.TargetType set TargetTypeCode=:code,TargetTypeName=:name where %ID=:rowId)
	q SQLCODE
}

/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 删除记录
/// Table：dhc.bonus.data.TargetType
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uTargetType).Delete(1)
ClassMethod Delete(rowId) As %String
{
	s sum=0
	s sum=..IfRepItem(rowId)
	q:sum>0 "RepItemType"
	&sql(update dhc_bonus_data.TargetType set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

/// w ##class(dhc.bonus.udata.uTargetType).IfRepItem(4)
ClassMethod IfRepItem(ItemType)
{
	new (ItemType)
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_data.BonusTarget
	WHERE TargetTypeID=:ItemType and IsValid=1)
	i sum="" d  s sum=0
	q sum
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uTargetTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
