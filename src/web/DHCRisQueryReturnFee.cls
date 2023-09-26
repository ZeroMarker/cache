Import SQLUser

/// websys.Abstract
Class web.DHCRisQueryReturnFee Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 60;

Query QueryReturnFee(Locrowid As %String, StDate As %String, EdDate As %String) As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TitmName:%String,Texecutedoc:%String,Tstrdate:%String,Tstrtime:%String,Tcost:%String,reason:%String")
{
}

ClassMethod QueryReturnFeeExecute(ByRef qHandle As %Binary, Locrowid As %String, StDate As %String, EdDate As %String) As %Status
{
   if Locrowid="" s Locrowid=%session.Get("LOGON.CTLOCID")
   if StDate="" s StDate=+$h
   if EdDate="" s EdDate=+$h
    
    s Totalprice=0
    s ^test=Locrowid_"^"_StDate_"^"_StDate
    If $g(ind)="" Set ind=1

	Set repid=$I(^CacheTemp)
	for date=StDate:1:EdDate d
	.s rowid="" f  s rowid=$o(^DHCRBRFi("LOC-DATE",Locrowid,date,rowid)) q:(rowid="")  d
	..s RegNo="",Name="",itmName="",executedoc="",strdate="",strtime="",cost="",reason=""
	..s info=^DHCRBRF("Record",rowid)
	..s oeorddr=$p(info,"^",1)
	..q:(oeorddr="")&(oeorddr=$c(0))
	..s ordrowid=$p(oeorddr,"||",1)
	..s itemsub=$p(oeorddr,"||",2)
	..q:itemsub=""
	..s arcimdr=$p($g(^OEORD(ordrowid,"I",itemsub,1)),"^",2)
	..s script=$p(arcimdr,"||",1),version=$p(arcimdr,"||",2)
	..s itmName=$p(^ARCIM(script,version,1),"^",2)
	..s paadmdr=$p(^OEORD(ordrowid),"^",1)
	..s papatmasmdr=$p(^PAADM(paadmdr),"^",1)   
	..s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1)   
    ..s Name=$p(^PAPER(papatmasmdr,"ALL"),"^",1)
   	..s ssurdr=$p(info,"^",3)
	..i ssurdr'="" s executedoc=$p(^SSU("SSUSR",ssurdr),"^",2)  
	..s stddate=$p(info,"^",4)
	..s strdate=##class(websys.Conversions).DateLogicalToHtml(stddate) ;$zd(stddate,3)
	..s sttime=$p(info,"^",5)
	..s strtime=$zt(sttime,1)
	..s cost=$p(info,"^",8)
	..i cost="" s cost=0
	..s Totalprice=Totalprice+cost
	..s reasondr=$p(info,"^",6)
	..i reasondr'="" s reason=$p(^DHCRBRR("Reason",0,reasondr),"^",1)
	..d Out 
    if Totalprice'=0  d
	.set Data=$lb("总价格","","","","","",Totalprice,"")
 	.Set ^CacheTemp(repid,ind)=Data
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Out
	set Data=$lb(RegNo,Name,itmName,$g(executedoc),strdate,strtime,cost,$g(reason))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryReturnFeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReturnFeeExecute ]
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

ClassMethod QueryReturnFeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReturnFeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
