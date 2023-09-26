Import SQLUSER

Class web.DHCBPCBed Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCBed","FindBPCBed")
Query FindBPCBed(hospId As %String = "") As %Query(ROWSPEC = "tRowId:%String,tBPCBCode:%String,tBPCBDesc:%String,tBPCBBPCBedGroupDr:%String,tBPCBBPCBedGroup:%String,tBPCBStatus:%String,tBPCBStatusD::%String,tBPCBType:%String,tBPCBIsFiltrationDr:%String,tBPCBIsFiltration:%String")
{
}

ClassMethod FindBPCBedExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("Bed",tRowId))  q:tRowId=""  d
	.s hospitalId=""
	.s DataAttributionDr=$lg(^DHCBPC("Bed",tRowId),12)
	.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	.q:((hospitalId'="")&(hospId'=hospitalId))
	.s tBPCBCode=$lg(^DHCBPC("Bed",tRowId),1)
	.s tBPCBDesc=$lg(^DHCBPC("Bed",tRowId),2)
	.s tBPCBBPCBedGroupDr=$lg(^DHCBPC("Bed",tRowId),3)
	.q:'$d(^DHCBPC("BedGroup",+tBPCBBPCBedGroupDr))
	.i tBPCBBPCBedGroupDr'="" s tBPCBBPCBedGroup=$lg(^DHCBPC("BedGroup",+tBPCBBPCBedGroupDr),2)
	.s tBPCBStatus=$lg(^DHCBPC("Bed",tRowId),4)
	.s:tBPCBStatus="I" tBPCBStatusD="空闲"
	.s:tBPCBStatus="O" tBPCBStatusD="占用"	
	.s tBPCBType=$lg(^DHCBPC("Bed",tRowId),5)
	.s tBPCBIsFiltrationDr=$lg(^DHCBPC("Bed",tRowId),11)
	.i tBPCBIsFiltrationDr="1"  s tBPCBIsFiltration="是"
	.e  s tBPCBIsFiltration="否"
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(tRowId,tBPCBCode,tBPCBDesc,tBPCBBPCBedGroupDr,tBPCBBPCBedGroup,tBPCBStatus,tBPCBStatusD,tBPCBType,tBPCBIsFiltrationDr,tBPCBIsFiltration)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCBedExecute ]
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

ClassMethod FindBPCBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 插入数据
ClassMethod InsertBPCBed(Code As %String, Desc As %String, BPCBedGroup As %String, Status As %String, Type As %String, IsFiltration As %String, hospId As %String = "")
{
	K PLIST
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=BPCBedGroup
	s PLIST(5)=Status
	s PLIST(6)=Type
	s PLIST(12)=IsFiltration
	&SQL(insert into DHC_BPC_Bed Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	s DataRowId=%ROWID
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCBed")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCBed",DataRowId,hospId)
    }
	q SQLCODE
}

/// 更新
ClassMethod UpdateBPCBed(BPCBRowid As %String, Code As %String, Desc As %String, BPCBedGroup As %String, Status As %String, Type As %String, IsFiltration As %String, hospId As %String = "")
{
	q:(BPCBRowid="") "" 
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=BPCBedGroup
	s PLIST(5)=Status
	s PLIST(6)=Type
	s PLIST(12)=IsFiltration
	&SQL(update DHC_BPC_Bed Values :PLIST() where BPCB_RowId=:BPCBRowid)
	s DataRowId=%ROWID
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCBed")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCBed",DataRowId,hospId)
    }
	Q SQLCODE
}

/// 删除
ClassMethod DeleteBPCBed(BPCBRowid As %String)
{
	i BPCBRowid'="" d
	.&SQL(delete from DHC_BPC_Bed where BPCB_RowId=:BPCBRowid)
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCBed")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCBed",BPCBRowid)
    }
	q SQLCODE
}

Query FindBPCBStatus() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBPCBStatusExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Id="I",Desc="空闲"
	d OutputRow1
	s Id="O",Desc="占用"
	d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	set Data=$lb(Desc,Id)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBPCBStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCBStatusExecute ]
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

