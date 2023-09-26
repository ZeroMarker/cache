Class web.DHCBPCDetection Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCDetection","FindBPCDetection")
Query FindBPCDetection() As %Query(ROWSPEC = "tRowId:%String,BPCDCode:%String,BPCDDesc:%String,BPCDType:%String,BPCDSpecimenDr:%String,BPCDMinQty:%String,BPCDMaxQty:%String,BPCDUomDr:%String,BPCDDetectIntervalDay:%String")
{
}

ClassMethod FindBPCDetectionExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tRowId=0
	f  s tRowId=$o(^DHCBPC("Detection",tRowId)) q:tRowId=""  d
	.s BPCDCode=$lg($g(^DHCBPC("Detection",tRowId)),1)
	.s BPCDDesc=$lg($g(^DHCBPC("Detection",tRowId)),2)
	.s BPCDType=$lg($g(^DHCBPC("Detection",tRowId)),3)
	.s BPCDSpecimenDr=$lg($g(^DHCBPC("Detection",tRowId)),4)
	.s BPCDMinQty=$lg($g(^DHCBPC("Detection",tRowId)),5)
	.s BPCDMaxQty=$lg($g(^DHCBPC("Detection",tRowId)),6)
	.s BPCDUomDr=$lg($g(^DHCBPC("Detection",tRowId)),7)
	.s BPCDDetectIntervalDay=$lg($g(^DHCBPC("Detection",tRowId)),8)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tRowId,BPCDCode,BPCDDesc,BPCDType,BPCDSpecimenDr,BPCDMinQty,BPCDMaxQty,BPCDUomDr,BPCDDetectIntervalDay)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPCDetectionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCDetectionExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindBPCDetectionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCDetectionExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
