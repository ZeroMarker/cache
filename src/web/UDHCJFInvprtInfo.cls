Import SQLUser

Class web.UDHCJFInvprtInfo Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 11;

ClassMethod FindInvprtInfoExecute(ByRef qHandle As %Binary, Regno) As %Status
{
   
	Set repid=$I(^CacheTemp)
    s Regno=$g(Regno)
    i (Regno="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    Set ind=1
    s Regno=##class(web.UDHCJFBaseCommon).regnocon(Regno)
	s papmidr=""
	f  s papmidr=$o(^PAPERi("PAPMI_PatNo",Regno,papmidr))  q:(papmidr="")  d
	.s admdr=""
	.f  s admdr=$o(^PAPERdr(papmidr,"ADM","I",admdr))  q:(admdr="")  d
	..s TAdmRowid=admdr
	..s Tadmdate=$p(^PAADM(admdr),"^",6)
	..i Tadmdate'=""  s Tadmdate=$zd(Tadmdate,3)
	..s Tdischdate=$p(^PAADM(admdr),"^",17)
	..i Tdischdate'=""  s Tdischdate=$zd(Tdischdate,3)
	..s Tdeptdr=$p(^PAADM(admdr),"^",4)
	..s Tdeptdesc=""
	..i Tdeptdr'=""  d
	...i $d(^CTLOC(Tdeptdr))'=0  d
	....s Tdeptdesc=$p(^CTLOC(Tdeptdr),"^",2)
	....i $f(Tdeptdesc,"-")'=0  d
	.....s Tdeptdesc=$p(Tdeptdesc,"-",2)
	..s TWarddesc=""
	..s warddr=$p(^PAADM(admdr),"^",70)
	..i warddr'=""  d
	...i $d(^PAWARD(warddr))'=0  d
	....s TWarddesc=$p(^PAWARD(warddr),"^",2)
	....i $f(TWarddesc,"-")'=0  d
	.....s TWarddesc=$p(TWarddesc,"-",2)
	..s invprtdr="0",TQfFee=0
	..f  s invprtdr=$o(^DHCINVPRTZY(0,"ADM",admdr,invprtdr))  q:(invprtdr="")  d
	...s Tinvno=$p(^DHCINVPRTZY(invprtdr),"^",1)
	...s TPrtdate=$p(^DHCINVPRTZY(invprtdr),"^",2)
	...i TPrtdate'=""  s TPrtdate=$zd(TPrtdate,3)
	...s Tdeposit=$p(^DHCINVPRTZY(invprtdr),"^",22)
	...s Tpatfee=$p(^DHCINVPRTZY(invprtdr),"^",6)
	...s Tprtuser=$p(^DHCINVPRTZY(invprtdr),"^",7)
	...i Tprtuser'=""  d
	....i $d(^SSU("SSUSR",Tprtuser))'=0  d
	.....s Tprtuser=$p(^SSU("SSUSR",Tprtuser),"^",2)
	...s TPBRowid=$p(^DHCINVPRTZY(invprtdr),"^",5)
	...s TInvprtRowid=invprtdr
	...s arrcpid="0"
    ...f  s arrcpid=$o(^ARRCP("ARPBL",TPBRowid,arrcpid))  q:(arrcpid="")  d
    ....s arralid="0"
    ....f  s arralid=$o(^ARRCP("ARPBL",TPBRowid,arrcpid,arralid))  q:(arralid="")  d
    .....s depositdr=$p(^ARRCP(arrcpid,"RAL",arralid),"^",9)
    .....q:(depositdr'="")
    .....s paymid="0"
    .....f  s paymid=$o(^ARRCP(arrcpid,"PAYM",paymid))  q:(paymid="")  d
    ......s paymodedr=$p(^ARRCP(arrcpid,"PAYM",paymid),"^",1)
    ......q:(paymodedr="")
    ......q:($d(^CT("CTPM",paymodedr))=0)
    ......s paymodedesc=$p(^CT("CTPM",paymodedr),"^",2)
    ......i paymodedesc="欠费"  d
    .......s qffee=$p(^ARRCP(arrcpid,"PAYM",paymid),"^",3)
    .......s TQfFee=TQfFee+qffee
	...d OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	set Data=$lb(Tadmdate,Tdischdate,Tinvno,TPrtdate,Tdeposit,Tpatfee,TQfFee,Tprtuser,TPBRowid,TInvprtRowid,TAdmRowid,Tdeptdesc,TWarddesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindInvprtInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvprtInfoExecute ]
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

ClassMethod FindInvprtInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvprtInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindInvprtInfo(Regno) As %Query(ROWSPEC = "Tadmdate:%String,Tdischdate:%String,Tinvno:%String,TPrtdate:%String,Tdeposit:%String,Tpatfee:%String,TQfFee:%String,Tprtuser:%String,TPBRowid:%String,TInvprtRowid:%String,TAdmRowid:%String,Tdeptdesc:%String,TWarddesc:%String")
{
}

}
