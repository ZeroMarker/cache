/// Creator: 李明忠
/// CreatDate: 2010-11-10
/// Description: 接口套维护
Class dhc.bonus.udata.uInterLocSet Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-11-10
/// Description:查询接口套记录
/// Table:dhc_bonus_inter.InterLocSet
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.bonus.udata.uInterLocSet).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterLocSet_rowid,InterLocSet_order,InterLocSet_code,InterLocSet_name,InterLocSet_shortcut,InterLocSet_desc ,InterLocSet_active "
	 _", InterLocSet_type typeID,case InterLocSet_type when 1 then '奖金指标接口'  when 2 then '收入数据接口' when 3 then '支出工作量' end as typeName"
	 _" from dhc_bonus_inter.InterLocSet where %ID>0"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterLocSet_rowid"
	.i sortField="order" s sortField1="InterLocSet_order"
	.i sortField="code" s sortField1="InterLocSet_code"
	.i sortField="name" s sortField1="InterLocSet_name"
	.i sortField="shortcut" s sortField1="InterLocSet_shortcut"
	.i sortField="desc" s sortField1="InterLocSet_desc"
	.i sortField="active" s sortField1="InterLocSet_active"
	.i sortField="typeName" s sortField1="InterLocSet_type"
	
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
	s jsonTitle="rowid^order^code^name^shortcut^desc^active^typeID^typeName"
	
	While(result.Next()){
		s rowid=result.Data("InterLocSet_rowid")
		s order=result.Data("InterLocSet_order")
		s code=result.Data("InterLocSet_code")
		s name=result.Data("InterLocSet_name")
		s shortcut=result.Data("InterLocSet_shortcut")
		s desc=result.Data("InterLocSet_desc")
		s active=result.Data("InterLocSet_active")

		s typeID=result.Data("typeID")
		s typeName=result.Data("typeName")
		
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active_"^"_typeID_"^"_typeName
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "desc")&(desc'[searchValue)
		.q:(searchField = "typeID")&(typeID'[searchValue)
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

ClassMethod List1(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterLocSet_rowid,InterLocSet_order,InterLocSet_code,InterLocSet_name,InterLocSet_shortcut,InterLocSet_desc ,InterLocSet_active "
	 _", InterLocSet_type typeID,case InterLocSet_type when 1 then '奖金指标接口'  when 2 then '收入数据接口' when 3 then '支出工作量' end as typeName"
	 _" from dhc_bonus_inter.InterLocSet where %ID>0 and InterLocSet_active='Y'"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterLocSet_rowid"
	.i sortField="order" s sortField1="InterLocSet_order"
	.i sortField="code" s sortField1="InterLocSet_code"
	.i sortField="name" s sortField1="InterLocSet_name"
	.i sortField="shortcut" s sortField1="InterLocSet_shortcut"
	.i sortField="desc" s sortField1="InterLocSet_desc"
	.i sortField="active" s sortField1="InterLocSet_active"
	.i sortField="typeName" s sortField1="InterLocSet_type"
	
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
	s jsonTitle="rowid^order^code^name^shortcut^desc^active^typeID^typeName"
	
	While(result.Next()){
		s rowid=result.Data("InterLocSet_rowid")
		s order=result.Data("InterLocSet_order")
		s code=result.Data("InterLocSet_code")
		s name=result.Data("InterLocSet_name")
		s shortcut=result.Data("InterLocSet_shortcut")
		s desc=result.Data("InterLocSet_desc")
		s active=result.Data("InterLocSet_active")

		s typeID=result.Data("typeID")
		s typeName=result.Data("typeName")
		
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active_"^"_typeID_"^"_typeName
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "desc")&(desc'[searchValue)
		.q:(searchField = "typeID")&(typeID'[searchValue)
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

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 判断接口套代码是否存在
/// Table：
/// Input：Code-接口套代码
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.bonus.udata.uInterLocSet).IfRepCode("s001")
ClassMethod IfRepCode(Code) As %String
{
	n (Code)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocSet
	WHERE InterLocSet_code=:Code and InterLocSet_active='Y')
	i sum="" d  s sum=0
	q sum
}

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 判断接口套名称是否存在
/// Table：
/// Input：Name-接口套名称
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.bonus.udata.uInterLocSet).IfRepName("HIS")
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocSet
	WHERE InterLocSet_name=:Name and InterLocSet_active='Y')
	i sum="" d  s sum=0
	q sum
}

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 添加接口套记录
/// Table：dhc_bonus_inter.InterLocSet
/// Input：Order-接口套顺序;Code-接口套代码;Name-接口套名称;Desc-接口套描述
/// Output：
/// Return：代码重复返回RepCode,名称重复返回RepName,否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uInterLocSet).Insert(8,12,12,"sddd")
ClassMethod Insert(Order, Code, Name, Desc, type) As %String
{
	n (Order,Code,Name,Desc,type)
	
	s sum=""
	s sum=..IfRepCode(Code)
	q:sum>0 "RepCode"
	s sum=..IfRepName(Name)
	q:sum>0 "RepName"
	
	s Active="Y"
	s ShortCut=Code_"-"_Name
	
	&SQL(Insert Into dhc_bonus_inter.InterLocSet(InterLocSet_order,InterLocSet_code,InterLocSet_name,InterLocSet_shortcut,InterLocSet_desc,InterLocSet_active,InterLocSet_type) VAlUES(:Order,:Code,:Name,:ShortCut,:Desc,:Active,:type))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-11-10
/// Description: 更新接口套记录
/// Table：dhc_bonus_inter.InterLocSet
/// Input：Rowid-记录的ID;Order-接口套顺序;Code-接口套代码;Name-接口套名称;Desc-接口套描述;Active-接口套记录有效标志
/// Output：
/// Return：代码重复返回RepCode，名称重复返回RepName,否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.bonus.udata.uInterLocSet).Update(7,8,12,12,12,"Y")
ClassMethod Update(Rowid, Order, Code, Name, Desc, Active, type) As %String
{
	n (Rowid,Order,Code,Name,Desc,Active,type)
	
	s sum=""
	s sum=..UpRepCode(Rowid,Code)
	q:(sum'=0)&(sum'=Rowid) "RepCode"    
	s sum=..UpRepName(Name)
	q:(sum'=0)&(sum'=Rowid) "RepName"
	
	s ShortCut=Code_"-"_Name
	
	&SQL(update dhc_bonus_inter.InterLocSet set InterLocSet_order=:Order,InterLocSet_code=:Code,InterLocSet_name=:Name,InterLocSet_shortcut=:ShortCut,InterLocSet_desc=:Desc,InterLocSet_active=:Active ,InterLocSet_type=:type where %ID=:Rowid)
	q SQLCODE
}

/// Others：w ##class(dhc.bonus.udata.uInterLocSet).UpRepName(13,"测试")
ClassMethod UpRepName(Rowid, Name) As %String
{
	n (Rowid,Name)
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocSet
	WHERE InterLocSet_name=:Name and InterLocSet_active='Y' and InterLocSet_rowid not in (:Rowid))
	i sum="" d  s sum=0
	q sum
}

/// Others：w ##class(dhc.bonus.udata.uInterLocSet).UpRepCode(13,"02")
ClassMethod UpRepCode(Rowid, Code) As %String
{
	n (Rowid,Code)
	s sum=0
	&sql(SELECT count(*) into :sum FROM dhc_bonus_inter.InterLocSet
	WHERE InterLocSet_code=:Code and InterLocSet_active='Y' and InterLocSet_rowid not in (:Rowid))
	i sum="" d  s sum=0
	q sum
}

/// Creator: 李明忠
/// CreatDate: 2010-11-10
/// Description: 删除接口套记录
/// Table：dhc_bonus_inter.InterLocSet
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.bonus.udata.uInterLocSet).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_bonus_inter.InterLocSet WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.bonus.udata.uInterLocSetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
