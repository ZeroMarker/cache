Import SQLUSER

Class web.DHCBPCBedGroup Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCBedGroup","FindBPCBedGroup")
Query FindBPCBedGroup(locId As %String = "", hospId As %String = "") As %Query(ROWSPEC = "tRowId:%String,tBPCBGCode:%String,tBPCBGDesc:%String,tBPCBGWardDr:%String,tBPCBGWard:%String,tBPCBGIsolatedDr:%String,tBPCBGIsolated:%String")
{
}

ClassMethod FindBPCBedGroupExecute(ByRef qHandle As %Binary, locId As %String = "", hospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("BedGroup",tRowId))  q:tRowId=""  d
	.s hospitalId=""
	.s DataAttributionDr=$lg(^DHCBPC("BedGroup",tRowId),5)
	.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	.q:((hospitalId'="")&(hospId'=hospitalId))
	.s tBPCBGCode=$lg(^DHCBPC("BedGroup",tRowId),1)
	.s tBPCBGDesc=$lg(^DHCBPC("BedGroup",tRowId),2)
	.s tBPCBGWardDr=$lg(^DHCBPC("BedGroup",tRowId),3)
	.;i tBPCBGWardDr'="" s tBPCBGWard=$p($g(^PAWARD(tBPCBGWardDr)),"^",2)
	.;e  s tBPCBGWard=""
	.i tBPCBGWardDr'="" s tBPCBGWard=$p($g(^CTLOC(tBPCBGWardDr)),"^",2)
	.e  s tBPCBGWard=""
	.q:(tBPCBGWardDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_tBPCBGWardDr_"^"))
	.s tBPCBGIsolatedDr=$lg(^DHCBPC("BedGroup",tRowId),4)
	.i tBPCBGIsolatedDr="1"  s tBPCBGIsolated="是"
	.e  s tBPCBGIsolated="否"
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tRowId,tBPCBGCode,tBPCBGDesc,tBPCBGWardDr,tBPCBGWard,tBPCBGIsolatedDr,tBPCBGIsolated)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCBedGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCBedGroupExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindBPCBedGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCBedGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCBPCBedGroup).InsertBPCBedGroup("2","1","C","1")
/// 插入数据
ClassMethod InsertBPCBedGroup(Code As %String, Desc As %String, BPCBGWardDr As %String, BPCBGIsolated As %String, hospId As %String = "")
{
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=BPCBGWardDr
	s PLIST(5)=BPCBGIsolated
	&SQL(insert into DHC_BPC_BedGroup Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	s DataRowId=%ROWID
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCBedGroup")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCBedGroup",DataRowId,hospId)
    }
	q SQLCODE
}

/// 更新
ClassMethod UpdateBPCBedGroup(BPCBGRowid As %String, Code As %String, Desc As %String, BPCBGWardDr As %String, BPCBGIsolated As %String, hospId As %String = "")
{
	q:(BPCBGRowid="") "" 
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=BPCBGWardDr
	s PLIST(5)=BPCBGIsolated
	&SQL(update DHC_BPC_BedGroup Values :PLIST() where BPCBG_RowId=:BPCBGRowid)
	s DataRowId=%ROWID
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCBedGroup")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCBedGroup",DataRowId,hospId)
    }
	Q SQLCODE
}

/// 删除
ClassMethod DeleteBPCBedGroup(BPCBGRowid As %String)
{
	i BPCBGRowid'="" d
	.&SQL(delete from DHC_BPC_BedGroup where BPCBG_RowId=:BPCBGRowid)
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCBedGroup")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCBedGroup",BPCBGRowid)
    }
	q SQLCODE
}

Query FindBPCBGIsolated() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBPCBGIsolatedExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="1",Desc="是"
	d OutputRow1
	s Id="0",Desc="否"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCBGIsolatedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCBGIsolatedExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindBPCBGIsolatedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCBGIsolatedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 打算不在使用 20150525

/*
Query GetBedGroupList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCBG_Code As Code,
	   BPCBG_Desc As Description,
	   BPCBG_Location_Dr As Location,
	   BPCBG_Isolated As Isolated 
	   FROM DHC_BPC_BedGroup
}
*/
/// d ##class(%ResultSet).RunQuery("web.DHCBPCBedGroup","GetBedGroupList")
Query GetBedGroupList(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,Location:%String,Isolated:%String")
{
}

ClassMethod GetBedGroupListExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("BedGroup",tRowId))  q:tRowId=""  d
	.s Id=tRowId
	.s Code=$lg(^DHCBPC("BedGroup",tRowId),1)
	.s Description=$lg(^DHCBPC("BedGroup",tRowId),2)
	.s Location=$lg(^DHCBPC("BedGroup",tRowId),3)	
	.q:(Location'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_Location_"^"))
	.s Isolated=$lg(^DHCBPC("BedGroup",tRowId),4)
	.i Isolated="1"  s Isolated="True"
	.e  s Isolated="False"	
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Id,Code,Description,Location,Isolated)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBedGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBedGroupListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetBedGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBedGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
