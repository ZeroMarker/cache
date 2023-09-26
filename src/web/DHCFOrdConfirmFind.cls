/// 已经确认医嘱查询
Class web.DHCFOrdConfirmFind Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod GetOrdConfirmFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdConfirmFindExecute ]
{
	Quit ##class(web.DHCFBASICINFO).QueryClose(qHandle)
}

ClassMethod GetOrdConfirmFindExecute(ByRef qHandle As %Binary, PatNo As %String = "", RecLocId As %String = "", OrdItmh As %String = "", ConfirmDate As %Date = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCFOrdConfirmFind","GetOrdConfirmFind","","2","5541||1","2007-08-06")
	;s ^fhqtemp1=PatNo_"^"_RecLocId_"^"_OrdItmh_"^"_ConfirmDate
	Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s del="^",RetNum=0
 if PatNo'="" d
 .s Para=PatNo_del_RecLocId_del_ConfirmDate
 .s RetNum=##class(web.DHCFOrdGet).GetOrdConfirmByPatno(repid,Para)
 else  if OrdItmh'="" d
 .s Para=OrdItmh_del_RecLocId_del_ConfirmDate
 .s RetNum=##class(web.DHCFOrdGet).GetOrdConfirmByArcId(repid,Para)
 if RetNum>0 d
 .s i=0
 .f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
 ..s Data=$g(^CacheTempFHQ(repid,i))
 ..s Data=##class(web.DHCFBCM).StrToList(Data,del)
 ..s ^CacheTemp(repid,ind)=Data
 ..S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	Quit $$$OK
}

ClassMethod GetOrdConfirmFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdConfirmFindExecute ]
{
	s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
	Quit $$$OK
}

/// 对确认医嘱进行查询
Query GetOrdConfirmFind(PatNo As %String = "", RecLocId As %String = "", OrdItmh As %String = "", ConfirmDate As %Date = "") As %Query(ROWSPEC = "OrdId,ConfirmStatus,PatName,PatNo,OrdData,OrdDesc,OrdStatus,OrdQty,OrdUnit,AdmLoc,Doctor,OrdLoc,StUser,StDate,StTime:%String")
{
}

}
