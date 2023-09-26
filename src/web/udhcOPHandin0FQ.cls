Import SQLUser

Class web.udhcOPHandin0FQ Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 865;

/// /此类是积水潭医院的复制版本
/// /如果Handin0有变化立即替换此类就可以了，但是有修改
ClassMethod BuildOPHZInfo(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, GroupDR As %String) As %String
{
	;w ##class(web.udhcOPHandin0FQ).BuildOPINVItem(23298,60589,62365,60589,$p($h,",",2),"")
	;生成流水的账目信息
	
	n (hUser, stdate, sttime, EndDate, EndTime, GroupDR)
	
	s rtn=0
	i (stdate'="")&(sttime'="")  d
	.;s catret=..getsubcat()
	.s snum=0
	.f pdate=stdate:1:EndDate  q:(rtn'=0)  d
	..q:$d(^DHCINVPRT(0,"Date",pdate))=0
	..s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:((PRTrowid="")!(rtn'=0))  d
	...s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	...q:((PRTUser'=hUser)&(hUser'=""))
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>EndTime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...s myUGroupDR=$p(^SSU("SSUSR", PRTUser),"^",5)
	...q:((GroupDR'="")&(GroupDR'=myUGroupDR))
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
	...;计算发票打印数量
	...
	
	s footnum=0
	;对于卡预交金的金额
	;按照支付模式保存
	;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},
	;{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	
	s pddate=stdate-1
	f  s pddate=$o(^DHCACDi("AccM",0,"APDDate",pddate)) q:((pddate="")||(+pddate>+EndDate))  d
	.s accid=0
 	.f  s accid=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid)) q:accid=""  d
	..s pdsub=0
	..f  s pdsub=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid,"AccPD",pdsub)) q:pdsub=""  d
	...s myRepDR=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",10)
	...;q:(myRepDR'="")
	...s myPRDUser=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",5)		;ccPD_User_DR
	...q:((hUser'=myPRDUser)&(hUser'=""))
	...s myUGroupDR=$p(^SSU("SSUSR", myPRDUser),"^",5)
	...q:((GroupDR'="")&(GroupDR'=myUGroupDR))
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
	...;Pay||P x Refund||R  Trans||T Foot||F
	...s myPRDType=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",1)		;AccPD_Type
	...i pdamt>0  d
	....;收预交金
	....s ^TMPOPPayMode($j,myPMDR,"PRD","GNum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GNum"))+1
	....s ^TMPOPPayMode($j,myPMDR,"PRD","GSum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","GSum"))+$g(pdamt)
	...i pdamt<0 d
	....;退预交金
	....s ^TMPOPPayMode($j,myPMDR,"PRD","RefNum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefNum"))+1
	....s ^TMPOPPayMode($j,myPMDR,"PRD","RefSum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","RefSum"))+$g(pdamt)
	...s receiptsno=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",6)
	
	;Pay||P x Refund||R  Trans||T Foot||F
	;回收预交金
	;^DHCACDi("AccM",0,"FIDate",{AccFI_Date},{DHC_AccManager.AccM_RowID},"AccFI",{AccFI_Sub})
	s pddate=stdate-1
	f  s pddate=$o(^DHCACDi("AccM",0,"FIDate",pddate)) q:((pddate="")||(+pddate>+EndDate))  d
	.s myAccRowID=0
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"FIDate",pddate, myAccRowID))  q:(myAccRowID="")  d
	..s mypdsub=0
	..f  s mypdsub=$o(^DHCACDi("AccM",0,"FIDate",pddate, myAccRowID,"AccFI", mypdsub))  q:(mypdsub="")  d
	...;^DHCACD("AccM",{DHC_AccManager.AccM_RowID},"AccFI",{AccFI_Sub})
	...q:($d(^DHCACD("AccM", myAccRowID,"AccFI",mypdsub))=10)
	...s myFUser=$p(^DHCACD("AccM", myAccRowID,"AccFI",mypdsub),"^",8)		;AccFI_User_DR
	...q:((hUser'=myFUser)&(hUser'=""))
	...s myPDDate=$p(^DHCACD("AccM", myAccRowID,"AccFI",mypdsub),"^",6)		;AccFI_Date
	...s myPDTime=$p(^DHCACD("AccM", myAccRowID,"AccFI",mypdsub),"^",7)		;AccFI_Time
	...q:((stdate=myPDDate)&&(myPDTime<sttime))
	...q:((EndDate=myPDDate)&&(myPDTime>=EndTime))
	...s myUGroupDR=$p(^SSU("SSUSR", myFUser),"^",5)
	...q:((GroupDR'="")&(GroupDR'=myUGroupDR))
	...s myFBackSum=$p(^DHCACD("AccM", myAccRowID,"AccFI",mypdsub),"^",3)		;AccFI_PreSum
	...s ^TMPOPPayMode($j,myPMDR,"PRD","FBackSum")=+$g(^TMPOPPayMode($j,myPMDR,"PRD","FBackSum"))+$g(myFBackSum)
	
	q rtn
}

