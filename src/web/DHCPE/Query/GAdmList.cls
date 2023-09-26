/// Created by Robert 2006/5/29
/// Description: QueryGAdm
/// test: d ##class(%ResultSet).RunQuery("web.DHCPE.Query.GAdmList", "query","","","^^ARRIVED,REGISTERED,CHARGED")
Class web.DHCPE.Query.GAdmList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Parameter BUILD = 1;

/// RAdmId:%String,
Query query(GrpName As %String, AdmDate As %String, StatusList As %String) As %Query(ROWSPEC = "GAdmId:%String,GrpName:%String,AdmDate:%String,Status:%String")
{
}

ClassMethod queryExecute(ByRef qHandle As %Binary, GrpName As %String, AdmDate As %String, StatusList As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	
	s GrpName=$g(GrpName),  AdmDate=$g(AdmDate), StatusList=$g(StatusList)
	i ((GrpName="")&(AdmDate="")&(StatusList="")){
		Set qHandle=$lb(0,repid,0)
		q $$$OK
	}
	s ^Bob("Temp",$zn)=GrpName_"^"_AdmDate_"^"_StatusList
	s GAdmId="0"
	f  s GAdmId=$o(^DHCPEGADM(GAdmId)) q:GAdmId=""  d 
		.s myStr=^DHCPEGADM(GAdmId)
		.s myStatus=$p(myStr,"^",8)
		.q:(StatusList'[myStatus)
		.s myGrpId=$p(myStr,"^",1)
		.s myGrpName=$p($g(^DHCPEGBI(myGrpId)),"^",2)
		.q:(myGrpName'[GrpName)
		.q:((AdmDate'="")&&(AdmDate'=$p(myStr,"^",2)))
 		.s myAdmDate=$ZD($p(myStr,"^",2),3)
		.do OutputRow1	
		.b //afert do
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	// "GAdmId:%String,GrpName:%String,AdmDate:%String,Status:%String"
	
OutputRow1
	set Data=$lb(GAdmId,myGrpName,myAdmDate,myStatus)  //todo: Modify
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod queryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = queryExecute ]
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

ClassMethod queryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = queryFetch ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
