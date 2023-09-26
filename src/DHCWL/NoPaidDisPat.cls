Class DHCWL.NoPaidDisPat Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yx
/// CreatDate：   2015-7-15
/// Description:  通过在院病人数据取出出院未结算病人的详细信息
/// Table：       DHCWL_Account.Period、DHCWL_Account.DayDetail
/// Input：       
///               
/// Return：      
/// d ##class(%ResultSet).RunQuery("DHCWL.NoPaidDisPat","GetNoPaidDisPat","2014-03-01","")
Query GetNoPaidDisPat(Qday As %String, type As %String) As %Query(ROWSPEC = "adm:%String,PatNo:%String,PatMedNo:%String,PatName:%String,PatAge:%String,PatSex:%String,PatReason:%String,admdate:%String,admdisdate:%String,Fee:%Float,Deposit:%Float,warramt:%Float,admLocDesc:%String,admWardDesc:%String") [ SqlProc ]
{
}

ClassMethod GetNoPaidDisPatExecute(ByRef qHandle As %Binary, Qday As %String, type As %String) As %Status
{
 k ^TEMPDHCWL($j)
 n (qHandle,Qday,type)
 Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 Set ind=1
 q:Qday="" $$$OK
 s day=$zdh(Qday,3)
 s AccPeriodID=0 f  s AccPeriodID=$o(^DHCWL.Account.PeriodI("AccDate",day,AccPeriodID))  q:AccPeriodID=""  d
 .d ##class(DHCWL.NoPaidDisPat).GetDeposit(AccPeriodID)
 .s accDataDr="" f  s accDataDr=$o(^DHCWL.Account.DayDetailI("AccType",AccPeriodID," C",accDataDr)) q:accDataDr=""  d
 ..s adm=$li($g(^DHCWL.Account.DayDetailD(accDataDr)),8) 
 ..//s disdate=$p(^PAADM(adm),"^",17)
 ..s disdate=$$GetAdmDisDate^DHCWLCommon(adm,"D")
 ..//w !,"disdate"_$zd(disdate,3)_"adm"_adm
 ..i disdate'="" s disdate=$zdh(disdate,3)
 ..i type=3 q:(disdate="")!(disdate>day)
 ..i type=2 q:(disdate'="")&(disdate<=day)
 ..//q:disdate>=day
 ..s Accfee=$fn($li($g(^DHCWL.Account.DayDetailD(accDataDr)),5),"",2)
 ..s ^TEMPDHCWL($j,"acc",adm)=$g(^TEMPDHCWL($j,"acc",adm))+Accfee
 s adm="" f  s adm=$o(^TEMPDHCWL($j,"acc",adm)) q:adm=""  d
 .s papmi=$p(^PAADM(adm),"^",1)
 .s PatNo=$$GetPapmiNo^DHCWLCommon(papmi)
 .s PatMedNo=$$GetPapmiMedtare^DHCWLCommon(papmi)
 .s PatName=$$GetPapmiName^DHCWLCommon(papmi)
 .s PatAge=$$GetAge^DHCWLCommon(papmi)
 .s PatSex=$$GetSex^DHCWLCommon(papmi)
 .s PatReason=$$GetReason^DHCWLCommon(adm)
 .//s admdate=$zd($p(^PAADM(adm),"^",6),3)
 .//s admdisdate=$p(^PAADM(adm),"^",17)
 .//i admdisdate="" s admdisdate=""
 .//e  s admdisdate=$zd(admdisdate,3)
 .s admdate=$$GetAdmDate^DHCWLCommon(adm)
 .s admdisdate=$$GetAdmDisDate^DHCWLCommon(adm,"D")
 .s admLocId=$p($g(^PAADM(adm)),"^",4)
 .s admLocDesc=$$GetDepDesc^DHCWLCommon(admLocId)
 .s admWardId=$p($g(^PAADM(adm)),"^",70)
 .s admWardDesc=$$GetWardDesc^DHCWLCommon(admWardId)
 .s Fee=$g(^TEMPDHCWL($j,"acc",adm))
 .s Deposit=$g(^TEMPDHCWL($j,"deposit"," "_adm))
 .s warramt=##class(DHCWL.NoPaidDisPat).IGetWarrAmt(adm)
 .q:Fee=0
 
 .s ^CacheTemp(repid,ind)=$lb(adm,PatNo,PatMedNo,PatName,PatAge,PatSex,PatReason,admdate,admdisdate,Fee,Deposit,warramt,admLocDesc,admWardDesc)
 .s ind=ind+1
 Set qHandle=$lb(0,repid,0)
 k ^TEMPDHCWL($j)
 Quit $$$OK
}

ClassMethod GetNoPaidDisPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNoPaidDisPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNoPaidDisPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNoPaidDisPatExecute ]
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

/// w ##class(DHCWL.NoPaidDisPat).GetDeposit("1")
ClassMethod GetDeposit(AccPeriodID)
{
	s Depositadm=0 f  s Depositadm=$o(^DHCWL.Account.DepositI("AccountADM",AccPeriodID,Depositadm)) q:Depositadm=""  d
	.s DepositId=0 f  s DepositId=$o(^DHCWL.Account.DepositI("AccountADM",AccPeriodID,Depositadm,DepositId)) q:DepositId=""  d
	..s deposit=$li(^DHCWL.Account.DepositD(DepositId),4)
	..s ^TEMPDHCWL($j,"deposit",Depositadm)=$g(^TEMPDHCWL($j,"deposit",Depositadm))+deposit
	q
}

/// w ##class(DHCWL.NoPaidDisPat).IGetDeposit("1")
ClassMethod IGetDeposit(adm)
{
	new (adm)
	quit:+adm=0 "0"
	set deposit=0
	
	;取押金
	if $d(^ARRCP("Adm_DR",+adm)) do
	.set arrcp="",dep=0,n=0 
	.for  set arrcp=$o(^ARRCP("Adm_DR",+adm,arrcp))  quit:arrcp=""  do
	..set arral=""  for  set arral=$o(^ARRCP("Adm_DR",adm,arrcp,arral))  quit:arral=""   do
	...quit:'$d(^DHCSFPRINTDETAIL(0,"RcptDR",arrcp))
	...set s=^ARRCP(arrcp,"RAL",arral),arpbl=$p(s,"^",18),flag=$p(s,"^",5),amt=+$p(s,"^",2)
	...set depttypedr=$p(s,"^",9)
	...quit:(depttypedr="")
	...quit:$d(^ARC("ARCDT",depttypedr))=0
	...set depttypedesc=$p(^ARC("ARCDT",depttypedr),"^",2)
	...quit:depttypedesc'["住院押金"
	...if +arpbl=0  s deposit=deposit+amt

	quit deposit
}

//取担保金额

//w ##class(DHCWL.NoPaidDisPat).IGetWarrAmt("1")

ClassMethod IGetWarrAmt(adm)
{
	new (adm)
	quit:+adm=0 "0"
	set warramt=0
	
	;取担保金额
	if $d(^DHCWARRANT(0,"ADM",adm)) do
	.set wdr=""
	.for  set wdr=$o(^DHCWARRANT(0,"ADM",adm,wdr)) quit:wdr=""  do
	..set ss=^DHCWARRANT(wdr)
	..set status=$p(ss,"^",8)
	..quit:(status'="Y")
	..set ltd=$p(ss,"^",4)
	..quit:(ltd<+$h)&(ltd'="")
	..set warramt=warramt+$p(ss,"^",2)
	
	quit warramt
}

}
