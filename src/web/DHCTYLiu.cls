Class web.DHCTYLiu Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Query TYLiuData(UserName) As %Query(ROWSPEC = "UserName:%String,UserRowid:%String")
{
}

ClassMethod TYLiuDataExecute(ByRef qHandle As %Binary, UserName) As %Status
{
	   Set repid=$I(^CacheTemp)
       s ind=1
       
       s rowid=0
       f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d      
       .s username=$p(^SSU("SSUSR",rowid),"^",2)
       .q:(username'[UserName)&(UserName'="") 
       
       .Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(username,rowid)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod TYLiuDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TYLiuDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TYLiuDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TYLiuDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod TYLiuDataFind(itmjs, UserID)
{
	q:UserID=""
	s username=$p(^SSU("SSUSR",UserID),"^",2)
	s password=$p(^SSU("SSUSR",UserID),"^",3)
	s str=username_"^"_password
	s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"')"
	&js<#(retval)#> 
    ;w !,str
    q
}

Query TYLiuGetData(UserName) As %Query(ROWSPEC = "UserName:%String,UserRowid:%String")
{
}

ClassMethod TYLiuGetDataExecute(ByRef qHandle As %Binary, UserName) As %Status
{
	   Set repid=$I(^CacheTemp)
       s ind=1
       
       s rowid=0
       f  s rowid=$o(^SSU("SSUSR",rowid)) q:rowid=""  d      
       .s username=$p(^SSU("SSUSR",rowid),"^",2)
       .q:(username'=UserName)&(UserName'="") 
       
       .Do OutputRow
       Set qHandle=$lb(0,repid,0)
       Quit $$$OK
OutputRow
       set Data=$lb(username,rowid)
       Set ^CacheTemp(repid,ind)=Data
       Set ind=ind+1
	   quit
}

ClassMethod TYLiuGetDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TYLiuGetDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TYLiuGetDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TYLiuGetDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
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
<Data name="DHCTYLiuDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCTYLiuD</DataLocation>
<DefaultData>DHCTYLiuDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCTYLiuD</IdLocation>
<IndexLocation>^web.DHCTYLiuI</IndexLocation>
<StreamLocation>^web.DHCTYLiuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
