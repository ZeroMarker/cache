Import SQLUser

Class web.DHCEQ.Plat.CTPCNoticeCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTPCNoticeCat","GetPCNoticeCat","")
/// modify by lmm 2020-04-20 增加安全组入参
Query GetPCNoticeCat(NoticeCat As %String = "", Group As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String,TCode:%String")
{
}

ClassMethod GetPCNoticeCatExecute(ByRef qHandle As %Binary, NoticeCat As %String = "", Group As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	i Group="" s Group=%session.Get("LOGON.GROUPID")
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQPCNoticeCat",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetPCNoticeCat
	.Set TRowID = rowid	//rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQPCNoticeCat",TRowID)),"^",1) //代码
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQPCNoticeCat",TRowID)),"^",2) //描述
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQPCNoticeCat",TRowID)),"^",4) //无符号标志
	.Quit:TInvalidFlag'="N"
	.Quit:(NoticeCat'="")&&($ZCONVERT(TDesc,"U")'[NoticeCat)
	.q:(Group'="")&&('$D(^DHCEQCCode("DHCEQCGroupNoticeCat",0,"Group",Group,TRowID)))
	.Do OutputRowGetPCNoticeCat
	Quit $$$OK
OutputRowGetPCNoticeCat
   	Set Data=$lb(TRowID,TDesc,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetPCNoticeCat
	Set (TDesc,TRowID,TCode)=""
	Quit
}

ClassMethod GetPCNoticeCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPCNoticeCatExecute ]
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

ClassMethod GetPCNoticeCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPCNoticeCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
