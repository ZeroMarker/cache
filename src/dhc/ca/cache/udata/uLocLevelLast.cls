/// 名称: 末端科室表数据维护
/// 描述: 末端科室表添加与修改
/// 编写者：杨旭
/// 编写日期:2009-8-23
Class dhc.ca.cache.udata.uLocLevelLast Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-8-23
/// Description: 插入一末端科室表数据
/// Table：LocLevelLast
/// Input：locDr-科室Dr;recCost-接受分摊标志;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uLocLevelLast).InsertRec(1,"Y",1)
ClassMethod InsertRec(locDr, recCost, parRef, order) As %String
{
	n (locDr, recCost, parRef, order)
	q:parRef="roo" "roo"
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uLocLevel).FindSource(parRef)
	s Rs=""
	s Rs=##class(dhc.ca.cache.udata.uLocLevel).CheckExist(TmpDr,locDr)
	q:Rs'=0 Rs
	&sql(insert into dhc_ca_cache_data.LocLevelLast (LocLevelLast_locDr,LocLevelLast_recCost,LocLevelLast_parRef,LocLevelLast_order) values(:locDr,:recCost,:parRef,:order))
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-23
/// Description: 更新一末端科室表数据
/// Table：LocLevelLast
/// Input：locDr-科室Dr;recCost-接受分摊标志;rowid-ID;parRef-父ID
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(locDr, recCost, rowid, parRef, order) As %String
{
	n (locDr, recCost, rowid, parRef, order)
	q:parRef="roo" "roo"
	s Str=..CheckRowid(rowid,locDr)
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uLocLevel).FindSource(parRef)
	s Rs=0
	i Str=0 d
	.s Rs=##class(dhc.ca.cache.udata.uLocLevel).CheckExist(TmpDr,locDr)
	q:Rs'=0 Rs
	&sql(update dhc_ca_cache_data.LocLevelLast set LocLevelLast_locDr=:locDr,LocLevelLast_recCost=:recCost,LocLevelLast_order=:order where %ID=:rowid)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-23
/// Description: 删除记录
/// Table：LocLevelLast
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.LocLevelLast WHERE %ID=:rowId)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查询符合条件的记录
/// Table：DHCCA_BusType
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;ParRef-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：
ClassMethod ListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevelLast_rowid,LocLevelLast_locDr,LocLevelLast_recCost,LocLevelLast_order from dhc_ca_cache_data.LocLevelLast where LocLevelLast_childSub>0 and LocLevelLast_parRef="_ParRef

	If SortField = "rowid" Set SortField = "LocLevelLast_rowid"
	If SortField = "locName" Set SortField = "LocLevelLast_locDr"
	If SortField = "recCost" Set SortField = "LocLevelLast_recCost"
	If SortField = "order" Set SortField = "LocLevelLast_order"
	
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
		
		s Rowid = Result.Data("LocLevelLast_rowid")
		s LocDr = Result.Data("LocLevelLast_locDr")
		s RecCost = Result.Data("LocLevelLast_recCost")
		s Order = Result.Data("LocLevelLast_order")
		s LocName=""
		s HospDr=""
		i LocDr'="" d
		.i $d(^DHCCALOCS(LocDr)) d
		..s LocName=$p(^DHCCALOCS(LocDr),"^",2)
		..s HospDr=$p(^DHCCALOCS(LocDr),"^",10)
		
		s HospName=""
		i HospDr'="" d
		.i $d(^DHCCAHOSPITALS(HospDr)) d
		..s HospName=$p(^DHCCAHOSPITALS(HospDr),"^",2)
		
		s Tmp=Rowid_"^"_LocDr_"^"_LocName_"^"_RecCost_"^"_HospDr_"^"_HospName_"^"_Order
		
		
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
	s ResultString = Json.getJsonData("rowid^locDr^locName^recCost^hospDr^hospName^order",Count)
 	k Json
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查看此科室是否已经被添加过
/// Table：LocLevelLast
/// Input：Rowid-ID;LocDr-科室ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uLocLevel).CheckLocExist(1,1)
ClassMethod CheckRowid(Rowid, LocDr)
{
	n (Rowid,LocDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LocLevelLast_rowid,LocLevelLast_locDr,LocLevelLast_recCost from dhc_ca_cache_data.LocLevelLast where LocLevelLast_childSub>0 and %ID='"_Rowid_"' and LocLevelLast_locDr='"_LocDr_"'"

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
<Data name="uLocLevelLastDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.c.uLocLevelLastD</DataLocation>
<DefaultData>uLocLevelLastDefaultData</DefaultData>
<IdLocation>^dhc.ca.c.uLocLevelLastD</IdLocation>
<IndexLocation>^dhc.ca.c.uLocLevelLastI</IndexLocation>
<StreamLocation>^dhc.ca.c.uLocLevelLastS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
