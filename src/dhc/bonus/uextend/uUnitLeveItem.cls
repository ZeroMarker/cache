/// 名称: 末端科室表数据维护
/// 描述: 末端科室表添加与修改
/// 编写者：Zhao LiGuo
/// 编写日期:2011-09-17
Class dhc.bonus.uextend.uUnitLeveItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：Zhao LiGuo
/// CreatDate：2011-09-17
/// Description: 插入一末端科室表数据
/// Table：LevelDepts
/// Input：deptDr-科室Dr;recCost-接受分摊标志;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.uextend.uUnitLeveItem).InsertRec("","","","",0,8,5)
ClassMethod InsertRec(order, deptDr, unitDesc, distCost, parRef) As %String
{
	n (order, deptDr, unitDesc, distCost, parRef)
	q:parRef="roo" "roo"
	s TmpDr=parRef
	//s TmpDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(parRef)
	s Rs=""
	//s Rs=##class(dhc.ca.cache.udata.uDeptLevelSets).CheckExist(TmpDr,deptDr)
	//q:Rs'=0 Rs
	&sql(insert into  dhc_bonus_extend.UnitLeveItem(UnitLeveSetID,BonusUnitID,ItemOrder,beizhu) values(:TmpDr,:deptDr,:order,:unitDesc))
	q SQLCODE
}

/// Creator：Zhao LiGuo
/// CreatDate：2011-09-17
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

	/*
	s Str=..CheckRowid(rowid,deptDr)
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uDeptLevelSets).FindSource(parRef)
	s Rs=0
	i Str=0 d
	.s Rs=##class(dhc.ca.cache.udata.uDeptLevelSets).CheckExist(TmpDr,deptDr)
	q:Rs'=0 Rs
	*/
	
	&sql(update dhc_bonus_extend.UnitLeveItem set UnitLeveSetID=:parRef, BonusUnitID=:deptDr,ItemOrder=:order where UnitLeveItemID=:rowid)
	q SQLCODE
}

/// Creator：Zhao LiGuo
/// CreatDate：2011-09-17
/// Description: 删除记录
/// Table：LevelDepts
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	/*	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelDepts_parRef,LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_recCost,LevelDepts_order from dhc_ca_cache_data.LevelDepts where %ID='"_rowId_"'"
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	s parRef=0
	While(Result.Next())
	{
		s parRef = Result.Data("LevelDepts_parRef")
	}
		*/
		
	&SQL(DELETE FROM dhc_bonus_extend.UnitLeveItem WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator：Zhao LiGuo
/// CreatDate：2011-09-17
/// Description: 查询符合条件的记录
/// Table：LevelDepts
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;ParRef-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.bonus.uextend.uUnitLeveItem).ListRec("","","","",0,8,5)
ClassMethod ListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
	Set Result = ##class(%Library.ResultSet).%New()
	//Set SqlStr = "select LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_distCost,LevelDepts_recCost,LevelDepts_order from dhc_ca_cache_data.LevelDepts where LevelDepts_childSub>0 and LevelDepts_parRef="_ParRef
	
	set SqlStr = " select  a.UnitLeveItemID ,c.BonusUnitTypeID unitTypeDr,c.UnitTypeName,b.BonusUnitID,b.BonusUnitCode,b.BonusUnitName,a.ItemOrder"
				_" from dhc_bonus_extend.UnitLeveItem a,dhc_bonus_data.BonusUnit b,dhc_bonus_data.BonusUnitType c"
				_" where a.BonusUnitID =b.BonusUnitID and b.BonusUnitTypeID = c.BonusUnitTypeID "
				_" and UnitLeveSetID='"_ParRef_"'"
				
	If SortField = "rowid" Set SortField = "a.UnitLeveItemID"
	If SortField = "deptName" Set SortField = "b.BonusUnitName"

	If SortField = "order" Set SortField = "a.ItemOrder"
	
	Set ConditionOrderBy = ""
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy

	//w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Count = 0
	s ResultString = ""
	s End = Start+Limit

	s Json = ##class(dhc.bonus.comm.JsonObj).%New()

	While(Result.Next())
	{
		
		s Rowid = Result.Data("UnitLeveItemID")
		s deptDr = Result.Data("BonusUnitID")
		s RecCost ="Y"
		s distCost = "Y"
		s Order = Result.Data("ItemOrder")
		s deptCode=Result.Data("BonusUnitCode")
		s deptName=Result.Data("BonusUnitName")
		
		s unitDr = Result.Data("BonusUnitID")
		s unitName= Result.Data("BonusUnitName")
		s unitTypeDr= Result.Data("unitTypeDr")
		s unitTypeName= Result.Data("UnitTypeName")

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

/// Creator：Zhao LiGuo
/// CreatDate：2011-09-17
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
<StreamLocation>^dhc.bonus.uex6AF.uUnitLeveItemS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
