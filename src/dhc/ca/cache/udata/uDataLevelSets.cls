/// 名称: 数据分层数据维护
/// 描述: 数据分层添加与修改
/// 编写者：王赢赢
/// 编写日期:2009-10-20
Class dhc.ca.cache.udata.uDataLevelSets Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查询符合条件的记录
/// Table：DataLevelSets
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;Parent-父节点;Active-是否有效
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelSets).RListRec("","","id","DESC",0,"25","roo","")
ClassMethod RListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent,DataLevelSets_order from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_Parent_"'"
	s Count=0
	s ResultString=""
	//w SqlStr
	If SortField = "id" Set SortField = "DataLevelSets_rowid"
	If SortField = "code" Set SortField = "DataLevelSets_code"
	If SortField = "name" Set SortField = "DataLevelSets_name"
	If SortField = "order" Set SortField = "DataLevelSets_order"
	If SortField = "remark" Set SortField = "DataLevelSets_remark"
	If SortField = "end" Set SortField = "DataLevelSets_end"
	If SortField = "active" Set SortField = "DataLevelSets_active"
	
	
	Set ConditionOrderBy = ""
	
	If Active'="" Do
	.s SqlStr=SqlStr_" and DataLevelSets_active='"_Active_"'"
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy
	//q SqlStr
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADATALEVELSETS(Parent)) d
	..s TmpEnd=$p(^DHCCADATALEVELSETS(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("DataLevelSets_rowid")
		s code = Result.Data("DataLevelSets_code")
		s name = Result.Data("DataLevelSets_name")
		s desc = Result.Data("DataLevelSets_shortcut")
		s remark = Result.Data("DataLevelSets_remark")
		s end = Result.Data("DataLevelSets_end")
		s active = Result.Data("DataLevelSets_active")
		s parent = Result.Data("DataLevelSets_parent")
		s order = Result.Data("DataLevelSets_order")
		s Count=Count+1
		s Tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_remark_"^"_end_"^"_end_"^"_active_"^"_parent_"^col"_"^"_order_"^"
		i (Count>Start)&(Count<=End) d
		.d Json.InsertRowData(Tmp)
		e  d
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
	}

	
	d Result.Close()
	s ResultString = Json.getJsonData("id^code^name^desc^remark^leaf^end^active^parent^uiProvider^order^itemTypeDr^hospDr^hospName^locDr",Count)
 	k Json
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查询符合条件的记录
/// Table：DataLevelSets
/// Input：Parent-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelSets).ListRec("roo")
ClassMethod ListRec(Parent)
{
	n (Parent)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_order,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_active = 'Y' and DataLevelSets_parent='"_Parent_"' ORDER BY DataLevelSets_order asc"
	
	//q SqlStr
	s ItemDr=""
	s ItemName=""
	s DataLevelSets=""
	s ResultString="["
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADATALEVELSETS(Parent)) d
	..s TmpEnd=$p(^DHCCADATALEVELSETS(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	While(Result.Next())
	{
		s rowid = Result.Data("DataLevelSets_rowid")
		s code = Result.Data("DataLevelSets_code")
		s name = Result.Data("DataLevelSets_name")
		s desc = Result.Data("DataLevelSets_shortcut")
		s remark = Result.Data("DataLevelSets_remark")
		s end = Result.Data("DataLevelSets_end")
		s active = Result.Data("DataLevelSets_active")
		s parent = Result.Data("DataLevelSets_parent")
		s ResultString=ResultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',desc:'"_desc_"',remark:'"_remark_"',leaf:false,end:'"_end_"',active:'"_active_"',parent:'"_parent_"',uiProvider:'col'},"
	}
	//^DHCCADATALEVELSETS(0,"Order",{DataLevelSets.DataLevelSets_rowid},{LevelItems_order},{LevelItems_childSub})
	
	
	s Order=""
	i Parent'="" d
	.f  s Order=$o(^DHCCADATALEVELSETS(0,"Order",Parent,Order)) q:Order=""  d
	..f  s DataLevelSets=$o(^DHCCADATALEVELSETS(0,"Order",Parent,Order,DataLevelSets)) q:DataLevelSets=""  d
	...q:DataLevelSets=0
	...s ItemDr=$p(^DHCCADATALEVELSETS(Parent,"Items",DataLevelSets),"^",3)
	...i ItemDr'="" d
	....i $d(^DHCCAALLDATAITEMS(ItemDr)) d
	.....s ItemName=$p(^DHCCAALLDATAITEMS(ItemDr),"^",3)
	.....s ResultString=ResultString_"{id:'"_Parent_"||"_DataLevelSets_"',code:'',name:'"_ItemName_"',desc:'',remark:'',leaf:'true',end:'',active:'Y',parent:'"_$p(^DHCCADATALEVELSETS(Parent,"Items",DataLevelSets),"^",2)_"',uiProvider:'col'},"
	
	s ResultString=ResultString_"]"
	d Result.Close()
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 插入一条新数据分层数据
/// Table：DataLevelSets
/// Input：Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体数据;Active-有效;Parent-父ID;order-顺序;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：
ClassMethod InsertRec(Code, Name, Remark, Leaf, Active, Parent, order) As %String
{
	
	n (Code, Name, Remark, Leaf, Active, Parent, order)
	s Desc =Code_"-"_Name
	i Parent="roo" s Parent=0
	i (Active'="Y")||(Active'="N") s Active="Y"
	&sql(insert into dhc_ca_cache_data.DataLevelSets (DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent,DataLevelSets_order) values(:Code,:Name,:Desc,:Remark,:Leaf,:Active,:Parent,:order))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 更新记录
/// Table：DataLevelSets
/// Input：RowId-所在行号;Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体数据;Active-有效;Parent-父ID;order-顺序;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(Rowid, Code, Name, Remark, Leaf, Active, order) As %String
{
	
	n (Rowid, Code, Name, Remark, Leaf, Active, order)
	s Desc =Code_"-"_Name
	s Rs=""
	&sql(update dhc_ca_cache_data.DataLevelSets set DataLevelSets_code=:Code,DataLevelSets_name=:Name,DataLevelSets_active=:Active,DataLevelSets_shortcut=:Desc,DataLevelSets_remark=:Remark,DataLevelSets_end=:Leaf,DataLevelSets_order=:order where %ID=:Rowid)
	s Rs=SQLCODE
	i Active="N" d
	.s Rs=..UpdateBySource(Rowid)
	q Rs
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查看一条数据是否是末端树枝
/// Table：DataLevelSets
/// Input：Rowid-ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelSets).CheckRec("1")
ClassMethod CheckRec(Rowid)
{
	n (Rowid)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and %ID='"_Rowid_"'"

	s ResultString="Y"

	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s ResultString = Result.Data("DataLevelSets_end")
	}
	d Result.Close()
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 遍历所有同根节点
/// Table：DataLevelSets
/// Input：Rowid-ID;ItemDr-数据ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckExist(Rowid, ItemDr)
{
	n (Rowid,ItemDr,ResultString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_Rowid_"'"

	s ResultString=""

	d Result.Prepare(SqlStr)
	d Result.Execute()
	i ResultString="" d
	.s ResultString =..CheckItemExist(Rowid,ItemDr)
	While(Result.Next())
	{	
		i ResultString=0 d
		.s Rowid = Result.Data("DataLevelSets_rowid")
		.s ResultString =..CheckItemExist(Rowid,ItemDr)
		.d ..CheckExist(Rowid,ItemDr)
	}
	d Result.Close()
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查看此数据是否已经被添加过
/// Table：DataLevelSets
/// Input：Rowid-ID;ItemDr-数据ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckItemExist(ParRef, ItemDr)
{
	n (ParRef,ItemDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr from dhc_ca_cache_data.LevelItems where LevelItems_childSub>0 and LevelItems_parRef='"_ParRef_"' and LevelItems_itemDr='"_ItemDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		//ParRefs RString = ParRef
		s RString=$p(^DHCCADATALEVELSETS(ParRef),"^",2)
	}
	d Result.Close()
	q RString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查找根节点
/// Table：DataLevelSets
/// Input：ParRef-父ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod FindSource(ParRef)
{
	s RString=""
	n (ParRef,RString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and %ID='"_ParRef_"'"
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s TmpParent=0
		s TmpParent = Result.Data("DataLevelSets_parent")
		i TmpParent'=0 d 
		.d ..FindSource(TmpParent)
		e  d  
		.s RString=ParRef
	}
	d Result.Close()
	q RString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 更新所有同根的节点
/// Table：DataLevelSets
/// Input：Rowid-ID;ItemDr-数据ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod UpdateBySource(Rowid)
{
	n (Rowid)
	TSTART
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_Rowid_"'"

	s ResultString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		
		
		s Rowid = Result.Data("DataLevelSets_rowid")
		d ..UpdateBySource(Rowid)
		&sql(update dhc_ca_cache_data.DataLevelSets set DataLevelSets_active='N' where %ID=:Rowid)
		i SQLCODE'=0 d  s ResultString=SQLCODE
	}
	d Result.Close()
	i ResultString'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 遍历所有同根节点
/// Table：DataLevelSets
/// Input：root-根节点ID;ResultString-返回的结果变量
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod GetNodes(root, ResultString)
{
	n (root,ResultString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_root_"'"
	s ResultString=""
	s ResultString=..GetLeaves(root)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		s Rowid = Result.Data("DataLevelSets_rowid")
		i ResultString="" d
		.s ResultString=..GetLeaves(Rowid)
		e  i (..GetLeaves(Rowid)'=0) d
		.s ResultString =ResultString_","_..GetLeaves(Rowid)
		s ResultString=ResultString_","_..GetNodes(Rowid, ResultString)
	}
	d Result.Close()
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 返回此节点所有的节点
/// Table：DataLevelSets
/// Input：NodeDr-节点的DR
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod GetLeaves(NodeDr)
{
	n (NodeDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr from dhc_ca_cache_data.LevelItems where LevelItems_childSub>0 and LevelItems_parRef='"_NodeDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		i RString=0 d
		.s RString=Result.Data("LevelItems_itemDr")
		e  d
		.s RString=RString_","_Result.Data("LevelItems_itemDr")
	}
	d Result.Close()
	q RString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 返回所有未添加此根节点的数据
/// Table：DataLevelSets
/// Input：hospDr-医院ID;start-开始行号;limit-查找条数;active-是否有效;nodeDr-节点DR;str-模糊查询字符串;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelSets).GetDepts("2","0","10","Y","6","","")
ClassMethod GetDepts(dataTypeDr, start, limit, active, nodeDr, str, searchValue)
{
	;q dataTypeDr_"^"_start_"^"_limit_"^"_active_"^"_nodeDr_"^"_str_"^"_searchValue
	n (dataTypeDr, start, limit, active, nodeDr, str,searchValue)
	Set result = ##class(%Library.ResultSet).%New()	
	s SqlStr="SELECT DataItemCorres_rowid,DataItemCorres_typeDr,DataItemCorres_order,DataItemCorres_itemDr FROM dhc_ca_cache_data.DataItemCorres"
	s whereStr=" WHERE DataItemCorres_rowid>0" /// AND DataLevelSets_active='"_active_"'"
	i dataTypeDr'="" d
	s whereStr=whereStr_" AND DataItemCorres_typeDr='"_dataTypeDr_"'"
	s SqlStr=SqlStr_whereStr
 	s rootDr=0
	s rootDr=..FindSource(nodeDr)
	s items=""
	s items=..GetNodes(rootDr)
	i items'="" d
	.s SqlStr=SqlStr_" and DataItemCorres_itemDr not in("_items_")"
	i str'="" d
	s RString=0
	
	d result.Prepare(SqlStr)
	d result.Execute()

	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowid^typeDr^typeName^typeShortCut^order^itemDr^itemCode^itemName^itemShortCut"
	
	While(result.Next())
	{
		s rowid=result.Data("DataItemCorres_rowid")
		s typeDr=result.Data("DataItemCorres_typeDr")
		s typeName=""
		s typeShortCut=""
		i typeDr'="" d
		.s typeName=$p($g(^DHCCADATAITEMTYPES(typeDr)),"^",3)
		.s typeShortCut=$p($g(^DHCCADATAITEMTYPES(typeDr)),"^",4)
		
		s order=result.Data("DataItemCorres_order")
		
		s itemDr=result.Data("DataItemCorres_itemDr")
		s itemName=""
		s itemCode=""
		s itemShortCut=""
		i itemDr'="" d
		.s itemCode=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",2)
		.s itemName=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",3)
		.s itemShortCut=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",4)
		.s itemActive=$p($g(^DHCCAALLDATAITEMS(itemDr)),"^",6)

		s tmp=rowid_"^"_typeDr_"^"_typeName_"^"_typeShortCut_"^"_order_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemShortCut
		
		i itemActive=active d
		.i searchValue'="" d
		..q:(itemShortCut'[searchValue)
		..i (count>=start)&(count<=end) d
		...d json.InsertRowData(tmp)
		..s count=count+1
		.e  d
		..i (count>=start)&(count<=end) d
		...d json.InsertRowData(tmp)
		..s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

/// Creator：zbp
/// CreatDate：2013-04-22
/// Description: 返回项目所在的数据分层
/// Table：DataLevelSets
/// Input：root 父节点 itemdr:数据项
/// Output：
/// Return：项目所在的数据分层
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelSets).GetLevelItemsParRef(22,87)
ClassMethod GetLevelItemsParRef(code, itemdr)
{
	
	n (code,itemdr)
	s root=$o(^DHCCADATALEVELSETS(0,"Code",code,""))
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_parRef from dhc_ca_cache_data.LevelItems where LevelItems_childSub!=0 and levelItems_parref->DataLevelSets_Parent='"_root_"' and LevelItems_ItemDr='"_itemdr_"'"
	s RString=0
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{   
		i RString=0 d
		.s RString=Result.Data("LevelItems_parRef")
		e  d
		.s RString=RString_","_Result.Data("LevelItems_parRef")
	}
	d Result.Close()
	q RString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uDataLevelSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
