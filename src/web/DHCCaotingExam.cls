Class web.DHCCaotingExam Extends %RegisteredObject
{

ClassMethod GetDepositDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepositDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetDepositDetailExecute(ByRef qHandle As %Binary) As %Status
{
		Set repid=$I(^CacheTemp)
        If $g(ind)="" Set ind=0	
		s prtrowid=0
		f  s prtrowid=$o(^DHCSFPRINTDETAIL(prtrowid)) q:prtrowid=""  d
		.Q:$O(^DHCSFPRINTDETAIL(prtrowid))=""
		.s prtdate=$p(^DHCSFPRINTDETAIL(prtrowid),"^",2)
		
		.s prttime=$p(^DHCSFPRINTDETAIL(prtrowid),"^",3)
		.s adm=$p(^DHCSFPRINTDETAIL(prtrowid),"^",4)
		.s prtamount=$p(^DHCSFPRINTDETAIL(prtrowid),"^",6)
		.s prtpaymode=$p(^DHCSFPRINTDETAIL(prtrowid),"^",9)
		.s prtadduser=$p(^DHCSFPRINTDETAIL(prtrowid),"^",14)
		.q:adm=""
		.s papmi=""
		.i $d(^PAADM(adm)) s papmi=$p(^PAADM(adm),"^",1)
		.q:papmi=""
		.i $d(^PAPER(papmi,"ALL")) d
		..s papname=$p(^PAPER(papmi,"ALL"),"^",1)
		.i $d(^PAPER(papmi,"PAT",1)) d
		..s papno=$p(^PAPER(papmi,"PAT",1),"^",1)
		.;w $zd(prtdate,3)_"^"_$zt(prttime,3)_"^"_prtamount_"^"_prtpaymode_"^"_prtadduser_"^"_papname_"^"_papno_"^"_prtrowid,!
		
		.Set ind=ind+1
 
 .d OutputRow2
 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(prtdate,prttime,prtamount,prtpaymode,prtadduser,papname,papno)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDepositDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepositDetailExecute ]
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

Query GetDepositDetail() As %Query(ROWSPEC = "prtdate:%String,prttime:%String,prtamount:%String,prtpaymode:%String,prtadduser:%String,papname:%String,papno:%String")
{
}

}
