Import SQLUser

Class web.udhcOPHandin11Back Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 759;

/// /专门提供给合肥来用的操作员自己的日报
/// /包括：
/// /1.对于DHC_INVPRT表的结算；
/// /1.1门诊现金(支票等类型)收费		用M来写结算时间和结算人；
/// /1.2门诊卡支付时，办理结算，但是不写结算时间和结算人
/// /1.3计算DHC_INVPRT和DHC_AccPayINV发票的分布信息
/// /1.3.1分出集中打印的发票
/// /1.3.2分出现金(支票等)打印的发票
/// /1.4计算工作量等参数加入(在DHC_INVReports表中增加更多的字段)
/// /1.5增加医保返钱的统计；这部分钱需要财务返还到操作员手中；
/// /1.6收款员的门诊收入=门诊现金收费+医保支付的钱
/// /
/// /写的表
/// /DHC_INVPRTReports
/// /DHC_INVPRT,  DHC_AccPayINV表	
/// /生成连续的号码； 
/// /
ClassMethod GetAPIYB(RepRowID As %String) As %String
{
	;w ##class(web.udhcOPHandin11Back).GetAPIYB(6944)
	n (RepRowID)
	
	q:(RepRowID="") RepRowID
	
	;^DHCOPInsFoot(RepRowID)
	
	s stdate=$p(^DHCOPInsFoot(RepRowID),"^",5)				;HIS_StartDate
	s sttime=$p(^DHCOPInsFoot(RepRowID),"^",6)				;HIS_StartTime
	s EndDate=$p(^DHCOPInsFoot(RepRowID),"^",3)				;HIS_EndDate
	s EndTime=$p(^DHCOPInsFoot(RepRowID),"^",4)				;HIS_EndTime
	s hUser=$p(^DHCOPInsFoot(RepRowID),"^",8)				;HIS_User

	b	;;Date
	;生成TMP  Global
	
	s myINVInfo=##class(web.udhcOPHandin11Back).SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;;;myINVInfo
	
	;增加卡支付门诊发票的结算
	s myIPRepInfo=##class(web.udhcOPHandin11Back).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;myIPRepInfo
	
	s myIPRepInfo1=myIPRepInfo
	s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	
	s myAPIRepInfo=##class(web.udhcOPHandin11Back).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo)
	
	b ;myAPIRepInfo
	s myAPRtn=$p(myAPIRepInfo,$c(3),1)
	s myAPIRepInfo=$p(myAPIRepInfo,$c(3),2)
	
	s myPDInfo=##class(web.udhcOPHandin11Back).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser)
	
	q 0
}

/// 提供一个方法校正发票红冲退医保的钱
ClassMethod ReviseYBRefund(RepRowID As %String) As %String
{
	;w ##class(web.udhcOPHandin11Back).ReviseYBRefund()
	n (RepRowID)
	
	q:(RepRowID="") RepRowID
	
	;^DHCOPInsFoot(RepRowID)
	
	s stdate=$p(^DHCOPInsFoot(RepRowID),"^",5)				;HIS_StartDate
	s sttime=$p(^DHCOPInsFoot(RepRowID),"^",6)				;HIS_StartTime
	s EndDate=$p(^DHCOPInsFoot(RepRowID),"^",3)				;HIS_EndDate
	s EndTime=$p(^DHCOPInsFoot(RepRowID),"^",4)				;HIS_EndTime
	
	b	;;Date
	;生成TMP  Global
	
	s myINVInfo=##class(web.udhcOPHandin11Back).SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;;;myINVInfo
	
	;增加卡支付门诊发票的结算
	s myIPRepInfo=##class(web.udhcOPHandin11Back).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;myIPRepInfo
	
	s myIPRepInfo1=myIPRepInfo
	s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	
	s myAPIRepInfo=##class(web.udhcOPHandin11Back).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo)
	
	b ;myAPIRepInfo
	s myAPRtn=$p(myAPIRepInfo,$c(3),1)
	s myAPIRepInfo=$p(myAPIRepInfo,$c(3),2)
	
	s myPDInfo=##class(web.udhcOPHandin11Back).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser)
	
	s myrtn=0
	d ..tb()
	
	;update DHC_INVPRTReports set HIS_PatSum=HIS_PatSum+256.68, HIS_YBSum=HIS_YBSum+256.68, HIS_CardYBRefSum=HIS_CardYBRefSum-256.68    where HIS_RowID=6876
	&sql(update DHC_INVPRTReports set HIS_PatSum=HIS_PatSum+256.68, HIS_YBSum=HIS_YBSum+256.68, HIS_CardYBRefSum=HIS_CardYBRefSum-256.68    where HIS_RowID=6876)
	
	if (+myrtn=0) d
	.d ..tc()
	e  d
	.Trollback
	
	q 0
}

