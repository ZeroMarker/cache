Import SQLUser

/// Lid
/// 2010-07-05 
/// 多种支付方式业务处理
Class web.DHCOPBillManyPaymentLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 不能使用多种支付结算的支付方式串
Parameter LimitPayMCodeStr [ Final ] = "QF^CPP^ECPP";

/// Lid
/// 2010-07-05
/// 根据发票号获取病人费用信息
/// input:发票Rowid串,以"^"分割
/// out:总金额^自付金额^折扣金额^记账金额^分币误差^医保金额
/// w ##class(web.DHCOPBillManyPaymentLogic).GetPatShareAmtByPrtRowid("236163^236161")
ClassMethod GetPatFeeInfoByPrtRowid(prtRowidStr)
{
	n (prtRowidStr)
	q:+prtRowidStr=0 "^^^^^^^"
	s (totalAmt,shareAmt,discAmt,payorAmt,ybAmt,roundErrAmt)=0
    f i=1:1:$l(prtRowidStr,"^") d
    .s prtRowid=$p(prtRowidStr,"^",i)
    .s totalAmt=totalAmt+(+$p(^DHCINVPRT(prtRowid),"^",1)) ;总金额
    .s shareAmt=shareAmt+(+$p(^DHCINVPRT(prtRowid),"^",16)) ;自付金额
    .s discAmt=discAmt+(+$p(^DHCINVPRT(prtRowid),"^",7)) ;折扣金额
    .s payorAmt=payorAmt+(+$p(^DHCINVPRT(prtRowid),"^",18)) ;记账金额
    .s ybAmt=ybAmt+(+$p(^DHCINVPRT(prtRowid),"^",31)) ;医保支付金额
    .s roundErrAmt=roundErrAmt+(+$p(^DHCINVPRT(prtRowid),"^",37)) ;分币误差金额
    
    s rtn=totalAmt_"^"_(shareAmt-ybAmt)_"^"_discAmt_"^"_payorAmt_"^"_roundErrAmt_"^"_ybAmt
    q rtn
}

