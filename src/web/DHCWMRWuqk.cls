Import SQLUser

Class web.DHCWMRWuqk Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right ]
{

Parameter BUILD = 11;

ClassMethod QueryTestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryTestExecute(ByRef qHandle As %Binary, Date1 As %String, Loc1 As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	
	
	/*
	/query........
	/
	/查询出数据
	/
	/
	/在这里循环调用
	/d BuildData
	/Set ind=ind+1
	/*/
	Quit $$$OK
	
BuildData
	
    s data=$lb(a1,a2,a3,a4)
    /*
    s data=$lb("")
 	For iIndex=1:1:$l(s) Do
 	.Set $li(data,iIndex)=$p(s,"^",iIndex)
 	*/
 	s ^CacheTemp(repid,ind)=data
	
	q err
}

ClassMethod QueryTestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTestExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// test for liyang
Query QueryTest(Date1 As %String, Loc1 As %String) As %Query(ROWSPEC = "Field1:%String,Field2:%String")
{
}

}