ClassMethod BuildOPINVItem(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
	;w ##class(web.udhcOPHandin11Back).BuildOPINVItem(23298,60589,62365,60589,$p($h,",",2))
	n (hUser, stdate, sttime, EndDate, EndTime)
	
	s rtn=0
	i (stdate'="")&(sttime'="")  d
	.;s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  q:(rtn'=0)  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:((PRTrowid="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...;s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...;s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...s myPMDR=$o(^CT("CTPM",0,"Code","CPP",0))
	...s myPMSub=$o(^DHCINVPRTi(0,"PMDR",PRTrowid,myPMDR,"P",0))
	...s myCKPRTNO=##class(web.UDHCINVPRT).CheckCPPPRTNO(PRTrowid)
	...s myPRTNo=$p(myCKPRTNO,"^",1)
	...q:((myPMSub'="")&(myPRTNo=""))
	...;i PrtNO'=""  d
	...;s stat=..STATtoOPCAT(PRTrowid)
	...;生成支付模式
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPPayMode(PRTrowid)
	...e  d
	....;作废发票的支付模式设定
	....d ..ReadOPParkPayMode(PRTrowid)
	...q:(rtn'=0)
	
	s footnum=0
	;对于卡预交金的金额
	;按照支付模式保存
	s pddate=stdate-1
	f  s pddate=$o(^DHCACDi("AccM",0,"User",hUser,pddate)) q:((pddate="")||(+pddate>+EndDate))  d
	.s accid=0
 	.f  s accid=$o(^DHCACDi("AccM",0,"User",hUser,pddate,accid)) q:accid=""  d
	..s pdsub=0
	..f  s pdsub=$o(^DHCACDi("AccM",0,"User",hUser,pddate,accid,"AccPD",pdsub)) q:pdsub=""  d
	...s myRepDR=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",10)
	...q:(myRepDR'="")
	...s footnum=+footnum+1
	...s pdamt=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",2)
	...s myPDDate=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",3)
	...s myPDTime=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",4)
	...q:((stdate=myPDDate)&&(myPDTime<sttime))
	...q:((EndDate=myPDDate)&&(myPDTime>=EndTime))
	...s pmsub=0
	...f  s pmsub=$o(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub)) q:pmsub=""  d
	....s pmid=$p(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub),"^",1)
	....;如果支付模式="" 默认为现金
	....s:pmid="" pmid=$o(^CT("CTPM",0,"Code","CASH",0))
	....q:pmid=""
	....s myPMCode=$p(^CT("CTPM",pmid),"^",1)
	....;i myPMCode="CASH" s cashsum=cashsum+pdamt
	....;i myPMCode="CHEQUES" s chequesum=chequesum+pdamt
	....;i "^CASH^CHEQUES^"'[myPMCode s othersum=+othersum+pdamt
	...s myPMDR=pmid
	...q:(myPMDR="")
	...i pdamt>0  d
	....;收预交金
	....s ^TMPOPPayMode($j,myPMDR,"PRD","GNum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GNum"))+1
	....s ^TMPOPPayMode($j,myPMDR,"PRD","GSum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GSum"))+$g(pdamt)
	...i pdamt<0 d
	....;退预交金
	....s ^TMPOPPayMode($j,myPMDR,"PRD","RefNum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefNum"))+1
	....s ^TMPOPPayMode($j,myPMDR,"PRD","RefSum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefSum"))+$g(pdamt)
	...s receiptsno=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",6)
	
	q rtn
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod GetAPIRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, PRTCPPInfo As %String) As %String
{
	n (itmjs, stdate, sttime, EndDate, EndTime, hUser, PRTCPPInfo)
	
	;此函数用来查询卡支付打印发票的统计；
	
	;w ##class(web.udhcOPHandin11Back).GetAPIRepInfo("", +$h-100,0,+$h,0, "10033")
	
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
	
	s rtn=1
	
	s RefundSum=0
	s YBRefundSum=0
	s snum=0
	
	;下面是：DHC_AccPayINV表的发票号码
	f APdate=stdate:1:EndDate  d
	.q:$d(^DHCINVPRTAPi(0,"Date",APdate))=0
	.s myAPRowID=""
	.f  s myAPRowID=$o(^DHCINVPRTAPi(0, "Date", APdate, myAPRowID))  q:(myAPRowID="")  d
	..s myAPUser=$p(^DHCINVPRTAP(myAPRowID),"^", 5)
	..q:(myAPUser'=hUser)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..q:((APdate=stdate)&&(myAPTime<sttime))
	..q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..;q:(myCheckDate'="")	;已经结算的退出
	..s AccAcount=+$p(^DHCINVPRTAP(myAPRowID),"^", 1)		;API_Amount  发票费用总额API_Amount
	..s AccPatPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 13)		;API_PatientShare
	..;s myRoundSum=+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	..s AccPatPay=AccPatPay+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	..s PatCardPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 16)		;API_SelfPatPay   发票患者卡支付总额  API_SelfPatPay
	..s YBPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 17)			;API_SelfYBPay
	..s myRefundPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 18)	;API_RefundSum
	..s PatCashPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 21)		;API_CashPay   患者退费时，如果现金退费
	..s AccPrtFlag=$p(^DHCINVPRTAP(myAPRowID),"^", 2)		;API_Flag    发票标志
	..s AccPrtNo=$p(^DHCINVPRTAP(myAPRowID),"^", 6)			;API_INVNo   发票号码  API_INVNo
	..s AccPrtDR=$p(^DHCINVPRTAP(myAPRowID),"^", 10)		;API_PayINV_DR
	..s rtn=0		;表示有结算数据
	..i AccPrtNo'=""  d
	...s snum=snum+1		;生成发票号码
	...s ^TMPOPACCHand($j,"INV",snum)=AccPrtNo
	...s ^TMPOPACCHand($j,"INVCol",AccPrtNo)=AccPrtNo		;统一计算发票的范围
	...s ^TMPOPACCHand($j,"APICol",AccPrtNo)=AccPrtNo			;单独的集中打印发票号码
	...s ^TMPOPACCHand($j,"INVNO",AccPrtNo)=AccPrtFlag			;;按照票据号码生成Global
	..;正常的发票
	..i ((AccPrtFlag="N")||((AccPrtFlag'="N")&&(AccPrtDR=""))) d
	...s AccNPatPaySum=AccNPatPaySum+$g(AccPatPay)
	...s AccNTotSum=AccNTotSum+$g(AccAcount)
	...s AccNNum=AccNNum+1
	...s AccNSum=AccNSum+$g(AccPatPay)
	...s AccNYBPaySum=AccNYBPaySum+$g(YBPay)
	...s AccNCardPaySum=AccNCardPaySum+$g(PatCardPay)
	...s AccNRefSum=AccNRefSum+$g(myRefundPay)				;真正的退款额
	...s AccNCashSum=AccNCashSum+$g(PatCashPay)
	...s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	..;作废发票
	..i (AccPrtFlag="A")&&(AccPrtDR'="") d
	...s AccParkPrtNO=$p(^DHCINVPRTAP(AccPrtDR),"^", 6)		;作废票据的原票据号码?
	...s AccParkPatPaySum=+AccParkPatPaySum+$g(AccPatPay)
	...s AccParkTotSum=AccParkTotSum+$g(AccAcount)
	...s AccParkINVInfo=AccParkINVInfo_" "_AccParkPrtNO_", "
	...s AccParkNum=AccParkNum+1
	...s AccParkSum=+AccParkSum+$g(AccPatPay)
	...s AccParkYBPaySum=+AccParkYBPaySum+$g(YBPay)
	...s AccParkCardPaySum=+AccParkCardPaySum+$g(PatCardPay)
	...s AccParkRefSum=+AccParkRefSum+$g(myRefundPay)
	...s AccParkCashSum=+AccParkCashSum+$g(PatCashPay)
	...s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	..;红冲发票
	..i (AccPrtFlag="S")&&(AccPrtDR'="") d
	...s AccRefundPrtNO=$p(^DHCINVPRTAP(AccPrtDR),"^",6)		;红冲票据的原票据号码?
	...;b		;SSS
	...;New   ;;;
	...s AccRefPatPaySum=AccRefPatPaySum+$g(AccPatPay)
	...s AccRefTotSum=+AccRefTotSum+$g(AccAcount)
	...s AccRefundINVInfo=AccRefundINVInfo_" "_AccRefundPrtNO_", "
	...s AccRefundNum=AccRefundNum+1
	...s AccRefundSum=AccRefundSum+$g(AccPatPay)
	...s AccRefYBPaySum=+AccRefYBPaySum+$g(YBPay)
	...;b		;;;AccRefYBPaySum
	...s AccRefCardPaySum=+AccRefCardPaySum+$g(PatCardPay)
	...s AccRefRefSum=+AccRefRefSum+$g(myRefundPay)
	...s AccRefCashSum=+AccRefCashSum +$g(PatCashPay)
	...s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	
	b		;计算红冲发票金额
	;票据总额
	;s FootTotSum=$fn(TotSum+AbTotSum+RefTotSum,"",2)
	
	;应上交金额,  操作员退款为负    此钱财务应该补齐
	s AccFootSum=$fn(AccNRefSum+AccParkRefSum+AccRefRefSum,"",2)
	
	;s AccRefPatPaySum=$fn(AccRefPatPaySum,"",2)		;
	;s AccAbPatPaySum=$fn(AccAbPatPaySum,"",2)		;
	
	;打印发票信息=票据金额+票据张数+票据信息+患者卡支付+医保支付额+退费金额+现金金额
	;作废发票信息	同上
	;红冲发票信息	同上
	
	s AccNINVInfo=..GetAccINVNOinfo()
	
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
	
	q rtn_$c(3)_AccFootSum_$c(4)_myNINfo_$c(4)_myParkInfo_$c(4)_myRefInfo
}

ClassMethod GetPRDRepINfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
	;w ##class(web.udhcOPHandin11Back).GetPRDRepINfo(60315,39695,60410,65865,1)
	n (stdate, sttime, EndDate, EndTime, hUser)
	
	q:hUser="" 0
	;s ^TMPINfo=stdate_"^"_sttime_"^"_EndDate_"^"_EndTime_"^"_hUser
	;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	
	q:'$d(^DHCACDi("AccM",0,"User",hUser)) 0_$c(3)_"0^0.00^0^0.00^0.00^0.00^0.00"
	
	s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
	s mypdnum=0
	s footnum=0,refundnum=0,rcptstr=""
	
	s pddate=stdate-1
	f  s pddate=$o(^DHCACDi("AccM",0,"User",hUser,pddate)) q:((pddate="")||(+pddate>+EndDate))  d
	.s accid=0
 	.f  s accid=$o(^DHCACDi("AccM",0,"User",hUser,pddate,accid)) q:accid=""  d
	..s pdsub=0
	..f  s pdsub=$o(^DHCACDi("AccM",0,"User",hUser,pddate,accid,"AccPD",pdsub)) q:pdsub=""  d
	...s myRepDR=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",10)
	...q:(myRepDR'="")
	...s footnum=+footnum+1
	...s pdamt=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",2)
	...s myPDDate=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",3)
	...s myPDTime=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",4)
	...q:((stdate=myPDDate)&&(myPDTime<sttime))
	...q:((EndDate=myPDDate)&&(myPDTime>=EndTime))
	...s pmsub=0
	...f  s pmsub=$o(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub)) q:pmsub=""  d
	....s pmid=$p(^DHCACD("AccM",accid,"AccPD",pdsub,"P",pmsub),"^",1)
	....;如果支付模式="" 默认为现金
	....s:pmid="" pmid=$o(^CT("CTPM",0,"Code","CASH",0))
	....q:pmid=""
	....s myPMCode=$p(^CT("CTPM",pmid),"^",1)
	....i myPMCode="CASH" s cashsum=cashsum+pdamt
	....i myPMCode="CHEQUES" s chequesum=chequesum+pdamt
	....i "^CASH^CHEQUES^"'[myPMCode s othersum=+othersum+pdamt
	...s footsum=footsum+pdamt
	...i pdamt>0  d
	....s pdsum=+pdsum+pdamt
	....s mypdnum=+mypdnum+1
	...i pdamt<0 d
	....s refundsum=+refundsum+pdamt
	....s refundnum=+refundnum+1
	...s receiptsno=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",6)
	...;s rcptstr=..getrcptstr(rcptstr,receiptsno)
	...
	
	s pdsum=$fn(pdsum,"",2)
	s refundsum=$fn(refundsum,"",2)
	s cashsum=$fn(cashsum,"",2)
	s chequesum=$fn(chequesum,"",2)
	s othersum=$fn(othersum,"",2)
	
	;s othersum=footsum-cashsum-chequesum
	;s enddate=$ZD(+$H,4),endtime=$ZT($p($H,",",2))
	;s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
	;利用收退款笔数来决定是否能办理结算
	s rtn=footnum
	
	s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	
	q rtn_$c(3)_myInfo
}

ClassMethod ReadINVRange() As %String
{
}

ClassMethod GetDate(hUser As %String, EndDate As %String)
{
	;;w ##class(web.udhcOPHandin11Back).GetDate("10033","2006-04-24")
	s stdate="",sttime=""
	s myAPRowID=""
	s myPrtDate=""
	s myPrtTime=""
	s myAPDate=""
	s myAPTime=""
	s myPreDate=""
	s myPreTime=""
	
	&sql(select max(HIS_Rowid) into:rowid            
	     from DHC_INVPRTReports where HIS_User=:hUser)
	i rowid'="" d
	.&sql(select HIS_EndDate,HIS_EndTime into :stdate,:sttime
	      from DHC_INVPRTReports where HIS_Rowid=:rowid)
	e  d
	.&sql(select min(PRT_Rowid) into :rowid from DHC_INVPRT
	      where PRT_Date<=:EndDate and PRT_Usr=:hUser and PRT_Handin is null)
	.b
	.i rowid'="" d
	..&sql(select PRT_Date,PRT_Time into:stdate,:sttime
	       from DHC_INVPRT where PRT_Rowid=:rowid)
	..s myPrtDate=$p(^DHCINVPRT(rowid),"^",5)
	..s myPrtTime=$p(^DHCINVPRT(rowid),"^",20)
	.&sql(select min(API_RowID) into :myAPRowID from DHC_AccPayINV 
			where API_PUser_DR=:hUser and API_CheckDate is null)
	.i (myAPRowID'="")  d
	..s myAPDate=$p(^DHCINVPRTAP(myAPRowID),"^",3)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^",4)
	.;预交金的最小日期
	.s myPreDate=$o(^DHCACDi("AccM",0,"User",hUser,0))
	.q:(myPreDate="")
	.s myPreTime=""
	.s myAccDR=0
	.f  s myAccDR=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate, myAccDR)) q:(myAccDR="")  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate, myAccDR,"AccPD", mySub)) q:(mySub="")  d
	...s myTMPTime=$p(^DHCACD("AccM",myAccDR,"AccPD",mySub),"^",4)
	...s myFootUDR=$p(^DHCACD("AccM",myAccDR,"AccPD",mySub),"^",13)
	...q:(myFootUDR'="")
	...i (myPreTime="")||(+myTMPTime<+myPreTime) d
	....s myPreTime=myTMPTime
	...
	
	b	;;
	i (myAPDate'="")&&(myPrtDate'="") d
	.i ((+myAPDate<+myPrtDate)||((myPrtDate=myAPDate)&&(+myAPTime<+myPrtTime)))  d
	..s stdate=myAPDate
	..s sttime=myAPTime
	
	if ((myPrtDate="")&&(myAPDate'="")) d
	..s stdate=myAPDate
	..s sttime=myAPTime
	
	i (myPreDate'="") d
	.i ((stdate="")||((+stdate=+myPreDate)&&(+sttime>+myPreTime))||(+stdate>+myPreDate)) d
	..s stdate=myPreDate
	..s sttime=myPreTime
	
	i stdate="" d  s stdate=+$h
	i sttime="" d  s sttime=$p($h,",",2)
	
	;获取预交金的最小未结算日期
	
	q stdate_"^"_sttime
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String) As %String
{
	;, EndDate As %String, EndTime As %String
	;调试代码
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23416")
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23417")			;孙晓科
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23540")			;周成玉
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23352")			;陈晔旻
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","21811")			;强林
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23528")			;许莹
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23350")			;何素琴
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23529")			;滕心彤
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23531")			;董洁梅
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23543")			;龚云霞
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","23336")			;曹伶俐
	;w ##class(web.udhcOPHandin11Back).KillTmp()
	;
	;w AccRefYBPaySum
	;w AccParkYBPaySum
	;
	;^TMPHandin=5%%%
	n (itmjs, itmjsex, hUser)
	
	d ..KillTmp()
	
	;s EndDate=+$h		;$zdh(EndDate,3)
	;s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	;s sttimeinfo=..GetDate(hUser,EndDate)
	;s stdate=$p(sttimeinfo,"^",1)
	;s sttime=$p(sttimeinfo,"^",2)
	
	s stdate=$zdh("11/04/2007",4)
	s sttime=$zth("17:16:51")
	s EndDate=$zdh("12/04/2007",4)		;$zdh(EndDate,3)
	s EndTime=$zth("16:59:32")			;$zth(EndTime,1)
	b	;;Date
	;生成TMP  Global
	
	s myINVInfo=##class(web.udhcOPHandin11Back).SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;;;myINVInfo
	
	;增加卡支付门诊发票的结算
	s myIPRepInfo=##class(web.udhcOPHandin11Back).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;myIPRepInfo
	
	s myIPRepInfo1=myIPRepInfo
	s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	
	s myAPIRepInfo=##class(web.udhcOPHandin11Back).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo)
	
	b ;myAPIRepInfo
	s myAPRtn=$p(myAPIRepInfo,$c(3),1)
	s myAPIRepInfo=$p(myAPIRepInfo,$c(3),2)
	
	s myPDInfo=##class(web.udhcOPHandin11Back).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser)
	b	;PRD
	s myPDRtn=$p(myPDInfo,$c(3),1)
	s myPDInfo=$p(myPDInfo,$c(3),2)
	
	;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	
	;myIPRepInfo=原来输出方式
	;myAPIRepInfo=交钱金额$(4)发票信息$c(4)作废票据信息$(4)红冲票据信息
	
	s myrtn=1
	i ((myINVInfo'="")!(+myIPRtn=0)!(+myAPRtn=1)!(+myPDRtn>0))  d
	.s myrtn=0
	
	;;*************************************************************
	;;*************************************************************
	;;下面是：现金支付和卡支付的汇合处
	;;*************************************************************
	;;*************************************************************
	
	s myCashSum=0
	
	s myAPIInfo=$p(myAPIRepInfo,$c(3))
	s myAPIInfo1=$p(myAPIInfo,$c(4),1)
	s myAPIInfo2=$p(myAPIInfo,$c(4),2)
	s myAPIInfo3=$p(myAPIInfo,$c(4),3)
	s myAPIInfo4=$p(myAPIInfo,$c(4),4)
	
	;票据金额
	s myPRTTolSum=+$p(myIPRepInfo,"^",18)			;现金收费的票据金额+支票和其他的费用总和
	
	;***************************************************************************************
	;卡支付的票据金额
	;***************************************************************************************
	;DHC_INVPRT
	s myPRTAccSum=0
	;s myPRTAccSum=+$p(myIPCPPRepInfo,"^",2)			;DHC_INVPRT表中卡支付myCPPSum
	;s myPRTAccSum=+myPRTAccSum+$p(myIPCPPRepInfo,"^",4)			;红冲
	;s myPRTAccSum=+myPRTAccSum+$p(myIPCPPRepInfo,"^",6)			;作废
	
	;DHC_AccPayINV
	s myAccTolSum=+$p(myAPIInfo2,"^",1)					;卡支付中收费票据金额
	s myAccTolSum=+myAccTolSum+$p(myAPIInfo3,"^",1)		;卡支付中退费票据金额
	s myAccTolSum=+myAccTolSum+$p(myAPIInfo4,"^",1)		;卡支付中红冲票据金额
	
	s myTolSum=+myPRTTolSum+myAccTolSum+myPRTAccSum
	
	;卡支付返回值
	;s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum
	;s myNINfo=myNINfo_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	;s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	;s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	;s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	;s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum	
	;
	
	;现金支付返回值
	;s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	;s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	;s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	;s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	;s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	;s myOthPayInfo=myCPPNum_"^"_$fn(myCPPSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)  ;21--24
	;Refhandcash_"^"_Refhandcheck_"^"_myRefCPPSum_"^"_myRefBankCardSum_"^"_myRefOtherSum		;25--29
	
	;其中现金
	;s myCashSum=+myCashSum+$p(myIPRepInfo,"^",11)
	s myCashSum=+$p(myIPRepInfo,"^",11)
	;把门诊收费中的退费钱数加到现金中		；与原来的分解有些差异；把收来的钱分解
	;s myCashSum=+myCashSum+$p(myIPRepInfo,"^",7)
	s myCashSum=+myCashSum+$p(myIPRepInfo,"^",26)
	
	s myCashSum=+myCashSum+$p(myAPIInfo3,"^",7)
	s myCashSum=+myCashSum+$p(myAPIInfo4,"^",7)
	
	s myCashSum=+myCashSum+$p(myPDInfo,"^",5)
	
	;其中支票
	s myCheckSum=0
	s myCheckSum=+$p(myIPRepInfo,"^",12)
	s myCheckSum=+myCheckSum+$p(myIPRepInfo,"^",27)
	
	s myCheckSum=+myCheckSum+$p(myPDInfo,"^",6)
	;其中其他支付方式
	s myOtherSum=0
	s myOtherSum=+$p(myIPRepInfo,"^",25)
	s myOtherSum=+myOtherSum+$p(myIPRepInfo,"^",30)
	
	s myOtherSum=+myOtherSum+$p(myPDInfo,"^",7)
	
	;实际收款
	s mySKSum=0
	s mySKSum=$p(myIPRepInfo,"^",13)
	s mySKSum=+mySKSum+$p(myPDInfo,"^",2)
	
	;实际退款
	s myTKSum=0
	s myTKSum=$p(myIPRepInfo,"^",14)
	s myTKSum=+myTKSum + $p(myAPIInfo3,"^",7)			;卡支付退款时退现金总额
	s myTKSum=+myTKSum+$p(myAPIInfo4,"^",7)				;卡支付红冲时退现金总额
	s myTKSum=+myTKSum+$p(myPDInfo,"^",4)
	
	;实际上缴金额：
	;现金收款+(-医保退款+退费或红冲时的款项)
	;退费或红冲时的款项=-退费时退现金总额+退费时回收医保支付
	;                   -红冲时退现金总额+红冲时回收医保支付
	;这个钱都累加到实际上缴额
	;现金收款
	s myPRTPatSum=+$p(myIPRepInfo,"^",10)
	
	;集中打印发票时的收退款
	;医保退款
	;在DHC_AccPayINV表的YBPaySum字段，操作员退款为正，收款为负
	;都是-
	s myAccPatSum=-$p(myAPIInfo2,"^",5)
	s myYBPaySum=-$p(myAPIInfo2,"^",5)
	
	;退费时回收医保支付
	s myAccPatSum=+myAccPatSum-$p(myAPIInfo3,"^",5)
	s myYBPaySum=myYBPaySum-$p(myAPIInfo3,"^",5)
	;退款时退现金总额
	s myAccPatSum=+myAccPatSum+$p(myAPIInfo3,"^",7)
	
	;红冲时回收医保支付
	s myAccPatSum=+myAccPatSum-$p(myAPIInfo4,"^",5)
	s myYBPaySum=myYBPaySum-$p(myAPIInfo4,"^",5)
	;红冲时退现金总额
	s myAccPatSum=+myAccPatSum+$p(myAPIInfo4,"^",7)
	
	;预交金额
	s myPDPatSum=+$p(myPDInfo,"^",2)+$p(myPDInfo,"^",4)
	
	;实际上缴额
	s myPatSum=+myPRTPatSum+myAccPatSum+myPDPatSum
	
	;数值类型转换
	s myTolSum=$fn(myTolSum,"",2)
	
	s myPatSum=$fn(myPatSum,"",2)
	
	s myYBPaySum=$fn(myYBPaySum,"",2)
	s mySKSum=$fn(mySKSum,"",2)
	s myTKSum=$fn(myTKSum,"",2)
	s myCashSum=$fn(myCashSum,"",2)
	s myCheckSum=$fn(myCheckSum,"",2)
	s myOtherSum=$fn(myOtherSum,"",2)
	s myYBPaySum=$fn(myYBPaySum,"",2)
	b	;

	;s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum_RefPRTInfo_ParkPRTInfo
	;增加DHC_INVPRT打印发票的卡支付汇总金额  这个代表医院收入
	s myCPPPRTINVSum=+$p(myIPCPPRepInfo,"^",2)
	s myCPPPRTINVSum=+myCPPPRTINVSum+$p(myIPCPPRepInfo,"^",4)
	s myCPPPRTINVSum=+myCPPPRTINVSum+$p(myIPCPPRepInfo,"^",6)
	
	;b	;实际上缴额
	;主要信息包括：上缴金额信息+总的发票信息
	;+日期段信息;
	s myMInfo=myINVInfo_"^"_stdate_"^"_sttime_"^"_EndDate_"^"_EndTime		;0-4
	s myMInfo=myMInfo_"^"_myTolSum_"^"_myPatSum_"^"_mySKSum_"^"_myTKSum_"^"_myCashSum_"^"_myCheckSum	;5--10
	s myMInfo=myMInfo_"^"_myOtherSum_"^"_myYBPaySum		;11-12
	
	b		;myMInfo
	s mystr=myMInfo_$c(3)_myIPRepInfo_$c(3)_myAPIRepInfo_$c(3)_myPDInfo_$c(3)_myIPCPPRepInfo_$c(3)_myCPPPRTINVSum
	
	s retval=itmjs_"('"_$ZCVT(mystr,"O","JS")_"');"
	&javascript<#(retval)#>
	
	d ..KillTmp()
		
	q myrtn
}

ClassMethod GetINVPRTRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
	n (stdate,sttime,EndDate,EndTime, hUser)
	
	;w ##class(web.udhcOPHandin11Back).GetINVPRTRepInfo(60315,39695,60410,65865,10033)
	
	;对于所有的卡支付都不在此体现，只有有发票的才能体现
	;
	;对于打印发票的卡支付需要被结算，同时在界面上显示
	
	s ToPaySum=0		;医疗费用支付总额?
	
	s ToPaySum=0		;医疗费用支付总额?
	
	s handinsum=0 ;应上交金额
	s handcash=0  ;应上交现金
	s handcheck=0 ;应上交支票
	s checknum=0  ;支票张数
	s cashnum=0   ;现金张数
	
	;费用总额变量
	s FootTotSum=0		;结算总费用
	s TotSum=0		;;总的金额	没有任何折扣之前
	s AbTotSum=0	;
	s RefTotSum=0	;
	
	;患者支付额度
	s PatPaySum=0	;患者支付金额?现金或支票?
	s PatPCash=0	;上交现金
	s PatPcheck=0	;上交支票
	s AbPatPaySum=0		;红冲?患者支付?
	s RefPatPaySum=0	;作废?患者支付?
	
	s RefundINVInfo=""		;红冲票据号码
	s ParkINVInfo=""		;作废票据号码
	
	s myPRoundSum=0		;分币误差
	s myAbPatRoundSum=0
	s myRefPatRoundSum=0
	
	s cancelnum=0,cancelsum=0   ;作废张数?作废金额
	s refundnum=0,refundsum=0   ;红冲张数?红冲金额
	s sksum=0,tksum=0           ;收款金额?退款金额
	s jybs=0,INVNOinfo=""
	s myRoundSum=0				;存放误差额
	
	;CPP  支付
	s myAPNum=0
	s myAPSum=0
	s myAPRefNum=0
	s myAPRefSum=0
	s myAPParkNum=0
	s myAPParkSum=0
	s myAPRefPRTInfo=""
	s myAPParkPRTInfo=""
	
	i (stdate'="")&(sttime'="")  d
	.s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...q:Handin="Y"
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	...;加入舍入问题
	...s PrtPatPay=+PrtPatPay+($p(^DHCINVPRT(PRTrowid),"^",37))
	...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	...s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	...;去掉卡支付的小票记录；
	...;但是不能去掉发票的卡支付
	...s myPaySub=0
	...s myPMCode=""
	...f  s myPaySub=$o(^DHCINVPRT(PRTrowid,"P",myPaySub)) q:((myPaySub="")||(myPMCode="CPP"))  d
	....s myPMDR=$p(^DHCINVPRT(PRTrowid,"P",myPaySub),"^",1)
	....s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...q:(myPMCode="CPP")&&(PrtNO="")&&(Flag="N")			;如果是卡支付退出,正常发票   1
	...;非正常发票
	...s myOldINVNo=""
	...s myOldPMCode=""
	...i (PrtinvDr'="") d
	....s myOldINVNo=$p(^DHCINVPRT(PrtinvDr),"^",14)
	....s myOldPMCode=""
	....s myOldPaySub=0
	....f  s myOldPaySub=$o(^DHCINVPRT(PrtinvDr,"P",myOldPaySub)) q:((myOldPaySub="")||(myOldPMCode="CPP"))  d
	.....s myOldPMDR=$p(^DHCINVPRT(PrtinvDr,"P",myOldPaySub),"^",1)
	.....s:myOldPMDR'="" myOldPMCode=$p(^CT("CTPM",myOldPMDR),"^",1)
	...q:((myPMCode="CPP")&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;作废的票据		2
	...;对于卡支付作废的发票退的现金体现在发票中；故此此处跳出
	...q:((myOldPMCode="CPP")&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;3
	...;b		;可以
	...i PrtNO'=""  d
	....s snum=snum+1
	....s ^TMPOPHand($j,"INV",snum)=PrtNO
	....s ^TMPOPHand($j,"INVNO",PrtNO)=Flag			;;按照票据号码生成Global
	...s stat=..STATtoOPCAT(PRTrowid)
	...;本收款员收取的票据?   下面的票据统计不包括CPP支付
	...i (((Flag="N")||((PrtinvDr="")&&(Flag'="N")))&&((myPMCode'="CPP")))  d
	....s PatPaySum=PatPaySum+$g(PrtPatPay)
	....s TotSum=TotSum+$g(PRTAcount)
	....s myPRoundSum=$g(myPRoundSum)+$p(^DHCINVPRT(PRTrowid),"^",37)		;PRT_OPCRoundErr
	....s jybs=jybs+1
	...;本收款员作废的单据?	下面的数据都依存于原帐单?
	...i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode'="CPP")  d
	....;重新写的作废单据
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s myAbPatRoundSum=+myAbPatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	....s ParkINVInfo=ParkINVInfo_" "_ParkPrtNO_", "
	....s cancelnum=cancelnum+1
	....s cancelsum=cancelsum+PRTAcount
	....s tksum=tksum+PRTAcount
	....s jybs=jybs+1
	....s myPRoundSum=$g(myPRoundSum)+$p(^DHCINVPRT(PRTrowid),"^",37)		;PRT_OPCRoundErr
	...;本收款员红冲得单据
	...i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode'="CPP")))  d
	....;重新写的红冲单据
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s myRefPatRoundSum=+myRefPatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s RefundINVInfo=RefundINVInfo_" "_RefundPrtNO_", "
	....s refundnum=refundnum+1
	....s refundsum=refundsum+$ZABS(PRTAcount)
	....s tksum=tksum+$ZABS(PRTAcount)
	....s myPRoundSum=$g(myPRoundSum)+$p(^DHCINVPRT(PRTrowid),"^",37)		;PRT_OPCRoundErr
	...;取支付模式 对于收费的发票
	...i myPMCode="CPP" d
	....;b	;;	CPP   处理CPP支付
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPPayMode(PRTrowid)
	...e  d
	....d ..ReadOPParkPayMode(PRTrowid)
	...;下面全部是卡支付的发票
	...q:((myPMCode'="CPP"))
	...i (((Flag="N")||((PrtinvDr="")&&(Flag'="N")))&&((myPMCode="CPP")))  d
	....s myAPNum=myAPNum+1
	....s myAPSum=myAPSum+$g(PrtPatPay)
	...i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode="CPP")))  d
	....s myAPRefNum=myAPRefNum+1
	....s myAPRefSum=myAPRefSum+$g(PrtPatPay)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s myAPRefPRTInfo=myAPRefPRTInfo_" "_RefundPrtNO_", "
	...i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode="CPP")  d
	....s myAPParkNum=myAPParkNum+1
	....s myAPParkSum=myAPParkSum+$g(PrtPatPay)
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s myAPParkPRTInfo=myAPParkPRTInfo_" "_ParkPrtNO_", "
	
	
	s myPosNum=0
	s myPosSum=0
	s myCPPNum=0
	s myCPPSum=0
	s myOtherNum=0
	s myOtherSum=0
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:(myPMDR="")  d
	.s myAmt=+$g(^TMPOPPayMode($j,myPMDR))
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金
	.i myPMCode="CASH"  d
	..s handcash=handcash+myAmt
	..s cashnum=+cashnum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.;支票
	.i myPMCode="CHEQUES" d
	..s handcheck=handcheck+myAmt
	..s checknum=+checknum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.;信用卡
	.;i myPMCode="POS" d
	..;s myPosNum=+myPosNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..;s myPosSum=myPosSum+myAmt
	.;卡支付
	.i myPMCode="CPP" d
	..s myCPPNum=+myCPPNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myCPPSum=+myCPPSum+myAmt
	.
	.i ((("^CASH^^CHEQUES^CPP^")'[("^"_myPMCode_"^"))&&(myPMCode'="CPP")) d
	.. s myOtherNum=myOtherNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.. s myOtherSum=myOtherSum+myAmt
	
	s Refhandcash=0
	s Refhandcheck=0
	s myRefCPPSum=0
	s myRefBankCardSum=0
	s myRefOtherSum=0
	
	;读取作废/红冲的数据
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPParkPayMode($j,myPMDR)) q:(myPMDR="")  d
	.s myAmt=+$g(^TMPOPParkPayMode($j,myPMDR))
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.;现金
	.i myPMCode="CASH"  d
	..s Refhandcash=Refhandcash+myAmt
	..;s cashnum=+cashnum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	.;支票
	.i myPMCode="CHEQUES" d
	..s Refhandcheck=Refhandcheck+myAmt
	..;s checknum=+checknum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	.;信用卡
	.;i myPMCode="POS" d
	..;s myPosNum=+myPosNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	..;s myPosSum=myPosSum+myAmt
	.;卡支付
	.i myPMCode="CPP" d
	..;s myCPPNum=+myCPPNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	..s myRefCPPSum=+myRefCPPSum+myAmt
	.;银行卡支付
	.i myPMCode="BANK" d
	..s myRefBankCardSum=myRefBankCardSum+myAmt
	..;s myBankCardNum=+myBankCardNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	.i ((("^CASH^^CHEQUES^CPP^BANK^")'[("^"_myPMCode_"^"))&&(myPMCode'="CPP")) d
	..;s myOtherNum=myOtherNum+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))
	..s myRefOtherSum=myRefOtherSum+myAmt
	
	;b		;Too
	
	;费用总额
	s FootTotSum=$fn(TotSum+AbTotSum+RefTotSum,"",2)			;发票总额
	
	s handinsum=$fn(PatPaySum+AbPatPaySum+RefPatPaySum,"",2)		;应上交金额
	
	s tksum=$fn(AbPatPaySum+RefPatPaySum,"",2)						;总退款
	s sksum=$fn(PatPaySum,"",2)		;总收款
	
	;公费总额
	s PayorSum= $fn(FootTotSum-handinsum,"",2)			;
	
	s refundsum=$fn(RefPatPaySum,"",2)		;
	s cancelsum=$fn(AbPatPaySum,"",2)		;
	
	s handcash=$fn(handcash,"",2)
	s handcheck=$fn(handcheck,"",2)
	
	s CurDate=$zd(EndDate,4)		;返回当前日期
	s CurTime=$zt(EndTime,1)		;返回当前时间
	s ret=$ZD(stdate,4)_"^"_$zt(sttime,1)_"^"_INVNOinfo_"^"_cashnum_"^"_checknum	;0-4
	s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	s ret=ret_"^"_handcash_"^"_handcheck_"^"_sksum_"^"_tksum_"^"_jybs_"^"_CurDate	;10-15
	s ret=ret_"^"_CurTime_"^"_FootTotSum		;16-17
	s ret=ret_"^"_$fn(PayorSum,"",2)_"^"_RefundINVInfo_"^"_ParkINVInfo	;18-20
	s myOthPayInfo=myCPPNum_"^"_$fn(myCPPSum,"",2)_"^"_myOtherNum_"^"_$fn(myOtherSum,"",2)  ;21--24
	
	s myRefInfo=Refhandcash_"^"_Refhandcheck_"^"_myRefCPPSum_"^"_myRefBankCardSum_"^"_myRefOtherSum		;25--29
	
	s myOthPayInfo=myOthPayInfo_"^"_myRefInfo
	s myOthPayInfo=myOthPayInfo_"^"_$fn(myPRoundSum,"",2)
	
	;卡支付的信息,退费信息，
	s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum
	s myCPPInfo=myCPPInfo_"^"_myAPRefPRTInfo_"^"_myAPParkPRTInfo
	
	s ret=ret_"^"_myOthPayInfo_$c(3)_myCPPInfo
	
	;验证是否能结算?
	i ((+cashnum'=0)||(+checknum'=0)||(+cancelnum'=0)||(+refundnum'=0)) d
	.s rtn=0
	e  d
	.s rtn=1
	
	quit rtn_$c(3)_ret
}

ClassMethod GetAccINVNOinfo() As %String
{
	;w ##class(web.udhcOPHandin11Back).GetINVNOinfo()
	n (ab)
	
	s INVNOinfo=""
	s Count = 0,newflag=0
	s startno=""
	s endno=""
	s num=0
	;^TMPOPACCHand($j,"INVCol",AccPrtNo)
	s myPrtNo=0 f  s myPrtNo=$o(^TMPOPACCHand($j,"INVCol",myPrtNo)) q:myPrtNo=""  d
	.s num=num+1
	.s invtmp=myPrtNo
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.s myNextPrtNo=$o(^TMPOPACCHand($j,"INVCol",myPrtNo))
	.;当前发票+1=下一个发票  说明在一个段，否则分段；
	.i (+myNextPrtNo=(+myPrtNo+1)) d
	..
	.e  d
	..;下一个段；
	..s endno=myPrtNo
	..s endno=..FormatINVNO(endno,lenReceipNo)
	..s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	..s startno="", endno=""
	..s newflag=1
	
	q INVNOinfo
}

ClassMethod GetINVNOinfo() As %String
{
	;w ##class(web.udhcOPHandin11Back).GetINVNOinfo()
	n (ab)
	
	s INVNOinfo=""
	s Count = 0,newflag=0
	s startno=""
	s endno=""
	s num=0
	s myPrtNo=0 f  s myPrtNo=$o(^TMPMYINVINFOi($j,"INV",myPrtNo)) q:myPrtNo=""  d
	.s num=num+1
	.s invtmp=myPrtNo				;$g(^TMPMYINVINFOi($j,"INV",num))
	.i (num=1)!(newflag=1)  d
	..s newflag=0
	..s startno = invtmp
	..s endno = invtmp
	..s lenReceipNo = $l(startno)
	.s myNextPrtNo=$o(^TMPMYINVINFOi($j,"INV",myPrtNo))
	.;当前发票+1=下一个发票  说明在一个段，否则分段；
	.i (+myNextPrtNo=(+myPrtNo+1)) d
	..
	.e  d
	..;下一个段；
	..s endno=myPrtNo
	..s endno=..FormatINVNO(endno,lenReceipNo)
	..s INVNOinfo = INVNOinfo _"  "_startno_"--"_endno_", "
	..s startno="", endno=""
	..s newflag=1
	
	q INVNOinfo
}

ClassMethod ReadOPPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
	;POS  信用卡
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	;在支付模式上已经把5舍6入补齐了
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0
	
	s myRoundSum=+$p(^DHCINVPRT(PRTRowID),"^",37)
	;
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.q:(myPMDR="")
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.s myPMSum=myPMSum		;+$g(myRoundSum)
	.;s myRoundSum=myRoundSum-myRoundSum
	.s ^TMPOPPayMode($j,myPMDR)=+$g(^TMPOPPayMode($j,myPMDR))+myPMSum
	.s ^TMPOPPayMode($j,myPMDR,"Num")=+$g(^TMPOPPayMode($j,myPMDR,"Num"))+1
	.;保存舍入
	.s ^TMPOPPayMode($j,myPMDR,"RSUM")=+$g(^TMPOPPayMode($j,myPMDR,"RSUM"))+myRoundSum
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPPayMode($j,myPMDR,"PM")=myPMDesc
	
	q 0
}

ClassMethod ReadOPParkPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0

	;把5舍6入的钱归加到第一种支付模式上
	s myRoundSum=+$p(^DHCINVPRT(PRTRowID),"^",37)
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.s myPMSum=myPMSum			;+$g(myRoundSum)
	.;s myRoundSum=myRoundSum-myRoundSum
	.q:(myPMDR="")
	.s ^TMPOPParkPayMode($j,myPMDR)=+$g(^TMPOPParkPayMode($j,myPMDR))+myPMSum
	.s ^TMPOPParkPayMode($j,myPMDR,"Num")=+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))+1
	.s ^TMPOPParkPayMode($j,myPMDR,"RSUM")=+$g(^TMPOPParkPayMode($j,myPMDR,"RSUM"))+myRoundSum
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPParkPayMode($j,myPMDR,"PM")=myPMDesc
	
	q 0
}

ClassMethod GetSTATCATinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	s STATCATinfo=""
	s cat="" f  s cat=$o(^TMPOPHandsub($j,cat)) q:cat=""  d
	.s tot=^TMPOPHandsub($j,cat)
	.i STATCATinfo=""  s STATCATinfo=cat_"^"_tot
	.e  s STATCATinfo=STATCATinfo_"||"_cat_"^"_tot
	s retval=itmjs_"('"_$ZCVT(ret,"O","JS")_"');"
	;i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ret,"O","JS")_"');"
	&javascript<#(retval)#>
	q 0
}

ClassMethod CheckHPreD(hUser As %String, BDate As %String, BTime As %String, EndDate As %String, EndTime As %String) As %String
{
	n (hUser, BDate,BTime, EndDate,EndTime)
	
	;s myPreDate=$o(^DHCACDi("AccM",0,"User",hUser,0))
	;q:(myPreDate="")
	s myPreTime=""
	s myAccDR=0
	s myPreDate=BDate-1
	s myFlag=""
	f  s myPreDate=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate)) q:((myPreDate="")||(myFlag="Y"))  d
	.s myAccDR=0
	.f  s myAccDR=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate, myAccDR)) q:((myAccDR="")||(myFlag="Y"))  d
	..s mySub=0
	..f  s mySub=$o(^DHCACDi("AccM",0,"User", hUser, myPreDate, myAccDR,"AccPD", mySub)) q:((mySub="")||(myFlag="Y"))  d
	...s myTMPTime=$p(^DHCACD("AccM",myAccDR,"AccPD",mySub),"^",4)
	...s myFootUDR=$p(^DHCACD("AccM",myAccDR,"AccPD",mySub),"^",13)
	...q:(myFootUDR'="")
	...b		;myflag
	...s myFlag="Y"
	
	q myFlag
}

