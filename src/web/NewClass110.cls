Class web.NewClass110 Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
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

Storage Default
{
<Data name="NewClass110DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.NewClass110D</DataLocation>
<DefaultData>NewClass110DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.NewClass110D</IdLocation>
<IndexLocation>^web.NewClass110I</IndexLocation>
<StreamLocation>^web.NewClass110S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
