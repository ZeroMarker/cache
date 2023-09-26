Import SQLUSER

Class web.DHCArrbeddoc Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

ClassMethod GetWardDesc(wardid) As %Status
{
	q:wardid="" ""
 	s warddesc=$p($g(^PAWARD(wardid)),"^",2)
 	q warddesc
}

// 病区放大镜

Query GetallWard(desc, HospitalRowId, ConfigName) As %Query(ROWSPEC = "warddesc:%String,wardcode:%String,wardid:%String")
{
}

ClassMethod GetallWardExecute(ByRef qHandle As %Binary, desc, HospitalRowId, ConfigName) As %Status
{
	s ^tempsc("GetallWard")=$lb(desc,HospitalRowId,ConfigName)
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s wardid=0
    f  s wardid=$o(^PAWARD(wardid)) q:wardid=""  d
    .q:+wardid=0
 	.s wardcode=$p($g(^PAWARD(wardid)),"^",1)
 	.s warddesc=$p($g(^PAWARD(wardid)),"^",2)
 	.s CTLocDr= $p($g(^PAWARD(wardid)),"^",5)
 	.s hospital=$p($g(^CTLOC(CTLocDr)),"^",22)
 	.s showFlag=##class(Nur.Interface.Other.BDPInterface).GetHospShowDataFlagSpecial("CT_Loc",CTLocDr,HospitalRowId,ConfigName)
 	.q:showFlag'="Y"
 	.;q:HospitalRowId'=hospital
 	.s CTLocCode= $p($g(^CTLOC(CTLocDr)),"^",43)
 	.s comparWarddesc=$$ALPHAUP^SSUTIL4(CTLocCode)
 	.;s comparWarddesc=$$ALPHAUP^SSUTIL4(warddesc)
 	.s desc=$$ALPHAUP^SSUTIL4(desc)
 	.q:(desc'="")&(comparWarddesc'[desc)&(warddesc'[desc)
	.d OutRow2
	 Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow2
	set Data=$lb(warddesc,wardcode,wardid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetallWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetallWardExecute ]
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

ClassMethod GetallWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetallWardExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 病区床位遍历

Query GetallWardbed(wardid As %String) As %Query(ROWSPEC = "bedcode:%String,bedcsub:%String,doctorname:%String,nursename:%String")
{
}

ClassMethod GetallWardbedExecute(ByRef qHandle As %Binary, wardid As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCArrbeddoc","GetallWardbed",22)
	s repid=$i(^CacheTemp)
	s ind=1
 	i wardid="" s qHandle=$lb(0,repid,0) Quit $$$OK
    s roomdr=0
    f  s roomdr=$o(^PAWARD(0,"WardRoom",wardid,roomdr)) q:roomdr=""  d
    .s bedcsub=0
    .f  s bedcsub=$o(^PAWARD(0,"WardRoom",wardid,roomdr,bedcsub)) q:bedcsub=""  d
    ..q:$g(^PAWARD(wardid,"BED",bedcsub))=""
    ..s bedtype=$p($g(^PAWARD(wardid,"BED",bedcsub)),"^",2) 
    ..s bedcode=$p($g(^PAWARD(wardid,"BED",bedcsub)),"^",1)
    ..s RcFlag=$p($g(^PAWARD(wardid,"BED",bedcsub)),"^",4)
	..q:(RcFlag="N") ;未激活的床
    ..;s rowid=$p($g(^DHCDocbed(wardid,bedcsub)),"^",1)
    ..;i rowid="" d 
	..;.s ^DHCDocbed(wardid,bedcsub)=""
	..i $d(^DHCDocbed(wardid,bedcsub))=0 d
	...s ^DHCDocbed(wardid,bedcsub)=""
	s bedcsub=""
	f  s bedcsub=$o(^DHCDocbed(wardid,bedcsub)) q:bedcsub=""  d
	.s rowid=$p($g(^DHCDocbed(wardid,bedcsub)),"^",1)
	.s nurrowid=$p($g(^DHCDocbed(wardid,bedcsub)),"^",2)
	.s bedcode=$p($g(^PAWARD(wardid,"BED",bedcsub)),"^",1)
	.s RcFlag=$p($g(^PAWARD(wardid,"BED",bedcsub)),"^",4)
	.q:(RcFlag="N") ;未激活的床
	.i rowid="" d
	..s doctorname=""
	.i rowid'=""  d
	..s doctorname=$p($g(^CTPCP(rowid,1)),"^",2)
	.i nurrowid="" d
	..s nursename=""
	.i nurrowid'=""  d
	..s nursename=$p($g(^CTPCP(nurrowid,1)),"^",2)
	.d OutRowReg
	s qHandle=$lb(0,repid,0)
	q $$$OK
OutRowReg
	s Data=$lb(bedcode,bedcsub,doctorname,nursename)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod GetallWardbedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetallWardbedExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetallWardbedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetallWardbedExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

// 病区所对应医生

Query GetallWarddoctor(wardid As %String) As %Query(ROWSPEC = "doctorname,rowid")
{
}

ClassMethod GetallWarddoctorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetallWarddoctorExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetallWarddoctorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetallWarddoctorExecute ]
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

ClassMethod GetallWarddoctorExecute(ByRef qHandle As %Binary, wardid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//i warddesc="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i wardid="" s qHandle=$lb(0,repid,0) Quit $$$OK
 	//s wardid="" ##class(%Resulset).RunQuery("web.DHCArrbeddoc","GetallWarddoctor",3)
    //f  s wardid=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(warddesc),wardid))  q:wardid=""  d
    s locid=$p(^PAWARD(wardid),"^",5)
    s locflag=$p(^CTLOC(locid),"^",5)
    i locflag="Y" d 
    .s locid1=$P(^CTLOC(locid,"LINK",$o(^CTLOC(locid,"LINK",0))),"^",1)
    i $g(locid1)="" s qHandle=$lb(0,repid,0) Quit $$$OK
    s resid=""
    f  s resid=$o(^RB("RES",0,"CTLOC",locid1,resid)) q:resid=""  d
    .s admRight=$p($G(^RB("RES",resid)),"^",20)
	.q:(admRight'="Y")
    .s doctorname=$p(^RB("RES",resid),"^",17)
    .s rowid=$p(^RB("RES",resid),"^",2)
    .q:rowid=""
    .i rowid=1813  b
    .q:$g(^CTPCP(rowid,1))=""
    .s activeFlag=$P($G(^CTPCP(rowid,1)),"^",9)
	.q:activeFlag="N"
    .s typedr=$p(^CTPCP(rowid,1),"^",4)
    .s type=$p(^CT("CPT",typedr),"^",4)
    .i type="DOCTOR" d
    ..Do Outputcpt
 	/*s rw=""
 	s doctorname=""
 	f  s doctorname=$o(^RB("RES",0,"LocDesc",locid,doctorname)) q:doctorname=""  d
 	.s rowid=""
 	.f  s rowid=$o(^RB("RES",0,"LocDesc",locid,$$ALPHAUP^SSUTIL4(doctorname),rowid)) q:rowid=""  d
 	..s typedr=$p(^CTPCP(rowid,1),"^",4)
 	..s type=$p(^CT("CPT",typedr),"^",4)
 	..i type="DOCTOR" d
 	...Do Outputcpt
 	f  s rw=$O(^RB("RES",0,"CTLOC",locid,rw))  q:rw=""  d
 	.w !,rw
 	.s rowid=$P(^RB("RES",rw),"^",2)
 	.w !,rowid
 	.q:rowid=""
 	.s typedr=$p(^CTPCP(rowid,1),"^",4)
 	.w !,typedr
 	.s type=$p(^CT("CPT",typedr),4)
 	.i type="DOCTOR" d
 	..s doctorname=$p(^CTPCP(rowid,1),"^",2)
 	..Do Outputcpt	*/
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

Outputcpt
	set Data=$lb(doctorname,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

// 给相应床位安排医生

ClassMethod updatevis(bedcsub As %String, rowid As %String, wardid As %String)
{
	i (bedcsub'="")&&(wardid'="")  d
	.i '$d(^DHCDocbed(wardid,bedcsub)) s ^DHCDocbed(wardid,bedcsub)=rowid
	.e  s $p(^DHCDocbed(wardid,bedcsub),"^",1)=rowid	
	.;s ^DHCDocbed(wardid,bedcsub)=rowid
	Q 0
}

// 给相应床位安排医生

ClassMethod updatenur(bedcsub As %String, rowid As %String, wardid As %String)
{
	i (bedcsub'="")&&(wardid'="")  d
	.i '$d(^DHCDocbed(wardid,bedcsub)) s ^DHCDocbed(wardid,bedcsub)="^"_rowid
	.e  s $p(^DHCDocbed(wardid,bedcsub),"^",2)=rowid
	Q 0
}

ClassMethod getCTCPOfBed(bedId)
{
	q:bedId="" ""
	s str=$g(^DHCDocbed(+bedId,$p(bedId,"||",2)))
	q:str="" ""
	s doctorCTCPId=$p(str,"^",1)
	i doctorCTCPId'="" d
	.i $g(^CTPCP(doctorCTCPId,1))="" s doctorCTCPId="" q
	.s doctorName=$p(^CTPCP(doctorCTCPId,1),"^",2)
	.s doctorCode=$p(^CTPCP(doctorCTCPId,1),"^",1)
	s nurseCTCPId=$p(str,"^",2)
	i (nurseCTCPId'="") d
	.i $g(^CTPCP(nurseCTCPId,1))="" s nurseCTCPId="" q
	.s nurseName=$p(^CTPCP(nurseCTCPId,1),"^",2)
	q doctorCTCPId_"^"_$g(doctorName)_"^"_nurseCTCPId_"^"_$g(nurseName)_"^"_$g(doctorCode)
}

// 病区所对应护士

Query GetallWardnurse(wardid As %String) As %Query(ROWSPEC = "nursename,rowid")
{
}

ClassMethod GetallWardnurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetallWardnurseExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetallWardnurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetallWardnurseExecute ]
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

ClassMethod GetallWardnurseExecute(ByRef qHandle As %Binary, wardid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//i warddesc="" s qHandle=$lb(0,repid,0) Quit $$$OK
	i wardid="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s DepRowId=$p(^PAWARD(wardid),"^",5)
	i DepRowId="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s wardFlag=$p(^CTLOC(DepRowId),"^",5)
	i wardFlag'="Y" Set qHandle=$lb(0,repid,0)	Quit $$$OK
	s ResRowId=""
	f  s ResRowId=$o(^RB("RES",0,"CTLOC",DepRowId,ResRowId)) q:ResRowId=""  d
	.s NurId=$p($G(^RB("RES",ResRowId)),"^",2)
	.s nursename=$p($G(^RB("RES",ResRowId)),"^",17)
	.q:NurId=""
	.s CTCPTypeId=$P($G(^CTPCP(NurId,1)),"^",4)
	.q:CTCPTypeId=""
	.s CTCPType=$P($G(^CT("CPT",CTCPTypeId)),"^",4)
	.q:CTCPType'="NURSE"
	.s rowid=NurId
	.Do OutputNur
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

OutputNur
	set Data=$lb(nursename,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
