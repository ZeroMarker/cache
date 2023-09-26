Import SQLUser

Class web.DHCOPBillAliBalanceAcount Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod HisTradeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisTradeDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod HisTradeDetailExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, Guser As %String, job As %String, UserName As %String, UserDR As %String, PAPERNo As %String, PAPERName As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 
 i StDate="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
 i EndDate="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
 ;i Guser="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
 ;i job="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
 ;w !,StDate_"^"_EndDate_"^"_Guser_"^"_job_"^"_UserName_"^"_UserDR_"^"_ PAPERNo _"^"_ PAPERName
 s Tjob=job
 s TotalAmt=0
 f PrtDate=StDate:1:EndDate  d
 .s TradeTime="0"
 .f  s TradeTime=$o(^DHCINVALITPi(0,"HISDTIME",PrtDate,TradeTime))  q:(TradeTime="")  d
 ..s IBPRowid="0"
 ..f  s IBPRowid=$o(^DHCINVALITPi(0,"HISDTIME",PrtDate,TradeTime,IBPRowid))  q:(IBPRowid="")  d
 ...s TTradeNo=$p(^DHCINVALITP(IBPRowid),"^",7)
 ...;q:(TTradeNo="")
 ...s HisTradeTypeCode=$p(^DHCINVALITP(IBPRowid),"^",24)
 ...;q:HisTradeTypeCode'="D"
 ...s THisTradeChannel=$p(^DHCINVALITP(IBPRowid),"^",31)
 ...q:(THisTradeChannel'["wechatpay")
 ...s IBSSub="0",IBSNum=0,InvPrtRowid=""
 ...s TPAPERNo="", TPAPERName="",TAcountDesc="",TTradeRc="",PAERDR=""
 ...s TTradeRc=$p(^DHCINVALITP(IBPRowid),"^",1)
 ...f  s IBSSub=$o(^DHCINVALITP(IBPRowid,"C",IBSSub))  q:(IBSSub="")  d
 ....s InvPrtRowid=$p(^DHCINVALITP(IBPRowid,"C",IBSSub),"^",1)
 ....q:(InvPrtRowid="")
 ....q:($d(^DHCINVPRT(InvPrtRowid))=0)
 ....q:($g(^DHCINVPRT(InvPrtRowid))="")
 ....s IBSNum=IBSNum+1
 ...q:(TTradeRc'="0000")&(IBSNum=0)
 ...s THisTradeNo=$p(^DHCINVALITP(IBPRowid),"^",32)
 ...i InvPrtRowid'=""  d
 ....s PAERDR=$p($g(^DHCINVPRT(InvPrtRowid)),"^",15)
 ....i PAERDR'=""  d
 .....s TPAPERNo=$p(^PAPER(PAERDR,"PAT",1),"^",2)
 .....s TPAPERName=$p(^PAPER(PAERDR,"ALL"),"^",1) 
 ...s TBankCardNo=$p(^DHCINVALITP(IBPRowid),"^",3)
 ...s TTradeAmt=$p(^DHCINVALITP(IBPRowid),"^",23)
 ...s TTradeAmt=$j(TTradeAmt,3,2)
 ...s TTradeType=""
 ...i HisTradeTypeCode="C"  d
 ....s TTradeType="扣费"
 ...i HisTradeTypeCode="D"  d
 ....s TTradeType="退费" 
 ...s UserDr=$p(^DHCINVALITP(IBPRowid),"^",25)
 ...s TTradeUser="",TradeUserCode=""
 ...i UserDr'=""  d
 ....s TTradeUser=$p(^SSU("SSUSR",UserDr),"^",2)
 ....s TradeUserCode=$p(^SSU("SSUSR",UserDr),"^",1)
 ...s TTradeClientType=""
 ...;w !,TradeUserCode
 ...i (TradeUserCode="alipay001")!(TradeUserCode="wechat001")  d
 ....s TTradeClientType="手机端" 
 ...e  d
 ....s TTradeClientType="窗口" 	
 ...s TTradeRowid=IBPRowid
 ...s TTradeDate=$zd(PrtDate,3)_" "_$zt(TradeTime,1)
 ...s TOldTradeRowid=$p(^DHCINVALITP(IBPRowid),"^",33)
 ...;w !,"#"_PAPERNo_"#"
 ...q:(+PAPERNo'=0)&&(TPAPERNo'[PAPERNo)
 ...q:(PAPERName'="")&&(PAPERName'=" ")&&(TPAPERName'[PAPERName)
 ...i HisTradeTypeCode="C" s TotalAmt=TotalAmt+TTradeAmt
 ...i HisTradeTypeCode="D" s TotalAmt=TotalAmt-TTradeAmt
 ...Do OutputRow3	
 s (TPAPERNo,TPAPERName,TBankCardNo,TTradeRc,TTradeNo,TTradeAmt,TTradeType,TTradeClientType,TTradeUser,TTradeRcDetail,TTradeRowid,TJob,TTradeDate,TOldTradeRowid,THisTradeNo)=""
 s TTradeNo="合计",TTradeAmt=$fn(TotalAmt,"",2)
 Do OutputRow3
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow3
	set Data=$lb(TPAPERNo,TPAPERName,TBankCardNo,TTradeRc,TTradeNo,TTradeAmt,TTradeType,TTradeClientType,TTradeUser,TTradeRcDetail,TTradeRowid,TJob,TTradeDate,$g(TOldTradeRowid),THisTradeNo)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod HisTradeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisTradeDetailExecute ]
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

Query HisTradeDetail(StDate As %String, EndDate As %String, Guser As %String, job As %String, UserName As %String, UserDR As %String, PAPERNo As %String, PAPERName As %String) As %Query(ROWSPEC = "TPAPERNo:%String,TPAPERName:%String,TBankCardNo:%String,TTradeRc:%String,TTradeNo:%String,TTradeAmt:%String,TTradeType:%String,TTradeClientType:%String,TTradeUser:%String,TTradeRcDetail:%String,TTradeRowid:%String,TJob:%String,TTradeDate:%String,TOldTradeRowid:%String,THisTradeNo:%String")
{
}

ClassMethod GetCurJob()
{
 s job=+$j	
 q job
}

ClassMethod CheckINVDetail(TradeRowid)
{
 ///k ^TMP("DHCOPBill","POSCPP",Guser,job)
 ///w ##class(web.DHCOPBillBalanceAcount).CheckINVDetail(207)
 q:(TradeRowid="") "TradeNull"
 s IBSSub="0",IBSNum=0,InvPrtRowid="",PAPERDR="",PAPERName="",PAPERNo="",TradeNo="",BankCardNo="",TradeAmt=0.00
 s BankCardNo=$p($g(^DHCINVALITP(TradeRowid)),"^",3)
 s TradeAmt=$p($g(^DHCINVALITP(TradeRowid)),"^",4)
 s TradeNo=$p($g(^DHCINVALITP(TradeRowid)),"^",5)
 s TradeRc=$p($g(^DHCINVALITP(TradeRowid)),"^",1)
 s BankTradeType=$p($g(^DHCINVALITP(TradeRowid)),"^",24)
 s PrtRowid="",InitPrtRowid="",NewPrtRowid=""
 f  s IBSSub=$o(^DHCINVALITP(TradeRowid,"C",IBSSub))  q:(IBSSub="")  d
 .s InvPrtRowid=$p(^DHCINVALITP(TradeRowid,"C",IBSSub),"^",1)
 .q:(InvPrtRowid="")
 .q:($d(^DHCINVPRT(InvPrtRowid))=0)
 .q:($g(^DHCINVPRT(InvPrtRowid))="")
 .s IBSNum=IBSNum+1  
 .i BankTradeType="T"  d
 ..s PrtFlag=$p(^DHCINVPRT(InvPrtRowid),"^",8)
 ..s InitDR=$p(^DHCINVPRT(InvPrtRowid),"^",13)
 ..s OldPrtRowid=$p(^DHCINVPRT(InvPrtRowid),"^",29)  
 ..i (PrtFlag'="N")&(PrtFlag'="")  d
 ...s PrtRowid=InitDR
 ...s InitPrtRowid=InvPrtRowid
 ..i (OldPrtRowid'="")&(InitDR="")  d
 ...s NewPrtRowid=InvPrtRowid      
 s Charge=0,SFCharge=0,TFCharge=0
 i NewPrtRowid'=""  d
 .s SFCharge=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(NewPrtRowid)
 s BJYNum=0
 
 i +InitPrtRowid'=0  d
 .s TFCharge=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(InitPrtRowid)
 .s BJYTradeDR="0"
 .f  s BJYTradeDR=$o(^DHCINVALITPi(0,"S","IPDR",InitPrtRowid,BJYTradeDR))  q:(BJYTradeDR="")  d
 ..s BJYTradeRc=$p($g(^DHCINVALITP(BJYTradeDR)),"^",1)
 ..q:(BJYTradeRc'="00")
 ..s IBSSubDR="0"
 ..f  s IBSSubDR=$o(^DHCINVALITPi(0,"S","IPDR",InitPrtRowid,BJYTradeDR,IBSSubDR))  q:(IBSSubDR="")  d
 ...s BJYNum=BJYNum+1 
 
 s Charge=SFCharge-TFCharge
 s Charge=$zabs(Charge)
 s Charge=$j(Charge,3,2) 
 ///modify 2013-10-14 判断退费发票是否已经补过交易
 
 
 q:(IBSNum=0) "0^"_PAPERDR_"^"_PAPERName_"^"_PAPERNo_"^"_TradeNo_"^"_BankCardNo_"^"_$j(TradeAmt,3,2)_"^"_TradeRc_"^"_BankTradeType_"^"_PrtRowid_"^"_InitPrtRowid_"^"_NewPrtRowid_"^"_Charge_"^"_BJYNum
 i InvPrtRowid'=""  d
 .s PAPERDR=$p($g(^DHCINVPRT(InvPrtRowid)),"^",15)
 .i PAPERDR'=""  d
 ..s PAPERNo=$p(^PAPER(PAPERDR,"PAT",1),"^",2)
 ..s PAPERName=$p(^PAPER(PAPERDR,"ALL"),"^",1) 
 
 q IBSNum_"^"_PAPERDR_"^"_PAPERName_"^"_PAPERNo_"^"_TradeNo_"^"_BankCardNo_"^"_$j(TradeAmt,3,2)_"^"_TradeRc_"^"_BankTradeType_"^"_PrtRowid_"^"_InitPrtRowid_"^"_NewPrtRowid_"^"_Charge_"^"_BJYNum
}

ClassMethod POSINVDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = POSINVDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod POSINVDetailExecute(ByRef qHandle As %Binary, TradeRowid As %String, PAPERNo As %String, PAPERName As %String, BankCardNo As %String, TradeAmt As %String, TradeNo As %String, PAPERDR As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 s ind=1
 i TradeRowid="" Set qHandle=$lb(0,repid,0)	Quit $$$OK
 s IBSSub="0",INVNum=0
 f  s IBSSub=$o(^DHCINVALITP(TradeRowid,"C",IBSSub))  q:(IBSSub="")  d
 .s InvPrtRowid=$p(^DHCINVALITP(TradeRowid,"C",IBSSub),"^",1)
 .q:(InvPrtRowid="")
 .q:($d(^DHCINVPRT(InvPrtRowid))=0)
 .q:($g(^DHCINVPRT(InvPrtRowid))="")
 .s INVNum=0
 .s TInvNo=$p(^DHCINVPRT(InvPrtRowid),"^",14)
 .s TPrtDate=$p(^DHCINVPRT(InvPrtRowid),"^",5)
 .i TPrtDate'=""  s TPrtDate=$zd(TPrtDate,3)
 .s PrtTime=$p(^DHCINVPRT(InvPrtRowid),"^",20)
 .i PrtTime'=""  s PrtTime=$zt(PrtTime,1)
 .s TPrtDate=TPrtDate_" "_PrtTime
 .s TInvStatusCode=$p(^DHCINVPRT(InvPrtRowid),"^",8)
 .s Invinit=$p(^DHCINVPRT(InvPrtRowid),"^",13)
 .i TInvStatusCode="N"  d
 ..s TInvStatus="正常"    	
 .i (TInvStatusCode="S")&(Invinit="")  d
 ..s TInvStatus="被红冲"
 .i (TInvStatusCode="A")&(Invinit="")  d
 ..s TInvStatus="被作废"
 .i (TInvStatusCode="S")&(Invinit="")  d
 ..s TInvStatus="红冲"
 .i (TInvStatusCode="A")&(Invinit="")  d
 ..s TInvStatus="作废"
 .s TUserDr=$p(^DHCINVPRT(InvPrtRowid),"^",21)
 .s TUserName=""
 .i TUserDr'=""  d
 ..s TUserName=$p(^SSU("SSUSR",TUserDr),"^",2) 
 .s TInvRowid=InvPrtRowid
 .s DHCBCIRowid="0"
 .f  s DHCBCIRowid=$o(^DHCBCI(0,"INV",InvPrtRowid,DHCBCIRowid))  q:(DHCBCIRowid="")  d
 ..s DHCPB=$p(^DHCBCI(DHCBCIRowid),"^",2)
 ..q:(DHCPB="")
 ..s PBOSub="0"
 ..f  s PBOSub=$o(^DHCPB(DHCPB,"O",PBOSub))  q:(PBOSub="")  d
 ...s OEORIRowid=$p(^DHCPB(DHCPB,"O",PBOSub),"^",4)
 ...s ARCIMRowid=$p(^DHCPB(DHCPB,"O",PBOSub),"^",3)
 ...q:(OEORIRowid="")
 ...q:(ARCIMRowid="")
 ...s TotalAmount=$p(^DHCPB(DHCPB,"O",PBOSub),"^",8)
 ...q:(TotalAmount=0)
 ...s TOrdeName=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
 ...s Qty=$p(^DHCPB(DHCPB,"O",PBOSub),"^",5)
 ...s RefundQty=$p(^DHCPB(DHCPB,"O",PBOSub),"^",6)
 ...s TOrderQty=Qty+RefundQty
 ...s TOrderAmt=$j(TotalAmount,3,2)  
 ...s confac=##class(web.DHCOPCashier).GetUomConvFactor(ARCIMRowid)
 ...i +confac=0  s confac=1
 ...s TOrderQty=TOrderQty/confac
 ...i INVNum>0  d
 ....s TInvNo=""
 ....s TPrtDate=""
 ....s TInvStatus=""    	
 ....s TUserName=""
 ...s INVNum=INVNum+1
 ...s RecLocDr=$p(^OEORD(+OEORIRowid,"I",$p(OEORIRowid,"||",2),3),"^",6)
 ...s TOrderRecLoc=""
 ...i RecLocDr'=""  d
 ....s TOrderRecLoc=$p(^CTLOC(RecLocDr),"^",2)
 ....i $f(TOrderRecLoc,"-")'=0  d
 .....s TOrderRecLoc=$p(TOrderRecLoc,"-",2)
 ...s TOrderRowid=OEORIRowid  
 ...Do OutputRow4	
	
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow4
	set Data=$lb(TInvNo,TPrtDate,TINVAmt,TInvStatus,TUserName,TOrdeName,TOrderAmt,TOrderQty,TOrderRecLoc,TOrderRowid,TInvRowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod POSINVDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = POSINVDetailExecute ]
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

Query POSINVDetail(TradeRowid As %String, PAPERNo As %String, PAPERName As %String, BankCardNo As %String, TradeAmt As %String, TradeNo As %String, PAPERDR As %String) As %Query(ROWSPEC = "TInvNo:%String,TPrtDate:%String,TINVAmt:%String,TInvStatus:%String,TUserName:%String,TOrdeName:%String,TOrderAmt:%String,TOrderQty:%String,TOrderRecLoc:%String,TOrderRowid:%String,TInvRowid:%String")
{
}

ClassMethod AliTradeDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AliTradeDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod AliTradeDetailExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	;w !,StDate_"^"_EndDate
	s TotalAmt=0
	f Date=StDate:1:EndDate d
	.s IBTRowID=""
	.f  s IBTRowID=$o(^User.DHCINVAliBalanceI("BANKFINDATE",Date,IBTRowID)) q:IBTRowID=""  d
	..q:+IBTRowID=0
	..;q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
	..s THISTradeNo=$LIST(^User.DHCINVAliBalanceD(IBTRowID),7)
	..s IBTPaymodeDr=$LIST(^User.DHCINVAliBalanceD(IBTRowID),10)
	..;w !,IBTPaymodeDr_"^"_IBTRowID
	..q:(IBTPaymodeDr'=$o(^CT("CTPM",0,"Code","WECHATPAY","")))&&((IBTPaymodeDr'=$o(^CT("CTPM",0,"Code","ALIPAY",""))))
	..s TClientType="微信"
	..s TTradeAmt=$LIST(^User.DHCINVAliBalanceD(IBTRowID),12)
	..s TTradeno=$LIST(^User.DHCINVAliBalanceD(IBTRowID),5)
	..s THISTradeNo=$LIST(^User.DHCINVAliBalanceD(IBTRowID),7)
	..s TBankCardNo="" ;$LIST(^User.DHCINVAliBalanceD(IBTRowID),2)
	..s IBTTradeFlag=$LIST(^User.DHCINVAliBalanceD(IBTRowID),13)
	..s TTradeType=""
	..i IBTTradeFlag=0 s TTradeType="扣费"
	..i IBTTradeFlag=1 s TTradeType="退费"
	..s TTradeDate=$LIST(^User.DHCINVAliBalanceD(IBTRowID),6)
	..s TTradeDate=$e(TTradeDate,1,4)_"-"_$e(TTradeDate,5,6)_"-"_$e(TTradeDate,7,8)_" "_$e(TTradeDate,9,10)_":"_$e(TTradeDate,11,12)_":"_$e(TTradeDate,13,14)
	..i IBTTradeFlag="0" s TotalAmt=TotalAmt+TTradeAmt
    ..i IBTTradeFlag="1" s TotalAmt=TotalAmt-TTradeAmt
    ..;w !,IBTRowID
	..Do OutputRow2
	 s (TTradeno,THISTradeNo,TTradeType,TClientType,TTradeAmt,TTradeDate)=""
	 s TTradeAmt=TotalAmt
	 
	 s TClientType="合计"
	 Do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(TTradeno,THISTradeNo,TTradeType,TClientType,TTradeAmt,TTradeDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod AliTradeDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AliTradeDetailExecute ]
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

Query AliTradeDetail(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "TTradeno:%String,THISTradeNo:%String,TTradeType:%String,TClientType:%String,TTradeAmt:%String,TTradeDate:%String")
{
}

ClassMethod FindAccPrtInvDailyExecute(ByRef qHandle As %Binary, StDate, EndDate, Guser, HandinFlag, JkDr, HandinType, Hospital, InsType, ApplyType, MyUser, InvType, InvFlag) As %Status
{
	;                                                                      63112,63112,1334,Y,,1,,,,,A,
    ;w ##class(%ResultSet).RunQuery("web.DHCOPBillAccDaily","FindAccPrtInvDaily",63112,63112,1334,"Y","",1,"","","","","A","")
    ;w !,StDate_","_EndDate_","_Guser_","_HandinFlag_","_JkDr_","_HandinType_","_Hospital_","_InsType_","_ApplyType_","_MyUser_","_InvType_","_InvFlag
    i $g(Guser)=""  s Guser=$G(%session.Data("LOGON.USERID"))
	;i Hospital="" s Hospital=$G(%session.Data("LOGON.HOSPID"))
	Set repid=$I(^CacheTemp)
    i (StDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
    ;i (JkDr="")&&(HandinFlag="Y")   Set qHandle=$lb(0,repid,0) 	  Quit $$$OK
    i (HandinType="")  s HandinType=1 
    
    i (MyUser="") s MyUserId=""
    s ind=1
    s job=$j
    s (invno,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr,RoundErr)=""
 	s tmp=$zdh("2012-02-10",3)
    s:StDate<tmp StDate=tmp
    i HandinFlag="N"  d   ;未交帐日报表
    .d ..GetInvNotHandin(StDate, EndDate,Guser,HandinFlag,JkDr,HandinType,Hospital,InsType,ApplyType,MyUserId,InvType,InvFlag)
    e  d           ;已交帐报表
    .;d ..GetInvHandin(JkDr,Guser,HandinType,Hospital,InsType,ApplyType,MyUserId)
    .d ..GetInvHandin(StDate, EndDate,Guser,HandinFlag,JkDr,HandinType,Hospital,InsType,ApplyType,MyUserId,InvType,InvFlag)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod FindAccPrtInvDailyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAccPrtInvDailyExecute ]
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

ClassMethod FindAccPrtInvDailyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAccPrtInvDailyExecute ]
{
   //住院收费员查询
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query FindAccPrtInvDaily(StDate, EndDate, Guser, HandinFlag, JkDr, HandinType, Hospital, InsType, ApplyType, MyUser, InvType, InvFlag) As %Query(ROWSPEC = "TInd,TRowId,TPrtUserCode,TPrtUserName,TPrtDate,TPrtTime,TPatName,TPatNo,Tamt,TPrtStatus,THandleDr,TJob,TRoundErr,TPaym1,TPaym2,TPaym3,TPaym4,TPaym5,TPaym6,TPaym7,TPaym8,TPaym9,TPaym10,TPaym11,TPaym12,TPaym13,TPaym14,TPaym15,TPaym16,TPaym17,TPaym18,TPaym19,TPaym20")
{
}

ClassMethod GetInvNotHandin(StDate, EndDate, Guser, Handin, JkDr, HandinType, Hospital, InsType, ApplyType, MyUserId, InvType, InvFlag)
{
	k ^TMP("MZJF","EPInvDailyHand",Guser,job)
  	k ^TMP("OPBILL","CateFee",Guser,job)
    k ^TMP("OPBILL","PayMode",Guser,job)
    k ^TMP("OPBILL","OPRoundErr",Guser,job)
    k ^TMP("DHCOPBILL","AdmReason",Guser,job)
    k ^TMP("DHCOPBill","DailyHandin")  //打印
    k ^TMP("invDailyHandin") //
    ;s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(Guser)
	s TabFlag="",n=0,Sum=0,PaySum=0,RoundErrSum=0
	
	i InvType="全部"  s InvFlag="A"
	i InvType=""  s InvFlag="A"
	i InvType="A"  s InvFlag="A"
	i InvType="门诊"  s InvFlag="F"
	i InvType="挂号"  s InvFlag="R"
	;
    ;存放支付方式金额
    ;b ;122
	f i=1:1:20  d
	.s paym(i)=0.00
	f Date=StDate:1:EndDate d
    .s RowId=""
    .f  s RowId=$o(^DHCINVPRT(0,"Date",Date,RowId)) q:RowId=""  d
    ..s invInfo=$g(^DHCINVPRT(RowId))
    ..s prtuser=$p(invInfo,"^",21)
	..s prtUserName=$p(^SSU("SSUSR",prtuser),"^",2)
    ..s invHospDR=$p(invInfo,"^",39)  ;医院ID
    ..;q:(Hospital'="")&&(+Hospital'=+invHospDR) ;add wangjian  2012-09-04
    ..;s:prtuser'="" prtuser=$p($g(^SSU("SSUSR",prtuser)),"^",2)
    ..s handdr=$p(invInfo,"^",6)
    ..q:handdr'=""  ;过滤已结算记录
    ..s prtfairtype=$p(invInfo,"^",34)  ;prt_fairtype (F:发票，R:挂号)
    ..q:(prtfairtype'="F")&(prtfairtype'="R")
    ..q:(InvFlag'="A")&(prtfairtype'=InvFlag)
    ..;q:(prtfairtype'="F")
    ..s prtUserCode=$p(^SSU("SSUSR",prtuser),"^",1)
    ..q:(prtUserCode'["alipay")
    ..s prinvptrflag=$p(invInfo,"^",3)  ;PRT_INVPrintFlag
    ..s invSub=$o(^DHCINVPRT(RowId,"P",0))  ;dhc_invpaymode
    ..s paymDesc=""
    ..s IPM=""
	..f  s IPM=$o(^DHCINVPRT(RowId,"P",IPM),-1) q:+IPM=0  d
	...s s=$g(^DHCINVPRT(RowId,"P",IPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s PayMHandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	...i +PayMHandDr>0 d
	....s paymsum=$p(s,"^",3)
	....s paymsumflag=paymsum
	....s paymDesc=$p(^CT("CTPM",payMDr),"^",2)
    ...e  d
    ....s paymDesc=""
    ....s paymsum=0
	..q:(+PayMHandDr=0)!(paymsumflag=0)
    ..s amt=$p(invInfo,"^",1)
    ..s prtdate=$p(invInfo,"^",5)
    ..s:prtdate'="" prtdate=$zd(prtdate,3)
    ..s prttime=$p(invInfo,"^",20)
    ..s:prttime'="" prttime=$zt(prttime)
    ..s flag=$p(invInfo,"^",8)
    ..q:flag="TP"
    ..i flag="N"  s flagDesc="正常"
    ..i flag="A"  s flagDesc="作废"
    ..;i flag="S"  s flagDesc="红冲"
    ..i (flag="S") d
    ...i +amt<0 s flagDesc="红冲"
    ...e  s flagDesc="正常"
    ..s invno=$p(invInfo,"^",14)
    ..q:invno'=""   ;自助机、科室卡消费不打印发票  
    ..s initinv=$p(invInfo,"^",13)
    ..s sFlag="PRT"
    ..d ..BuildOPCatFee(Guser,job,RowId)
    ..d ..BuildOPPayM(Guser, job, RowId,.payMDr,sFlag)
    ..d ..BuildOPAdmReaon(Guser,job,RowId,sFlag)
    ..s papmi=$p($p(invInfo,"^",15),$c(1))
    ..s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s RoundErr=$p(invInfo,"^",37)
    ..s RoundErrSum=RoundErrSum+RoundErr
    ..s paymsum=$fn(paymsum,"",2)
    ..s TabFlag="Inv"
    ..d OutputNotHandin
    ..s n=n+1
    ..s Sum=Sum+amt
    ..s PaySum=PaySum+paymsum
    if (n>0)
    {
	    s (prtUserCode,prtUserName,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr,initinv)=""
	    s paydr="0",k=0
	    f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(k>20)  d
	    .s:paydr'="" paymCode=$p($g(^CT("CTPM",paydr)),"^",1)
	    .s k=k+1
	    .s paym(k)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))
	    s paymsum=PaySum
	    s amt=Sum
	    s RoundErr=RoundErrSum
	    s prtUserName="合计"
	    s Guser=""
	    d OutputNotHandin
    }
    
    q
OutputNotHandin
     s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_paym_"^"_flagDesc_"^"_amt_"^"_handdr_"^"_initinv_"^"_job_"^"_RowId_"^"_RoundErr_"^"_sFlag
    ;s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_amt_"^"_handdr_"^"_job_"^"_RoundErr
	set Data=$lb(ind,RowId,prtUserCode,prtUserName,prtdate,prttime,PatName,PatNo,amt,flag,handdr,job,RoundErr,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInvHandin(StDate, EndDate, Guser, Handin, JkDr, HandinType, Hospital, InsType, ApplyType, MyUserId, InvType, InvFlag)
{
    k ^TMP("MZJF","EPInvDailyHand",Guser,job)
	k ^TMP("OPBILL","CateFee",Guser,job)
    k ^TMP("OPBILL","PayMode",Guser,job)
    k ^TMP("OPBILL","OPRoundErr",Guser,job)
    k ^TMP("DHCOPBILL","AdmReason",Guser,job)
    k ^TMP("DHCOPBill","DailyHandin")  //打印
    k ^TMP("invDailyHandin") //
    ;s myHospDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(Guser)
   ;存放支付方式金额
	i InvType="全部"  s InvFlag="A"
	i InvType=""  s InvFlag="A"
	i InvType="门诊"  s InvFlag="F"
	i InvType="挂号"  s InvFlag="R"
	i InvType="A"  s InvFlag="A"
	f i=1:1:20  d
	.s paym(i)=0.00
    s n=0,Sum=0,PaySum=0,RoundErrSum=0
    s TabFlag=""
    f Date=StDate:1:EndDate d
    .s JkDr="" f  s JkDr=$o(^DHCOPInsFootI(0,"Date",Date,JkDr)) q:JkDr=""   d
    ..s footInfo=$g(^DHCOPInsFoot(JkDr))
 	..s footUser=$p(footInfo,"^",8) ;HIS_User 结算人
 	..s footDate=$p(footInfo,"^",2) ;HIS_Date 结算日期
 	..s footTime=$p(footInfo,"^",7) ;HIS_Time 结算时间
 	..s footStDate=$p(footInfo,"^",5) ;HIS_StartDate 结算开始日期
 	..s footStTime=$p(footInfo,"^",6) ;HIS_StartTime 结算开始时间
 	..s footEndDate=$p(footInfo,"^",3) ;HIS_EndDate 结算结束日期
 	..s footEndTime=$p(footInfo,"^",4) ;HIS_EndTime 结算结束时间
 	..s footHospDr=$p(footInfo,"^",66) ;HIS_HospitalDR 医院Dr	
    ..s RowId=""
    ..f  s RowId=$o(^DHCINVPRT(0,"Report",JkDr,RowId)) q:RowId=""  d
    ...s invInfo=$g(^DHCINVPRT(RowId))
    ...s prtuser=$p(invInfo,"^",21)
    ...s prtUserCode=$p(^SSU("SSUSR",prtuser),"^",1)
	...s prtUserName=$p(^SSU("SSUSR",prtuser),"^",2)
	...q:(prtUserCode'["alipay")
	...s prtfairtype=$p(invInfo,"^",34)  ;prt_fairtype (F:发票，R:挂号)
    ...q:(prtfairtype'="F")&(prtfairtype'="R")
    ...q:(InvFlag'="A")&(prtfairtype'=InvFlag)
    ...s invHospDR=$p(invInfo,"^",39)  ;医院ID
    ...s invSub=$o(^DHCINVPRT(RowId,"P",0))  ;dhc_invpaymode
    ...s paymDesc=""
    ...s IPM=""
	...f  s IPM=$o(^DHCINVPRT(RowId,"P",IPM),-1) q:+IPM=0  d
	....s s=$g(^DHCINVPRT(RowId,"P",IPM))
	....s payMDr=$p(s,"^",1)
	....s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	....s PayMHandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	....i +PayMHandDr>0 d
	.....s paymsum=$p(s,"^",3)
	.....s paymsumflag=paymsum
	.....s paymDesc=$p(^CT("CTPM",payMDr),"^",2)
    ....e  d
    .....s paymDesc=""
    .....s paymsum=0
	...q:(+PayMHandDr=0)!(paymsumflag=0)
    ...s amt=$p(invInfo,"^",1)
    ...s prtdate=$p(invInfo,"^",5)
    ...s:prtdate'="" prtdate=$zd(prtdate,3)
    ...s prttime=$p(invInfo,"^",20)
    ...s:prttime'="" prttime=$zt(prttime)
    ...s flag=$p(invInfo,"^",8)
    ...s flag=$p(invInfo,"^",8)
    ...i flag="N"  s flagDesc="正常"
    ...i flag="A"  s flagDesc="作废"
    ...;i flag="S"  s flagDesc="红冲"
    ...i (flag="S") d
    ....i +amt<0 s flagDesc="红冲"
    ....e  s flagDesc="正常"
    ...s invno=$p(invInfo,"^",14)   
    ...q:invno'=""
    ...s initinv=$p(invInfo,"^",13)
    ...s prtUserCode=$p(^SSU("SSUSR",prtuser),"^",1)
    ...;w !,"HandinType="_HandinType
    ...;q:(HandinType=1)&&($e(prtUserCode,1,4)'="810_")
    ...;q:(HandinType=2)&&  ;银行柜台挂号add by wangjian 2012-09-04
    ...;q:'$d(^DHCINVPRTCAPi(0,"INVPRTDR",RowId))
    ...;q:((initinv'="")&&('$d(^DHCINVPRTCAPi(0,"INVPRTDR",initinv))))
    ...s sFlag="PRT"
    ...d ..BuildOPCatFee(Guser,job,RowId)
    ...d ..BuildOPPayM(Guser, job, RowId,.paym,sFlag) ;生成支付方式信息
    ...d ..BuildOPAdmReaon(Guser,job,RowId,sFlag)
    ...s handdr=$p(invInfo,"^",6)
    ...s papmi=$p($p(invInfo,"^",15),$c(1))
    ...s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
    ...s PatNo=$p(^PAPER(papmi,"PAT",1),"^",1)
    ...;s paym=$o(^DHCINVPRT(RowId,"P",""),-1)  
    ...s paym=$p($g(^DHCINVPRT(RowId,"P",1)),"^",1)
    ...s:paym'="" paym=$p($g(^CT("CTPM",paym)),"^",2)
    ...s paymsum=$p($g(^DHCINVPRT(RowId,"P",1)),"^",3)
    ...s RoundErr=$p(invInfo,"^",37)
    ...s RoundErrSum=RoundErrSum+RoundErr
    ...s paymsum=$fn(paymsum,"",2)
    ...s TabFlag="Inv"
    ...d OutputHandin
    ...s n=n+1
    ...s Sum=Sum+amt
    ...s PaySum=PaySum+paymsum
    if (n>0)
    {
	    s (prtUserCode,prtUserName,prtuser,prtdate,prttime,PatName,PatNo,paymsum,paym,flag,amt,handdr,initinv)=""
	   	s paydr="0",k=0
	    f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(k>20)  d
	    .s:paydr'="" paymCode=$p($g(^CT("CTPM",paydr)),"^",1)
	    .s k=k+1
	    .s paym(k)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))
		s paymsum=PaySum
	    s amt=Sum
	     s RoundErr=RoundErrSum
	    s prtUserName="合计"
	    s Guser=""
	    d OutputHandin
	}   
    
    q
    
OutputHandin
 	;
    s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_paym_"^"_flagDesc_"^"_amt_"^"_handdr_"^"_initinv_"^"_job_"^"_RowId_"^"_RoundErr_"^"_sFlag
    ;s:Guser'="" ^TMP("MZJF","EPInvDailyHand",Guser,job,ind)=invno_"^"_prtuser_"^"_prtdate_"^"_prttime_"^"_PatName_"^"_PatNo_"^"_paymsum_"^"_amt_"^"_handdr_"^"_job_"^"_RoundErr
	set Data=$lb(ind,RowId,prtUserCode,prtUserName,prtdate,prttime,PatName,PatNo,amt,flag,handdr,job,RoundErr,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// Lid
/// 2010-04-06 
/// 根据发票Rowid获取会计子类
/// ^TMP("OPBILL","CateFee",Guser,job,cateCode):
/// w ##class(web.UDHCJFEPDailyHand).BuildOPCatFee(639,3124,"175681")
ClassMethod BuildOPCatFee(Guser, job, InvDr)
{
	 s Condr=""
	 f  s Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  q:Condr=""  d
	 .s Bill=$p($g(^DHCBCI(Condr)),"^",2)
	
	 .s BillOrd=0
	 .f  s BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  q:BillOrd=""   d
	 ..s BillDetsub=0
	
	 ..f  s BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
	 ...s tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
	 ...q:tarid=""
	 ...s OPSubCat=$p($g(^DHCTARI(tarid)),"^",5)      ;会计子类
	 ...s OPSubCatCode=$p(^DHCTarC("AC",OPSubCat),"^",1)
	 ...s OPSubCatDesc=$p(^DHCTarC("AC",OPSubCat),"^",2)
	 ...s OPCat=$p($G(^DHCTarC("AC",OPSubCat)),"^",3)  ;门诊大类
	 ...s cateDesc=$p(^DHCTarC("TAC",OPCat),"^",2)     
	 ...s cateCode=$p(^DHCTarC("TAC",OPCat),"^",1)
	 ...s ^TMP("OPBILL","CateFee",Guser,job,OPSubCat)=$g(^TMP("OPBILL","CateFee",Guser,job,OPSubCat))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	 ...s ^yhb("sum")=$g(^yhb("sum"))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	 ...;s ^TMP("OPBILL","CateFee",Guser,job,cateCode)=$g(^TMP("OPBILL","CateFee",Guser,job,cateCode))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	 ...;s ^TMP("OPBILL","CateFee",Guser,job,OPSubCatCode)=$g(^TMP("OPBILL","CateFee",Guser,job,OPSubCatCode))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
}

/// Lid
/// 2010-04-06 
/// 根据发票Rowid获取支付方式信息
/// ^TMP("OPBILL","PayMode",Guser,job,paym)
/// 节点:"OPBILL","PayMode",用户Rowid,job,支付方式Code
/// w ##class(web.UDHCJFEPDailyHand).BuildOPPayM(639,3124,"175681")
ClassMethod BuildOPPayM(Guser, job, RowId, paymAry, sFlag)
{
	k ^TMP("OPBILL","PayMode","SingleInv",Guser,job) ;存放一张发票的支付方式
	if (sFlag="PRT"){
		s Paysub=0
    	s YBPay=0
    	f  s Paysub=$o(^DHCINVPRT(RowId,"P",Paysub))  q:Paysub=""  d
    	.s paymDr=$p(^DHCINVPRT(RowId,"P",Paysub),"^",1)
    	.s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
    	.s paymsum2=$p($g(^DHCINVPRT(RowId,"P",Paysub)),"^",3)
    	.s:paymCode["YB" YBPay=YBPay+paymsum2
    	.s ^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr)=+$g(^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr))+paymsum2 ;一张发票金额
    	.i paymCode["YB"  s ^TMP("OPBILL","PayMode",Guser,job,"YBZF")=+$g(^TMP("OPBILL","PayMode",Guser,job,"YBZF"))+paymsum2 ;累计医保金额
    	.s ^TMP("OPBILL","PayMode",Guser,job,paymCode)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))+paymsum2 ;合计
	}
	;卡消费
	if (sFlag="API"){
		;^DHCINVPRTAP	
	    s Paysub=0
    	s YBPay=0
    	f  s Paysub=$o(^DHCINVPRTAP(RowId,"P",Paysub))  q:Paysub=""  d
    	.s paymDr=$p(^DHCINVPRTAP(RowId,"P",Paysub),"^",1)
    	.s:paymDr'="" paymCode=$p($g(^CT("CTPM",paymDr)),"^",1)
    	.s paymsum2=$p($g(^DHCINVPRTAP(RowId,"P",Paysub)),"^",3)
    	.s:paymCode["YB" YBPay=YBPay+paymsum2
    	.s ^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr)=+$g(^TMP("OPBILL","PayMode","SingleInv",Guser,job,paymDr))+paymsum2 ;api一张发票金额
    	.i paymCode["YB"  s ^TMP("OPBILL","PayMode",Guser,job,"YBZF")=+$g(^TMP("OPBILL","PayMode",Guser,job,"YBZF"))+paymsum2 ;累计医保金额
    	.s ^TMP("OPBILL","PayMode",Guser,job,paymCode)=+$g(^TMP("OPBILL","PayMode",Guser,job,paymCode))+paymsum2 ;合计
	
	}   
	
    s paydr="0",j=0
	f  s paydr=$o(^CT("CTPM",paydr))  q:(paydr="")||(j>20)  d
	.s j=j+1
	.s paym(j)=+$g(^TMP("OPBILL","PayMode","SingleInv",Guser,job,paydr))
    
    ;清除临时数据
    k ^TMP("OPBILL","PayMode","SingleInv",Guser,job)
}

/// Lid
/// 2010-07-17
/// 按病人费别统计
ClassMethod BuildOPAdmReaon(Guser, job, prtRowid, sFalg)
{
	;^DHCINVPRT(RowId
	i (sFlag="PRT") d
	.s prtfairtype=$p(^DHCINVPRT(RowId),"^",34)
    .s amt=$p(^DHCINVPRT(RowId),"^",1)
    .s invStatus=$p(^DHCINVPRT(RowId),"^",8)   
    .s initInv=$p(^DHCINVPRT(RowId),"^",13)
    .s admReason=$p(^DHCINVPRT(RowId),"^",9)
	.;累计金额
	.s ^TMP("DHCOPBILL","AdmReason",Guser,job,prtfairtype,admReason,prtRowid)=""
	
	;卡消费
	i (sFlag="API") d
	.;暂无
}

/// wangjian
/// 2014-12-30
/// 沈阳医大自助结算
ClassMethod AccInvHandinAuto11(sUser As %String, HospDR As %String, FootInfo As %String, HandinType = "1")
{
	
	n (sUser,HospDR,FootInfo,HandinType)
	
	;s $ZT="ERROR^SSERR"
	
	s StDate=$p(FootInfo,"^",1)
	s StTime=$p(FootInfo,"^",2)
	
	s EndDate=$p(FootInfo,"^",3)
	s EndTime=$p(FootInfo,"^",4)
	
	s hdate=+$h-1
	s htime=82800
	d ..KillTmp()
	
	s myrtn=..BuildOPINVItem1(sUser,StDate, StTime, EndDate, EndTime)	
	b ;ok
	q:(+myrtn) myrtn_"^"
	s MyTotalSum=$p(myrtn,"^",2)
	s MyTotalNum=$p(myrtn,"^",3)
	d ..tb()
	
	k PLIST
	
	k PLIST(1)
	;日期格式转换
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$p(FootInfo,"^",1)		;HIS_StartDate
	s PLIST(5)=$p(FootInfo,"^",2)		; HIS_StartTime
	s PLIST(6)=$p(FootInfo,"^",3)		;HIS_EndDate
	s PLIST(7)=$p(FootInfo,"^",4)		;HIS_EndTime
	s PLIST(8)=$fn(MyTotalSum,"",2) ;$p(FootInfo,"^",5)
	s PLIST(9)=sUser
	s PLIST(10)=MyTotalNum ;$p(FootInfo,"^",11)
	s PLIST(11)=$p(FootInfo,"^",12)
	s patpayamt=$p(FootInfo,"^",6)+$p(FootInfo,"^",7)+$p(FootInfo,"^",8)
	s PLIST(17)=$j(patpayamt,3,2)
	s PLIST(19)=$p(FootInfo,"^",6)
	s PLIST(31)=$p(FootInfo,"^",7)
	s PLIST(29)=$p(FootInfo,"^",8)
	s PLIST(25)=$p(FootInfo,"^",13)
	s PLIST(24)=$p(FootInfo,"^",14)
	s PLIST(26)=$p(FootInfo,"^",15)
	s PLIST(23)=$p(FootInfo,"^",16)
	s PLIST(22)=$p(FootInfo,"^",17)
	s PLIST(27)=$p(FootInfo,"^",18)
	s PLIST(30)=+$p(FootInfo,"^",19)
	s PLIST(61)="S"
	s PLIST(62)=$p(FootInfo,"^",9)
	s PLIST(63)=$p(FootInfo,"^",10)
	s refamt=$p(FootInfo,"^",13)+$p(FootInfo,"^",16)
	s PLIST(64)=$j(refamt,3,2)
	
	s CashToBankLeftInfo=..getOpUserCashToBankLeftSum(sUser,StDate, StTime, EndDate, EndTime)	 ;HIS_Note8  66 本期余额 ---现金 - 转账金
	s PLIST(66)=$p(CashToBankLeftInfo,"^",1)
	s CashToBankLeftRowIdStr=$p(CashToBankLeftInfo,"^",2)
	
	s StDate=PLIST(4)
	s StTime=PLIST(5)
	s EndDate=PLIST(6)
	s EndTime=PLIST(7)
	
	
	;结算主表
	s mycat=""
	s mycatsub=""
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()
	i myrtn=0 d
	.s HISParref=PLIST(1)
	
	i myrtn=0 d
	.;更新银行转帐表
	.s myrtn=..UpdateCashToBank(CashToBankLeftRowIdStr,HISParref)
	
	b ;;;;;
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=+$g(^TMPCatSub($j,mycat,mycatsub,"N"))
	...s myRefpay=+$g(^TMPCatSub($j,mycat,mycatsub,"R"))
	...s myAmt=myPatpay+myRefpay
	...k PLIST
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myAmt,"",2)
	...s PLIST(5)=mycatsub
	...s PLIST(6)=$fn(myPatpay,"",2)
	...s PLIST(7)=$fn(myRefpay,"",2)
	...
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	
	b ;更新票据流水表
	i myrtn=0 d
	.d ..UpdateFootForUserNoCard(sUser,StDate,StTime,EndDate,EndTime,HISParref,hdate,htime,HospDR,HandinType)
	b ;end
	;写入支付方式子表
	i myrtn=0 d
	.s myPMDR=0
	.f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:((myPMDR="")||(myrtn'=0))  d
	..s myPMSum=+$g(^TMPOPPayMode($j,myPMDR,"N","Sum"))
	..s myPMNum=+$g(^TMPOPPayMode($j,myPMDR,"N","Num"))
	..s myParkSum=+$g(^TMPOPPayMode($j,myPMDR,"A","Sum"))
	..s myParkNum=+$g(^TMPOPPayMode($j,myPMDR,"A","Num"))
	..s myRefundSum=+$g(^TMPOPPayMode($j,myPMDR,"S","Sum"))
	..s myRefundNum=+$g(^TMPOPPayMode($j,myPMDR,"S","Num"))
	..;预交金
	..s myPRDGNum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GNum")) ;预交金
	..s myPRDGSum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GSum"))
	..s myPRDRefNum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefNum"))
	..s myPRDRefSum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefSum"))
	..;卡支付 发票
	..k PLIST
	..s PLIST(0)=HISParref
	..s PLIST(3)=$fn(myPMSum,"",2)
	..s PLIST(4)=myPMDR
	..s PLIST(5)=myRefundNum  				;HisPay_Refund
	..s PLIST(6)=$fn(myRefundSum,"",2) 				;HisPay_Refundsum
	..s PLIST(7)=myPMNum
	..s PLIST(8)=myPRDGNum
	..s PLIST(9)=$fn(myPRDGSum,"",2)
	..s PLIST(10)=myPRDRefNum
	..s PLIST(11)=$fn(myPRDRefSum,"",2)
	..s PLIST(16)=myParkNum			//note9 ---parkNum
	..s PLIST(17)=$fn(myParkSum,"",2)  	//note10 ---parkSum
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()

	
	s myInsTypeDR=0
	f  s myInsTypeDR=$o(^TMPOPRepInstype($j,"Instype",myInsTypeDR))  q:((myInsTypeDR="")!(myrtn'=0))  d
	.s myNum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,0))      ;人次
	.s myCashSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,1))  ;现金
	.s myYBTCZFSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,3))  ;统筹支付
	.s myYBZHZCSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,4))  ;帐户支出
	.s myYBDEBZSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,6))  ;大额补助
	.s myYBGWYBZSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,7))  ;公务员补助
	.s myYBTKJJSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,9))  ;特困救济
	.s myParkPayorSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,"P")) ;记账
	.s PosSum=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,10))  ;Pos
	.s myAmount=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR))			;总额
	.s myCardCpp=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,20))
	.s myAliPay=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,30))
	.
	.
	.k PLIST
	.s PLIST(0)=HISParref
	.s PLIST(3)=myInsTypeDR
	.s PLIST(8)=myNum 						;ITC_Note1
	.s PLIST(9)=$fn(+myCashSum,"",2)	    ;ITC_Note2
	.s PLIST(10)=$fn(+myYBTCZFSum,"",2)	    ;ITC_Note3
	.s PLIST(11)=$fn(+myYBZHZCSum,"",2)     ;ITC_Note4
	.s PLIST(12)=$fn(+myYBDEBZSum,"",2)     ;ITC_Note5
	.s PLIST(13)=$fn(+myYBGWYBZSum,"",2)	;ITC_Note6
	.s PLIST(14)=$fn(+myYBTKJJSum,"",2)	    ;ITC_Note7
	.s PLIST(15)=$fn(+myParkPayorSum,"",2)	;ITC_Note8
	.s PLIST(16)=$fn(+myAmount,"",2)        ;ITC_Note9
	.s PLIST(17)=$fn(+PosSum,"",2)          ;itc_note10  yyx 2011-05-31
	.s PLIST(18)=$fn(+myCardCpp,"",2)       ;ITC_Note11 wangjian 2013-02-18
	.s PLIST(19)=$fn(+myAliPay,"",2)       ;ITC_Note12 wangjian 2014-12-30
	.s myrtn=##class(web.UDHCINVPRTReportsInsType).Insert()
	.s HisRowid=%ROWID
	b		;Tro
	
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTmp()
	
	quit myrtn_"^"_HISParref
}

