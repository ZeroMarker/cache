Class web.DHCFCareProvService Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CareProvServiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CareProvServiceExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod CareProvServiceExecute(ByRef qHandle As %Binary, CtCareDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
 s RetNum=##class(web.DHCFBCare).GetCareService(repid,CtCareDr)
 s i=0
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=$g(^CacheTempFHQ(repid,i))
 .s Data=##class(web.DHCFBCM).StrToList(Data,del)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod CareProvServiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CareProvServiceExecute ]
{
	S Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

Query CareProvService(CtCareDr As %String) As %Query(ROWSPEC = "rid,TService")
{
}

}
