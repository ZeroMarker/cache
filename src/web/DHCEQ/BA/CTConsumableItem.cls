Class web.DHCEQ.BA.CTConsumableItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetConsumableItem(Code As %String = "", Desc As %String = "", ExTypeDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String:描述,TCode:%String:编码,TUnitDR:%String,TUnit:%String:单位,TPrice:%String:单价,TExType:%String:对照类型,TExID:%String:对照ID,TExDesc:%String:对照描述,TPayPrice:%String:付款金额,TRow:%String:序号,TChargeType:%String,TExpenseType:%String,TAdditionRate:%String,TBillItemNo:%String,TRegistrationNo:%String,TExpenseRate:%String,TDisposableFlag:%String")
{
}

/// modified by sjh 2020-01-19 增加输出	TChargeType,TExpenseType,TAdditionRate,TBillItemNo,TRegistrationNo,TExpenseRate,TDisposableFlag
ClassMethod GetConsumableItemExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", ExTypeDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=1
	s rowid=0
	d BuildDataGetConsumableItem
	Quit $$$OK
	
BuildDataGetConsumableItem
	Set Code=##Class(web.DHCEQCommon).UnEscape(Code)
	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
	f  s rowid=$o(^DHCEQCCode("DHCEQCConsumableItem",rowid))  quit:rowid=""  d
	.d ResetVariablesGetConsumableItem
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",7)
	.q:InvalidFlag="Y"
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",1)
	.q:(Desc'="")&&(TDesc'=Desc)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",2)
	.q:(Code'="")&&(TCode'=Code)
	.s TUnitDR=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",4)
	.s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",3)
	.s TExType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",5)
	.q:(ExTypeDR'="")&&(TExType'=ExTypeDR)
	.s TExID=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",6)
	.s TExDesc=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",8)
	.s TPayPrice=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",9)
	.s TChargeType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",14)
	.i TChargeType'="" s TChargeType=##Class(web.DHCEQCConsumableItem).GetChargeType(TChargeType)
	.s TExpenseType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",15)
	.i TExpenseType'="" s TExpenseType=##Class(web.DHCEQCConsumableItem).GetExpenseType(TExpenseType)
	.s TAdditionRate=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",16)
	.s TBillItemNo=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",17)
	.s TRegistrationNo=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",18)
	.s TExpenseRate=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",19)
	.s TDisposableFlag=$p($g(^DHCEQCCode("DHCEQCConsumableItem",rowid)),"^",20)
	.i TDisposableFlag'="" s TDisposableFlag=##Class(web.DHCEQCConsumableItem).GetDisposableFlag(TDisposableFlag)
	.d OutputRowGetConsumableItem
	quit
OutputRowGetConsumableItem
	s Data=$lb(TRowID,TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc,TPayPrice,TRow,TChargeType,TExpenseType,TAdditionRate,TBillItemNo,TRegistrationNo,TExpenseRate,TDisposableFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	quit
ResetVariablesGetConsumableItem
	s (TRowID,TDesc,TCode,TUnitDR,TUnit,TPrice,TExType,TExID,TExDesc,TPayPrice,TChargeType,TExpenseType,TAdditionRate,TBillItemNo,TRegistrationNo,TExpenseRate,TDisposableFlag)=""
	quit
}

ClassMethod GetConsumableItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsumableItemExecute ]
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

ClassMethod GetConsumableItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsumableItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
