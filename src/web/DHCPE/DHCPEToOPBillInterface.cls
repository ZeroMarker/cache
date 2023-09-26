/// Creator: xy
/// CreatDate: 2018-05-25
/// Description: 体检和计费日报合并相关代码
Class web.DHCPE.DHCPEToOPBillInterface Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 体检收费明细
/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEToOPBillInterface","FindInv","2018-06-09","23:59:59","2018-06-14","09:43:16","",4647,2)
Query FindInv(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, LocID As %String = "") As %Query(ROWSPEC = "Tdate,Ttime,Tamt,Tflag,Tuser,Treceiptsno,Tjkdate,Tpayamt,Tpaymode,Tchequeno,Tbank,Tcompany,Tdeposit,Tregno,Tname,Trowid,Trefinvno,TRoundFee,TISYJJ,TsswrFee,TPaym1:%Float,TPaym2:%Float,TPaym3:%Float,TPaym4:%Float,TPaym5:%Float,TPaym6:%Float,TPaym7:%Float,TPaym8:%Float,TPaym9:%Float,TPaym10:%Float,TPaym11:%Float,TPaym12:%Float,TPaym13:%Float,TPaym14:%Float,TPaym15:%Float,TPaym16:%Float,TPaym17:%Float,TPaym18:%Float,TPaym19:%Float,TPaym20:%Float,TPaym21:%Float,TPaym22:%Float,TPaym23:%Float,TPaym24:%Float,TPaym25:%Float,TPaym26:%Float,TPaym27:%Float,TPaym28:%Float,TPaym29:%Float,TPaym30:%Float")
{
}

