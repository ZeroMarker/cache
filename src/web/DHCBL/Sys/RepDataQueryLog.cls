Class web.DHCBL.Sys.RepDataQueryLog Extends %RegisteredObject [ ProcedureBlock ]
{

Query DataQueryLog(RepName As %String, RepCond As %String, ssessionid As %String) As %Query(ROWSPEC = "Querylog:%String") [ SqlProc ]
{
}

ClassMethod DataQueryLogExecute(ByRef qHandle As %Binary, RepName As %String, RepCond As %String, ssessionid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	s ^TMPURL("web.DHCBL.Sys.RepDataQueryLog")=(RepName_","_ RepCond _","_ ssessionid )
	
	if ((RepName="")||(ssessionid="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	;
	s myobj = ##class(User.DHCRepDataQueryLog).%New()
	s myobj.BIRepName = RepName
	s myobj.BIRepCondition = RepCond
	s sessobj=##class(web.DHCBL.Sys.SessionShareInfo).GetShareSession(ssessionid)
	if ($IsObject(sessobj)){
		s myobj.QueryUserName = sessobj.USERNAME
		s myobj.QueryGroupDesc = sessobj.GROUPDESC
		s myobj.QueryUserIP = ""
		
		d sessobj.%Close()
	}
	d myobj.%Save()
	d myobj.%Close()
	k sessobj, myobj
	
	Do OutputRow
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb("1")
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables
	s (rtn)=""
	q
}

ClassMethod DataQueryLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataQueryLogExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DataQueryLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DataQueryLogExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}Else{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
