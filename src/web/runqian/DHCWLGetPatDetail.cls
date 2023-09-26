Class web.runqian.DHCWLGetPatDetail Extends %RegisteredObject [ ProcedureBlock ]
{

// d ##class(%ResultSet).RunQuery("web.runqian.DHCWLGetPatDetail","NewQuery1","2014-02-15","2014-02-15")

Query NewQuery1(StDate As %String, EnDate As %String) As %Query(ROWSPEC = "ItemDesc:%String,PATH:%Float,PATI:%Float,PATC:%Float,PATLast:%Float") [ SqlProc ]
{
}

ClassMethod NewQuery1Execute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String) As %Status [ SqlProc ]
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:StDate="" $$$OK
 q:EnDate="" $$$OK
 k ^TMPDayDetail($j)
 s StDate=$zdh(StDate,3)
 s EnDate=$zdh(EnDate,3)
 d ..QueryC(EnDate)
 d ..QueryLastFee(StDate)
 f DATE=StDate:1:EnDate d
 .s AccPeriodID=""
 .f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",DATE,AccPeriodID))  q:AccPeriodID=""  d
 ..d ..Query(AccPeriodID)
 
 s statCode="ACCItemGrp"
 s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_$zcvt(statCode,"U"),""))
 ;s grpTypeDr=$li(^DHCWL.CodeCfg.GroupD(grpId),7) 
 ;s statType=$li(^DHCWL.CodeCfg.TypeD(grpTypeDr),2)        
 s itemstatDr=0  f  s itemstatDr=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,itemstatDr)) q:itemstatDr=""  d
 .s ItemDesc=$li(^DHCWL.CodeCfg.SubGroupD(itemstatDr),3)
 
 .//s StitSub=0 f  s StitSub=$o(^DHCWLSTAT(statCode,"ITEM",StitSub)) q:StitSub=""  d
 .//s ItemDesc=$p(^DHCWLSTAT(statCode,"ITEM",StitSub),"^",2)
 .//s itemstatDr=statCode_"||"_StitSub
 .w !,ItemDesc_"^"_+$g(^TMPDayDetail($j,itemstatDr," H"))_"^"_+$g(^TMPDayDetail($j,itemstatDr," I"))_"^"_+$g(^TMPDayDetail($j,itemstatDr," C")) 
 .s PATH=+$g(^TMPDayDetail($j,itemstatDr," H"))
 .s PATI=+$g(^TMPDayDetail($j,itemstatDr," I"))
 .s PATC=+$g(^TMPDayDetail($j,itemstatDr," C"))
 .s PATLast=+$g(^TMPDayDetail($j,itemstatDr,"Last"))
 .d OutputRow
 k ^TMPDayDetail($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow
	set Data=$lb(ItemDesc,PATH,PATI,PATC,PATLast)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NewQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute, SqlProc ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute, SqlProc ]
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

ClassMethod QueryC(DATE) As %Status [ SqlProc ]
{
 
 s AccPeriodID=""
 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",DATE,AccPeriodID))  q:AccPeriodID=""  d
 .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID," C",accDataDr)) q:accDataDr=""  d 
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8)
 ..s admReasonDr=$p($g(^PAADM(adm,1)),"^",7)
 ..s fee=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),5)
 ..s itemDr=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),6)
 ..s ^TMPDayDetail($j,itemDr," C")=$g(^TMPDayDetail($j,itemDr," C"))+fee
 ..s ^TMPDayDetail($j," C")=$g(^TMPDayDetail($j," C"))+fee
 q
}

ClassMethod QueryLastFee(DATE) As %Status [ SqlProc ]
{
 s LastDay=DATE-1
 s PeriodID=""
 f  s PeriodID=$o(^DHCWL.Account.PeriodI("AccDate",LastDay,PeriodID)) q:PeriodID=""  d
 .s accDataDr="" 
 .f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",PeriodID," C",accDataDr)) q:accDataDr=""  d
 ..s Loc=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),7)
 ..s ward=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),12)
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ..s lastPatFee=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),5)
 ..s itemDr=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),6)
 ..s ^TMPDayDetail($j,itemDr,"Last")=$g(^TMPDayDetail($j,itemDr,"Last"))+lastPatFee
 ..s ^TMPDayDetail($j,"Last")=$g(^TMPDayDetail($j,"Last"))+lastPatFee
 q
}

ClassMethod Query(wlaccDr) As %Status [ SqlProc ]
{
 									
 s typeIndex=""  f  s typeIndex=$o(^DHCWL.Account.DayDetailI("AccType",wlaccDr,typeIndex)) q:typeIndex=""  d
 .q:typeIndex=" C"
 .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",wlaccDr,typeIndex,accDataDr)) q:accDataDr=""  d
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8)
 ..s admReasonDr=$p($g(^PAADM(adm,1)),"^",7)
 ..s fee=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),5)
 ..s itemDr=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),6)
 ..s ^TMPDayDetail($j,itemDr,typeIndex)=$g(^TMPDayDetail($j,itemDr,typeIndex))+fee
 ..s ^TMPDayDetail($j,typeIndex)=$g(^TMPDayDetail($j,typeIndex))+fee
 q
}

}