ClassMethod FindInvExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, LocID As %String = "") As %Status
{
	
	k ^tempdhcpe("FindInv")
	S ^tempdhcpe("FindInv")=stDate_"^"_endDate_"^"_stTime_"^"_endTime_"^"_footId_"^"_guser
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s Rows=1
 	
 	s TAmountTotal=0
 	s TRoundFeeTotal=0
 	s sswrTotal=0
 	
    set job=$j
	kill ^||TMPPAYMODE("TOTAL",job)    //存放支付方式汇总金额

   	//若footId是预结算记录，查询明细按未结算查询
    if (footId'="") do
    .set preHandinFlag=$p(^DHCOPInsFoot(footId),"^",68)
    .if (preHandinFlag="Y") do
    ..set footId=""
    
    set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime,1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime,1)
    
	i (guser'="")&&(footId="")  d
	.s rowid=""
	.f  s rowid=$o(^DHCPEINVPRT(0,"RPFLAG",guser,"N",rowid))  q:rowid=""  d
	..d getinvdetail
    
	i +$g(footId)>0  d
	.s rowid=0
	.f  s rowid=$o(^DHCPEINVPRT(0,"REPORT",footId,rowid))  q:rowid=""  d
	..d getinvdetail
 		
 
   
    S tdate="合计"
	s (ttime,tamt,tflag,tuser,treceiptsno,tjkdate,tpayamt,tpaymode,tchequeno,tbank,tcompany,tdeposit,tregno,tname2,trowid,trefinvno,TRoundFee,TISYJJ,sswr)=""
    s tamt=$j(TAmountTotal,3,2)
    s TRoundFee=$j(TRoundFeeTotal,3,2)
    s sswr=$j(sswrTotal,3,2)
    d BuildInvPaymAmtAry("TOTAL")
 	d OutPutFindInv	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
getinvdetail
    S TISYJJ="否"
    s tmpstr=$g(^DHCPEINVPRT(rowid))
    s InvHospDR=$p(tmpstr,"^",26)  
    q:(hospDR'="")&&(hospDR'=InvHospDR)
    s InvUserDR=$p(tmpstr,"^",10)  
    q:(guser'="")&&(guser'=InvUserDR)
    s tchequeno="",tbank="",tcompany=""
    s Invdate=$p(tmpstr,"^",11)
    q:((Invdate>endDate)||(Invdate<stDate)) 
    i Invdate'="" s tdate=##class(websys.Conversions).DateLogicalToHtml(Invdate)
    s ttime=$p(tmpstr,"^",12)  
    q:((Invdate=endDate)&&(ttime>endTime))
    s treceiptsno=$p(tmpstr,"^",1)
    q:treceiptsno["DHCPEYJS"
    i ttime'="" s ttime=$ZT(ttime)
    s tamt=+$p(tmpstr,"^",7)
    S TAmountTotal=TAmountTotal+tamt
    s sswr=+$p(tmpstr,"^",21) //分币误差
    s sswr=$j(sswr,3,2)
    s sswrTotal=sswrTotal+sswr
    s tflag=$p(tmpstr,"^",8) 
    //s tamt=tamt+sswr  
    
    s tflag=##class(web.DHCPE.InvPrt).ParseInvFlag(tflag)
    s hasDrop=$o(^DHCPEINVPRT(0,"REF",rowid,""))
    i hasDrop'=""
	{
		s DropInvData=$g(^DHCPEINVPRT(hasDrop))
		s TDropInvFlag=$p(DropInvData,"^",8)
		s TDropInvFlag=##class(web.DHCPE.InvPrt).ParseInvFlag(TDropInvFlag)
		i TDropInvFlag="作废" s tflag=TDropInvFlag	
	}
    

    s tRfInvID=$p(tmpstr,"^",9) 
    i tRfInvID'="" d
	.s trefinvno=$P($G(^DHCPEINVPRT(tRfInvID)),"^",1)
	.s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_tRfInvID,""))
	.i RFocusPrintID'="" d
	..s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),3)
	..s trefinvno=RealInvNo_"("_trefinvno_")"
    ;i trefinvno'="" s trefinvno=$p($g(^DHCPEINVPRT(trefinvno)),"^",1)
    s tuser=$p(tmpstr,"^",10) i tuser'="" s tuser=$p(^SSU("SSUSR",tuser),"^",2)
    
    s RFocusPrintID=""
    s RFocusPrintID=$o(^User.DHCPEINVFocusPrtI("IFPINVDRIndex"," "_rowid,""))
	i RFocusPrintID'="" d
	.s RealInvNo=$LG(^User.DHCPEINVFocusPrtD(RFocusPrintID),3)
	.s treceiptsno=RealInvNo_" ("_treceiptsno_")"

    s tjkdate=$p(tmpstr,"^",15)
    i tjkdate'="" s tjkdate=##class(websys.Conversions).DateLogicalToHtml(tjkdate)
    s tdeposit=+$p(tmpstr,"^",6)
    s adm=$p(tmpstr,"^",2),papmi=$p($g(^PAADM(adm)),"^")
    
    s IsFeeLocFlag=$g(^DHCPESetting("DHCPE","IsFeeLocFlag",LocID)) //是否按科室计费
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",adm,LocID,IsFeeLocFlag)
  	q:LocFlag=1


    s tname2=$P($g(^PAPER(papmi,"ALL")),"^",1)
    s tregno=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
    s trowid=rowid
    s arrcp=$p(tmpstr,"^",4)
    
    kill ^||TMPPAYMODE("SINGLE",job)      //存放单张发票支付方式金额
    s tpayamt=0,tpaymode=""
    s paym="0"
    f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d
    .s ss=^ARRCP(arrcp,"PAYM",paym)
    .s mode=$p(ss,"^",1)
    .q:'$D(^CT("CTPM",mode))
    .i mode'="" d
    ..s pmcode=$p(^CT("CTPM",mode),"^",1)
    ..i ((pmcode="TJYJJ")||(pmcode="TJDJK")) S TISYJJ="是"
    .i mode'="" s pmdesc=$p(^CT("CTPM",mode),"^",2)
    .e  s pmdesc="现金"
    .;s pdamt=+$p(ss,"^",3)+sswr,tpayamt=tpayamt+pdamt
    .s pdamt=+$p(ss,"^",3),tpayamt=tpayamt+pdamt
    .S pdamt=$FN(pdamt,"",2) ,tpayamt=$FN(tpayamt,"",2)
    
    .i tpaymode="" s tpaymode=pmdesc_":"_pdamt
    .s chequeno=$p(ss,"^",4)
    .i tchequeno=""  s tchequeno=chequeno
    .e  d
    ..i chequeno'="" s tchequeno=tchequeno_",  "_chequeno
    .i mode'="" d
    ..s ^||TMPPAYMODE("SINGLE",job,mode)=+$g(^||TMPPAYMODE("SINGLE",job,mode))+pdamt
	..s ^||TMPPAYMODE("TOTAL",job,mode)=$g(^||TMPPAYMODE("TOTAL",job,mode))+pdamt
	s TRoundFee=$j(..GetRoundingFeeByInvPrt(rowid),2,3)
    //i tflag="冲红" s TRoundFee=-TRoundFee
    s TRoundFeeTotal=TRoundFeeTotal+TRoundFee
	d BuildInvPaymAmtAry("SINGLE")
	d OutPutFindInv
	d ClearDynamicData
	q 
BuildInvPaymAmtAry(note)
    
	kill paym
	set paymIndex=0
	set paymDR="0"
	for  set paymDR=$o(^CT("CTPM",paymDR))  quit:(paymDR="")  do
	.q:$g(^CT("CTPM",paymDR))=""
	.q:$g(^DHCPESetting("DHCPE","CashierMode",LocID,paymDR))'="Y"
	.set paymAmt=+$g(^||TMPPAYMODE(note,job,paymDR))
	.s paymIndex=paymIndex+1
	.set paym(paymIndex)=$j(paymAmt,3,2)
	
	kill ^||TMPPAYMODE(note,job)
	quit 	
    
ClearDynamicData 
	s (ttime,tamt,tflag,tuser,treceiptsno,tjkdate,tpayamt,tpaymode,tchequeno,tbank,tcompany,tdeposit,tregno,tname2,trowid,trefinvno,TRoundFee,TISYJJ,sswr)="" 
   	q
