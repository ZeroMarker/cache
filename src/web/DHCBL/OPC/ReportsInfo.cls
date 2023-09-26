/// 对于单个的 报表与记录的对照
Class web.DHCBL.OPC.ReportsInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Parameter CPPPayMode = "CPP";

/// 设置DHC_INVPRT表的数据
ClassMethod SetINVPRTRepInfoByRowID(ByRef INVObj As %ObjectHandle, PRTrowid As %String) As %String
{
	;PRTrowid
	;
	;s obj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	;w ##class(web.DHCBL.OPC.ReportsInfo).SetINVPRTRepInfoByRowID(.obj,"156")
	s FootFlag=$g(FootFlag)
	
	s ToPaySum=0		;医疗费用支付总额?
	
	s ToPaySum=0		;医疗费用支付总额?
	
	s myCount=0
	
	s snum=0
	;.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	;加入舍入问题
	s PrtPatPay=+PrtPatPay+($p(^DHCINVPRT(PRTrowid),"^",37))
	s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	;去掉卡支付的小票记录；
	;但是不能去掉发票的卡支付
	s myPaySub=0
	s myPMCode=""
	f  s myPaySub=$o(^DHCINVPRT(PRTrowid,"P",myPaySub)) q:((myPaySub="")||(myPMCode=..#CPPPayMode))  d
	.s myPMDR=$p(^DHCINVPRT(PRTrowid,"P",myPaySub),"^",1)
	.s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	q:(myPMCode=..#CPPPayMode)&&(PrtNO="")&&(Flag="N")			;如果是卡支付退出,正常发票   1
	;非正常发票
	s myOldINVNo=""
	s myOldPMCode=""
	i (PrtinvDr'="") d
	.s myOldINVNo=$p(^DHCINVPRT(PrtinvDr),"^",14)
	.s myOldPMCode=""
	.s myOldPaySub=0
	.f  s myOldPaySub=$o(^DHCINVPRT(PrtinvDr,"P",myOldPaySub)) q:((myOldPaySub="")||(myOldPMCode=..#CPPPayMode))  d
	..s myOldPMDR=$p(^DHCINVPRT(PrtinvDr,"P",myOldPaySub),"^",1)
	..s:myOldPMDR'="" myOldPMCode=$p(^CT("CTPM",myOldPMDR),"^",1)
	q:((myPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;作废的票据		2
	;对于卡支付作废的发票退的现金体现在发票中；故此此处跳出
	q:((myOldPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;3
	
	;本收款员收取的票据?   下面的票据统计不包括CPP支付
	i (((Flag="N")||((PrtinvDr="")&&(Flag'="N")))&&((myPMCode'=..#CPPPayMode)))  d
	.s INVObj.PatINVCount=+INVObj.PatINVCount+1
	.s INVObj.PatPRTCount=+INVObj.PatPRTCount+1
	.s INVObj.PatPaySum=+INVObj.PatPaySum+$g(PrtPatPay)
	.s INVObj.PatTotSum=+INVObj.PatTotSum+$g(PRTAcount)
	.s INVObj.INVTotalSum = +INVObj.INVTotalSum+$g(PRTAcount)
	.s INVObj.PatRoundSum=+INVObj.PatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	.s INVObj.FactPatTotSum = +INVObj.FactPatTotSum+$g(PRTAcount)
	.s INVObj.FactPatPaySum = +INVObj.FactPatPaySum+$g(PrtPatPay)
	;本收款员作废的单据?	下面的数据都依存于原帐单?
	i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode'=..#CPPPayMode)  d
	.;重新写的作废单据
	.s INVObj.AbPatINVCount=+INVObj.AbPatINVCount+1
	.s INVObj.AbPatPaySum=+INVObj.AbPatPaySum + PrtPatPay
	.s INVObj.AbPatPRTCount=+INVObj.AbPatPRTCount+1
	.s INVObj.AbPatRoundSum=+INVObj.AbPatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	.s INVObj.AbTotSum = +INVObj.AbTotSum + PRTAcount
	.s INVObj.FactPatTotSum = +INVObj.FactPatTotSum+$g(PRTAcount)
	.s INVObj.FactPatPaySum = +INVObj.FactPatPaySum+$g(PrtPatPay)
	.s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	.s INVObj.AbParkINVInfo =INVObj.AbParkINVInfo_" "_ParkPrtNO_", "
	;本收款员红冲得单据
	i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode'=..#CPPPayMode)))  d
	.;重新写的红冲单据
	.s INVObj.RefPatPaySum=+INVObj.RefPatPaySum+$g(PrtPatPay)
	.s INVObj.RefPatINVCount=+INVObj.RefPatINVCount+1
	.s INVObj.RefPatRoundSum=+INVObj.RefPatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	.s INVObj.RefPatPRTCount=+INVObj.RefPatPRTCount+1
	.s INVObj.RefTotSum=+INVObj.RefTotSum+$g(PRTAcount)
	.s INVObj.FactPatTotSum = +INVObj.FactPatTotSum+$g(PRTAcount)
	.s INVObj.FactPatPaySum = +INVObj.FactPatPaySum+$g(PrtPatPay)
	.s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	.s INVObj.RefundINVInfo=INVObj.RefundINVInfo_" "_RefundPrtNO_", "
	s myCount=+myCount+1
	;*********************************************************************
	;*********************************************************************
	;使用对象进行数据存储
	s myBillStr=..GetINVBillStr(PRTrowid)
	i myBillStr'="" d
	.d INVObj.PutPayModeByPRTRowID(PRTrowid, Flag, myBillStr)
	;取支付模式 对于收费的发票
	;
	
	quit 0
}

/// 获取一张发票的账单RowID串
ClassMethod GetINVBillStr(INVRowID As %String) As %String
{
	s mystr=""
	
	q:(INVRowID="") ""
	
	;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	s myBIRowID=0
	f  s myBIRowID=$o(^DHCBCI(0,"INV", INVRowID,myBIRowID)) q:(myBIRowID="")  d
	.s myBPRowID=$p(^DHCBCI(myBIRowID),"^", 2)
	.s mystr=mystr_"^"_myBPRowID
	
	q mystr
}

ClassMethod SetCardINVRepInfoByRowID(ByRef CardINVObj As %ObjectHandle, CIPRowID As %String) As %String
{
	;w ##class(web.udhcOPHandin7).GetCardINVRepInfo()
	s myrtn=0
	
	s myCIPRowID=CIPRowID
	;1. 发票
	;2. 金额
	s myCardINVObj=CardINVObj
	
	
	s snum=0
	
	q:('$d(^DHCCARDINVPRT(myCIPRowID))) $$$OK
	
	s PRTUser=$p(^DHCCARDINVPRT(myCIPRowID),"^",6)			;CIP_PUser_DR
	
	s PRTAcount=$p(^DHCCARDINVPRT(myCIPRowID),"^",3)				;CIP_Amount
	s PrtPatPay=PRTAcount
	s PrtNO=$p(^DHCCARDINVPRT(myCIPRowID),"^",7)					;CIP_INVNo
	s PrtinvDr=$p(^DHCCARDINVPRT(myCIPRowID),"^",8)		;原票据的RowID  正常票据=""
	s Flag=$p(^DHCCARDINVPRT(myCIPRowID),"^",2)			;CIP_Flag
	;去掉卡支付的小票记录；
	;但是不能去掉发票的卡支付
	s myPaySub=0
	s myPMCode=""
	f  s myPaySub=$o(^DHCCARDINVPRT(myCIPRowID,"P",myPaySub)) q:((myPaySub="")||(myPMCode=..#CPPPayMode))  d
	.s myPMDR=$p(^DHCCARDINVPRT(myCIPRowID,"P",myPaySub),"^",1)
	.s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	q:(myPMCode=..#CPPPayMode)&&(PrtNO="")&&(Flag="N")			;如果是卡支付退出,正常发票   1
	;非正常发票
	s myOldINVNo=""
	s myOldPMCode=""
	i (PrtinvDr'="") d
	.s myOldINVNo=$p(^DHCCARDINVPRT(PrtinvDr),"^",14)
	.s myOldPMCode=""
	.s myOldPaySub=0
	.f  s myOldPaySub=$o(^DHCCARDINVPRT(PrtinvDr,"P",myOldPaySub)) q:((myOldPaySub="")||(myOldPMCode=..#CPPPayMode))  d
	..s myOldPMDR=$p(^DHCCARDINVPRT(PrtinvDr,"P",myOldPaySub),"^",1)
	..s:myOldPMDR'="" myOldPMCode=$p(^CT("CTPM",myOldPMDR),"^",1)
	q:((myPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;作废的票据		2
	;对于卡支付作废的发票退的现金体现在发票中；故此此处跳出
	q:((myOldPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;3
	i PrtNO'=""  d
	.s snum=snum+1
	.s ^TMPOPHand($j,"INV",snum)=PrtNO
	.s ^TMPOPHand($j,"INVNO",PrtNO)=Flag			;;按照票据号码生成Global
	;本收款员收取的票据?   下面的票据统计不包括CPP支付
	i (((Flag="N")||((PrtinvDr="")&&(Flag'="N")))&&((myPMCode'=..#CPPPayMode)))  d
	.;b	;;;CardNormal
	.s myCardINVObj.PatPaySum=+myCardINVObj.PatPaySum+$g(PrtPatPay)
	.s myCardINVObj.FactPatPaySum=+myCardINVObj.FactPatPaySum+$g(PrtPatPay)
	.s myCardINVObj.PatTotSum=+myCardINVObj.PatTotSum+$g(PRTAcount)
	.s myCardINVObj.INVTotalSum = +myCardINVObj.INVTotalSum+$g(PRTAcount)
	.s myCardINVObj.FactPatTotSum=+myCardINVObj.FactPatTotSum+$g(PRTAcount)
	.i PrtNO'="" d
	..s myCardINVObj.PatINVCount = myCardINVObj.PatINVCount+1
	.;不打印发票而收的钱数
	.s myCardINVObj.PatPRTCount = myCardINVObj.PatPRTCount+1
	;本收款员作废的单据?	下面的数据都依存于原帐单?
	i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode'=..#CPPPayMode)  d
	.;重新写的作废单据
	.s myCardINVObj.AbPatPaySum = myCardINVObj.AbPatPaySum+$g(PrtPatPay)
	.s myCardINVObj.AbTotSum = myCardINVObj.AbTotSum+$g(PRTAcount)
	.s myCardINVObj.AbPatPRTCount=+myCardINVObj.AbPatPRTCount+1
	.s myCardINVObj.AbPatINVCount=+myCardINVObj.AbPatINVCount+1
	.s ParkPrtNO=$p(^DHCCARDINVPRT(PrtinvDr),"^",7)		;作废票据的原票据号码?
	.s myCardINVObj.AbParkINVInfo= myCardINVObj.AbParkINVInfo_" "_ParkPrtNO_", "
	.s myCardINVObj.FactPatTotSum=+myCardINVObj.FactPatTotSum+$g(PRTAcount)
	.s myCardINVObj.FactPatPaySum=+myCardINVObj.FactPatPaySum+$g(PrtPatPay)
	.;s cancelnum=cancelnum+1
	;本收款员红冲得单据
	i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode'=..#CPPPayMode)))  d
	.;重新写的红冲单据
	.s myCardINVObj.RefPatPaySum=+myCardINVObj.RefPatPaySum+$g(PrtPatPay)
	.s myCardINVObj.RefTotSum=+myCardINVObj.RefTotSum+$g(PRTAcount)
	.s myCardINVObj.RefPatINVCount=+myCardINVObj.RefPatINVCount+1
	.s myCardINVObj.RefPatPRTCount=+myCardINVObj.RefPatPRTCount+1
	.s RefundPrtNO=$p(^DHCCARDINVPRT(PrtinvDr),"^",7)		;红冲票据的原票据号码?
	.s myCardINVObj.RefundINVInfo=myCardINVObj.RefundINVInfo_" "_RefundPrtNO_", "
	.s myCardINVObj.FactPatPaySum=+myCardINVObj.FactPatPaySum+$g(PrtPatPay)
	.s myCardINVObj.FactPatTotSum=+myCardINVObj.FactPatTotSum+$g(PRTAcount)
	s myrtn=+myrtn+1
	d myCardINVObj.PutCardINVPayMode(myPMCode,Flag,PrtPatPay,1)
	
	i myPMCode=..#CPPPayMode d
	.;b	;;	CPP   处理CPP支付
	
	q $$$OK
}

/// /预交金 对象转换
ClassMethod SetPRDRepINfoByRowID(ByRef PDObj As %ObjectHandle, AccPreRowID As %String) As %String
{
	;w ##class(web.udhcOPHandin7).GetPRDRepINfo(60315,39695,60410,65865,1)
	
	s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
	s mypdnum=0
	s footnum=0,refundnum=0,rcptstr=""
	
	s pmsub=0
	f  s pmsub=$o(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub)) q:pmsub=""  d
	.s pmid=$p(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub),"^",1)
	.;如果支付模式="" 默认为现金
	.;s:pmid="" pmid=$o(^CT("CTPM",0,"Code",..#CashPayMode,0))
	.q:pmid=""
	.s myPMCode=$p(^CT("CTPM",pmid),"^",1)
	.;i myPMCode=..#CashPayMode s cashsum=cashsum+pdamt
	.;i myPMCode=..#ChequePayMode s chequesum=chequesum+pdamt
	.i "^CASH^CHEQUES^"'[myPMCode s othersum=+othersum+pdamt
	s footsum=footsum+pdamt
	i pdamt>0  d
	.s pdsum=+pdsum+pdamt
	.s mypdnum=+mypdnum+1
	i pdamt<0 d
	.s refundsum=+refundsum+pdamt
	.s refundnum=+refundnum+1
	s receiptsno=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",6)
	;s rcptstr=..getrcptstr(rcptstr,receiptsno)
	
	
	s pdsum=$fn(pdsum,"",2)
	s refundsum=$fn(refundsum,"",2)
	s cashsum=$fn(cashsum,"",2)
	s chequesum=$fn(chequesum,"",2)
	s othersum=$fn(othersum,"",2)
	
	quit $$$OK
}

ClassMethod SetAPIRepInfoByRowID(APIObj As %ObjectHandle, APRowID As %String) As %String
{
	;此函数用来查询卡支付打印发票的统计；
	
	;w ##class(web.udhcOPHandin7).GetAPIRepInfo("", +$h-100,0,+$h,0, "10033")
	
	s myAPRowID = APRowID
	
	s myCount=0
	k ^TMPOPACCHand($j)
	
	;集中打印发票信息
	;医保支付金额；发票总额；卡支付额
	s AccPay=0		;每张发票的患者支付金额
	s YBPaySum=0		;医保支付金额
	s PatPaySum=0		;卡支付金额
	s AccRefundSum=0		;集中打印发票退费金额=医保退费金额+账户结算后的退款金额
	s AccPaySum=0		;账户支付总额；
	s AccPrtNo=""		;账户的发票号码
	s AccPrtDR=""		;账户支付的外键
	s AccPrtFlag=""		;账户支付的发票状态
	s AccPrtNum=0		;打印的发票数量
	s myRoundSum=0		;结算打印发票舍入的金额
	
	;正常发票支付
	s AccNPatPaySum=0
	s AccNTotSum=0
	s AccNINVInfo=""
	s AccNNum=0
	s AccNSum=0
	s AccNYBPaySum=0
	s AccNCardPaySum=0
	s AccNRefSum=0
	s AccNCashSum=0
	
	;作废		Abort =Park
	s AccParkPatPaySum=0
	s AccParkTotSum=0
	s AccParkINVInfo=""
	s AccParkNum=0
	s AccParkSum=0
	s AccParkYBPaySum=0
	s AccParkCardPaySum=0
	s AccParkRefSum=0
	s AccParkCashSum=0
	
	;红冲
	s AccRefPatPaySum=0
	s AccRefTotSum=0
	s AccRefundINVInfo=""
	s AccRefundNum=0
	s AccRefundSum=0
	s AccRefYBPaySum=0
	s AccRefCardPaySum=0
	s AccRefRefSum=0
	s AccRefCashSum=0
	
	s rtn=0
	
	s RefundSum=0
	s YBRefundSum=0
	s snum=0
	
	;下面是：DHC_AccPayINV表的发票号码
	s AccAcount=+$p(^DHCINVPRTAP(myAPRowID),"^", 1)		;API_Amount  发票费用总额API_Amount
	s AccPatPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 13)		;API_PatientShare
	;s myRoundSum=+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	s AccPatPay=AccPatPay+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	s PatCardPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 16)		;API_SelfPatPay   发票患者卡支付总额  API_SelfPatPay
	s YBPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 17)			;API_SelfYBPay
	s myRefundPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 18)	;API_RefundSum
	s PatCashPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 21)		;API_CashPay   患者退费时，如果现金退费
	s AccPrtFlag=$p(^DHCINVPRTAP(myAPRowID),"^", 2)		;API_Flag    发票标志
	s AccPrtNo=$p(^DHCINVPRTAP(myAPRowID),"^", 6)			;API_INVNo   发票号码  API_INVNo
	s AccPrtDR=$p(^DHCINVPRTAP(myAPRowID),"^", 10)		;API_PayINV_DR
	
	;正常的发票
	i ((AccPrtFlag="N")||((AccPrtFlag'="N")&&(AccPrtDR=""))) d
	.s AccNPatPaySum=AccNPatPaySum+$g(AccPatPay)
	.s AccNTotSum=AccNTotSum+$g(AccAcount)
	.s AccNNum=AccNNum+1
	.s AccNSum=AccNSum+$g(AccPatPay)
	.s AccNYBPaySum=AccNYBPaySum+$g(YBPay)
	.s AccNCardPaySum=AccNCardPaySum+$g(PatCardPay)
	.s AccNRefSum=AccNRefSum+$g(myRefundPay)				;真正的退款额
	.s AccNCashSum=AccNCashSum+$g(PatCashPay)
	.s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	;作废发票
	i (AccPrtFlag="A")&&(AccPrtDR'="") d
	.s AccParkPrtNO=$p(^DHCINVPRTAP(AccPrtDR),"^", 6)		;作废票据的原票据号码?
	.s AccParkPatPaySum=+AccParkPatPaySum+$g(AccPatPay)
	.s AccParkTotSum=AccParkTotSum+$g(AccAcount)
	.s AccParkINVInfo=AccParkINVInfo_" "_AccParkPrtNO_", "
	.s AccParkNum=AccParkNum+1
	.s AccParkSum=+AccParkSum+$g(AccPatPay)
	.s AccParkYBPaySum=+AccParkYBPaySum+$g(YBPay)
	.s AccParkCardPaySum=+AccParkCardPaySum+$g(PatCardPay)
	.s AccParkRefSum=+AccParkRefSum+$g(myRefundPay)
	.s AccParkCashSum=+AccParkCashSum+$g(PatCashPay)
	.s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	;红冲发票
	i (AccPrtFlag="S")&&(AccPrtDR'="") d
	.s AccRefundPrtNO=$p(^DHCINVPRTAP(AccPrtDR),"^",6)		;红冲票据的原票据号码?
	.b		;SSS
	.;New   ;;;
	.s AccRefPatPaySum=AccRefPatPaySum+$g(AccPatPay)
	.s AccRefTotSum=+AccRefTotSum+$g(AccAcount)
	.s AccRefundINVInfo=AccRefundINVInfo_" "_AccRefundPrtNO_", "
	.s AccRefundNum=AccRefundNum+1
	.s AccRefundSum=AccRefundSum+$g(AccPatPay)
	.s AccRefYBPaySum=+AccRefYBPaySum+$g(YBPay)
	.s AccRefCardPaySum=+AccRefCardPaySum+$g(PatCardPay)
	.s AccRefRefSum=+AccRefRefSum+$g(myRefundPay)
	.s AccRefCashSum=+AccRefCashSum +$g(PatCashPay)
	.s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	s myCount=+myCount+1
	
	;票据总额
	
	;应上交金额,  操作员退款为负    此钱财务应该补齐
	s AccFootSum=$fn(AccNRefSum+AccParkRefSum+AccRefRefSum,"",2)
	
	;s AccRefPatPaySum=$fn(AccRefPatPaySum,"",2)		;
	;s AccAbPatPaySum=$fn(AccAbPatPaySum,"",2)		;
	
	;在此加入DHC_INVPRT表中的卡支付发票2006-07-03  zhaocz
	;s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum
	;RefPRTInfo_ParkPRTInfo
	s AccNNum=+AccNNum+$p(PRTCPPInfo,"^",1)
	
	s AccNTotSum=AccNTotSum+$p(PRTCPPInfo,"^",2)
	s AccNTotSum=$fn(AccNTotSum,"",2)
	s AccNCardPaySum=AccNCardPaySum+$p(PRTCPPInfo,"^",2)
	s AccNCardPaySum=$fn(AccNCardPaySum,"",2)
	s AccNYBPaySum=$fn(AccNYBPaySum,"",2)
	s AccNRefSum=$fn(AccNRefSum,"",2)
	s AccNCashSum=$fn(AccNCashSum,"",2)
	
	s AccParkNum=AccParkNum+$p(PRTCPPInfo,"^",5)
	s AccParkINVInfo=AccParkINVInfo_""_$p(PRTCPPInfo,"^",8)
	
	s AccParkTotSum=+AccParkTotSum+$p(PRTCPPInfo,"^",6)
	s AccParkTotSum=$fn(AccParkTotSum,"",2)
	s AccParkCardPaySum=AccParkCardPaySum+$p(PRTCPPInfo,"^",6)
	s AccParkCardPaySum=$fn(AccParkCardPaySum,"",2)
	s AccParkYBPaySum=$fn(AccParkYBPaySum,"",2)
	s AccParkRefSum=$fn(AccParkRefSum,"",2)
	s AccParkCashSum=$fn(AccParkCashSum,"",2)
	
	s AccRefundNum=AccRefundNum+$p(PRTCPPInfo,"^",3)
	s AccRefundINVInfo=AccRefundINVInfo_""_$p(PRTCPPInfo,"^",7)
	
	s AccRefTotSum=AccRefTotSum+$p(PRTCPPInfo,"^",4)
	s AccRefTotSum=$fn(AccRefTotSum,"",2)
	s AccRefCardPaySum=+AccRefCardPaySum+$p(PRTCPPInfo,"^",4)
	s AccRefCardPaySum=$fn(AccRefCardPaySum,"",2)
	s AccRefYBPaySum=$fn(AccRefYBPaySum,"",2)
	s AccRefRefSum=$fn(AccRefRefSum,"",2)
	s AccRefCashSum=$fn(AccRefCashSum,"",2)
	
	s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	
	k ^TMPOPACCHand($j)
	
	s rtn=myCount
	
	q rtn_$c(3)_AccFootSum_$c(4)_myNINfo_$c(4)_myParkInfo_$c(4)_myRefInfo
}

}
