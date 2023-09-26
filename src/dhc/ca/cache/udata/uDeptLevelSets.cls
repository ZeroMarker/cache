/// 名称: 科室分层数据维护
/// 描述: 科室分层添加与修改
/// 编写者：杨旭
/// 编写日期:2009-10-17
Class dhc.ca.cache.udata.uDeptLevelSets Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查询符合条件的记录
/// Table：DeptLevelSets
/// Input：SearchField-查询字段; SearchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;Parent-父节点;Active-是否有效
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uDeptLevelSets).RListRec("desc","","","",0,"10","roo","Y")
ClassMethod RListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
{
	;q SearchField_"^"_SearchValue_"^"_SortField_"^"_SortDir_"^"_Start_"^"_Limit_"^"_Parent_"^"_Active
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_repFlag,DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent,DeptLevelSets_order from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_parent='"_Parent_"'"
	s Count=0
	s ResultString=""
	
	If SortField = "id" Set SortField = "DeptLevelSets_rowid"
	If SortField = "code" Set SortField = "DeptLevelSets_code"
	If SortField = "name" Set SortField = "DeptLevelSets_name"
	If SortField = "order" Set SortField = "DeptLevelSets_order"
	If SortField = "remark" Set SortField = "DeptLevelSets_remark"
	If SortField = "end" Set SortField = "DeptLevelSets_end"
	If SortField = "active" Set SortField = "DeptLevelSets_active"
	If SortField = "repFlag" Set SortField = "DeptLevelSets_repFlag"
	
	
	Set ConditionOrderBy = ""
	
	If Active'="" Do
	.s SqlStr=SqlStr_" and DeptLevelSets_active='"_Active_"'"
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy
	
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADEPTLEVELSETS(Parent)) d
	..s TmpEnd=$p(^DHCCADEPTLEVELSETS(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	s Json = ##class(dhc.ca.cache.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("DeptLevelSets_rowid")
		s code = Result.Data("DeptLevelSets_code")
		s name = Result.Data("DeptLevelSets_name")
		s desc = Result.Data("DeptLevelSets_shortcut")
		s remark = Result.Data("DeptLevelSets_remark")
		s end = Result.Data("DeptLevelSets_end")
		s active = Result.Data("DeptLevelSets_active")
		s parent = Result.Data("DeptLevelSets_parent")
		s order = Result.Data("DeptLevelSets_order")
		s repFlag = Result.Data("DeptLevelSets_repFlag")
		s Tmp=rowid_"^"_code_"^"_name_"^"_desc_"^"_remark_"^"_end_"^"_end_"^"_active_"^"_parent_"^col"_"^"_order_"^"_repFlag
		s Count=Count+1
		i SearchValue'="" d
		.i (SearchField="active") d
		..i (SearchValue="Y") || (SearchValue="y") s SearchValue="Y"
		..e  s SearchValue="N"
		.q:(SearchField="order")&(order'[SearchValue)
		.q:(SearchField="code")&(code'[SearchValue)
		.q:(SearchField="name")&(name'[SearchValue)
		.q:(SearchField="desc")&(desc'[SearchValue)
		.q:(SearchField="active")&(active'[SearchValue)
		.i (Count>=Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
		e  d
		.i (Count>Start)&(Count<=End) d
		..d Json.InsertRowData(Tmp)
		
	}

	
	d Result.Close()
	s ResultString = Json.getJsonData("id^code^name^desc^remark^leaf^end^active^parent^uiProvider^order^repFlag^recCost^hospDr^hospName^locDr",Count)
 	k Json
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查询符合条件的记录
/// Table：DeptLevelSets
/// Input：Parent-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.ca.cache.udata.uDeptLevelSets).ListRec("roo")
ClassMethod ListRec(Parent)
{
	;q Parent
	n (Parent)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_order,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_active = 'Y' and DeptLevelSets_parent='"_Parent_"' ORDER BY DeptLevelSets_order asc"
	
	s LocDr=""
	s LocName=""
	s DeptLevelSets=""
	s ResultString="["
	s TmpEnd=""
	i Parent'="" d
	.i $d(^DHCCADEPTLEVELSETS(Parent)) d
	..s TmpEnd=$p(^DHCCADEPTLEVELSETS(Parent),"^",5)
	
	i (TmpEnd="N")||(Parent=0) d
	.//w SqlStr
	.d Result.Prepare(SqlStr)
	.d Result.Execute()

	While(Result.Next())
	{
		s rowid = Result.Data("DeptLevelSets_rowid")
		s code = Result.Data("DeptLevelSets_code")
		s name = Result.Data("DeptLevelSets_name")
		s desc = Result.Data("DeptLevelSets_shortcut")
		s remark = Result.Data("DeptLevelSets_remark")
		s end = Result.Data("DeptLevelSets_end")
		s active = Result.Data("DeptLevelSets_active")
		s parent = Result.Data("DeptLevelSets_parent")
		s ResultString=ResultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',desc:'"_desc_"',remark:'"_remark_"',leaf:false,end:'"_end_"',active:'"_active_"',parent:'"_parent_"',uiProvider:'col'},"
	}
	//^DHCCADEPTLEVELSETS(0,"DeptOrder",{DeptLevelSets.DeptLevelSets_rowid},{LevelDepts_order},{LevelDepts_childSub})
	s Order=""
	i Parent'="" d
	.f  s Order=$o(^DHCCADEPTLEVELSETS(0,"DeptOrder",Parent,Order)) q:Order=""  d
	..f  s DeptLevelSets=$o(^DHCCADEPTLEVELSETS(0,"DeptOrder",Parent,Order,DeptLevelSets)) q:DeptLevelSets=""  d
	...q:DeptLevelSets=0
	...s LocDr=$p(^DHCCADEPTLEVELSETS(Parent,"Depts",DeptLevelSets),"^",1)
	...i LocDr'="" d
	....i $d(^DHCCAUNITDEPTS(LocDr)) d
	.....s LocName=$p(^DHCCAUNITDEPTS(LocDr),"^",2)
	.....s ResultString=ResultString_"{id:'"_Parent_"||"_DeptLevelSets_"',code:'',name:'"_LocName_"',desc:'',remark:'',leaf:'true',end:'',active:'Y',parent:'"_$p(^DHCCADEPTLEVELSETS(Parent,"Depts",DeptLevelSets),"^",2)_"',uiProvider:'col'},"
	
	s ResultString=ResultString_"]"
	d Result.Close()
	q ResultString
}

/// Creator: 杨旭
/// CreatDate: 2009-10-17
/// Description: 代码是否存在
/// Table：DeptLevelSets
/// Input: type-类别,code-代码
/// Output: 
/// Return: 不存在返回0,存在返回所在行号
/// Others: 
ClassMethod IfRepCode(code) As %String
{
	n (code)
	s rowid=0
	s rowid=$o(^DHCCADEPTLEVELSETS(0,"Code",code,rowid))
	i rowid="" d  s rowid=0
	q rowid
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 插入一条新科室分层数据
/// Table：DeptLevelSets
/// Input：Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体科室;Active-有效;Parent-父ID;order-顺序;
/// Output：
/// Return：返回执行插入语句后的SQLCODE
/// Others：
ClassMethod InsertRec(Code, Name, Remark, Leaf, Active, Parent, order) As %String
{
	
	n (Code, Name, Remark, Leaf, Active, Parent, order)
	s Desc =Code_"-"_Name
	i Parent="roo" s Parent=0
	s rowid=0
	s rowid=..IfRepCode(Code)
	q:rowid>0 "RepCode"
	i (Active'="Y")||(Active'="N") s Active="Y"
	&sql(insert into dhc_ca_cache_data.DeptLevelSets (DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent,DeptLevelSets_order,DeptLevelSets_repFlag) values(:Code,:Name,:Desc,:Remark,:Leaf,:Active,:Parent,:order,'Y'))
	q SQLCODE
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 更新记录
/// Table：DeptLevelSets
/// Input：RowId-所在行号;Code-代码;Name-名称,;Remark-备注;Leaf-是否是实体科室;Active-有效;Parent-父ID;order-顺序;repFlag-报表输出标志;
/// Output：
/// Return：否则返回执行更新语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(Rowid, Code, Name, Remark, Leaf, Active, order, repFlag) As %String
{
	
	n (Rowid, Code, Name, Remark, Leaf, Active, order, repFlag)
	s Desc =Code_"-"_Name
	s Rs=""
	s tmpRowid=0
	s tmpRowid=..IfRepCode(Code)
	q:(tmpRowid'=0)&(tmpRowid'=Rowid) "RepCode"
	&sql(update dhc_ca_cache_data.DeptLevelSets set DeptLevelSets_code=:Code,DeptLevelSets_name=:Name,DeptLevelSets_active=:Active,DeptLevelSets_shortcut=:Desc,DeptLevelSets_remark=:Remark,DeptLevelSets_end=:Leaf,DeptLevelSets_order=:order,DeptLevelSets_repFlag=:repFlag where %ID=:Rowid)
	s Rs=SQLCODE
	i Active="N" d
	.s Rs=..UpdateBySource(Rowid)
	q Rs
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查看一条数据是否是末端树枝
/// Table：DeptLevelSets
/// Input：Rowid-ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDeptLevelSets).CheckRec("1")
ClassMethod CheckRec(Rowid)
{
	
	n (Rowid)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and %ID='"_Rowid_"'"

	s ResultString="Y"

	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s ResultString = Result.Data("DeptLevelSets_end")
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 遍历所有同根节点
/// Table：DeptLevelSets
/// Input：Rowid-ID;LocDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckExist(Rowid, LocDr)
{
	n (Rowid,LocDr,ResultString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_parent='"_Rowid_"'"

	s ResultString=""

	d Result.Prepare(SqlStr)
	d Result.Execute()
	i ResultString="" d
	.s ResultString =..CheckLocExist(Rowid,LocDr)
	While(Result.Next())
	{	
		i ResultString=0 d
		.s Rowid = Result.Data("DeptLevelSets_rowid")
		.s ResultString =..CheckLocExist(Rowid,LocDr)
		.d ..CheckExist(Rowid,LocDr)
	}
	d Result.Close()
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查看此科室是否已经被添加过
/// Table：DeptLevelSets
/// Input：Rowid-ID;LocDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod CheckLocExist(ParRef, LocDr)
{
	n (ParRef,LocDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_recCost from dhc_ca_cache_data.LevelDepts where LevelDepts_childSub>0 and LevelDepts_parRef='"_ParRef_"' and LevelDepts_deptDr='"_LocDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		//ParRefs RString = ParRef
		s RString=$p(^DHCCADEPTLEVELSETS(ParRef),"^",2)
	}
	d Result.Close()
	q RString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 查找根节点
/// Table：DeptLevelSets
/// Input：ParRef-父ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod FindSource(ParRef)
{
	s RString=""
	n (ParRef,RString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and %ID='"_ParRef_"'"


	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s TmpParent=0
		s TmpParent = Result.Data("DeptLevelSets_parent")
		i TmpParent'=0 d 
		.d ..FindSource(TmpParent)
		e  d  
		.s RString=ParRef
	}
	d Result.Close()
	q RString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 更新所有同根的节点
/// Table：DeptLevelSets
/// Input：Rowid-ID;LocDr-科室ID
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod UpdateBySource(Rowid)
{
	n (Rowid)
	TSTART
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_parent='"_Rowid_"'"

	s ResultString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		
		
		s Rowid = Result.Data("DeptLevelSets_rowid")
		d ..UpdateBySource(Rowid)
		&sql(update dhc_ca_cache_data.DeptLevelSets set DeptLevelSets_active='N' where %ID=:Rowid)
		i SQLCODE'=0 d  s ResultString=SQLCODE
	}
	d Result.Close()
	i ResultString'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q ResultString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 遍历所有同根节点
/// Table：DeptLevelSets
/// Input：root-根节点ID;ResultString-返回的结果变量
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod GetNodes(root, resultString)
{
	n (root,resultString)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select DeptLevelSets_rowid,DeptLevelSets_code,DeptLevelSets_name,DeptLevelSets_shortcut,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent from dhc_ca_cache_data.DeptLevelSets where %ID>0 and DeptLevelSets_parent='"_root_"'"
	i resultString="" d
	.s resultString=..GetLeaves(root)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
		
		s Rowid = Result.Data("DeptLevelSets_rowid")
		i resultString="" d
		.s resultString=..GetLeaves(Rowid)
		e  i (..GetLeaves(Rowid)'=0) d
		.s resultString =resultString_","_..GetLeaves(Rowid)
		//w resultString,!
		s resultString=..GetNodes(Rowid, resultString)
		
	}
	d Result.Close()
	q resultString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 返回此节点所有的节点
/// Table：DeptLevelSets
/// Input：NodeDr-节点的DR
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDeptLevelSets).GetNodes(1)
ClassMethod GetLeaves(NodeDr)
{
	n (NodeDr)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LevelDepts_rowid,LevelDepts_deptDr,LevelDepts_recCost from dhc_ca_cache_data.LevelDepts where LevelDepts_childSub>0 and LevelDepts_parRef='"_NodeDr_"'"

	s RString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		i RString=0 d
		.s RString=Result.Data("LevelDepts_deptDr")
		e  d
		.s RString=RString_","_Result.Data("LevelDepts_deptDr")
	}
	d Result.Close()
	q RString
}

/// Creator：杨旭
/// CreatDate：2009-10-17
/// Description: 返回所有未添加此根节点的科室
/// Table：DeptLevelSets
/// Input：hospDr-医院ID;start-开始行号;limit-查找条数;active-是否有效;nodeDr-节点DR;str-模糊查询字符串;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDeptLevelSets).GetDepts(1,0,"10","Y",6,"")
ClassMethod GetDepts(hospDr, start, limit, active, nodeDr, str)
{
	;q hospDr_"^"_start_"^"_limit_"^"_active_"^"_nodeDr_"^"_str
	n (hospDr, start, limit, active, nodeDr, str)
	;Set result = ##class(%Library.ResultSet).%New()
	
	Set SqlStr = "SELECT UnitDepts_rowid,UnitDepts_code,UnitDepts_name,UnitDepts_shortcut,UnitDepts_address,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_unitDr,UnitDepts_propertyDr,UnitDepts_active FROM dhc_ca_cache_data.UnitDepts WHERE %ID>0 AND UnitDepts_unitDr="_hospDr_" AND UnitDepts_active='"_active_"'"
	s rootDr=0
	s rootDr=..FindSource(nodeDr)
	s items=""
	s items=..GetNodes(rootDr,"")
	i items'="" d
	.s SqlStr=SqlStr_" and %ID not in("_items_")"
	
	i str'="" d
	.s SqlStr=SqlStr_" and UnitDepts_shortcut like '%"_str_"%'"
	s RString=0
	Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	d result.Prepare(SqlStr)
	d result.Execute()

	s Count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.ca.cache.comm.JsonObj).%New()
	s jsonTitle="rowId^code^name^shortcut^address^remark^startTime^stop^unitDr^propertyDr^active"
	While(result.Next())
	{
		s rowId = result.Data("UnitDepts_rowid")
		s code = result.Data("UnitDepts_code")
		s name = result.Data("UnitDepts_name")
		s shortcut = result.Data("UnitDepts_shortcut")
		s address = result.Data("UnitDepts_address")
		s remark = result.Data("UnitDepts_remark")
		s startTime = result.Data("UnitDepts_start")
		s stop = result.Data("UnitDepts_stop")
		s unitDr = result.Data("UnitDepts_unitDr")
		s propertyDr = result.Data("UnitDepts_propertyDr")
		s active = result.Data("UnitDepts_active")
		
		i startTime'="" s startTime=$zd(startTime,3)
		i stop'="" s stop=$zd(stop,3)
		
		s tmp=rowId_"^"_code_"^"_name_"^"_shortcut_"^"_address_"^"_remark_"^"_startTime_"^"_stop_"^"_unitDr_"^"_propertyDr_"^"_active
		i (Count>=start)&(Count<=end) d
		.d json.InsertRowData(tmp)
		s Count=Count+1
	}
	d result.Close()
	s resultString = json.getJsonData(jsonTitle,Count)
 	k json
	q resultString
}

/// Creator：杨旭
/// CreatDate：2010-02-22
/// Description: 拷贝此树下所有节点与节点科室
/// Table：DeptLevelSets
/// Input：root-根节点ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.ca.cache.udata.uDeptLevelSets).CopyLevels(58)
ClassMethod CopyLevels(root)
{
	q:root="" ""
	n (root)
	TSTART
	s resultString=""
	s deptLevelSetsName= ""
	s deptLevelSetsRemark= ""
	s deptLevelSetsEnd= ""
	s deptLevelSetsActive= ""
	s deptLevelSetsOrder= ""
	
	i $d(^DHCCADEPTLEVELSETS(root)) d
	.s deptLevelSetsName=$p($g(^DHCCADEPTLEVELSETS(root)),"^",2)
	.s deptLevelSetsName=deptLevelSetsName_" 副本"
	.s deptLevelSetsRemark=$p($g(^DHCCADEPTLEVELSETS(root)),"^",4)
	.s deptLevelSetsEnd=$p($g(^DHCCADEPTLEVELSETS(root)),"^",5)
	.s deptLevelSetsActive=$p($g(^DHCCADEPTLEVELSETS(root)),"^",6)
	.s deptLevelSetsOrder=$p($g(^DHCCADEPTLEVELSETS(root)),"^",8)
	.&sql(insert into dhc_ca_cache_data.DeptLevelSets (DeptLevelSets_name,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent,DeptLevelSets_order) values(:deptLevelSetsName,:deptLevelSetsRemark,:deptLevelSetsEnd,:deptLevelSetsActive,0,:deptLevelSetsOrder))
	.i SQLCODE'="" s resultString=SQLCODE
	.s newDeptLevelSetsId=$g(%ROWID)
	.s tmpResult=0
	.s tmpResult=..CopyDepts(root,newDeptLevelSetsId)
	.i tmpResult'=0 s resultString=tmpResult
	.s tmpResult=..CopyLevel(root,newDeptLevelSetsId)
	.i tmpResult'=0 s resultString=tmpResult
	i resultString=0 TCOMMIT
	e  TROLLBACK
	q resultString
}

/// Creator：杨旭
/// CreatDate：2010-02-22
/// Description: 拷贝此树下所有节点
/// Table：DeptLevelSets
/// Input：root-根节点ID;newRoot-新根节点ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：##class(dhc.ca.cache.udata.uDeptLevelSets).CopyLevel(58,88)
ClassMethod CopyLevel(root, newRoot)
{
	q:root="" ""
	q:newRoot="" ""
	n (root,newRoot)
	
	s resultString=0
	s deptLevelSetsId=""
	f  s deptLevelSetsId= $o(^DHCCADEPTLEVELSETS(0,"Parent",root,deptLevelSetsId)) q:deptLevelSetsId=""  d
	.s deptLevelSetsName= ""
	.s deptLevelSetsRemark= ""
	.s deptLevelSetsEnd= ""
	.s deptLevelSetsActive= ""
	.s deptLevelSetsOrder= ""
	.i $d(^DHCCADEPTLEVELSETS(deptLevelSetsId)) d
	..s deptLevelSetsName=$p($g(^DHCCADEPTLEVELSETS(deptLevelSetsId)),"^",2)
	..s deptLevelSetsRemark=$p($g(^DHCCADEPTLEVELSETS(deptLevelSetsId)),"^",4)
	..s deptLevelSetsEnd=$p($g(^DHCCADEPTLEVELSETS(deptLevelSetsId)),"^",5)
	..s deptLevelSetsActive=$p($g(^DHCCADEPTLEVELSETS(deptLevelSetsId)),"^",6)
	..s deptLevelSetsOrder=$p($g(^DHCCADEPTLEVELSETS(deptLevelSetsId)),"^",8)
	..&sql(insert into dhc_ca_cache_data.DeptLevelSets (DeptLevelSets_name,DeptLevelSets_remark,DeptLevelSets_end,DeptLevelSets_active,DeptLevelSets_parent,DeptLevelSets_order) values(:deptLevelSetsName,:deptLevelSetsRemark,:deptLevelSetsEnd,:deptLevelSetsActive,:newRoot,:deptLevelSetsOrder))
	..i SQLCODE'=0 s resultString=SQLCODE
	..s newDeptLevelSetsId=$g(%ROWID)
	..s tmpResult=0
	..s tmpResult=..CopyDepts(deptLevelSetsId,newDeptLevelSetsId)
	..i tmpResult'=0 s resultString=tmpResult
	..s tmpResult=..CopyLevel(deptLevelSetsId,newDeptLevelSetsId)
	..i tmpResult'=0 s resultString=tmpResult
	q resultString
}

/// Creator：杨旭
/// CreatDate：2010-02-22
/// Description: 拷贝此节点下所有科室
/// Table：DeptLevelSets
/// Input：root-根节点ID;newRoot-新根节点ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：##class(dhc.ca.cache.udata.uDeptLevelSets).CopyDepts(58,88)
ClassMethod CopyDepts(root, newRoot)
{
	q:root="" ""
	q:newRoot="" ""
	n (root,newRoot)
	s resultString=0
	s levelDeptsId=""
	f  s levelDeptsId=$o(^DHCCADEPTLEVELSETS(root,"Depts",levelDeptsId)) q:levelDeptsId=""  d
	.i $d(^DHCCADEPTLEVELSETS(root,"Depts",levelDeptsId)) d
	..s levelDeptsOrder=""
	..s levelDeptsDeptId=""
	..s levelDeptsRecCost="N"
	..s levelDeptsDistCost="N"
	..s levelDeptsOrder=$p($g(^DHCCADEPTLEVELSETS(root,"Depts",levelDeptsId)),"^",3)
	..s levelDeptsDeptId=$p($g(^DHCCADEPTLEVELSETS(root,"Depts",levelDeptsId)),"^",1)
	..s levelDeptsRecCost=$p($g(^DHCCADEPTLEVELSETS(root,"Depts",levelDeptsId)),"^",2)
	..i levelDeptsRecCost="" s levelDeptsRecCost="N"
	..s levelDeptsDistCost=$p($g(^DHCCADEPTLEVELSETS(root,"Depts",levelDeptsId)),"^",4)
	..i levelDeptsDistCost="" s levelDeptsDistCost="N"
	..//w levelDeptsOrder_"^"_levelDeptsDeptId_"^"_levelDeptsRecCost_"^"_levelDeptsDistCost,!
	..&sql(insert into dhc_ca_cache_data.LevelDepts (LevelDepts_order,LevelDepts_deptDr,LevelDepts_recCost,LevelDepts_distCost,LevelDepts_parRef) values(:levelDeptsOrder,:levelDeptsDeptId,:levelDeptsRecCost,:levelDeptsDistCost,:newRoot))
	..i SQLCODE'=0 s resultString=SQLCODE
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uDeptLevelSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