ClassMethod getOpUserCashToBankLeftSum(sUser, StDate, StTime, EndDate, EndTime)
{
	 ;HIS_Note8  66 本期余额 ---现金 - 转账金额
	 s CashPMRowId=1	;需要修改
	 s HandCashSum=$g(^TMPOPPayMode($j,CashPMRowId,"N","Sum"))+$g(^TMPOPPayMode($j,CashPMRowId,"A","Sum"))+$g(^TMPOPPayMode($j,CashPMRowId,"S","Sum"))
	
	 s CashToBankSum=0
	 s tmpInfo=..GetCashToBankA(sUser,StDate,EndDate)
	 //s rtn=ycsum_"^"_ybdzsum_"^"_RowidStr	
	 s ycsum=+$p(tmpInfo,"^",1)
	 s ybdzsum=+$p(tmpInfo,"^",2)
	 s RowidStr=$p(tmpInfo,"^",3)
	 s BankLeftSum=HandCashSum-(ycsum+ybdzsum)
	 
	 /*
	 f curDate=StDate:1:EndDate d
	 .s (amt1,amt2)=0
	 .s strAmt=##class(web.UDHCJFOP9CashDaily).GetCashToBank(sUser,curDate)
	 .s amt1=+$p($g(strAmt),"^",1)
	 .s amt2=+$p($g(strAmt),"^",2)
	 .s CashToBankSum=CashToBankSum+amt1+amt2
	 
	 s BankLeftSum=$fn(HandCashSum-CashToBankSum,"",2)
	 */
	 
	 Quit BankLeftSum_"^"_RowidStr
}

