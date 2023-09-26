Class web.DHCBPCManufacturer Extends %RegisteredObject
{

/// 查询设备厂家信息
/// d ##class(%ResultSet).RunQuery("web.DHCBPCManufacturer","FindEManufacturer","")
Query FindEManufacturer(rowid) As %Query(ROWSPEC = "tRowId:%String,BPCMCode:%String,BPCMDesc:%String")
{
}

ClassMethod FindEManufacturerExecute(ByRef qHandle As %Binary, rowid) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPCMRowId=0
	for  s tBPCMRowId=$o(^DHCBPC("Manufacturer",tBPCMRowId)) q:tBPCMRowId=""  d
	.q:(rowid'="")&&(rowid'=tBPCMRowId)
	.s mCode=$lg(^DHCBPC("Manufacturer",tBPCMRowId),1)
	.s mDesc=$lg(^DHCBPC("Manufacturer",tBPCMRowId),2)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPCMRowId,mCode,mDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEManufacturerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEManufacturerExecute ]
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

ClassMethod FindEManufacturerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEManufacturerExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
