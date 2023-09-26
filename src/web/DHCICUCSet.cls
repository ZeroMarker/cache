Import SQLUSER

Class web.DHCICUCSet Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindexeLevel() As %Query(ROWSPEC = "RowId:%String,ICUCL_Code:%String,ICUCL_Desc:%String") [ SqlProc ]
{
}

ClassMethod FindexeLevelExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^DHCICUC("Level",RowId))  q:RowId=""  d
	.s TICUCode=$p(^DHCICUC("Level",RowId),"^",1)
	.s TICUDesc=$p(^DHCICUC("Level",RowId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowId,TICUCode,TICUDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindexeLevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindexeLevelExecute ]
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

ClassMethod FindexeLevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindexeLevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepICUCLevel(Code As %String)
{
	s ICURowid=0
	s flag="N"
	f  s ICURowid=$o(^DHCICUC("Level",ICURowid)) q:(ICURowid="")  d
	.s RCode=$p(^DHCICUC("Level",ICURowid),"^",1)

	.i (RCode=Code) s flag="Y"
	q flag
}

ClassMethod InsertICUCLevel(Code As %String, Desc As %String)
{
	s ICURowid=0
	s flag="N"
	s i=0
	f  s ICURowid=$o(^DHCICUC("Level",ICURowid)) q:(ICURowid="")  d
	.s i=i+1
	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_ICUC_Level Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateICUCLevel(ICURowid As %String, Code As %String, Desc As %String)
{
	i (ICURowid'="")&&(Code'="")&&(Desc'="") d
	.k PLIST
	.s PLIST(2)=Code
	.s PLIST(3)=Desc
	.&SQL(update DHC_ICUC_Level Values :PLIST() where ICUCL_RowId=:ICURowid)
	Q 0
}

ClassMethod DeleteICUCLevel(ICURowid As %String)
{
	i ICURowid'="" d
	.k ^DHCICUC("Level",ICURowid)
	Q 0
}

///  ^DHCNurC("ICD",{NCICD_RowId}),{PAADM_DepCode_DR},"P",{NCP_ChildSub=1},"D",{NCPI_ChildSub})
///  ^DHCNurCare({NC_RowId},"P",{NCP_ChildSub},"D", {NCPI_ChildSub})
///  i ^DHCNurC("ICD",{NCICD_RowId},{PAADM_DepCode_DR}) m ^DHCNurCare({NC_RowId})=^DHCNurC("ICD",{NCICD_RowId},{PAADM_DepCode_DR})

}
