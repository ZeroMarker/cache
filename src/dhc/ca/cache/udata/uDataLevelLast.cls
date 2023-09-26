/// Creator: 杨旭
/// CreatDate: 2009-8-27
/// Description: 数据分层维护
Class dhc.ca.cache.udata.uDataLevelLast Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-8-23
/// Description: 插入一末端业务项表数据
/// Table：DataLevelLast
/// Input：ltemDr-业务项Dr;recCost-接受分摊标志;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelLast).InsertRec(1,1,1)
ClassMethod InsertRec(ltemDr, parRef, order) As %String
{
	n (ltemDr, parRef, order)
	q:parRef="roo" "roo"
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uDataLevel).FindSource(parRef)
	s Rs=""
	s Rs=##class(dhc.ca.cache.udata.uDataLevel).CheckExist(TmpDr,ltemDr)
	q:Rs'=0 Rs
	&sql(insert into dhc_ca_cache_data.DataLevelLast (DataLevelLast_dataItemDr,DataLevelLast_parRef,DataLevelLast_order) values(:ltemDr,:parRef,:order))
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-23
/// Description: 更新一末端业务项表数据
/// Table：DataLevelLast
/// Input：ltemDr-业务项Dr;recCost-接受分摊标志;rowid-ID;parRef-父ID
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.ca.cache.udata.uDataLevelLast).UpdateRec(2,"1||2",1,1)
ClassMethod UpdateRec(ltemDr, rowid, parRef, order) As %String
{
	n (ltemDr, rowid, parRef, order)
	q:parRef="roo" "roo"
	s Str=..CheckRowid(rowid,ltemDr)
	s TmpDr=""
	s TmpDr=##class(dhc.ca.cache.udata.uDataLevel).FindSource(parRef)
	s Rs=0
	i Str=0 d
	.s Rs=##class(dhc.ca.cache.udata.uDataLevel).CheckExist(TmpDr,ltemDr)
	q:Rs'=0 Rs
	&sql(update dhc_ca_cache_data.DataLevelLast set DataLevelLast_dataItemDr=:ltemDr,DataLevelLast_order=:order where %ID=:rowid)
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-8-23
/// Description: 删除记录
/// Table：DataLevelLast
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	&SQL(DELETE FROM dhc_ca_cache_data.DataLevelLast WHERE %ID=:rowId)
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
	Set SqlStr = "select DataLevelLast_rowid,DataLevelLast_dataItemDr,DataLevelLast_order from dhc_ca_cache_data.DataLevelLast where DataLevelLast_childSub>0 and DataLevelLast_parRef="_ParRef

	If SortField = "rowid" Set SortField = "DataLevelLast_rowid"
	If SortField = "itemName" Set SortField = "DataLevelLast_dataItemDr"
	If SortField = "order" Set SortField = "DataLevelLast_order"
	
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
		
		s Rowid = Result.Data("DataLevelLast_rowid")
		s LocDr = Result.Data("DataLevelLast_dataItemDr")
		s Order = Result.Data("DataLevelLast_order")
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
		
		s Tmp=Rowid_"^"_LocDr_"^"_LocName_"^"_HospDr_"^"_HospName_"^"_Order
		
		
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
	s ResultString = Json.getJsonData("rowid^ltemDr^itemName^hospDr^hospName^order",Count)
 	k Json
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-8-24
/// Description: 查看此业务项是否已经被添加过
/// Table：DataLevelLast
/// Input：Rowid-ID;LocDr-业务项ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDataLevel).CheckLocExist(1,1)
ClassMethod CheckRowid(Rowid, LocDr)
{
	n (Rowid,LocDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DataLevelLast_rowid,DataLevelLast_dataItemDr from dhc_ca_cache_data.DataLevelLast where DataLevelLast_childSub>0 and %ID='"_Rowid_"' and DataLevelLast_dataItemDr='"_LocDr_"'"

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
<StreamLocation>^dhc.ca.c.uDataLevelLastS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
