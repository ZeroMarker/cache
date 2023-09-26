Class web.DHCEQ.EM.CTTree Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0302 20220601 增加DHC_EQCTreeList数据筛选
/// Creator:czf
/// CreateDate:2021-04-28
/// Description：68分类
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.CTTree","GetTree","超声","")
Query GetTree(Desc As %String = "", Code As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TLRowID:%String,TLManageLevel:%String,TLProductNames:%String,TLProductDesc:%String,TLPurposeDesc:%String")
{
}

ClassMethod GetTreeExecute(ByRef qHandle As %Binary, Desc As %String = "", EquipTypeDR As %String = "", StatCatDR As %String = "", EditFlag As %String = "") As %Status
{
	new repid, index,RowID
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s RowID=0
	for  s RowID=$o(^DHCEQCCode("DHCEQCTree",RowID)) quit:RowID=""  d
	.s (TDesc,TRowID,TCode)=""
	.s TRowID=RowID
	.q:$p($g(^DHCEQCCode("DHCEQCTree",RowID)),"^",17)="Y"
	.s TCode=$P(^DHCEQCCode("DHCEQCTree",RowID),"^",2)
	.s TDesc=$P(^DHCEQCCode("DHCEQCTree",RowID),"^",3)
	.s TreeListID=0
	.for  s TreeListID=$o(^DHCEQCCode("DHCEQCTreeList",0,"TreeDR",RowID,TreeListID)) quit:TreeListID=""  d
	..s (TLRowID,TLManageLevel,TLProductNames,TLProductDesc,TLPurposeDesc)=""
	..s TLRowID=TreeListID
	..s TLProductDesc=$P(^DHCEQCCode("DHCEQCTreeList",TreeListID),"^",2)
	..s TLPurposeDesc=$P(^DHCEQCCode("DHCEQCTreeList",TreeListID),"^",3)
	..s TLProductNames=$P(^DHCEQCCode("DHCEQCTreeList",TreeListID),"^",4)
	..s TLManageLevel=$P(^DHCEQCCode("DHCEQCTreeList",TreeListID),"^",5)
	..q:(Desc'="")&&(TDesc'[Desc)&&(TLProductNames'[Desc)&&($ZConvert(TCode,"U")'[$ZConvert(Desc,"U"))
	..d OutputRowGetTree
	Quit $$$OK
OutputRowGetTree
	Set Data=$lb(TDesc,TRowID,TCode,TLRowID,TLManageLevel,TLProductNames,TLProductDesc,TLPurposeDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
