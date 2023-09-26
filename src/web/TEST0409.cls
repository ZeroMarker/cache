Class web.TEST0409 Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query Query0409(Param1 As %String, Param2 As %String) As %Query(ROWSPEC = "Arg1:%String,Arg2:%String")
{
}

ClassMethod Query0409Execute(ByRef qHandle As %Binary, Param1 As %String, Param2 As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=0
    
    s RowID=""
     
    f  s RowID=$o(^SSU("SSUSR",RowID))  q:RowID=""  d
    .i $d(^SSU("SSUSR",RowID))   s username=$p(^SSU("SSUSR",RowID),"^",2)
    .//q:(User'="")&(User'=username)
    .d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
		
OutputRow
	set Data=$lb(username,RowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod Query0409Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = Query0409Execute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod Query0409Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = Query0409Execute ]
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