ClassMethod GetCashToBankA(user, StDate, EndDate)
{
    ;取预存金额
	n (user,StDate ,EndDate)
	s user=$g(user),StDate=+$g(StDate),EndDate=+$g(EndDate)
	s rtn="^^"
	q:user="" rtn
	q:StDate=0 rtn
	q:EndDate=0 rtn
	s RowidStr=""
	s ycsum=0,ybdzsum=0
	f jkdate=StDate:1:EndDate d
	.s RowId=""
	.f  s RowId=$o(^DHCJFOPCASHTOBANK(0,"Date",jkdate,"User",user,RowId)) q:RowId=""  d
	..s UserRptDR=$p(^DHCJFOPCASHTOBANK(RowId),"^",6)
	..q:UserRptDR'=""
	..s ycsum=+$p(^DHCJFOPCASHTOBANK(RowId),"^",3)+ycsum
	..s ybdzsum=+$p(^DHCJFOPCASHTOBANK(RowId),"^",5)+ybdzsum
	..i RowidStr="" s RowidStr=RowId
	..e  s RowidStr=RowidStr_"!"_RowId
	s rtn=ycsum_"^"_ybdzsum_"^"_RowidStr	
	q rtn
}

ClassMethod UpdateCashToBank(RowidStr, UserReportsDR)
{
	n (RowidStr,UserReportsDR)
	s rtn=0
	q:$g(RowidStr)="" rtn
	q:$g(UserReportsDR)="" rtn
	s delistr="!"
	s strlen=$l(RowidStr,delistr)
	f i=1:1:strlen d
	.s RowID=$p(RowidStr,delistr,i)
	.q:RowID=""
	.q:'$d(^DHCJFOPCASHTOBANK(RowID))
	.k PLIST
	.s PLIST(7)=UserReportsDR
	.&sql(update DHC_JFOPCashToBank values PLIST() where OP_RowId=:RowID)
	.i SQLCODE'=0 s rtn=SQLCODE
	q rtn
}

