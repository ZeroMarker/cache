Class web.DHCFSchedule Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod ValueNullClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ValueNullExecute ]
{
	Quit ##Class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod ValueNullExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^"
	//s Para=OrdItm_del_ArcimCatSub_del_StopFlag
 //s RetNum=##class(web.DHCFArcimGet).GetArcimByAlia(repid,Para)
 //s i=0
 //f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 s Data="fhq^iqiq"
 s Data=$lb($p(Data,del,2),$p(Data,del,1))
 s ^CacheTemp(repid,ind)=Data
 //S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod ValueNullFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ValueNullExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
 Quit $$$OK
}

Query ValueNull() As %Query(ROWSPEC = "LocCode:%String:医嘱名称")
{
}

}
