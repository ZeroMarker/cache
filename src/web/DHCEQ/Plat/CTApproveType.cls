/// Description:动作定义页面来源类型
/// Creator:	cjc
/// CreateDate:	20220803
Class web.DHCEQ.Plat.CTApproveType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: CJC  
/// CreatDate: 2022-07-26 
/// Description:  动作定义页面获取来源类型
/// Input: Code，Desc
/// Output: Data:(TRowID，TCode，TDesc，TRemark)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTApproveType","GetApproveType","","")
Query GetApproveType(Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod GetApproveTypeExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s index=1
	
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCApproveType",rowid)) quit:rowid=""  d
	.d ResetVariablesGetApproveType
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCApproveType",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCApproveType",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCApproveType",rowid)),"^",3)
	.q:(Code'="")&&($ZCONVERT(TCode,"U")'[Code)
	.q:(Desc'="")&&($ZCONVERT(TDesc,"U")'[Desc)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCApproveType",rowid)),"^",4)
	.q:TInvalidFlag="Y"
	.d OutputRowGetApproveType
	Quit $$$OK
OutputRowGetApproveType
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
ResetVariablesGetApproveType
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod GetApproveTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ActionExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 		}
 	Else      {
 		Set Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetApproveTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
