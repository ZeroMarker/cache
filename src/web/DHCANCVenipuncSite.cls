Import SQLUSER

Class web.DHCANCVenipuncSite Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 3;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLROWID = "ID";

Parameter SQLCODE = "ANCVPS_Code";

Parameter SQLDESCRIPTION = "ANCVPS_Desc";

Query FindANCVenipuncSite() As %Query(ROWSPEC = "ancsuId:%String,ancsuCode:%String,ancsuDesc:%String")
{
}

ClassMethod FindANCVenipuncSiteExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ancsuId=0
	f  s ancsuId=$o(^DHCANC("VPSite",ancsuId)) q:ancsuId=""  d
	.s ancsuCode=$p(^DHCANC("VPSite",ancsuId),"^",1)
	.s ancsuDesc=$p(^DHCANC("VPSite",ancsuId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(ancsuId,ancsuCode,ancsuDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCVenipuncSiteFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCVenipuncSiteExecute ]
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

ClassMethod FindANCVenipuncSiteClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCVenipuncSiteExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod RepANCVpSite(ancsuCode As %String)
{
    ;w ##class(web.DHCANRoomEquipDetail).RepMoniDataItemDesc("31","脉搏")
    s flag="N"
	s ancsuId=0
	f  s ancsuId=$o(^DHCANC("VPSite",ancsuId)) q:ancsuId=""  d
	.s tancsuCode=$p(^DHCANC("VPSite",ancsuId),"^",1)
	.i tancsuCode=ancsuCode   s flag="Y"
	q flag
}

ClassMethod InsertANCVpSite(ancsuCode As %String, ancsuDesc As %String)
{
	k PList
	TSTART
	;w ##class(web.DHCANRoomEquipDetail).InsertMoniDataItem("31","18","Y","11")
	s PList(2)=ancsuCode
	s PList(3)=ancsuDesc
	&SQL(insert into SQLUSER.DHC_ANC_VenipuncSite Values :PList())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod UpdateANCVpSite(ancsuId As %String, ancsuCode As %String, ancsuDesc As %String)
{
 
   ;w ##class(web.DHCANCViewCat).UpdateANCViewCat("1","22","55","N","N","Y","","4")
	k PList 
	;&sql(select * into PList() from SQLUSER.DHC_ANC_MoniDataItem where ANCMDI_RowId=:Rowid)
    ;i SQLCODE TRollBack  q
	//s PList(1)="4"  //Rowid
	s PList(2)=ancsuCode
	s PList(3)=ancsuDesc
	&sql(update SQLUSER.DHC_ANC_VenipuncSite Values :PList() where ANCVPS_RowId=:ancsuId)
 q SQLCODE
}

ClassMethod DeleteANCVpSite(ancsuId As %String)
{
	i ancsuId'="" d
	.&SQL(delete from SQLUSER.DHC_ANC_VenipuncSite where ANCVPS_RowId=:ancsuId)
	q SQLCODE
}

}
