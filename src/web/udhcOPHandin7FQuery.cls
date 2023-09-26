Import SQLUser

Class web.udhcOPHandin7FQuery Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1088;

/// 银行卡支付模式
Parameter BankCardPayMode = "Bank";

/// 医院账户卡支付模式
Parameter CPPPayMode = "CPP";

/// 现金支付模式
Parameter CashPayMode = "CASH";

/// 支票支付模式
Parameter ChequePayMode = "CHEQUES";

/// 其他支付模式
Parameter OtherPayMode = "^^";

/// POS机支付模式
Parameter POSPayMode = "POS";

/// 医保卡支付模式, 因为有多种, 需要用 
Parameter YBCardPayMode = "^YBCardPay^";

/// /专门提供给华西来用的操作员自己的日报
/// /包括：
/// /1.对于DHC_INVPRT表的结算；
/// /1.1门诊现金(支票等类型)收费		用M来写结算时间和结算人；
/// /1.2门诊卡支付时，办理结算，但是不写结算时间和结算人
/// /1.3计算DHC_INVPRT和DHC_AccPayINV和 DHC_CardINVPRT发票的分布信息
/// /1.3.1分出集中打印的发票
/// /1.3.2分出现金(支票等)打印的发票
/// /1.4计算工作量等参数加入(在DHC_INVReports表中增加更多的字段)
/// /1.5增加医保返钱的统计；这部分钱需要财务返还到操作员手中；
/// /1.6收款员的门诊收入=门诊现金收费+医保支付的钱
/// /1.7加入 DHC_CardINVPRT 收费信息
/// /
/// /写的表
/// /DHC_INVPRTReports
/// /DHC_INVPRT,  DHC_AccPayINV表	
/// /DHC_CardINVPRT 表
/// /
/// /生成连续的号码； 
/// /
ClassMethod BuildOPINVItem(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String) As %String
{
	;w ##class(web.udhcOPHandin7).BuildOPINVItem(27, 60783, 57658, 60954, 68777)
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
	...s myPMDR=$o(^CT("CTPM",0,"Code",..#CPPPayMode,0))			;卡支付的支付模式
	...;f  s myPMSub=$o(^DHCINVPRT(PRTrowid,"P",myPMSub)) q:((myPMSub="")||(myPMCode=..#CPPPayMode))  d
	....;s myPMDR=$p(^DHCINVPRT(PRTrowid,"P",myPMSub),"^",1)
	....;s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...;s myPMSub=$o(^DHCINVPRTi(0,"PMDR",PRTrowid,myPMDR,"P",0))
	...s myPMSub=""
	...i myPMDR'="" d
	....s myPMSub=$o(^DHCINVPRTi(0,"PMDR",PRTrowid,myPMDR,"P",0))
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
	s myDefaultHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
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
	....s:pmid="" pmid=$o(^CT("CTPM",0,"Code",..#CashPayMode,0))
	....q:pmid=""
	....s myPMCode=$p(^CT("CTPM",pmid),"^",1)
	...s myPMDR=pmid
	...q:(myPMDR="")
	...i pdamt>0  d
	....;收预交金
	....s ^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","GNum")=+$g(^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","GNum"))+1
	....s ^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","GSum")=+$g(^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","GSum"))+$g(pdamt)
	...i pdamt<0 d
	....;退预交金
	....s ^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","RefNum")=+$g(^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","RefNum"))+1
	....s ^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","RefSum")=+$g(^TMPOPPayMode($j,myDefaultHospDR, myPMDR,"PRD","RefSum"))+$g(pdamt)
	...s receiptsno=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",6)
	
	;卡注册发票
	i (stdate'="")&(sttime'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCCARDINVPRTi(0,"Date",pdate))=0
	..s myCIPRowID=0
	..f  s myCIPRowID=$o(^DHCCARDINVPRTi(0,"Date",pdate,myCIPRowID)) q:(myCIPRowID="")  d
	...s PRTUser=$p(^DHCCARDINVPRT(myCIPRowID),"^",6)			;CIP_PUser_DR
	...q:PRTUser'=hUser
	...s PRTTime=$p(^DHCCARDINVPRT(myCIPRowID),"^",5)			;CIP_Time
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s myReportsDR=$p(^DHCCARDINVPRT(myCIPRowID),"^",9)			;CIP_INVReports_DR
	...q:myReportsDR'=""
	...s PRTAcount=$p(^DHCCARDINVPRT(myCIPRowID),"^",3)				;CIP_Amount
	...s PrtPatPay=PRTAcount
	...s PrtNO=$p(^DHCCARDINVPRT(myCIPRowID),"^",7)					;CIP_INVNo
	...s PrtinvDr=$p(^DHCCARDINVPRT(myCIPRowID),"^",8)		;原票据的RowID  正常票据=""
	...s Flag=$p(^DHCCARDINVPRT(myCIPRowID),"^",2)			;CIP_Flag
	...;去掉卡支付的小票记录；
	...;但是不能去掉发票的卡支付
	...s myPaySub=0
	...s myPMCode=""
	...;非正常发票
	...s myOldINVNo=""
	...s myOldPMCode=""
	...i (PrtinvDr'="") d
	....s myOldINVNo=$p(^DHCCARDINVPRT(PrtinvDr),"^",14)
	....s myOldPMCode=""
	....s myOldPaySub=0
	...;本收款员收取的票据?   下面的票据统计不包括CPP支付
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPCardPayMode(myCIPRowID)
	...e  d
	....d ..ReadOPCardParkPayMode(myCIPRowID)
	...;下面全部是卡支付的发票
	
	q rtn
}

/// /加入对于前缀和后缀的支持
ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod GetAPIRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, PRTCPPInfo As %String, APIObj) As %String
{
	n (itmjs, stdate, sttime, EndDate, EndTime, hUser, PRTCPPInfo)
	
	;此函数用来查询卡支付打印发票的统计；
	
	;w ##class(web.udhcOPHandin7).GetAPIRepInfo("", +$h-100,0,+$h,0, "10033")
	
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
	..q:(myCheckDate'="")	;已经结算的退出
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
	...b		;SSS
	...;New   ;;;
	...s AccRefPatPaySum=AccRefPatPaySum+$g(AccPatPay)
	...s AccRefTotSum=+AccRefTotSum+$g(AccAcount)
	...s AccRefundINVInfo=AccRefundINVInfo_" "_AccRefundPrtNO_", "
	...s AccRefundNum=AccRefundNum+1
	...s AccRefundSum=AccRefundSum+$g(AccPatPay)
	...s AccRefYBPaySum=+AccRefYBPaySum+$g(YBPay)
	...s AccRefCardPaySum=+AccRefCardPaySum+$g(PatCardPay)
	...s AccRefRefSum=+AccRefRefSum+$g(myRefundPay)
	...s AccRefCashSum=+AccRefCashSum +$g(PatCashPay)
	...s myRoundSum=+myRoundSum+$p(^DHCINVPRTAP(myAPRowID),"^", 24)		;API_OPCRoundSum
	..s myCount=+myCount+1
	
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
	
	s rtn=myCount
	
	q rtn_$c(3)_AccFootSum_$c(4)_myNINfo_$c(4)_myParkInfo_$c(4)_myRefInfo
}

//(stdate,sttime,EndDate,EndTime, hUser)

ClassMethod GetCardINVRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, ByRef RepInfos As web.DHCEntity.OPC.ReportsInfos) As %String
{
	;w ##class(web.udhcOPHandin7).GetCardINVRepInfo(60315,39695,60949,0,27)
	n (stdate, sttime, EndDate, EndTime, hUser, RepInfos)
	
	;q:hUser="" 0
	
	s myrtn=0
	
	;1. 发票
	;2. 金额
	;s myCardINVObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	;s myCardINVObj=CardINVObj
	
	i (stdate'="")&(sttime'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..;^DHCCARDINVPRTi(0,"Date",{CIP_Date},{CIP_RowID})
	..;^DHCCARDINVPRT({CIP_RowID})
	..q:$d(^DHCCARDINVPRTi(0,"Date",pdate))=0
	..s myCIPRowID=0
	..;b	;;CardINV  卡收费
	..f  s myCIPRowID=$o(^DHCCARDINVPRTi(0,"Date",pdate,myCIPRowID)) q:(myCIPRowID="")  d
	...s PRTUser=$p(^DHCCARDINVPRT(myCIPRowID),"^",6)			;CIP_PUser_DR
	...;q:PRTUser'=hUser
	...d RepInfos.SetUserRepsByUser(PRTUser)
	...s myCardINVObj = RepInfos.SelRepInfo
	...s PRTTime=$p(^DHCCARDINVPRT(myCIPRowID),"^",5)			;CIP_Time
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s myReportsDR=$p(^DHCCARDINVPRT(myCIPRowID),"^",9)			;CIP_INVReports_DR
	...;q:myReportsDR'=""
	...s PRTAcount=$p(^DHCCARDINVPRT(myCIPRowID),"^",3)				;CIP_Amount
	...s PrtPatPay=PRTAcount
	...s PrtNO=$p(^DHCCARDINVPRT(myCIPRowID),"^",7)					;CIP_INVNo
	...s PrtinvDr=$p(^DHCCARDINVPRT(myCIPRowID),"^",8)		;原票据的RowID  正常票据=""
	...s Flag=$p(^DHCCARDINVPRT(myCIPRowID),"^",2)			;CIP_Flag
	...;去掉卡支付的小票记录；
	...;但是不能去掉发票的卡支付
	...s myPaySub=0
	...s myPMCode=""
	...f  s myPaySub=$o(^DHCCARDINVPRT(myCIPRowID,"P",myPaySub)) q:((myPaySub="")||(myPMCode=..#CPPPayMode))  d
	....s myPMDR=$p(^DHCCARDINVPRT(myCIPRowID,"P",myPaySub),"^",1)
	....s:myPMDR'="" myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...q:(myPMCode=..#CPPPayMode)&&(PrtNO="")&&(Flag="N")			;如果是卡支付退出,正常发票   1
	...;非正常发票
	...s myOldINVNo=""
	...s myOldPMCode=""
	...i (PrtinvDr'="") d
	....s myOldINVNo=$p(^DHCCARDINVPRT(PrtinvDr),"^",14)
	....s myOldPMCode=""
	....s myOldPaySub=0
	....f  s myOldPaySub=$o(^DHCCARDINVPRT(PrtinvDr,"P",myOldPaySub)) q:((myOldPaySub="")||(myOldPMCode=..#CPPPayMode))  d
	.....s myOldPMDR=$p(^DHCCARDINVPRT(PrtinvDr,"P",myOldPaySub),"^",1)
	.....s:myOldPMDR'="" myOldPMCode=$p(^CT("CTPM",myOldPMDR),"^",1)
	...q:((myPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;作废的票据		2
	...;对于卡支付作废的发票退的现金体现在发票中；故此此处跳出
	...q:((myOldPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;3
	...i PrtNO'=""  d
	....s snum=snum+1
	....s ^TMPOPHand($j,"INV",snum)=PrtNO
	....s ^TMPOPHand($j,"INVNO",PrtNO)=Flag			;;按照票据号码生成Global
	...;本收款员收取的票据?   下面的票据统计不包括CPP支付
	...i (((Flag="N")||((PrtinvDr="")&&(Flag'="N")))&&((myPMCode'=..#CPPPayMode)))  d
	....;b	;;;CardNormal
	....s myCardINVObj.PatPaySum=+myCardINVObj.PatPaySum+$g(PrtPatPay)
	....s myCardINVObj.FactPatPaySum=+myCardINVObj.FactPatPaySum+$g(PrtPatPay)
	....s myCardINVObj.PatTotSum=+myCardINVObj.PatTotSum+$g(PRTAcount)
	....s myCardINVObj.FactPatTotSum=+myCardINVObj.FactPatTotSum+$g(PRTAcount)
	....i PrtNO'="" d
	.....s myCardINVObj.PatINVCount = myCardINVObj.PatINVCount+1
	....;不打印发票而收的钱数
	....s myCardINVObj.PatPRTCount = myCardINVObj.PatPRTCount+1
	...;本收款员作废的单据?	下面的数据都依存于原帐单?
	...i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode'=..#CPPPayMode)  d
	....;重新写的作废单据
	....s myCardINVObj.AbPatPaySum = myCardINVObj.AbPatPaySum+$g(PrtPatPay)
	....s myCardINVObj.AbTotSum = myCardINVObj.AbTotSum+$g(PRTAcount)
	....s myCardINVObj.AbPatPRTCount=+myCardINVObj.AbPatPRTCount+1
	....s myCardINVObj.AbPatINVCount=+myCardINVObj.AbPatINVCount+1
	....s ParkPrtNO=$p(^DHCCARDINVPRT(PrtinvDr),"^",7)		;作废票据的原票据号码?
	....s myCardINVObj.AbParkINVInfo= myCardINVObj.AbParkINVInfo_" "_ParkPrtNO_", "
	....s myCardINVObj.FactPatTotSum=+myCardINVObj.FactPatTotSum+$g(PRTAcount)
	....s myCardINVObj.FactPatPaySum=+myCardINVObj.FactPatPaySum+$g(PrtPatPay)
	....;s cancelnum=cancelnum+1
	...;本收款员红冲得单据
	...i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode'=..#CPPPayMode)))  d
	....;重新写的红冲单据
	....s myCardINVObj.RefPatPaySum=+myCardINVObj.RefPatPaySum+$g(PrtPatPay)
	....s myCardINVObj.RefTotSum=+myCardINVObj.RefTotSum+$g(PRTAcount)
	....s myCardINVObj.RefPatINVCount=+myCardINVObj.RefPatINVCount+1
	....s myCardINVObj.RefPatPRTCount=+myCardINVObj.RefPatPRTCount+1
	....s RefundPrtNO=$p(^DHCCARDINVPRT(PrtinvDr),"^",7)		;红冲票据的原票据号码?
	....s myCardINVObj.RefundINVInfo=myCardINVObj.RefundINVInfo_" "_RefundPrtNO_", "
	....s myCardINVObj.FactPatPaySum=+myCardINVObj.FactPatPaySum+$g(PrtPatPay)
	....s myCardINVObj.FactPatTotSum=+myCardINVObj.FactPatTotSum+$g(PRTAcount)
	...s myrtn=+myrtn+1
	...d myCardINVObj.PutCardINVPayMode(myPMCode,Flag,PrtPatPay,1)
	...i myPMCode=..#CPPPayMode d
	....;b	;;	CPP   处理CPP支付
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPCardPayMode(myCIPRowID)
	...e  d
	....d ..ReadOPCardParkPayMode(myCIPRowID)
	
	s myPMDR=0
	
	q myrtn_$c(3)_""
}

ClassMethod GetPRDRepINfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, RepInfos As web.DHCEntity.OPC.ReportsInfos) As %String
{
	;w ##class(web.udhcOPHandin7).GetPRDRepINfo(60315,39695,60410,65865,1)
	n (stdate, sttime, EndDate, EndTime, hUser, RepInfos)
	
	;s ^TMPINfo=stdate_"^"_sttime_"^"_EndDate_"^"_EndTime_"^"_hUser
	;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	
	;q:'$d(^DHCACDi("AccM",0,"User",hUser)) 0_$c(3)_"0^0.00^0^0.00^0.00^0.00^0.00"
	
	s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
	s mypdnum=0
	s footnum=0,refundnum=0,rcptstr=""
	
	;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},                      x
	;x           {DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	s pddate=stdate-1
	f  s pddate=$o(^DHCACDi("AccM",0,"APDDate",pddate)) q:((pddate="")||(+pddate>+EndDate))  d
	.s accid=0
 	.f  s accid=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid)) q:accid=""  d
	..s pdsub=0
	..f  s pdsub=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid,"AccPD",pdsub)) q:pdsub=""  d
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
	....s:pmid="" pmid=$o(^CT("CTPM",0,"Code",..#CashPayMode,0))
	....q:pmid=""
	....s myPMCode=$p(^CT("CTPM",pmid),"^",1)
	....i myPMCode=..#CashPayMode s cashsum=cashsum+pdamt
	....i myPMCode=..#ChequePayMode s chequesum=chequesum+pdamt
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
	
	;利用收退款笔数来决定是否能办理结算
	s rtn=footnum
	
	q rtn
}

ClassMethod ReadINVRange() As %String
{
}

ClassMethod GetDate(hUser As %String, EndDate As %String)
{
	;;w ##class(web.udhcOPHandin7).GetDate("6","2007-11-18")
	s stdate="",sttime=""
	s myAPRowID=""
	s myPrtDate=""
	s myPrtTime=""
	s myAPDate=""
	s myAPTime=""
	s myPreDate=""
	s myPreTime=""
	s myCardINVDate=""
	s myCardINVTime=""
	
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
	.;卡注册时最小的日期
	.&sql(select min(CIP_RowID) into :myCIPRowID from DHC_CardINVPRT where (CIP_PUser_DR=:hUser and (CIP_INVReports_DR is null !(CIP_INVReports_DR=""))))
	.b	;;CIPRowID
	.i (myCIPRowID'="") d
	..s myCardINVDate=$p(^DHCCARDINVPRT(myCIPRowID),"^",4)
	..s myCardINVTime=$p(^DHCCARDINVPRT(myCIPRowID),"^",5)
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
	
	i (myCardINVDate'="") d
	.i ((stdate="")||((+stdate=+myCardINVDate)&&(+sttime>+myCardINVTime))||(+stdate>+myCardINVDate)) d
	..s stdate=myCardINVDate
	..s sttime=myCardINVTime
	
	i stdate="" d  s stdate=+$h
	i sttime="" d  s sttime=$p($h,",",2)
	
	;获取预交金的最小未结算日期
	
	q stdate_"^"_sttime
}

ClassMethod GetHandin(itmjs As %Library.String = "", itmjsex As %Library.String = "", hUser As %String) As %String
{
	;, EndDate As %String, EndTime As %String
	;调试代码
	;w ##class(web.udhcOPHandin7).GetHandin("","","6")
	;w ##class(web.udhcOPHandin7).GetCardINVRepInfo(60315,39695,60949,0,27)
	;w ##class(web.udhcOPHandin7).KillTmp()
	;^TMPHandin=5%%%
	n (itmjs, itmjsex, hUser)
	
	d ..KillTmp()
	
	s EndDate=+$h		;$zdh(EndDate,3)
	s EndTime=$p($h,",",2)			;$zth(EndTime,1)
	s sttimeinfo=..GetDate(hUser,EndDate)
	s stdate=$p(sttimeinfo,"^",1)
	s sttime=$p(sttimeinfo,"^",2)
	
	;生成TMP  Global
	
	s myINVInfo=##class(web.udhcOPHandin7).SetINVRepInfo(stdate,sttime,EndDate,EndTime, hUser)
	;b	;;;myINVInfo
	
	;增加卡支付门诊发票的结算
	s myINVObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	s myIPRepInfo=##class(web.udhcOPHandin7).GetINVPRTRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myINVObj)
	;b	;myIPRepInfo
	
	s myIPRepInfo1=myIPRepInfo
	s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	
	s myAPIObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	s myAPIRepInfo=##class(web.udhcOPHandin7).GetAPIRepInfo(stdate,sttime,EndDate,EndTime, hUser, myIPCPPRepInfo, .myAPIObj)
	
	b ;myAPIRepInfo
	s myAPRtn=$p(myAPIRepInfo,$c(3),1)
	s myAPIRepInfo=$p(myAPIRepInfo,$c(3),2)
	
	s myPDObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	s myPDInfo=##class(web.udhcOPHandin7).GetPRDRepINfo(stdate,sttime,EndDate,EndTime, hUser, .myPDObj)
	b	;PRD   OK
	s myPDRtn=$p(myPDInfo,$c(3),1)
	s myPDInfo=$p(myPDInfo,$c(3),2)
	
	s myCardObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	s myCardINVInfo=##class(web.udhcOPHandin7).GetCardINVRepInfo(stdate,sttime,EndDate,EndTime, hUser, .myCardObj)
	s myCardINVRtn=$p(myCardINVInfo,$c(2),1)
	
	b	; CardINVPRT
	
	;判断的标准是否有记录包含在里面
	s myrtn=1
	i ((+myIPRtn>0)!(+myAPRtn>0)!(+myPDRtn>0)!(myCardINVRtn>0))  d
	.s myrtn=0
	
	;;*************************************************************
	;;*************************************************************
	;;下面是：现金支付和卡支付的汇合处
	;;*************************************************************
	;;*************************************************************
	
	s myCashSum=0
	
	;票据金额
	;***************************************************************************************
	;卡支付的票据金额
	;***************************************************************************************
	;DHC_INVPRT
	;费用总额
	;s myTolSum=+myPRTTolSum+myAccTolSum+myPRTAccSum
	;s myTolSum=+myTolSum + myCardObj.PatPaySum
	
	;其中现金
	;s myCashSum=+myCashSum+$p(myIPRepInfo,"^",11)
	;s myCashSum=+$p(myIPRepInfo,"^",11)
	;把门诊收费中的退费钱数加到现金中		；与原来的分解有些差异；把收来的钱分解
	
	;其中支票
	///s myCheckSum=+myCheckSum+myCardObj.PayMode.ChequeSum
	///s myCheckSum=+myCheckSum+myCardObj.ParkPayMode.ChequeSum
	///s myCheckSum=+myCheckSum+myCardObj.RefPayMode.ChequeSum
	
	;其中其他支付方式
	
	;实际收款
	
	;实际退款
	
	;实际上缴金额：
	;现金收款+(-医保退款+退费或红冲时的款项)
	;退费或红冲时的款项=-退费时退现金总额+退费时回收医保支付
	;                   -红冲时退现金总额+红冲时回收医保支付
	;这个钱都累加到实际上缴额
	;现金收款
	
	;集中打印发票时的收退款
	;医保退款
	;在DHC_AccPayINV表的YBPaySum字段，操作员退款为正，收款为负
	;都是-
	
	;退费时回收医保支付
	;退款时退现金总额
	
	;红冲时回收医保支付
	;红冲时退现金总额
	
	;预交金额
	
	;实际上缴额
	
	;数值类型转换
	b	;

	;s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum_RefPRTInfo_ParkPRTInfo
	;增加DHC_INVPRT打印发票的卡支付汇总金额  这个代表医院收入
	
	;b	;实际上缴额
	;主要信息包括：上缴金额信息+总的发票信息
	;+日期段信息;
	
	;卡的报表
	;s myCardIPRepInfo=myCardObj.GetCardINVInfo()
	
	;,,,, hUser, 
	s myOutObj=##class(web.DHCEntity.OPC.Report).%New()
	
	s myTINVObj=##class(web.DHCEntity.OPC.ReportsInfo).%New()
	
	;转换计费支付模式，在界面上显示
	;ParkPayMode
	;PayMode
	;RefPayMode
	;TotalPayMode
	d myTINVObj.Calculate("+", myCardObj)
	d myTINVObj.Calculate("+", myINVObj)
	d myTINVObj.Calculate("+", myPDObj)
	d myTINVObj.Calculate("+", myAPIObj)
	
	s myOutObj.HISAmount=myTINVObj.FactPatTotSum
	s myOutObj.HISDate =""
	s myOutObj.HISStartDate =$zd(stdate,3)
	s myOutObj.HISStartTime =$zt(sttime)
	s myOutObj.HISEndDate = $zd(EndDate,3)
	s myOutObj.HISEndTime = $zt(EndTime)
	s myOutObj.HISParkINVInfo = myTINVObj.AbParkINVInfo
	s myOutObj.HISParkNum = myTINVObj.AbPatINVCount
	s myOutObj.HISParkSum = myTINVObj.AbTotSum
	s myOutObj.HISPatSum = myTINVObj.FactPatPaySum
	s myOutObj.HISRcptNO =myINVInfo
	s myOutObj.HISRefundINVInfo = myTINVObj.RefundINVInfo
	s myOutObj.HISRefundNum = myTINVObj.RefPatINVCount
	s myOutObj.HISRefundSum = myTINVObj.RefTotSum
	s myOutObj.HISTime =""
	s myUserName=$p(^SSU("SSUSR",hUser),"^",2)
	s myOutObj.HISUser =""
	s myOutObj.HISUserName=myUserName
	s myOutObj.HisNum = myTINVObj.PatINVCount
	s myOutObj.HISReportType="U"
	
	s myOutObj.CalGetTotal=myTINVObj.PatPaySum
	s myOutObj.CalGiveTotal=myTINVObj.AbPatPaySum+ myTINVObj.RefPatPaySum
	
	b		;TINVOBJ
	;关闭对象
	
	d myCardObj.%Close()
	d myINVObj.%Close()
	d myPDObj.%Close()
	d myAPIObj.%Close()
	
	s myCatSubs=##class(web.DHCEntity.OPC.CatSubs).%New()
	
	d myCatSubs.TransPayMode(myCardObj)
	
	;格式化数据
	s myOutObj.HISAmount=$fn(myOutObj.HISAmount,"",2)
	s myOutObj.HISParkSum= $fn(myOutObj.HISParkSum,"",2)
	s myOutObj.HISPatSum= $fn(myOutObj.HISPatSum,"",2)
	s myOutObj.HISRefundSum = $fn(myOutObj.HISRefundSum,"",2)
	s myOutObj.CalGetTotal = $fn(myOutObj.CalGetTotal, "", 2)
	s myOutObj.CalGiveTotal = $fn(myOutObj.CalGiveTotal,"",2)
	
	d myOutObj.XMLExportToString(.mystr)
	
	d myOutObj.%Close()
	b		;myMInfo
	
	d myCatSubs.XMLExportToString(.myCatXmlData)
	
	s retval=itmjs_"('"_$ZCVT(mystr,"O","JS")_"', '"_$ZCVT(myCatXmlData,"O","JS")_"' "
	s retval=retval_");"
	s ^TMPJSTESTDFDFD=retval
	&javascript<#(retval)#>
	
	;
	s myTCashSum=0
	s myTCheckSum=0
	s myTBankCardSum=0
	s myTYBCardSum=0
	s myTDWJZSum=0
	s myTHTJZSum=0
	s myTBLJZSum=0
	S myTTotSum=0
	
	s myCount=myTINVObj.TotalPayMode.Count()
	f myIdx=1:1:myCount d
	.s myTPMObj=myTINVObj.TotalPayMode.GetAt(myIdx)
	.s myDesc=myTPMObj.SubAvailHospitlDesc
	.s myCashSum=myTPMObj.CashSum
	.s myCheckSum=myTPMObj.ChequeSum
	.s myBankCardSum=myTPMObj.BankCardSum
	.s myYBCardSum=myTPMObj.YBCardSum
	.b	;;;OutTab
	.s myDWJZSum=0.00
	.s myHTJZSum=0.00
	.s myBLJZSum=0.00
	.s myTotSum=myCashSum+myCheckSum+myBankCardSum+myYBCardSum+myDWJZSum
	.s myTotSum=+myTotSum+myHTJZSum+myBLJZSum
	.s myTotSum=$fn(myTotSum,"",2)
	.s myTCashSum=+myTCashSum+myCashSum
	.s myTCheckSum=+myTCheckSum+myCheckSum
	.s myTBankCardSum=+myTBankCardSum+myBankCardSum
	.s myTYBCardSum=+myTYBCardSum+myYBCardSum
	.s mystr=myDesc_"^"_myCashSum_"^"_myCheckSum_"^"_myBankCardSum
	.s mystr=mystr_"^"_myYBCardSum_"^"_myDWJZSum_"^"_myHTJZSum
	.s mystr=mystr_"^"_myBLJZSum_"^"_myTotSum
	.s retval=itmjsex_"('"_$ZCVT(mystr,"O","JS")_"');"
	.&javascript<#(retval)#>

	s myTTotSum=+myTCashSum+myTCheckSum+myTBankCardSum+myTYBCardSum+myTDWJZSum+myTHTJZSum+myTBLJZSum
	s mystr="合计： "_"^"_myTCashSum_"^"_myTCheckSum_"^"_myTBankCardSum
	s mystr=mystr_"^"_myTYBCardSum_"^"_myTDWJZSum_"^"_myTHTJZSum
	s mystr=mystr_"^"_myTBLJZSum_"^"_myTTotSum
	s retval=itmjsex_"('"_$ZCVT(mystr,"O","JS")_"');"
	&javascript<#(retval)#>
	
	d myTINVObj.%Close()
	
	d ..KillTmp()
		
	q myrtn
}

ClassMethod ReportXmlOut() As %String
{
	///报表输出使用Xml格式输出
	s myOutStr=""
	s myOutObj=##class(web.DHCEntity.OPC.Report).%New()
	s myOutObj.HISAmount=""
	s myOutObj.HISDate =""
	s myOutObj.HISEndDate =""
	s myOutObj.HISEndTime =""
	s myOutObj.HISParkINVInfo =""
	s myOutObj.HISParkNum =""
	s myOutObj.HISParkSum =""
	s myOutObj.HISPatSum =""
	s myOutObj.HISRcptNO =""
	s myOutObj.HISRefundINVInfo =""
	s myOutObj.HISRefundNum =""
	s myOutObj.HISRefundSum =""
	s myOutObj.HISStartDate =""
	s myOutObj.HISStartTime =""
	s myOutObj.HISTime =""
	s myOutObj.HISUser =""
	s myOutObj.HisNum =""
	
	
	q myOutStr
}

ClassMethod GetINVPRTRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, RepInfos As web.DHCEntity.OPC.ReportsInfos) As %String
{
	n (stdate,sttime,EndDate,EndTime, hUser, RepInfos)
	
	;w ##class(web.udhcOPHandin7).GetINVPRTRepInfo(60315,39695,60410,65865,10033)
	
	s ToPaySum=0		;医疗费用支付总额?
	
	s ToPaySum=0		;医疗费用支付总额?
	
	s myCount=0
	
	i (stdate'="")&(sttime'="")  d
	.s snum=0
	.f pdate=stdate:1:EndDate  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...;q:PRTUser'=hUser
	...;d INVObj.SetUserRepsByUser(PRTUser)
	...d RepInfos.SetUserRepsByUser(PRTUser)
	...s INVObj=RepInfos.SelRepInfo
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...;q:Handin="Y"
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
	...;非正常发票
	...s myOldINVNo=""
	...s myOldPMCode=""
	...i (PrtinvDr'="") d
	....s myOldINVNo=$p(^DHCINVPRT(PrtinvDr),"^",14)
	....s myOldPMCode=""
	....s myOldPaySub=0
	....f  s myOldPaySub=$o(^DHCINVPRT(PrtinvDr,"P",myOldPaySub)) q:((myOldPaySub="")||(myOldPMCode=..#CPPPayMode))  d
	.....s myOldPMDR=$p(^DHCINVPRT(PrtinvDr,"P",myOldPaySub),"^",1)
	.....s:myOldPMDR'="" myOldPMCode=$p(^CT("CTPM",myOldPMDR),"^",1)
	...q:((myPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;作废的票据		2
	...;对于卡支付作废的发票退的现金体现在发票中；故此此处跳出
	...q:((myOldPMCode=..#CPPPayMode)&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))	;3
	...s stat=..STATtoOPCAT(PRTrowid)
	...;本收款员收取的票据?   下面的票据统计不包括CPP支付
	...i (((Flag="N")||((PrtinvDr="")&&(Flag'="N")))&&((myPMCode'=..#CPPPayMode)))  d
	....s INVObj.PatINVCount=+INVObj.PatINVCount+1
	....s INVObj.PatPRTCount=+INVObj.PatPRTCount+1
	....s INVObj.PatPaySum=+INVObj.PatPaySum+$g(PrtPatPay)
	....s INVObj.PatTotSum=+INVObj.PatTotSum+$g(PRTAcount)
	....s INVObj.PatRoundSum=+INVObj.PatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	...;本收款员作废的单据?	下面的数据都依存于原帐单?
	...i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode'=..#CPPPayMode)  d
	....;重新写的作废单据
	....s INVObj.AbPatINVCount=+INVObj.AbPatINVCount+1
	....s INVObj.AbPatPaySum=+INVObj.AbPatPaySum + PrtPatPay
	....s INVObj.AbPatPRTCount=+INVObj.AbPatPRTCount+1
	....s INVObj.AbPatRoundSum=+INVObj.AbPatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	....s INVObj.AbTotSum = +INVObj.AbTotSum + PRTAcount
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s INVObj.AbParkINVInfo =INVObj.AbParkINVInfo_" "_ParkPrtNO_", "
	...;本收款员红冲得单据
	...i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode'=..#CPPPayMode)))  d
	....;重新写的红冲单据
	....s INVObj.RefPatPaySum=+INVObj.RefPatPaySum+$g(PrtPatPay)
	....s INVObj.RefPatINVCount=+INVObj.RefPatINVCount+1
	....s INVObj.RefPatRoundSum=+INVObj.RefPatRoundSum+$p(^DHCINVPRT(PRTrowid),"^",37)
	....s INVObj.RefPatPRTCount=+INVObj.RefPatPRTCount+1
	....s INVObj.RefTotSum=+INVObj.RefTotSum+$g(PRTAcount)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s INVObj.RefundINVInfo=INVObj.RefundINVInfo_" "_RefundPrtNO_", "
	...s myCount=+myCount+1
	...;*********************************************************************
	...;*********************************************************************
	...;使用对象进行数据存储
	...s myBillStr=..GetINVBillStr(PRTrowid)
	...i myBillStr'="" d
	....;INVRowID, PRTFlag, BillStr
	....d INVObj.PutPayModeByPRTRowID(PRTrowid, Flag, myBillStr)
	...;取支付模式 对于收费的发票
	....;b	;;	CPP   处理CPP支付
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
	....d ..ReadOPPayMode(PRTrowid)
	...e  d
	....d ..ReadOPParkPayMode(PRTrowid)
	...;下面全部是卡支付的发票
	...q:((myPMCode'=..#CPPPayMode))
	
	;验证是否能结算?
	s rtn=myCount
	
	quit rtn_$c(3)
}

ClassMethod GetAccINVNOinfo() As %String
{
	;w ##class(web.udhcOPHandin7).GetINVNOinfo()
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
	;w ##class(web.udhcOPHandin7).GetINVNOinfo()
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

ClassMethod ReadOPParkPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	
	s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GreSubHospByINVRowID(PRTRowID)
	
	s myInsTypeDR=$p(^DHCINVPRT(PRTRowID),"^",9)		;PRT_InsType_DR
	s myINVPatSum=$p(^DHCINVPRT(PRTRowID),"^",16)		;PRT_PatientShare
	s myINVAcount=$p(^DHCINVPRT(PRTRowID),"^",1)		;PRT_Acount
	
	;折扣
	i +$fn($g(myINVAcount)-$g(myINVPatSum),"",2)'=0 d
	.s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefSum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefSum"))+$g(myINVAcount)-$g(myINVPatSum)
	.s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefNum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefNum"))+1		;表示此发票有结帐或者折扣
	
	s myOldINVFlg=""
	;票据红冲金额记录这个有一定意义
	s myOldINVFlg=$p(^DHCINVPRT(PRTRowID),"^",8)		;PRT_Flag
	
	s myPMSub=0
	
	;把5舍6入的钱归加到第一种支付模式上
	s myRoundSum=+0				;$p(^DHCINVPRT(PRTRowID),"^",37)
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.s myPMSum=myPMSum+$g(myRoundSum)
	.s myRoundSum=myRoundSum-myRoundSum
	.q:(myPMDR="")
	.s ^TMPOPParkPayMode($j,mySubHospDR, myPMDR)=+$g(^TMPOPParkPayMode($j,mySubHospDR, myPMDR))+myPMSum
	.s ^TMPOPParkPayMode($j,mySubHospDR, myPMDR,"Num")=+$g(^TMPOPParkPayMode($j,mySubHospDR, myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPParkPayMode($j,mySubHospDR, myPMDR,"PM")=myPMDesc
	.i myOldINVFlg="S" d
	..s ^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","RefSum")=+$g(^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","RefSum"))+myPMSum
	..s ^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","RefNum")=+$g(^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","RefNum"))+1
	
	q 0
}

ClassMethod ReadOPPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
	s mySubHospDR=""
	
	;POS  信用卡
	;^DHCINVPRT({DHC_INVPRT.PRT_Rowid},"P",{IPM_Sub})
	q:'$d(^DHCINVPRT(PRTRowID,"P"))
	s myPMSub=0
	s myInsTypeDR=$p(^DHCINVPRT(PRTRowID),"^",9)		;PRT_InsType_DR
	s myINVPatSum=$p(^DHCINVPRT(PRTRowID),"^",16)		;PRT_PatientShare
	s myINVAcount=$p(^DHCINVPRT(PRTRowID),"^",1)		;PRT_Acount
	
	;票据折扣金额
	i +$fn($g(myINVAcount)-$g(myINVPatSum),"",2)'=0 d
	.s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetSum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetSum"))+$g(myINVAcount)-$g(myINVPatSum)
	.s ^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetNum")=$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetNum"))+1		;表示此发票有结帐或者折扣
	
	s myOldINVFlg=""
	;票据红冲金额出的正发票金额，记录这个有一定意义
	s myOldPRTDR=$p(^DHCINVPRT(PRTRowID),"^",29)		;PRT_OldINV_DR
	i myOldPRTDR'="" d
	.;原发票的RowID
	.s myOldINVFlg=$p(^DHCINVPRT(myOldPRTDR),"^",8)			;PRT_Flag
	
	;规定这个张发票的 归属
	s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GreSubHospByINVRowID(PRTRowID)
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.s ^TMPOPPayMode($j,mySubHospDR, myPMDR)=+$g(^TMPOPPayMode($j,mySubHospDR, myPMDR))+myPMSum
	.s ^TMPOPPayMode($j,mySubHospDR, myPMDR,"Num")=+$g(^TMPOPPayMode($j,mySubHospDR, myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPPayMode($j,mySubHospDR, myPMDR,"PM")=myPMDesc
	.i myOldINVFlg="S" d
	..s ^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","GetSum")=+$g(^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","GetSum"))+myPMSum
	..s ^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","GetNum")=+$g(^TMPOPINVSTRIK($j,mySubHospDR, myPMDR,"Strik","GetNum"))+1
	.;
	.
	
	q 0
}

ClassMethod ReadOPCardPayMode(CIPRowID As %String = "") As %String
{
	n (CIPRowID)
	
	s PRTRowID=CIPRowID
	s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	
	;POS  信用卡
	;^DHCCARDINVPRT({DHC_CardINVPRT.CIP_RowID},"P",{CPM_Sub})
	;在支付模式上已经把5舍6入补齐了
	q:'$d(^DHCCARDINVPRT(PRTRowID,"P"))
	s myPMSub=0
	
	s myRoundSum=+$p(^DHCCARDINVPRT(PRTRowID),"^",37)
	
	f  s myPMSub=$o(^DHCCARDINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCCARDINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.q:(myPMDR="")
	.s myPMSum=$p(^DHCCARDINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.s myPMSum=myPMSum		;+$g(myRoundSum)
	.s ^TMPOPPayMode($j,mySubHospDR, myPMDR, "CIP","Sum")=+$g(^TMPOPPayMode($j,mySubHospDR,myPMDR, "CIP","Sum"))+myPMSum
	.s ^TMPOPPayMode($j,mySubHospDR, myPMDR, "CIP", "Num")=+$g(^TMPOPPayMode($j,mySubHospDR,myPMDR, "CIP", "Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPPayMode($j,mySubHospDR, myPMDR,"PM")=myPMDesc
	
	q 0
}

ClassMethod ReadOPCardParkPayMode(CIPRowID As %String = "") As %String
{
	n (CIPRowID)
	s PRTRowID=CIPRowID
	;^DHCCARDINVPRT({DHC_CardINVPRT.CIP_RowID},"P",{CPM_Sub})
	q:'$d(^DHCCARDINVPRT(PRTRowID,"P"))
	s myPMSub=0
	s mySubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	
	;把5舍6入的钱归加到第一种支付模式上
	s myRoundSum=+$p(^DHCCARDINVPRT(PRTRowID),"^",37)
	
	f  s myPMSub=$o(^DHCCARDINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCCARDINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMSum=$p(^DHCCARDINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.s myPMSum=myPMSum			;+$g(myRoundSum)
	.q:(myPMDR="")
	.s ^TMPOPParkPayMode($j, mySubHospDR, myPMDR, "CIP")=+$g(^TMPOPParkPayMode($j, mySubHospDR, myPMDR,"CIP"))+myPMSum
	.s ^TMPOPParkPayMode($j, mySubHospDR, myPMDR, "CIP","Num")=+$g(^TMPOPParkPayMode($j, mySubHospDR, myPMDR,"CIP", "Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPParkPayMode($j, mySubHospDR, myPMDR,"PM")=myPMDesc
	.;分开 S和A
	.s myINVFlag=$p(^DHCCARDINVPRT(PRTRowID),"^", 2)
	.q:myINVFlag=""
	.s ^TMPOPParkPayMode($j, mySubHospDR, myPMDR, "CIP", myINVFlag)=+$g(^TMPOPParkPayMode($j, mySubHospDR, myPMDR,"CIP", myINVFlag))+myPMSum
	.s ^TMPOPParkPayMode($j, mySubHospDR, myPMDR, "CIP",myINVFlag, "Num")=+$g(^TMPOPParkPayMode($j, mySubHospDR, myPMDR,"CIP",myINVFlag, "Num"))+1
	.
	
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

ClassMethod Test()
{
	;d ##class(web.udhcOPHandin7).Test()
	s sUser =$list(^TMPHandin,1)
	s FootInfo=$list(^TMPHandin,2)
	s ReportsXmlData=$list(^TMPHandin,3)
	s CatXmlData=$list(^TMPHandin,4)
	;s PDXmlData=$list(^TMPHandin,5)
	;s APIXmlData=$list(^TMPHandin,6)
	;s CardXmlData=$list(^TMPHandin,7)
	d ..Handin(sUser , FootInfo, ReportsXmlData, CatXmlData)
}

ClassMethod ObjectDataToTMP()
{
}

ClassMethod Handin(sUser As %String, FootInfo As %String, ReportsXmlData As %String, CatXmlData As %String)
{
	;INVPRTPayModeXml As %String, PDXmlData As %String, APIXmlData As %String, CardXmlData As %String,
	;Sum As %String, EndDate As %String, EndTime As %String, StDate As %String, 
	;StTime As %String, Rcptno As %String, jynum As %String
	;w ##class(web.udhcOPHandin7).GetHandin("","","9937")
	;w ##class(web.udhcOPHandin7).Handin(2,"^^^^02/06/2007^16:00:58^24/07/2007^19:06:17^3136.00^2^11^  1097--1107, ^^^^^^3136.00^11^4336.00^0^0.00^0^0.00^2^-1200.00^ 1097,  1101, ^^0^0.00^^0.00^0^0.00^0.00^0^0.00^0.00^0.00^0^0.00^0.00^0.00^^^0^0.00^4336.00^-1200.00^3136.00^0.00^0.00^0^0.00^0^0.00^0.00^0.00^0.00^^0^U")
	;w ##class(web.udhcOPHandin7).Handin("5","20/10/2005^15:13:48^24/10/2005^23:08:44^55.00^5^  00000337--00000341^55.00^4^81.00^1^42.00^1^-47.00^1^-21.00^ 00000337^ 00000315")
	;w ##class(web.udhcOPHandin7).Handin("23294","^^^^02/06/2006^09:15:23^06/06/2006^22:53:58^503.41^23294^14^  00004531--00004532, ^^^^^^475.00^12^175.00^0^0.00^0^0.00^0^0.00^^^0^0.00^^0.00^2^328.41^0.00^0^0.00^0.00^0.00^0^0.00^0.00^0.00^^^0^0.00^475.00^0.00^475.00^0.00^0.00^2^300.00^0^0.00^300.00^0.00^0.00")
	;INVPRTPayModeXml, PDXmlData, APIXmlData, CardXmlData
	n (sUser, FootInfo, ReportsXmlData, INVPRTPayModeXml, PDXmlData, APIXmlData, CardXmlData, CatXmlData)
	s ^TMPHandin=$lb(sUser, FootInfo, ReportsXmlData, CatXmlData)
	s ^TMPHandin1=CatXmlData
	;s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	s myReportsObj=##class(web.DHCEntity.OPC.Report).%New()
	
	d myReportsObj.XMLDeserialize(.myReportsObj, ReportsXmlData)
	
	;CardPay
	
	;s StDate=$zdh($p(FootInfo,"^",5),4)
	s myReportsObj.HISStartDate=$zdh(myReportsObj.HISStartDate,3)
	s StDate=myReportsObj.HISStartDate
	;s StTime=$zth($p(FootInfo,"^",6),1)
	s myReportsObj.HISStartTime =$zth(myReportsObj.HISStartTime,1)
	s StTime=myReportsObj.HISStartTime
	
	;s EndDate=$zdh($p(FootInfo,"^",7),4)
	s myReportsObj.HISEndDate=$zdh(myReportsObj.HISEndDate,3)
	s EndDate=myReportsObj.HISEndDate
	;s EndTime=$zth($p(FootInfo,"^",8),1)
	s myReportsObj.HISEndTime=$zth(myReportsObj.HISEndTime,1)
	s EndTime=myReportsObj.HISEndTime
	
	s hdate=+$h
	s htime=$p($h,",",2)
	
	d ..KillTmp()
	
	s myrtn=..BuildOPINVItem(sUser,StDate, StTime, EndDate, EndTime)
	
	;把数据转换 成TMP
	
	q:(myrtn) myrtn_"^"
	
	d ..tb()
	
	k PLIST
	
	s myDHCReports=##class(User.DHCINVPRTReports).%New()
	s myDHCReports.HISAmount=myReportsObj.HISAmount
	
	s myDHCReports.HISDate=hdate
	s myDHCReports.HISEndDate=myReportsObj.HISEndDate
	s myDHCReports.HISEndTime=myReportsObj.HISEndTime
	s myDHCReports.HISParkINVInfo=myReportsObj.HISParkINVInfo
	s myDHCReports.HISParkNum=myReportsObj.HISParkNum
	s myDHCReports.HISParkSum=myReportsObj.HISParkSum
	s myDHCReports.HISPatSum=myReportsObj.HISPatSum
	s myDHCReports.HISRcptNO=myReportsObj.HISRcptNO
	s myDHCReports.HISRefundINVInfo=myReportsObj.HISRefundINVInfo
	s myDHCReports.HISRefundNum=myReportsObj.HISRefundNum
	s myDHCReports.HISRefundSum=myReportsObj.HISRefundSum
	s myDHCReports.HISStartDate=myReportsObj.HISStartDate
	s myDHCReports.HISStartTime=myReportsObj.HISStartTime
	s myDHCReports.HISTime=htime
	s myDHCReports.HISUser=sUser
	s myDHCReports.HisNum=myReportsObj.HisNum
	s myDHCReports.HISReportType=myReportsObj.HISReportType
	;^CT("HOSP",{HOSP_RowId})
	s myHospDR=$o(^CT("HOSP", 0))
	s myDHCReports.HISHospitalDR=myHospDR
	
	s sc=myDHCReports.%Save()
	
	s HISParref=myDHCReports.%Id()
	b		;Save Reports
	;结算主表
	
	b ;;;;;
	
	
	i myrtn=0 d
	.s myCatSubObj=##class(web.DHCEntity.OPC.CatSubs).%New()
	.d myCatSubObj.XMLDeserialize(.myCatSubObj, CatXmlData)
	.;门诊类别大类和子类表
	.;保存会计大类和子类
	.s myCount=myCatSubObj.ACCat.Count()
	.f myIdx=1:1:myCount q:(+myrtn)  d
	..s myACCatSubOjb=myCatSubObj.ACCat.GetAt(myIdx)
	..k PLIST
	..s PLIST(0)=HISParref
	..s PLIST(3)=myACCatSubOjb.CatDR
	..s PLIST(4)=$fn(myACCatSubOjb.Acount,"",2)
	..s PLIST(5)=myACCatSubOjb.SubCatDR
	..s PLIST(6)=myACCatSubOjb.SubAvailHospitlDR
	..s PLIST(7)=myACCatSubOjb.TarSubjectType
	..b
	..s myrtn=##class(web.UDHCINVPRTReportsSub).Insert()
	..
	
	b	;;;;;;InsertSub
	;更新票据流水表   可能要更改
	i myrtn=0 d
	.s myrtn=##class(web.UDHCINVPRT).UpdateFootForUserNoCardNew(sUser, StDate, StTime, EndDate, EndTime, HISParref, hdate, htime)
	
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
	
	b		;;UpdateCardPay
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
	
	b	;;子表	
	;写日报的支付模式表，增加了预交金的支付与退，
	;写入支付模式子表
	;^TMPOPParkPayMode($j,myPMDR,"PM")
	s myPMDR=0
	f  s myPMDR=$o(^TMPOPParkPayMode($j,myPMDR))  q:(myPMDR="")  d
	.;s myParkSum=+$g(^TMPOPParkPayMode($j,myPMDR))
	.;s ^TMPOPPayMode($j,myPMDR,"PKSum")=+$g(^TMPOPPayMode($j,myPMDR,"PKSum"))+myParkSum
	.;s myParkNum=+$g(^TMPOPParkPayMode($j,myPMDR, "Num"))
	.;s ^TMPOPPayMode($j,myPMDR,"PKNum")=+$g(^TMPOPPayMode($j,myPMDR,"PKNum"))+myParkNum
	
	s myAvailHospitlDR=0
	i myrtn=0 d
	.f  s myAvailHospitlDR=$o(^TMPOPPayMode($j,myAvailHospitlDR)) q:((myAvailHospitlDR="")||(myrtn'=0))  d
	..b	;;
	..s myPMDR=0
	..f  s myPMDR=$o(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR)) q:((myPMDR="")||(myrtn'=0))  d
	...s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	...q:(myPMCode="CPP")
	...s myPMSum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR))
	...s myPMNum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"Num"))
	...s myParkSum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR, "PKSum"))
	...s myParkNum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR, "PKNum"))
	...s myPRDGNum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"PRD","GNum"))
	...s myPRDGSum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"PRD","GSum"))
	...s myPRDRefNum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"PRD","RefNum"))
	...s myPRDRefSum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"PRD","RefSum"))
	...s myStrikRefSum=+$g(^TMPOPINVSTRIK($j, myAvailHospitlDR, myPMDR,"Strik","RefSum"))
	...s myStrikRefNum=+$g(^TMPOPINVSTRIK($j, myAvailHospitlDR, myPMDR,"Strik","RefNum"))
	...s myStrikGetSum=+$g(^TMPOPINVSTRIK($j, myAvailHospitlDR, myPMDR,"Strik","GetSum"))
	...s myStrikGetNum=+$g(^TMPOPINVSTRIK($j, myAvailHospitlDR, myPMDR,"Strik","GetNum"))
	...s myFBackSum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"PRD","FBackSum"))
	...s myFBackNum=+$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR,"PRD","FBackNum"))
	...;卡注册发票
	...s myLogINVSum=$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR, "CIP","Sum"))
	...s myLogINVNum=$g(^TMPOPPayMode($j, myAvailHospitlDR, myPMDR, "CIP", "Num"))
	...s myLStrikINVSum=$g(^TMPOPParkPayMode($j, myAvailHospitlDR, myPMDR, "CIP", "S"))
	...s myLStrikINVNum=$g(^TMPOPParkPayMode($j, myAvailHospitlDR, myPMDR, "CIP","S", "Num"))
	...s myLParkINVSum=$g(^TMPOPParkPayMode($j, myAvailHospitlDR, myPMDR, "CIP", "A"))
	...s myLParkINVNum=$g(^TMPOPParkPayMode($j, myAvailHospitlDR, myPMDR, "CIP","A", "Num"))
	...;
	...k PLIST
	...s PLIST(0)=HISParref
	...s PLIST(3)=myPMSum
	...s PLIST(4)=myPMDR
	...s PLIST(5)=myParkNum				;HisPay_Refund
	...s PLIST(6)=myParkSum				;HisPay_Refundsum
	...s PLIST(7)=myPMNum
	...s PLIST(8)=myPRDGNum
	...s PLIST(9)=$fn(myPRDGSum,"",2)
	...s PLIST(10)=myPRDRefNum
	...s PLIST(11)=$fn(myPRDRefSum,"",2)
	...s PLIST(12)=$fn(myStrikRefSum,"",2)
	...s PLIST(13)=myStrikRefNum
	...s PLIST(14)=$fn(myStrikGetSum,"",2)
	...s PLIST(15)=myStrikGetNum
	...s PLIST(16)=myFBackSum
	...s PLIST(17)=myFBackNum
	...;专门为 注册用的字段
	...s PLIST(18)=myLParkINVSum			;HisPay_LParkINVSum
	...s PLIST(19)=myLParkINVNum			;HisPay_LParkINVNum 
	...s PLIST(20)=myLStrikINVSum			;HisPay_LStrikINVSum
	...s PLIST(21)=myLStrikINVNum			;HisPay_LStrikINVNum
	...s PLIST(22)=myLogINVSum			;HisPay_LogINVSum
	...s PLIST(23)=myLogINVNum			;HisPay_LogINVNum
	...s PLIST(24)=myAvailHospitlDR					;AvailHospitlDR
	...s myrtn=##class(web.UDHCINVPRTReportsPaymode).Insert()
	
	;更新 发卡发票表记录
	i myrtn=0 d
	.;&sql()
	.&sql(select min(CIP_RowID) into :myCIPRowID from DHC_CardINVPRT 
		where (CIP_PUser_DR=:sUser 
			and (CIP_INVReports_DR is null !(CIP_INVReports_DR=""))))
	.q:(myCIPRowID="")
	.&sql(update DHC_CardINVPRT
		set CIP_INVReports_DR=:HISParref
		where CIP_PUser_DR=:sUser and (CIP_INVReports_DR is null or CIP_INVReports_DR="") 
		and ((CIP_Date>=:StDate and CIP_Date<:EndDate) or 
			(CIP_Date=:EndDate and CIP_Time<=:EndTime)))
	.
	.i SQLCODE=100 d
	..s myrtn=0
	.e  d
	..s myrtn=SQLCODE
	.
	
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
	;w ##class(web.udhcOPHandin7).ReadUFCat()
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
	;w ##class(web.udhcOPHandin7).ReadUFSubCat()
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

/// 获取一张发票的账单RowID串
ClassMethod GetINVBillStr(INVRowID As %String) As %String
{
	n (INVRowID)
	s mystr=""
	
	q:(INVRowID="") ""
	
	;^DHCBCI(0,"INV",{DHCBCI_INVDR},{DHCBCI_Rowid})
	s myBIRowID=0
	f  s myBIRowID=$o(^DHCBCI(0,"INV", INVRowID,myBIRowID)) q:(myBIRowID="")  d
	.s myBPRowID=$p(^DHCBCI(myBIRowID),"^", 2)
	.s mystr=mystr_"^"_myBPRowID
	
	q mystr
}

ClassMethod SetINVRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String) As %String
{
	;w ##class(web.udhcOPHandin7).SetINVRepInfo(60315,39695,60410,65865,10033)
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
	
	;对于发卡环节打印的发票
	f myCIdate=stdate:1:EndDate  d
	.q:$d(^DHCCARDINVPRTi(0,"Date",myCIdate))=0
	.;^DHCCARDINVPRTi(0,"Date",{CIP_Date},{CIP_RowID})
	.s myCIPRowID=0
	.f  s myCIPRowID=$o(^DHCCARDINVPRTi(0,"Date",myCIdate, myCIPRowID)) q:(myCIPRowID="")  d
	..;^DHCCARDINVPRT({CIP_RowID})
	..s myCIUser=$p(^DHCCARDINVPRT(myCIPRowID),"^",6)		;CIP_PUser_DR
	..q:(hUser'=myCIUser)
	..s myCITime=$p(^DHCCARDINVPRT(myCIPRowID),"^",5)		;CIP_Time
	..q:((stdate=myCIdate)&&(myCITime<sttime))
	..q:(EndDate = myCIdate)&&(myCITime>EndTime)
	..s myINVRepDR=$p(^DHCCARDINVPRT(myCIPRowID),"^",9)			;CIP_INVReports_DR
	..q:(myINVRepDR'="")
	..s myCINo=$p(^DHCCARDINVPRT(myCIPRowID),"^",7)			;CIP_INVNo
	..i myCINo'="" d
	...s ^TMPMYINVINFO($j,"INVCI", myCIPRowID)=myCINo
	...s ^TMPMYINVINFOi($j,"INV",myCINo)=myCIPRowID_"^CI"
	
	;合计发票
	q:('$d(^TMPMYINVINFOi($j,"INV"))) ""
	
	s myINVInfo=##class(web.udhcOPHandin7).GetINVNOinfo()
	
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

Query SelectAvailbHospital() As %SQLQuery(CONTAINID = 1)
{
	Select top 1 %ID,SAH_Desc,SAH_Code from DHC_SuAvailbHospital order by %ID
}

ClassMethod GetReportDataByRowIDPrint(ReportRowID As %String) As %String
{
	;规则  RowNum^ColNum^Value
	n (ReportRowID)
	s myData=""
	q:(ReportRowID="") ""
	
	s myRepObj=##class(User.DHCINVPRTReports).%OpenId(ReportRowID)
	s myUserName=$p(^SSU("SSUSR",myRepObj.HISUser),"^",2)
	s myRowID=4
	s myRepData=myRowID_"^3^"_ReportRowID
	s myRepData=myRepData_$c(1)_myRowID_"^6^"_myUserName
	
	s myTJDate= $zd(myRepObj.HISStartDate, 3)
	s myTJDate= myTJDate_" "_$zt(myRepObj.HISStartTime)
	s myTJDate= myTJDate_" -- "_$zd(myRepObj.HISEndDate, 3)
	s myTJDate= myTJDate_" "_$zt(myRepObj.HISEndTime)
	s myRowID=7
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myTJDate
	
	s myRowID=8
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HisNum
	
	s myRowID=9
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISRcptNO
	
	s myPMObj=##class(web.DHCEntity.OPC.SubHospPayModes).%New()
	d myPMObj.SetPayModeByRepRowID(ReportRowID)
	s myZSRTTSum=0
	s myLKYFTTSum=0
	s myYYTTSum=0
	
	s myYYSubHospDR=##class(web.DHCBL.OPINVREP.SubHospAvailSeg).GetDefaultAvailDR()
	s myCount=myPMObj.TotalPayMode.Count()
	f myIdx=1:1:myCount {
		s myYYObj=myPMObj.TotalPayMode.GetAt(myIdx)
		s myRowID=12+myIdx
		s myCol=3
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myYYObj.CashSum,"",2)
		s myRowID=12+myIdx
		s myCol=4
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myYYObj.ChequeSum,"",2)
		s myRowID=12+myIdx
		s myCol=5
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myYYObj.BankCardSum,"",2)
		s myRowID=12+myIdx
		s myCol=6
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myYYObj.YBCardSum,"",2)
		s myRowID=12+myIdx
		s myCol=7
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^0.00"
		s myRowID=12+myIdx
		s myCol=8
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^0.00"
		s myRowID=12+myIdx
		s myCol=9
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^0.00"
		s myRowID=12+myIdx
		s myCol=10
		s myTSum=+myYYObj.CashSum+ myYYObj.ChequeSum + myYYObj.BankCardSum + myYYObj.YBCardSum
		s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myTSum,"",2)
		i myYYSubHospDR=myYYObj.SubAvailHospitlDR d
		.s myYYTTSum=$fn(myTSum,"",2)
		e  d
		.s myLKYFTTSum=$fn(myTSum,"",2)
		s myZSRTTSum=+myZSRTTSum+myTSum
	}
	s myRowID=5
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myYYTTSum,"",2)
	
	s myRowID=5
	s myCol=6
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myLKYFTTSum,"",2)

	s myRowID=5
	s myCol=9
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_$fn(myZSRTTSum,"",2)
	
	;废票张数
	s myRowID=18
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISParkNum
	;废票金额
	s myRowID=18
	s myCol=7
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISParkSum

	;废票票
	s myRowID=19
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISParkINVInfo
	
	;红冲数量
	s myRowID=20
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISRefundNum

	;红冲金额
	s myRowID=20
	s myCol=7
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISRefundSum
	
	;
	s myRowID=21
	s myCol=3
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myRepObj.HISRefundINVInfo
	
	;打印日期
	s myRowID=30
	s myCol=3
	s myPRTDate=$zd(+$h,3)
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myPRTDate
	
	s myRowID=30
	s myCol=8
	s myRepData=myRepData_$c(1)_myRowID_"^"_myCol_"^"_myUserName
	
	d myPMObj.%Close()
	
	s myData=myRepData
	
	q myData
}

}
