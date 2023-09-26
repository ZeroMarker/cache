/// 名称: web.DHCEQ.Plat.CTApproveSet
/// 描述: 设备类型
/// 编写者：ZC
/// 编写日期: 2020-03-11
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTApproveSet Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetApproveSet() As %Query(ROWSPEC = "TRowID:%String,TApproveType:%String,TDesc:%String,TCode:%String,TEquipType:%String,TPurchaseType:%String,TSpecialType:%String,TSingleMinFee:%String,TSingleMaxFee:%String,TAutoAuditFlag:%String,TYearFlag:%String,TApproveTypeDR:%String,TRow:%String")
{
}

ClassMethod GetApproveSetExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s ApproveTypeDR=0
	f  s ApproveTypeDR=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveTypeDR))  q:ApproveTypeDR=""  d
	.s rowid=0
	.for  s rowid=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveTypeDR,rowid)) quit:rowid=""  d
	..d ResetVariablesGetApproveSet
	..s TRowID=rowid
	..s TApproveTypeDR=ApproveTypeDR
	..i TApproveTypeDR'="" s TApproveType=$p($g(^DHCEQCCode("DHCEQCApproveType",TApproveTypeDR)),"^",2)
	..s TDesc=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",2)
	..s TCode=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",3)
	..s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",4)
	..i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	..s TPurchaseTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",5)
	..i TPurchaseTypeDR'="" s TPurchaseType=$p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	..s TSpecialTypeDR=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",6)
	..i TSpecialTypeDR'="" s TSpecialType=$p($g(^DHCEQCCode("DHCEQCSpecialType",TSpecialTypeDR)),"^",2)
	..s TSingleMinFee=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",7)
	..s TSingleMaxFee=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",8)
	..s TAutoAuditFlag=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",9)
	..s TAutoAuditFlag=$CASE(TAutoAuditFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..s TYearFlag=$p($g(^DHCEQCCode("DHCEQCApproveSet",TRowID)),"^",10)
	..s TYearFlag=$CASE(TYearFlag,"Y":"是","N":"否","":"否") ;add by QW 2018-10-08 描述：hisui改造,Y/N改为是/否
	..d OutputRowGetApproveSet
	Quit $$$OK
OutputRowGetApproveSet
	s Data=$lb(TRowID,TApproveType,TDesc,TCode,TEquipType,TPurchaseType,TSpecialType,TSingleMinFee,TSingleMaxFee,TAutoAuditFlag,TYearFlag,TApproveTypeDR,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetApproveSet
	s (TRowID,TApproveType,TDesc,TCode,TEquipType,TPurchaseType,TSpecialType,TSingleMinFee,TSingleMaxFee,TAutoAuditFlag,TYearFlag,TApproveTypeDR)=""
	quit
}

ClassMethod GetApproveSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveSetExecute ]
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

ClassMethod GetApproveSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveSetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
