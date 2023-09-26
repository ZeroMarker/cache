Class web.try Extends %RegisteredObject
{

Query NewQuery110(AdmRowId) As %Query(ROWSPEC = "PbRowId:%String,PbTotal:%String")
{
}

ClassMethod NewQuery110Execute(ByRef qHandle As %Binary, AdmRowId) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i AdmRowId="" s qHandle=$lb(0,repid,0) Quit $$$OK
 
 	s PbRowId=""
 	f  s PbRowId=$o(^DHCPB(0,"ADM",AdmRowId,PbRowId))  q:PbRowId=""  d
    .i $d(^DHCPB(PbRowId)) d
    ..s PbTotal=$p(^DHCPB(PbRowId),"^",8)
 	
 	
	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PbRowId,PbTotal)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod NewQuery110Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery110Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery110Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery110Execute ]
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

Query NewQuery111(PapmiNo) As %Query(ROWSPEC = "AdmRowId:%String")
{
}

ClassMethod NewQuery111Execute(ByRef qHandle As %Binary, PapmiNo) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i PapmiNo="" s qHandle=$lb(0,repid,0)   Quit $$$OK
 	
 	s PapmiRowId=""
 	s PapmiRowId=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PapmiRowId))
 	q:PapmiRowId=""
 	s AdmRowId=""
 	f  s AdmRowId=$o(^PAPERdr(PapmiRowId,"ADM","I",AdmRowId)) q:AdmRowId=""  d
 	
 	 	
	.Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(AdmRowId)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod NewQuery111Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery111Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery111Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery111Execute ]
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

ClassMethod GetPatInfo(PapmiNo)
{

    s PapmiRowId=""
    s PapmiRowId=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PapmiRowId)) 
    s PatName=$p(^PAPER(PapmiRowId,"ALL"),"^",1)
    s PatSexDr=$p(^PAPER(PapmiRowId,"ALL"),"^",7)
    i $d(^CT("SEX",PatSexDr)) s PatSex=$p(^CT("SEX",PatSexDr),"^",2)
    q PatName_"^"_PatSex
}

Query detail(PbRowId) As %Query(ROWSPEC = "ProName:%String,PbdUnitPrice:%String,PbdBillQty:%String,PbdTotalAmount:%String")
{
}

ClassMethod detailExecute(ByRef qHandle As %Binary, PbRowId) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i PbRowId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    
    
    
    s PboRowId="",PbdRowId=""
    f  s PboRowId=$o(^DHCPB(PbRowId,"O",PboRowId)) q:PboRowId=""  d  
    .f  s PbdRowId=$o(^DHCPB(PbRowId,"O",PboRowId,"D",PbdRowId)) q:PbdRowId=""  d
    ..s PbdTariDr=$p(^DHCPB(PbRowId,"O",PboRowId,"D",PbdRowId),"^",3)
    ..s PbdUnitPrice=$p(^DHCPB(PbRowId,"O",PboRowId,"D",PbdRowId),"^",4)
    ..s PbdBillQty=$p(^DHCPB(PbRowId,"O",PboRowId,"D",PbdRowId),"^",5)
    ..s PbdTotalAmount=$p(^DHCPB(PbRowId,"O",PboRowId,"D",PbdRowId),"^",7)
    ..q:PbdTariDr=""
    ..I $D(^DHCTARI(PbdTariDr)) s ProName=$p(^DHCTARI(PbdTariDr),"^",2)
    
    
    
    
    
    ..Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ProName,PbdUnitPrice,PbdBillQty,PbdTotalAmount)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod detailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = detailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod detailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = detailExecute ]
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

}
