Class web.DHCANRJ Extends %RegisteredObject
{

Query FindRICT() As %Query(ROWSPEC = "CTloc:%String,locID:%String")
{
}

ClassMethod FindRICTExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s id=""
	f  s id=$o(^DHCANCRJ(id)) q:id=""  d
	.s locID=""
    .s locID=id
	.s CTloc=$p($g(^CTLOC(id)),"^",2)
	.Do OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow6
	set Data=$lb(CTloc,locID)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindRICTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncAppDateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)

	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else {	Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindRICTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncAppDateExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Insert(locID As %String)
{
	q:locID=""
	s ^DHCANCRJ(locID)=""
	
	q 0
}

ClassMethod Delete(ID As %String)
{
	q:ID=""
	k ^DHCANCRJ(ID)
	
	q 0
}

ClassMethod FindlocID()
{
	s id=""
	s locID=""
	s ^DHCRJ("locID")=""
	f  s id=$o(^DHCANCRJ(id)) q:id=""  d
    .s locID=id
    .q:locID=""
    .s ^DHCRJ("locID")=locID_"^"_^DHCRJ("locID")
    .s B=^DHCRJ("locID")

	q B
}

}
