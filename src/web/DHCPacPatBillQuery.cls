Class web.DHCPacPatBillQuery Extends %RegisteredObject
{

Query GetPatBillDetail(BillRowid) As %Query(ROWSPEC = "trialName:%String,price:%String,num:%String,total:%String,billDate:%String,billTime:%String")
{
}

ClassMethod GetPatBillDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatBillDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetPatBillDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatBillDetailExecute ]
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

/// Function     :取出指定账单下的收费明细，包括收费项目、单价、数量、金额、收费日期、收费时间等信息
/// Input        :PBRowid,账单Rowid
/// Return       :
ClassMethod GetPatBillDetailExecute(ByRef qHandle As %Binary, BillRowid) As %Status
{
	w BillRowid
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    if BillRowid=""  Set qHandle=$lb(0,repid,0)  Quit $$$OK	
    
    s ordSub=""
    f  s ordSub=$O(^DHCPB(BillRowid,"O",ordSub)) q:ordSub=""  d
    .s detSub=""
    .f  s detSub=$O(^DHCPB(BillRowid,"O",ordSub,"D",detSub)) q:detSub=""  d
    ..s trialRowid = $p(^DHCPB(BillRowid,"O",ordSub,"D",detSub),"^",3)
    ..q:trialRowid=""
    ..s trialName=""
    ..i $d(^DHCTARI(trialRowid)) s trialName=$p(^DHCTARI(trialRowid),"^",2)
    ..s price = $p(^DHCPB(BillRowid,"O",ordSub,"D",detSub),"^",4) 
    ..s num = $p(^DHCPB(BillRowid,"O",ordSub,"D",detSub),"^",5)
    ..s total = $p(^DHCPB(BillRowid,"O",ordSub,"D",detSub),"^",7)
    ..s billDate = $p(^DHCPB(BillRowid,"O",ordSub,"D",detSub),"^",11)
    ..s billTime = $p(^DHCPB(BillRowid,"O",ordSub,"D",detSub),"^",12)    
    ..d OutputRow
   Set qHandle=$lb(0,repid,0)
   Quit $$$OK
    
OutputRow
	set Data=$lb(trialName,price,num,total,billDate,billTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
