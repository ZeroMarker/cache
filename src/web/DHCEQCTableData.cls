Class web.DHCEQCTableData Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUp() As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT TD_Desc,
	   TD_RowID,
	   TD_Code
FROM sqluser.DHC_EQCTableData
}

/// add by wy  2017-06-19 添加列表序号
Query TableData() As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRow:%String")
{
}

ClassMethod TableDataExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCTableData",rowid)) q:rowid=""  d
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCTableData",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCTableData",rowid)),"^",2)
	.d OutputRowFormat
	
	Quit $$$OK
OutputRowFormat
    s TRow=TRow+1
    s Data=$lb(TRowID,TCode,TDesc,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod TableDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TableDataExecute ]
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

ClassMethod TableDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TableDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
