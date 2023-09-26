/// add by ZY0208 2020-02-27
Class web.DHCEQ.BA.BUSServiceMap Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query ServiceMap(EquipDR As %String = "", Service As %String = "") As %Query(ROWSPEC = "TService:%String:服务,TServiceRowID:%String,TModel:%String:型号,TRow:%String:序号")
{
}

ClassMethod ServiceMapExecute(ByRef qHandle As %Binary, EquipDR As %String = "", Service As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	k ^TempDHCEQ("EquipService",curuser)
	s index=1
	s rowid=0
	q:EquipDR=""
	s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	s ModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	s EQService=0
	f  s EQService=$o(^DHCEQEquipService(0,"SourceService",1,EquipDR,EQService))  quit:EQService=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquipService(0,"SourceService",1,EquipDR,EQService,rowid))  quit:rowid=""  d
	..s TServiceRowID = rowid	//rowid
	..s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	..q:InvalidFlag="Y"
	..s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	..s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	..s ^TempDHCEQ("EquipService",curuser,TService)=TServiceRowID_"^"_TModel

	i ItemDR'="" d
	.s EQService=0
	.f  s EQService=$o(^DHCEQEquipService(0,"SourceService",2,ItemDR,EQService))  quit:EQService=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQEquipService(0,"SourceService",2,ItemDR,EQService,rowid))  quit:rowid=""  d
	...s TServiceRowID=rowid
	...s InvalidFlag=$p($g(^DHCEQEquipService(rowid)),"^",9)
	...q:InvalidFlag="Y"
	...s TService=$p($g(^DHCEQEquipService(rowid)),"^",4)
	...s TModel=$p($g(^DHCEQEquipService(rowid)),"^",3)
	...q:$g(^TempDHCEQ("EquipServie",curuser,TService))'=""
	...q:(TModel'="")&&(TModel'=ModelDR)
	...s ^TempDHCEQ("EquipService",curuser,TService)=TServiceRowID_"^"_TModel
	s rowid=0
	f  s rowid=$o(^TempDHCEQ("EquipService",curuser,rowid))  quit:rowid=""  d
	.d ResetVariablesServiceMap
	.s TService=rowid
	.s TServiceRowID=rowid
	.s TModel=$p($g(^TempDHCEQ("EquipService",curuser,rowid)),"^",2)
	.i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.i TService'="" s TService=$p($g(^DHCEQCCode("DHCEQCServiceItem",TService)),"^",1)
	.q:(Service'="")&&(TService'=Service)
	.d OutputRowServiceMap
	Quit $$$OK
OutputRowServiceMap
	s Data=$lb(TService,TServiceRowID,TModel,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesServiceMap
	s (TService,TServiceRowID,TModel)=""
	quit
}

ClassMethod ServiceMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ServiceMapExecute ]
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

ClassMethod ServiceMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ServiceMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
