/// 名称: 末端科室表数据维护
/// 描述: 末端科室表添加与修改
/// 编写者：杨旭
/// 编写日期:2009-10-17
Class dhc.ca.cache.udata.uLevelDepts Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 插入一末端科室表数据
/// Table：LevelDepts
/// Input：deptDr-科室Dr;recCost-接受分摊标志;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod InsertRec(order, deptDr, recCost, distCost, parRef) As %String
{
	n (order, deptDr, recCost, distCost, parRef)
	q:parRef="roo" "roo"
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(parRef)
	s Rs=""
	s Rs=##class(dhc.ca.cache.udata.uDeptLevelSets).CheckExist(TmpDr,deptDr)
	q:Rs'=0 Rs
	&sql(insert into dhc_ca_cache_data.LevelDepts (LevelDepts_order,LevelDepts_deptDr,LevelDepts_recCost,LevelDepts_distCost,LevelDepts_parRef) values(:order,:deptDr,:recCost,:distCost,:parRef))
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 更新一末端科室表数据
/// Table：LevelDepts
/// Input：deptDr-科室Dr;recCost-接受分摊标志;rowid-ID;parRef-父ID
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(rowid, order, deptDr, recCost, distCost, parRef) As %String
{
	n (rowid, order, deptDr, recCost, distCost, parRef)
	q:parRef="roo" "roo"
	s Str=..CheckRowid(rowid,deptDr)
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(parRef)
	s Rs=0
	i Str=0 d
	.s Rs=##class(dhc.ca.cache.udata.uDeptLevelSets).CheckExist(TmpDr,deptDr)
	q:Rs'=0 Rs
	&sql(update dhc_ca_cache_data.LevelDepts set LevelDepts_deptDr=:deptDr,LevelDepts_recCost=:recCost,LevelDepts_order=:order,LevelDepts_distCost=:distCost where %ID=:rowid)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 删除记录
/// Table：LevelDepts
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelDepts_parRef,LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_recCost,LevelDepts_order from dhc_ca_cache_data.LevelDepts where %ID='"_rowId_"'"
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s parRef=0
	While(Result.Next())
	{
		s parRef = Result.Data("LevelDepts_parRef")
	}
	&SQL(DELETE FROM dhc_ca_cache_data.LevelDepts WHERE %ID=:rowId)
	i SQLCODE'=0 d  s parRef=0
	q parRef
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查询符合条件的记录
/// Table：LevelDepts
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;ParRef-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uLevelDepts).ListRec("","","rowid","DESC",0,15,2)
ClassMethod ListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
{
	;Q SearchField_"^"_SearchValue_"^"_SortField_"^"_SortDir_"^"_Start_"^"_Limit_"^"_ParRef
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_distCost,LevelDepts_recCost,LevelDepts_order from dhc_ca_cache_data.LevelDepts where LevelDepts_childSub>0 and LevelDepts_parRef="_ParRef

	If SortField = "rowid" Set SortField = "LevelDepts_rowid"
	If SortField = "deptName" Set SortField = "LevelDepts_deptDr"
	If SortField = "recCost" Set SortField = "LevelDepts_recCost"
	If SortField = "distCost" Set SortField = "LevelDepts_distCost"
	If SortField = "order" Set SortField = "LevelDepts_order"
	
	Set ConditionOrderBy = ""
	
	i SortField '= "" d
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir
	e  d 
	.s ConditionOrderBy=" ORDER BY LevelDepts_order ASC "

	Set SqlStr = SqlStr_ConditionOrderBy

	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Count = 0
	s ResultString = ""
	s End = Start+Limit

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()

	While(Result.Next())
	{
		
		s Rowid = Result.Data("LevelDepts_rowid")
		s deptDr = Result.Data("LevelDepts_deptDr")
		s RecCost = Result.Data("LevelDepts_recCost")
		s distCost = Result.Data("LevelDepts_distCost")
		s Order = Result.Data("LevelDepts_order")
		s deptCode=""
		s deptName=""
		s unitDr=""
		s unitName=""
		s unitTypeDr=""
		s unitTypeName=""
		i deptDr'="" d
		.s deptCode=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",1)
		.s deptName=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",2)
		.s unitDr=$p($g(^DHCCAUNITDEPTS(deptDr)),"^",8)
		.i unitDr'="" d
		..s unitName=$p($g(^DHCCAUNITS(unitDr)),"^",2)
		..s unitTypeDr=$p($g(^DHCCAUNITS(unitDr)),"^",8)
		..i unitTypeDr'="" d
		...s unitTypeName=$p($g(^DHCCAUNITTYPES(unitTypeDr)),"^",2)
		
		s Tmp=Rowid_"^"_unitTypeDr_"^"_unitTypeName_"^"_unitDr_"^"_unitName_"^"_deptDr_"^"_deptCode_"^"_deptName_"^"_RecCost_"^"_distCost_"^"_Order
		
		
		i SearchValue '= "" d
		.q:(SearchField = "Code")&(Code'[SearchValue)
		.q:(SearchField = "Name")&(Name'[SearchValue)
		.s Count = Count+1
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
		e  d
		.s Count=Count+1
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
	}
	d Result.Close()
	s ResultString = Json.getJsonData("rowid^unitTypeDr^unitTypeName^unitDr^unitName^deptDr^deptCode^deptName^recCost^distCost^order",Count)
 	k Json
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查看此科室是否已经被添加过
/// Table：LevelDepts
/// Input：Rowid-ID;deptDr-科室ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckRowid(Rowid, deptDr)
{
	n (Rowid,deptDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_recCost from dhc_ca_cache_data.LevelDepts where LevelDepts_childSub>0 and %ID='"_Rowid_"' and LevelDepts_deptDr='"_deptDr_"'"

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
<StreamLocation>^dhc.ca.c.uLevelDeptsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