OutPutFindInv
	set Data=$lb(tdate,ttime,$j(tamt,3,2),tflag,tuser,treceiptsno,tjkdate,$j(tpayamt,3,2),tpaymode,tchequeno,tbank,tcompany,tdeposit,tregno,tname2,trowid,trefinvno,$j($g(TRoundFee),3,2),TISYJJ,sswr,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20),paym(21),paym(22),paym(23),paym(24),paym(25),paym(26),paym(27),paym(28),paym(29),paym(30))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
 	quit
}

ClassMethod FindInvFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInvExecute ]
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

ClassMethod FindInvClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInvExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 根据发票获取体检凑整费
/// d ##class(web.DHCPE.DHCPEToOPBillInterface).GetRoundingFeeByInvPrt(1401)
ClassMethod GetRoundingFeeByInvPrt(invid) As %String
{
	new rtn,i
	new invData,roundfeeid
	new billId,relateId,preAuditId
	new preAdmId,childsub,feesub,FeeType,subroot,feeData
	new amount,FactAmount
	s rtn=""
	if invid="" q rtn
	
	s RPEINVID=$p(^DHCPEINVPRT(invid),"^",9)
    s Flag=1
    i RPEINVID'="" d
    .s CurINVID=RPEINVID
    .s Flag=-1

	s invData=$g(^DHCPEINVPRT(invid))
	if invData="" q rtn
	s paadm=$P($g(^DHCPEINVPRT(invid)),"^",2)
	s locid=$P($G(^PAADM(paadm)),"^",4)
	
	//s roundfeeid=$g(^DHCPESetting("DHCPE","RoundingFee"))
    s roundfeeid=$g(^DHCPESetting("DHCPE","RoundingFee",locid))

	if roundfeeid=""  q rtn
	
	s i=0
	s billId=$p(invData,"^",3)
	s relateId=""

	s amount=0		
	f  s relateId=$o(^DHCPEPAPBR(0,"PBDR",billId,relateId)) q:(relateId="")  d
	.s preAuditId=$p($g(^DHCPEPAPBR(relateId)),"^",1)
	.q:preAuditId=""
	.///取项目
	.s FeeType=1
	.s subroot="ORDITEM"
	.s preAdmId=""
	.f  s preAdmId=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId)) q:((preAdmId=""))  d
	..s childsub=""
	..f  s childsub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub)) q:((childsub=""))  d
	...
	...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",16)'=1	//判断是否有效
	...q:$p($g(^DHCPEPreIADM(preAdmId,"ORDITEM",childsub)),"^",1)'=roundfeeid	//判断是否有效
	...
	...s feesub=0
	...f  s feesub=$o(^DHCPEPreIADM(0,"PAORDITEM",preAuditId,preAdmId,childsub,feesub)) q:((feesub=""))  d
	....s feeData=$g(^DHCPEPreIADM(preAdmId,subroot,childsub,"FEE",feesub))	
	....s FactAmount=$p(feeData,"^",2)
	....s amount=amount+(FactAmount*Flag)
	q amount
}

/// 体检集中打印发票
/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEToOPBillInterface","FindFocusReportDetail","2018-05-18","14:35:18","2018-05-25","16:59:11","",4647,2)
Query FindFocusReportDetail(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String) As %Query(ROWSPEC = "TID:%String,TPrintDate:%String,TInvName:%String,TInvNo:%String,TInvAmt:%String,TInvTime:%String,TBillDate:%String,TInvTypeDesc:%String,TName:%String,TRegNo:%String")
{
}

