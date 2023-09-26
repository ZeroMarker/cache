Class web.DHCPE.RelateItem Extends %RegisteredObject
{

ClassMethod Update(Instring)
{
	s OldItem=$p(Instring,"^",1)
	s RelateItem=$p(Instring,"^",2)
	s tmpLoop=$o(^DHCPEDataEx("RelateItem",OldItem,""),-1)
	i tmpLoop="" s tmpLoop=1
	e  s tmpLoop=tmpLoop+1
	s ^DHCPEDataEx("RelateItem",OldItem,tmpLoop)=RelateItem
	s ^DHCPECTDataEx("RelatedItem",RelateItem)=OldItem
	q 0
}

ClassMethod Delete(Instring)
{
	s OldItem=$p(Instring,"^",1)
	s RelateItem=$p(Instring,"^",2)
	s tmpLoop=0
	f  s tmpLoop=$o(^DHCPEDataEx("RelateItem",OldItem,tmpLoop)) q:tmpLoop=""  d
	.s NowRelate=$g(^DHCPEDataEx("RelateItem",OldItem,tmpLoop))
	.i NowRelate=RelateItem d
	.k ^DHCPECTDataEx("RelatedItem",^DHCPEDataEx("RelateItem",OldItem,tmpLoop))
	.k ^DHCPEDataEx("RelateItem",OldItem,tmpLoop)
	q
}

Query query(ItemID) As %Query(ROWSPEC = "RelateID:%String,RelateDesc:%String")
{
}

ClassMethod queryExecute(ByRef qHandle As %Binary, ItemID) As %Status
{

 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    s tmpLoop=0
 	f  s tmpLoop=$o(^DHCPEDataEx("RelateItem",ItemID,tmpLoop)) q:tmpLoop=""  d
 	.s RelateItem=$g(^DHCPEDataEx("RelateItem",ItemID,tmpLoop))
 	.s RelateItemDesc=$P($G(^ARCIM($p(RelateItem,"||",1),$p(RelateItem,"||",2),1)),"^",2)
 	.Do OutputRow
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(RelateItem,RelateItemDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod queryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = queryExecute ]
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

ClassMethod queryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = queryFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
