/// 名称: web.DHCEQ.Plat.CTExpenditures
/// 描述: 经费来源
/// 编写者：ZX
/// 编写日期: 2018-09-02
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTExpenditures Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-09-02
/// Description:   经费来源LookUp所需Query
/// Table：        DHC_EQCExpenditures
/// Input：        Name:单位描述
Query GetExpenditures(Name As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetExpendituresExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set Name=$ZCONVERT(Name ,"U")
 	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCExpenditures",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetExpenditures
	.Set TRowID = rowid	//rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TRowID)),"^",1) //代码
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TRowID)),"^",2) //描述
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TRowID)),"^",4) //无符号标志
	.Quit:TInvalidFlag'="N"
	.Quit:($ZCONVERT(TCode,"U")'[Name)&($ZCONVERT(TDesc,"U")'[Name)&(Name'="")
	.Do OutputRowGetExpenditures
	Quit $$$OK
OutputRowGetExpenditures
   	Set Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetExpenditures
	Set (TDesc,TRowID,TCode)=""
	Quit
}

ClassMethod GetExpendituresFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExpendituresExecute ]
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

ClassMethod GetExpendituresClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExpendituresExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

}
