Class web.DHCMGNurAnt Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetProValExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
    s pro=parr
    if pro="" Set qHandle=$lb(0,repid,0)	Quit $$$OK

    s rw=""  f  s rw=$O(^User.DHCMGTechArcProValI("pro",pro,rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (cat,des,flag)=""
    s a=^User.DHCMGTechArcProValD(rw)
    s catdr=$List(a,2)
    s des=$List(a,3)
    s a=^User.DHCMGTechArcProD(catdr)
    s cat=$list(a,2)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(cat,des,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetProValFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProValExecute ]
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

ClassMethod GetProValClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProValExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetProVal(parr As %String) As %Query(ROWSPEC = "cat,des,rw")
{
}

ClassMethod GetTechProExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"

    s rw=""  f  s rw=$O(^User.DHCMGTechArcProD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (cat,des,flag)=""
    s a=^User.DHCMGTechArcProD(rw)
    s cat=$List(a,2)
    s des=$List(a,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(cat,des,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTechProFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTechProExecute ]
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

ClassMethod GetTechProClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTechProExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetTechPro(parr As %String) As %Query(ROWSPEC = "cat,des,rw")
{
}

ClassMethod GetAntDataExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	s parr="2009-05-13^2009-06-13^"
 	s loc=$P(parr,"^",3)
 	s stdate=$P(parr,"^",1)
 	s edate=$P(parr,"^",2)
 	s stdate=$ZDH(stdate,3)
 	s edate=$ZDH(edate,3)
 	
 	//if dep=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    for date=stdate:1:edate
    {
	  s dep=""  f  s dep=$O(^User.DHCMGNurAntDataI("DepDate",date,dep)) q:dep=""  d
      .q:(dep'=loc)&(loc'="")
      .s rw=""  f  s rw=$O(^User.DHCMGNurAntDataI("DepDate",date,dep,rw)) q:rw=""  d
      ..b
      ..d out

	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,person,stdate,endate)=""
    s a=^User.DHCMGNurAntDataD(rw)
    s depdr=$List(a,2)
    s nur=$List(a,6)
    //if (nur'=per)&(per'="") q
    s endate=$ZD($List(a,3),3)
    s stdate=$ZD($List(a,7),3)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s parr=^User.DHCMGPersonsD(nur)
    s person=$list(parr,21)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,person,stdate,endate,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAntDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntDataExecute ]
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

ClassMethod GetAntDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAntData(parr As %String) As %Query(ROWSPEC = "depdes,person,stdate,endate,rw")
{
}

ClassMethod GetAntCatExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"

    s rw=""  f  s rw=$O(^User.DHCMGNurAntCatD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (cat,des,flag)=""
    s a=^User.DHCMGNurAntCatD(rw)
    s cat=$List(a,5)
    s des=$List(a,2)
    s flag=$List(a,3)
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(cat,des,flag,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAntCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntCatExecute ]
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

ClassMethod GetAntCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAntCat(parr As %String) As %Query(ROWSPEC = "cat,des,preflag,rw")
{
}

ClassMethod GetAntItmExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s loc=$P(parr,"^")
 	s Cat=$P(parr,"^",2)
 	//if per=""  Set qHandle=$lb(0,repid,0) Quit $$$OK

    s Cat=""  f  s Cat=$O(^User.DHCMGNurAntItmI("DepCat"," "_loc,Cat)) q:Cat=""  d
    .s rw=""  f  s rw=$O(^User.DHCMGNurAntItmI("DepCat"," "_loc,Cat,rw)) q:rw=""  d
    ..b
    ..d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (depdes,typ,itm)=""
    s a=^User.DHCMGNurAntItmD(rw)
    s depdr=$List(a,3)
    s typdr=$List(a,2)
    if (typdr'=Cat)&(Cat'="") q
    s itm=$List(a,4)
    if depdr'="" s depdes=$P(^CTLOC(depdr),"^",2)
    s a=^User.DHCMGNurAntCatD(typdr)
    s typ=$List(a,5)

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(depdes,typ,itm,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAntItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntItmExecute ]
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

ClassMethod GetAntItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntItmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetAntItm(parr As %String) As %Query(ROWSPEC = "depdes,cat,Itm,rw")
{
}

ClassMethod GetDepAnt(loc As %String, id As %String) As %String
{
 //992
    
    if (id'="")
    {
	  s chl=""  f  s chl=$O(^User.DHCMGNurAntDataSubD(id,chl)) q:chl=""  d
	  .s a=^User.DHCMGNurAntDataSubD(id,chl)
	  .s afternum=$List(a,2)
	  .s prevnum=$List(a,3)
	  .s mem=$List(a,4)
	  .s subitm=$List(a,3)
	  .s m(subitm)=prevnum_$C(5)_afternum_$C(5)_mem
	}
    s retdata="",rowid=""
    s Cat=""  f  s Cat=$O(^User.DHCMGNurAntItmI("DepCat"," "_loc,Cat)) q:Cat=""  d
    .s a=^User.DHCMGNurAntCatD(Cat)
    .s flag=$List(a,3)
    .s des=$List(a,5)
    .s ret=""
    .s ret=des_"^"_flag
    .s rw=""  f  s rw=$O(^User.DHCMGNurAntItmI("DepCat"," "_loc,Cat,rw)) q:rw=""  d
    .. s a=^User.DHCMGNurAntItmD(rw)
    .. q:'$D(m(rw))&(id'="")
    .. s itm=$List(a,4)
    .. if id'="" s ret=ret_$C(1)_itm_$C(5)_m(rw)
    .. e  s ret=ret_$C(1)_itm
    .. s rowid=rowid_rw_"^"
    .s retdata=retdata_ret_$C(2)
   q rowid_$C(3)_retdata
}

}
