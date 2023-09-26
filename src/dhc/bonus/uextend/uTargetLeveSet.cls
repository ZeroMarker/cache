/// 名称: 数据分层数据维护
/// 描述: 数据分层添加与修改
/// 编写者：ZHAO LIGUO
/// 编写日期:2011-10-20
Class dhc.bonus.uextend.uTargetLeveSet Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 查询符合条件的记录
/// Table：DataLevelSets
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;Parent-父节点;Active-是否有效
/// Output：
/// Return：返回查询到的记录的Json串 RListRec
/// Others：w ##class(dhc.bonus.uextend.uTargetLeveSet).RListRec("","","","",0,8,"roo",1)
ClassMethod RListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, Parent, Active)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	//Set SqlStr = "select DataLevelSets_rowid,DataLevelSets_code,DataLevelSets_name,DataLevelSets_shortcut,DataLevelSets_remark,DataLevelSets_end,DataLevelSets_active,DataLevelSets_parent,DataLevelSets_order from dhc_ca_cache_data.DataLevelSets where %ID>0 and DataLevelSets_parent='"_Parent_"'"
	
	s SqlStr = "select TargetLeveSetID,TargetLeveCode,TargetLeveName, TargetLeveShutcut, TargetLeveDesc,SuperiorID ,TargetLeveOrder,"
			_" case  LastStage when 1 then 'Y' else 'N' end as LastStage ,case IsValid when 1 then 'Y' else 'N' end as IsValid"
			_" from dhc_bonus_extend.TargetLeveSet where %ID>0 and IsValid = '1' and SuperiorID='"_Parent_"'"
			

	s Count=0
	s ResultString=""
	//w SqlStr,!
	
	If SortField = "id" Set SortField = "TargetLeveSetID"
	If SortField = "code" Set SortField = "TargetLeveCode"
	If SortField = "name" Set SortField = "TargetLeveName"
	If SortField = "order" Set SortField = "TargetLeveOrder"
	If SortField = "remark" Set SortField = "TargetLeveShutcut"
	If SortField = "end" Set SortField = "LastStage"
	If SortField = "active" Set SortField = "IsValid"
	
	Set ConditionOrderBy = ""
	
	If SortField '= "" Do
	.s ConditionOrderBy = " ORDER BY "_SortField_" "_SortDir

	Set SqlStr = SqlStr_ConditionOrderBy
	//q SqlStr
	s TmpEnd=""
	i Parent'="" d

	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Json = ##class(dhc.bonus.comm.JsonObj).%New()
	s End = Start+Limit
	
	While(Result.Next())
	{
		s rowid = Result.Data("TargetLeveSetID")
		s code = Result.Data("TargetLeveCode")
		s name = Result.Data("TargetLeveName")
		s desc = Result.Data("TargetLeveShutcut")
		s remark = Result.Data("TargetLeveDesc")
		s end = Result.Data("LastStage")
		s active = Result.Data("IsValid")
		s parent = Result.Data("SuperiorID")
		s order = Result.Data("TargetLeveOrder")
		
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

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 查询符合条件的记录
/// Table：DataLevelSets
/// Input：Parent-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others： w ##class(dhc.bonus.uextend.uTargetLeveSet).ListRec(1)
ClassMethod ListRec(Parent)
{
	n (Parent)
	i Parent="roo" s Parent=0
	Set Result = ##class(%Library.ResultSet).%New()
	s SqlStr = "select TargetLeveSetID,TargetLeveCode,TargetLeveName, TargetLeveShutcut, TargetLeveDesc,SuperiorID ,TargetLeveOrder,"
			_" case  LastStage when 1 then 'Y' else 'N' end as LastStage ,case IsValid when 1 then 'Y' else 'N' end as IsValid"
			_" from dhc_bonus_extend.TargetLeveSet where %ID>0 and IsValid = '1' and SuperiorID='"_Parent_"'"
			_" ORDER BY TargetLeveOrder asc"
	//q SqlStr
	s ItemDr=""
	s ItemName=""
	s DataLevelSets=""
	s ResultString="["
	s TmpEnd=""
	i Parent'="" d
	
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s rowid = Result.Data("TargetLeveSetID")
		s code = Result.Data("TargetLeveCode")
		s name = Result.Data("TargetLeveName")
		s desc = Result.Data("TargetLeveShutcut")
		s remark = Result.Data("TargetLeveDesc")
		s end = Result.Data("LastStage")
		s active = Result.Data("IsValid")
		s parent = Result.Data("SuperiorID")
		s ResultString=ResultString_"{id:'"_rowid_"',code:'"_code_"',name:'"_name_"',desc:'"_desc_"',remark:'"_remark_"',leaf:false,end:'"_end_"',active:'"_active_"',parent:'"_parent_"',uiProvider:'col'},"
	}
	
	s Order=""
	s rowid=""
	s ItemDr=""
	i Parent'="" d
	.f  s Order=$o(^dhcbsTargetLeveItemI("IdxTargetOrder",Parent,Order)) q:Order=""  d
	..f  s rowid=$o(^dhcbsTargetLeveItemI("IdxTargetOrder",Parent,Order,rowid)) q:rowid=""  d
	...q:rowid=0
	...s dataType=$List(^dhcbsTargetLeveItemD(rowid),5)
	...i dataType=1 d
	....s ItemDr=$List(^dhcbsTargetLeveItemD(rowid),3)
	....s ItemName=$List(^dhcbsBonusTargetD(ItemDr),3)
	...i dataType=2 d
	....s ItemDr=$List(^dhcbsTargetLeveItemD(rowid),7)
	....s ItemName=$List(^dhcbsBonusSchemeItemD(ItemDr),4)
	...i dataType>2 d
	....s ItemDr=$List(^dhcbsTargetLeveItemD(rowid),4)
	....s ItemName=$List(^dhcbsSubItemD(ItemDr),3)
	...s ResultString=ResultString_"{id:'',code:'',name:'"_ItemName_"',desc:'',remark:'',leaf:'true',end:'',active:'Y',parent:'"_Parent_"',uiProvider:'col'},"
	
	
	s ResultString=ResultString_"]"
	d Result.Close()
	q ResultString
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
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
	
	i Active="N" d
	.s Active=0 
	e  d
	.s Active=1
	
	i Leaf="N" d
	.s Leaf=0 
	e  d
	.s Leaf=1
	&sql(insert into dhc_bonus_extend.TargetLeveSet (TargetLeveCode,TargetLeveName, TargetLeveShutcut, TargetLeveDesc,SuperiorID ,TargetLeveOrder, LastStage ,IsValid)  values(:Code,:Name,:Desc,:Remark,:Parent,:order,:Leaf,:Active))
	q SQLCODE
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
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
	i Active="N" d
	.s Active=0 
	e  d
	.s Active=1
	
	i Leaf="N" d
	.s Leaf=0 
	e  d
	.s Leaf=1
	
	&sql(update dhc_bonus_extend.TargetLeveSet set TargetLeveCode=:Code,TargetLeveName=:Name,IsValid=:Active,TargetLeveShutcut=:Desc,TargetLeveDesc=:Remark,LastStage=:Leaf,TargetLeveOrder=:order where %ID=:Rowid)

	s Rs=SQLCODE
	i Active="N" d
	.s Rs=..UpdateBySource(Rowid)
	q Rs
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 查看一条数据是否是末端树枝
/// Table：DataLevelSets
/// Input：Rowid-ID;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：w ##class(dhc.bonus.uextend.uTargetLeveSet).CheckRec(1)
ClassMethod CheckRec(Rowid)
{
	n (Rowid)
	Set Result = ##class(%Library.ResultSet).%New()
	Set SqlStr = "select LastStage from dhc_bonus_extend.TargetLeveSet where %ID='"_Rowid_"'"

	s ResultString="N"

	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		s ResultString = Result.Data("LastStage")
	}
	
	i ResultString="1" d
	.s ResultString="Y"
	e  d
	.s ResultString="N"
	
	d Result.Close()
	q ResultString
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
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
	
	s SqlStr = "select TargetLeveSetID from dhc_bonus_extend.TargetLeveSet where %ID>0 and  SuperiorID='"_Rowid_"'"
	s ResultString=0
	
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{	
				
		s Rowid = Result.Data("TargetLeveSetID")
		d ..UpdateBySource(Rowid)
		&sql(update dhc_bonus_extend.TargetLeveSet set IsValid='0' where %ID=:Rowid)
		i SQLCODE'=0 d  s ResultString=SQLCODE
	}
	d Result.Close()
	i ResultString'=0 d
	.TRollBack
	e  d
	.TCOMMIT
	q ResultString
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 返回所有未添加此根节点的数据
/// Table：DataLevelSets
/// Input：hospDr-医院ID;start-开始行号;limit-查找条数;active-是否有效;nodeDr-节点DR;str-模糊查询字符串;
/// Output：
/// Return：如果为末端为Y,否则为N
/// Others：
ClassMethod GetItems(dataType, start, limit, str)
{
	n (dataType, start, limit,str)
	Set result = ##class(%Library.ResultSet).%New()	
	
	i dataType="1" d //奖金指标
	.s SqlStr="select %ID rowid,BonusTargetCode scode,BonusTargetName sname "
	.s SqlStr=SqlStr_ " from dhc_bonus_data.BonusTarget where %ID>0 AND IsValid=1 and DataSource=1 "
	.s SqlStr=SqlStr_ " and (BonusTargetCode like '"_str_"%' or BonusTargetName like '"_str_"%')"
	
	i dataType="2" d // 奖金项
	.s SqlStr="select %ID rowid,SchemeItemCode scode,BonusSchemeID->BonusSchemeName _ '_' _ SchemeItemName sname from dhc_bonus_data.BonusSchemeItem where BonusSchemeID->SchemeState=1 and IsValid=1"
	.s SqlStr=SqlStr_ " and (SchemeItemCode like '"_str_"%' or SchemeItemName like '"_str_"%')"
	
	i dataType="3" d // 辅助收入
	.s SqlStr="SELECT %ID rowid,SubItemCode scode,SubItemName sname FROM dhc_bonus_subs.BonusSubItem where %ID>0 AND LastStage=1 and IsValid=1 AND subitemType=1 "
	.s SqlStr=SqlStr_ " and (SubItemCode like '"_str_"%' or SubItemName like '"_str_"%')"
	
	i dataType="4" d // 辅助支出
	.s SqlStr="SELECT %ID rowid,SubItemCode scode,SubItemName sname FROM dhc_bonus_subs.BonusSubItem where %ID>0 AND LastStage=1 and IsValid=1 AND subitemType=3 "
	.s SqlStr=SqlStr_ " and (SubItemCode like '"_str_"%' or SubItemName like '"_str_"%')"
	
	i dataType="5" d //辅助工作量
	.s SqlStr="SELECT %ID rowid,SubItemCode scode,SubItemName sname FROM dhc_bonus_subs.BonusSubItem where %ID>0 AND LastStage=1 and IsValid=1 AND subitemType=2 "
	.s SqlStr=SqlStr_ " and (SubItemCode like '"_str_"%' or SubItemName like '"_str_"%')"
	

	

	d result.Prepare(SqlStr)
	d result.Execute()

	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(dhc.bonus.comm.JsonObj).%New()
	s jsonTitle="rowid^itemCode^itemName^dataType"
	
	While(result.Next())
	{
		s rowid=result.Data("rowid")
		s scode=result.Data("scode")
		s sname=result.Data("sname")
	
		//dataType
		
		s tmp=rowid_"^"_scode_"^"_scode_"_" _sname_"^"_dataType
		 
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1

	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uDataLevelSetsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
