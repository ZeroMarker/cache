/// 关于就诊信息的查询
Class web.DHCFHQ.AdmInfo Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

Query LeaveProve(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "登记号,姓名,性别,出生日期,就诊科室,医生:%String") [ SqlProc ]
{
}

ClassMethod LeaveProveExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	if $g(StartDate)="" s qHandle=$lb(0,0,0)
 	quit:($g(StartDate)="") $$$OK
 	if $g(EndDate)="" s qHandle=$lb(0,0,0)
 	quit:($g(EndDate)="") $$$OK
 	s RetNum=##class(web.DHCFHQ.Adm.GetInfoByAdm).LeaveProv(repid,StartDate, EndDate)
 	d ##Class(web.DHCFHQ.DHCFBasicInfo).QueryExecute(repid)
 	Set qHandle=$lb(0,repid,0)
 	quit $$$OK
}

ClassMethod LeaveProveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LeaveProveExecute ]
{
	Quit ##Class(web.DHCFHQ.DHCFBasicInfo).QueryClose(qHandle)
}

ClassMethod LeaveProveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LeaveProveExecute ]
{
	s Row= ##Class(web.DHCFHQ.DHCFBasicInfo).QueryFetch(qHandle,AtEnd)
 	Quit $$$OK
}

}
