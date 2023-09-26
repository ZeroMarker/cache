Class web.DHCwty1 Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Query Entry(patno) As %Query(ROWSPEC = "admid:%String,admno:%String")
{
}

ClassMethod EntryExecute(ByRef qHandle As %Binary, patno) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    i patno="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s rowid=""
    s rowid=$o(^PAPERi("PAPMI_PatNo",patno,rowid))
    q:rowid=""
    s admid=""
    f  s admid=$o(^PAPERdr(rowid,"ADM","I",admid)) q:admid=""  d
    .s admno=$p(^PAADM(admid),"^",81)
   
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(admid,admno)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
}

ClassMethod EntryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EntryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod EntryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EntryExecute ]
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

Query Detail(admid) As %Query(ROWSPEC = "amount:%String,rowid:%String")
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, admid) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    
    i admid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    
    s rowid=""
    f  s rowid=$o(^DHCPB(0,"ADM",admid,rowid)) q:rowid=""  d
    .s amount=$p(^DHCPB(rowid),"^",8)
    
    .Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(amount,rowid)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
    
	Quit $$$OK
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DetailExecute ]
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

Query GetDetail(rowid) As %Query(ROWSPEC = "billname:%String,price:%String,billqty:%String,payamount:%String")
{
}

ClassMethod GetDetailExecute(ByRef qHandle As %Binary, rowid) As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    i rowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    
    s pbrowid="",pbdrowid=""
    f  s pbrowid=$o(^DHCPB(rowid,"O",pbrowid)) q:pbrowid=""  d
    .f  s pbdrowid=$o(^DHCPB(rowid,"O",pbrowid,"D",pbdrowid)) q:pbdrowid=""  d
    ..s price=$p(^DHCPB(rowid,"O",pbrowid,"D",pbdrowid),"^",4)
    ..s billqty=$p(^DHCPB(rowid,"O",pbrowid,"D",pbdrowid),"^",5)
    ..s payamount=$p(^DHCPB(rowid,"O",pbrowid,"D",pbdrowid),"^",7)
    ..s tarid=$p(^DHCPB(rowid,"O",pbrowid,"D",pbdrowid),"^",3)
    ..q:tarid=""
    ..i $d(^DHCTARI(tarid)) s billname=$p(^DHCTARI(tarid),"^",2)
    ..Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(billname,price,billqty,payamount)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
	quit
    
	Quit $$$OK
}

ClassMethod GetDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDetailExecute ]
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

Storage Default
{
<Data name="DHCwty1DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCwty1D</DataLocation>
<DefaultData>DHCwty1DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCwty1D</IdLocation>
<IndexLocation>^web.DHCwty1I</IndexLocation>
<StreamLocation>^web.DHCwty1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
