/// 办卡统计QUERY
Class web.DHCFHQ.CardTotal Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query CardTypeNumByDate(StartDate As %String, EndDate As %String, HospDesc As %String) As %Query(ROWSPEC = "操作员:%String,卡壮态:%String,卡类型:%String,办卡数:%String,退卡数:%String") [ SqlProc ]
{
}

ClassMethod CardTypeNumByDateExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, HospDesc As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s RetNum=##class(web.DHCFHQ.CardTotalF).CardTypeByDate(repid,StartDate,EndDate,HospDesc)
 d ##Class(web.DHCFHQ.DHCFBasicInfo).QueryExecute(repid)
 Set qHandle=$lb(0,repid,0)
 quit $$$OK
}

ClassMethod CardTypeNumByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardTypeNumByDateExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod CardTypeNumByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardTypeNumByDateExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

Query CardTotalCancle(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "操作员:%String,卡类型:%String,卡壮态:%String,办卡数:%String,退卡数:%String")
{
}

ClassMethod CardTotalCancleExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s RetNum=##class(web.DHCFHQ.CardTotalF).CardTypeByDateCancle(repid,StartDate,EndDate)
 	d ##Class(web.DHCFHQ.DHCFBasicInfo).QueryExecute(repid)
 	Set qHandle=$lb(0,repid,0)
 	quit $$$OK
}

ClassMethod CardTotalCancleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CardTotalCancleExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod CardTotalCancleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CardTotalCancleExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

}