ClassMethod FindFocusReportDetailExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String) As %Status
{
 
 	set repid=$I(^CacheTemp)
	set ind=1
    
   	//若footId是预结算记录，查询明细按未结算查询
    if (footId'="") do
    .set preHandinFlag=$p($g(^DHCOPInsFoot(footId)),"^",68)
    .if (preHandinFlag="Y") do
    ..set footId=""
    
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime,1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime,1)
    
    s TAmountTotal=0
    
    if (footId'=""){
	   
	 	s ID=""
	 	f  s ID=$O(^User.DHCPEINVFocusPrtI("IFPReportDRIndex",footId,ID)) q:ID=""  d
	 	.d OutOneInfo
 	}
 	else{
	 	
	 	f Date=stDate:1:endDate d
	 	.s ID=""
	 	.f  s ID=$O(^User.DHCPEINVFocusPrtI("FlagUserDateIndex","N",guser,Date,ID)) q:ID=""  d
	 	..s IFPTime=$LG(^User.DHCPEINVFocusPrtD(ID),6)
	 	..q:((Date=endDate)&&(IFPTime>endTime))
	 	..d OutOneInfo
	
 	}
 	
 	S TPrintDate="合计"
	s (ID,TInvName,TInvNo,TInvTime,TBillDate,TInvTypeDesc,TName,TRegNo)=""
    set Data=$lb(ID,TPrintDate,TInvName,TInvNo,TAmountTotal,TInvTime,TBillDate,TInvTypeDesc,TName,TRegNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutOneInfo
	s TPrintDate=$LG(^User.DHCPEINVFocusPrtD(ID),5)
	s:TPrintDate'="" TPrintDate=##class(websys.Conversions).DateLogicalToHtml(TPrintDate)
	s TInvTime=$LG(^User.DHCPEINVFocusPrtD(ID),6)
	s:TInvTime'="" TInvTime=$ZT(TInvTime)
	s TInvNo=$LG(^User.DHCPEINVFocusPrtD(ID),3)
	s InvID=$LG(^User.DHCPEINVFocusPrtD(ID),2)
	s TInvType=$LG(^User.DHCPEINVFocusPrtD(ID),11)
	s TuserDR=$LG(^User.DHCPEINVFocusPrtD(ID),4)  
	q:((guser'="")&&(guser'=TuserDR))
	s TInvHospDR=$LG(^User.DHCPEINVFocusPrtD(ID),12)
	q:((hospDR'="")&&(hospDR'=TInvHospDR))
	s CardType=""
	
	i TInvType="N" d
	.s TBillDate=$P($g(^DHCPEINVPRT(InvID)),"^",11)
	.s:TBillDate'="" TBillDate=##class(websys.Conversions).DateLogicalToHtml(TBillDate)
	.s TInvAmt=$P($g(^DHCPEINVPRT(InvID)),"^",7)
	.s paadm=$P($g(^DHCPEINVPRT(InvID)),"^",2)
	.s patid=$p($g(^PAADM(paadm)),"^",1)
	.s TName=$p($g(^PAPER(patid,"ALL")),"^",1)
	.S TRegNo=$p($g(^PAPER(patid,"PAT",1)),"^",1)
	.s InvName=$g(^DHCPEDataEx("InvName",InvID))
	i TInvType="Y" d
	.s APID=$p(InvID,"||",1)
	.s Sub=$p(InvID,"||",2)
	.s TInvAmt=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",2)
	.s CardType=$p($g(^DHCPEAP(APID)),"^",3)
	.s TRegNo=""
	.i CardType="R" d
	..s TRegNo=$p($g(^DHCPEAP(APID)),"^",1) 
    .s TSourceNo=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",4)
	.s InvoID=TSourceNo
	.s TInvName=""
	.s:InvoID'="" TInvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	.s TName=""
	.i TRegNo'="" d
	..s PAID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
	..s TName=$P($g(^PAPER(PAID,"ALL")),"^",1)
	.e  d 
	..s TName=$p($g(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	.;b ; APID_"^"_Sub
	.s TBillDate=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",5)
	.s:TBillDate'="" TBillDate=##class(websys.Conversions).DateLogicalToHtml(TBillDate)
	i (TInvType="Y")&(CardType="R") S TInvTypeDesc="体检预交金"
	i (TInvType="Y")&(CardType="C") S TInvTypeDesc="体检代金卡"
	i (TInvType="N")&&(CardType="") S TInvTypeDesc="非预交金"
	d DetailOutputRow
	q
   
DetailOutputRow
	set Data=$lb(ID,TPrintDate,TInvName,TInvNo,TInvAmt,TInvTime,TBillDate,TInvTypeDesc,TName,TRegNo)
 	s TAmountTotal=TAmountTotal+TInvAmt
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindFocusReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindFocusReportDetailExecute ]
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

ClassMethod FindFocusReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindFocusReportDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 体检预交金明细
/// d ##class(%ResultSet).RunQuery("web.DHCPE.DHCPEToOPBillInterface","SearchAPACDetail","","","","","34775",4647,2)
Query SearchAPACDetail(stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, locId As %String) As %Query(ROWSPEC = "TRowID:%String,TRegNo:%String,TRemainAmount:%Float,TType:%String,TAmount:%Float,TSourceNo:%String,TDate:%String,TTime:%String,TUser:%String,TRemark:%String,TName:%String,TReport:%String,TPayMode:%String,TCardNo:%String,TTime:%String,TSex:%String,TAge:%String,TPaym1:%Float,TPaym2:%Float,TPaym3:%Float,TPaym4:%Float,TPaym5:%Float,TPaym6:%Float,TPaym7:%Float,TPaym8:%Float,TPaym9:%Float,TPaym10:%Float,TPaym11:%Float,TPaym12:%Float,TPaym13:%Float,TPaym14:%Float,TPaym15:%Float,TPaym16:%Float,TPaym17:%Float,TPaym18:%Float,TPaym19:%Float,TPaym20:%Float,TPaym21:%Float,TPaym22:%Float,TPaym23:%Float,TPaym24:%Float,TPaym25:%Float,TPaym26:%Float,TPaym27:%Float,TPaym28:%Float,TPaym29:%Float,TPaym30:%Float")
{
}

ClassMethod SearchAPACDetailExecute(ByRef qHandle As %Binary, stDate As %String, stTime As %String, endDate As %String, endTime As %String, footId As %String, guser As %String, hospDR As %String, locId As %String) As %Status
{
	
	set repid=$I(^CacheTemp)
	set ind=1
   
   	//若footId是预结算记录，查询明细按未结算查询
    if (footId'="") do
    .set preHandinFlag=$p(^DHCOPInsFoot(footId),"^",68)
    .if (preHandinFlag="Y") do
    ..set footId=""
    
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime,1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime,1)
    
    s TAmountTotal=0
    set job=$j
	kill ^||TMPPAYMODE("TOTAL",job)    //存放支付方式汇总金额

     if (footId'=""){
	    
	 	s APID=""
	 	f  s APID=$O(^DHCPEAP(0,"Report",footId,APID)) q:APID=""  d
	 	.S Sub=0
	 	.f  s Sub=$O(^DHCPEAP(0,"Report",footId,APID,Sub)) q:Sub=""  d
	 	..d GetOneInfoDetail
     }else{
	   /*
	     s APID=""
	     f  s APID=$O(^DHCPEAP(0,"ReportFlag",guser,"N",APID)) q:APID=""  d
	     .S Sub="0"
	     .f  s Sub=$O(^DHCPEAP(0,"ReportFlag",guser,"N",APID,Sub)) q:Sub=""  d
	     ..s tDate=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",5)
	     ..q:(tDate<stDate)||(tDate>endDate)
	     ..s tTime=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",6)
	     ..q:((tDate=endDate)&&(tTime>endTime))
	     ..d GetOneInfoDetail
	     */
	     f Date=stDate:1:endDate d
	 	.s APID=""
	 	.f  s APID=$o(^DHCPEAP(0,"Date",Date,APID))  q:APID=""  d
	 	..s Sub=""
	 	..f  s Sub=$o(^DHCPEAP(0,"Date",Date,APID,Sub))  q:Sub=""  d
	 	...s tDate=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",5)
	    ...s tTime=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",6)
	    ...q:((tDate=endDate)&&(tTime>endTime))
	    ...s tReport=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",9)
	    ...Q:tReport'=""
	    ...d GetOneInfoDetail
     }
		
	
	S TDate="合计"
	s (TRowID,TRegNo,TRemainAmount,TTypeDesc,TSourceNo,TTime,TUser,TRemark,TName,TReport,TPayModeDesc,TCardNo,TTime,Sex,Birth)=""
    s TAmount=$j(TAmountTotal,3,2)
    d BuildPaymAmtAryAPAC("TOTAL")
 	d FindBuildDetail	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetOneInfoDetail
	;q:1=##class(web.DHCPE.AdvancePayment).IsCurLocCard(APID)
 	s CType=$p($g(^DHCPEAP(APID)),"^",3)
 	s TRowID=APID_"||"_Sub
 	s TRegNo=""
	i CType="R" d
	.s TRegNo=$p($g(^DHCPEAP(APID)),"^",1)

	s TCardNo=$p($g(^DHCPEAP(APID)),"^",2)
	s TType=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",1)

	q:(TType'="B")&&(TType'="R")&&(TType'="RF")
	s APACHospDR=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",15)
	q:(hospDR'="")&&(hospDR'=APACHospDR)
	s APACUserDR=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",7)
	q:(guser'="")&&(guser'=APACUserDR)
	s TAmount=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",2)
	s TAmount=$j(TAmount,3,2)
	s TAmountTotal=TAmount+TAmountTotal
	s TRemainAmount=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",3)
	s TSourceNo=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",4)
	s InvoID=TSourceNo
	
	s InvName=""
	s:InvoID'="" InvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	i TType="RF" d
	.s InvoID=$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)
	.s:InvoID'="" InvName=$G(^DHCPEDataEx("AdvancePayment","InvName",InvoID))
	.s TSourceNo="退"_$p($g(^DHCPEAP(+TSourceNo,"AC",$p(TSourceNo,"||",2))),"^",4)

	
	i (TType="B")||(TType="R") d
	.q:'$D(^DHCPEAP(0,"SourceNo","RF",TRowID))
	.s TSourceNo=TSourceNo_"(已退)"
	s TTypeDesc=""
	I TType'="" s TTypeDesc=##class(web.DHCPE.AdvancePayment).GetTypeDesc(TType)

	s TDate=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",5)
	s TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
	s TTime=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",6)
	s:TTime'="" TTime=##class(websys.Conversions).TimeLogicalToHtml(TTime)
	s TUser=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",7)
	s:TUser'="" TUser=$P(^SSU("SSUSR",TUser),"^",2)
	s TRemark=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",8)
	s TReport=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",9)
	s TReportFlag=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",13)
	s:(TReportFlag="Y")&&(TReport="") TReport="a"
	s TPayMode=$p($g(^DHCPEAP(APID,"AC",Sub)),"^",10)
	kill ^||TMPPAYMODE("SINGLE",job)      //存放单张发票支付方式金额
	I TPayMode'="" D
	.set ^||TMPPAYMODE("SINGLE",job,TPayMode)=+$g(^||TMPPAYMODE("SINGLE",job,TPayMode))+TAmount
	.set ^||TMPPAYMODE("TOTAL",job,TPayMode)=$g(^||TMPPAYMODE("TOTAL",job,TPayMode))+TAmount
	
	s TPayModeDesc=""
	i TPayMode'="" d
	.s TPayModeDesc=$P($G(^CT("CTPM",TPayMode)),"^",2)
	.i $g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))'="" d
	..s TPayModeDesc=$P($G(^CT("CTPM",TPayMode)),"^",2)_"("_$g(^DHCPEDataEx("DHCPEAD","paymode",APID_"||"_Sub))_")"
	
	s Sex=""
	i CType="R" d
	.s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
	.s TName=$P(^PAPER(ID,"ALL"),"^",1)
	.s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
	.s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	.s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
	.S Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
	.S Age=##class(web.DHCBillInterface).GetPapmiAge(ID)

	e  d
	.i TTypeDesc="结算" d
	..s PAADM=$P($G(^DHCPB(TSourceNo)),"^",1)
	..q:PAADM=""
	..s ID=$P(^PAADM(PAADM),"^",1)
	..s TName=$P(^PAPER(ID,"ALL"),"^",1)
	..s Sex=$p($g(^PAPER(ID,"ALL")),"^",7)
	..s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	..s Birth=$p($g(^PAPER(ID,"ALL")),"^",6)
	..S Birth=##class(websys.Conversions).DateLogicalToHtml(Birth)
	..S Age=##class(web.DHCBillInterface).GetPapmiAge(ID)
	.e  i (TTypeDesc="转入")||(TTypeDesc="转出") d
	..s TName=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	..s Sex=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",2)
	.e  i TTypeDesc="退预缴金" d
	..s TSourceNo="退"_$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4)
	..s TName=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",1)
	..s Sex=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",2)
	..s Age=$p($G(^DHCPEDataEx("DHCPEAD","InvID",$p($g(^DHCPEAP(+TRowID,"AC",$p(TRowID,"||",2))),"^",4))),"^",3)
    ..s Birth=""
	.e  d
	..;q:InvoID=""
	..;s TName=$G(^DHCPEDataEx("DHCPEAD","InvID",TRowID))
	..s TName=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",1)
	..s Sex=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",2)
	..s Age=$p($G(^DHCPEDataEx("DHCPEAD","InvID",TRowID)),"^",3)
    ..s Birth=""
    
	d BuildPaymAmtAryAPAC("SINGLE")
	d FindBuildDetail
	q 
BuildPaymAmtAryAPAC(note)
	k paym
	s i=0
	s paymDR="0"
	f  s paymDR=$o(^CT("CTPM",paymDR))  q:(paymDR="")  do
	.q:$g(^DHCPESetting("DHCPE","CardMode",locId,paymDR))'="Y"
	.s paymInfo=$g(^CT("CTPM",paymDR))
	.q:(paymInfo="")
	.s paymAmt=+$g(^||TMPPAYMODE(note,job,paymDR))
	.;s paym($i(i))=$j(paymAmt,3,2)
	.s i=i+1
	.s paym(i)=$j(paymAmt,3,2)
	k ^||TMPPAYMODE(note,job)
	
	
	q	
FindBuildDetail      
	set Data=$lb(TRowID,TRegNo,TRemainAmount,TTypeDesc,TAmount,TSourceNo,TDate,TTime,TUser,TRemark,TName,TReport,TPayModeDesc,TCardNo,$G(TTime),Sex,Birth,paym(1),paym(2),paym(3),paym(4),paym(5),paym(6),paym(7),paym(8),paym(9),paym(10),paym(11),paym(12),paym(13),paym(14),paym(15),paym(16),paym(17),paym(18),paym(19),paym(20),paym(21),paym(22),paym(23),paym(24),paym(25),paym(26),paym(27),paym(28),paym(29),paym(30))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchAPACDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAPACDetailExecute ]
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

