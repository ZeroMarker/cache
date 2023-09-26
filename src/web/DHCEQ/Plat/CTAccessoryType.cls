/// 名称: web.DHCEQ.Plat.CTAccessoryType
/// 描述: 配件类组
/// 编写者：Mozy
/// 编写日期: 2019-09-15
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTAccessoryType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      Mozy
/// CreatDate：    2019-09-15
/// Description:   配件类组LookUp所需Query
/// Table：        DHC_EQCAccessoryType
/// Input：        Desc:来源描述
/// 				   GroupID:安全组ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTAccessoryType","GetAccessoryType","",85)
Query GetAccessoryType(AccessoryType As %Library.String = "", GroupID As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetAccessoryTypeExecute(ByRef qHandle As %Binary, AccessoryType As %Library.String = "", GroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCAccessoryType",rowid))  q:rowid=""  d
	.d ResetVariablesGetAccessoryType
	.s RowID=rowid
	.Quit:##Class(web.DHCEQACommon).AccessoryTypeIsIn(RowID,GroupID)
	.s Desc=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",2)
	.Quit:(AccessoryType'="")&(Desc'[AccessoryType)
	.s Code=$p($g(^DHCEQCCode("DHCEQCAccessoryType",rowid)),"^",1)
	.d OutputRowGetAccessoryType
	Quit $$$OK
OutputRowGetAccessoryType
	s Data=$lb(Desc,RowID,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAccessoryType
	s (Desc,RowID,Code)=""
	quit
}

ClassMethod GetAccessoryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
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

ClassMethod GetAccessoryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAccessoryTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
