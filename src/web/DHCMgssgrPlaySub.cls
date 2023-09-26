Class web.DHCMgssgrPlaySub Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query GetPlayOut() As %Query(ROWSPEC = "grpdes,title,pos,flag,rw,grp")
{
}

ClassMethod GetPlayOutExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//补贴调节记录
 	//s parr="^2009-04-13^2009-04-13"
 	s ssgp= %request.Get("GRPID")
    s rw=""  f  s rw=$O(^Nur.DHCMGSSGRPLAYOUTD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (grp,title,pos,flag,grpdes)=""
    s a=^Nur.DHCMGSSGRPLAYOUTD(rw)
    s grp=$List(a,2)
    i (ssgp'="")&(ssgp'=grp) q
    if grp'=""  s grpdes=$P(^SSU("SSGRP",grp),"^")
    s title=$List(a,3)
	s pos=$List(a,4)
	s flag=$List(a,5)
   
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(grpdes,title,pos,flag,rw,grp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPlayOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlayOutExecute ]
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

ClassMethod GetPlayOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlayOutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindPHCType() As %Query(ROWSPEC = "PHCType:%String,PHCTypeId:%String")
{
}

ClassMethod FindPHCTypeExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s PHCTypeId="1",PHCType="Y"
	d OutputRow2
	s PHCTypeId="2",PHCType="N"
	d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(PHCType,PHCTypeId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPHCTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPHCTypeExecute ]
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

ClassMethod FindPHCTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPHCTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query LookGrp(Grp As %String) As %Query(ROWSPEC = "grpDesc:%String,grpCode:%String")
{
}

ClassMethod LookGrpExecute(ByRef qHandle As %Binary, Grp As %String) As %Status
{
  	Set repid=$I(^CacheTemp)
 	s ind=1
    s rw=""  f  s rw=$O(^SSU("SSGRP",rw)) q:rw=""  d
    .s grpDesc=$p(^SSU("SSGRP",rw),"^",1)
   	.q:(grpDesc'[Grp)&(Grp'="")
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
  
OutRowtyp
	set Data=$lb(grpDesc,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookGrpExecute ]
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

ClassMethod LookGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetPlayOutSub() As %Query(ROWSPEC = "subname,rw")
{
}

ClassMethod GetPlayOutSubExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
    s rw=""  f  s rw=$O(^Nur.DHCMGSSGRPLAYOUTSUBD(rw)) q:rw=""  d
    .b
    .d out
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

out
    s (subname)=""
    s a=^Nur.DHCMGSSGRPLAYOUTSUBD(rw)
    s subname=$List(a,2) 
    d OutRowtyp
    q
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(subname,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPlayOutSubFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlayOutSubExecute ]
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

ClassMethod GetPlayOutSubClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlayOutSubExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//"20&DHCNURCCERRLISTGLHT"

//d ##class(web.DHCMgssgrPlaySub).GetLayoutItem("20","DHCNURCCERRLISTGLHT")

ClassMethod GetLayoutItem(grp, moudCode) As %String
{
  s moudCode=$ZConvert(moudCode,"U")
  s ^objcyf45=grp_"&"_moudCode
  s layitem=""
  s rw=""  f  s rw=$O(^Nur.DHCMGSSGRPLAYOUTI("grp"," "_grp,rw)) q:rw=""  d
  .s sub=""  f  s sub=$O(^Nur.DHCMGSSGRPLAYOUTSUBD(rw,sub)) q:sub=""  d
  ..s a=##class(Nur.DHCMGSSGRPLAYOUTSUB).%OpenId(rw_"||"_sub)
  ..b ;1
  ..s moudrw=a.laysubmoud
  ..s b=##class(Nur.DHCNurExtMoudle).%OpenId(moudrw)
  ..s mlcode=$ZConvert(b.mlcode,"U")
  ..b ;2
  ..q:mlcode'=moudCode
  ..s layitem=a.laysubitem
  s ret=""
  if layitem'=""
  {
    s l=$L(layitem)
    f i=1:1:l
    {
	  s itm=$P(layitem,"^",i)
	  if itm="" continue
      s a=##class(Nur.DHCNurExtMoudleSub).%OpenId(itm)
	  s code=a.subcode
	  s typ=a.subtyp
	  s ret=ret_code_"|"_typ_"^"
	}
	q ret
  }
}

}
