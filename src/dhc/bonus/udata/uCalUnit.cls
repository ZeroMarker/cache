/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 计量单位
Class dhc.bonus.udata.uCalUnit Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 代码是否存在
/// Table：dhc.bonus.data.CalUnit
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uCalUnit).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s sqlStr="SELECT * FROM dhc_bonus_data.CalUnit WHERE CalUnitCode='"_code_"' AND IsValid =1 "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("CalUnitID")
	}
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 名称是否存在
/// Table：dhc.bonus.data.CalUnit
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uCalUnit).IfRepName("测试")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s sqlStr="SELECT * FROM dhc_bonus_data.CalUnit WHERE CalUnitName='"_name_"' AND IsValid =1 "
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	s rowid=0
	While(result.Next()){
		s rowid=result.Data("CalUnitID")
	}
	q rowid
}

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 查询
/// Table：dhc.bonus.data.CalUnit
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uCalUnit).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT CalUnitID,CalUnitCode,CalUnitName from dhc_bonus_data.CalUnit where  IsValid ="_1_""
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="CalUnitID"
	.i sortField="code" s sortField1="CalUnitCode"
	.i sortField="name" s sortField1="CalUnitName"
	.i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  s sortStr=" ORDER BY %ID DESC"

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
		
		s rowid = result.Data("CalUnitID")
		s code = result.Data("CalUnitCode")
		s name = result.Data("CalUnitName")
					
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

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 插入一条新数据
/// Table：dhc.bonus.data.CalUnit
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uCalUnit).InsertRec("ccc","ccc")
ClassMethod InsertRec(code, name) As %String
{
	
	n (code, name)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	
	set isValid =1

	&sql(insert into dhc_bonus_data.CalUnit (CalUnitCode,CalUnitName,IsValid) values(:code,:name,:isValid))
	q SQLCODE
	
	
	/*
	s obj = ##Class(dhc.bonus.data.CalUnit).%New()
	s obj.CalUnitCode=code
	s obj.CalUnitName=name
	s obj.IsValid=1
	
	s rs = obj.%Save()*/
}

/// Creator：刘洋
/// CreatDate：2011-1-17
/// Description: 更新记录
/// Table：dhc.bonus.data.CalUnit
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uCalUnit).UpdateRec(13,"13","测试")
ClassMethod UpdateRec(rowId, code, name) As %String
{
	
	n (rowId, code, name)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	
	&sql(update dhc_bonus_data.CalUnit set CalUnitCode=:code,CalUnitName=:name where %ID=:rowId)
	q SQLCODE
}

/// Creator: 刘洋
/// CreatDate: 2011-1-17
/// Description: 删除记录
/// Table：dhc.bonus.data.CalUnit
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uCalUnit).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(update dhc_bonus_data.CalUnit set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uCalUnitS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
