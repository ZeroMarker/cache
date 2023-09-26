Class web.runqian.DHCWLGetPatFullDetail Extends %RegisteredObject
{

//d ##class(%ResultSet).RunQuery("web.runqian.DHCWLGetPatFullDetail","NewQuery1","2011-06-01","2011-06-30")

Query NewQuery1(StDate As %String, EnDate As %String) As %Query(ROWSPEC = "AccLoc:%String,AccWard:%String,adm:%String,PatNo:%String,PatName:%String,PATLast:%String,PATH:%String,PATI:%String,PATC:%String") [ SqlProc ]
{
}

ClassMethod NewQuery1Execute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String) As %Status
{
  
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:StDate="" $$$OK
 q:EnDate="" $$$OK
 k ^TMPDayDetail($j)
 s StDate=$zdh(StDate,3)
 s EnDate=$zdh(EnDate,3)
 d ..CreatCFee(EnDate)
 d ..CreatLastFee(StDate)
 f DATE=StDate:1:EnDate d
 .s AccPeriodID=""
 .f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",DATE,AccPeriodID))  q:AccPeriodID=""  d
 ..d ..QueryDetail(AccPeriodID,DATE) 
 s adm="" f  s adm=$o(^TMPDayDetail($j,"PatDet",adm)) q:adm=""  d
 .s Loc="" f  s Loc=$o(^TMPDayDetail($j,"PatDet",adm,Loc)) q:Loc=""  d
 ..s ward=""  f  s ward=$o(^TMPDayDetail($j,"PatDet",adm,Loc,ward)) q:ward=""  d
 ...s papmi=$p(^PAADM(adm),"^",1)
 ...s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
 ...s PatName=$$GetPapmiName^DHCWLCommon(papmi)
 ...s AccLoc=$$GetDepDesc^DHCWLCommon(Loc)
 ...s AccWard=$$GetDepDesc^DHCWLCommon(ward)
 ...s ^TMPDayDetail($j,"AdmFee",adm,Loc,ward," H")=+$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward," H"))
 ...s ^TMPDayDetail($j,"AdmFee",adm,Loc,ward," I")=+$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward," I"))
 ...s ^TMPDayDetail($j,"AdmFee",adm,Loc,ward," C")=+$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward," C"))
 ...s ^TMPDayDetail($j,"AdmFee",adm,Loc,ward,"Last")=+$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward,"Last"))
 ...s PATH=(^TMPDayDetail($j,"AdmFee",adm,Loc,ward," H"))
 ...s PATI=(^TMPDayDetail($j,"AdmFee",adm,Loc,ward," I"))
 ...s PATC=(^TMPDayDetail($j,"AdmFee",adm,Loc,ward," C"))
 ...s PATLast=(^TMPDayDetail($j,"AdmFee",adm,Loc,ward,"Last"))
 ...i (PATLast=0)&(PATI=0)&(PATH=0)&(PATC=0)  q
 ...;w !,AccLoc_"^"_adm_"^"_PatNo_"^"_PatName_"^"_PATLast_"^"_PATH_"^"_PATI_"^"_PATC
 ...d OutputRow
 k ^TMPDayDetail($j)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
	
	
OutputRow
	set Data=$lb(AccLoc,AccWard,adm,PatNo,PatName,PATLast,PATH,PATI,PATC)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod NewQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = NewQuery1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod NewQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = NewQuery1Execute ]
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

ClassMethod QueryDetail(wlaccDr, DATE) As %Status
{
     s typeIndex=""  f  s typeIndex=$o(^DHCWL.Account.DayDetailI("AccType",wlaccDr,typeIndex)) q:typeIndex=""  d
     .q:typeIndex=" C"
     .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",wlaccDr,typeIndex,accDataDr)) q:accDataDr=""  d
     ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
     ..s papmi=$p(^PAADM(adm),"^",1)
     ..s free=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),5)
     ..s Loc=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),7)
     ..s ward=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),12)
     ..s ^TMPDayDetail($j,"PatDet",adm,Loc,ward,typeIndex)=$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward,typeIndex))+free
     q
}

ClassMethod CreatCFee(DATE) As %Status
{
 s PeriodID=""
 f  s PeriodID=$o(^DHCWL.Account.PeriodI("AccDate",DATE,PeriodID)) q:PeriodID=""  d
 .s accDataDr="" 
 .f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",PeriodID," C",accDataDr)) q:accDataDr=""  d
 ..s Loc=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),7)
 ..s ward=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),12)
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ..s lastPatFee=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),5)
 ..s ^TMPDayDetail($j,"PatDet",adm,Loc,ward," C")=$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward," C"))+lastPatFee
 ..;w ^TMPDayDetail($j,"PatDet",adm,Loc,"C")
 q
}

ClassMethod CreatLastFee(DATE) As %Status
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
 ..s ^TMPDayDetail($j,"PatDet",adm,Loc,ward,"Last")=$g(^TMPDayDetail($j,"PatDet",adm,Loc,ward,"Last"))+lastPatFee
 ..;w ^TMPDayDetail($j,"PatDet",adm,Loc,"Last")
 q
}

}
