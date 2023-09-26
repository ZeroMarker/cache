/// 名称: 	web.DHCEQ.Plat.CTTaxItem
/// 描述: 	税目分类
/// 编写者：CZF
/// 编写日期: 2022-09-16
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTTaxItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：  	CZF
/// CreatDate：	2021-06-29
/// Description:税目分类LookUp所需Query
/// Table：  	DHC_EQCTaxItem
/// Input：  	Name:单位描述
/// Command：	d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.Plat.CTTaxItem","GetTaxItem","")
Query GetTaxItem(Name As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetTaxItemExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Name=$ZCONVERT(Name ,"U")
 	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCTaxItem",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetTaxItem
	.Set TRowID = rowid
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCTaxItem",TRowID)),"^",4)
	.Quit:TInvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCTaxItem",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCTaxItem",TRowID)),"^",2)
	.Quit:($ZCONVERT(TCode,"U")'[Name)&($ZCONVERT(TDesc,"U")'[Name)&(Name'="")
	.Do OutputRowGetTaxItem
	Quit $$$OK
OutputRowGetTaxItem
   	Set Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetTaxItem
	Set (TDesc,TRowID,TCode)=""
	Quit
}

ClassMethod GetTaxItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTaxItemExecute ]
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

ClassMethod GetTaxItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTaxItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
