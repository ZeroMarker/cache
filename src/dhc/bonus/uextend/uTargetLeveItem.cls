/// 名称: 末端数据表数据维护
/// 描述: 末端数据表添加与修改
/// 编写者：ZHAO LIGUO
/// 编写日期:2011-10-20
Class dhc.bonus.uextend.uTargetLeveItem Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 插入一末端数据表数据
/// Table：LevelItems
/// Input：itemDr-数据Dr;itemTypeDr-数据类别Dr;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod InsertRec(itemDr, itemTypeDr, parRef, order, remark) As %String
{
	n (itemDr, itemTypeDr, parRef, order,remark)
	q:parRef="roo" "roo"
	
	s tmpId=0
	//s tmpId=..IfRepOrder(parRef,order)
	//q:tmpId>0 "RepOrder"
	i itemTypeDr=1 d
	.s targetID= itemDr
	.s schemeItemID = -1
	.s subItemID= -1
	
	i itemTypeDr=2 d
	.s targetID= -1
	.s schemeItemID = itemDr
	.s subItemID= -1
	
	i itemTypeDr>2 d
	.s targetID= -1
	.s schemeItemID = -1
	.s subItemID= itemDr
	
	&sql(insert into dhc_bonus_extend.TargetLeveItem(TargetLeveSetID,BonusTargetID,BonusSubItemID,TargetLeveType,ItemOrder,BonusSchemeItemID,remark) values(:parRef,:targetID,:subItemID,:itemTypeDr,:order,:schemeItemID,:remark))
													
	
	;;&sql(insert into dhc_ca_cache_data.LevelItems (LevelItems_itemDr,LevelItems_itemTypeDr,LevelItems_parRef,LevelItems_order) values(:itemDr,:itemTypeDr,:parRef,:order))
	q SQLCODE
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 
/// Table：LevelItems
/// Input：itemDr-数据Dr;itemTypeDr-数据类别Dr;parRef-父ID;order-顺序
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：w ##class(dhc.bonus.uextend.uTargetLeveItem).CheckExist(94,2,1)
ClassMethod CheckExist(itemDr, parRef, dataType) As %String
{
	n (itemDr, parRef,dataType)
	
	Set Result = ##class(%Library.ResultSet).%New()
	i dataType=1 d
	.s SqlStr = "select * from dhc_bonus_extend.TargetLeveItem where BonusTargetID ='"_itemDr _"' and TargetLeveSetID='"_parRef_"'"

	
	i dataType=2 d
	.s SqlStr = "select * from dhc_bonus_extend.TargetLeveItem where  BonusSchemeItemID='"_itemDr _"' and TargetLeveSetID='"_parRef_"'"

	
	i dataType>2 d
	.s SqlStr = "select * from dhc_bonus_extend.TargetLeveItem where  BonusSubItemID='"_itemDr _"' and TargetLeveSetID='"_parRef_"'"

	
	s ResultString="0"
	s Rowid=0
	//w SqlStr,!
	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{	
   	s Rowid = Result.Data("TargetLeveItemID")
	}
	d Result.Close()
	i Rowid>0 s ResultString=1
	q ResultString
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 更新一末端数据表数据
/// Table：LevelItems
/// Input：itemDr-数据Dr;itemTypeDr-接受分摊标志;rowid-ID;parRef-父ID
/// Output：
/// Return：要插入的数据名称存在,返回"RepName",或数据代码存在,返回"RepCode"否则返回执行插入语句后的SQLCODE
/// Others：
ClassMethod UpdateRec(itemDr, itemTypeDr, rowid, parRef, order, remark) As %String
{
	n (itemDr, itemTypeDr, rowid, parRef, order,remark)
	q:parRef="roo" "roo"
	
	s tmpId=0
	//s tmpId=..IfRepOrder(parRef,order)
	//q:(tmpId>0)&(tmpId'=$p(rowid,"||",2)) "RepOrder"
	
	i itemTypeDr=1 d
	.s targetID= itemDr
	.s schemeItemID = -1
	.s subItemID= -1
	
	i itemTypeDr=2 d
	.s targetID= -1
	.s schemeItemID = itemDr
	.s subItemID= -1
	
	i itemTypeDr>2 d
	.s targetID= -1
	.s schemeItemID = -1
	.s subItemID= itemDr
	
	&sql(update dhc_bonus_extend.TargetLeveItem set TargetLeveSetID=:parRef,BonusTargetID=:targetID,BonusSubItemID=:subItemID,TargetLeveType=:itemTypeDr,ItemOrder=:order,BonusSchemeItemID=:schemeItemID,remark=:remark where %ID=:rowid) 

	q SQLCODE
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 删除记录
/// Table：LevelItems
/// Input：rowId-准备删除的数据所在行号
/// Output：
/// Return：返回执行删除语句后的SQLCODE
/// Others：
ClassMethod DelRec(rowId) As %String
{
	Set Result = ##class(%Library.ResultSet).%New()

	i rowId>0 d
	s parRef= $List(^dhcbsTargetLeveItemD(rowId),2)
	
	&SQL(DELETE FROM dhc_bonus_extend.TargetLeveItem WHERE %ID=:rowId)
	i SQLCODE'=0 d  s parRef=0
	q parRef
}

/// Creator：ZHAO LIGUO
/// CreatDate：2011-10-20
/// Description: 查询符合条件的记录
/// Table：LevelItems
/// Input：searchField-查询字段; searchValue-查询值; sortField-排序字段; sortDir-排序方向; Start-起始行; Limit-行数;ParRef-父ID
/// Output：
/// Return：返回查询到的记录的Json串
/// Others：w ##class(dhc.bonus.uextend.uTargetLeveItem).ListRec("","","","",0,8,1)
ClassMethod ListRec(SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
{
	n (SearchField, SearchValue, SortField, SortDir, Start, Limit, ParRef)
	Set Result = ##class(%Library.ResultSet).%New()
	//Set SqlStr = "select LevelItems_rowid,LevelItems_itemDr,LevelItems_itemTypeDr,LevelItems_order from dhc_ca_cache_data.LevelItems where LevelItems_childSub>0 and LevelItems_parRef="_ParRef
	
	s SqlStr= " select %ID rowid,TargetLeveSetID,BonusTargetID,BonusSubItemID,TargetLeveType,ItemOrder,BonusSchemeItemID,remark from dhc_bonus_extend.TargetLeveItem where %ID>0 AND TargetLeveSetID="_ParRef
	

	d Result.Prepare(SqlStr)
	d Result.Execute()

	s Count = 0
	s ResultString = ""
	s End = Start+Limit

	s Json = ##class(dhc.bonus.comm.JsonObj).%New()

	While(Result.Next())
	{
		
		s Rowid = Result.Data("rowid")
		s remark = Result.Data("remark")
		
		;s itemDr = Result.Data("LevelItems_itemDr")
		
		s itemTypeDr = Result.Data("TargetLeveType")
		s Order = Result.Data("ItemOrder")
		s itemCode=""
		s itemName=""
		s itemTypeName=""
		s itemDr=""
		
		i itemTypeDr=1 d
		.s itemTypeName="奖金指标"
		.s itemDr = Result.Data("BonusTargetID")
		.i itemDr>0 d
		..s itemCode =$List(^dhcbsBonusTargetD(itemDr),2)
		..s itemName =$List(^dhcbsBonusTargetD(itemDr),3)
		
		i itemTypeDr=2 d
		.s itemTypeName="奖金项目"
		.s itemDr = Result.Data("BonusSchemeItemID")
		.i itemDr>0 d
		..s itemCode =$List(^dhcbsBonusSchemeItemD(itemDr),3)
		..s itemName =$List(^dhcbsBonusSchemeItemD(itemDr),4)
		
		i itemTypeDr=3 d
		.s itemTypeName="辅助收入"
		.s itemDr = Result.Data("BonusSubItemID")
		.i itemDr>0 d
		..s itemCode =$List(^dhcbsSubItemD(itemDr),2)
		..s itemName =$List(^dhcbsSubItemD(itemDr),3)
		
		i itemTypeDr=4 d
		.s itemTypeName="辅助支出"
		.s itemDr = Result.Data("BonusSubItemID")
		.i itemDr>0 d
		..s itemCode =$List(^dhcbsSubItemD(itemDr),2)
		..s itemName =$List(^dhcbsSubItemD(itemDr),3)
		
		i itemTypeDr=5 d
		.s itemTypeName="辅助工作量"
		.s itemDr = Result.Data("BonusSubItemID")
		.i itemDr>0 d
		..s itemCode =$List(^dhcbsSubItemD(itemDr),2)
		..s itemName =$List(^dhcbsSubItemD(itemDr),3)
		
		s Tmp=Rowid_"^"_itemDr_"^"_itemCode_"^"_itemName_"^"_itemTypeDr_"^"_Order_"^"_itemTypeName_"^"_remark
		
		s Count=Count+1
		i (Count>Start)&(Count<=End) d
		.d Json.InsertRowData(Tmp)
	}
	d Result.Close()
	s ResultString = Json.getJsonData("rowid^itemDr^itemCode^itemName^itemTypeDr^order^itemTypeName^remark",Count)
 	k Json
	q ResultString
}

/// Others：w ##class(dhc.bonus.uextend.uTargetLeveItem).ListRec1()
ClassMethod ListRec1()
{
	
	Set Result = ##class(%Library.ResultSet).%New()
	s SqlStr= "select * from testConnection2.dhc_ca_cache_data.Units where %ID>0"
	//w SqlStr,!
	s Json = ##class(dhc.bonus.comm.JsonObj).%New()

	d Result.Prepare(SqlStr)
	d Result.Execute()

	While(Result.Next())
	{
		
		s scode = Result.Data("Units_code")
		s sname = Result.Data("Units_name")
		w sname,!
	}
	q "0"
}

Storage Default
{
<StreamLocation>^dhc.ca.c.uLevelItemsS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
