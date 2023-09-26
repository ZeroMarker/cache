Import SQLUSER

Class web.DHCANCInstrument Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindexeInstrument() As %Query(ROWSPEC = "RowId:%String,ANCINSTR_Code:%String,ANCINSTR_Desc:%String")
{
}

ClassMethod FindexeInstrumentExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCANC("Instrument",RowId))  q:RowId=""  d
	.s TOPRCode=$p(^DHCANC("Instrument",RowId),"^",1)
	.s TOPRDesc=$p(^DHCANC("Instrument",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TOPRCode,TOPRDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeInstrumentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeInstrumentExecute ]
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

ClassMethod FindexeInstrumentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeInstrumentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepOperInstrument(Code As %String)
{
	s OPRowid=0
	s flag="N"
	f  s OPRowid=$o(^DHCANC("Instrument",OPRowid)) q:(OPRowid="")  d
	.s RCode=$p(^DHCANC("Instrument",OPRowid),"^",1)

	.i (RCode=Code) s flag="Y"
	q flag
}

ClassMethod InsertOperInstrument(Code As %String, Desc As %String)
{
	s OPRowid=0
	s flag="N"
	s i=0
	f  s OPRowid=$o(^DHCANC("Instrument",OPRowid)) q:(OPRowid="")  d
	.s i=i+1
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_ANC_Instrument Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateOperInstrument(OPRRowid As %String, Code As %String, Desc As %String)
{
	i (OPRRowid'="")&&(Code'="")&&(Desc'="") d
	.k PLIST
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",1)=OPRCode
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",2)=OPRDesc
	.//s $p(^DHCANC("OPRoom",OPRRowid),"^",3)=LocId
	.s PLIST(2)=Code
	.s PLIST(3)=Desc
	.&SQL(update DHC_ANC_Instrument Values :PLIST() where ANCINSTR_RowId=:OPRRowid)
	Q 0
}

ClassMethod DeleteOperInstrument(OPRRowid As %String)
{
	i OPRRowid'="" d
	.k ^DHCANC("Instrument",OPRRowid)
	Q 0
}

/*    暂时无作用
Query ctloclookup(desc As %String) As %Query(ROWSPEC = "OPRCTLoc:%String,OPRLocID:%String")
{
}

ClassMethod ctloclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	i $g(desc)=""  d
	.s desc="%"
	e  d
	.s desc=$$ALPHAUP^SSUTIL4(desc)
	.s desc=desc_"%"
	&sql(declare ctloc cursor  for 
	select distinct ctloc_desc,ctloc_rowid
	              from SQLUser.ct_loc 
	              WHERE (UPPER(ctloc_desc) like :desc))
	&sql(open ctloc)
	f  &sql(fetch ctloc into :ctlocdesc,:ctlocrowid) q:SQLCODE  d
 	.Do OutputRow4	 	
 	&sql(close ctloc)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(ctlocdesc,ctlocrowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ctloclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ctloclookupExecute ]
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

ClassMethod ctloclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ctloclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}


}

*/
}
