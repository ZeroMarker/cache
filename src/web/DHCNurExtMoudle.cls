Class web.DHCNurExtMoudle Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetMoudle(rowid As %String) As %Query(ROWSPEC = "code,desc,rw")
{
}

ClassMethod GetMoudleExecute(ByRef qHandle As %Binary, rowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
    s rw=""  f  s rw=$O(^Nur.DHCNurExtMoudleD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (code,desc)=""
    s a=^Nur.DHCNurExtMoudleD(rw)
    s code=$List(a,2)
    s desc=$List(a,3) 
    //s submits=$$CheckLoc(rowid,rw)

    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(code,desc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMoudleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoudleExecute ]
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

ClassMethod GetMoudleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoudleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMoudSubExecute(ByRef qHandle As %Binary, rowid As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if rowid=""   Set qHandle=$lb(0,repid,0) Quit $$$OK
 	//s rowid=""
 	//f  s rowid=$O(^Nur.DHCNurExtMoudleSubD(rowid)) q:rowid=""  d
    s rw=""  f  s rw=$O(^Nur.DHCNurExtMoudleSubD(rowid,rw)) q:rw=""  d
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (mname,mcode,mtyp)=""
    s a=^Nur.DHCNurExtMoudleSubD(rowid,rw)
    s mname=$List(a,3)
    s mcode=$List(a,2)
    s mtyp=$list(a,4)
    s rd=rowid_"||"_rw 
   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(mname,mcode,mtyp,rd)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMoudSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMoudSubExecute ]
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

ClassMethod GetMoudSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMoudSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMoudSub(rowid As %String = "") As %Query(ROWSPEC = "mname,mcode,mtyp,rd")
{
}

ClassMethod DHCNurSub(id) As %String
{
	s ret=""
	s rw=""  f  s rw=$O(^Nur.DHCMGSSGRPLAYOUTSUBD(rw)) q:rw=""  d
	.q:rw'=id
	.s subid="" f  s subid=$O(^Nur.DHCMGSSGRPLAYOUTSUBD(rw,subid)) q:subid=""  d
	..i ret="" s ret=$listget(^Nur.DHCMGSSGRPLAYOUTSUBD(rw,subid),4)
	..e  s ret=ret_"^"_$listget(^Nur.DHCMGSSGRPLAYOUTSUBD(rw,subid),4)
	q ret
}

//}

ClassMethod DHCNurGetSubmits(moudid, titlid) As %String
{
	
	q:(moudid="")!(titlid="") ""
	s sub=$O(^Nur.DHCMGSSGRPLAYOUTSUBI("submoud"," "_moudid,titlid,""))
    s ret=""
    if sub'=""
    {
	  s a=##class(Nur.DHCMGSSGRPLAYOUTSUB).%OpenId(titlid_"||"_sub)
	  s ret= a.laysubitem
    }
	q ret
}

}
