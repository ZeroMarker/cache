/// Creator: wang ying
/// CreatDate: 2011-1-11
/// Description: 接口套维护(海军总医院)
Class dhc.pa.udata.uInterSysSet Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:wang ying
/// CreatDate:2010-11-10
/// Description:查询接口套记录
/// Table:dhc_pa_inter.InterSysSet
/// Input:searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uInterSysSet).List("","","","",0,25)
ClassMethod List(searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (searchField, searchValue, sortField, sortDir, start, limit)

	s sqlStr="select InterSysSet_rowid,InterSysSet_order,InterSysSet_code,InterSysSet_name,InterSysSet_shortcut,InterSysSet_desc,InterSysSet_active from dhc_pa_inter.InterSysSet where %ID>0"
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="InterSysSet_rowid"
	.i sortField="order" s sortField1="InterSysSet_order"
	.i sortField="code" s sortField1="InterSysSet_code"
	.i sortField="name" s sortField1="InterSysSet_name"
	.i sortField="shortcut" s sortField1="InterSysSet_shortcut"
	.i sortField="desc" s sortField1="InterSysSet_desc"
	.i sortField="active" s sortField1="InterSysSet_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" DESC"
	e  d
	.s sortStr=" ORDER BY %ID ASC"
	
	s sqlStr=sqlStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^order^code^name^shortcut^desc^active"
	
	While(result.Next()){
		s rowid=result.Data("InterSysSet_rowid")
		s order=result.Data("InterSysSet_order")
		s code=result.Data("InterSysSet_code")
		s name=result.Data("InterSysSet_name")
		s shortcut=result.Data("InterSysSet_shortcut")
		s desc=result.Data("InterSysSet_desc")
		s active=result.Data("InterSysSet_active")
		
		s tmp=rowid_"^"_order_"^"_code_"^"_name_"^"_shortcut_"^"_desc_"^"_active
		
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

/// Creator：wang ying
/// CreatDate：2010-11-10
/// Description: 判断接口套代码是否存在
/// Table：
/// Input：Code-接口套代码
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.pa.udata.uInterSysSet).IfRepCode("s001")
ClassMethod IfRepCode(Code) As %String
{
	n (Code)
	
	s RowId=0
	s RowId=$o(^DHCCJXPAINTERSYSSET(0,"Code",Code,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：wang ying
/// CreatDate：2010-11-10
/// Description: 判断接口套名称是否存在
/// Table：
/// Input：Name-接口套名称
/// Output：
/// Return：如果为空就返回"0"，否则返回RowId值
/// Others：w ##class(dhc.pa.udata.uInterSysSet).IfRepName("HIS")
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	
	s RowId=0
	s RowId=$o(^DHCCJXPAINTERSYSSET(0,"Name",Name,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：wang ying
/// CreatDate：2010-11-10
/// Description: 添加接口套记录
/// Table：dhc_pa_inter.InterSysSet
/// Input：Order-接口套顺序;Code-接口套代码;Name-接口套名称;Desc-接口套描述
/// Output：
/// Return：代码重复返回RepCode,名称重复返回RepName,否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uInterSysSet).Insert(1,001,"用友软件","sddd")
ClassMethod Insert(Order, Code, Name, Desc) As %String
{
	n (Order,Code,Name,Desc)
	
	s RowId=""
	s RowId=..IfRepCode(Code)
	q:RowId'=0 "RepCode"
	s RowId=..IfRepName(Name)
	q:RowId'=0 "RepName"
	
	s Active="Y"
	s ShortCut=Code_"-"_Name
	
	&SQL(Insert Into dhc_pa_inter.InterSysSet(InterSysSet_order,InterSysSet_code,InterSysSet_name,InterSysSet_shortcut,InterSysSet_desc,InterSysSet_active) VAlUES(:Order,:Code,:Name,:ShortCut,:Desc,:Active))
	q SQLCODE
}

/// Creator：wang ying
/// CreatDate：2010-11-10
/// Description: 更新接口套记录
/// Table：dhc_pa_inter.InterSysSet
/// Input：Rowid-记录的ID;Order-接口套顺序;Code-接口套代码;Name-接口套名称;Desc-接口套描述;Active-接口套记录有效标志
/// Output：
/// Return：代码重复返回RepCode，名称重复返回RepName,否则返回执行更新语句后的SQLCODE
/// Others：w ##class(dhc.pa.udata.uInterSysSet).Update(7,8,12,12,12,"Y")
ClassMethod Update(Rowid, Order, Code, Name, Desc, Active) As %String
{
	n (Rowid,Order,Code,Name,Desc,Active)
	
	s RowId=""
	s RowId=..IfRepCode(Code)
	q:(RowId'=0)&(RowId'=Rowid) "RepCode"    
	s RowId=..IfRepName(Name)
	q:(RowId'=0)&(RowId'=Rowid) "RepName"
	
	s ShortCut=Code_"-"_Name
	
	&SQL(update dhc_pa_inter.InterSysSet set InterSysSet_order=:Order,InterSysSet_code=:Code,InterSysSet_name=:Name,InterSysSet_shortcut=:ShortCut,InterSysSet_desc=:Desc,InterSysSet_active=:Active where %ID=:Rowid)
	q SQLCODE
}

/// Creator: wang ying
/// CreatDate: 2010-11-10
/// Description: 删除接口套记录
/// Table：dhc_pa_inter.InterSysSet
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uInterSysSet).Delete(1)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_pa_inter.InterSysSet WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uInterSysSetS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
