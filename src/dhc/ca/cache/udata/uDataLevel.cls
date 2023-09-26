/// Creator: 杨旭
/// CreatDate: 2009-8-27
/// Description: 数据分层维护
Class dhc.ca.cache.udata.uDataLevel Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-8-20
/// Description: 查询符合条件的记录
/// Table：DataLevel
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;Parent-父节点;Active-是否有效
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).RListRec("", "", "", "", 0, 25, 0)
ClassMethod ListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
	i Parent="roo" s Parent=0
	;Set Result = ##class(%Library.ResultSet).%New()
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	Set SqlStr = "select DataLevel_rowid,DataLevel_code,DataLevel_name,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent,DataLevel_order from dhc_ca_cache_data.DataLevel where %ID>0 and DataLevel_parent='"_Parent_"'"
	s Count=0
	s ResultString=""
	
	If SortField = "id" Set SortField = "DataLevel_rowid"
	If SortField = "code" Set SortField = "DataLevel_code"
	If SortField = "name" Set SortField = "DataLevel_name"
	If SortField = "order" Set SortField = "DataLevel_order"
	If SortField = "remark" Set SortField = "DataLevel_remark"
	If SortField = "end" Set SortField = "DataLevel_end"
	If SortField = "active" Set SortField = "DataLevel_active"
	
	
	Set ConditionOrderBy = ""
	
	If Active'="" Do
	.s SqlStr=SqlStr_" and DataLevel_active='"_Active_"'"
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy
	
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADATALEVEL(Parent)) d
	..s TmpEnd=$p(^DHCCADATALEVEL(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("DataLevel_rowid")
		s code = Result.Data("DataLevel_code")
		s name = Result.Data("DataLevel_name")
		s desc = Result.Data("DataLevel_desc")
		s remark = Result.Data("DataLevel_remark")
		s end = Result.Data("DataLevel_end")
		s active = Result.Data("DataLevel_active")
		s parent = Result.Data("DataLevel_parent")
		s order = Result.Data("DataLevel_order")
		s Count=Count+1
		s Tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_remark_"^"_end_"^"_end_"^"_active_"^"_parent_"^col"_"^"_order
		i (Count>Start)&(Count<=End) d
		.d Json.InsertRowData(Tmp)
		e  d
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
	}
	s Order=""
	s LocLevel=""
	i Parent'="" d
	.f  s Order=$o(^DHCCADATALEVEL(0,"DataItemOrder",Parent,Order)) q:Order=""  d
	..f  s LocLevel=$o(^DHCCADATALEVEL(0,"DataItemOrder",Parent,Order,LocLevel)) q:LocLevel=""  d
	...q:LocLevel=0
	...s Count=Count+1
	...s ItemDr=$p(^DHCCADATALEVEL(Parent,"ITEM",LocLevel),"^",1)
	...i ItemDr'="" d
	....i $d(^DHCCADATAITEMS(ItemDr)) d
	.....s LocName=$p(^DHCCADATAITEMS(ItemDr),"^",2)
	.....s TypeDr=$p(^DHCCADATAITEMS(ItemDr),"^",5)
	.....s TypeName=""
	.....i TypeDr'="" d
	......i $d(^DHCCADATATYPE(TypeDr)) d
	.......s TypeName=$p(^DHCCADATATYPE(TypeDr),"^",2)
	.....s Tmp=Parent_"||"_LocLevel_"^^"_LocName_"^^^^^"_$p(^DHCCADATAITEMS(ItemDr),"^",6)_"^^col^"_$p(^DHCCADATALEVEL(Parent,"ITEM",LocLevel),"^",2)_"^"_TypeDr_"^"_TypeName_"^"_ItemDr
	.....i (Count>Start)&(Count<=End) d
	......d Json.InsertRowData(Tmp)
	.....e  d
	......i (Count>Start)&(Count<=End) d
	.......d Json.InsertRowData(Tmp)
	
	d Result.Close()
	s ResultString = Json.getJsonData("id^code^name^desc^remark^leaf^end^active^parent^uiProvider^order^typeDr^typeName^itemDr",Count)
 	k Json
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-20
/// Description: 插入一条新科室分层数据
/// Table：DataLevel
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
	&sql(insert into dhc_ca_cache_data.DataLevel (DataLevel_code,DataLevel_name,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent,DataLevel_order) values(:Code,:Name,:Desc,:Remark,:Leaf,:Active,:Parent,:order))
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-20
/// Description: 查询符合条件的记录
/// Table：DataLevel
/// Input：Parent-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uDataLevel).RListRec(1)
ClassMethod RListRec(Parent)
{
	n (Parent)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevel_rowid,DataLevel_code,DataLevel_name,DataLevel_order,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent from dhc_ca_cache_data.DataLevel where %ID>0 and DataLevel_active = 'Y' and DataLevel_parent='"_Parent_"' ORDER BY DataLevel_order asc"
	
	s ItemDr=""
	s ItemName=""
	s DataLevel=""
	s ResultString="["
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADATALEVEL(Parent)) d
	..s TmpEnd=$p(^DHCCADATALEVEL(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.//w SqlStr
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	While(Result.Next())
	{
		s rowid = Result.Data("DataLevel_rowid")
		s code = Result.Data("DataLevel_code")
		s name = Result.Data("DataLevel_name")
		s desc = Result.Data("DataLevel_desc")
		s remark = Result.Data("DataLevel_remark")
		s end = Result.Data("DataLevel_end")
		s active = Result.Data("DataLevel_active")
		s parent = Result.Data("DataLevel_parent")
		s ResultString=ResultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',desc:'"_desc_"',remark:'"_remark_"',leaf:false,end:'"_end_"',active:'"_active_"',parent:'"_parent_"',uiProvider:'col'},"
	}
	s Order=""
	i Parent'="" d
	.f  s Order=$o(^DHCCADATALEVEL(0,"DataItemOrder",Parent,Order)) q:Order=""  d
	..f  s DataLevel=$o(^DHCCADATALEVEL(0,"DataItemOrder",Parent,Order,DataLevel)) q:DataLevel=""  d
	...q:DataLevel=0
	...s ItemDr=$p(^DHCCADATALEVEL(Parent,"ITEM",DataLevel),"^",1)
	...i ItemDr'="" d
	....i $d(^DHCCADATAITEMS(ItemDr)) d
	.....s ItemName=$p(^DHCCADATAITEMS(ItemDr),"^",2)
	.....s ResultString=ResultString_"{id:'"_Parent_"||"_DataLevel_"',code:'',name:'"_ItemName_"',desc:'',remark:'',leaf:'true',end:'',active:'Y',parent:'"_$p(^DHCCADATALEVEL(Parent,"ITEM",DataLevel),"^",2)_"',uiProvider:'col'},"
	
	s ResultString=ResultString_"]"
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 更新记录
/// Table：DataLevel
/// Input：RowId-所在行号;Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体科室;Active-有效;Parent-父ID;order-顺序;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(Rowid, Code, Name, Remark, Leaf, Active, order) As %String
{
	
	n (Rowid, Code, Name, Remark, Leaf, Active, order)
	s Desc =Code_"-"_Name
	s Rs=""
	&sql(update dhc_ca_cache_data.DataLevel set DataLevel_code=:Code,DataLevel_name=:Name,DataLevel_active=:Active,DataLevel_desc=:Desc,DataLevel_remark=:Remark,DataLevel_end=:Leaf,DataLevel_order=:order where %ID=:Rowid)
	s Rs=SQLCODE
	i Active="N" d
	.s Rs=..UpdateBySource(Rowid)
	q Rs
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查看一条数据是否是末端树枝
/// Table：DataLevel
/// Input：Rowid-ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckRec(Rowid)
{
	n (Rowid)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevel_rowid,DataLevel_code,DataLevel_name,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent from dhc_ca_cache_data.DataLevel where %ID>0 and %ID='"_Rowid_"'"

	s ResultString="Y"

	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s ResultString = Result.Data("DataLevel_end")
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 遍历所有同根节点
/// Table：DataLevel
/// Input：Rowid-ID;ItemDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).CheckExist(0)
ClassMethod CheckExist(Rowid, ItemDr)
{
	n (Rowid,ItemDr,ResultString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevel_rowid,DataLevel_code,DataLevel_name,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent from dhc_ca_cache_data.DataLevel where %ID>0 and DataLevel_parent='"_Rowid_"'"

	s ResultString=""

	d Result.Prepare(SqlStr)
	d Result.Execute()
	i ResultString="" d
	.s ResultString =..CheckLocExist(Rowid,ItemDr)
	While(Result.Next())
	{	
		i ResultString=0 d
		.s Rowid = Result.Data("DataLevel_rowid")
		.s ResultString =..CheckLocExist(Rowid,ItemDr)
		.d ..CheckExist(Rowid,ItemDr)
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查看此科室是否已经被添加过
/// Table：DataLevel
/// Input：Rowid-ID;ItemDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).CheckLocExist(1,1)
ClassMethod CheckLocExist(ParRef, ItemDr)
{
	n (ParRef,ItemDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelLast_rowid,DataLevelLast_dataItemDr from dhc_ca_cache_data.DataLevelLast where DataLevelLast_childSub>0 and DataLevelLast_parRef='"_ParRef_"' and DataLevelLast_dataItemDr='"_ItemDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		//ParRefs RString = ParRef
		s RString=$p(^DHCCADATALEVEL(ParRef),"^",2)
	}
	d Result.Close()
	q RString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查找根节点
/// Table：DataLevel
/// Input：ParRef-父ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).FindSource(5)
ClassMethod FindSource(ParRef)
{
	s RString=""
	n (ParRef,RString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevel_rowid,DataLevel_code,DataLevel_name,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent from dhc_ca_cache_data.DataLevel where %ID>0 and %ID='"_ParRef_"'"


	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s TmpParent=0
		s TmpParent = Result.Data("DataLevel_parent")
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
/// Table：DataLevel
/// Input：Rowid-ID;ItemDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).UpdateBySource(0)
ClassMethod UpdateBySource(Rowid)
{
	n (Rowid)
	TSTART
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevel_rowid,DataLevel_code,DataLevel_name,DataLevel_desc,DataLevel_remark,DataLevel_end,DataLevel_active,DataLevel_parent from dhc_ca_cache_data.DataLevel where %ID>0 and DataLevel_parent='"_Rowid_"'"

	s ResultString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		
		
		s Rowid = Result.Data("DataLevel_rowid")
		d ..UpdateBySource(Rowid)
		&sql(update dhc_ca_cache_data.DataLevel set DataLevel_active='N' where %ID=:Rowid)
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
<Data name="uDataLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uDataLevelD</DataLocation>
<DefaultData>uDataLevelDefaultData</DefaultData>
<IdLocation>^dhc.ca.c.uDataLevelD</IdLocation>
<IndexLocation>^dhc.ca.c.uDataLevelI</IndexLocation>
<StreamLocation>^dhc.ca.c.uDataLevelS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