ClassMethod Handin(sUser As %String, FootInfo As %String)
{
	;Sum As %String, EndDate As %String, EndTime As %String, StDate As %String, 
	;StTime As %String, Rcptno As %String, jynum As %String
	;w ##class(web.udhcOPHandin11Back).GetHandin("","","9937")
	;w ##class(web.udhcOPHandin11Back).Handin("5","20/10/2005^15:13:48^24/10/2005^23:08:44^55.00^5^  00000337--00000341^55.00^4^81.00^1^42.00^1^-47.00^1^-21.00^ 00000337^ 00000315")
	;w ##class(web.udhcOPHandin11Back).Handin("23294","^^^^02/06/2006^09:15:23^06/06/2006^22:53:58^503.41^23294^14^  00004531--00004532, ^^^^^^475.00^12^175.00^0^0.00^0^0.00^0^0.00^^^0^0.00^^0.00^2^328.41^0.00^0^0.00^0.00^0.00^0^0.00^0.00^0.00^^^0^0.00^475.00^0.00^475.00^0.00^0.00^2^300.00^0^0.00^300.00^0.00^0.00")
	n (sUser, FootInfo)
	s ^TMPHandin=sUser_"%%%"_FootInfo
	
	s $ZT="ERROR^DHCSSERR"

	s StDate=$zdh($p(FootInfo,"^",5),4)
	s StTime=$zth($p(FootInfo,"^",6),1)
	
	s EndDate=$zdh($p(FootInfo,"^",7),4)
	s EndTime=$zth($p(FootInfo,"^",8),1)
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	d ..KillTmp()
	
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	
	q:(myrtn) myrtn_"^"
	
	d ..tb()
	
	k PLIST
	
	s mylen=$l(FootInfo,"^")
	f i=2:1:mylen  d
	.s myValue=$p(FootInfo,"^",i)
	.i myValue'="" d
	..s PLIST(i-1)=myValue
	
	k PLIST(1)
	;日期格式转换
	s PLIST(2)=hdate		;HIS_Date
	s PLIST(3)=htime		;HIS_Time
	s PLIST(4)=$zdh(PLIST(4),4)		;HIS_StartDate
	s PLIST(5)=$zth(PLIST(5),1)		; HIS_StartTime
	s PLIST(6)=$zdh(PLIST(6),4)		;HIS_EndDate
	s PLIST(7)=$zth(PLIST(7),1)		;HIS_EndTime
	
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
	
	b ;;;;;
	i myrtn=0 d
	.;门诊类别大类和子类表
	.;^TmpCatSub($j,ItmOPCat,ItmOPSubCat)
	.f  s mycat=$o(^TMPCatSub($j,mycat)) q:(mycat=""||myrtn'=0)  d
	..s mycatsub=""
	..f  s mycatsub=$o(^TMPCatSub($j,mycat,mycatsub)) q:(mycatsub=""||myrtn'=0)  d
	...s myPatpay=$g(^TMPCatSub($j,mycat,mycatsub))
	...k PLIST
	...s PLIST(0)=HISParref
	...s PLIST(3)=mycat
	...s PLIST(4)=$fn(myPatpay,"",2)
	...s PLIST(5)=mycatsub
	...s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	
	b	;;;;;;
	;更新票据流水表   可能要更改
	i myrtn=0 d
	.s myrtn=##class(web.UDHCINVPRT).UpdateFootForUserNoCard(sUser, StDate, StTime, EndDate, EndTime, HISParref, hdate, htime)
	
	;判断是否有要结算的数据否则=100，错误
	;更新卡支付票据表 :myAPRowID
	i myrtn=0 d
	.;b		;myrtn
	.&sql(select min(API_RowID) into :myAPRowID  from DHC_AccPayINV 
			where API_PUser_DR=:sUser and API_INVRep_DR is null)
	.q:(myAPRowID="")
	.b		;;;;更新卡支付票据表
	.q:(SQLCODE'=0)
	.b		;;;;更新卡支付票据表
	.&sql(update DHC_AccPayINV set  API_INVRep_DR=:HISParref, API_CheckDate=:hdate, API_CheckTime=:htime, API_CheckUser_DR=:sUser
	      where (API_PUser_DR=:sUser and API_INVRep_DR is null and
	      ((API_Date>=:StDate and API_Date<:EndDate) or
	       (API_Date=:EndDate and API_Time<=:EndTime)) ))
	.s myrtn=SQLCODE
	
	b
	;更新预交金表
	i myrtn=0 d
	.s myflag=..CheckHPreD(sUser,StDate,StTime,EndDate,EndTime)
	.b		;更新预交金表
	.q:(myflag'="Y")
	.&sql(update DHC_AccPreDeposit
		set AccPD_IPRep_DR=:HISParref,AccPD_FootDate=:hdate, AccPD_FootTime=:htime, AccPD_FootUser_DR=:sUser
		where AccPD_User_DR=:sUser and (AccPD_IPRep_DR is null or AccPD_IPRep_DR="") 
		and ((AccPD_PreDate>=:StDate and AccPD_PreDate<:EndDate) or 
			(AccPD_PreDate=:EndDate and AccPD_PreTime<=:EndTime)))
	.s myrtn=SQLCODE
	
	;写日报的支付模式表，增加了预交金的支付与退，
	;写入支付模式子表
	;^TMPOPParkPayMode($j,myPMDR,"PM")
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPParkPayMode($j,myPMDR))  q:(myPMDR="")  d
	.s myParkSum=+$g(^TMPOPParkPayMode($j,myPMDR))
	.s ^TMPOPPayMode($j,myPMDR,"PKSum")=+$g(^TMPOPPayMode($j,myPMDR,"PKSum"))+myParkSum
	.s myParkNum=+$g(^TMPOPParkPayMode($j,myPMDR, "Num"))
	.s ^TMPOPPayMode($j,myPMDR,"PKNum")=+$g(^TMPOPPayMode($j,myPMDR,"PKNum"))+myParkNum
	
	i myrtn=0 d
	.s myPMDR=0
	.f  s myPMDR=$o(^TMPOPPayMode($j,myPMDR)) q:((myPMDR="")||(myrtn'=0))  d
	..s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	..q:(myPMCode="CPP")
	..s myPMSum=+$g(^TMPOPPayMode($j,myPMDR))
	..s myPMNum=+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	..s myParkSum=+$g(^TMPOPPayMode($j,myPMDR, "PKSum"))
	..s myParkNum=+$g(^TMPOPPayMode($j,myPMDR, "PKNum"))
	..s myPRDGNum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GNum"))
	..s myPRDGSum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GSum"))
	..s myPRDRefNum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefNum"))
	..s myPRDRefSum=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefSum"))
	..k PLIST
	..s PLIST(0)=HISParref
	..s PLIST(3)=myPMSum
	..s PLIST(4)=myPMDR
	..s PLIST(5)=myParkNum				;HisPay_Refund
	..s PLIST(6)=myParkSum				;HisPay_Refundsum
	..s PLIST(7)=myPMNum
	..s PLIST(8)=myPRDGNum
	..s PLIST(9)=$fn(myPRDGSum,"",2)
	..s PLIST(10)=myPRDRefNum
	..s PLIST(11)=$fn(myPRDRefSum,"",2)
	..s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	
	b		;Tro
	
	i myrtn=0 d
		.d ..tc()
	e  d
		.Trollback
	
	d ..KillTmp()
	
	quit myrtn_"^"_HISParref
}

ClassMethod KillTmp()
{
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
}

ClassMethod ReadUFCat(RepID As %String = "") As %String
{
	;读取门诊费用大类   RepID As %String = ""
	;w ##class(web.udhcOPHandin11Back).ReadUFCat()
	s CatData=""
	;^DHCTarC("TOC",0,"Code",4,4)=
	;^TMPOPCat($j,ItmOPCat)
	s mycode=""
	f  s mycode=$o(^DHCTarC("TOC",0,"Code",mycode)) q:mycode=""  d
	.s myrowid=""
	.f  s myrowid=$o(^DHCTarC("TOC",0,"Code",mycode,myrowid)) q:myrowid=""  d
	..s catdesc=$p(^DHCTarC("TOC",myrowid),"^",2)
	..i CatData="" d
	...s CatData=catdesc_$c(2)_$fn(+$g(^TMPOPCat($j,myrowid)),"",2)
	..e  d
	...s CatData=CatData_"^"_catdesc_$c(2)_$fn(+$g(^TMPOPCat($j,myrowid)),"",2)
	
	quit CatData
}

ClassMethod ReadUFSubCat() As %String
{
	;读取门诊费用子类
	;w ##class(web.udhcOPHandin11Back).ReadUFSubCat()
	s CatData=""
	;^DHCTarC("OC",0,"Code","10a",40)
	s mycode=""
	f  s mycode=$o(^DHCTarC("OC",0,"Code",mycode)) q:mycode=""  d
	.s myrowid=""
	.f  s myrowid=$o(^DHCTarC("OC",0,"Code",mycode,myrowid)) q:myrowid=""  d
	..s subcatdesc=$p(^DHCTarC("OC",myrowid),"^",2)
	..i CatData="" d
	...s CatData=subcatdesc_$c(2)_$fn(+$g(^TMPCatSubOther($j,"SubCat",myrowid)),"",2)
	..e  d
	...s CatData=CatData_"^"_subcatdesc_$c(2)_$fn(+$g(^TMPCatSubOther($j,"SubCat",myrowid)),"",2)
	
	quit CatData
}

ClassMethod STATtoOPCAT(INVPRTRowid As %String)
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
	...s totmp=totmp+TotalAmount
	...;定义一个^TmpCatSub($j,Cat,CatSub)
	...s ^TMPCatSub($j,ItmOPCat,ItmOPSubCat)=+$g(^TMPCatSub($j,ItmOPCat,ItmOPSubCat))+TotalAmount
	...s ^TMPCatSubOther($j,"SubCat",ItmOPSubCat)=+$g(^TMPCatSubOther($j,"SubCat",ItmOPSubCat))+TotalAmount
	...s ^TMPOPHandsub($j,OPCatDesc)=totmp
	...s ^TMPOPCat($j,ItmOPCat)=+TotalAmount+$g(^TMPOPCat($j,ItmOPCat))
	q 0
}

ClassMethod APayINVSTATtoOPCAT(APINVRowid As %String)
{
	n (APINVRowid)
	;把一张集中打印的票据转化为门诊收费大类或子类
	;^DHCINVPRTCAPi(0,"APINVDR",{ACP_APINV_DR},{ACP_RowID})
	
	s myACPRowID=0
	f  s myACPRowID=$o(^DHCINVPRTCAPi(0,"APINVDR",APINVRowid, myACPRowID)) q:(myACPRowID="")  d
	.s INVPRTRowid=$p($g(^DHCINVPRTCAP(myACPRowID)),"^",1)
	.s conRowid=0 F  S conRowid=$o(^DHCBCI(0,"INV",INVPRTRowid,conRowid)) Quit:conRowid=""  d
	..S Bill=$p(^DHCBCI(conRowid),"^",2)
	..q:'$D(^DHCPB(Bill))
	..S Ord="" F  S Ord=$o(^DHCPB(Bill,"O",Ord)) q:Ord=""  d
	...S Itm=0 For  Set Itm=$o(^DHCPB(Bill,"O",Ord,"D",Itm)) q:Itm=""  Do
	....;b DHC_TarOutpatCate	  DHC_TarOC
	....S ItmDr=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",3)
	....S TotalAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",7)
	....S DiscAmount=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",8)
	....S PayorShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",9)
	....S PatientShare=$p(^DHCPB(Bill,"O",Ord,"D",Itm),"^",10)	
	....S ItmOPSubCat=$p(^DHCTARI(ItmDr),"^",15)
	....q:$g(ItmOPSubCat)=""
	....s ItmOPSubCatDesc=$p(^DHCTarC("OC",ItmOPSubCat),"^",2)
	....S ItmOPCat=$p(^DHCTarC("OC",ItmOPSubCat),"^",3)
	....q:$g(ItmOPCat)=""
	....s OPCatDesc=$p(^DHCTarC("TOC",ItmOPCat),"^",2)
	....s totmp=+$g(^TMPOPHandsub($j,OPCatDesc))
	....s totmp=totmp+TotalAmount
	....;定义一个^TmpCatSub($j,Cat,CatSub)
	....s ^TMPCatSub($j,ItmOPCat,ItmOPSubCat)=+$g(^TMPCatSub($j,ItmOPCat,ItmOPSubCat))+TotalAmount
	....s ^TMPCatSubOther($j,"SubCat",ItmOPSubCat)=+$g(^TMPCatSubOther($j,"SubCat",ItmOPSubCat))+TotalAmount
	....s ^TMPOPHandsub($j,OPCatDesc)=totmp
	....s ^TMPOPCat($j,ItmOPCat)=+TotalAmount+$g(^TMPOPCat($j,ItmOPCat))
	
	q 0
}

ClassMethod SetINVRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
	;w ##class(web.udhcOPHandin11Back).SetINVRepInfo(60315,39695,60410,65865,10033)
	n (hUser, stdate,sttime,EndDate,EndTime)
	;生成临时的Global
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	
	;生成一个票据号码的Global
	f pdate=stdate:1:EndDate  d
	.q:($d(^DHCINVPRT(0,"Date",pdate))=0)
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>=EndTime)
	..q:(pdate=stdate)&(PRTTime<sttime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..q:(Handin="Y")
	..
	..s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	..s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	..s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	..i PrtNO'=""  d
	...s ^TMPMYINVINFO($j,"INVCP",PRTrowid)=PrtNO			;^DHCINVPRT()
	...s ^TMPMYINVINFOi($j,"INV",PrtNO)=PRTrowid_"^CP"
	
	;集中打印生成票据Global
	f APdate=stdate:1:EndDate  d
	.q:$d(^DHCINVPRTAPi(0,"Date",APdate))=0
	.s myAPRowID=""
	.f  s myAPRowID=$o(^DHCINVPRTAPi(0, "Date", APdate, myAPRowID))  q:(myAPRowID="")  d
	..s myAPUser=$p(^DHCINVPRTAP(myAPRowID),"^", 5)
	..q:(myAPUser'=hUser)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..q:((APdate=stdate)&&(myAPTime<sttime))
	..q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..q:(myCheckDate'="")
	..s YBAccAcount=$p(^DHCINVPRTAP(myAPRowID),"^", 1)		;发票费用总额API_Amount
	..s YBPatPay=$p(^DHCINVPRTAP(myAPRowID),"^", 16)		;发票患者卡支付总额  API_SelfPatPay
	..s AccPrtFlag=$p(^DHCINVPRTAP(myAPRowID),"^", 2)		;发票标志
	..s AccPrtNo=$p(^DHCINVPRTAP(myAPRowID),"^", 6)			;发票号码  API_INVNo
	..s AccPrtDR=$p(^DHCINVPRTAP(myAPRowID),"^", 10)		;API_PayINV_DR
	..i AccPrtNo'=""  d
	...s ^TMPMYINVINFO($j,"INVAP",myAPRowID)=AccPrtNo			;^DHCINVPRTAP(myAPRowID)
	...s ^TMPMYINVINFOi($j,"INV",AccPrtNo)=myAPRowID_"^AP"
	
	;合计发票
	q:('$d(^TMPMYINVINFOi($j,"INV"))) ""
	
	s myINVInfo=##class(web.udhcOPHandin11Back).GetINVNOinfo()
	
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	
	q myINVInfo
}

ClassMethod UnFootINV(hUser As %String, Begdate As %String, BegTime As %String, EndDate, EndTime As %String) As %String
{
	s Begdate=$zdh(Begdate,4)
	s BegTime=$zth(BegTime,1)
	s EndDate=$zdh(EndDate,4)
	s EndTime=$zth(EndTime,1)
	
	f pdate=Begdate:1:EndDate  d
	.q:$d(^DHCINVPRT(0,"Date",pdate))=0
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d  
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..q:Handin="Y"
	..s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	..s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
	..s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID  正常票据=??
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)
	..
	
	quit 0
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

}
