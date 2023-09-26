Class web.DHCMgNurPatlist Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetPatientListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s ^TMP("parr")=parr
    //s parr="2009-10-4^2009-12-25"
   // s parr=^TMP("parr")
 	//Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//
 	s typ=$P(parr,"^",1)
 	s loc=$P(parr,"^",2)
 	s stdate=$P(parr,"^",3)
 	s enddate=$P(parr,"^",4)
 	
 	s pward=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	
    s stdate=$ZDH(stdate,3),enddate=$ZDH(enddate,3)
    if typ="Disch"
    {
		f date=stdate:1:enddate
		{
			b
			s rw=""  f  s rw=$O(^PAADMi("DischDate",date,rw)) q:rw=""  d
		    .//s Typ=$p(^PAADM(rw),"^",2)
		    .s ward=$p(^PAADM(rw),"^",70)
		    .//s wardloc=$P(^PAWARD(ward),"^",70)
		    .q:(ward'=pward)&(pward'="")
		    .s patinfo=##class(web.DHCNurHdComm).PatInfo(rw)
		    .d outrow
		}
	}else{
	    s room=""  f  s room=$O(^PAADMi("CurrWard",pward,room)) q:room=""  d
	    .s rw=""  f  s rw=$O(^PAADMi("CurrWard",pward,room,rw)) q:rw=""  d
		..s patinfo=##class(web.DHCNurHdComm).PatInfo(rw)
		..d outrow
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
outrow
	set Data=$lb(patinfo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatientListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPatientListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatientListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

Query GetPatientList(parr As %String) As %Query(ROWSPEC = "aa")
{
}

}
