/// 名称: 科室分层数据维护
/// 描述: 科室分层添加与修改
/// 编写者：杨旭
/// 编写日期:2009-8-20
Class dhc.ca.cache.udata.uLocLevel Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-8-20
/// Description: 查询符合条件的记录
/// Table：LocLevel
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;Parent-父节点;Active-是否有效
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).RListRec("", "", "", "", 0, 25, 0)
ClassMethod RListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevel_rowid,LocLevel_code,LocLevel_name,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent,LocLevel_order from dhc_ca_cache_data.LocLevel where %ID>0 and LocLevel_parent='"_Parent_"'"
	s Count=0
	s ResultString=""
	
	If SortField = "id" Set SortField = "LocLevel_rowid"
	If SortField = "code" Set SortField = "LocLevel_code"
	If SortField = "name" Set SortField = "LocLevel_name"
	If SortField = "order" Set SortField = "LocLevel_order"
	If SortField = "remark" Set SortField = "LocLevel_remark"
	If SortField = "end" Set SortField = "LocLevel_end"
	If SortField = "active" Set SortField = "LocLevel_active"
	
	
	Set ConditionOrderBy = ""
	
	If Active'="" Do
	.s SqlStr=SqlStr_" and LocLevel_active='"_Active_"'"
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy
	
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCALOCLEVEL(Parent)) d
	..s TmpEnd=$p(^DHCCALOCLEVEL(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("LocLevel_rowid")
		s code = Result.Data("LocLevel_code")
		s name = Result.Data("LocLevel_name")
		s desc = Result.Data("LocLevel_desc")
		s remark = Result.Data("LocLevel_remark")
		s end = Result.Data("LocLevel_end")
		s active = Result.Data("LocLevel_active")
		s parent = Result.Data("LocLevel_parent")
		s order = Result.Data("LocLevel_order")
		s Count=Count+1
		s Tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_remark_"^"_end_"^"_end_"^"_active_"^"_parent_"^col"_"^"_order
		i (Count>Start)&(Count<=End) d
		.d Json.InsertRowData(Tmp)
		e  d
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
	}
	d Result.Close()
	s ResultString = Json.getJsonData("id^code^name^desc^remark^leaf^end^active^parent^uiProvider^order",Count)
 	k Json
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-20
/// Description: 查询符合条件的记录
/// Table：LocLevel
/// Input：Parent-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).ListRec(0)
ClassMethod ListRec(Parent)
{
	n (Parent)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevel_rowid,LocLevel_code,LocLevel_name,LocLevel_order,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent from dhc_ca_cache_data.LocLevel where %ID>0 and LocLevel_active = 'Y' and LocLevel_parent='"_Parent_"' ORDER BY LocLevel_order asc"
	
	s LocDr=""
	s LocName=""
	s LocLevel=""
	s ResultString="["
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCALOCLEVEL(Parent)) d
	..s TmpEnd=$p(^DHCCALOCLEVEL(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.//w SqlStr
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	While(Result.Next())
	{
		s rowid = Result.Data("LocLevel_rowid")
		s code = Result.Data("LocLevel_code")
		s name = Result.Data("LocLevel_name")
		s desc = Result.Data("LocLevel_desc")
		s remark = Result.Data("LocLevel_remark")
		s end = Result.Data("LocLevel_end")
		s active = Result.Data("LocLevel_active")
		s parent = Result.Data("LocLevel_parent")
		s ResultString=ResultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',desc:'"_desc_"',remark:'"_remark_"',leaf:false,end:'"_end_"',active:'"_active_"',parent:'"_parent_"',uiProvider:'col'},"
	}
	//^DHCCALOCLEVEL(0,"LocOrder",{LocLevel.LocLevel_rowid},{LocLevelLast_order},{LocLevelLast_childSub})
	s Order=""
	i Parent'="" d
	.f  s Order=$o(^DHCCALOCLEVEL(0,"LocOrder",Parent,Order)) q:Order=""  d
	..f  s LocLevel=$o(^DHCCALOCLEVEL(0,"LocOrder",Parent,Order,LocLevel)) q:LocLevel=""  d
	...q:LocLevel=0
	...s LocDr=$p(^DHCCALOCLEVEL(Parent,"Locs",LocLevel),"^",1)
	...i LocDr'="" d
	....i $d(^DHCCALOCS(LocDr)) d
	.....s LocName=$p(^DHCCALOCS(LocDr),"^",2)
	.....s ResultString=ResultString_"{id:'"_Parent_"||"_LocLevel_"',code:'',name:'"_LocName_"',desc:'',remark:'',leaf:'true',end:'',active:'Y',parent:'"_$p(^DHCCALOCLEVEL(Parent,"Locs",LocLevel),"^",2)_"',uiProvider:'col'},"
	
	s ResultString=ResultString_"]"
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-20
/// Description: 插入一条新科室分层数据
/// Table：LocLevel
/// Input：Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体科室;Active-有效;Parent-父ID;order-顺序;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).InsertRec(3, 3,3 , "N", "", 0)
ClassMethod InsertRec(Code, Name, Remark, Leaf, Active, Parent, order) As %String
{
	
	n (Code, Name, Remark, Leaf, Active, Parent, order)
	s Desc =Code_"-"_Name
	i Parent="roo" s Parent=0
	i (Active'="Y")||(Active'="N") s Active="Y"
	&sql(insert into dhc_ca_cache_data.LocLevel (LocLevel_code,LocLevel_name,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent,LocLevel_order) values(:Code,:Name,:Desc,:Remark,:Leaf,:Active,:Parent,:order))
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 更新记录
/// Table：LocLevel
/// Input：RowId-所在行号;Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体科室;Active-有效;Parent-父ID;order-顺序;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(Rowid, Code, Name, Remark, Leaf, Active, order) As %String
{
	
	n (Rowid, Code, Name, Remark, Leaf, Active, order)
	s Desc =Code_"-"_Name
	s Rs=""
	&sql(update dhc_ca_cache_data.LocLevel set LocLevel_code=:Code,LocLevel_name=:Name,LocLevel_active=:Active,LocLevel_desc=:Desc,LocLevel_remark=:Remark,LocLevel_end=:Leaf,LocLevel_order=:order where %ID=:Rowid)
	s Rs=SQLCODE
	i Active="N" d
	.s Rs=..UpdateBySource(Rowid)
	q Rs
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查看一条数据是否是末端树枝
/// Table：LocLevel
/// Input：Rowid-ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckRec(Rowid)
{
	n (Rowid)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevel_rowid,LocLevel_code,LocLevel_name,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent from dhc_ca_cache_data.LocLevel where %ID>0 and %ID='"_Rowid_"'"

	s ResultString="Y"

	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s ResultString = Result.Data("LocLevel_end")
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 遍历所有同根节点
/// Table：LocLevel
/// Input：Rowid-ID;LocDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).CheckExist(0)
ClassMethod CheckExist(Rowid, LocDr)
{
	n (Rowid,LocDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevel_rowid,LocLevel_code,LocLevel_name,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent from dhc_ca_cache_data.LocLevel where %ID>0 and LocLevel_parent='"_Rowid_"'"

	s ResultString=""

	d Result.Prepare(SqlStr)
	d Result.Execute()
	s ResultString =..CheckLocExist(Rowid,LocDr)
	While(Result.Next())
	{	
		i ResultString=0 d
		.s Rowid = Result.Data("LocLevel_rowid")
		.s ResultString =..CheckLocExist(Rowid,LocDr)
		.d ..CheckExist(Rowid,LocDr)
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查看此科室是否已经被添加过
/// Table：LocLevel
/// Input：Rowid-ID;LocDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).CheckLocExist(1,1)
ClassMethod CheckLocExist(ParRef, LocDr)
{
	n (ParRef,LocDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevelLast_rowid,LocLevelLast_locDr,LocLevelLast_recCost from dhc_ca_cache_data.LocLevelLast where LocLevelLast_childSub>0 and LocLevelLast_parRef='"_ParRef_"' and LocLevelLast_locDr='"_LocDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		//ParRefs RString = ParRef
		s RString=$p(^DHCCALOCLEVEL(ParRef),"^",2)
	}
	d Result.Close()
	q RString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查找根节点
/// Table：LocLevel
/// Input：ParRef-父ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).FindSource(5)
ClassMethod FindSource(ParRef)
{
	s RString=""
	n (ParRef,RString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevel_rowid,LocLevel_code,LocLevel_name,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent from dhc_ca_cache_data.LocLevel where %ID>0 and %ID='"_ParRef_"'"


	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s TmpParent=0
		s TmpParent = Result.Data("LocLevel_parent")
		i TmpParent'=0 d 
		.d ..FindSource(TmpParent)
		e  d  
		.s RString=ParRef
	}
	d Result.Close()
	q RString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 更新所有同根的节点
/// Table：LocLevel
/// Input：Rowid-ID;LocDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).UpdateBySource(0)
ClassMethod UpdateBySource(Rowid)
{
	n (Rowid)
	TSTART
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevel_rowid,LocLevel_code,LocLevel_name,LocLevel_desc,LocLevel_remark,LocLevel_end,LocLevel_active,LocLevel_parent from dhc_ca_cache_data.LocLevel where %ID>0 and LocLevel_parent='"_Rowid_"'"

	s ResultString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		
		
		s Rowid = Result.Data("LocLevel_rowid")
		d ..UpdateBySource(Rowid)
		&sql(update dhc_ca_cache_data.LocLevel set LocLevel_active='N' where %ID=:Rowid)
		i SQLCODE'=0 d  s ResultString=SQLCODE
	}
	d Result.Close()
	i ResultString'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q ResultString
}

Storage Default
{
<Data name="uLocLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uLocLevelD</DataLocation>
<DefaultData>uLocLevelDefaultData</DefaultData>
<IdLocation>^dhc.ca.c.uLocLevelD</IdLocation>
<IndexLocation>^dhc.ca.c.uLocLevelI</IndexLocation>
<StreamLocation>^dhc.ca.c.uLocLevelS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
