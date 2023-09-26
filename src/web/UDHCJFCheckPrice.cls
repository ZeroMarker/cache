Class web.UDHCJFCheckPrice Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod OrdPriceExecute(ByRef qHandle As %Binary, EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %String = "", uomstr As %String = "", drugformstr As %String = "", ordidstr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s strlen=$LENGTH(itemstr,"^")
	s sum=0
	f i=1:1:strlen d 
	
	.s arcim1=$p(itemstr,"^",i)
	.q:arcim1=""
	.s oerowid=$p(ordidstr,"^",i)
	.i oerowid'="" d
	..s qty=$p(^OEORD(+oerowid,"I",$p(oerowid,"||",2),1),"^",12)

	.s price=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcim1,+$h,"","","","")
	.s unitprice=$p(price,"^",1)
	.s total=unitprice*qty
	.s arcim=+arcim1
	.s sub=$p(arcim1,"||",2)
	.s arcimdesc=$p(^ARCIM(arcim,sub,1),"^",2)    
    .s sum=sum+total
    .d OutputRow
    s arcim1="",arcimdesc="合计",qty="",unitprice="",total=sum
    d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow
	set Data=$lb(arcim1,arcimdesc,qty,unitprice,total)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OrdPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrdPriceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod OrdPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrdPriceExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query OrdPrice(EpisodeID As %String, itemstr As %String, qtystr As %String, ordsetidstr As %String, billpricestr As %String = "", uomstr As %String = "", drugformstr As %String = "", ordidstr As %String) As %Query(ROWSPEC = "ID,Item:%String,Qty:%String,Price:%String,Total:%String")
{
}

}
