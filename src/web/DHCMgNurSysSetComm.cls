Class web.DHCMgNurSysSetComm Extends %RegisteredObject
{

/// 
/// MethodDescripition:大科护理单元维护查询
/// Date:2015-02-15
Query SchMgLocCode(wardid = "") As %Query(ROWSPEC = "LocDes,LocDr")
{
}

ClassMethod SchMgLocCodeExecute(ByRef qHandle As %Binary, wardid = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s ^TEMP("g201503110011")=wardid
 	
	//s wardid=$ZConvert(wardid,"U")
 	s raw="" f  s raw=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",raw)) q:raw=""  d
 	.s id="" f  s id=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",raw,id)) q:id=""  d
 	..s obj=##class(DHCMGNUR.MgNurPerWard).%OpenId(id)
 	..s CtLocDr=obj.WardLoc
 	..q:((CtLocDr'=wardid)&(wardid'=""))
 	..i CtLocDr="9997" s ctlocDesc="LZQ-离职区(不做统计)"
 	..e  i CtLocDr="9998" s ctlocDesc="TXQ-退休区(不做统计)"
 	..e  i CtLocDr="9999" s ctlocDesc="DFQ-待分区"
 	..e  s ctlocDesc=$P(^CTLOC(CtLocDr),"^",2)
 	..;q:(ctlocDesc'[wardid)&&(wardid'="")
 	..d OutputRow8
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SchMgLocCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchMgLocCodeExecute ]
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

ClassMethod SchMgLocCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchMgLocCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 
/// 

Query FindWardCode(wardid = "") As %Query(ROWSPEC = "LocDes,LocDr")
{
}

ClassMethod FindWardCodeExecute(ByRef qHandle As %Binary, wardid = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s wardid=$ZConvert(wardid,"U")
 	s ord="" f  s ord=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord)) q:ord=""  d
 	.s id="" f  s id=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",ord,id)) q:id=""  d
 	..s obj=##class(DHCMGNUR.MgNurPerWard).%OpenId(id)
 	..s LocDr=obj.WardLoc
 	..s LocDes=$p(^CTLOC(LocDr),"^",2)
 	..q:(LocDes'[wardid)&&(wardid'="")
 	..d OutputRow8
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(LocDes,LocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardCodeExecute ]
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

ClassMethod FindWardCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