ClassMethod BuildOPINVItem1(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
	;w ##class(web.udhcOPHandin1).BuildOPINVItem(23298,60589,62365,60589,$p($h,",",2))
	n (hUser, stdate, sttime, EndDate, EndTime)
	
	s rtn=0
	i (stdate'="")&(sttime'="")  d
	.;s catret=..getsubcat()
	.s (MyTotalSum,MyTotalNum)=0
	.s snum=0
	.f pdate=stdate:1:EndDate  q:(rtn'=0)  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:((PRTrowid="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...s myflag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...q:myflag="TP"
	...s PRTUserCode=$p($g(^SSU("SSUSR",PRTUser)),"^",1)
	...;q:PRTUserCode'["alipay001"
	...q:PRTUser'=hUser
	...s PRTFairType=$p(^DHCINVPRT(PRTrowid),"^",34)
	...;q:PRTFairType'="F"
	...
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...;q:(pdate=EndDate)&&(PRTTime>EndTime)
	...q:(pdate=EndDate)&&(PRTTime>=EndTime)    //update by zhl 20111019
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...
	...s stat=..STATtoOPCAT11(PRTrowid)
	...
	...d ..GetOPRepPayMode(PRTrowid)
	...d ..GetOPRepInstype11(PRTrowid)
	...;add by wangjian 2013-03-01
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...S MyTotalSum=MyTotalSum+PRTAcount
	...s MyTotalNum=MyTotalNum+1
	...;end
	...q:(rtn'=0)
	
	q rtn_"^"_MyTotalSum_"^"_MyTotalNum
}

ClassMethod KillTmp()
{
	;k ^TMPOPHand($j)
	;k ^TMPOPHandsub($j)
	;k ^TMPCatSub($j)
	;k ^TMPCatSubOther($j)
	;k ^TMPOPCat($j)
	k ^TMPOPHand($j)
	k ^TMPOPHandsub($j)
	k ^TMPCatSub($j)
	k ^TMPCatSubOther($j)
	k ^TMPOPCat($j)
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	k ^TMPOPACCHand($j)
	k ^TMPOPPayMode($j)
	k ^TMPOPParkPayMode($j)
	k ^TMPOPINVTALLY($j)
	k ^TMPOPINVSTRIK($j)
	k ^TMPOPPayMode($j)
	k ^TMPOPRepInstype($j)
	k ^TMPOPINVREFUND($j)
}

ClassMethod STATtoOPCAT11(INVPRTRowid As %String)
{
	;把一张票据转化为门诊收费大类或子类
	;
	n (INVPRTRowid)
	q:INVPRTRowid="" 0
	s PrtinvDr=$p(^DHCINVPRT(INVPRTRowid),"^",13)		;原票据的RowID  正常票据=??
	s Flag=$p(^DHCINVPRT(INVPRTRowid),"^",8)
	i (Flag="N")!((Flag'="N")&&(PrtinvDr=""))  d
	.s PrtFlag="N"
	e  d
	.s PrtFlag="R"
	
	s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	.S Bill=$p(^DHCBCI(conRowid),"^",2)
	.q:'$D(^DHCPB(Bill))
	.S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	..S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	...;b DHC_TarOutpatCate	  DHC_TarOC
	...S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	...S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	...S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	...S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	...S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	...S ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	...q:$g(ItmOPSubCat)=""
	...s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	...S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	...q:$g(ItmOPCat)=""
	...s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	...s totmp=+$g(^TMPOPHandsub($j,OPCatDesc,PrtFlag))
	...s totmp=totmp+TotalAmount
	...;定义一个^TmpCatSub($j,Cat,CatSub)
	...s ^TMPCatSub($j,ItmOPCat,ItmOPSubCat,PrtFlag)=+$g(^TMPCatSub($j,ItmOPCat,ItmOPSubCat,PrtFlag))+TotalAmount
	...s ^TMPCatSubOther($j,"SubCat",ItmOPSubCat,PrtFlag)=+$g(^TMPCatSubOther($j,"SubCat",ItmOPSubCat,PrtFlag))+TotalAmount
	...s ^TMPOPHandsub($j,OPCatDesc,PrtFlag)=totmp
	...s ^TMPOPCat($j,ItmOPCat,PrtFlag)=+TotalAmount+$g(^TMPOPCat($j,ItmOPCat,PrtFlag))
	q 0
}

ClassMethod GetOPRepPayMode(PRTRowID As %String = "") As %String
{
	;w ##class(web.UDHCJFOPHandin8).GetOPRepPayMode(617)
	n (PRTRowID)
	s Flag=$p(^DHCINVPRT(PRTRowID),"^",8)
	s PrtDr=$p(^DHCINVPRT(PRTRowID),"^",13)
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0
		
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.d
	..q:(Flag'="N")&&(PrtDr="")
	..s ^TMPOPPayMode($j,myPMDR,Flag,"Sum")=+$g(^TMPOPPayMode($j,myPMDR,Flag,"Sum"))+myPMSum
	..s ^TMPOPPayMode($j,myPMDR,Flag,"Num")=+$g(^TMPOPPayMode($j,myPMDR,Flag,"Num"))+1
	.
	.i (Flag'="N")&&(PrtDr="") d
	..s ^TMPOPPayMode($j,myPMDR,"N","Sum")=+$g(^TMPOPPayMode($j,myPMDR,"N","Sum"))+myPMSum
	..s ^TMPOPPayMode($j,myPMDR,"N","Num")=+$g(^TMPOPPayMode($j,myPMDR,"N","Num"))+1
	.
		
	q 0
}

ClassMethod GetOPRepInstype11(PRTRowID As %String = "") As %String
{
	;w ##class(web.UDHCJFOPHandin9).GetOPRepInstype(907809)
	
	s Flag=$p(^DHCINVPRT(PRTRowID),"^",8)			;PRT_Flag
	s PrtDr=$p(^DHCINVPRT(PRTRowID),"^",13)
	s myPMSub=$o(^DHCINVPRT(PRTRowID,"P","0")) 
	q:myPMSub=""
	s PMDr=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	s myInsTypeDR=$p(^DHCINVPRT(PRTRowID),"^",9)		;PRT_InsType_DR
	s myINVPatSum=$p(^DHCINVPRT(PRTRowID),"^",16)		;PRT_PatientShare
	s myINVAcount=$p(^DHCINVPRT(PRTRowID),"^",1)		;PRT_Acount
	s myINVPayorSum=$p(^DHCINVPRT(PRTRowID),"^",18)		;PRT_PayorShare
	
	s myPMSub=0
		
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.i myPMDR="13" d
	..s myINVPayorSum=myINVPayorSum+myPMSum
	.e  d
	..s ^TMPOPRepInstype($j,"Instype",myInsTypeDR,myPMDR)=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,myPMDR))+myPMSum
	..s ^TMPOPRepInstype($j,"Instype",myInsTypeDR)=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR))+myPMSum
	.i (Flag="N")!((Flag'="N")&&(PrtDr=""))  d
	..s ^TMPOPRepInstype($j,"Instype",myInsTypeDR,0)=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,0))+1
    
    i +myINVPayorSum'=0  d
    .s ^TMPOPRepInstype($j,"Instype",myInsTypeDR,"P")=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR,"P"))+myINVPayorSum
    .s ^TMPOPRepInstype($j,"Instype",myInsTypeDR)=+$g(^TMPOPRepInstype($j,"Instype",myInsTypeDR))+myINVPayorSum
	Quit $$$OK
}

