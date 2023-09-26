Import SQLUser

Class web.DHCArcositm Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindArcosbyitm(arcimrow, arcim As %String = "") As %Query(ROWSPEC = "acosdate:%String,acosname:%String,acostype:%String,acosrow:%String")
{
}

ClassMethod FindArcosbyitmExecute(ByRef qHandle As %Binary, arcimrow, arcim As %String = "") As %Status
{
 s repid=$I(^CacheTemp)	
 s ind=1
 s arcos=0 f  s arcos=$o(^ARCOS(arcos)) q:arcos=""  d
 .s datesub=0 f  s datesub=$o(^ARCOS(arcos,"DATE",datesub)) q:datesub=""  d
 ..s flag=0
 ..s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:arcossub=""  d
 ...s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
 ...q:(arcimrow'="")&&(arcimrow'=arcosarcitm)&&(arcim'="")
 ...s flag=1  //包含这个医嘱项
 ..i flag=1 d
 ...s acossubcat=$p(^ARCOS(arcos),"^",9) 
 ...s acostype=""
 ...if acossubcat'="" s acostype=$p(^ARC("IC",acossubcat),"^",2)
 ...s arcosname=$p(^ARCOS(arcos),"^",2)
 ...s acosdate=$p(^ARCOS(arcos,"DATE",datesub),"^",1)
 ...d OutputRow
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
    
OutputRow
	set Data=$lb(..%ZD(acosdate),arcosname,acostype,arcos_"||"_datesub)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindArcosbyitmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcosbyitmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcosbyitmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcosbyitmExecute ]
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

ClassMethod upacosarcim(arcimrow As %String, toarcimrow As %String) As %String
{
 q:(arcimrow="") -11
 q:(toarcimrow="") -12
 s ret=-2
 s arcos=0 f  s arcos=$o(^ARCOS(arcos)) q:arcos=""  d
 .s datesub=0 f  s datesub=$o(^ARCOS(arcos,"DATE",datesub)) q:datesub=""  d
 ..s flag=0
 ..s arcossub=0 f  s arcossub=$o(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub)) q:arcossub=""  d
 ...s arcosarcitm=$p(^ARCOS(arcos,"DATE",datesub,"ITM",arcossub),"^",1)
 ...i arcosarcitm=arcimrow d
 ....s rowid=arcos_"||"_datesub_"||"_arcossub
 ....&sql(update ARC_OrdSetDateItem set itm_arcim_dr=:toarcimrow where itm_rowid=:rowid)
 ....s ret=SQLCODE
 q ret
}

}
