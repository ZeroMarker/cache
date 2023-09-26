Class DHCWL.DocQueryData.DocDirectorCommon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      duh
/// CreatDate：    2016年2月18日 22:15:21
/// Description:： 获取科室描述
/// Table：      CTLOC
/// Input：       locId 科室ID
/// Output：     locDesc 科室描述
/// Return：      
/// Others：d ##class(%ResultSet).RunQuery("DHCWL.DocQueryData.DocDirectorCommon","GetLocOfHospital","1")
Query GetLocOfHospital(locId As %String) As %Query(ROWSPEC = "locDesc:%String") [ SqlProc ]
{
}

ClassMethod GetLocOfHospitalExecute(ByRef qHandle As %Binary, locId As %String) As %Status
{
	n (qHandle,locId)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:locId="" $$$OK
    s locDesc = $p($p(^CTLOC(locId),"^",2),"-",2)
    d outputRow1
	Quit $$$OK
	
outputRow1
 s row=$listbuild(locDesc)
 s ^CacheTemp(repid,ind)=row
 s ind=ind+1
 q
}

ClassMethod GetLocOfHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocOfHospitalExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocOfHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocOfHospitalExecute ]
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
