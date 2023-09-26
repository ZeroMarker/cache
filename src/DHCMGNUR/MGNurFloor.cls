Class DHCMGNUR.MGNurFloor Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property HsDr As %Integer;

Property LocTyp As %String(TRUNCATE = 1);

Property WardLoc As %Integer;

Property SortPos As %Integer;

Index Typ On (HsDr, LocTyp, WardLoc);

ClassMethod delpos(hsdr, typ, loc) As %String
{
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	
	s count=0
	s rw=""  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,loc,rw))
	b //loc
 	if rw="" q 0
	 s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
	 s crw=rw
	 s oldpos=a.SortPos
	 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
		..s st=a.SortPos
		..if ((st>oldpos)) d
		...s a.SortPos=st-1
		...d a.%Save()
   d ##class(DHCMGNUR.MGNurFloor).%DeleteId(crw)
   q 0
}

ClassMethod getselloc(hsdr, typ)
{
 //s r=##class(DHCMGNUR.MGNurFloor).getselloc
  	 s ret=""
  	 s typ=$TR($ZConvert(typ,"U")," ","")
  	 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
  	 .s ret=ret_CtLocDr_"^"
  	 q ret
}

ClassMethod SavePos(hsdr, typ, loc, sort) As %String
{
 //s r=##class(DHCMGNUR.MGNurFloor).SavePos()
    s ^TMP("loc")=$LB(hsdr,typ,loc,sort)
  	s typ=$TR($ZConvert(typ,"U")," ","")
  	
	s count=0
	s rw=""  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,loc,rw))
	b //loc
 	if rw="" q 0
	 s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
	 s crw=rw
	 s oldpos=a.SortPos
	 b //
    if (oldpos>sort) 
    { //加1 '<sort  && <oldpos
        b  // //值变小，往前移
	   s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
		..s st=a.SortPos
		..//w !,st,",",sort,",",oldpos
		..if ((st'<sort)&(st<oldpos)) d
		...b //sort
		...s a.SortPos=st+1
		...d a.%Save()

	}
    if (oldpos<sort)  //值变大，往后移
    { //减1 >oldpos && '>sort
	   s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr)) q:CtLocDr=""  d
	    .s rw="" f  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",hsdr," "_typ,CtLocDr,rw)) q:rw=""  d
		..s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
		..s st=a.SortPos
		..//w !,st,",",sort,",",oldpos
		..if ((st'>sort)&(st>oldpos)) d
		...s a.SortPos=st-1
		...d a.%Save()

	}
	 b ///ggg
	 s a=##class(DHCMGNUR.MGNurFloor).%OpenId(crw)
	 s a.SortPos=sort
	 d a.%Save()

	q 0
}

ClassMethod Save(typ, locstr) As %String
{
	s l=$L(locstr,"^")
	s HsDr=1
	s typ=$TR($ZConvert(typ,"U")," ","")
	s count=0
	 s loc="" f  s loc=$O(^DHCMGNUR.MGNurFloorI("Typ",HsDr," "_typ,loc)) q:loc=""  d
	 .s count=count+1
	for i=1:1:l
	{
	  s loc=$P(locstr,"^",i)
	  if loc="" continue
	  if '$D(^DHCMGNUR.MGNurFloorI("Typ",HsDr," "_typ,loc))
	  {
	     s a=##class(DHCMGNUR.MGNurFloor).%New()
	     s a.HsDr=HsDr
	     s a.WardLoc=loc
	     s a.LocTyp=typ
	     s count=count+1
	     s a.SortPos=count
	     d a.%Save()
	  }
	}
}

Query FindWardLoc(HsDr, typ, ward = "", Par = "") As %Query(ROWSPEC = "LocDes,LocDr,SortPos")
{
}

ClassMethod FindWardLocExecute(ByRef qHandle As %Binary, HsDr, typ, ward = "", Par = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//d ##Class(%ResultSet).RunQuery("DHCMGNUR.MGNurFloor","FindWardLoc",1,"xl","","")
 	 //s ^TMP("a")=$LB(HsDr,typ)
 	 //s ^mw123("WardLoc")=ward
 	 s typ=$TR($ZConvert(typ,"U")," ","")
 	 s ward=$TR($ZConvert(ward,"U")," ","")
 	 ;i typ="N" s typ=""
     s tmp=""
     if Par'=""
     {
	    s rw=""  f  s rw=$O(^DHCMGNUR.MgNurseD(Par,"ChildSub",rw)) q:rw=""  d
	    .s a=##class(DHCMGNUR.MgNurseSub).%OpenId(Par_"||"_rw)
	    .s CtLocDr=a.WardLoc
	    .s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	    .s p=rw
	    .d OutputRow8
       	Set qHandle=$lb(0,repid,0)
	    Quit $$$OK

	 }
     if (typ="")
     {
         s ty="" f  s ty=$O(^DHCMGNUR.MGNurFloorI("Typ",HsDr,ty)) q:ty=""  d
         .s loc="" f  s loc=$O(^DHCMGNUR.MGNurFloorI("Typ",HsDr,ty,loc)) q:loc=""  d
       	 ..s rw="" f  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",HsDr,ty,loc,rw)) q:rw=""  d
         ...s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
         ...s CtLocDr=a.WardLoc
         
         ...s p=a.SortPos
         ...s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
         ...q:(ctlocDesc']ward)&&(ward'="")
         ...d OutputRow8

	 }else{
		 s CtLocDr="" f  s CtLocDr=$O(^DHCMGNUR.MGNurFloorI("Typ",HsDr," "_typ,CtLocDr)) q:CtLocDr=""  d
		 .s rw="" f  s rw=$O(^DHCMGNUR.MGNurFloorI("Typ",HsDr," "_typ,CtLocDr,rw)) q:rw=""  d
	 	 ..s a=##class(DHCMGNUR.MGNurFloor).%OpenId(rw)
	 	 ..s sort=a.SortPos
	 	 
	 	 ..s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	 ..q:(ctlocDesc']ward)&&(ward'="")
	 	 ..if '$D(tmp(sort)) s tmp(sort)=ctlocDesc_"^"_CtLocDr
	 	 ..e  s tmp(sort+1)=ctlocDesc_"^"_CtLocDr
	 	 //s ^TMP("aa")=tmp
	 	 s p=""   f  s p=$O(tmp(p)) q:p=""  d
	 	 .s ctlocDesc=$P(tmp(p),"^"),CtLocDr=$P(tmp(p),"^",2)
	 	 .d OutputRow8
	 }
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr,p)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardLocExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindWardItem(typ) As %Query(ROWSPEC = "LocDes,LocDr")
{
}

ClassMethod FindWardItemExecute(ByRef qHandle As %Binary, typ = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//s ^QTMP("typ")=typ
 	s CtLocDr="" f  s CtLocDr=$o(^CTLOC(CtLocDr)) q:CtLocDr=""  d
 	.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
 	.s cttyp=$p(^CTLOC(CtLocDr),"^",13)
 	.q:(cttyp'=typ)&(typ'="")
 	.//q:(ctlocDesc'["门诊")&&(ctlocDesc'["病区")
 	.q:(ctlocDesc["停用")!(ctlocDesc["工作量")!(ctlocDesc["不做医疗")!(ctlocDesc="")
 	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Storage Default
{
<Data name="MGNurFloorDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HsDr</Value>
</Value>
<Value name="3">
<Value>LocTyp</Value>
</Value>
<Value name="4">
<Value>SortPos</Value>
</Value>
<Value name="5">
<Value>WardLoc</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.MGNurFloorD</DataLocation>
<DefaultData>MGNurFloorDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.MGNurFloorD</IdLocation>
<IndexLocation>^DHCMGNUR.MGNurFloorI</IndexLocation>
<StreamLocation>^DHCMGNUR.MGNurFloorS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
