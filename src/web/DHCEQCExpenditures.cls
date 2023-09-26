Import SQLUser

Class web.DHCEQCExpenditures Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQCExpenditures","GetExpenditures","服务")
Query GetExpenditures(data As %String = "") As %Query(ROWSPEC = "Description:%String:经费来源,HIDDEN:%String,Code:%String:编码")
{
}

ClassMethod GetExpendituresExecute(ByRef qHandle As %Binary, data As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set data=$ZCONVERT(data ,"U")
 	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCExpenditures",rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetExpenditures
	.Set TRowID = rowid	//rowid
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TRowID)),"^",1) //代码
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TRowID)),"^",2) //描述
	.Set TInvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TRowID)),"^",4) //无符号标志
	.Quit:TInvalidFlag'="N"
	.Quit:($ZCONVERT(TCode,"U")'[data)&($ZCONVERT(TDesc,"U")'[data)&(data'="")
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
