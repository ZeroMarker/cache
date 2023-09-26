Class DHCWL.AccFeeByDepItem Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ycm
/// CreatDate：   2015-09-07
/// Description:  通过在院病人数据取出病人科室的在院费用情况
/// Table：       DHCWL_Account.Period、DHCWL_Account.DayDetail
/// Input：       
///               
/// Return：      
/// d ##class(%ResultSet).RunQuery("DHCWL.AccFeeByDepItem","GetDepfee","2014-03-01")
Query GetDepfee(Qday As %String) As %Query(ROWSPEC = "PatDepdr:%String,PatDepCode:%String,PatDepDesc:%String,ItemDr:%String,ItemDesc:%String,mStItem:%String,fee:%Float") [ SqlProc ]
{
}

ClassMethod GetDepfeeExecute(ByRef qHandle As %Binary, Qday As %String) As %Status
{
 k ^TEMPDHCWL($j)
 n (qHandle,Qday)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:Qday="" $$$OK
 s day=$zdh(Qday,3)
 s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",day,AccPeriodID))  q:AccPeriodID=""  d
 .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID," C",accDataDr)) q:accDataDr=""  d
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ..s Accfee=$fn($li($g(^DHCWL.Account.DayDetailD(accDataDr)),5),"",2)
 ..s PatDepdr=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),7)
 ..s ItemDr=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),6)
 ..s ^TEMPDHCWL($j,"NoPaid",PatDepdr,ItemDr,"fee")=+$g(^TEMPDHCWL($j,"NoPaid",PatDepdr,ItemDr,"fee"))+Accfee
 
 s PatDepdr=0
 f  s PatDepdr=$O(^TEMPDHCWL($j,"NoPaid",PatDepdr)) Q:PatDepdr=""  d
 .s PatDepDesc="",PatDepCode=""
 .i $D(^CTLOC(PatDepdr)) s PatDepDesc=$P(^CTLOC(PatDepdr),"^",2)
 .i PatDepDesc["-" s PatDepDesc=$P(PatDepDesc,"-",2)
 .i $D(^CTLOC(PatDepdr)) s PatDepCode=$p(^CTLOC(PatDepdr),"^",16)   
 .s ItemDr=""
 .f  s ItemDr=$O(^TEMPDHCWL($j,"NoPaid",PatDepdr,ItemDr)) Q:ItemDr=""  d
 ..s fee=+$g(^TEMPDHCWL($j,"NoPaid",PatDepdr,ItemDr,"fee"))
 ..//s mWLStat=+ItemDr,mStItem=$P(ItemDr,"||",2)
 ..//s ItemDesc=$P(^DHCWLSTAT(mWLStat,"ITEM",mStItem),"^",2)
 ..i $d(^DHCWL.CodeCfg.SubGroupD(ItemDr)) s ItemDesc=$li(^DHCWL.CodeCfg.SubGroupD(ItemDr),3)
 ..else  s ItemDesc=""
 ..s ^CacheTemp(repid,ind)=$lb(PatDepdr,PatDepCode,PatDepDesc,ItemDr,ItemDesc,mStItem,fee)
 ..s ind=ind+1
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
}

ClassMethod GetDepfeeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDepfeeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDepfeeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDepfeeExecute ]
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

}
