/// 挂号统计
Class web.DHCFHQ.DHCFRegTotal Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

//d ##class(%ResultSet).RunQuery("web.DHCFHQ.DHCFRegTotal","GetLocReg","","","")

/// 取科室挂号数量
Query GetLocReg(StartDate As %String, EndDate As %String, USERID As %String) As %Query(ROWSPEC = "科室名称:%String,类别:%String,出诊级别:%String,挂号数量:%String,退号数") [ SqlProc ]
{
}

ClassMethod GetLocRegExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, USERID As %String) As %Status
{
  
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 ;s EpisodeID="119"
 ;S EpisodeID=1
 s del="^"
 s RetNum=##class(web.DHCFHQ.DHCFBRegTotal).GetLocReg(repid,StartDate,EndDate,USERID)
 s i=0
 f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 .s Data=^CacheTempFHQ(repid,i)
 .s ^CacheTemp(repid,ind)=Data
 .S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
 quit $$$OK
}

ClassMethod GetLocRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocRegExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod GetLocRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocRegExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

/// 得医生的挂号金额和数量
Query GetLocDocReg(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "科室名称:%String,医生:%String,金额:%String,挂号数量:%String,挂号金额") [ SqlProc ]
{
}

ClassMethod GetLocDocRegExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s RetNum=##class(web.DHCFHQ.DHCFBRegTotal).GetLocDocReg(repid,StartDate,EndDate)
 	d ##Class(web.DHCFHQ.DHCFBasicInfo).QueryExecute(repid)
 	Set qHandle=$lb(0,repid,0)
 	quit $$$OK
}

ClassMethod GetLocDocRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocDocRegExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod GetLocDocRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocDocRegExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

}
