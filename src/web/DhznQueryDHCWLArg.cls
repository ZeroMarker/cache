Import SQLUser

Class web.DhznQueryDHCWLArg Extends %RegisteredObject [ Not ProcedureBlock ]
{

//d ##class(%ResultSet).RunQuery("web.DhznQueryDHCWLArg","GetDep","1")	

ClassMethod GetDepExecute(ByRef qHandle As %Binary, useId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
   
    q:useId="" $$$OK
    s outdata=$$GetUserLoginLoc^DHCWLGetCurrentPatFee(useId,.data)
    f num=0:1:outdata-1 d
    .s loc=$p(data(num),"^",1)
    .s desc=$p(data(num),"^",2)
    .d OutputRow1
 	q $$$OK	

OutputRow1
  
    s Data=$lb(loc,desc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepExecute ]
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

ClassMethod GetDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetDep(useId As %String) As %Query(ROWSPEC = "loc:%Integer,desc:%String") [ SqlProc ]
{
}

}