ClassMethod SearchAPACDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAPACDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:      xy
/// CreatDate:    2018-05-25
/// Description:  取体检收费明细列头
/// Input:        LocID(科室ID)
/// Output: 
/// Debug: w ##class(web.DHCPE.DHCPEToOPBillInterface).GetInvDetColumns()
ClassMethod GetInvDetColumns(LocID As %String = "") As %String
{
	
	kill columnAry
	set i=0
	set columnAry($i(i))="Tdate^交款日期"
	set columnAry($i(i))="Ttime^交款时间"
	set columnAry($i(i))="Tname^交款人"
	set columnAry($i(i))="Tregno^登记号"
	//set columnAry($i(i))="Tpayamt^总金额"
	set columnAry($i(i))="Tamt^总金额"
	set columnAry($i(i))="Treceiptsno^发票号"
	set columnAry($i(i))="Trefinvno^原始发票号"
	set columnAry($i(i))="Tflag^状态"
	set columnAry($i(i))="Trowid^记录号"
	set columnAry($i(i))="TISYJJ^是否体检预交金"
	//set columnAry($i(i))="TRoundFee^凑整费"
	set columnAry($i(i))="TsswrFee^分币误差"
	
	

	set paymIndex=0
	set paymId=0
	for  set paymId=$o(^CT("CTPM",paymId))  quit:(paymId="")  do
	.Q:$g(^DHCPESetting("DHCPE","CashierMode",LocID,paymId))'="Y"
	.set paymInfo=$g(^CT("CTPM",paymId))
	.quit:(paymInfo="")
	.set colField="TPaym"_$i(paymIndex)
	.set colTitle=$p(paymInfo,"^",2)
	.set columnAry($i(i))=colField_"^"_colTitle
	/*
	set columnAry($i(i))="TInvRoundErrSum^分币误差"
	*/
	set jsonStr=""
	set index=0
	for  set index=$o(columnAry(index)) quit:(index="")  do
	.set field=$p(columnAry(index),"^",1)
	.set title=$p(columnAry(index),"^",2)
	.set align="left"
	.if ((field["TPaym")||(field["payamt")||(field["Fee")||(field["amt")) do
	..set align="right"
	.set myJson="{""field"":"""_field_""",""title"":"""_title_""",""align"":"""_align_""",""halign"":""center"",""width"":"_100_"}"
	.if (jsonStr="") do
	..set jsonStr=myJson
	.else  do
	..set jsonStr=jsonStr_","_myJson

	set jsonStr="["_jsonStr_"]"
	
	quit jsonStr
}

/// Creator:     xy
/// CreatDate:   2018-05-25
/// Description: 取体检预交金明细明细列头
/// Input:        LocID(科室ID)
/// Output:  
/// Debug: w ##class(web.DHCPE.DHCPEToOPBillInterface).GetAdvanceInvDetColumns()
ClassMethod GetAdvanceInvDetColumns(LocID As %String = "") As %String
{
	
	kill columnAry
	set i=0
	set columnAry($i(i))="TDate^日期"
	set columnAry($i(i))="TTime^时间"
	set columnAry($i(i))="TName^姓名"
	set columnAry($i(i))="TRegNo^登记号"
	set columnAry($i(i))="TAmount^总金额"
	set columnAry($i(i))="TSourceNo^收据号"
	set columnAry($i(i))="TCardNo^代金卡号"
	set columnAry($i(i))="TType^类型"
	
	

	set paymIndex=0
	set paymId=0
	for  set paymId=$o(^CT("CTPM",paymId))  quit:(paymId="")  do
	.quit:$g(^DHCPESetting("DHCPE","CardMode",LocID,paymId))'="Y"
	.set paymInfo=$g(^CT("CTPM",paymId))
	.quit:(paymInfo="")
	.set colField="TPaym"_$i(paymIndex)
	.set colTitle=$p(paymInfo,"^",2)
	.set columnAry($i(i))=colField_"^"_colTitle
	/*
	set columnAry($i(i))="TInvRoundErrSum^分币误差"
	*/
	set jsonStr=""
	set index=0
	for  set index=$o(columnAry(index)) quit:(index="")  do
	.set field=$p(columnAry(index),"^",1)
	.set title=$p(columnAry(index),"^",2)
	.set align="left"
	.if ((field["TPaym")||(field["Amount")||(field["Fee")) do
	..set align="right"
	.set myJson="{""field"":"""_field_""",""title"":"""_title_""",""align"":"""_align_""",""halign"":""center"",""width"":"_100_"}"
	.if (jsonStr="") do
	..set jsonStr=myJson
	.else  do
	..set jsonStr=jsonStr_","_myJson

	set jsonStr="["_jsonStr_"]"
	
	quit jsonStr
}

/// Creator: xy
/// CreatDate: 2018-06-10
/// Description: 根据日期查找错发票
/// Input: 
/// Output: 
/// Return: 
/// Debug: w ##class(web.DHCPE.DHCPEToOPBillInterface).FindErrInvItem()
ClassMethod FindErrInvItem(stDate As %String, stTime As %String, endDate As %String, endTime As %String, guser As %String, hospDR As %String)
{
	
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
    set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime,1)
    set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime,1)
    
	for date=stDate:1:endDate  do
	.S invid=""
	.f  s invid=$o(^DHCPEINVPRT(0,"DATE",date,invid))  q:invid=""  d 
	..s PRTTime=$p($g(^DHCPEINVPRT(invid)),"^",12)  
    ..q:((date=endDate)&&(PRTTime>endTime))
    ..s PRTUserDR=$p($g(^DHCPEINVPRT(invid)),"^",10)
    ..q:(guser'="")&(guser'=PRTUserDR)
    ..s InvHospDR=$p($g(^DHCPEINVPRT(invid)),"^",26) 
    ..q:(hospDR'="")&&(hospDR'=InvHospDR)
    ..s PRTFlag=$p($g(^DHCPEINVPRT(invid)),"^",8)
    ..q:PRTFlag="Y"
    ..s Amount=$P(^DHCPEINVPRT(invid),"^",7)
    ..s sswc=$P(^DHCPEINVPRT(invid),"^",21)
    ..i sswc'=0 d
    ...s factAmount=Amount+swc
    ..e  d
    ...s factAmount=Amount
    ..s arrcp=$p(^DHCPEINVPRT(invid),"^",4)
    ..s paym="0",PAYMAmtTotal=0
    ..f  s paym=$o(^ARRCP(arrcp,"PAYM",paym)) q:paym=""  d   
    ... s ss=$G(^ARRCP(arrcp,"PAYM",paym))
    ... s paymode=$p(ss,"^",1)
    ...s PAYMAmt=$p(ss,"^",3)
    ...s PAYMAmtTotal=PAYMAmtTotal+PAYMAmt
    ..i +PAYMAmtTotal'=+Amount d
    ...w "ErrPAYM:"_"invid:"_invid_",InvAmount:"_Amount_",PAYMAmtTotal:"_PAYMAmtTotal_",sswc:"_sswc	
	..d GetErrInvInfo
GetErrInvInfo
	
	s ReInvID=$P(^DHCPEINVPRT(invid),"^",9)
	q:ReInvID'=""
	s OneAmt=0
	s ItemID=""
	f  s ItemID=$O(^DHCPEOEITEM(Inv,"OEITEM",ItemID)) q:ItemID=""  d
	.s ItemFactAmount=$p($G(^DHCPEOEITEM(Inv,"OEITEM",ItemID)),"^",4)
	.s arcitmid=$p($G(^DHCPEOEITEM(Inv,"OEITEM",ItemID)),"^",5)
	.s arcitemDesc=$P(^ARCIM(+arcitmid,1,1),"^",2)
	.s TarECID=0,ItemAmount=0
	.f  s TarECID=$O(^DHCPEOEITEM(Inv,"OEITEM",ItemID,"TARITEM",TarECID)) q:TarECID=""  d
	..s TarAmount=$p($G(^DHCPEOEITEM(Inv,"OEITEM",ItemID,"TARITEM",TarECID)),"^",4)
	..s ItemAmount=ItemAmount+TarAmount
	..s OneAmt=OneAmt+TarAmount
	i Amount
	i +OneAmt'=+Amount d
	.w "ErrTarOC:"_"invid:"_invid_",InvAmount:"_Amount_",TarocAmount:"_OneAmt
}

/// Creator: 		xy
/// CreatDate: 		2020-10-10
/// Description: 	体检支付方式提供给计费医保组
/// Input: 			GroupId:安全组ID,LocID:科室ID,HospId:医院ID,UserId:用户ID,Type:B 收费、R 退费
/// Output: 		空 或 支付方式Rowid^支付方式Code^支付方式Desc$c(2)支付方式Rowid^支付方式Code^支付方式
/// Debug: w ##class(web.DHCPE.DHCPEToOPBillInterface).GetTJPaymodeInfo("","","","R")
ClassMethod GetTJPaymodeInfo(GroupId As %String = "", LocID As %String = "", HospId As %String = "", UserId As %String = "", Type As %String = "B")
{
	s PayMode=0,PayModeStr=""
	q:Type="" ""
	if Type="B" d
	.f  s PayMode=$o(^DHCPESetting("DHCPE","CashierMode",LocID,PayMode)) q:PayMode=""  d
	..q:$g(^DHCPESetting("DHCPE","CashierMode",LocID,PayMode))'="Y"
	..s PayModeDesc=$p($g(^CT("CTPM",PayMode)),"^",2)
	..s PayModeCode=$p($g(^CT("CTPM",PayMode)),"^",1)
	..i PayModeStr="" s PayModeStr=PayMode_"^"_PayModeCode_"^"_PayModeDesc
	..e  s PayModeStr=PayModeStr_$C(2)_PayMode_"^"_PayModeCode_"^"_PayModeDesc
	else  if Type="R" d
	.f  s PayMode=$o(^DHCPESetting("DHCPE","RefundMode",LocID,PayMode)) q:PayMode=""  d
	..q:$g(^DHCPESetting("DHCPE","RefundMode",LocID,PayMode))'="Y"
	..s PayModeDesc=$p($g(^CT("CTPM",PayMode)),"^",2)
	..s PayModeCode=$p($g(^CT("CTPM",PayMode)),"^",1)
	..i PayModeStr="" s PayModeStr=PayMode_"^"_PayModeCode_"^"_PayModeDesc
	..e  s PayModeStr=PayModeStr_$C(2)_PayMode_"^"_PayModeCode_"^"_PayModeDesc
	else  d
	.S PayModeStr=""
	
	q PayModeStr
}

}
