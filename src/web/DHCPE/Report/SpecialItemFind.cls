Class web.DHCPE.Report.SpecialItemFind Extends %Persistent
{

// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.SpecialItemFind", "FindSpecialItem","","")

ClassMethod FindSpecialItemExecute(ByRef qHandle As %Binary, StartDate, EndDate) As %Status
{
    Set repid=$I(^CacheTemp)
    s Job=$J
    k ^TempDHCPEFindSpecialItem(Job)
	s ind=1
	
	s:StartDate'="" StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	s:StartDate="" StartDate=+$H
	s:EndDate="" EndDate=+$H
	s IADMAdmDate=+StartDate-1
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((IADMAdmDate>+EndDate)||(""=IADMAdmDate))  d
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)
  	...q:LocFlag=1
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...s PIADM=$P(^DHCPEIADM(IAdmRowId),"^",4)
	...s VIPLevel=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PIADM)
	...s VIP=1
	...s:VIPLevel[("VIP") VIP=2
	...s LocID=$P(^DHCPEPreIADM(PIADM),"^",26)
	...s ItemSub=""
	...f  s ItemSub=$O(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)) q:ItemSub=""  d
	....s ItemStat=$P($G(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)),"^",16)
	....q:ItemStat'="1"
	....s ArcimID=$P($G(^DHCPEPreIADM(PIADM,"ORDITEM",ItemSub)),"^",1)
	....q:$G(^DHCPECTDataEx("DHCPEStationOrder","SpecialItem",ArcimID,LocID))'="8"
	....s STID=$O(^DHCPEST(0,"STORD_ARCIM",ArcimID,0))
	....q:STID'="9"
	....s Num=$I(^TempDHCPEFindSpecialItem(Job,STID,ArcimID,VIP))
	s STID=""
	f  s STID=$O(^TempDHCPEFindSpecialItem(Job,STID)) q:STID=""   d
	.s ArcimID=""
	.f  s ArcimID=$O(^TempDHCPEFindSpecialItem(Job,STID,ArcimID)) q:ArcimID=""   d
	..s TItemDesc=$P(^ARCIM(+ArcimID,1,1),"^",2)
	..s TItemPTQty=$G(^TempDHCPEFindSpecialItem(Job,STID,ArcimID,1))
	..s TItemVIPQty=$G(^TempDHCPEFindSpecialItem(Job,STID,ArcimID,2))
	..s TItemPrice=##class(web.UDHCJFPRICE).GetOrderPrice(8,"",ArcimID,+$H,"","","","")
	..s TItemPrice=$P(TItemPrice,"^",1)
	..s TItemAmt=TItemPrice*(TItemVIPQty+TItemPTQty)
	..d OutPat
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutPat
    set Data=$lb(TItemDesc,TItemPTQty,TItemVIPQty,TItemPrice,TItemAmt)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
 /////////////////////////////////////////////////////////////////////
}

ClassMethod FindSpecialItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSpecialItemExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindSpecialItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSpecialItemExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindSpecialItem(StartDate, EndDate) As %Query(ROWSPEC = "TItemDesc:%String,TItemPTQty:%String,TItemVIPQty:%String,TItemPrice:%String,TItemAmt:%String")
{
}

Storage Default
{
<Data name="SpecialItemFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPED50C.SpecialItemF6A8D</DataLocation>
<DefaultData>SpecialItemFindDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPED50C.SpecialItemF6A8D</IdLocation>
<IndexLocation>^web.DHCPED50C.SpecialItemF6A8I</IndexLocation>
<StreamLocation>^web.DHCPED50C.SpecialItemF6A8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
