/// 名称: 	web.DHCEQ.EM.CTFinanceType
/// 描述: 	资产大类
/// 编写者：CZF
/// 编写日期: 2021-06-29
/// 产品组：设备管理
Class web.DHCEQ.EM.CTFinanceType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：  	CZF
/// CreatDate：	2021-06-29
/// Description:资产大类LookUp所需Query
/// Table：  	DHC_EQCFinanceType
/// Input：  	Name:单位描述
/// Command：	d ##class(%Library.ResultSet).RunQuery("web.DHCEQ.EM.CTFinanceType","GetFinanceType","")
Query GetFinanceType(Name As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetFinanceTypeExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Name=$ZCONVERT(Name ,"U")
 	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCFinanceType",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetFinanceType
	.Set TRowID = rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCFinanceType",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCFinanceType",TRowID)),"^",2)
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCFinanceType",TRowID)),"^",4)
	.Quit:TInvalidFlag="Y"
	.Quit:($ZCONVERT(TCode,"U")'[Name)&($ZCONVERT(TDesc,"U")'[Name)&(Name'="")
	.Do OutputRowGetFinanceType
	Quit $$$OK
OutputRowGetFinanceType
   	Set Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetFinanceType
	Set (TDesc,TRowID,TCode)=""
	Quit
}

ClassMethod GetFinanceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFinanceTypeExecute ]
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

ClassMethod GetFinanceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFinanceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
