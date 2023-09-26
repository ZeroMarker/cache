Class web.UDHCJFcpatdetail Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

ClassMethod findbilldetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findbilldetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod findbilldetailExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, admreasonid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	set stdate=$g(stdate)
	set enddate=$g(enddate)
	if stdate=""  s stdate=$h
	for i=stdate:i:enddate d
	.s rowid=""
	.f  s rowid=$o(^DHCINVPRTZY(0,"DATE",i,rowid)) q:rowid=""  d
	..s Tccompany=""
	..s adm=$p($g(^DHCINVPRTZY(rowid)),"^",4)
	..s adm=$P(adm,$c(1))
	..i adm'="" d
	...s papmi=$p($g(^PAADM(adm)),"^",1)
	...s papmi=$P(papmi,$c(1))
	...i papmi'="" d
	....s Tname=$p($g(^PAPER(papmi,"ALL")),"^",1)
	...s Tregno=$p($g(^PAADM(adm)),"^",81)
	...s admreason=$p($g(^PAADM(adm,1)),"^",7)
	...s admreason=$P(admreason,$c(1))
	..q:((admreasonid'=admreason)&(admreasonid'=""))
	...i admreason'="" d
	....s Tccompany=$p($g(^PAC("ADMREA",admreason)),"^",2)
	..s pbid=$p($g(^DHCINVPRTZY(rowid)),"^",5)
	..s pbid=$P(pbid,$c(1))
	..i pbid'="" d
	...s Tamount=$p($g(^DHCPB(pbid)),"^",8)
	...s Tpatshare=$p($g(^DHCPB(pbid)),"^",12)
	...s Tcompanyp=$p($g(^DHCPB(pbid)),"^",11)
	..s Tprint=""
	..d outputrow 
 	 s ^tmp("ptnum","ALL")=ind
 	 s qHandle=$lb(0,repid,0)
  quit $$$OK
outputrow
	set Data=$lb(Tname,Tregno,Tccompany,Tamount,Tpatshare,Tcompanyp)
 	Set ^CacheTemp(repid,ind)=Data
 	set ^tmp("cpact",ind)=Tname_"^"_Tregno_"^"_Tccompany_"^"_Tamount_"^"_Tpatshare_"^"_Tcompanyp
 	Set ind=ind+1
	quit
}

ClassMethod findbilldetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findbilldetailExecute ]
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

Query findbilldetail(stdate As %String, enddate As %String, admreasonid As %String) As %Query(ROWSPEC = "Tname:%String,Tregno:%String,Tccompany:%String,Tamount:%String,Tpatshare:%String,Tcompanyp:%String,Tprint:%String")
{
}

ClassMethod getnum(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
  s num=$g(^tmp("ptnum","ALL")) 
   q num
}

ClassMethod getdata(itmjs As %Library.String = "", itmjsex As %Library.String = "", i)
{
  s str=$g(^tmp("cpact",i))
   q str
}

ClassMethod gettoday(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
  s date=$zd($h,3)
   q date
}

}