/// Lid
/// 2010-07-06
/// 根据收费员录入金额，为每张发票拆分金额
/// input:prtRowid（发票Rowid串,以"^"分割），payMInfo(收费员录入的支付方式信息格式"现金^金额$c(2)银行卡^金额$c(2)支票^金额..."),expStr(扩展信息"用户Rowid^安全组Rowid^...")
/// out:发票Rowid^总金额^自付金额$c(2)支付方式一^金额$(2)支付方式一^金额$c(2)...$c(3)发票Rowid^总金额^自付金额$c(2)支付方式一^金额$(2)支付方式一^金额$c(2)...$c(3)...
/// w ##class(web.DHCOPBillManyPaymentLogic).SplitAmtForInv("","","")
ClassMethod SplitAmtForInv(prtRowidStr, payMInfo, expStr As %String = "")
{
	n (prtRowidStr,payMInfo,expStr)
	;测试数据
	;s prtRowidStr="236163^236161"
	;s payMInfo="1^200"_$c(2)_"4^192.5"   ;1:现金，4:银行卡
	;s expStr="3873^92^"
	;
	;拆分规则:
	;    1.支付方式顺序:现金->银行卡->支票->其它
	;    2.发票顺序:按prtRowid串的顺序
	;    
	;   注：支票是否允许拆分？
	
	s Guser=$p(expStr,"^",2) ;操作员Dr
	s Group=$p(expStr,"^",3) ;安全组Dr

	f i=1:1:$l(payMInfo,$c(2)) d
	.s str=$p(payMInfo,$c(2),i)
	.s payMDr=$p(str,"^",1) ;支付方式Rowid
	.s payMAmt=$p(str,"^",2) ;金额
	.s ^DHCOPBillPayMAmt(Guser,$j,payMDr)=+$g(^DHCOPBillPayMAmt(Guser,$j,payMDr))+payMAmt
	
	s rtn=""
	f i=1:1:$l(prtRowidStr,"^") d
    .s prtRowid=$p(prtRowidStr,"^",i)
	.s totalAmt=(+$p(^DHCINVPRT(prtRowid),"^",1)) ;总金额
    .s shareAmt=(+$p(^DHCINVPRT(prtRowid),"^",16)) ;自付金额
	.s myInvInfo=prtRowid_"^"_totalAmt_"^"_shareAmt
	.s tmpAmt=shareAmt,payMDr=""
	.f  s payMDr=$o(^DHCOPBillPayMAmt(Guser,$j,payMDr)) q:(payMDr="")!(tmpAmt=0)  d
	..s payMAmt=+^DHCOPBillPayMAmt(Guser,$j,payMDr)
	..q:payMAmt=0
	..i tmpAmt>payMAmt d ;剩余自付金额>剩余支付方式金额
	...s myInvInfo=myInvInfo_$c(2)_payMDr_"^"_payMAmt
	...s tmpAmt=tmpAmt-payMAmt 
	...s ^DHCOPBillPayMAmt(Guser,$j,payMDr)=0
	..e  d
	...s myInvInfo=myInvInfo_$c(2)_payMDr_"^"_tmpAmt
	...s ^DHCOPBillPayMAmt(Guser,$j,payMDr)=^DHCOPBillPayMAmt(Guser,$j,payMDr)-tmpAmt
	...s tmpAmt=0 
	.i +rtn=0 s rtn=myInvInfo
	.e  s rtn=rtn_$c(3)_myInvInfo
   
    ;清除临时数据
    i $d(^DHCOPBillPayMAmt(Guser,$j)) k ^DHCOPBillPayMAmt(Guser,$j)
    
    ;验证拆分是否正确
    s err=..CheckPayMBalance(rtn)
    q:(+err'=0) "-3" 
    
    q rtn
}

/// Lid 
/// 2010-07-06
/// 验证拆分后，票据的平衡关系
/// input:格式:发票Rowid^总金额^自付金额$c(2)支付方式一^金额$(2)支付方式一^金额$c(2)...$c(3)发票Rowid^总金额^自付金额$c(2)支付方式一^金额$(2)支付方式一^金额$c(2)...$c(3)...
/// out:0:平衡，-1:不平
ClassMethod CheckPayMBalance(payMInfo)
{
	n (payMInfo)
	s rtn=0
	s invNum=+$L(payMInfo,$c(3))
	f i=1:1:invNum d
	.s invInfo=$p(payMInfo,$c(3),i)
	.s invAmtInfo=$p(invInfo,$c(2),1)
	.s totalAmt=+$p(invAmtInfo,"^",2)  ;总金额
	.s shareAmt=+$p(invAmtInfo,"^",3)  ;自付金额
	.s tmpAmt=0
	.s payMLen=+$l(invInfo,$c(2))
	.f j=2:1:payMLen d   ;支付方式信息，从2开始，1是发票金额信息
	..s payMDr=$p($p(invInfo,$c(2),j),"^",1)  
	..s payMAmt=+$p($p(invInfo,$c(2),j),"^",2)
	..s tmpAmt=tmpAmt+payMAmt
	.i (tmpAmt'=shareAmt) s rtn=-1   ;有一张票不平，都认为不平
	
	q rtn
}

/// Lid
/// 2010-07-06
/// 更新发票支付方式表(DHC_InvPayMode)
/// input:
/// input:prtRowid（发票Rowid串,以"^"分割），payMInfo(收费员录入的支付方式信息格式"现金Rowid^金额$c(2)银行卡Rowid^金额$c(2)支票Rowid^金额...")
///      expStr:扩展字段(扩展信息"N^用户Rowid^安全组Rowid^...")
/// out:0:更新成功
/// w ##class(web.DHCOPBillManyPaymentLogic).UpdateInvPayM(208559,"1^3"_$c(2)_"4^4"_$c(2)_"2^2.65","N^639^6^0000001075")
ClassMethod UpdateInvPayM(prtRowidStr, payMInfo, expStr As %String = "")
{
	s $ZT="ERROR^DHCSSERR"
	n (prtRowidStr,payMInfo,expStr)
	s Guser=$p(expStr,"^",2) ;操作员Dr
	s Group=$p(expStr,"^",3) ;安全组Dr
	
	s papmiDr=""
	f i=1:1:$l(prtRowidStr,"^") q:(+papmiDr'=0)  d
	.s prtRowid=$p(prtRowidStr,"^",i)
	.q:(+prtRowid=0)
	.s papmiDr=$p($g(^DHCINVPRT(prtRowid)),"^",15)  ;dhc_patmas表Rowid

	s oldPayMInfo=payMInfo ;拆分前的支付方式串
	s newPayMInfo=""       ;拆分后的支付方式串
	s newPayMInfo=..SplitAmtForInv(prtRowidStr, oldPayMInfo, expStr)
	q:(newPayMInfo="-3") newPayMInfo
	
	s myrtn=0
	
	;测试数据
	;s payMInfo="236163^230.25^230.25#1^230.25@236161^161.8^161.8#1^69.75#4^92.05"
	;s expStr=""
	;
	f i=1:1:$l(newPayMInfo,$c(3)) d
	.s invInfo=$p(newPayMInfo,$c(3),i)
	.d ..tb()
	.s myrtn=..UpdateSingleInvPayM(invInfo)
	.i +myrtn=0 d
	..d ..tc()
	..;更新成功，记录日志
	..s ^DHCOPBILLManyPaymodeLog("SUCCESS",papmiDr,Guser,+$h,$p($h,",",2))=myrtn_$c(4)_prtRowidStr_$c(4)_oldPayMInfo_$c(4)_newPayMInfo
	.e  d
	..trollback
	..;错误日志
	..s ^DHCOPBILLManyPaymodeLog("ERROR",papmiDr,Guser,+$h,$p($h,",",2))=myrtn_$c(4)_prtRowidStr_$c(4)_oldPayMInfo_$c(4)_newPayMInfo
	
	q myrtn
}

ClassMethod UpdateSingleInvPayM(invInfo)
{
	s $ZT="ERROR^DHCSSERR"
	n (invInfo)
	
	s myrtn=""
	
	s myINVInfo=$p(invInfo,$c(2),1)
	s myPrtRowID=$p(myINVInfo,"^",1)        ;发票Rowid 
	s myInvTotalAmt=$p(myINVInfo,"^",2)     ;发票总金额
	s myInvShareAmt=$p(myINVInfo,"^",3)     ;病人自付金额
	s myHospDR=$p(^DHCINVPRT(myPrtRowID),"^",39)    ;PRT_Hospital_DR
	s myRoundErr=+$p(^DHCINVPRT(myPrtRowID),"^",37) ;分币误差金额
	s RealFlag=0	
	;1.更新DHC_InvPayMode(全额结算时插入的记录),不用判全额结算时的支付方式，支付更新
	;2.在DHC_InvPayMode表中插入新支付的记录
	s RealFlag=0
	f myIdx=2:1:$l(invInfo,$c(2)) d  q:+myrtn'=0
	.s PMInfo=$p(invInfo,$c(2),myIdx)
	.s payMDr=$p(PMInfo,"^",1)
	.s payMAmt=$p(PMInfo,"^",2) 
	.;st 取四舍五入 2012-09-29 tang
	.s PayModrCode=$p($g(^CT("CTPM",payMDr)),"^",1)
	.s myRoundDownNum=0
	.s myRoundPatSum=payMAmt
	.i (PayModrCode="CASH") d
	..s myRoundPatSum=##class(web.DHCBillConsIF).OPCRound(payMAmt, myHospDR, "")
	..s myRoundDownNum=+(myRoundPatSum-payMAmt)
	.;end
	.k PLIST
	.s IPMSub=$o(^DHCINVPRT(myPrtRowID,"P","0")) ;根据已有记录，获取公用信息
	.s myIPMRowID=myPrtRowID_"||"_IPMSub
	.s myrtn=##class(web.UDHCINVPayMode).SELECT(myIPMRowID)
	.s myOldPayMDR=PLIST(3)
	.s myDate=PLIST(8)  
	.s myTime=PLIST(9)
	.s myAccPLDR=PLIST(10)
	.;i +myIdx=2 d  ;使用第一种支付方式更新的记录，其余的支付方式插入
	.i $d(^DHCINVPRTi(0,"PMDR",myPrtRowID,payMDr)) d  ;如果支付方式存在测更新，不存在则插入
	..;更新
	..k PLIST
	..s IPMSub=$o(^DHCINVPRT(myPrtRowID,"P","0")) ;根据已有记录，获取公用信息
	..s myIPMRowID=myPrtRowID_"||"_IPMSub
	..s myrtn=##class(web.UDHCINVPayMode).SELECT(myIPMRowID)
	..s myDate=PLIST(8)  
	..s myTime=PLIST(9)
	..s myAccPLDR=PLIST(10)
	..s PLIST(3)=payMDr
	..s PLIST(5)=myRoundPatSum  //+myRoundErr  ;注意:要加上分币误差金额
	..i +myrtn=0 d
	...s myrtn=##class(web.UDHCINVPayMode).UPDATE(myIPMRowID)
	...s RealFlag=1
	.e  d
	..;插入
	..k PLIST
	..s PLIST(0)=myPrtRowID
	..s PLIST(3)=payMDr
	..s PLIST(5)=myRoundPatSum
	..s myDate=+$h
	..s myTime=$p($h,",",2)
	..s PLIST(8)=myDate
	..s PLIST(9)=myTime
	..s PLIST(14)=1  ;非医保支付方式标志
	..s myrtn=##class(web.UDHCINVPayMode).INSERT()
	.i +myrtn=0 d
	..;更新多种支付方式的四舍五入    ;tang 2012-09-29
	..i PayModrCode="CASH" d
	...k PLIST
	...s PLIST(38)=myRoundDownNum
	...i +myrtn=0 d
	...s myrtn=##class(web.DHCOPInvoice).UPDATE(myPrtRowID)
	
	;20120822 tangtao
	i RealFlag=0 d
	.;如果这个标志为0，则说明多种支付方式里面没有收费页面选择的支付方式
	.;此时需要更新第一种的支付方式的金额为0
	.k PLIST
	.s IPMSub=$o(^DHCINVPRT(myPrtRowID,"P","0")) ;根据已有记录，获取公用信息
	.s myIPMRowID=myPrtRowID_"||"_IPMSub
	.s myrtn=##class(web.UDHCINVPayMode).SELECT(myIPMRowID)
	.s myDate=PLIST(8)  
	.s myTime=PLIST(9)
	.s myAccPLDR=PLIST(10)
	.s PLIST(5)=0
	.i +myrtn=0 d
	..s myrtn=##class(web.UDHCINVPayMode).UPDATE(myIPMRowID)
	.i +myrtn=0 d
	..;更新多种支付方式的四舍五入    ;tang 2012-09-29
	..s myOldPaym=$p(^DHCINVPRT(myPrtRowID,"P",IPMSub),"^",1)
	..s PayModrCode=$p($g(^CT("CTPM",myOldPaym)),"^",1)
	..i (PayModrCode="CASH") d
	...k PLIST
	...s PLIST(38)=0
	...i (+myrtn=0) d
	...s myrtn=##class(web.DHCOPInvoice).UPDATE(myPrtRowID)

	q myrtn
}

/// Lid
/// 2010-07-07
/// 更新"作废重打"时新发票记录的支付方式
/// w ##class(web.DHCOPBillManyPaymentLogic).UpdateNewInvPayM("", "", "")
ClassMethod UpdateNewInvPayM(oldPrtRowid, newPrtRowid, Guser)
{
	s $ZT="ERROR^DHCSSERR"
	n (oldPrtRowid,newPrtRowid,Guser)
	;获取原发票的支付方式
	s oldInvPayMInfo=""
	s totalAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",1)) ;总金额
    s shareAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",16)) ;自付金额
    s newInvPayMInfo=newPrtRowid_"^"_totalAmt_"^"_shareAmt
	s papmiDr=$p(^DHCINVPRT(oldPrtRowid),"^",15)  ;dhc_patmas表Rowid
	s IPMSub="0"
	f  s IPMSub=$o(^DHCINVPRT(oldPrtRowid,"P",IPMSub)) q:IPMSub=""  d
	.s paymFlag=+$p(^DHCINVPRT(oldPrtRowid,"P",IPMSub),"^",12)  ;大于0是非医保支付方式
	.q:((paymFlag<0)||(paymFlag=0))
	.s payMDr=$p(^DHCINVPRT(oldPrtRowid,"P",IPMSub),"^",1)
	.s paymAmt=$p(^DHCINVPRT(oldPrtRowid,"P",IPMSub),"^",3)
	.i (oldInvPayMInfo="") s oldInvPayMInfo=payMDr_"^"_paymAmt
	.e  s oldInvPayMInfo=oldInvPayMInfo_$c(2)_payMDr_"^"_paymAmt
	
	s newInvPayMInfo=newInvPayMInfo_$c(2)_oldInvPayMInfo
	
	;更新新发票的支付方式
	d ..tb()
	s myrtn=..UpdateSingleInvPayM(newInvPayMInfo)
	i (+myrtn=0) d
	.d ..tc()
	.;更新成功，记录日志
	.s ^DHCOPBILLManyPaymodeLog("SUCCESS",papmiDr,Guser,+$h,$p($h,",",2))=myrtn_$c(4)_newPrtRowid_$c(4)_oldInvPayMInfo_$c(4)_newInvPayMInfo
	e  d
	.trollback
	.;错误日志
	.s ^DHCOPBILLManyPaymodeLog("ERROR",papmiDr,Guser,+$h,$p($h,",",2))=myrtn_$c(4)_newPrtRowid_$c(4)_oldInvPayMInfo_$c(4)_newInvPayMInfo
    q myrtn
}

/// Lid
/// 2010-07-06
/// 根据支付方式描述获取支付方式Rowid
ClassMethod GetPayMDrByPayMDesc(payMDesc)
{
	s desc=$$ALPHAUP^SSUTIL4(payMDesc)
	s payMDr=$o(^CT("CTPM",0,"Desc",desc,""))
	q payMDr
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

/// Lid
/// 2011-07-12
/// 根据发票号获取发票支付方式信息
/// w ##class(web.DHCOPBillManyPaymentLogic).GetPayMListByPrtRowid("176600")
ClassMethod GetPayMListByPrtRowid(prtRowid)
{
	n (prtRowid)
	s IPM=0, payMList=""
    f  s IPM=$o(^DHCINVPRT(prtRowid,"P",IPM))  q:(IPM="")  d
    .s paymDr=$p(^DHCINVPRT(prtRowid,"P",IPM),"^",1)
    .s:(paymDr'="") paymCode=$p($g(^CT("CTPM",paymDr)),"^",1),paymDesc=$p($g(^CT("CTPM",paymDr)),"^",2)
    .s paymAmt=$p($g(^DHCINVPRT(prtRowid,"P",IPM)),"^",3)
    .i (payMList="") s payMList=paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
    .e  s payMList=payMList_"!"_paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
    
    q payMList
}

/// Lid
/// 2011-07-12
/// 获取病人退费金额
/// w ##class(web.DHCOPBillManyPaymentLogic).GetRefundAmtByPrtRowid(184295,184297)
ClassMethod GetRefundAmtByPrtRowid(oldPrtRowid, newPrtRowid)
{
	n (oldPrtRowid,newPrtRowid)
	
	k PayMAmtAry
	s refundAmt=0 ;退费金额
	;原发票信息
	s (oldtotalAmt,oldshareAmt,olddiscAmt,oldpayorAmt,oldybAmt,oldroundErrAmt)=0
	i (oldPrtRowid'="") d
	.s oldtotalAmt=(+$p(^DHCINVPRT(oldPrtRowid),"^",1)) ;总金额
    .s oldshareAmt=(+$p(^DHCINVPRT(oldPrtRowid),"^",16)) ;自付金额
    .s olddiscAmt=(+$p(^DHCINVPRT(oldPrtRowid),"^",7)) ;折扣金额
    .s oldpayorAmt=(+$p(^DHCINVPRT(oldPrtRowid),"^",18)) ;记账金额
    .s oldybAmt=(+$p(^DHCINVPRT(oldPrtRowid),"^",31)) ;医保支付金额
    .s oldroundErrAmt=(+$p(^DHCINVPRT(oldPrtRowid),"^",37)) ;分币误差金额
    .;
    .s IPM="0"
    .f  s IPM=$o(^DHCINVPRT(oldPrtRowid,"P",IPM)) q:IPM=""  d
    ..s IPMData=$g(^DHCINVPRT(oldPrtRowid,"P",IPM))
    ..s payMDR=$p(IPMData,"^",1)
    ..s payMAmt=+$p(IPMData,"^",3)
    ..s PayMAmtAry(payMDR)=+$g(PayMAmtAry(payMDR))+payMAmt
    ;
    ;新发票信息
    s (newtotalAmt,newshareAmt,newdiscAmt,newpayorAmt,newybAmt,newroundErrAmt)=0
    i (newPrtRowid'="") d
    .s newtotalAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",1)) ;总金额
    .s newshareAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",16)) ;自付金额
    .s newdiscAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",7)) ;折扣金额
    .s newpayorAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",18)) ;记账金额
    .s newybAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",31)) ;医保支付金额
    .s newroundErrAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",37)) ;分币误差金额
    .s IPM="0"
    .f  s IPM=$o(^DHCINVPRT(newPrtRowid,"P",IPM)) q:IPM=""  d
    ..s IPMData=$g(^DHCINVPRT(newPrtRowid,"P",IPM))
    ..s payMDR=$p(IPMData,"^",1)
    ..s payMAmt=+$p(IPMData,"^",3)
    ..s PayMAmtAry(payMDR)=+$g(PayMAmtAry(payMDR))-payMAmt
    ;
    ;计算退费金额
    s refundAmt=oldtotalAmt-newtotalAmt     ;退费金额
    s discAmt=olddiscAmt-newdiscAmt         ;折扣金额
    s payorAmt=oldpayorAmt-newpayorAmt      ;记账金额
    s factRefundAmt=oldshareAmt-newshareAmt ;实际退费金额
    s ybRefundAmt=oldybAmt-newybAmt         ;医保退费金额
    ;
    s payM="",payMInfo=""
    f  s payM=$o(PayMAmtAry(payM)) q:payM=""  d
    .s payMCode=$p(^CT("CTPM",payM),"^",1)
    .s payMDesc=$p(^CT("CTPM",payM),"^",2)
    .s amt=$j(PayMAmtAry(payM),3,2)
    .q:(payMCode["YB")
    .i (payMInfo="") s payMInfo=payMDesc_":"_amt
    .e  s payMInfo=payMInfo_" "_payMDesc_":"_amt
    
    k PayMAmtAry
    q refundAmt_"^"_discAmt_"^"_payorAmt_"^"_factRefundAmt_"^"_ybRefundAmt_"^"_payMInfo
}

/// Lid
/// 2011-07-12
/// 根据退费支付方式计算新发票的支付方式(部分退费)
/// w ##class(web.DHCOPBillManyPaymentLogic).UpdateNewInvPayM2("4^125.00"_$c(2)_"2^18.00","234290","234306","N^10207^238")
ClassMethod UpdateNewInvPayM2(refundPayMInfo, oldPrtRowid, newPrtRowid, expStr)
{
	n (refundPayMInfo, oldPrtRowid, newPrtRowid, expStr)
	s ^TMP("UpdateNewInvPayM2")=$lb(refundPayMInfo, oldPrtRowid, newPrtRowid, expStr)
	s Guser=$p(expStr,"^",2) ;操作员Dr
	s Group=$p(expStr,"^",3) ;安全组Dr
	
	s $ZT="ERROR^DHCSSERR"
	k ^DHCCalcNewPrtRowidPayMAmt(Guser,$j)
	
	;退费金额
	f i=1:1:$l(refundPayMInfo,$c(2)) d
	.s payMDr=$p($p(refundPayMInfo,$c(2),i),"^",1) 
	.s payMAmt=0-(+$p($p(refundPayMInfo,$c(2),i),"^",2))  ;退费为负值
	.s ^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payMDr)=+$g(^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payMDr))+payMAmt

	s totalAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",1)) ;总金额
    s shareAmt=(+$p(^DHCINVPRT(newPrtRowid),"^",16)) ;自付金额
    s newInvPayMInfo=newPrtRowid_"^"_totalAmt_"^"_shareAmt
	s papmiDr=$p(^DHCINVPRT(oldPrtRowid),"^",15)  ;dhc_patmas表Rowid
	
	s IPMSub="0"
	f  s IPMSub=$o(^DHCINVPRT(oldPrtRowid,"P",IPMSub)) q:(IPMSub="")  d
	.s paymFlag=+$p(^DHCINVPRT(oldPrtRowid,"P",IPMSub),"^",12)  ;大于0是非医保支付方式
	.q:(paymFlag'>0)  ;过滤医保支付方式
	.s payMDr=$p(^DHCINVPRT(oldPrtRowid,"P",IPMSub),"^",1)
	.s paymAmt=$p(^DHCINVPRT(oldPrtRowid,"P",IPMSub),"^",3)
	.;旧票与退费支付金额累计，获取的值为新票的支付金额
	.s ^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payMDr)=+$g(^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payMDr))+paymAmt

	s payM="",newInvPayMList=""
	f  s payM=$o(^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payM)) q:(payM="")  d
	.i (newInvPayMList="") s newInvPayMList=payM_"^"_+$g(^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payM))
	.e  s newInvPayMList=newInvPayMList_$c(2)_payM_"^"_+$g(^DHCCalcNewPrtRowidPayMAmt(Guser,$j,payM))
	
	s newInvPayMInfo=newInvPayMInfo_$c(2)_newInvPayMList

	;更新新发票的支付方式
	d ..tb()
	s myrtn=..UpdateSingleInvPayM(newInvPayMInfo)
	i (+myrtn=0) d
	.d ..tc()
	.;更新成功，记录日志
	.s ^DHCOPBILLManyPaymodeLog("SUCCESS",papmiDr,Guser,+$h,$p($h,",",2))=myrtn_$c(4)_newPrtRowid_$c(4)_newInvPayMInfo
	e  d
	.trollback
	.;错误日志
	.s ^DHCOPBILLManyPaymodeLog("ERROR",papmiDr,Guser,+$h,$p($h,",",2))=myrtn_$c(4)_newPrtRowid_$c(4)_newInvPayMInfo
    
    k ^DHCCalcNewPrtRowidPayMAmt(Guser,$j)
    
    q myrtn
}

/// Creator:Lid
/// CreatDate:2012-08-30
/// Desc:多种支付方式退费时，计算每种支付方式的退费金额。
/// 		说明：1.都够退时，优先级：现金->银行卡->银医卡->支票
/// 			  2.都不够退时，优先级：现金->银行卡->银医卡->支票
/// 			  3.一个够退，别的不够退时，以够退得支付方式退费。
/// 			  4.两个或两个以上够退，别的不够退时，优先级：安CT_Paymode中的定义顺序,也可以自定义顺序。
/// 			  5.支持手动改
/// w ##class(web.DHCOPBillManyPaymentLogic).CalcRefundPayMAmt(234220, 234222)
ClassMethod CalcRefundPayMAmt(OldPrtRowid As %String, NewPrtRowid As %String) As %String
{
	New (OldPrtRowid, NewPrtRowid)
	;
	Set rtn=""
	Set RefundAmtInfo=##class(web.DHCOPBillManyPaymentLogic).GetRefundAmtByPrtRowid(OldPrtRowid, NewPrtRowid)
	Set FactRefundAmt=$p(RefundAmtInfo,"^",4) ;实际退费金额
	Set OldPayMList=##class(web.DHCOPBillManyPaymentLogic).GetPayMListByPrtRowid(OldPrtRowid)
	;
	Set Flag=0
	For i=1:1:$l(OldPayMList,"!") Quit:(Flag=1)  Do
	.Set tmp=$p(OldPayMList,"!",i)		;paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
	.Quit:(tmp="")
	.Set PayMDR=$p(tmp,"^",1)
	.Set PayMCode=$p(tmp,"^",2)
	.Set PayMDesc=$p(tmp,"^",3)
	.Set PayMAmt=$p(tmp,"^",4)
	.If (+PayMAmt>=+FactRefundAmt) Do
	..Set RefAmt=FactRefundAmt
	..Set Flag=1
	..Set rtn=rtn_"!"_PayMDR_"^"_PayMCode_"^"_PayMDesc_"^"_$j(RefAmt,3,2)
	;
	Quit:(Flag=1) rtn  ;支付方式中有够退的
	;
	Set Balance=FactRefundAmt
	If ((+Balance'=0)&&(OldPayMList["CASH")) Do
	.For i=1:1:$l(OldPayMList,"!") Do
	..Set tmp=$p(OldPayMList,"!",i)		;paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
	..Quit:(tmp="")
	..Set PayMDR=$p(tmp,"^",1)
	..Set PayMCode=$p(tmp,"^",2)
	..Quit:(PayMCode'="CASH")
	..Set PayMDesc=$p(tmp,"^",3)
	..Set PayMAmt=$p(tmp,"^",4)
	..If (+PayMAmt<+Balance) Do
	...Set Balance=Balance-PayMAmt
	...Set RefAmt=PayMAmt
	..Else  Do
	...Set RefAmt=Balance
	...Set Balance=0
	..Set rtn=rtn_"!"_PayMDR_"^"_PayMCode_"^"_PayMDesc_"^"_$j(RefAmt,3,2)

	Quit:(Balance=0) rtn
	;
	If ((+Balance'=0)&&(OldPayMList["YHK")) Do
	.For i=1:1:$l(OldPayMList,"!") Do
	..Set tmp=$p(OldPayMList,"!",i)	;paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
	..Quit:(tmp="")
	..Set PayMDR=$p(tmp,"^",1)
	..Set PayMCode=$p(tmp,"^",2)
	..Quit:(PayMCode'="YHK")
	..Set PayMDesc=$p(tmp,"^",3)
	..Set PayMAmt=$p(tmp,"^",4)
	..If (+PayMAmt<+Balance) Do
	...Set Balance=Balance-PayMAmt
	...Set RefAmt=PayMAmt
	..Else  Do
	...Set RefAmt=Balance
	...Set Balance=0
	..Set rtn=rtn_"!"_PayMDR_"^"_PayMCode_"^"_PayMDesc_"^"_$j(RefAmt,3,2)

	Quit:(Balance=0) rtn
	;
	If ((+Balance'=0)&&(OldPayMList["CARDCPP")) Do
	.For i=1:1:$l(OldPayMList,"!") Do
	..Set tmp=$p(OldPayMList,"!",i)	  ;paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
	..Quit:(tmp="")
	..Set PayMDR=$p(tmp,"^",1)
	..Set PayMCode=$p(tmp,"^",2)
	..Quit:(PayMCode'="CARDCPP")
	..Set PayMDesc=$p(tmp,"^",3)
	..Set PayMAmt=$p(tmp,"^",4)
	..If (+PayMAmt<+Balance) Do
	...Set Balance=Balance-PayMAmt
	...Set RefAmt=PayMAmt
	..Else  Do
	...Set RefAmt=Balance
	...Set Balance=0
	..Set rtn=rtn_"!"_PayMDR_"^"_PayMCode_"^"_PayMDesc_"^"_$j(RefAmt,3,2)
	
	Quit:(Balance=0) rtn

	If ((+Balance'=0)&&(OldPayMList["ZP")) Do
	.For i=1:1:$l(OldPayMList,"!") Do
	..Set tmp=$p(OldPayMList,"!",i)	;paymDr_"^"_paymCode_"^"_paymDesc_"^"_paymAmt
	..Quit:(tmp="")
	..Set PayMDR=$p(tmp,"^",1)
	..Set PayMCode=$p(tmp,"^",2)
	..Quit:(PayMCode'="ZP")
	..Set PayMDesc=$p(tmp,"^",3)
	..Set PayMAmt=$p(tmp,"^",4)
	..If (+PayMAmt<+Balance) Do
	...Set Balance=Balance-PayMAmt
	...Set RefAmt=PayMAmt
	..Else  Do
	...Set RefAmt=Balance
	...Set Balance=0
	..Set rtn=rtn_"!"_PayMDR_"^"_PayMCode_"^"_PayMDesc_"^"_$j(RefAmt,3,2)

	Quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-05-06
/// Description: 取安全组配置的支付方式(用于多种支付方式)
/// Input:  GPRowID: SS_Group.RowId
/// Output: 
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillManyPaymentLogic","ReadGSINSPMList","235293","238","")
Query ReadGSINSPMList(PrtRowIdStr As %String, GPRowID As %String, HospID As %String, InsType As %String = "") As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMDesc:%String,CTPMCode:%String,RPFlag:%String,INVPrtFlag:%String")
{
}

ClassMethod ReadGSINSPMListExecute(ByRef qHandle As %Binary, PrtRowIdStr As %String, GPRowID As %String, HospID As %String, InsType As %String = "", TypeFlag As %String = "", DefFlag As %String = "Y") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("ReadGSINSPMList")=$lb(PrtRowIdStr,GPRowID,HospID,InsType)
	
	set limitPaymStr=..#LimitPayMCodeStr   //不能使用多种支付结算的支付方式串	
	for i=1:1:$l(PrtRowIdStr,"^") do
	.set prtRowId=$p(PrtRowIdStr,"^",i)
	.quit:(+prtRowId=0)
	.set paymSub="0"
	.for  set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub)) quit:(paymSub="")  do
	..set tmp=$g(^DHCINVPRT(prtRowId,"P",paymSub))
	..quit:(tmp="")
	..set paymDR=$p(tmp,"^",1)
	..quit:(+paymDR=0)
	..set paymCode=$p(^CT("CTPM",paymDR),"^",1)
	..set paymNote=$p(tmp,"^",12)
	..quit:(+paymNote=1)
	..quit:(((("^"_limitPaymStr_"^")[("^"_paymCode_"^"))))
	..set limitPaymStr=limitPaymStr_"^"_paymCode
	
	set myPMStr=##class(web.UDHCOPGSConfig).ReadPMByINSRowID(InsType, HospID)
	set num=0
	set mySelFlag=0
	set rset=##class(%ResultSet).%New("web.UDHCOPGSConfig:ReadPMConfig")
	do rset.Execute(GPRowID, HospID)
	while (rset.Next()) {
		set num=$i(num)
		set myTypeFlag=$g(rset.Data("PMOPCFlag"))
	 	set myGSPMRowID=$g(rset.Data("PMRowID"))
	 	continue:((myGSPMRowID="")||(myTypeFlag'="Y"))
	 	set myCTPMRowID=$g(rset.Data("CTPMRowID"))
	 	set myCTPMCode=($g(rset.Data("CTPMCode")))
	 	set myCTPMDesc=$g(rset.Data("CTPMDesc"))
	 	continue:(((("^"_limitPaymStr_"^")[("^"_myCTPMCode_"^"))))
	 	set myRPFlag=$g(rset.Data("RPFlag"))
	 	set myINVPrtFlag=$g(rset.Data("INVPrtFlag"))
		do OutputGSINSPMList
	}
	do rset.Close()
	
	quit $$$OK
	
OutputGSINSPMList
	set Data=$lb(myCTPMRowID,myCTPMDesc,myCTPMCode,myRPFlag,myINVPrtFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-05-06
/// Description: 多种支付方式退费时，计算每种支付方式的退费金额。
/// 		    说明：1.都够退时，优先级：现金->银行卡->银医卡->支票
/// 			  2.都不够退时，优先级：现金->银行卡->银医卡->支票
/// 			  3.一个够退，别的不够退时，以够退得支付方式退费。
/// 			  4.两个或两个以上够退，别的不够退时，优先级：按CT_Paymode中的定义顺序,也可以自定义顺序。
/// 			  5.支持手动改
/// Input:  
/// Output: 
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillManyPaymentLogic","FindInvRefPMAmtList",234220, 234226)
Query FindInvRefPMAmtList(oldPrtRowId As %String, newPrtRowId As %String) As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMDesc:%String,CTPMCode:%String,CTPMAmt:%Float")
{
}

ClassMethod FindInvRefPMAmtListExecute(ByRef qHandle As %Binary, oldPrtRowId As %String, newPrtRowId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+oldPrtRowId=0)||(+newPrtRowId=0) quit $$$OK
	
	set refAmtInfo=##class(web.DHCOPBillManyPaymentLogic).GetRefundAmtByPrtRowid(oldPrtRowId, newPrtRowId)
	set factRefAmt=$p(refAmtInfo,"^",4)   //实际退费金额

	kill paymAry
	set paymSub=0
	for  set paymSub=$o(^DHCINVPRT(oldPrtRowId,"P",paymSub)) quit:(paymSub="")  do
	.set tmp=$g(^DHCINVPRT(oldPrtRowId,"P",paymSub))
	.quit:(tmp="")
	.set paymDR=$p(tmp,"^",1)
	.quit:(+paymDR=0)
	.set paymAmt=$p(tmp,"^",3)
	.set paymNote=$p(tmp,"^",12)
	.quit:(+paymNote'=1)       //过滤医保支付方式
	.set paymAry(paymDR)=$i(paymAry(paymDR),paymAmt)
	
	set usePMCodeStr=""
	set balance=factRefAmt
	//输出支付方式有够退的第一条记录
	set flag=0
	set paymDR=0
	for  set paymDR=$o(paymAry(paymDR))  quit:((paymDR="")||(flag=1))  do
	.set paymAmt=$g(paymAry(paymDR))
	.quit:(+paymAmt<+balance)
	.set paymCode=$p(^CT("CTPM",paymDR),"^",1)
	.set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	.set refAmt=balance
	.set flag=1
	.set refAmt=$fn(refAmt,"",2)
	.set balance=balance-refAmt
	.set usePMCodeStr=usePMCodeStr_"^"_paymCode
	.do OutputInvRefPMAmtList      //支付方式中有够退的
	
	//每个支付方式都不够退时，按顺序输出(优先级：现金->银行卡->银医卡->支票)
	set seqPMCodeStr="CASH^YHK^CARDCPP^ZP"
	if (flag=0) do
	.for i=1:1:$l(seqPMCodeStr,"^") do
	..set paymCode=$p(seqPMCodeStr,"^",i)
	..quit:(paymCode="")
	..set paymDR=$o(^CT("CTPM",0,"Code",$$ALPHAUP^SSUTIL4(paymCode),""))
	..quit:(paymDR="")
	..quit:('$d(paymAry(paymDR)))
	..set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	..set paymAmt=$g(paymAry(paymDR))
	..if (+paymAmt<+balance) do
	...set balance=balance-paymAmt
	...set refAmt=paymAmt
	..else  do
	...set refAmt=balance
	...set balance=0
	..set refAmt=$fn(refAmt,"",2)
	..set usePMCodeStr=usePMCodeStr_"^"_paymCode
	..do OutputInvRefPMAmtList
	
	//输出剩余的支付方式
	set paymDR=0
	for  set paymDR=$o(paymAry(paymDR))  quit:(paymDR="")  do
	.set paymCode=$p(^CT("CTPM",paymDR),"^",1)
	.quit:(("^"_usePMCodeStr_"^")[("^"_paymCode_"^"))    //过滤已输出的支付方式信息
	.set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	.set paymAmt=$g(paymAry(paymDR))
	.if (+paymAmt<+balance) do
	..set balance=balance-paymAmt
	..set refAmt=paymAmt
	.else  do
	..set refAmt=balance
	..set balance=0
	.set refAmt=$fn(refAmt,"",2)
	.do OutputInvRefPMAmtList
	
	quit $$$OK
	
OutputInvRefPMAmtList
	set Data=$lb(paymDR,paymDesc,paymCode,refAmt)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-06-19
/// Description: 多种支付方式结算时，计算每种支付方式的金额(用于多种支付方式)
/// Input:  
/// Output: 
/// Return: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillManyPaymentLogic","FindInvGSINSPMList",235293, 238, 1)
Query FindInvGSINSPMList(PrtRowIdStr As %String, GPRowID As %String, HospID As %String, InsType As %String = "") As websys.Query(ROWSPEC = "CTPMRowID:%String,CTPMDesc:%String,CTPMCode:%String,CTPMAmt:%Float")
{
}

ClassMethod FindInvGSINSPMListExecute(ByRef qHandle As %Binary, PrtRowIdStr As %String, GPRowID As %String, HospID As %String, InsType As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set limitPaymStr=..#LimitPayMCodeStr   //不能使用多种支付结算的支付方式串
	
	set defPayMode=""
	set defPayMSum=0
	for i=1:1:$l(PrtRowIdStr,"^") do
	.set prtRowId=$p(PrtRowIdStr,"^",i)
	.quit:(+prtRowId=0)
	.set patShareAmt=$p($g(^DHCINVPRT(prtRowId)),"^",16)
	.set insuPayAmt=$p($g(^DHCINVPRT(prtRowId)),"^",31)
	.set defPayMSum=$i(defPayMSum,(patShareAmt-insuPayAmt))
	.set paymSub="0"
	.for  set paymSub=$o(^DHCINVPRT(prtRowId,"P",paymSub)) quit:(paymSub="")  do
	..set tmp=$g(^DHCINVPRT(prtRowId,"P",paymSub))
	..quit:(tmp="")
	..set paymDR=$p(tmp,"^",1)
	..quit:(+paymDR=0)
	..set paymCode=$p(^CT("CTPM",paymDR),"^",1)
	..set paymAmt=$p(tmp,"^",3)
	..set paymNote=$p(tmp,"^",12)
	..if (+paymNote'=1) do
	...quit:(((("^"_limitPaymStr_"^")[("^"_paymCode_"^"))))
	...set limitPaymStr=limitPaymStr_"^"_paymCode
	..else  if (+defPayMode=0)  do
	...set defPayMode=paymDR

	if (+defPayMode'=0) {
		set myCTPMRowID=defPayMode
		set myCTPMCode=$p(^CT("CTPM",myCTPMRowID),"^",1)
		set myCTPMDesc=$p(^CT("CTPM",myCTPMRowID),"^",2)
		set myPaymAmt=$fn(defPayMSum,"",2)
		do OutputInvGSINSPMList
	}
	
	set myPMStr=##class(web.UDHCOPGSConfig).ReadPMByINSRowID(InsType, HospID)
	set rset=##class(%ResultSet).%New("web.UDHCOPGSConfig:ReadPMConfig")
	do rset.Execute(GPRowID, HospID)
	while (rset.Next()) {
		set myTypeFlag=$g(rset.Data("PMOPCFlag"))
	 	set myGSPMRowID=$g(rset.Data("PMRowID"))
	 	continue:((myGSPMRowID="")||(myTypeFlag'="Y"))
	 	set myCTPMRowID=$g(rset.Data("CTPMRowID"))
	 	continue:(myCTPMRowID=defPayMode)
	 	set myCTPMCode=($g(rset.Data("CTPMCode")))
	 	set myCTPMDesc=$g(rset.Data("CTPMDesc"))
	 	continue:(((("^"_limitPaymStr_"^")[("^"_myCTPMCode_"^"))))
	 	set myPaymAmt="0.00"
	 	do OutputInvGSINSPMList
	}
	do rset.Close()
			
	quit $$$OK
	
OutputInvGSINSPMList
	set Data=$lb(myCTPMRowID,myCTPMDesc,myCTPMCode,myPaymAmt)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

}
