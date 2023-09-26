Import SQLUser

Class web.DHCWMRCommon.Hospital Extends %Library.RegisteredObject [ Not ProcedureBlock ]
{

Parameter BUILD = 4;

ClassMethod QryHospitalDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryHospitalDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryHospitalDicExecute(ByRef qHandle As %Binary, argDesc As %String) As %Status
{
    s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	;^CT("HOSP",{HOSP_RowId})
	s Rowid=0
	f  s Rowid=$o(^CT("HOSP",Rowid)) q:Rowid=""  d
	.s Code=$p($g(^CT("HOSP",Rowid)),"^",1)
	.s Desc=$p($g(^CT("HOSP",Rowid)),"^",2)
	.q:(argDesc'="")&&(Desc'[argDesc)
	.s Data=$lb(Rowid,Code,Desc)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	
	q $$$OK
}

ClassMethod QryHospitalDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryHospitalDicExecute ]
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

Query QryHospitalDic(argDesc As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

}