ClassMethod ReadOPINVHZInfo(hUser As %String, stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, GroupDR As %String) As %String
{
	;单独去获取票据的信息
	;取流水帐的 发票信息
	;w ##class(web.udhcOPHandin0FQ).ReadOPINVHZInfo("",60446,0,60447,0,"")
	n (hUser, stdate, sttime, EndDate, EndTime, GroupDR)
	
	i stdate["/" d
	.s stdate=$zdh(stdate,4)
	
	i EndDate["/" d
	.s EndDate=$zdh(EndDate,4)
	
	i sttime[":" d
	.s sttime=$zth(sttime)
	
	i EndTime[":" d
	.s EndTime=$zth(EndTime)
	
	d ..KillTmp()
	
	i (+EndTime=0) d
	.s EndDate=EndDate+1
	
	;处理发票号码  打印的发票号码
	;(stdate, sttime, EndDate, EndTime, hUser, GroupDR)
	s myINVInfo=..SetINVRepInfo(stdate, sttime, EndDate, EndTime, hUser, GroupDR)
	
	s myrtn=""
	
	;b		;;GetInvInfo
	
	;获取门诊现金打印的发票数量
	s myIPRepInfo=..GetINVPRTRepInfo(stdate, sttime, EndDate, EndTime, hUser, GroupDR)
	
	s myIPRepInfo1=myIPRepInfo
	s myIPRtn=$p(myIPRepInfo1,$c(3),1)
	s myIPRepInfo=$p(myIPRepInfo1,$c(3),2)
	
	s myIPCPPRepInfo=$p(myIPRepInfo1,$c(3),3)
	s PRTCPPInfo=""
	
	;s ret=ret_"^"_cancelnum_"^"_cancelsum_"^"_refundnum_"^"_refundsum_"^"_handinsum	;5-9
	s myPRTINVNum=$p(myIPRepInfo,"^",15)		;打印的票据数量(现金)
	s myPRTAbortNum=$p(myIPRepInfo,"^",6)
	s myPRTRefNum=$p(myIPRepInfo,"^",8)
	s myPRTAbortInfo=$p(myIPRepInfo,"^",21)
	s myPRTRefInfo=$p(myIPRepInfo,"^",20)
	s myPRTSum=$p(myIPRepInfo,"^",13)		;现金收费的票据金额
	
	;处理集中打印发票的数量
	s myAPIInfoRtn=..GetAPIRepInfo(stdate, sttime, EndDate, EndTime, hUser, myIPCPPRepInfo, GroupDR)
	s myAPRtn=$p(myAPIInfoRtn,$c(3),1)
	
	s myAPIRepInfo=$p(myAPIInfoRtn,$c(3),2)
	
	s myAPIInfo=$p(myAPIRepInfo, $c(4),2)
	s myAPIAbortInfo=$p(myAPIRepInfo, $c(4),3)
	s myAPIRefInfo=$p(myAPIRepInfo, $c(4),4)
	
	;myAPIRepInfo=交钱金额$(4)发票信息$c(4)作废票据信息$(4)红冲票据信息
	
	;s myNINfo=AccNTotSum_"^"_AccNNum_"^"_AccNINVInfo_"^"_AccNCardPaySum_"^"_AccNYBPaySum_"^"_AccNRefSum_"^"_AccNCashSum
	;s myParkInfo=AccParkTotSum_"^"_AccParkNum_"^"_AccParkINVInfo_"^"_AccParkCardPaySum
	;s myParkInfo=myParkInfo_"^"_AccParkYBPaySum_"^"_AccParkRefSum_"^"_AccParkCashSum
	;s myRefInfo=AccRefTotSum_"^"_AccRefundNum_"^"_AccRefundINVInfo_"^"_AccRefCardPaySum
	;s myRefInfo=myRefInfo_"^"_AccRefYBPaySum_"^"_AccRefRefSum_"^"_AccRefCashSum
	
	s myAPIINVSum=$p(myAPIInfo,"^",1)
	s myAPIINVNum=$p(myAPIInfo,"^",2)
	s myAPIAbortNum=$p(myAPIAbortInfo,"^",2)
	s myAPIAbortInfo=$p(myAPIAbortInfo,"^",3)
	s myAPIRefNum=$p(myAPIRefInfo,"^",2)
	s myAPIRefInfo=$p(myAPIRefInfo,"^",3)
	
	;汇总信息
	s myTotINVSum=+myPRTSum+myAPIINVSum
	s myTotINVSum=$fn(myTotINVSum,"",2)
	
	s myTotINVNum=+myPRTINVNum+myAPIINVNum
	s myTotAbortNum=+myPRTAbortNum+myAPIAbortNum
	i myPRTAbortInfo="" d
	.s myTotAbortInfo=myAPIAbortInfo
	e  d
	.s myTotAbortInfo=myPRTAbortInfo_", "_myAPIAbortInfo
	
	s myTotRefNum=+myPRTRefNum+myAPIRefNum
	i myPRTRefInfo="" d
	.s myTotRefInfo=myAPIRefInfo
	e  d
	.s myTotRefInfo=myPRTRefInfo_", "_myAPIRefInfo
	
	;计算流水的票据张数和  作废(红冲)数量
	;
	;汇总信息
	;门诊信息
	;急诊信息
	s myInfoT=myTotINVNum_"^"_myINVInfo_"^"_myTotAbortNum_"^"_myTotAbortInfo_"^"_myTotRefNum_"^"_myTotRefInfo_"^"_myTotINVSum
	s myInfoPRT=myPRTINVNum_"^"_myPRTAbortNum_"^"_myPRTAbortInfo_"^"_myPRTRefNum_"^"_myPRTRefInfo
	s myInfoAPI=myAPIINVNum_"^"_myAPIAbortNum_"^"_myAPIAbortInfo_"^"_myAPIRefNum_"^"_myAPIRefInfo
	
	s myrtn=myInfoT_$c(1)_myInfoPRT_$c(1)_myInfoAPI
	
	;b	;;;;myrtn
	d ..KillTmp()
	
	q myrtn
}

ClassMethod FormatINVNO(INVNO As %String, len As %String)
{
	
	if $l(INVNO)<len d
	.s prelen=len-$l(INVNO)
	.for i=1:1:prelen s INVNO="0"_INVNO
	Q INVNO
}

ClassMethod GetAPIRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, PRTCPPInfo As %String, GroupDR As %String) As %String
{
	n (itmjs, stdate, sttime, EndDate, EndTime, hUser, PRTCPPInfo, GroupDR)
	
	;此函数用来查询卡支付打印发票的统计；
	
	;w ##class(web.udhcOPHandin1).GetAPIRepInfo("", +$h-100,0,+$h,0, "10033")
	
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
	..q:((myAPUser'=hUser)&(hUser'=""))
	..s myUGroupDR=$p(^SSU("SSUSR",myAPUser),"^",5)
	..q:((GroupDR'="")&(GroupDR'=myUGroupDR))
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..q:((APdate=stdate)&&(myAPTime<sttime))
	..q:((APdate=EndDate)&&(myAPTime>=EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..;q:(myCheckDate'="")	;已经结算的退出
	..s AccAcount=+$p(^DHCINVPRTAP(myAPRowID),"^", 1)		;API_Amount  发票费用总额API_Amount
	..s AccPatPay=+$p(^DHCINVPRTAP(myAPRowID),"^", 13)		;API_PatientShare
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
	..;红冲发票
	..i (AccPrtFlag="S")&&(AccPrtDR'="") d
	...s AccRefundPrtNO=$p(^DHCINVPRTAP(AccPrtDR),"^",6)		;红冲票据的原票据号码?
	...
	...;New   ;;;
	...s AccRefPatPaySum=AccRefPatPaySum+$g(AccPatPay)
	...s AccRefTotSum=+AccRefTotSum+$g(AccAcount)
	...s AccRefundINVInfo=AccRefundINVInfo_" "_AccRefundPrtNO_", "
	...s AccRefundNum=AccRefundNum+1
	...s AccRefundSum=AccRefundSum+$g(AccPatPay)
	...s AccRefYBPaySum=$g(YBPay)
	...s AccRefCardPaySum=+AccRefCardPaySum+$g(PatCardPay)
	...s AccRefRefSum=+AccRefRefSum+$g(myRefundPay)
	...s AccRefCashSum=+AccRefCashSum +$g(PatCashPay)
	
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

ClassMethod GetPRDRepINfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, GroupDR As %String) As %String
{
	;w ##class(web.udhcOPHandin1).GetPRDRepINfo(60315,39695,60410,65865,1)
	n (stdate, sttime, EndDate, EndTime, hUser, GroupDR)
	
	q:hUser="" 0
	;s ^TMPINfo=stdate_"^"_sttime_"^"_EndDate_"^"_EndTime_"^"_hUser
	;s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	;s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum
	
	q:'$d(^DHCACDi("AccM",0,"User",hUser)) 0_$c(3)_"0^0.00^0^0.00^0.00^0.00^0.00^0.00"
	
	s footsum=0,pdsum=0,refundsum=0,cashsum=0,chequesum=0,othersum=0
	s mypdnum=0
	s footnum=0,refundnum=0,rcptstr=""
	s myBankCardSum=0
	;b	;;;Test
	s pddate=stdate-1
	;^DHCACDi("AccM",0,"APDDate",{AccPD_PreDate},
	;{DHC_AccManager.AccM_RowID},"AccPD",{AccPD_Sub})
	
	f  s pddate=$o(^DHCACDi("AccM",0,"APDDate",pddate)) q:((pddate="")||(+pddate>+EndDate))  d
	.s accid=0
 	.f  s accid=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid)) q:accid=""  d
	..s pdsub=0
	..f  s pdsub=$o(^DHCACDi("AccM",0,"APDDate",pddate,accid,"AccPD",pdsub)) q:pdsub=""  d
	...s myRepDR=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",10)
	...s myPRDUser=$p(^DHCACD("AccM",accid,"AccPD",pdsub),"^",5)	;AccPD_User_DR
	...q:((hUser'="")&(myPRDUser'=hUser))
	...s myUGroupDR=$p(^SSU("SSUSR",myPRDUser),"^",5)
	...b		;;;;Test
	...q:((GroupDR'="")&(GroupDR'=myUGroupDR))
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
	....i myPMCode="BANK" s myBankCardSum=myBankCardSum+pdamt
	....i "^CASH^CHEQUES^BANK^"'[myPMCode s othersum=+othersum+pdamt
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
	s myBankCardSum=$fn(myBankCardSum,"",2)
	
	;s othersum=footsum-cashsum-chequesum
	;s enddate=$ZD(+$H,4),endtime=$ZT($p($H,",",2))
	;s rtn=footnum_"^"_refundnum_"^"_$j(footsum,3,2)_"^"_$j(pdsum,3,2)_"^"_$j(refundsum,3,2)_"^"_$j(cashsum,3,2)_"^"_$j(chequesum,3,2)_"^"_$j(othersum,3,2)_"^"_stdate_"^"_sttime_"^"_enddate_"^"_endtime_"^"_rcptstr
	;利用收退款笔数来决定是否能办理结算
	s rtn=footnum
	b		;;;获得预交金
	s myInfo=mypdnum_"^"_pdsum_"^"_refundnum_"^"_refundsum
	s myInfo=myInfo_"^"_cashsum_"^"_chequesum_"^"_othersum_"^"_myBankCardSum
	
	q rtn_$c(3)_myInfo
}

ClassMethod GetDate(hUser As %String, EndDate As %String)
{
	;;w ##class(web.udhcOPHandin0).GetDate("23298",+$h)
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
	
	;增加返回结束日期
	s myEndDate=+$h
	s myEndTime=+$p($h,",",2)
	
	;要求按照日期循环验证   等待
	s myCount=0
	b
	i (+stdate<+$h) d
	.s myCount=0
	.s mypdate=""
	.f mypdate=stdate:1:myEndDate  q:(+myCount'=0)  d
	..q:(+mypdate>=+$h)			;要求当前日期
	..s myCount=..CheckINVFlag(hUser, mypdate, myEndDate)
	..
	..i +myCount'=0  d
	...;如果当天存在要要结算数据, 把结束时间定为明天的0分
	...s myEndDate=mypdate+1
	...s myEndTime=0
	
	q stdate_"^"_sttime_"^"_myEndDate_"^"_myEndTime
}

ClassMethod CheckINVFlag(hUser As %String, stdate As %String, EndDate As %String) As %String
{
	n (hUser,stdate,EndDate,EndTime)
	;目的是验证当天的数据是否有没有办理结算的
	
	s myCount=0
	
	;^DHCINVPRT(0,"UserDate",{PRT_Usr},{PRT_Date},{PRT_Rowid})
	
	s pddate=stdate
	i $d(^DHCINVPRT(0,"UserDate",hUser,pddate))'=0 d
	.;验证发票表
	.s Handin=""
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"UserDate",hUser, pddate,PRTrowid),-1) q:((PRTrowid="")!(Handin="Y"))  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:PRTUser'=hUser
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..;q:(pdate=EndDate)&(PRTTime>EndTime)
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	..s myINVNo=$p(^DHCINVPRT(PRTrowid),"^",14)			;PRT_inv
	..s myPrtFlag=$p(^DHCINVPRT(PRTrowid),"^",3)		;PRT_INVPrintFlag
	..q:((myINVNo="")&(myPrtFlag="P"))
	..q:Handin="Y"
	..b		;;验证发票表
	..s myCount=+myCount+1
	
	;验证押金表，或者账户结算信息表
	i $d(^DHCACDi("AccM",0,"User",hUser))'=0 d
	.s myAccRowID=""
	.f  s myAccRowID=$o(^DHCACDi("AccM",0,"User",hUser,pddate, myAccRowID)) q:(myAccRowID="")  d
	..s myAccSub=0
	..f  s myAccSub=$o(^DHCACDi("AccM",0,"User",hUser,pddate, myAccRowID,"AccPD", myAccSub)) q:(myAccSub="")  d
	...q:($d(^DHCACD("AccM",myAccRowID,"AccPD",myAccSub))=10)
	...s myPLIST=^DHCACD("AccM",myAccRowID,"AccPD",myAccSub)
	...s myRepDR=$p(myPLIST,"^",10)
	...q:(myRepDR'="")
	...b		;押金表
	...s myCount=+myCount+1
	..
	
	;验证集中打印发票表
	;下面是：DHC_AccPayINV表的发票号码
	
	i $d(^DHCINVPRTAPi(0,"Date",pddate))'=0 d
	.s myAPRowID=""
	.f  s myAPRowID=$o(^DHCINVPRTAPi(0, "Date", pddate, myAPRowID))  q:(myAPRowID="")  d
	..s myAPUser=$p(^DHCINVPRTAP(myAPRowID),"^", 5)
	..q:(myAPUser'=hUser)
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..;q:((APdate=stdate)&&(myAPTime<sttime))
	..;q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..q:(myCheckDate'="")	;已经结算的退出
	..b		;集中打印
	..s myCount=+myCount+1
	
	q myCount
}

ClassMethod GetINVPRTRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, GroupDR As %String) As %String
{
	n (stdate,sttime,EndDate,EndTime, hUser, GroupDR)
	
	;w ##class(web.udhcOPHandin1).GetINVPRTRepInfo(60315,39695,60410,65865,10033)
	
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
	
	;以下的退费代表总金额,不能代表支付模式
	s cancelnum=0,cancelsum=0   ;作废张数?作废金额
	s refundnum=0,refundsum=0   ;红冲张数?红冲金额
	s sksum=0,tksum=0           ;收款金额?退款金额
	s jybs=0,INVNOinfo=""
	
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
	...q:((PRTUser'=hUser)&(hUser'=""))
	...s myUGroupDR=$p(^SSU("SSUSR",PRTUser),"^",5)
	...q:((GroupDR'="")&(GroupDR'=myUGroupDR))
	...s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	...q:(pdate=EndDate)&(PRTTime>=EndTime)
	...q:(pdate=stdate)&(PRTTime<sttime)
	...s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
	...s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	...s PrtPatPay=$p(^DHCINVPRT(PRTrowid),"^",16)
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
	...q:((myOldPMCode="CPP")&&(Flag'="N")&&(myOldINVNo="")&&(PrtNO=""))
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
	....s jybs=jybs+1
	...;本收款员作废的单据?	下面的数据都依存于原帐单?
	...i ((Flag="A")&&(PrtinvDr'=""))&&(myPMCode'="CPP")  d
	....;重新写的作废单据
	....s AbPatPaySum=AbPatPaySum+$g(PrtPatPay)
	....s AbTotSum=AbTotSum+$g(PRTAcount)
	....s ParkPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;作废票据的原票据号码?
	....s ParkINVInfo=ParkINVInfo_" "_ParkPrtNO_", "
	....s cancelnum=cancelnum+1
	....s cancelsum=cancelsum+PRTAcount
	....s tksum=tksum+PRTAcount
	....;s jybs=jybs+1
	...;本收款员红冲得单据
	...i (((Flag="S")&&(PrtinvDr'=""))&&((myPMCode'="CPP")))  d
	....;重新写的红冲单据
	....s RefPatPaySum=RefPatPaySum+$g(PrtPatPay)
	....s RefTotSum=RefTotSum+$g(PRTAcount)
	....s RefundPrtNO=$p(^DHCINVPRT(PrtinvDr),"^",14)		;红冲票据的原票据号码?
	....s RefundINVInfo=RefundINVInfo_" "_RefundPrtNO_", "
	....s refundnum=refundnum+1
	....s refundsum=refundsum+$ZABS(PRTAcount)
	....s tksum=tksum+$ZABS(PRTAcount)
	...;取支付模式 对于收费的发票
	...i myPMCode="CPP" d
	....;b	;;	CPP   处理CPP支付
	...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N"))) d
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
	s myBankCardNum=0
	s myBankCardSum=0
	
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
	.;银行卡支付
	.i myPMCode="BANK" d
	..s myBankCardSum=myBankCardSum+myAmt
	..s myBankCardNum=+myBankCardNum+$g(^TMPOPPayMode($j,myPMDR,"Num"))
	.i ((("^CASH^^CHEQUES^CPP^BANK^")'[("^"_myPMCode_"^"))&&(myPMCode'="CPP")) d
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
	
	;读取折扣或优惠
	s myInsTypeDR=0
	s mySARSNum=0
	s mySARSSum=0
	s mySARSRefNum=0
	s mySARSRefSum=0
	
	f  s myInsTypeDR=$o(^TMPOPINVTALLY($j,myInsTypeDR)) q:(myInsTypeDR="")  d
	.;患者费别
	.s myInsCode=$p(^PAC("ADMREA",myInsTypeDR),"^",1)
	.i ((myInsCode="医保SARS")!(myInsCode="SARS非医保")) d
	..s mySARSNum=+mySARSNum+$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetNum"))
	..s mySARSSum=+mySARSSum+$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","GetSum"))
	..s mySARSRefNum=+mySARSRefNum+$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefNum"))
	..s mySARSRefSum=+mySARSRefSum+$g(^TMPOPINVTALLY($j,myInsTypeDR,"TALL","RefSum"))
	
	s mySARSSum=$fn(mySARSSum,"",2)
	s mySARSRefSum=$fn(mySARSRefSum,"",2)
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
	s myOthPayInfo=myOthPayInfo_"^"_myBankCardNum_"^"_$fn(myBankCardSum,"",2)		;25--26
	s myRefInfo=Refhandcash_"^"_Refhandcheck_"^"_myRefCPPSum_"^"_myRefBankCardSum_"^"_myRefOtherSum		;27--31
	
	s myOthPayInfo=myOthPayInfo_"^"_myRefInfo
	
	;SARS  记帐信息
	s myTallInfo=mySARSNum_"^"_mySARSSum_"^"_mySARSRefNum_"^"_mySARSRefSum		;32--35
	s myOthPayInfo=myOthPayInfo_"^"_myTallInfo
	
	;卡支付的信息,退费信息，
	s myCPPInfo=myAPNum_"^"_myAPSum_"^"_myAPRefNum_"^"_myAPRefSum_"^"_myAPParkNum_"^"_myAPParkSum
	s myCPPInfo=myCPPInfo_"^"_myAPRefPRTInfo_"^"_myAPParkPRTInfo
	
	
	s ret=ret_"^"_myOthPayInfo_$c(3)_myCPPInfo
	;b		;PRTINV
	;验证是否能结算?
	i ((+cashnum'=0)||(+checknum'=0)||(+cancelnum'=0)||(+refundnum'=0)||(+myBankCardNum'=0)) d
	.s rtn=0
	e  d
	.s rtn=1
	
	;b	;;;
	
	quit rtn_$c(3)_ret
}

ClassMethod GetAccINVNOinfo() As %String
{
	;w ##class(web.udhcOPHandin1).GetINVNOinfo()
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
	;w ##class(web.udhcOPHandin1).GetINVNOinfo()
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
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPParkPayMode($j,myPMDR)=+$g(^TMPOPParkPayMode($j,myPMDR))+myPMSum
	.s ^TMPOPParkPayMode($j,myPMDR,"Num")=+$g(^TMPOPParkPayMode($j,myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPParkPayMode($j,myPMDR,"PM")=myPMDesc
	.i myOldINVFlg="S" d
	..s ^TMPOPINVSTRIK($j,myPMDR,"Strik","RefSum")=+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","RefSum"))+myPMSum
	..s ^TMPOPINVSTRIK($j,myPMDR,"Strik","RefNum")=+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","RefNum"))+1
	
	q 0
}

ClassMethod ReadOPPayMode(PRTRowID As %String = "") As %String
{
	n (PRTRowID)
	
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
	
	f  s myPMSub=$o(^DHCINVPRT(PRTRowID,"P",myPMSub))  q:(myPMSub="")  d
	.s myPMDR=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",1)		;IPM_PayMode_DR
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s myPMSum=$p(^DHCINVPRT(PRTRowID,"P",myPMSub),"^",3)		;IPM_Amt
	.q:(myPMDR="")
	.s ^TMPOPPayMode($j,myPMDR)=+$g(^TMPOPPayMode($j,myPMDR))+myPMSum
	.s ^TMPOPPayMode($j,myPMDR,"Num")=+$g(^TMPOPPayMode($j,myPMDR,"Num"))+1
	.s myPMDesc=$p(^CT("CTPM",myPMDR),"^",2)
	.s myPMCode=$p(^CT("CTPM",myPMDR),"^",1)
	.s ^TMPOPPayMode($j,myPMDR,"PM")=myPMDesc
	.i myOldINVFlg="S" d
	..s ^TMPOPINVSTRIK($j,myPMDR,"Strik","GetSum")=+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","GetSum"))+myPMSum
	..s ^TMPOPINVSTRIK($j,myPMDR,"Strik","GetNum")=+$g(^TMPOPINVSTRIK($j,myPMDR,"Strik","GetNum"))+1
	.;
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
	.q:(+myPreDate>+EndDate)
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
	k ^TMPOPINVTALLY($j)
	k ^TMPOPINVSTRIK($j)
}

ClassMethod ReadUFCat(RepID As %String = "") As %String
{
	;读取门诊费用大类   RepID As %String = ""
	;w ##class(web.udhcOPHandin1).ReadUFCat()
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
	;w ##class(web.udhcOPHandin1).ReadUFSubCat()
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

ClassMethod ReadOPINVHZInfoByHISRowID(HISRowID As %String) As %String
{
	;w ##class(web.udhcOPHandin0FQ).ReadOPINVHZInfoByHISRowID(8)
	n (HISRowID)
	
	q:(HISRowID="") ""
	
	q:($d(^DHCOPInsFoot(HISRowID))=10)
	;^DHCOPInsFoot({HIS_Rowid})
	s myINVInfo=$p(^DHCOPInsFoot(HISRowID),"^",10)		;HIS_RcptNO
	s myTotINVNum=$p(^DHCOPInsFoot(HISRowID),"^",9)		;His_Num
	s myPRTRefNum=$p(^DHCOPInsFoot(HISRowID),"^",21)		;HIS_RefundNum
	s myPRTAbortNum=$p(^DHCOPInsFoot(HISRowID),"^",23)		;HIS_ParkNum
	
	s myPRTAbortInfo=$p(^DHCOPInsFoot(HISRowID),"^",25)		;HIS_ParkINVInfo
	s myPRTRefInfo=$p(^DHCOPInsFoot(HISRowID),"^",26)		;HIS_RefundINVInfo
	
	s myAPIINVNum=$p(^DHCOPInsFoot(HISRowID),"^",31)		;
	s myAPIAbortNum=$p(^DHCOPInsFoot(HISRowID),"^",38)		;HIS_CardParkNum
	s myAPIAbortInfo=$p(^DHCOPInsFoot(HISRowID),"^",42)		;
	s myAPIRefNum=$p(^DHCOPInsFoot(HISRowID),"^",34)		;HIS_CardRefNum
	s myAPIRefInfo=$p(^DHCOPInsFoot(HISRowID),"^",43)		;
	
	s myPRTINVNum=+myTotINVNum-myAPIINVNum
	
	s myTotAbortNum=+myPRTAbortNum+myAPIAbortNum
	s myTotRefNum=+myPRTRefNum+myAPIRefNum
	s myTotAbortInfo=myPRTAbortInfo_", "_myAPIAbortInfo
	s myTotRefInfo=myPRTRefInfo_", "_myAPIRefInfo
	
	s myBegDate=$p(^DHCOPInsFoot(HISRowID),"^",5)		;
	s myBegTime=$p(^DHCOPInsFoot(HISRowID),"^",6)		;
	s myEndDate=$p(^DHCOPInsFoot(HISRowID),"^",3)		;
	s myEndTime=$p(^DHCOPInsFoot(HISRowID),"^",4)		;
	s myBegDate=$zd(myBegDate,3)
	s myBegTime=$zt(myBegTime)
	s myEndDate=$zd(myEndDate,3)
	s myEndTime=$zt(myEndTime)
	
	s myUserRowID=$p(^DHCOPInsFoot(HISRowID),"^",8)
	s:(myUserRowID'="") myUserName=$p(^SSU("SSUSR",myUserRowID),"^",2)
	
	s myInfoT=myTotINVNum_"^"_myINVInfo_"^"_myTotAbortNum_"^"_myTotAbortInfo_"^"_myTotRefNum_"^"_myTotRefInfo
	s myInfoT=myInfoT_"^"_myBegDate_"^"_myBegTime_"^"_myEndDate_"^"_myEndTime_"^"_myUserName
	
	s myInfoPRT=myPRTINVNum_"^"_myPRTAbortNum_"^"_myPRTAbortInfo_"^"_myPRTRefNum_"^"_myPRTRefInfo
	s myInfoAPI=myAPIINVNum_"^"_myAPIAbortNum_"^"_myAPIAbortInfo_"^"_myAPIRefNum_"^"_myAPIRefInfo
	
	s myrtn=myInfoT_$c(1)_myInfoPRT_$c(1)_myInfoAPI
	
	q myrtn
}

ClassMethod ReadOPINVRepForPrint(JSName As %String, HISRowID As %String, QueryMode As %String, ExpStr As %String) As %String
{
	;在日报中新增加的打印方法，可以使用在结算日报和日报查询中中
	n (HISRowID, QueryMode, ExpStr)
	s myrtn=""
	
	q:(HISRowID="") ""
	;Get RS
	Set rset = ##class(%ResultSet).%New("web.udhcOPFinBalance:ReadFinCOLSubRep")
	Set columns = rset.GetColumnCount()
	// Execute the query
	s myStDate=""
	s myEndDate=""
	s myGroupDR=""
	s myUserDR=""
	s myQueryMode="HISRep"	;单独针对报表的  标志
	
	Set rs = rset.Execute(myStDate,myEndDate, myGroupDR, myUserDR, myQueryMode, HISRowID)
	s myIdx=0
	
	While (rset.Next()) {
	 	s myRowVal=""
		;No:%String,FinRefSum:%String,FinItem:%String,FinGetSum:%String
		
		s myFinRefSum=+$g(rset.Data("FinRefSum"))
		
		s myFinGetSum=+rset.Data("FinGetSum")
		s myval=myIdx_"^"_myFinRefSum_"^"_myFinGetSum
		s rtnval=JSFunName_"('"_$ZCVT($g(myval),"O","JS")_"');"
		&javascript<#(rtnval)#>
		s myIdx=myIdx+1
	}

	d rset.Close()
	
	;Get Inovice
	
	
	q myrtn
}

ClassMethod SetINVRepInfo(stdate As %String, sttime As %String, EndDate As %String, EndTime As %String, hUser As %String, GroupDR As %String) As %String
{
	;w ##class(web.udhcOPHandin1).SetINVRepInfo(60315,39695,60410,65865,10033)
	n (hUser, stdate,sttime,EndDate,EndTime, GroupDR)
	;生成临时的Global
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	
	;生成一个票据号码的Global
	f pdate=stdate:1:EndDate  d
	.q:($d(^DHCINVPRT(0,"Date",pdate))=0)
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",pdate,PRTrowid)) q:PRTrowid=""  d
	..s PRTUser=$p(^DHCINVPRT(PRTrowid),"^",21)
	..q:((PRTUser'=hUser)&(hUser'=""))
	..s PRTTime=$p(^DHCINVPRT(PRTrowid),"^",20)
	..q:(pdate=EndDate)&(PRTTime>=EndTime)
	..q:(pdate=stdate)&(PRTTime<sttime)
	..s myUGroupDR=$p(^SSU("SSUSR",PRTUser),"^",5)			;SSUSR_Group
	..q:((GroupDR'="")&(GroupDR'=myUGroupDR))
	..s Handin=$p(^DHCINVPRT(PRTrowid),"^",10)
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
	..q:((myAPUser'=hUser)&(hUser'=""))
	..s myAPTime=$p(^DHCINVPRTAP(myAPRowID),"^", 4)
	..q:((APdate=stdate)&&(myAPTime<sttime))
	..q:((APdate=EndDate)&&(myAPTime>EndTime))
	..s myCheckDate=$p(^DHCINVPRTAP(myAPRowID),"^", 7)
	..
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
	
	;##class(web.udhcOPHandin1)
	s myINVInfo=..GetINVNOinfo()
	
	k ^TMPMYINVINFO($j)
	k ^TMPMYINVINFOi($j)
	
	q myINVInfo
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
