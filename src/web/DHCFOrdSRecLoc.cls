Class web.DHCFOrdSRecLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ItemCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ItemCatExecute ]
{
	
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod ItemCatExecute(ByRef qHandle As %Binary, OrdCat As %String, OrdCatSubId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
 s ^ab=OrdCatSubId_"^"_OrdCat
 s:$g(OrdCatSubId)="" ordsid=0
 s:$g(OrdCatSubId)'="" ordsid=OrdCatSubId-1
 f  s ordsid=$o(^ARC("IC",ordsid)) q:ordsid=""  d
 .q:(($g(OrdCatSubId)'=ordsid)&($g(OrdCatSubId)'="")) 
 .s code=$p(^ARC("IC",ordsid),del,1)
 .s desc=$p(^ARC("IC",ordsid),del,2)
 .s ordcate=$p(^ARC("IC",ordsid),del,8)
 .q:(($G(OrdCat)'=ordcate)&($G(OrdCat)'=""))
 .s:$d(^OEC("ORCAT",ordcate)) ordcate=$p(^OEC("ORCAT",ordcate),del,2)
 .s Data=$lb(ordsid,code,desc,ordcate)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
 Set qHandle=$lb(0,repid,0)
 quit $$$OK
}

ClassMethod ItemCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ItemCatExecute ]
{
 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

ClassMethod OrdSRecLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrdSRecLocExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod OrdSRecLocExecute(ByRef qHandle As %Binary, ItemCatId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 If $g(ind)="" Set ind=1
 s del="^",childid=0
 q:ItemCatId="" $$$OK
 f  s childid=$o(^ARC("IC",ItemCatId,"RL",childid)) q:childid=""  d
 .s str=$g(^ARC("IC",ItemCatId,"RL",childid))
 .s type=$p(str,del,1),patloc=$p(str,del,2),recloc=$p(str,del,3)
 .S:patloc'="" patloc=$p(^CTLOC(patloc),del,1)
 .S:recloc'="" recloc=$p(^CTLOC(recloc),del,1)
 .s Data=$lb(type,ItemCatId,patloc,recloc)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
 Set qHandle=$lb(0,repid,0)
	quit $$$OK
}

ClassMethod OrdSRecLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrdSRecLocExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

Query ItemCat(OrdCat As %String, OrdCatSubId As %String) As %Query(ROWSPEC = "Id:%String,Code:%String,Desc:%String,OrdCat:%String")
{
}

Query OrdSRecLoc(ItemCatId As %String) As %Query(ROWSPEC = "type:%String,OrdSType:%String,PatLoc:%String,RecLoc:%String")
{
}

Storage Default
{
<Data name="DHCFOrdSRecLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCFOrdSRecLocD</DataLocation>
<DefaultData>DHCFOrdSRecLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCFOrdSRecLocD</IdLocation>
<IndexLocation>^web.DHCFOrdSRecLocI</IndexLocation>
<StreamLocation>^web.DHCFOrdSRecLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
