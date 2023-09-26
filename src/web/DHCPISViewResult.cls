Class web.DHCPISViewResult Extends %RegisteredObject
{

Query FindViewedBy(RequestID As %String, ComponentID As %String) As %Query(ROWSPEC = "UserDR:%String,AuditDate:%String,AuditTime:%String,Number:%String")
{
}

ClassMethod FindViewedByExecute(ByRef qHandle As %Binary, RequestID As %String, ComponentID As %String) As %Status
{
	Set RequestID=$Get(RequestID),ComponentID=$Get(ComponentID)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^TMP("FindViewedBy","para")=RequestID_","_ComponentID
	//^websys.LogI("ReferenceId"," 1403"," 50594||1113",6384)	=	"
	s id="" f  s id=$o(^websys.LogI("ReferenceId",$c(32)_ComponentID,$c(32)_RequestID,id)) q:id=""  d
	.s str=$g(^websys.LogD(id))
	.s UserDr=$li(str,5)
	.s AudDate=$li(str,1)
	.//i $l(AudDate) s AudDate=$zd(AudDate,3)
	.s AudTime=$li(str,2)
	.//i $l(AudTime) s AudTime=$zt(AudTime)
	.i $l(UserDr),$d(^SSU("SSUSR",UserDr)) s Number=$p(^SSU("SSUSR",UserDr),"^",1)

	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(UserDr,AudDate,AudTime,Number)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
  q
}

ClassMethod FindViewedByClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewedByExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindViewedByFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewedByExecute ]
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
