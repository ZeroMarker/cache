Class web.UDHCJFOrdCat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 28;

ClassMethod getordcatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getordcatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getordcatExecute(ByRef qHandle As %Binary, EpisodeID As %String, getnotpaid As %String, getstatus As %String, ordcat As %String, getseldate As %String, stdate As %String, enddate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 
 	If $g(ind)="" Set ind=1
	s EpisodeID=$g(EpisodeID)
	if EpisodeID=""  s qHandle=$lb(0,repid,0)    quit $$$OK
	;;;;;build data for ordcat;;;;;
	
	s oedr=$o(^OEORD(0,"Adm",EpisodeID,""))

	s oeidr="0"
	f  s oeidr=$o(^OEORD(oedr,"I",oeidr))  q:oeidr=""  d
	.s adddate=$p($g(^OEORD(oedr,"I",oeidr,1)),"^",9)
	.q:(getseldate=1)&&(adddate<stdate)
	.q:(getseldate=1)&&(adddate>enddate)
	.s arcim=$p($g(^OEORD(oedr,"I",oeidr,1)),"^",2)
	.q:arcim=""
	.s itmdesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
	.s catsubid=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
	.s Tordcatid=$p($g(^ARC("IC",catsubid)),"^",8)
	.q:(ordcat'="")&&(ordcat'=Tordcatid)
	.s TOrdCate=$p(^OEC("ORCAT",Tordcatid),"^",2) 
	.s billed=$p($g(^OEORD(oedr,"I",oeidr,3)),"^",5)
	.q:(getnotpaid="1")&(billed'="P")
	.q:(getnotpaid="0")&(billed="P")
	.s ordstat=$p($g(^OEORD(oedr,"I",oeidr,1)),"^",13)
	.s:ordstat ordstat=$p($g(^OEC("OSTAT",ordstat)),"^",2)
	.i ordstat="Inactive"  s ordstat="未激活"
	.q:(getstatus="1")&(ordstat="未激活")
	.q:(getstatus="0")&(ordstat'="未激活")
	.s pbo=$p($g(^OEORD(oedr,"I",oeidr,1)),"^",16)
	.i pbo'=""  d
	..s amt=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",11)
	..s pbqty=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",5)
	..s refqty=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",6)
	.s ^TMP("ZYJF","getordcat",$j,Tordcatid)=TOrdCate
	.s ^TMP("ZYJF","getordcat",$j,Tordcatid,arcim)=itmdesc
	.s ^TMP("ZYJF","getordcat",$j,Tordcatid,arcim,"num")=+$g(^TMP("ZYJF","getordcat",$j,Tordcatid,arcim,"num"))+$g(pbqty)-$g(refqty)
	.s ^TMP("ZYJF","getordcat",$j,Tordcatid,arcim,"sum")=+$g(^TMP("ZYJF","getordcat",$j,Tordcatid,arcim,"sum"))+$g(amt)
	
	;;;;;;;;;
	
	i $d(^TMP("ZYJF","getordcat",$j))  d
	.s catid=""
	.f  s catid=$o(^TMP("ZYJF","getordcat",$j,catid))  q:catid=""   d
	..s catamt=0
	..s catdesc=$g(^TMP("ZYJF","getordcat",$j,catid))
	..s itmid=""
	..f  s itmid=$o(^TMP("ZYJF","getordcat",$j,catid,itmid))  q:itmid=""   d
	...s itmdesc=$g(^TMP("ZYJF","getordcat",$j,catid,itmid))
	...s itmnum=$g(^TMP("ZYJF","getordcat",$j,catid,itmid,"num"))
	...s itmsum=$g(^TMP("ZYJF","getordcat",$j,catid,itmid,"sum"))
	...s catamt=catamt+$g(itmsum)
	...s oedr1=oedr
	...d OutputRow1
	..s catdesc="小计：",oedr1=""
	..s itmsum=catamt
	..s itmdesc="",itmnum="",itmid=""
	..d OutputRow1

	i $d(^TMP("ZYJF","getordcat",$j))   k ^TMP("ZYJF","getordcat",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	s itmsum=$g(itmsum),itmsum=$j(itmsum,3,2)
	set Data=$lb(catdesc,itmdesc,itmnum,itmsum,itmid,oedr1)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getordcatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getordcatExecute ]
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

Query getordcat(EpisodeID As %String, getnotpaid As %String, getstatus As %String, ordcat As %String, getseldate As %String, stdate As %String, enddate As %String) As %Query(ROWSPEC = "Tcatdesc:%String,Titmdesc:%String,Titmnum:%String,Titmsum:%String,itmid:%String,oeord:%String")
{
}

ClassMethod getorditemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getorditemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getorditemExecute(ByRef qHandle As %Binary, oeord As %String, arcitm As %String, getnotpaid As %String, getstatus As %String, stdate As %String, enddate As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 
 	If $g(ind)="" Set ind=1
 	if (oeord="")||(arcitm="")  s qHandle=$lb(0,repid,0)    quit $$$OK
    s n=0
	s oedate=""
	f  s oedate=$o(^OEORDi(0,"ARCIM",oeord,arcitm,oedate))  q:oedate=""  d
	.q:(((stdate'="")&&(oedate<stdate))||((enddate'="")&&(oedate>enddate)))
	.s oestdate=$zd(oedate,3)
	.s itmdesc=$p($g(^ARCIM(+arcitm,$p(arcitm,"||",2),1)),"^",2)
	.s oesub=""
	.f  s oesub=$o(^OEORDi(0,"ARCIM",oeord,arcitm,oedate,oesub))  q:oesub=""  d 
	..s billed=$p($g(^OEORD(oeord,"I",oesub,3)),"^",5)
	..q:(getnotpaid="1")&(billed'="P")
	..q:(getnotpaid="0")&(billed="P")
	..s ordstat=$p($g(^OEORD(oeord,"I",oesub,1)),"^",13)
	..s:ordstat ordstat=$p($g(^OEC("OSTAT",ordstat)),"^",2)
	..i ordstat="Inactive"  s ordstat="未激活"
	..q:(getstatus="1")&(ordstat="未激活")
	..q:(getstatus="0")&(ordstat'="未激活")
	..s docuserid=$p($g(^OEORD(oeord,"I",oesub,7)),"^",1)
	..i docuserid="" s DocUser=""
	..i docuserid'="" s DocUser=$p(^SSU("SSUSR",docuserid),"^",2)
	..s recloc=$p($g(^OEORD(oeord,"I",oesub,3)),"^",6)
	..s:recloc'="" recloc=$p($g(^CTLOC(recloc)),"^",2)
	..s pbo=$p($g(^OEORD(oeord,"I",oesub,1)),"^",16)
	..s amt=0,num=0
	..i pbo'=""  d
	...s amt=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",11)
	...s pbqty=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",5)
	...s refqty=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",6)
	...s unitprice=$p($g(^DHCPB(+pbo,"O",$p(pbo,"||",2))),"^",7)
	...s num=$g(pbqty)-$g(refqty)
	..s oeoritm=oeord_"||"_oesub
	..d OutputRow2
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
    set n=n+1
	s amt=$g(amt),amt=+$j(amt,3,2)
	set Data=$lb(n,oestdate,itmdesc,DocUser,num,$g(unitprice),ordstat,billed,recloc,amt,pbo,oeoritm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getorditemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getorditemExecute ]
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

Query getorditem(oeord As %String, arcitm As %String, getnotpaid As %String, getstatus As %String, stdate As %String, enddate As %String) As %Query(ROWSPEC = "Tnumber:%String,Toestdate:%String,Titmdesc:%String,TDocUser:%String,Tquaty:%String,Tprice:%String,Tordstat:%String,Tbillfalg:%String,Trecloc:%String,Tamt:%String,Tbillno:%String,Toeori:%String")
{
}

}
