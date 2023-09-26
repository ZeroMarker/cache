Import SQLUser

Class web.DHCPE.Report.PreInfoStatistic Extends %RegisteredObject
{

//d ##class(%ResultSet).RunQuery("web.DHCPE.Report.PreInfoStatistic","PreInfoStatistic","61871","61872","","","")

Query PreInfoStatistic(DateBegin As %Library.String = "", DateEnd As %Library.String = "", ItemDR As %Library.String = "", SetDR As %Library.String = "", LocDR As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TItemDesc:%String, TAmount:%String")
{
}

ClassMethod PreInfoStatisticExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "", ItemDR As %Library.String = "", SetDR As %Library.String = "", LocDR As %Library.String = "") As %Status
{
 	s ind=1
 	s id=0	
	Set repid=$I(^CacheTemp)
	
 	if (""=DateBegin)&&(""=DateEnd){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	s OtherStation=$G(^DHCPESetting("DHCPE","StationId_Other"))
 	i DateBegin=""  s DateBegin=0
 	i DateEnd=""  s DateEnd=DateBegin
 	k ^DHCPETMPPIS
 	for DateFrom=DateBegin:1:DateEnd
  { 
 	s ^DHCPETMPPIS("PreInfoStatistic")=LocDR_","""_SetDR_""""_","""_ItemDR_""","_DateBegin_","_DateEnd
	s DateTo=0
	f  s DateTo=$o(^DHCPEPreIADM(0,"BookDateTime",DateFrom,DateTo))  q:DateTo=""  d
	.s BookTime=0
	.f  s BookTime=$o(^DHCPEPreIADM(0,"BookDateTime",DateFrom,DateTo,BookTime))  q:BookTime=""  d
	..s PIADMRowId=0
	..f  s PIADMRowId=$o(^DHCPEPreIADM(0,"BookDateTime",DateFrom,DateTo,BookTime,PIADMRowId))  q:PIADMRowId=""   d
	...s PIADMStatus=$p(^DHCPEPreIADM(PIADMRowId),"^",8)
	...q:(PIADMStatus="CANCELPE")||(PIADMStatus="CANCELPREREG")
	...s PIADMVip=$p(^DHCPEPreIADM(PIADMRowId),"^",18)
	...s ^DHCPETMPPIS("TotalAmount")=+$g(^DHCPETMPPIS("TotalAmount"))+1
    ...s ^DHCPETMPPIS("TotalAmount",PIADMRowId)=1
	...i PIADMVip="1" d
	....s ^DHCPETMPPIS("VIPTotalAmount")=+$g(^DHCPETMPPIS("VIPTotalAmount"))+1
	....s ^DHCPETMPPIS("VIPTotalAmount",PIADMRowId)=1
	...s ChildSub=0
	...f  s ChildSub=$o(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub))  q:ChildSub=""  d
	....s OrderSetsDR="",PIOIItmMastDR="",PIOIItemRecLocDR=""
	....s PIOIItmMastDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub),"^",1)
	....q:PIOIItmMastDR=""
	....s STRowId="0"
	....s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",PIOIItmMastDR,STRowId))
    ....s Station="^"_STRowId_"^"
	....Q:(""=STRowId)
	....q:OtherStation[Station
    ....s PIOIOrdEntDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub),"^",2)
    ....i PIOIOrdEntDR'="" s OrderSetsDR=$p($g(^DHCPEPreIADM($p($g(PIOIOrdEntDR),"||",1),"ORDENT",$p($g(PIOIOrdEntDR),"||",2))),"^",1)
    ....s PIOIItemRecLocDR=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub),"^",17) 
    ....s PIOIItemStat=$p(^DHCPEPreIADM(PIADMRowId,"ORDITEM",ChildSub),"^",16)
    ....q:PIOIItemStat'="1"
    ....q:(LocDR'="")&&(LocDR'=PIOIItemRecLocDR)
    ....q:(SetDR'="")&&(SetDR'=OrderSetsDR)
    ....q:(ItemDR'="")&&(ItemDR'=PIOIItmMastDR)
    ....i ($G(^DHCPETMPPIS("RecDep", PIOIItemRecLocDR, "ADMList"))'[(PIADMRowId_"^")) s ^DHCPETMPPIS("RecDep", PIOIItemRecLocDR)=+$G(^DHCPETMPPIS("RecDep", PIOIItemRecLocDR))+1
 	....i ($G(^DHCPETMPPIS("RecDep", PIOIItemRecLocDR, "ADMList"))'[(PIADMRowId_"^")) S ^DHCPETMPPIS("RecDep", PIOIItemRecLocDR, "ADMList")=$G(^DHCPETMPLWA("RecDep", PIOIItemRecLocDR, "ADMList"))_PIADMRowId_"^"
    ....s ^DHCPETMPPIS("RecDep",PIOIItemRecLocDR,"ItmMast",PIOIItmMastDR)=+$g(^DHCPETMPPIS("RecDep",PIOIItemRecLocDR,"ItmMast",PIOIItmMastDR))+1
    ....s ^DHCPETMPPIS("RecDepList",PIOIItemRecLocDR,PIOIItmMastDR,PIADMRowId)=1
    ....i OrderSetsDR'=""  d
    .....i ($G(^DHCPETMPPIS("Sets", OrderSetsDR, "ADMList"))'[(PIADMRowId_"^")) s ^DHCPETMPPIS("Sets", OrderSetsDR)=+$G(^DHCPETMPPIS("Sets", OrderSetsDR))+1
 	.....i ($G(^DHCPETMPPIS("Sets", OrderSetsDR, "ADMList"))'[(PIADMRowId_"^")) S ^DHCPETMPPIS("Sets", OrderSetsDR, "ADMList")=$G(^DHCPETMPLWA("Sets", OrderSetsDR, "ADMList"))_PIADMRowId_"^"
    .....s ^DHCPETMPPIS("SetsList",OrderSetsDR,PIADMRowId)=1
  }
   	 s TotalPerson=+$G(^DHCPETMPPIS("TotalAmount"))
   	 s TotalPerson=TotalPerson_"人"
	 s Name="总人数:"
	 s Data=$LB(Name,"",TotalPerson)
     d PreInfoStatisticOut

   
     s VIPTotalPerson=+$G(^DHCPETMPPIS("VIPTotalAmount"))
     s VIPTotalPerson=VIPTotalPerson_"人"
	 s Name="贵宾人数:"
	 s Data=$LB(Name,"",VIPTotalPerson)
     d PreInfoStatisticOut

    s RecLocDR=0,CTLOCDesc=""
    f  s RecLocDR=$o(^DHCPETMPPIS("RecDep",RecLocDR))  q:RecLocDR=""   d
    .s RecLocTotal=$g(^DHCPETMPPIS("RecDep",RecLocDR))
    .s RecLocTotal=RecLocTotal_"人"
    .s CTLOCDesc=$P($G(^CTLOC(RecLocDR)),"^",2)   //科室名称
    .s Data=$LB(CTLOCDesc,"总计:", RecLocTotal)
    .i ((LocDR'="")||((ItemDR="")&&(SetDR=""))) d PreInfoStatisticOut
    .s ItmMastDR=0
    .f  s ItmMastDR=$o(^DHCPETMPPIS("RecDep",RecLocDR,"ItmMast",ItmMastDR))  q:ItmMastDR=""  d
    ..s RecItemTotal=$g(^DHCPETMPPIS("RecDep",RecLocDR,"ItmMast",ItmMastDR)) 
    ..s RecItemTotal=RecItemTotal_"人" 
	..s ARCIMSubscript=$P(ItmMastDR,"||",1)
	..s ARCIMVersion=$P(ItmMastDR,"||",2)
	..s ARCIMDesc=$P($G(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	..s Data=$LB("", ARCIMDesc,RecItemTotal)
    ..d PreInfoStatisticOut
  
    s OrdSetsDR=0,OrderSetsDesc=""
    f  s OrdSetsDR=$o(^DHCPETMPPIS("Sets",OrdSetsDR))  q:OrdSetsDR=""  d
    .s SetsTotal=$G(^DHCPETMPPIS("Sets",OrdSetsDR))
    .s SetsTotal=SetsTotal_"人" 
    .s OrderSetsDesc=$p(^ARCOS(OrdSetsDR),"^",2)
    .s Data=$LB(OrderSetsDesc,"",SetsTotal)
    .i ((SetDR'="")||((LocDR="")&&(ItemDR="")))  d PreInfoStatisticOut

	k ^DHCPETMPPIS
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
PreInfoStatisticOut
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PreInfoStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PreInfoStatisticExecute ]
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

ClassMethod PreInfoStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PreInfoStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
