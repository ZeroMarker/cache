Class web.DHCFHQ.OrderExec Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query GetOrdExecByLoc(LocId As %String, GroupId As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "类型,科室名称,医嘱名称,人员代码,姓名,医嘱单位,数量,金额:%String") [ SqlProc ]
{
}

ClassMethod GetOrdExecByLocExecute(ByRef qHandle As %Binary, LocId As %String, GroupId As %String, StartDate As %String, EndDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCFHQ.OrderExec","GetOrdExecByLoc","656","58","2011-12-13","2011-12-13")
 Set repid=$I(^CacheTemp)
 ;s LocId=%session.Get("LOGON.CTLOCID")
 ;s ^fhqsess=%session.Data("LOGON.CTLOCID")
 ;S LocId=202
 S ^FHQCT=LocId_"^"_GroupId
 if $g(LocId)="" s qHandle=$lb(0,0,0)
 quit:($g(LocId)="") $$$OK
 s RetNum=##class(web.DHCFHQ.Ord.OrdInfo).GetOrdByLoc(repid,LocId,GroupId,StartDate,EndDate)
 d ##Class(web.DHCFHQ.DHCFBasicInfo).QueryExecute(repid)
 Set qHandle=$lb(0,repid,0)
 quit $$$OK
}

ClassMethod GetOrdExecByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdExecByLocExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod GetOrdExecByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdExecByLocExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

/// 按核算分类开统计执行
/// d ##class(%ResultSet).RunQuery("web.DHCFHQ.OrderExec","GetOrdExecByLocTar","331","87","2011-12-13","2011-12-14")
Query GetOrdExecByLocTar(LocId As %String, GroupId As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "科室名称,人员代码,姓名,分类,金额:%String") [ SqlProc ]
{
}

ClassMethod GetOrdExecByLocTarExecute(ByRef qHandle As %Binary, LocId As %String, GroupId As %String, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 ;s LocId=%session.Get("LOGON.CTLOCID")
 ;s ^fhqsess=%session.Data("LOGON.CTLOCID")
 ;S LocId=202
 S ^FHQCT=LocId_"^"_GroupId
 if $g(LocId)="" s qHandle=$lb(0,0,0)
 quit:($g(LocId)="") $$$OK
 s RetNum=##class(web.DHCFHQ.Ord.OrdInfo).GetOrdByLocTotal(repid,LocId,GroupId,StartDate,EndDate)
 d ##Class(web.DHCFHQ.DHCFBasicInfo).QueryExecute(repid)
 Set qHandle=$lb(0,repid,0)
 quit $$$OK
}

ClassMethod GetOrdExecByLocTarClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdExecByLocTarExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod GetOrdExecByLocTarFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdExecByLocTarExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

}
