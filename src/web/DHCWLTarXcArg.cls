Class web.DHCWLTarXcArg Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarXcArg","GetGrpItem")
Query GetGrpItem() As %Query(ROWSPEC = "code,desc") [ SqlProc ]
{
}

ClassMethod GetGrpItemExecute(ByRef qHandle As %Binary) As %Status
{
 n (qHandle)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s grpId = 0 f  s grpId = $o(^DHCWL.CodeCfg.GroupD(grpId)) q:grpId=""  d
 .s code = $li(^DHCWL.CodeCfg.GroupD(grpId),2)
 .s desc = $li(^DHCWL.CodeCfg.GroupD(grpId),3)
 .d outputRow1
 Quit $$$OK
	
outputRow1
 s row=$listbuild(code,desc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetGrpItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGrpItemExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetGrpItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGrpItemExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// 获取科室类型为E的科室

// Others：d ##class(%ResultSet).RunQuery("web.DHCWLTarXcArg","GetELoc")

Query GetELoc() As %Query(ROWSPEC = "locId,locDesc") [ SqlProc ]
{
}

ClassMethod GetELocExecute(ByRef qHandle As %Binary) As %Status
{
 n (qHandle)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 s locId=0 f  s locId = $o(^CTLOC(locId)) q:locId=""  d
 .s locType = $p(^CTLOC(locId),"^",13)
 .q:locType'="E"
 .s locDesc = $$GetLocDesc^DHCWLAnalysisMethod(locId)
 .d outputRow2
 Quit $$$OK
	
outputRow2
 s row=$listbuild(locId,locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetELocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetELocExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetELocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetELocExecute ]
{
	n (qHandle,Row,AtEnd)
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
