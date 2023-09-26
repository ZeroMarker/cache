Class web.DHCFBORD Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod OrdCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrdCatExecute ]
{
	Quit ##class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod OrdCatExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
 s OrdCatId=0
 f  s OrdCatId=$o(^OEC("ORCAT",OrdCatId)) q:OrdCatId=""  d
 .s ab=OrdCatId
 .s desc=$p(^OEC("ORCAT",OrdCatId),del,2)
 .s Data=$lb(OrdCatId,desc)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod OrdCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrdCatExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
	Quit $$$OK
}

ClassMethod OrdCatSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OrdCatSubExecute ]
{
	Quit ##class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod OrdCatSubExecute(ByRef qHandle As %Binary, OrdCat As %String, OrdCatSub As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
 s:$g(OrdCatSub)="" ordsid=0
 s:$g(OrdCatSub)'="" ordsid=OrdCatSub
 f  s ordsid=$o(^ARC("IC",ordsid)) q:ordsid=""  d
 .q:(($g(OrdCatSub)'=ordsid)&($g(OrdCatSub)'=""))
 .s code=$p(^ARC("IC",ordsid),del,1)
 .s desc=$p(^ARC("IC",ordsid),del,2)
 .s ordcate=$p(^ARC("IC",ordsid),del,8)
 .q:(($G(OrdCat)'=ordcate)&($G(OrdCat)'=""))
 .s Data=$lb(desc,ordsid)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod OrdCatSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OrdCatSubExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
	Quit $$$OK
}

Query OrdCat() As %Query(ROWSPEC = "OrdCatId:%String,desc:%String")
{
}

Query OrdCatSub(OrdCat As %String, OrdCatSub As %String) As %Query(ROWSPEC = "Id:%String,desc:%String")
{
}

Storage Default
{
<Data name="DHCFBORDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCFBORDD</DataLocation>
<DefaultData>DHCFBORDDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCFBORDD</IdLocation>
<IndexLocation>^web.DHCFBORDI</IndexLocation>
<StreamLocation>^web.DHCFBORDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
