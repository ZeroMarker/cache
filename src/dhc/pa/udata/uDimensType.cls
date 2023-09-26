/// Creator: 李明忠
/// CreatDate: 2010-07-14
/// Description: 维度分类基础维护
Class dhc.pa.udata.uDimensType Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator:李明忠
/// CreatDate:2010-7-14
/// Description:查询维度分类记录
/// Table:dhc_pa_data.DimensType
/// Input:active-维度分类有效标志;searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;start-起始行;limit-行数
/// Output:
/// Return:返回查询到的记录的Json串
/// Others:w ##class(dhc.pa.udata.uDimensType).List("Y","","","","",0,25)
ClassMethod List(active, searchField, searchValue, sortField, sortDir, start, limit) As %String
{
	n (active, searchField, searchValue, sortField, sortDir, start, limit)
	//s ^dhctmp("List")=active_"^"_searchField_"^"_searchValue_"^"_sortField_"^"_sortDir_"^"_start_"^"_limit
	i active="" s active="Y"
	i active="y" s active="Y"
	i active="yes" s active="Y"
	i active="Yes" s active="Y"
	
	s sqlStr="SELECT DimensType_rowid,DimensType_code,DimensType_name,DimensType_shortcut,DimensType_order,DimensType_appSysDr,DimensType_desc,DimensType_isInner,DimensType_active FROM dhc_pa_data.DimensType"
	
	s whereStr=" WHERE %ID>0"
	;i (active="Y")||(active="N") s whereStr=whereStr_" AND DimensType_active='"_active_"'"
	
	s sortStr=""
	s sortField1=""
	
	i sortField'="" d
	.i sortField="rowid" s sortField1="DimensType_rowid"
	.i sortField="code" s sortField1="DimensType_code"
	.i sortField="name" s sortField1="DimensType_name"
	.i sortField="shortcut" s sortField1="DimensType_shortcut"
	.i sortField="order" s sortField1="DimensType_order"
	.i sortField="appSysDr" s sortField1="DimensType_appSysDr"
	.i sortField="desc" s sortField1="DimensType_desc"
	.i sortField="isInner" s sortField1="DimensType_isInner"
	.i sortField="active" s sortField1="DimensType_active"
	
	i sortField1'="" d
	.s sortDir=$ZCONVERT(sortDir,"u")
	.i (sortDir="DESC")||(sortDir="ASC") s sortStr=" ORDER BY "_sortField1_" "_sortDir
	.e  s sortStr=" ORDER BY "_sortField1_" ASC"
	e  d
	.s sortStr=" ORDER BY %ID DESC"
	
	s sqlStr=sqlStr_whereStr_sortStr
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.pa.comm.JsonObj).%New()
	s jsonTitle="rowid^code^name^shortcut^order^appSysDr^appSysName^desc^isInner^active"
	
	While(result.Next()){
		s rowid=result.Data("DimensType_rowid")
		s code=result.Data("DimensType_code")
		s name=result.Data("DimensType_name")
		s shortcut=result.Data("DimensType_shortcut")
		s order=result.Data("DimensType_order")
		s appSysDr=result.Data("DimensType_appSysDr")
		s appSysName="不匹配"
		i appSysDr=1 s appSysName="全院"
		i appSysDr=2 s appSysName="科室"
		i appSysDr=3 s appSysName="护理"
		i appSysDr=4 s appSysName="医疗"
		i appSysDr=5 s appSysName="个人"
		s desc=result.Data("DimensType_desc")
		s isInner=result.Data("DimensType_isInner")
		s active=result.Data("DimensType_active")
		
		s tmp=rowid_"^"_code_"^"_name_"^"_shortcut_"^"_order_"^"_appSysDr_"^"_appSysName_"^"_desc_"^"_isInner_"^"_active
		
		i searchValue'="" d
		.i searchField = "active" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.i searchField = "flag" d
		..i (searchValue="Y") || (searchValue="y") s searchValue="Y"
		..e  s searchValue="N"
		.q:(searchField = "code")&(code'[searchValue)
		.q:(searchField = "name")&(name'[searchValue)
		.q:(searchField = "appSysName")&(appSysName'[searchValue)
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
/// CreatDate：2010-7-14
/// Description: 判断维度分类代码是否存在
/// Table：dhc_pa_data.DimensType
/// Input：Code-维度分类代码
/// Output：
/// Return：如果为空就返回“0”，否则返回RowId值
/// Others：
ClassMethod IfRepCode(Code) As %String
{
	n (Code)
	s RowId=0
	s RowId=$o(^DHCCJXPADIMENSTYPE(0,"Code",Code,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-7-14
/// Description: 判断维度分类名称是否存在
/// Table：dhc_pa_data.DimensType
/// Input：Name-维度分类名称
/// Output：
/// Return：如果为空就返回“0”，否则返回RowId值
/// Others：
ClassMethod IfRepName(Name) As %String
{
	n (Name)
	s RowId=0
	s RowId=$o(^DHCCJXPADIMENSTYPE(0,"Name",Name,RowId))
	i RowId="" d  s RowId=0
	q RowId
}

/// Creator：李明忠
/// CreatDate：2010-7-14
/// Description: 添加维度分类记录
/// Table：dhc_pa_data.DimensType
/// Input：Code-维度分类代码; Name-维度分类名称; Order-维度分类顺序; AppSysDr-维度分类所属应用系统类别; Desc-维度分类描述
/// Output：
/// Return：代码重复返回RepCode,名称重复返回RepName,否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod Insert(Code, Name, Order, AppSysDr, Desc) As %String
{
	n (Code,Name,Order,AppSysDr,Desc)
	
	s RowId=""
	s RowId=..IfRepCode(Code)
	q:RowId'=0 "RepCode"
	s RowId=..IfRepName(Name)
	q:RowId'=0 "RepName"
	
	s Active="Y"
	s IsInner="Y"
	
	s ShortCut=Code_"-"_Name
	
	&SQL(Insert Into dhc_pa_data.DimensType(DimensType_code,DimensType_name,DimensType_shortcut,DimensType_order,DimensType_appSysDr,DimensType_desc,DimensType_isInner,DimensType_active) VAlUES(:Code,:Name,:ShortCut,:Order,:AppSysDr,:Desc,:IsInner,:Active))
	q SQLCODE
}

/// Creator：李明忠
/// CreatDate：2010-7-14
/// Description: 更新维度分类记录
/// Table：dhc_pa_data.DimensType
/// Input：Rowid-记录的ID;Code-维度分类代码; Name-维度分类名称; Order-维度分类顺序; AppSysDr-维度分类所属应用系统类别; Desc-维度分类描述; IsInner-内置标志; Active-维度分类记录有效标志
/// Output：
/// Return：代码重复返回RepCode，名称重复返回RepName,否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod Update(Rowid, Code, Name, Order, AppSysDr, Desc, IsInner, Active) As %String
{
	n (Rowid,Code,Name,Order,AppSysDr,Desc,IsInner,Active)
	
	s RowId=""
	s RowId=..IfRepCode(Code)
	q:(RowId'=0)&(RowId'=Rowid) "RepCode"    
	s RowId=..IfRepName(Name)
	q:(RowId'=0)&(RowId'=Rowid) "RepName"
	
	s ShortCut=Code_"-"_Name
	
	&SQL(update dhc_pa_data.DimensType set DimensType_code=:Code,DimensType_name=:Name,DimensType_shortcut=:ShortCut,DimensType_order=:Order,DimensType_appSysDr=:AppSysDr,DimensType_desc=:Desc,DimensType_isInner=:IsInner,DimensType_active=:Active where %ID=:Rowid)
	q SQLCODE
}

/// Creator: 李明忠
/// CreatDate: 2010-7-14
/// Description: 删除维度分类记录
/// Table：dhc_pa_data.DimensType
/// Input：rowid-数据行号
/// Output: 
/// Return: 返回执行删除语句后的SQLCODE
/// Others: w ##class(dhc.pa.udata.uDimensType).Delete(4)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
	
	&SQL(DELETE FROM dhc_pa_data.DimensType WHERE %ID=:rowid)
	q SQLCODE
}

Storage Default
{
<StreamLocation>^dhc.pa.udata.uDimensTypeS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
