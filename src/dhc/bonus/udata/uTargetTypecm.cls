/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 奖金指标类别维护
Class dhc.bonus.udata.uTargetTypecm Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 代码是否存在
/// Table：dhc.bonus.data.TargetTypecm
/// Input: code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetTypecm).IfRepCode("001")
ClassMethod IfRepCode(code) As %String
{
	new (code)
	s rowid=0
	;s rowid=$o(^dhcbsTargetTypecmI("Code",code,rowid))
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.TargetTypecm
	WHERE TargetTypecmCode=:Code AND IsValid=1)
 
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 名称是否存在
/// Table：dhc.bonus.data.TargetTypecm
/// Input: name-名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetTypecm).IfRepName("医疗收入类")
ClassMethod IfRepName(name) As %String
{
	new (name)
	s rowid=0
	;s rowid=$o(^dhcbsTargetTypecmI("Name",name,rowid))
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.TargetTypecm
	WHERE TargetTypecmName=:Name AND IsValid=1)
	
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator: 陈明
/// CreatDate: 2016-2-25
/// Description: 描述是否存在
/// Table：dhc.bonus.data.TargetTypecm
/// Input: desc-描述名称
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others:w ##class(dhc.bonus.udata.uTargetTypecm).IfRepDesc("医疗资金收入")
ClassMethod IfRepDesc(desc) As %String
{
	new (desc)
	s rowid=0
	;s rowid=$o(^dhcbsTargetTypecmI("Desc",desc,rowid))
	&sql(SELECT count(*) into :rowid FROM dhc_bonus_data.TargetTypecm
	WHERE TargetTypecmDesc=:Desc AND IsValid=1)

	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：刘洋
/// CreatDate：2011-1-4
/// Description: 查询
/// Table：dhc.bonus.data.TargetTypecm
/// Input：searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数;
/// Output：
/// Return：返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uTargetTypecm).List("","","","",0,10)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)
	//SQL
	s sqlStr="SELECT TargetTypecmID,TargetTypecmCode,TargetTypecmName,TargetTypecmDesc from dhc_bonus_data.TargetTypecm where  IsValid =1"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="TargetTypecmID"
	.i sortField="code" s sortField1="TargetTypecmCode"
	.i sortField="name" s sortField1="TargetTypecmName"
	.i sortField="desc" s sortField1="TargetTypecmDesc"
	.i sortField="isValid" s sortField1="IsValid"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	;e  s sortStr=" ORDER BY TargetTypecmCode "

	s sqlStr=sqlStr_sortStr
	;w sqlStr,! 
			
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	
	s jsonTitle="rowid^code^name^desc^cname"
	

	//取结构
	While(result.Next()){
		
		s rowid = result.Data("TargetTypecmID")
		s code = result.Data("TargetTypecmCode")
		s name = result.Data("TargetTypecmName")
		s desc = result.Data("TargetTypecmDesc")			
		//s tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_valid
		s tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_code_":"_name_":"_desc

		i searchValue'="" d
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "desc")&(desc'[searchValue)
		
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
/// Table：dhc.bonus.data.TargetTypecm
/// Input：code-代码;name-名称;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uTargetTypecm).InsertRec("","")
ClassMethod InsertRec(code, name, desc) As %String
{
	
	n (code, name, desc)
	
	s rowid=0
	s rowid=..IfRepCode(code)
	q:rowid>0 "RepCode"
	s rowid=..IfRepName(name)
	q:rowid>0 "RepName"
	s rowid=..IfRepDesc(desc)
	q:rowid>0 "RepDesc"
	
	
	set isValid =1

	&sql(insert into dhc_bonus_data.TargetTypecm (TargetTypecmCode,TargetTypecmName,TargetTypecmDesc,IsValid) values(:code,:name,:desc,:isValid))
	q SQLCODE
}

/// Creator：刘洋
/// CreatDate：2011-1-4
/// Description: 更新记录
/// Table：dhc.bonus.data.TargetTypecm
/// Input：rowId-所在行号;code-代码;name-名称;valid-有效;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uTargetTypecm).UpdateRec(1,"","",)
ClassMethod UpdateRec(rowId, code, name, desc) As %String
{
	
	n (rowId, code, name, desc)
	
	s tmpRowid=0
	s tmpRowid=..IfRepCode(code)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepCode"
	s tmpRowid=0
	s tmpRowid=..IfRepName(name)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepName"
	s tmpRowid=0
	s tmpRowid=..IfRepDesc(desc)
	q:(tmpRowid'=0)&(tmpRowid'=rowId) "RepDesc"
	
	&sql(update dhc_bonus_data.TargetTypecm  set TargetTypecmCode=:code,TargetTypecmName=:name,TargetTypecmDesc=:desc where %ID=:rowId)
	q SQLCODE
}

/// Creator: 刘洋
/// CreatDate: 2011-1-4
/// Description: 删除记录
/// Table：dhc.bonus.data.TargetTypecm
/// Input：rowId-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uTargetTypecm).Delete(1)
ClassMethod Delete(rowId) As %String
{
	&sql(update dhc_bonus_data.TargetTypecm set IsValid=0 where %ID=:rowId)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uTargetTypecmS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
