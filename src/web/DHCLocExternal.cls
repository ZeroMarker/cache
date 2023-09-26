Import SQLUser

Class web.DHCLocExternal Extends %RegisteredObject
{

ClassMethod LocExternalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocExternalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

// W ##class(%ResultSet).RunQuery("web.DHCLocExternal","LocExternal")

ClassMethod LocExternalExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1   
	s LExternalRowid=0
	f  s LExternalRowid=$o(^DHCLE(LExternalRowid))  q:LExternalRowid=""  d
	.s CTLocDr=$P(^DHCLE(LExternalRowid),"^",1)
	.s LELocDesc=$p(^DHCLE(LExternalRowid),"^",2)
	.s LEExtCode=$p(^DHCLE(LExternalRowid),"^",3)
	.s LEExtDesc=$p(^DHCLE(LExternalRowid),"^",4)
	.s TableLEActive=$p(^DHCLE(LExternalRowid),"^",5)
	.s:TableLEActive="Y" LEActive="是"
	.s:TableLEActive="N" LEActive="否"
	.d Build1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1      
	set Data=$lb(LExternalRowid,CTLocDr,LELocDesc,LEExtCode,LEExtDesc,LEActive,TableLEActive)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod LocExternalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocExternalExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

Query LocExternal() As %Query(ROWSPEC = "TLExternalRowid:%String,TCTLocDr:%String,TLELocDesc:%String,TLEExtCode:%String,TLEExtDesc:%String,TLEActive:%String,TableLEActive:%String")
{
}

// W ##class(%ResultSet).RunQuery("web.LocExternal","CTLoc")

ClassMethod CTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod CTLocExecute(ByRef qHandle As %Binary, CTLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s CTLocDesc=$$ALPHAUP^SSUTIL4(CTLocDesc)
	s CTLOCRowID="0"
	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d 
	.s CTDesc=$p(^CTLOC(CTLOCRowID),"^",2)
	.;w !,"CTLocDesc=",CTLocDesc
	.//q:((CTLocDesc'="")&(($$ALPHAUP^SSUTIL4(CTDesc))'[CTLocDesc))
	.Q:##class(web.DHCOPAdmReg).CheckLocDesc(CTLOCRowID,CTLocDesc)'=1 
	.s CTLocCode=$p(^CTLOC(CTLOCRowID),"^",1)
	.d Build1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1      
	set Data=$lb(CTLocCode,CTDesc,CTLOCRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocExecute ]
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

Query CTLoc(CTLocDesc As %String) As %Query(ROWSPEC = "CTLocCode:%String,CTDesc:%String,CTLOCRowID:%String")
{
}

/// w ##class(web.DHCLocExternal).AddtoRow("3^儿科^ceshi儿科1^儿科一单元测试^Y")
ClassMethod AddtoRow(InString) As %String
{
 s ^songsongDHCLocExternal("123")=InString
 s PLIST(2)=$p(InString,"^",1)
 s PLIST(3)=$p(InString,"^",2)
 s PLIST(4)=$p(InString,"^",3)
 s PLIST(5)=$p(InString,"^",4)
 s PLIST(6)=$p(InString,"^",5)
 &sql(insert into DHC_LocExternal values PLIST())    
 q:SQLCODE SQLCODE  ///如果SQLCODE为真 则退出并返回SQLCODE,==q SQLCODE
 q 0
}

/// w ##class(web.DHCLocExternal).DeleteRow("3")
ClassMethod DeleteRow(LERowid) As %String
{
 &sql(delete from DHC_LocExternal where LE_Rowid=:LERowid)
 q SQLCODE
}

}
