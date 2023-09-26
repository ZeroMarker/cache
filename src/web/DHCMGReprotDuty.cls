Class web.DHCMGReprotDuty Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod getReportDutyExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s parr="1304^2010-4-08^2010-4-08"
    s dep=$P(parr,"^",1)
    s stdate=$P(parr,"^",2)
    s edate=$P(parr,"^",3)
    s stdate=$ZDH(stdate,3)
    s edate=$ZDH(edate,3)
    f date=stdate:1:edate
    {
	    b
     s loc=""  f  s loc=$O(^User.DHCMGRpDutyI("DepDate",loc)) q:loc=""  d
     .q:($TR(loc," ","")'=dep)&(dep'="")
     .b
     .s rw=""  f  s rw=$O(^User.DHCMGRpDutyI("DepDate",loc,date,rw)) q:rw=""  d
     ..b
     ..d out
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
out
    s (DepDes,stdate,edate,Unit,num,UnitPrice,Sum,Flag,audUser,audDate,audTime)=""
    s a=^User.DHCMGRpDutyD(rw)
    s Dep=$List(a,2)
    if Dep'="" s DepDes=$P(^CTLOC(Dep),"^",2)
    s stdate=$List(a,6)
    if stdate'="" s stdate=$ZD(stdate,3)
    s edate=$List(a,3)
    if edate'=""  s edate=$ZD(edate,3)
    s feaprice=$List(a,13)
    s feriprice=$List(a,17)
    s feahours=$List(a,15)
    s ferihours=$List(a,16)
    s feasum=$List(a,14)
    s ferisum=$List(a,18)
    s sum=$List(a,19)
    s Flag=$List(a,4)
    s audUser=$List(a,7)
    s mem=$List(a,20)
    i audUser'="" 
    {
	    s parr=^User.DHCMGPersonsD(audUser)
        s audUser=$list(parr,21)

	}
    s audDate=$List(a,10)
    if audDate'="" s audDate=$ZD(audDate,3)
    s audTime=$List(a,11)
    if audTime'="" s audTime=$ZT(audTime)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(DepDes,stdate,edate,feahours,ferihours,sum,feasum,ferisum,feaprice,feriprice,Flag,audUser,audDate,audTime,rw,"",mem)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getReportDutyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getReportDutyExecute ]
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

ClassMethod getReportDutyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getReportDutyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getReportDuty(parr As %String) As %Query(ROWSPEC = "DepDes,stdate,edate,feahours,ferihours,sum,feasum,ferisum,feaprice,feriprice,Stat,audUser,audDate,audTime,rw,Sel:%Boolean,mem")
{
}

ClassMethod getRpSubDutyExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s par=$P(parr,"^",1)
    if par'=""{
    
	    s rw="" f  s rw=$O(^User.DHCMGRpDutyD(par,"ChildDHCMGRpDutySub",rw)) q:rw=""  d
	    .d out
    }else{
	    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (Person,days,num,Sum)=""
    s a=^User.DHCMGRpDutyD(par,"ChildDHCMGRpDutySub",rw)
    s per=$List(a,2)
    s parr=^User.DHCMGPersonsD(per)
    s Person=$list(parr,21)
    s feahours=$List(a,4)
    s ferihours=$List(a,6)
    s feasum=$List(a,3)
    s ferisum=$List(a,5)
    s Sum=$List(a,7)
    
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(Person,feahours,ferihours,feasum,ferisum,Sum,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getRpSubDutyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getRpSubDutyExecute ]
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

ClassMethod getRpSubDutyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getRpSubDutyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query getRpSubDuty(parr As %String) As %Query(ROWSPEC = "Person,feahours,ferihours,feasum,ferisum,Sum,rw")
{
}

}
