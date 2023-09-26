/// add by zy 20180814  ZY0171
/// 产品库功能代码
Class web.DHCEQ.Plat.CTBrand Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetBrand(ManuFactoryDR, valName) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetBrandExecute(ByRef qHandle As %Binary, ManuFactoryDR, valName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBrandList
	Quit $$$OK
BuildDataGetBrandList
	f  s rowid=$o(^DHCEQCCode("DHCEQCBrand",rowid))  quit:rowid=""  d
	.d ResetVariablesGetBrandList
	.s TRowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",5)
	.q:Flag="Y"
	.s TName = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",3)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",2)
	.q:(valName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(valName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(valName,"U")))
	.s ManuFactory=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",1)
	.q:(ManuFactoryDR'="")&&(ManuFactoryDR'=ManuFactory)&&(ManuFactory'="")
	.d OutputRowGetBrandList
	quit
OutputRowGetBrandList
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBrandList
	s (Name,RowID,Code)=""
	quit
}

ClassMethod GetBrandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBrandExecute ]
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

ClassMethod GetBrandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBrandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