ClassMethod FindBPCBStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCBStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindBedGroup(hospId As %String = "") As %Query(ROWSPEC = "BedCode:%String,BedDesc:%String,BedRowId:%String")
{
}

ClassMethod FindBedGroupExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s BedRowId=0
	f  s BedRowId=$o(^DHCBPC("BedGroup",BedRowId))  q:BedRowId=""  d
	.s hospitalId=""
	.s DataAttributionDr=$lg(^DHCBPC("BedGroup",BedRowId),5)
	.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	.q:((hospitalId'="")&(hospId'="")&(hospId'=hospitalId))
	.s BedCode=$lg(^DHCBPC("BedGroup",BedRowId),1)
    .s BedDesc=$lg(^DHCBPC("BedGroup",BedRowId),2)
	.d OutputRow7
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(BedCode,BedDesc,BedRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedGroupExecute ]
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

ClassMethod FindBedGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*Query GetBedList() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID As Id,
	   BPCB_Code As Code,
	   BPCB_Desc As Description,
	   BPCB_BPCBedGroup_Dr As BedGroupId,
	   BPCB_Status As Status,
	   BPCB_Type As BedType 
       FROM DHC_BPC_Bed
}*/
Query GetBedList(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,BedGroupId:%String,Status:%String,BedType:%String,BedGroupDesc:%String,StatusDesc:%String")
{
}

ClassMethod GetBedListExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	s tRowId=0
	f  s tRowId=$o(^DHCBPC("Bed",tRowId))  q:tRowId=""  d
	.s Id=tRowId
	.s Code=$lg(^DHCBPC("Bed",tRowId),1)
	.s Description=$lg(^DHCBPC("Bed",tRowId),2)
	.s BedGroupId=$lg(^DHCBPC("Bed",tRowId),3)
	.q:'$d(^DHCBPC("BedGroup",+BedGroupId))
	.s BedGroupDesc=$lg(^DHCBPC("BedGroup",+BedGroupId),2)
	.s Location=$lg(^DHCBPC("BedGroup",BedGroupId),3)
	.q:(Location'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_Location_"^"))
	.s Status=$lg(^DHCBPC("Bed",tRowId),4)
	.s:Status="I" StatusDesc="空闲"
	.s:Status="O" StatusDesc="占用"	
	.s BedType=$lg(^DHCBPC("Bed",tRowId),5)		
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Id,Code,Description,BedGroupId,Status,BedType,BedGroupDesc,StatusDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBedListExecute ]
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

ClassMethod GetBedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBedListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 支持血滤
Query FindBPCBIsFiltration() As %Query(ROWSPEC = "Desc:%String,Id:%String")
{
}

ClassMethod FindBPCBIsFiltrationExecute(ByRef qHandle As %Binary) As %Status
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

ClassMethod FindBPCBIsFiltrationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPCBIsFiltrationExecute ]
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

ClassMethod FindBPCBIsFiltrationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPCBIsFiltrationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCBed","GetAllBedList","194")
Query GetAllBedList(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,BedGroupId:%String,Status:%String,BedType:%String,radio:%String")
{
}

ClassMethod GetAllBedListExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
	f i=1:1:3 {
	s Id=0
	f  s Id=$o(^DHCBPC("Bed",Id))  q:Id=""  d
	.s Code=$lg(^DHCBPC("Bed",Id),1)
    .s Description=$lg(^DHCBPC("Bed",Id),2)
    .s BedGroupId=$lg(^DHCBPC("Bed",Id),3)
    .q:'$d(^DHCBPC("BedGroup",+BedGroupId))
    .s Location=$lg(^DHCBPC("BedGroup",BedGroupId),3)
	.q:(Location'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_Location_"^"))
    .s Status=$lg(^DHCBPC("Bed",Id),4)
    .s BedType=$lg(^DHCBPC("Bed",Id),5)
    .i i=1 s radio="AM"
    .e  i i=2 s radio="PM"
    .e  s radio="Evening"
	.d OutputRow8
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(Id,Code,Description,BedGroupId,Status,BedType,radio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAllBedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedGroupExecute ]
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

}
