Include webimport

IncludeGenerator webimport

/// Creator:Liang Qiang
/// CreatDate:2010-03-17
/// Description:病区保留药品查询
/// 
Class web.DHCSTRESERVEQUERY Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1442;

ClassMethod GetReservedQtyExecute(ByRef qHandle As %Binary, displocrowid, wardrowid, enddate) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1

    q:displocrowid="" $$$OK
    s arcsub=""
    s inci="" 
    f  s inci=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci)) q:inci=""  d 
    .s ward=""
    .f  s ward=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,ward)) q:ward=""  d
    ..q:(wardrowid'=ward)&(wardrowid'="")
    ..s pres="" 
    ..f  s pres=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,ward,pres)) q:pres=""  d 
    ...s qty=..GetQty(pres,enddate)
    ...s warddesc=$p(^PAWARD(ward),"^",2)
	...s incidesc=$p(^INCI(inci,1),"^", 2)
    ...d OutRowInci
	Quit $$$OK
OutRowInci
	set Data=$lb(warddesc,incidesc,qty,ward,pres,inci)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetReservedQtyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReservedQtyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetReservedQty(displocrowid As %String, wardrowid As %String, enddate) As %Query(ROWSPEC = "Tward:%String,Tinci:%String,Tqty:%String,Twardrowid:%String,Tpres:%String,Tincirowid:%String")
{
}

ClassMethod GetReservedQtyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReservedQtyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:Liang Qiang
/// CreatDate:2010-03-17
/// Description:清除病区单个保留药品
/// Input:wardRowid
/// 
ClassMethod ClearInciResQty(displocrowid, wardrowid, inci, user, pres) As %String
{
	n (displocrowid, wardrowid, inci, user ,pres)
	s ret=0
	l +^DHCPhaReserve(pres):5  e  q -1   ;加锁
	s avqty=$p(^DHCPRES(pres),"^",4)
	;i avqty=0 l -^DHCPhaReserve(pres)
	;q:avqty=0 1
	&sql(update  DHC_PhaReserve set PRES_ResQty=0 where PRES_Ward_DR=:wardrowid and PRES_CTLOC_DR=:displocrowid and PRES_INCI_DR=:inci)
	i SQLCODE l -^DHCPhaReserve(pres)
	i SQLCODE q -2
	k PLIST
	s chl=$o(^DHCPRES(pres,"DET",""),-1)
	s qty=$p(^DHCPRES(pres,"DET",chl),"^",4)
	s PLIST(0)=pres
	s PLIST(2)=$o(^DHCPRES(pres,"DET",""),-1)+1
	s PLIST(3)="A"
	s PLIST(4)=-qty
	s PLIST(5)=pres
	s PLIST(6)=0
	s PLIST(7)=+$h
	s PLIST(8)=user
	s PLIST(9)=$p($h,",",2)
	&sql(insert into DHC_PhaReserveDetail values PLIST())
	i SQLCODE'=0 s $p(^DHCPRES(pres),"^",4)=avqty
	i SQLCODE'=0 s ret=-5
	l -^DHCPhaReserve(pres) 
	q ret
}

/// Creator:Liang Qiang
/// CreatDate:2010-09-12
/// Description:清除病区保留药品
/// Input:wardRowid
/// 
ClassMethod ClearWardResQty(displocrowid, wardrowid, user) As %String
{
	n (displocrowid, wardrowid, user)
	s inci=""
	f  s inci=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci)) q:inci=""  d
	.s pres=""
	.f  s pres=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,wardrowid,pres)) q:pres=""  d
	..s ret=..ClearInciResQty(displocrowid, wardrowid, inci, user, pres)
	q 0
}

/// Creator:Liang Qiang
/// CreatDate:2010-09-12
/// Description:清除全院保留药品
/// Input:wardRowid
/// 
ClassMethod ClearAllResQty(displocrowid, user) As %String
{
	n (displocrowid, user)
	s inci=""
	f  s inci=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci)) q:inci=""  d
	.s wardrowid=""
	.f  s wardrowid=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,wardrowid)) q:wardrowid=""  d
	..s pres=""
	..f  s pres=$o(^DHCPRES(0,"LOCINCIWARD",displocrowid,inci,wardrowid,pres)) q:pres=""  d
	...s ret=..ClearInciResQty(displocrowid, wardrowid, inci, user, pres)
	q 0
}

ClassMethod GetQty(pres, enddate) As %String
{
	n (pres,enddate)
	s enddate=enddate+1
	s enddate=$o(^DHCPRES(0,"Date",pres,enddate),-1)
	q:enddate="" 0
	s chl=$o(^DHCPRES(0,"Date",pres,enddate,""),-1)
	s avqty=$p(^DHCPRES(pres,"DET",chl),"^",4)
	Q avqty
}

/// Creator:Liang Qiang
/// CreatDate:2010-09-12
/// Description:保留药品明细查询
/// Input:保留表rowid,日期
/// 
ClassMethod GetReservedQtyItmExecute(ByRef qHandle As %Binary, pres, startdate, enddate) As %Status
{

    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    s ^zdm("GetReservedQtyItmExecute")=pres_"^"_startdate_"^"_enddate
    q:pres="" $$$OK
    s distype=""
    f date=startdate:1:enddate d
    .s presub="" 
    .f  s presub=$o(^DHCPRES(0,"Date",pres,date,presub)) q:presub=""  d
    ..s type=$p(^DHCPRES(pres,"DET",presub),"^",1)
    ..i type="P" s distype="发药"
    ..i type="Y" s distype="退药"
    ..i type="A" s distype="清零"
    ..s qty=$p(^DHCPRES(pres,"DET",presub),"^",3)
    ..i type="P" s qty=-qty
    ..s avqty=$p(^DHCPRES(pres,"DET",presub),"^",4)
    ..s retdate=$p(^DHCPRES(pres,"DET",presub),"^",5)
    ..i retdate'="" s retdate=$zd(retdate,3)
    ..s retuser=$p(^DHCPRES(pres,"DET",presub),"^",6)
    ..i retuser'="" s retuser=$p(^SSU("SSUSR",retuser),"^",2)
    ..s rettime=$p(^DHCPRES(pres,"DET",presub),"^",7)
    ..i rettime'="" s rettime=$zt(rettime,1)
    ..s retdate=retdate_" "_rettime
    ..d OutRowItm
	Quit $$$OK
OutRowItm
	set Data=$lb(distype,qty,avqty,retdate,retuser)   //所对应传出的列名
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetReservedQtyItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReservedQtyItmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
	}
	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetReservedQtyItm(pres As %String, startdate As %String, enddate As %String) As %Query(ROWSPEC = "Ttype:%String,Tqty:%String,Tavqty:%String,Tdate:%String,Tuser:%String")
{
}

ClassMethod GetReservedQtyItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReservedQtyItmExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