/// 结算发票表
ClassMethod UpdateFootForUserNoCard(UserDR As %String, StDate As %String, StTime As %String, EndDate As %String, EndTime As %String, INVRepRef As %String, HDate As %String, HTime As %String, hospDr, HandinType) As %String
{
	;
	n (UserDR, StDate, StTime, EndDate, EndTime, INVRepRef, HDate, HTime,hospDr,HandinType)
	s $ZT="ERROR^DHCSSERR"
	s myrtn=0
	
	s myDate=StDate-1
	f  s myDate=$o(^DHCINVPRT(0,"Date",myDate)) q:((myDate="")!(myrtn'=0)!(+myDate>+EndDate))  d
	.s myPrtRowID=0
	.f  s myPrtRowID=$o(^DHCINVPRT(0,"Date",myDate,myPrtRowID)) q:((myPrtRowID="")||(myrtn'=0))  d
	..i myPrtRowID="19736181" b ;;111
	..s myTime=$p(^DHCINVPRT(myPrtRowID),"^",20)
	..s myPRTNo=$p(^DHCINVPRT(myPrtRowID),"^",14)		;PRT_inv
	..s myUser=$p(^DHCINVPRT(myPrtRowID),"^",21)
	..s myflag=$p(^DHCINVPRT(myPrtRowID),"^",8)
	..s myHospDr=$p(^DHCINVPRT(myPrtRowID),"^",39)
	..q:myflag="TP"
	..s prtUserCode=$p(^SSU("SSUSR",myUser),"^",1)
    ..;q:(prtUserCode'["alipay")
    ..q:myUser'=UserDR
	..s myHandin=$p(^DHCINVPRT(myPrtRowID),"^",10)
	..s myHospDr=$p(^DHCINVPRT(myPrtRowID),"^",39)
	..q:(myHandin="Y")
	..q:((myDate=StDate)&&(myTime<StTime))
	..q:((myDate=EndDate)&&(myTime>=EndTime))
	..i myPrtRowID="19736181" b ;;22
    ..s IPM="0",PayMHandDr=0
	..f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:((IPM="")!(+PayMHandDr'=0))  d
	...s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s PayMHandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	..q:+PayMHandDr=0
	..s myrtn=##class(web.DHCOPInvoice).SELECT(myPrtRowID)
	..q:myrtn
	..s PLIST(7)="Y"
	..s PLIST(8)=HDate		; PRT_HandinDate
	..s PLIST(9)=HTime		;PRT_HandinTime
	..s PLIST(5)=INVRepRef
	..s myrtn=##class(web.DHCOPInvoice).UPDATE(myPrtRowID)
	..s ^AliDailyHandinLog("AliDaily",$zd(HDate,3),$zt(HTime,1),INVRepRef,myPrtRowID)=myrtn
	..q:myrtn
	
	q myrtn
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  s SQLCODE=$zu(34)
	q
}

ClassMethod tc()
{
	n SQLCODE
	TCOMMIT  s SQLCODE=$zu(34)
	q
}

/// wangjian
/// 2014-07-22
/// 支付宝自动结算任务
/// d ##class(web.DHCOPBillAliBalanceAcount).AccAliInvHandinTask()
ClassMethod AccAliInvHandinTask()
{
	
	s HospDR="2"
	s FootInfo=(+$h-1)_"^"_$zth("00:00:00",1)_"^"_(+$h-1)_"^"_$zth("23:59:59",1)
	s userrowid=""  f  s userrowid=$o(^SSU("SSUSR",0,"Group",949,userrowid)) q:userrowid=""  d
	.s sUser=userrowid
	.s rtn=..AccInvHandinAuto11(sUser,HospDR,FootInfo,"")
	.b ;b00
	.i +$p(rtn,"^",1)'=0 d
	..s ^AccInvHandin("DHCBILL","AliHandinErrLog",HospDR,$zd(+$h,3))=rtn
	;
}

/// wangjian
/// 2014-07-11
/// 根据门诊发票表Rowid获取支付宝支付额
/// 医保返钱时候取发票支付表
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmtForYB("2244307|2244311")
ClassMethod GetOPInvAliPayAmtForYB(rowidStr)
{
	;发票如果发票存在医保分解扩展以医保扩展表为准
	n (rowidStr)
	s amt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.s IPM="0"
	.q:'$d(^DHCINVPRT(rowid,"P",IPM))
	.f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(rowid,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..;b ;;
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s handDr=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s amt=amt+payMAmt
	
	
	q amt
}

Query JudgeTradePay(StDate, StTime, EndDate, EndTime, AllFlag) As %Query(ROWSPEC = "Tind:%String,TPatNo:%String,TPatName:%String,TTradeHospDesc:%String,TTradeChannel:%String,TUserName:%String,TTradeCardNo:%String,TTradeDate:%String,TTradeTime:%String,TBankTradeType:%String,TTradeAmt:%String,TTradeTxtDate:%String,TTradeTxtTime:%String,TTradeRRN:%String,THisTradeNo:%String,TJudge:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCOPBillAliBalanceAcount","JudgeTradePay","2015-10-09","","2015-10-09","",0,1)
ClassMethod JudgeTradePayExecute(ByRef qHandle As %Binary, StDate, StTime, EndDate, EndTime, AllFlag) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If (StDate="")!(EndDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
 	Set ind=2
	Set job=$j
    Kill ^TMPDHCINVAPPBalance
	If StDate["-" Set StDate=$zdh(StDate,3)
	If EndDate["-" Set EndDate=$zdh(EndDate,3)
	If StDate["/" Set StDate=$zdh(StDate,4)
	If EndDate["/" Set EndDate=$zdh(EndDate,4)
	i AllFlag=0 Set AllFlag="0"		; 0 查询差错，1 查询核对上的，2 查询所有
	
	For Date=StDate:1:EndDate Do
	.Set IBPRowid=""
	.For  Set IBPRowid=$o(^DHCINVALITPi(0,"TypeDate",Date,IBPRowid)) Quit:IBPRowid=""  Do
	..Quit:IBPRowid=0
	..Set Rc=$p(^DHCINVALITP(IBPRowid),"^",1)
	..Quit:((Rc'="00")&(Rc'="0000"))	; 过滤不成功的交易数据
	..Set HisTradeNo=$p(^DHCINVALITP(IBPRowid),"^",32)			; HIS交易流水号
	..Set TradeAmt=$p(^DHCINVALITP(IBPRowid),"^",23)				; 应收金额
	..Set IBTRowID=$o(^User.DHCINVAliBalanceI("TRADENO",HisTradeNo,""))
	..If (IBTRowID'="") Do	;说明能核对上的
	...Set ^TMPDHCINVAPPBalance("IBT",IBTRowID)=IBTRowID
	...If ((AllFlag=1)!(AllFlag=2)) d
	....Do GetIAPInfo(IBPRowid)
	...Set TJudge="对平"
	....Do OutputrowPay
	..Else  Do						; HIS交易表有数据，对账文件没有
	...If ((AllFlag=0)!(AllFlag=2)) Do
	....Do GetIAPInfo(IBPRowid)
	....Set TJudge="His存在交易记录回款中不存在记录,交易表ID"_IBPRowid
	....Do OutputrowPay
	..Set IBSSub=""
	..For  Set IBSSub=$o(^DHCINVALITP(IBPRowid,"C",IBSSub)) Quit:IBSSub=""  Do
	...Quit:IBSSub=0
	...Set PrtRowid=$p(^DHCINVALITP(IBPRowid,"C",IBSSub),"^",1)
	...Set ^TMPDHCINVAPPBalance("PRT",PrtRowid)=PrtRowid		; 交易流水能核对上的发票ID
	.Set PrtRowid=""
	.For  Set PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:PrtRowid=""  d
	..Quit:PrtRowid=0
	..Quit:$d(^TMPDHCINVAPPBalance("PRT",PrtRowid))			; 过滤交易明细表已经核对的发票
	..Set HandStr=..GetOPInvWeChatPayAmt(PrtRowid)
	..Quit:+HandStr=0											; 过滤非微信支付宝发票
	..Set PrtAcount=$p(^DHCINVPRT(PrtRowid),"^",1)
    ..Set OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
	..If ((PrtAcount<0)) Do
    ...Set InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)			; 原发票
    ...Set PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,0))		; 新发票
	...;Set RefundMode=##class(web.DHCBillBankLogic).CheckRefundMode(PrtRowid,PrtOldDr)
	...;Quit:RefundMode=2										; 2 作废重打
	...;If PrtOldDr'="" Set ^TMPDHCINVAPPBalance("PRT",PrtOldDr)=PrtOldDr		; 交易流水能核对上的发票ID
	...If ((AllFlag=0)!(AllFlag=2)) Do
	....Do GetPrtInfo(PrtRowid,Date)
	....Set TJudge="His交易成功,交易记录不成功,发票表ID"_PrtRowid
	....Do OutputrowPay
	..Else  Do
	...;If (OldInvDr="") Do										; 说明收费
	...If ((AllFlag=0)!(AllFlag=2)) Do
	....Do GetPrtInfo(PrtRowid,Date)
	....Set TJudge="His交易成功,交易记录不成功,发票表ID"_PrtRowid
	....Do OutputrowPay
	.; 取对账表差错信息
	.Set IBTRowID=""
	.For  Set IBTRowID=$o(^User.DHCINVAliBalanceI("BANKFINDATE",Date,IBTRowID)) Quit:IBTRowID=""  Do
	..Quit:IBTRowID=0
	..Quit:$d(^TMPDHCINVAPPBalance("IBT",IBTRowID))
	..If ((AllFlag=0)!(AllFlag=2)) Do
	...Do GetIBTInfo(IBTRowID)
	...Set TJudge="交易回款中有记录,His无对应成功交易记录,回款表ID"_IBTRowID
	...Do OutputrowPay
	
	;Set (PatNo,PatName,TradeHospDesc,TradeChannel,UserName,TradeCardNo,TradeDate,TradeTime,BankTradeType,TradeAmt,TradeTxtDate,TradeTxtTime,TradeRRN,HisTradeNo)=""
	;Set PrtPapminame="合计"
	;Do OutputrowPay 
	Kill ^TMPDHCINVAPPBalance
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
GetIAPInfo(IBPRowid)
	Set PapmiRowid=$p(^DHCINVALITP(IBPRowid),"^",48)				; 基本信息
	s PatNo="",PatName=""
	i PapmiRowid'="" d
    .Set PatNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",1)				; 病人登记号
    .Set PatName=$p(^PAPER(PapmiRowid,"ALL"),"^",1)				; 病人姓名
	Set TradeHospDr=$p(^DHCINVALITP(IBPRowid),"^",28)				; 医院ID
	Set TradeHospDesc=..GetHospital(TradeHospDr)
	Set TradeChannel=$p(^DHCINVALITP(IBPRowid),"^",31)			; 渠道代码
	Set TradeChannel=..GetChannelDesc(TradeChannel)
	Set TradeUser=$p(^DHCINVALITP(IBPRowid),"^",25)				; 交易操作员
	Set UserName=..GetUserName(TradeUser)
	Set TradeCardNo=$p(^DHCINVALITP(IBPRowid),"^",3)				; 银行卡号
	Set TradeDate=$p(^DHCINVALITP(IBPRowid),"^",21)				; HIS交易日期
	Set TradeDate=$zd(TradeDate,3)
	Set TradeTime=$p(^DHCINVALITP(IBPRowid),"^",22)				; HIS交易时间
	Set TradeTime=$zt(TradeTime,1)
	Set BankTradeType=$p(^DHCINVALITP(IBPRowid),"^",24)			; 交易类型
	Set BankTradeType=..GetBankTradeType(BankTradeType)
	Set TradeAmt=$p(^DHCINVALITP(IBPRowid),"^",23)				; 实收金额
	Set TradeTxtDate=$p(^DHCINVALITP(IBPRowid),"^",14)			; 银行交易日期
	;Set TradeTxtDate=$p(..GetBankTradeDate(TradeTxtDate,"","Date"),"^",1)
	Set TradeTxtTime=$p(^DHCINVALITP(IBPRowid),"^",15)			; 银行交易时间
	;Set TradeTxtTime=$p(..GetBankTradeDate("",TradeTxtTime,"Time"),"^",2)
	Set TradeRRN=$p(^DHCINVALITP(IBPRowid),"^",7)					; 银行交易流水号
	Set HisTradeNo=$p(^DHCINVALITP(IBPRowid),"^",32)			; HIS交易流水号
GetPrtInfo(PrtRowid,Date)
	; INVPRT表有数据，交易明细表没有
	Set PapmiRowid=$p(^DHCINVPRT(PrtRowid),"^",15)				; 基本信息
    Set PatNo=$p(^PAPER(PapmiRowid,"PAT",1),"^",1)				; 病人登记号
    Set PatName=$p(^PAPER(PapmiRowid,"ALL"),"^",1)				; 病人姓名
    ;Set IBPRowid=$o(^DHCINVALITPi(0,"PAPMI",Date,PapmiRowid,""),-1)
    ;If IBPRowid'="" Do
	;.Set Rc=$p(^DHCINVALITP(IBPRowid),"^",1)
	;.Quit:((Rc="00")!(Rc="0000"))								; 过滤成功的交易数据
    ;.Do GetIAPInfo(IBPRowid)
    ;Else  Do
	Set TradeHospDr=$p(^DHCINVPRT(PrtRowid),"^",39)			; 医院ID
	Set TradeHospDesc=..GetHospital(TradeHospDr)
	Set TradeChannel=""										; 渠道代码
	Set TradeChannel=..GetChannelDesc(TradeChannel)
	Set TradeUser=$p(^DHCINVPRT(PrtRowid),"^",21)				; 交易操作员
	Set UserName=..GetUserName(TradeUser)
	Set TradeCardNo=""											; 银行卡号
	Set TradeDate=$p(^DHCINVPRT(PrtRowid),"^",5)				; HIS交易日期
	Set TradeDate=$zd(TradeDate,3)
	Set TradeTime=$p(^DHCINVPRT(PrtRowid),"^",20)				; HIS交易时间
	Set TradeTime=$zt(TradeTime,1)
	Set PrtAcount=$p(^DHCINVPRT(PrtRowid),"^",1)
    Set OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
    Set BankTradeType="",TradeAmt=""
	If ((PrtAcount>0)&(OldInvDr="")) Do
	.Set BankTradeType="C"
	.Set TradeAmt=..GetOPInvWeChatPayAmt(PrtRowid)
	Else  Do
	.Set BankTradeType="D"
	.If PrtAcount<0 Do
    ..Set InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)			; 原发票
    ..Set PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,0))		; 新发票
	..Set TradeAmt=..GetOPInvWeChatPayAmt(PrtOldDr_"|"_PrtRowid)				; 实收金额
	.Else  Do
    ..Set OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)					; 原发票
    ..Set PrtInitInvDr=$o(^DHCINVPRT(0,"InitInvDR",OldInvDr,0))	; 负发票
	..Set TradeAmt=..GetOPInvWeChatPayAmt(PrtRowid_"|"_PrtInitInvDr)				; 实收金额
	Set BankTradeType=..GetBankTradeType(BankTradeType)
	Set TradeTxtDate=""										; 银行交易日期
	Set TradeTxtTime=""										; 银行交易时间
	Set TradeRRN=""											; 银行交易流水号
	Set HisTradeNo=""											; HIS流水号
GetIBTInfo(IBTRowID)
    Set PatNo=""												; 病人登记号
    Set PatName=""												; 病人姓名
 	Set THopDr=$LIST(^User.DHCINVAliBalanceD(IBTRowID),9)
	Set TradeHospDesc=..GetHospital(THopDr)						; 医院ID
	Set TTrannelNo=$LIST(^User.DHCINVAliBalanceD(IBTRowID),15)
	Set TradeChannel=..GetChannelDesc(TTrannelNo)				; 渠道代码
	Set IBTUserId=$LIST(^User.DHCINVAliBalanceD(IBTRowID),16)
	Set UserName=..GetUserName(IBTUserId)						; 交易操作员
	;Set TradeCardNo=$LIST(^User.DHCINVAliBalanceD(IBTRowID),2)	; 银行卡号
	Set THISTradeTime=$LIST(^User.DHCINVAliBalanceD(IBTRowID),8)
	Set TradeDate=$e(THISTradeTime,1,4)_"-"_$e(THISTradeTime,5,6)_"-"_$e(THISTradeTime,7,8)			; HIS交易日期
	Set TradeTime=$e(THISTradeTime,9,10)_":"_$e(THISTradeTime,11,12)_":"_$e(THISTradeTime,13,14)	; HIS交易时间
	Set IBTTradeFlag=$LIST(^User.DHCINVAliBalanceD(IBTRowID),13)
	Set BankTradeType=""
	If IBTTradeFlag=0 Set BankTradeType="扣费"
	If IBTTradeFlag=1 Set BankTradeType="退费"
	Set TradeAmt=$LIST(^User.DHCINVAliBalanceD(IBTRowID),12)	; 实收金额
	;Set TradeAmt=$Fn(TradeAmt/100,"",2)
	Set TBankTradeTime=$LIST(^User.DHCINVAliBalanceD(IBTRowID),6)
	Set TradeTxtDate=$e(TBankTradeTime,1,4)_"-"_$e(TBankTradeTime,5,6)_"-"_$e(TBankTradeTime,7,8)
	Set TradeTxtTime=$e(TBankTradeTime,9,10)_":"_$e(TBankTradeTime,11,12)_":"_$e(TBankTradeTime,13,14)
	Set TradeRRN=$LIST(^User.DHCINVAliBalanceD(IBTRowID),5)	; 银行交易流水号
	Set HisTradeNo=$LIST(^User.DHCINVAliBalanceD(IBTRowID),7)	; HIS流水号
	q 
OutputrowPay
	set Data=$lb(ind-1,PatNo,PatName,TradeHospDesc,TradeChannel,UserName,TradeCardNo,TradeDate,TradeTime,BankTradeType,TradeAmt,TradeTxtDate,TradeTxtTime,TradeRRN,HisTradeNo,TJudge)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod JudgeTradePayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JudgeTradePayExecute ]
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

ClassMethod JudgeTradePayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JudgeCardCPPTradePayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetHospital(HospDr)
{
	Quit:HospDr="" ""
	Set HospDesc=$p(^CT("HOSP",HospDr),"^",2)
	Quit HospDesc
}

ClassMethod GetBankTradeType(BankTradeType)
{
	Set BankTradeType=$Case(BankTradeType,"C":"消费","D":"退费",:BankTradeType)
	Quit BankTradeType
}

/// w ##class(web.DHCOPBillAliBalanceAcount).GetChannelDesc("")
ClassMethod GetChannelDesc(ChanCode)
{
	Set ChanCode=$Case(ChanCode,"alipay":"支付宝","wechatpay":"微信",:ChanCode)
	Quit ChanCode
}

ClassMethod GetUserName(UserRowid)
{
	Quit:UserRowid="" ""
	Set UserName=$p(^SSU("SSUSR",UserRowid),"^",2)
	Quit UserName
}

/// wangjian
/// 2014-07-11
/// 根据门诊发票表Rowid获取微信支付额
/// 要考虑医保扩展表
/// w ##class(web.DHCOPBillAliBalanceAcount).GetOPInvWeChatPayAmt("2244307|2244311")
ClassMethod GetOPInvWeChatPayAmt(rowidStr)
{
	;发票如果发票存在医保分解扩展以医保扩展表为准
	n (rowidStr)
	s amt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.i '$d(^DHCINVPRTInsu("0","PRT",rowid)) d
	..s IPM="0"
	..q:'$d(^DHCINVPRT(rowid,"P",IPM))
	..f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	...s s=$g(^DHCINVPRT(rowid,"P",IPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...s payMAmt=+$p(s,"^",3)
	...s handDr=..GetPayModeHardComm("OP",payMDr)
	...i +handDr=3 d
	....s amt=amt+payMAmt
	.e  d
	..s InsuInvID=$o(^DHCINVPRTInsu("0","PRT",rowid,""))
	..s InsuIPM=0
	..q:'$d(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM))
	..f  s InsuIPM=$o(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM)) q:InsuIPM=""  d
	...s s=$g(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...i payMCode="WECHATPAY" b ;;
	...s payMAmt=+$p(s,"^",3)
	...s handDr=..GetPayModeHardComm("OP",payMDr)
	...i +handDr=3 d
	....s amt=amt+payMAmt
	
	s amt=$fn($zabs(amt),"",2)
	
	q amt
}

/// wangjian
/// 2014-07-11
/// 判断是否调用接口(非空则调用)
/// w ##class(web.DHCOPBillAliBalanceAcount).GetPayModeHardComm("OP",32)
ClassMethod GetPayModeHardComm(invType, PayMode)
{
	n (invType,PayMode)
	i PayMode["WECHATPAY" s PayMode=$o(^CT("CTPM",0,"Code",PayMode,""))
	i PayMode["ALIPAY" s PayMode=$o(^CT("CTPM",0,"Code",PayMode,""))
	s HardDr=""
	s invType=" "_invType,PayMode=" "_PayMode
	i $d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode)) d
	.s HardRowID=$o(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode,""))
	.s HardDr=$LIST(^User.DHCCTPayModeExpD(HardRowID),3)
	.s IfMode=$LIST(^User.DHCCTPayModeExpD(HardRowID),4)
	.s tmpPayMode=$tr(PayMode," ","")
	.i +HardDr=3 s HardDr=HardDr_"^"_IfMode_"^"_tmpPayMode
	q HardDr
}

}
