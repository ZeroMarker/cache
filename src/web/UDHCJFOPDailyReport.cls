Import SQLUser

Class web.UDHCJFOPDailyReport Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 164;

ClassMethod InvHandin(sUser As %String, FootInfo As %String)
{
	;w ##class(web.UDHCJFOPDailyReport).InvHandin("1683","29/01/2010^22:16:20^30/01/2010^22:16:20")
    ;s ^TMPHandin=sUser_"%%%"_FootInfo
	
	s $ZT="ERROR^SSERR"
	
	s StDate=$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	
	s EndDate=$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	;Q:$d(^TMPOPCat($j))=0 1
	;q:$d(^TMPCatSub($j))=0 1
	
	d ..KillTmp()
	;把发票重新生成，门诊大类项目
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	s myrtn0=$p(myrtn,"^",1)
	q:(myrtn0) myrtn0_"^"
	
     
	
	d ..tb()
	
	k PLIST
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$zdh($p(FootInfo,"^",1),4)		;HIS_StartDate
	s PLIST(5)=$zth($p(FootInfo,"^",2),1)		; HIS_StartTime
	s PLIST(6)=$zdh($p(FootInfo,"^",3),4)		;HIS_EndDate
	s PLIST(7)=$zth($p(FootInfo,"^",4),1)		;HIS_EndTime
	;s PLIST(8)=$p(FootInfo,"^",5)		;HIS_Amount应收额
	s PLIST(8)=$p(myrtn,"^",4)
	
	s PLIST(9)=sUser					;HIS_User
	s PLIST(10)=$p(myrtn,"^",3)		;His_Num	打印票据数量
	s PLIST(11)=$p(myrtn,"^",2)		;HIS_RcptNO

	s PLIST(17)=$p(myrtn,"^",5)		;HIS_PatSum
	s PLIST(22)=$p(myrtn,"^",7)		;HIS_RefundNum
	s PLIST(23)=$p(myrtn,"^",8)		;HIS_RefundSum
	s PLIST(24)=$p(myrtn,"^",11)		;HIS_ParkNum
	s PLIST(25)=$p(myrtn,"^",12)		;HIS_ParkSum
	s PLIST(26)=$p(myrtn,"^",10)		;HIS_ParkINVInfo
	s PLIST(27)=$p(myrtn,"^",6)		;HIS_RefundINVInfo
	s PLIST(30)=$p(myrtn,"^",14)    ;;;   HIS_INVRoundSum
	s PLIST(61)="U"
	;结算主表
	s mycat=""
	s mycatsub=""
	s HISParref=""
	s myrtn=##class(web.UDHCINVPRTReports).Insert()
	i myrtn=0 d
	.s HISParref=PLIST(1)
	
	;b ;;;;;
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=$g(^TMPCatSub($j,mycat,mycatsub))
	...k PLIST
	...;b   
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myPatpay,"",2)
	...s PLIST(5)=mycatsub
	...s PLIST(7)="OP"
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	i myrtn=0  d  
	.;;;门诊结算支付方式统计
	.s paysub=0
	.f  s paysub=$o(^TMPOPPayM($j,paysub))  q:(paysub=""||myrtn'=0)   d
	..s Amt=$g(^TMPOPPayM($j,paysub))
	..q:+Amt=0
	..k PLIST
	..s PLIST(3)=$fn(Amt,"",2)
	..s PLIST(0)=HISParref
	..s PLIST(4)=paysub
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	k ^TMPOPPayM($j)
	
	
	;更新票据流水表
	/*i myrtn=0 d
	.&sql(update DHC_INVPRT set PRT_DHCINVPRTR_DR=:HISParref,PRT_Handin='Y',PRT_HandinDate=:hdate,PRT_HandinTime=:htime
	      where (PRT_Usr=:sUser and PRT_Handin is null and 
	      ((PRT_Date>=:StDate and PRT_Date<:EndDate) or
	       (PRT_Date=:EndDate and PRT_Time<=:EndTime)) ))
	.s myrtn=SQLCODE
	.s:myrtn=100 myrtn=0
	i myrtn=0 d     ;;;;;add  by zhl 090818   S
	.&sql(update DHC_AccPayINV set API_INVRep_DR=:HISParref,API_CheckDate=:hdate,API_CheckTime=:htime,API_CheckUser_DR=:sUser
	      where (API_PUser_DR=:sUser and API_INVRep_DR is null and 
	      ((API_Date>=:StDate and API_Date<:EndDate) or
	       (API_Date=:EndDate and API_Time<=:EndTime)) ))
	.s myrtn=SQLCODE
	.s:myrtn=100 myrtn=0     ;;;;zhl  E
	*/
	i myrtn=0 d 
	.f pdate=StDate:1:EndDate  d
	..s PrtRow=""
	..f  s PrtRow=$o(^DHCINVPRT(0,"UserDate",sUser,pdate,PrtRow)) q:(PrtRow="")!(myrtn)  d
	...s PrtHandin=$p(^DHCINVPRT(PrtRow),"^",10)
	...q:PrtHandin="Y"
	...s PrtFariType=$p(^DHCINVPRT(PrtRow),"^",34)
	...q:PrtFariType'="F"
	...s PrtTime=$p(^DHCINVPRT(PrtRow),"^",20)
	...q:((pdate=EndDate)&(PrtTime>EndTime))
	...&sql(update DHC_INVPRT set PRT_DHCINVPRTR_DR=:HISParref,PRT_Handin='Y',PRT_HandinDate=:hdate,PRT_HandinTime=:htime
	      where Prt_rowid =:PrtRow)
	...s myrtn=SQLCODE	
	...q:(myrtn'=0)   ;退出外层循环
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTmp()
	
	quit myrtn_"^"_HISParref
}

ClassMethod handinreport(StDate, EndDate, Guser, FootItmStr)
{
	s StDate=$zdh(StDate,4)
	s EndDate=$zdh(EndDate,4)
	s recdate=+$h
	s rectime=$p($h,",",2)
    s RecDr=""
	d ..tb()	
	i $g(FootItmStr)=""  d
	.K PLIST(1)
	.S PLIST(2)=+$H,PLIST(3)=+$P($H,",",2)
	.S PLIST(5)=Guser,PLIST(6)="Acc"
	.S PLIST(7)=StDate,PLIST(8)=EndDate
	.&SQL(insert into DHCOPReceipt Values PLIST())
    .i 'SQLCODE  s RecDr=%ROWID
    .s rtn=SQLCODE
    .i rtn=0   d
	..s sum=0
	..f date=StDate:1:EndDate  d
    ...s PDFL=""
    ...f  s PDFL=$o(^DHCACDi("AccPDFL",0,"FootDT",date,PDFL))   q:PDFL=""   d
    ....s receiptflag=$p($g(^DHCACD("AccPDFL",PDFL)),"^",7)
    ....Q:receiptflag'=""
    ....s $p(^DHCACD("AccPDFL",PDFL),"^",7)=Guser
    ....s $p(^DHCACD("AccPDFL",PDFL),"^",8)=recdate
    ....s $p(^DHCACD("AccPDFL",PDFL),"^",9)=rectime
    ....s $p(^DHCACD("AccPDFL",PDFL),"^",23)=RecDr
    e    d
    .K PLIST(1)
	.S PLIST(2)=+$H,PLIST(3)=+$P($H,",",2)
	.S PLIST(5)=Guser,PLIST(6)="Acc"
	.S PLIST(7)=StDate,PLIST(8)=EndDate
	.&SQL(insert into DHCOPReceipt Values PLIST())
    .i 'SQLCODE  s RecDr=%ROWID
    .s rtn=SQLCODE
    .i rtn=0   d
    ..s StDate="",EndDate=""
    ..f i=1:1:$l(FootItmStr,"^")  d
	...s HisId=$p($g(FootItmStr),"^",i)
	...q:HisId=""
	...s Date=$p(^DHCACD("AccPDFL",HisId),"^",1)
	...i (StDate="")||(Date<StDate)  s StDate=Date
	...i (EndDate="")||(Date>EndDate)  s EndDate=Date
	...s receiptflag=$p($g(^DHCACD("AccPDFL",HisId)),"^",7)
    ...Q:receiptflag'=""
    ...s $p(^DHCACD("AccPDFL",HisId),"^",7)=Guser
    ...s $p(^DHCACD("AccPDFL",HisId),"^",8)=recdate
    ...s $p(^DHCACD("AccPDFL",HisId),"^",9)=rectime
    ...s $p(^DHCACD("AccPDFL",HisId),"^",23)=RecDr
    ..&SQL(Update DHCOPReceipt set OPRecStDate=:StDate,OPRecEndDate=:EndDate where OPREC_Rowid=:RecDr)
	..s rtn=SQLCODE
	
	
	
    i rtn=0 d ..tc()
	e  tro
    
    q 0
}

ClassMethod KillTmp()
{
	k ^TMPOPHand($j)
	k ^TMPOPHandsub($j)
	k ^TMPCatSub($j)
	k ^TMPCatSubOther($j)
	k ^TMPOPCat($j)
}

ClassMethod BuildOPINVItem(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
    ;
    ;w ##class(web.UDHCJFOPDailyReport).BuildOPINVItem("2565","61902","63330","61902","63817")

	n (hUser, stdate, sttime, EndDate, EndTime)
	s (INVNOinfo,RefundINVInfo,ParkINVInfo)=""
	s (snum,TotSum,PatPaySum,refundnum,RefTotSum,RefPatPaySum,cancelnum,AbTotSum,AbPatPaySum,RoundSum)=0
	s rtn=0
	k ^TMPOPPayM($j)
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  q:(rtn'=0)  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:((PRTrowid="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)  
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s prinvptrflag=$p(^DHCINVPRT(PRTrowid),"^",3)
    ...q:prinvptrflag'="P"   ;卡消费时是否打印发票
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)+$p(^DHCINVPRT(PRTrowid),"^",37)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)+$p(^DHCINVPRT(PRTrowid),"^",37)
	...s Round=$p(^DHCINVPRT(PRTrowid),"^",37)
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...q:($d(^DHCINVPRTCAPi(0,"INVPRTDR",PRTrowid))||((PrtinvDr'="")&&($d(^DHCINVPRTCAPi(0,"INVPRTDR",PrtinvDr)))))   ;;;zhl 20100109   
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...i PrtNO'=""  d
	....s snum=snum+1
	....s ^TMPOPHand($j,"INV",snum)=PrtNO
	....s ^TMPOPHand($j,"INVNO",+PrtNO)=Flag_"^"_PrtNO			;;按照票据号码生成Global
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	...i (Flag="A")&&(PrtinvDr'="")  d
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s:ParkPrtNO'="" ParkINVInfo=ParkINVInfo_" "_ParkPrtNO_", "
	....s cancelnum=cancelnum+1
	...i (Flag="S")&&(PrtinvDr'="")  d
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s:RefundPrtNO'="" RefundINVInfo=RefundINVInfo_" "_RefundPrtNO_", "
	....s refundnum=refundnum+1
	...s stat=..STATtoOPCAT(PRTrowid,"N")
	...s InvPaySub="0"
	...f  s InvPaySub=$o(^DHCINVPRT(PRTrowid,"P",InvPaySub))  q:InvPaySub=""   d
	....s Paym=$p($g(^DHCINVPRT(PRTrowid,"P",InvPaySub)),"^",1)
	....s PayAmt=$p($g(^DHCINVPRT(PRTrowid,"P",InvPaySub)),"^",3)
    ....q:(Paym="")||('$d(^CT("CTPM",Paym)))
	....s ^TMPOPPayM($j,Paym)=$g(^TMPOPPayM($j,Paym))+PayAmt
	...q:(rtn'=0)
	..s AccInv=""   ;;;;;   add  by zhl 090818   Start
	..f  s AccInv=$o(^DHCINVPRTAPi(0,"Date",pdate,AccInv))  q:((AccInv="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRTAP(AccInv),"^",5)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRTAP(AccInv),"^",4)
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRTAP(AccInv),"^",20)
	...q:Handin'=""
	...s PRTAcount=$p(^DHCINVPRTAP(AccInv),"^",1)+$p(^DHCINVPRTAP(AccInv),"^",23)
	...s PrtPatPay=$p(^DHCINVPRTAP(AccInv),"^",16)+$p(^DHCINVPRTAP(AccInv),"^",23)
	...s Round=$p(^DHCINVPRTAP(AccInv),"^",23)
	...s PrtNO=$p(^DHCINVPRTAP(AccInv),"^",6)
	...s PrtinvDr=$p(^DHCINVPRTAP(AccInv),"^",10)	;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRTAP(AccInv),"^",2)
	...i PrtNO'=""  d
	....s snum=snum+1
	....s ^TMPOPHand($j,"INV",snum)=PrtNO
	....s ^TMPOPHand($j,"INVNO",+PrtNO)=Flag_"^"_PrtNO			;;按照票据号码生成Global
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	...i (Flag="A")&&(PrtinvDr'="")  d
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	....s ParkPrtNO=$p(^DHCINVPRTAP(PrtinvDr),"^",6)		;作废票据的原票据号码?
	....s:ParkPrtNO'="" ParkINVInfo=ParkINVInfo_" "_ParkPrtNO_", "
	....s cancelnum=cancelnum+1
	...i (Flag="S")&&(PrtinvDr'="")  d
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s RoundSum=RoundSum+$g(Round)
	....s RefundPrtNO=$p(^DHCINVPRTAP(PrtinvDr),"^",6)		;红冲票据的原票据号码?
	....s:RefundPrtNO'="" RefundINVInfo=RefundINVInfo_" "_RefundPrtNO_", "
	....s refundnum=refundnum+1
	...s AcclinkInv=""
	...f  s AcclinkInv=$o(^DHCINVPRTCAPi(0,"APINVDR",AccInv,AcclinkInv))  q:((AcclinkInv="")!(rtn'=0))  d
	....s InvDr=$p($g(^DHCINVPRTCAP(AcclinkInv)),"^",1)
	....;i Flag'="N"  s InitInvDr=$o(^DHCINVPRT(0,"InitInvDR",InvDr,"0"))
    ....;s:+$g(InitInvDr)'=0 InvDr=InitInvDr
    ....i (Flag'="N")&&(PRTAcount<0)  s AFlag="A"
    ....e  s AFlag="N"
	....s stat=..STATtoOPCAT(InvDr,AFlag) 
	...s PayMSub="0"
	...f  s PayMSub=$o(^DHCINVPRTAP(AccInv,"P",PayMSub))   q:PayMSub=""  d
	....s Paym=$p($g(^DHCINVPRTAP(AccInv,"P",PayMSub)),"^",1)
	....s PayAmt=$p($g(^DHCINVPRTAP(AccInv,"P",PayMSub)),"^",3)
    ....q:(Paym="")||('$d(^CT("CTPM",Paym)))
	....s ^TMPOPPayM($j,Paym)=$g(^TMPOPPayM($j,Paym))+PayAmt
	...q:(rtn'=0)    ;;;;;zhl   End
	.i snum>0  d
	..s INVNOinfo=..GetINVNOList()
	

	s rtn=rtn_"^"_INVNOinfo_"^"_snum_"^"_TotSum_"^"_PatPaySum_"^"_RefundINVInfo_"^"_refundnum_"^"_RefTotSum_"^"_RefPatPaySum_"^"_ParkINVInfo
	s rtn=rtn_"^"_cancelnum_"^"_AbTotSum_"^"_AbPatPaySum_"^"_RoundSum
	q rtn
}

ClassMethod getsubcat() As %String
{
	;;门诊收费大类或子类?最好是子类
	s n=1
	s ret=""
	s itmrowid=0 f  s itmrowid=$o(^DHCTarC("TOC",itmrowid)) q:itmrowid=""  d
	.s itm=$p(^DHCTarC("TOC",itmrowid),"^",2)
	.i $g(^TMPOPHandsub($j))="" s ^TMPOPHandsub($j)=0
	.s ^TMPOPHandsub($j,itm)=0
	.i $g(^TMPdhcsfdaily1)="" s ^TMPdhcsfdaily1=0
	.s ^TMPdhcsfdaily1(n)=itmrowid
	.i ret=""  s ret=itm
	.e  s ret=ret_"^"_itm
	.s ^TMPOPHandsub($j)=n
	.s ^TMPdhcsfdaily1=n
	.s n=n+1
	q ret
}

ClassMethod STATtoOPCAT(INVPRTRowid As %String, AFlag As %String = "")
{
	;把一张票据转化为门诊收费大类或子类
	;
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
	...s totmp=+$g(^TMPOPHandsub($j,OPCatDesc))
	...s:$g(AFlag)="A" TotalAmount=0-TotalAmount
	...s totmp=totmp+TotalAmount
	...;定义一个^TmpCatSub($j,Cat,CatSub)
	...i +ItmOPCat=18  s ^TMP("ZHLTest","Hand",Bill_"||"_Ord_"||"_Itm,AFlag)=AFlag_"^"_TotalAmount
	...s ^TMPCatSub($j,ItmOPCat,ItmOPSubCat)=+$g(^TMPCatSub($j,ItmOPCat,ItmOPSubCat))+TotalAmount
	...s ^TMPCatSubOther($j,"SubCat",ItmOPSubCat)=+$g(^TMPCatSubOther($j,"SubCat",ItmOPSubCat))+TotalAmount
	...s ^TMPOPHandsub($j,OPCatDesc)=totmp
	...s ^TMPOPCat($j,ItmOPCat)=+TotalAmount+$g(^TMPOPCat($j,ItmOPCat))
	q 0
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

ClassMethod GetINVNOList() As %String
{
   ;;;creat by zhl  090818  
	;w ##class(web.udhcOPHandin).GetINVNOinfo("1")
	s INVNOinfo=""
	s Count = 0,newflag=0
	s startno="",endno="",lenReceipNo=8
	s num=0 f  s num=$o(^TMPOPHand($j,"INVNO",num)) q:num=""  d
	.s invtmp=$p(^TMPOPHand($j,"INVNO",num),"^",2)
	.q:+invtmp=0
	.i (+$g(startno)=0)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.i $o(^TMPOPHand($j,"INVNO",num))'=""  d
	..s next=$o(^TMPOPHand($j,"INVNO",num))
	..s newinv=$p(^TMPOPHand($j,"INVNO",next),"^",2)
	..i (+newinv-1=+endno)  d
	...s endno=endno+1
	..e  d
	...s Count=Count+1
	...s endno=..FormatINVNO(endno,lenReceipNo)
	...s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	...s startno="", endno=""
	...s newflag=1
	i (INVNOinfo="")!(Count >= 1) d
	.s endno=..FormatINVNO(endno,lenReceipNo)
	.s INVNOinfo = INVNOinfo_"  "_startno_"--"_endno
	q INVNOinfo
}

ClassMethod GetINVNOinfo(znum As %String) As %String
{
	;w ##class(web.udhcOPHandin).GetINVNOinfo("1")
	s INVNOinfo=""
	s Count = 0,newflag=0
	s num=0 f  s num=$o(^TMPOPHand($j,"INV",num)) q:num=""  d
	.s invtmp=^TMPOPHand($j,"INV",num)
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.i $d(^TMPOPHand($j,"INV",num+1))'=0  d
	..s newinv=^TMPOPHand($j,"INV",num+1)
	..i (+newinv-1=+endno)  d
	...s endno=endno+1
	..e  d
	...s Count=Count+1
	...s endno=..FormatINVNO(endno,lenReceipNo)
	...s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	...s startno="", endno=""
	...s newflag=1
	
	i (INVNOinfo="")!(Count >= 1) d
	.s endno=..FormatINVNO(endno,lenReceipNo)
	.s INVNOinfo = INVNOinfo_"  "_startno_"--"_endno
	q INVNOinfo
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod AccHandin(sUser As %String, FootInfo As %String)
{
	s $ZT="ERROR^SSERR"
	s StDate=$zdh($p(FootInfo,"^",1),4)
	s StTime=$zth($p(FootInfo,"^",2),1)
	s EndDate=$zdh($p(FootInfo,"^",3),4)
	s EndTime=$zth($p(FootInfo,"^",4),1)
	s hdate=+$h
	s htime=$p($h,",",2)
	s CardInfo=..GetCardInfo(sUser,StDate,StTime,EndDate,EndTime)
	d ..tb()
	k PLIST
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=sUser		;HIS_StartDate
	;s PLIST(5)=$zdh($p(FootInfo,"^",1),4)	; HIS_StartTime
	;s PLIST(6)=$zth($p(FootInfo,"^",2),1)		;HIS_EndDate
	s PLIST(5)=$zdh($p(FootInfo,"^",3),4)	; HIS_StartTime       ///update by zhl 2010.05.06     xy
	s PLIST(6)=$zth($p(FootInfo,"^",4),1)		;HIS_EndDate          ///update by zhl 2010.05.06   xy
	s PLIST(7)=sUser					;AccPDF_OperUser_DR
	s PLIST(24)=$p(CardInfo,"^",1)      ;;add by zhl 2010.01.12
	s PLIST(25)=$p(CardInfo,"^",2)      ;;add by zhl 2010.01.12
	s PLIST(20)=$p(CardInfo,"^",3)      ;;add by zhl 2010.04.06
	s PLIST(21)=$p(CardInfo,"^",4)      ;;add by zhl 2010.04.06
	s PLIST(19)=$p(CardInfo,"^",5)      ;;add by zhl 2010.04.06
	s PLIST(15)=$p(CardInfo,"^",6)      ;;add by zhl 2010.04.06
	s PLIST(16)=$p(CardInfo,"^",7)      ;;add by zhl 2010.04.06
	;结算主表
	s HISParref=""
	s myrtn=##class(web.DHCAccPDFootLog).Insert()
	i myrtn=0 d
	.s HISParref=PLIST(1)
	;更新票据流水表
	i myrtn=0 d
	.&sql(update DHC_AccPreDeposit set AccPD_PDFoot_DR=:HISParref,AccPD_FootUser_DR=:sUser,AccPD_FootDate=:hdate,AccPD_FootTime=:htime
	       where (AccPD_User_DR=:sUser and AccPD_PDFoot_DR is null and 
	      ((AccPD_PreDate>=:StDate and AccPD_PreDate<:EndDate) or
	       (AccPD_PreDate=:EndDate and AccPD_PreTime<=:EndTime)) ))
	.s myrtn=SQLCODE
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	quit myrtn_"^"_HISParref
}

ClassMethod GetCardInfo(User, StDate, StTime, EndDate, EndTime)
{
  ///creat by zhl 2010.01.12 
	
	s BuildCard=0,ReCard=0,AccGetCash=0,AccRefSum=0,AccGetBank=0,GetNum=0,RefNum=0
	f Date=StDate:1:EndDate  d 
	.s CardDr="0"
	.f  s CardDr=$o(^DHCCARDi("CF",0,"CSDate",Date,CardDr))  q:CardDr=""  d
	..s CardSub="0"
	..f  s CardSub=$o(^DHCCARDi("CF",0,"CSDate",Date,CardDr,"CSC",CardSub))  q:CardSub=""  d
	...s DataStr=$g(^DHCCARD("CF",CardDr,"CSC",CardSub))
	...s Gusr=$p(DataStr,"^",4)
	...s Time=$p(DataStr,"^",2)
	...q:(Date=EndDate)&&(Time>EndTime)
	...q:(User'="")&&(User'=Gusr)
	...s Status=$p(DataStr,"^",3)
	...s:Status["N" BuildCard=BuildCard+1
	...s:Status["R" ReCard=ReCard+1 
	.s accid="0"       ///  add  by  zhl 2010.04.06  xy  start
    .f  s accid=$o(^DHCACDi("AccM",0,"APDDate",Date,accid))  q:accid=""  d
    ..s sub="0" 
    ..f  s sub=$o(^DHCACDi("AccM",0,"APDDate",Date,accid,"AccPD",sub))  q:sub=""   d
    ...q:'$d(^DHCACD("AccM",accid,"AccPD",sub))
    ...s datastr=$g(^DHCACD("AccM",accid,"AccPD",sub))
    ...s peruser=$p(datastr,"^",5)
    ...q:(User'="")&&(User'=peruser)
    ...s pdate=$p(datastr,"^",3)
    ...s ptime=$p(datastr,"^",4)
    ...q:(pdate=EndDate)&&(ptime>EndTime)
    ...s type=$p(datastr,"^",1)
    ...s sum=$p(datastr,"^",2)
    ...s accno=$p(datastr,"^",6)
    ...s Paysub=$o(^DHCACD("AccM",accid,"AccPD",sub,"P",0))
    ...s paym=$p($g(^DHCACD("AccM",accid,"AccPD",sub,"P",+Paysub)),"^",1)
    ...s paym=$p($g(^CT("CTPM",paym)),"^",1)
    ...i type["P"  d
    ....i paym["CASH"   s AccGetCash=AccGetCash+sum
    ....e   s AccGetBank=AccGetBank+sum
    ....s GetNum=GetNum+1
    ...i ((type["R")!(type["F"))    s AccRefSum=AccRefSum+sum,RefNum=RefNum+1     /////  add  by  zhl 2010.04.06  xy  start
     
    q BuildCard_"^"_ReCard_"^"_AccGetCash_"^"_AccGetBank_"^"_AccRefSum_"^"_GetNum_"^"_RefNum
}

/// w ##class(web.UDHCJFOPDailyReport).Test()
ClassMethod Test()
{
	;..FormatDepNOStr("EPInvDailyHand/No","MZYJ",Guser,DepNo)
	k ^TMP("OPBILL","TEST")
	f i=1:1:8 d
	.s ^TMP("OPBILL","TEST",i)="sf001000000"_i
	k ^TMP("EPInvDailyHand/No","2565","MZYJ","no")
	f i=10:1:15 d
	.s ^TMP("OPBILL","TEST",i)="sf001000000"_i
	k ^TMP("EPInvDailyHand/No","2565","MZYJ","no")
	b ;1
	s ind=""
	f  s ind=$o(^TMP("OPBILL","TEST",ind)) q:ind=""  d
	.s no=^TMP("OPBILL","TEST",ind)
	.d ##class(web.UDHCJFOPdailyhand).FormatDepNOStr("EPInvDailyHand/No","MZYJ","2565",no)
	b ;3
	s str=^TMP("EPInvDailyHand/No","2565","MZYJ","no")
	q str
}

}
