/// 名称: 末端数据表数据维护
/// 描述: 末端数据表添加与修改
/// 编写者：王赢赢
/// 编写日期:2009-10-20
Class dhc.ca.cache.udata.uLevelItems Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：王赢赢
/// CreatDate：2009-10-22
/// Description: 查看order是否重复
/// Table：LevelItems
/// Input：
/// Output：
/// Return：
/// Others：
ClassMethod IfRepOrder(parRef, order) As %String
{
	n (parRef,order)
	s rowid=0
	s rowid=$o(^DHCCADATALEVELSETS(0,"Order",parRef,order,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 插入一末端数据表数据
/// Table：LevelItems
/// Input：itemDr-数据Dr;itemTypeDr-数据类别Dr;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod InsertRec(itemDr, itemTypeDr, parRef, order) As %String
{
	n (itemDr, itemTypeDr, parRef, order)
	q:parRef="roo" "roo"
	
	s tmpId=0
	s tmpId=..IfRepOrder(parRef,order)
	q:tmpId>0 "RepOrder"
	
	//s TmpDr=""
	//s TmpDr=##class(dhc.ca.cache.udata.uDataLevelSets).FindSource(parRef)
	//q TmpDr
	//s Rs=""
	//s Rs=##class(dhc.ca.cache.udata.uDataLevelSets).CheckExist(TmpDr,itemDr)
	//q:Rs'=0 Rs
	&sql(insert into dhc_ca_cache_data.LevelItems (LevelItems_itemDr,LevelItems_itemTypeDr,LevelItems_parRef,LevelItems_order) values(:itemDr,:itemTypeDr,:parRef,:order))
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 
/// Table：LevelItems
/// Input：itemDr-数据Dr;itemTypeDr-数据类别Dr;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod CheckExist(itemDr, parRef) As %String
{
	s TmpDr=0
	s TmpDr=##class(dhc.ca.cache.udata.uDataLevelSets).FindSource(parRef)
	s Rs=0
	s Rs=##class(dhc.ca.cache.udata.uDataLevelSets).CheckExist(TmpDr,itemDr)
	q Rs
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 更新一末端数据表数据
/// Table：LevelItems
/// Input：itemDr-数据Dr;itemTypeDr-接受分摊标志;rowid-ID;parRef-父ID
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(itemDr, itemTypeDr, rowid, parRef, order) As %String
{
	n (itemDr, itemTypeDr, rowid, parRef, order)
	q:parRef="roo" "roo"
	
	s tmpId=0
	s tmpId=..IfRepOrder(parRef,order)
	q:(tmpId>0)&(tmpId'=$p(rowid,"||",2)) "RepOrder"
	
	//s Str=..CheckRowid(rowid,itemDr)
	//s TmpDr=""
	//s TmpDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(parRef)
	//s Rs=0
	//i Str=0 d
	//.s Rs=##class(dhc.ca.cache.udata.uDeptLevelSets).CheckExist(TmpDr,itemDr)
	//q:Rs'=0 Rs
	&sql(update dhc_ca_cache_data.LevelItems set LevelItems_itemDr=:itemDr,LevelItems_itemTypeDr=:itemTypeDr,LevelItems_order=:order where %ID=:rowid)
	q SQLCODE
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 删除记录
/// Table：LevelItems
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_parRef,LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr,LevelItems_order from dhc_ca_cache_data.LevelItems where %ID='"_rowId_"'"
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s parRef=0
	While(Result.Next())
	{
		s parRef = Result.Data("LevelItems_parRef")
	}
	&SQL(DELETE FROM dhc_ca_cache_data.LevelItems WHERE %ID=:rowId)
	i SQLCODE'=0 d  s parRef=0
	q parRef
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查询符合条件的记录
/// Table：LevelItems
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;ParRef-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uLevelItems).ListRec("","","rowid","DESC",0,15,30)
ClassMethod ListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
{
	;q SearchField_"^"_SearchValue_"^"_SortField_"^"_SortDir_"^"_Start_"^"_Limit_"^"_ParRef
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr,LevelItems_order from dhc_ca_cache_data.LevelItems where LevelItems_childSub>0 and LevelItems_parRef="_ParRef

	If SortField = "rowid" Set SortField = "LevelItems_rowid"
	If SortField = "itemName" Set SortField = "LevelItems_itemDr"
	If SortField = "itemTypeDr" Set SortField = "LevelItems_itemTypeDr"
	If SortField = "order" Set SortField = "LevelItems_order"
	
	Set ConditionOrderBy = ""
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy

	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Count = 0
	s ResultString = ""
	s End = Start+Limit

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()

	While(Result.Next())
	{
		
		s Rowid = Result.Data("LevelItems_rowid")
		s itemDr = Result.Data("LevelItems_itemDr")
		s RecCost = Result.Data("LevelItems_itemTypeDr")
		s Order = Result.Data("LevelItems_order")
		s itemName=""
		s itemTypeName=""
		
		i RecCost'="" d
		.i $d(^DHCCADATAITEMTYPES(RecCost)) d
		..s itemTypeName=$p($g(^DHCCADATAITEMTYPES(RecCost)),"^",3)


		i itemDr'="" d
		.i $d(^DHCCAALLDATAITEMS(itemDr)) d
		..s itemCode=$p(^DHCCAALLDATAITEMS(itemDr),"^",2)
		..s itemName=$p(^DHCCAALLDATAITEMS(itemDr),"^",3)

		
		s Tmp=Rowid_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_RecCost_"^"_Order_"^"_itemTypeName
		
		
		i SearchValue '= "" d
		.q:(SearchField = "Code")&(itemCode'[SearchValue)
		.q:(SearchField = "Name")&(itemName'[SearchValue)
		.s Count = Count+1
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
		e  d
		.s Count=Count+1
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
	}
	d Result.Close()
	s ResultString = Json.getJsonData("rowid^itemDr^itemCode^itemName^itemTypeDr^order^itemTypeName",Count)
 	k Json
	q ResultString
}

/// Creator：王赢赢
/// CreatDate：2009-10-20
/// Description: 查看此数据是否已经被添加过
/// Table：LevelItems
/// Input：Rowid-ID;itemDr-数据ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckRowid(Rowid, itemDr)
{
	n (Rowid,itemDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr from dhc_ca_cache_data.LevelItems where LevelItems_childSub>0 and %ID='"_Rowid_"' and LevelItems_itemDr='"_itemDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s RString=1
	}
	d Result.Close()
	q RString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uLevelItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
