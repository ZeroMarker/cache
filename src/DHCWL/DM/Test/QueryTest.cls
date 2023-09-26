Class DHCWL.DM.Test.QueryTest Extends %RegisteredObject [ Not ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("DHCWL.DM.Test.QueryTest","A")

Query A() As %Query(ROWSPEC = "ID:%String,Code:%String")
{
}

ClassMethod AExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,2)
	Set ind=3
	w "A1:"_$lts(qHandle),!
	b ;1
	set rs=##class(%ResultSet).%New("DHCWL.DM.Test.QueryTest:B")
	set sc=rs.Execute()
	w "A2:"_$lts(qHandle),!
	b ;3
	While rs.Next(.sc) {
      If $$$ISERR(sc) Quit
	  d BuildRowA($lb(rs.Data("ID"),rs.Data("Code")))
	}

	Quit $$$OK
BuildRowA(rowList)
	s ^CacheTemp(repid,ind)=rowList
 	s ind=ind+1
	q
}

ClassMethod AClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AExecute ]
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

Query B() As %Query(ROWSPEC = "ID:%String,Code:%String,Name:%String")
{
}

ClassMethod BExecute(ByRef qHandle As %Binary) As %Status
{
	b ;2
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	w "B1:"_$lts(qHandle),!
	Set ind=1
	d BuildRowB($lb(1,"A","A测试"))
	d BuildRowB($lb(2,"B","B测试"))
	d BuildRowB($lb(3,"C","C测试"))

	Quit $$$OK
BuildRowB(rowList)
	s ^CacheTemp(repid,ind)=rowList
 	s ind=ind+1
	q
}

ClassMethod BClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod BFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BExecute ]
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
