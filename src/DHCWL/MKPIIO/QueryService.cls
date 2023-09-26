Class DHCWL.MKPIIO.QueryService Extends %RegisteredObject
{

Query AccessClass() As %Query(ROWSPEC = "className:%String,code:%String,name:%String")
{
}

ClassMethod AccessClassExecute(ByRef qHandle As %Binary) As %Status
{
	Quit $$$OK
}

ClassMethod AccessClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AccessClassExecute ]
{
	Quit $$$OK
}

ClassMethod AccessClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AccessClassExecute ]
{
	Quit $$$OK
}

}
