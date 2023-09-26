Class web.DHDBZTNewClass Extends %RegisteredObject
{

Query NewQuery1(patnum) As %Query(ROWSPEC = "billRowId:%String,billAmount:%String")
{
}

ClassMethod NewQuery1Execute(ByRef qHandle As %Binary, patnum) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i patnum="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s billRowId=""
    f  s billRowId=$o(^DHCPB(0,"ADM",patnum,billRowId)) q:billRowId=""  d
    .s billAmount=$p(^DHCPB(billRowId),"^",8)
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(billRowId,billAmount)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod NewQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	
	Quit $$$OK
}

ClassMethod NewQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
