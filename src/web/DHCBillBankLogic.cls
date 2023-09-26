Import SQLUser

/// Lid
/// 2011-03-01
/// 银医卡业务处理类
Class web.DHCBillBankLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取银医卡接口的入参信息
/// patType:病人类型(O:门诊,I:住院,D:发票),guser:收费员ID,payModeDr:支付方式
/// prtRowidStr:发票Rowid串),bank
/// NO:银医卡卡号(用于校验)
/// tradeType:交易类型,expStr:扩展串
ClassMethod GetInputArgsInfo(patType, guser, payModeDr, prtRowidStr, bankCardNO, tradeType, expStr)
{
	n (patType, guser, payModeDr, prtRowidStr, bankCardNO, tradeType, expStr)

	s prtCount=$l(prtRowidStr,"^")
	s rtn=""
	f i=1:1:prtCount d
	.s prtRowidInfo=$p(prtRowidStr,"^",i)
    .q:prtRowidInfo=""
	.s:patType="OP" prtAmt=..GetOPInvBankCardAmt(prtRowidInfo)
	.s:patType="IP" prtAmt=..GetIPInvBankCardAmt(prtRowidInfo)
	.s:patType="DEP" prtAmt=..GetIPDepBankCardAmt(prtRowidInfo)
	.s prtAmt=..FormatAmtStr(+$g(prtAmt))
	.;获取原流水号,原交易日期,原交易参考号
	.s invoiceNO="",txnDate="",referenceNO=""
	.i ((tradeType="D")!(tradeType="T")) d   
	..i patType="O" d
	...s invoiceNO=..GetOPInvoiceNO(prtRowidInfo) ;获取原凭证号，原交易日期，原交易参考号
	..i patType="I" d
	...s invoiceNO=""
	..i patType="D" d
	...s invoiceNO=""
    .s tmp=prtRowidInfo_"^"_tradeType_"^"_1_"^"_guser_"^"_bankCardNO_"^"_prtAmt_"^"_invoiceNO_"^"_txnDate_"^"_referenceNO_"^"_""
    .i rtn="" d 
    ..s rtn=tmp
    .e  d
    ..;s rtn=rtn_$c(2)_tmp
    ..s rtn=rtn_$c(34)_tmp
	
	i tradeType="B" d ;查询
	.s rtn=""_"^"_"B"_"^"_1_"^"_guser_"^"_bankCardNO_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	
	i $l(prtCount)>1 d
	. s rtn=prtCount_$c(33)_rtn
	e  d
	.s rtn=0_prtCount_$c(33)_rtn
	Set date=$zd(+$h,3)
	Set time=$zt($p($h,",",2),3)
	Set ^SetTempRegStr(+$g(bankCardNO),date,time)=rtn
	q rtn
}

/// Lid
/// 2011-03-03
/// 根据门诊发票表Rowid获取银医卡支付金
ClassMethod GetOPInvBankCardAmt(rowidStr)
{
	;
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
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s amt=amt+payMAmt
	s amt=$fn($zabs(amt),"",2)
	
	q amt
}

/// Lid
/// 2011-03-07
/// 门诊撤消/退货时获取原凭证号、原交易日期、原交易参考号
ClassMethod GetOPInvoiceNO(rowidStr)
{
	;^DHCINVBTPi(0,"S","IPDR",
	;w ##class(web.DHCBillBankLogic).GetOPInvoiceNO(17145)
	n (rowidStr)
	s myrtn="^^^"
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.s initIBPDr=$o(^DHCINVBTPi(0,"S","IPDR",rowid,""))  ;原交易Rowid
	.s myTxnDate=$p(^DHCINVBTP(initIBPDr),"^",14) ;原交易日期
	.s myInvoiceNO=$p(^DHCINVBTP(initIBPDr),"^",5) ;原凭证号
	.s myRRNO=$p(^DHCINVBTP(initIBPDr),"^",7)      ;原交易参考号
	.s myrtn=myInvoiceNO_"^"_myTxnDate_"^"_myRRNO
	
	
	/*n (rowidStr)
	s myrtn="^^^"
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.s initInv=$p(^DHCINVPRT(rowid),"^",13)
	.q:((initInv="")!(initInv=0))
	.s initIBPDr=$o(^DHCINVBTPi(0,"S","IPDR",initInv,""))  ;原交易Rowid
	.s myTxnDate=$p(^DHCINVBTP(initIBPDr),"^",14) ;原交易日期
	.s myInvoiceNO=$p(^DHCINVBTP(initIBPDr),"^",5) ;原凭证号
	.s myRRNO=$p(^DHCINVBTP(initIBPDr),"^",7)      ;原交易参考号
	.s myrtn=myInvoiceNO_"^"_myTxnDate_"^"_myRRNO
	*/
	q myrtn
}

/// Lid
/// 2011-03-07
/// 住院发票撤消/退货时获取原凭证号、原交易日期、原交易参考号
ClassMethod GetIPInvoiceNO(rowidStr)
{
}

/// Lid
/// 2011-03-07
/// 住院押金撤消/退货时获取原凭证号、原交易日期、原交易参考号
ClassMethod GetDEPInvoiceNO(rowidStr)
{
}

/// Lid
/// 2011-03-02
/// 解析、保存银行卡返回信息
ClassMethod SaveBankCardInfo(patType, guser, tradeType, bankInfo, expStr)
{
	n (patType, guser, tradeType, bankInfo, expStr)
	
	;根据操作员ID获取医院ID
	s myHospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(guser)
    s $ZT="ERROR^DHCSSERR"
     s guserName=""
	i guser'="" s guserName=$p($g(^SSU("SSUSR",guser)),"^",2)
	;添加银行交易日志
	;d ..SetBankTradeLog(bankInfo,guser)
	s ^BankTradeInfoLog("BankTrade","Normal",guser,+$h,$p($h,",",2))="收费员:"_guserName_"  日期:"_$zd(+$h,3)_"  时间:"_$zt($p($h,",",2),1)_"  银行返回信息:"_bankInfo
	d ..tb()
	s rtn=0,rc=0,rcDetail="",amtSum=0,failInvStr=""
	;消费,撤销,退货
	i tradeType="C" d
	.s tradStatus="N",consultStatus="N"
	e  d
	.s tradStatus="A",consultStatus="A"
	s count=+$p(bankInfo,$c(33),1)
	s invInfo=$p(bankInfo,$c(33),2)
	s rtn=0
	f i=1:1:count d
	.s singleInfo=$p(invInfo,$c(34),i)
	.s prtRowidStr=$p(singleInfo,"^",1)
	.s rc=$p(singleInfo,"^",2)      ;成功标志
	.s rcDetail=$p(singleInfo,"^",3)   ;错误描述
	.s rtn=+rc
	.i rc'="00" d
	..i failInvStr="" s failInvStr=prtRowidStr
	..e  s failInvStr=failInvStr_"^"_prtRowidStr
	.q:rc'="00"  
	.s cardType=$p(singleInfo,"^",4) ;卡类型
	.s pan=$p(singleInfo,"^",5)  ;卡号
	.s trAmt=$p(singleInfo,"^",6)   ;交易金额
	.s merSystrace=$p(singleInfo,"^",7) ;凭证号
	.s invoiceNo=$p(singleInfo,"^",8) ;原交凭证号
	.s referenceNo=$p(singleInfo,"^",9) ;参考号
	.s authNo=$p(singleInfo,"^",10) ;授权号
	.s tid=$p(singleInfo,"^",11) ;终端号
	.s mchid=$p(singleInfo,"^",12) ;商户号
	.s batchNo=$p(singleInfo,"^",13) ;批次号
	.s tellerNo=$p(singleInfo,"^",14) ;操作员
	.s bankName=$p(singleInfo,"^",15) ;发卡行
	.s txnDate=$p(singleInfo,"^",16) ;银行交易日期
	.s txnTime=$p(singleInfo,"^",17) ;银行交易时间
	.s expDate=$p(singleInfo,"^",18) ;有效期
	.s appendInfo=$p(singleInfo,"^",19) ;备注
	.s IBPRowID="" 
	.k PLIST
	.s PLIST(2)=rc
	.s PLIST(3)=rcDetail
	.s PLIST(4)=pan
	.s PLIST(5)=trAmt
	.s PLIST(6)=merSystrace
	.s PLIST(7)=invoiceNo
	.s PLIST(8)=referenceNo
	.s PLIST(9)=authNo
	.s PLIST(10)=tid
	.s PLIST(11)=mchid
	.s PLIST(12)=batchNo
	.s PLIST(13)=tellerNo
	.s PLIST(14)=bankName
	.s PLIST(15)=txnDate
	.s PLIST(16)=txnTime
	.s PLIST(17)=expDate
	.s PLIST(18)=appendInfo
	.s PLIST(19)=tradStatus
	.;s PLIST(20)=""					;IBPBankTradePayDR
	.;s PLIST(21)=""				;OldTradDR
	.s BankDateNum=+$h
	.s BankTimeNum=$p($h,",",2)
	.i $l(txnDate)=4 d
	..s BankYear=+$zd(+$h,3)
	..s BankMonth=$e(txnDate,1,2)
	..s BankDay=$e(txnDate,3,4)
	..s BankDate=BankYear_"-"_BankMonth_"-"_BankDay
	..s BankDateNum=$zdh(BankDate,3)
	.i ($l(txnTime)=6) d
	..s BankHour=$e(txnTime,1,2)
	..s BankMinute=$e(txnTime,3,4)
    ..s BankSecond=$e(txnTime,5,6)
    ..s BankTime=BankHour_":"_BankMinute_":"_BankSecond
	..s BankTimeNum=$zth(BankTime)
	.s PLIST(22)=BankDateNum    ;把银行返回的日期时间转换为Cache系统的日期是时间
	.s PLIST(23)=BankTimeNum
	.s BankAmt=+trAmt/100
	.s amtSum=amtSum+BankAmt
	.s PLIST(24)=+BankAmt       ;转换银行返回的金额
	.s PLIST(25)=patType
	.s PLIST(26)=""
	.s PLIST(27)=tradeType     ;交易类型
	.s PLIST(28)=cardType      ;卡片类型
	.s PLIST(29)=myHospitalDr  ;医院ID
	.s myRtn=..INSERT()
	.s myIBPRowID=$p(myRtn,"^",2)
	.s myIBPRowID=$p(myIBPRowID,$c(1))
	.;s $p(^DHCINVBTP(myIBPRowID),"^",27)=cardType
	.;s $p(^DHCINVBTP(myIBPRowID),"^",28)=myHospitalDr
	.s rtn=$p(myRtn,"^",1)
	.i +rtn TRollback
	.q:+rtn'=0
	.s invCount=$L(prtRowidStr,"|")
	.f k=1:1:invCount d  q:+rtn'=0
	..k PLIST
	..s PLIST(0)=+myIBPRowID
	..s PLIST(3)=+$p(prtRowidStr,"|",k)
	..s PLIST(4)=consultStatus
	..i patType="OP" d   ;门诊

	...s rtn=##class(web.DHCOPBillINVBankConSub).INSERT()

	..i patType="IP" d   ;住院
	...;s rtn=##class(web.DHCIPBillInvBankTrade).INSERT()
	..i patType="DEP" d   ;押金
	...;s rtn=##class(web.DHCIPBillIPRcptBankTrade).INSERT()
	..i +rtn'=0 Trollback
	
	i +rtn=0 d
	.d ..tc()
	e  d
	.Trollback
	.;写插入错误日志
	.;d ..SetBankTradeInertFaildLog(bankInfo,guser)
	.s ^BankTradeInfoLog("BankTrade","Error",guser,+$h,$p($h,",",2))="收费员:"_guserName_"  日期:"_$zd(+$h,3)_"  时间:"_$zt($p($h,",",2),1)_"  银行返回信息:"_bankInfo
	
	q +$g(rc)_$c(4)_rcDetail_$c(4)_amtSum_$c(4)_failInvStr
}

/// 格式化金额
ClassMethod FormatAmtStr(amt)
{
	;w ##class(web.DHCBillBankLogic).FormatAmtStr("33.12")
	n (amt)
	s amt=$j(amt,3,2)*100
	;s tmp="000000000000"
	s tmp="00000000000000000000"
	s amt=$e(tmp,1,$l(tmp)-$l(amt))_amt  ;格式化金额
	q amt
}

ClassMethod DELETE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(DELETE FROM DHC_INVBankTradePay WHERE IBP_RowID= :RowId)
	d ..tc()
	q SQLCODE
}

ClassMethod INSERT()
{
	K PLIST(1)
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVBankTradePay Values PLIST())
	;d ..tc()
	
	s myRowID=%ROWID
	i 'SQLCODE d ..SELECT(myRowID)
	
	q SQLCODE_"^"_myRowID
}

ClassMethod SELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVBankTradePay WHERE IBP_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

ClassMethod UPDATE(RowId)
{
	s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(UPDATE DHC_INVBankTradePay VALUES PLIST() WHERE IBP_RowID= :RowId)
	d ..tc()
	q SQLCODE
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
/// 2011-03-11
/// 根据发票Rwoid判断是否交易成功
/// 0：交易成功，非0：交易不成功,-1:记录不存在(非银医卡消费)
ClassMethod CheckTradeFailByInvRowidOLD(patType, invRowid)
{
	//18016
	;w ##class(web.DHCBillBankLogic).CheckTradeFailByInvRowid("O",34774)
	n (patType,invRowid)
    s myrtn="-1^^^^^"
	i patType="OP" d 
	.q:'$d(^DHCINVBTPi(0,"S","IPDR",invRowid))
	.s initIBPDr=$o(^DHCINVBTPi(0,"S","IPDR",invRowid,""))  ;原交易Rowid
	.s s=$g(^DHCINVBTP(initIBPDr))
	.s myrc=+$p(s,"^",1)  ;
	.s tradeDate=$p(s,"^",21)
	.q:tradeDate'=+$h
	.s myrcDetail=$p(s,"^",2)
	.s myTxnDate=$p(s,"^",14) ;原交易日期
	.s myInvoiceNO=$p(s,"^",5) ;原凭证号
	.s myRRNO=$p(s,"^",7)      ;原交易参考号
	.s myrtn=myrc_"^"_myrcDetail
	
	q myrtn
}

/// Lid
/// 2011-03-11
/// 根据发票Rwoid判断是否交易成功
/// 0：交易成功，非0：交易不成功,-1:记录不存在(非银医卡消费)
ClassMethod CheckTradeFailByInvRowid(patType, tradeType, invRowid)
{
	//18016
	;w ##class(web.DHCBillBankLogic).CheckTradeFailByInvRowid("O","D",34846)
	;w ##class(web.DHCBillBankLogic).CheckTradeFailByInvRowid("O","C",34846)
	n (patType,tradeType,invRowid)

    s myrtn="-1^^^^^"
	i patType="OP" d 
	.q:'$d(^DHCINVBTPi(0,"S","IPDR",invRowid))
	.s initIBPDr="0",flag=0
	.f  s initIBPDr=$o(^DHCINVBTPi(0,"S","IPDR",invRowid,initIBPDr)) q:((initIBPDr="")!(flag=1))  d
	..s s=$g(^DHCINVBTP(initIBPDr))
	..s myrc=+$p(s,"^",1)  ;
	..s myTradeType=$p(s,"^",26)
	..s myTradeDate=$p(s,"^",21)
	..s myTradeTime=$p(s,"^",22)
	..s myrcDetail=$p(s,"^",2)
	..s myTxnDate=$p(s,"^",14)  ;原交易日期
	..s myInvoiceNO=$p(s,"^",5) ;原凭证号
	..s myRRNO=$p(s,"^",7)      ;原交易参考号
	..i ((tradeType=myTradeType)&(+myrc=0)) s flag=1,myrtn=myrc_"^"_myrcDetail
	q myrtn
}

/// Lid
/// 2011-03-11
/// 存放交易失败记录
ClassMethod SetTradeFailLog(patType, guser, payModeDr, prtRowidStr, bankCardNO, tradeType, bankInfo, expStr)
{
	n (patType, guser, payModeDr, prtRowidStr, bankCardNO, tradeType, bankInfo,expStr)
	s tradeFailCode=$p(bankInfo,$c(4),1)
	s tradeFailDesc=$p(bankInfo,$c(4),2)
	;根据操作员ID获取医院ID
	s myHospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(guser)
    s $ZT="ERROR^DHCSSERR"
	d ..tb()
    k PLIST
	s PLIST(2)=rc
	s PLIST(3)=rcDetail
	s PLIST(4)=pan
	s PLIST(5)=trAmt
	s PLIST(6)=merSystrace
	s PLIST(7)=invoiceNo
	s PLIST(8)=referenceNo
	s PLIST(9)=authNo
	s PLIST(10)=tid
	s PLIST(11)=mchid
	s PLIST(12)=batchNo
	s PLIST(13)=tellerNo
	s PLIST(14)=bankName
	s PLIST(15)=txnDate
	s PLIST(16)=txnTime
	s PLIST(17)=expDate
}

/// Lid
/// 2011-03-11
/// 生成核对数据，做任务每晚自动生成数据
/// ;^DHCINVBTPi(0,"TypeDate",{IBP_BankTradeType},{IBP_TradeDate},{IBP_RowID})
ClassMethod SetCheckUpDate()
{
	
	;d ##class(web.DHCBillBankLogic).SetCheckUpDate()
	//s tradeDate=62157
	s tradeDate=+$h-1
	;门诊对账数据
	s fileName=$zd(tradeDate,8)
	s OPData=..GetTradeData(tradeDate,"OP")
	if ('(OPData.IsNull())){
		s file="D:\HisData\OP"_fileName_".txt"
		o file:"NWS"
		u file
		
		while('OPData.AtEnd){
		    w OPData.ReadLine()	
		    w !
		}
	    
		
		c file	
	}
	
	
	;住院对账数据
	/*s IPData=..GetTradeData(tradeDate,"IP")
	s DEPData=..GetTradeData(tradeDate,"DEP")
	if (('(IPData.IsNull()))!('(DEPData.IsNull()))){
		s file="D:\HisData\IP"_fileName_".txt"
		o file:"NWS"
		u file
	    
	   while('IPData.AtEnd){
		    w IPData.ReadLine()	
		    w !
		}
		while('DEPData.AtEnd){
		    w DEPData.ReadLine()	
		    w !
		}
		
		c file	
	} 
	*/
}

ClassMethod GetTradeData(tradeDate, bankTradeType) As %GlobalCharacterStream
{
	n (tradeDate,bankTradeType)
	Set stream=##class(%GlobalCharacterStream).%New()
	s IBPDr="",rtn=""
	f  s IBPDr=$o(^DHCINVBTPi(0,"TypeDate",bankTradeType,tradeDate,IBPDr)) q:IBPDr=""  d
	.q:'$d(^DHCINVBTP(IBPDr))
	.s data=$g(^DHCINVBTP(IBPDr))
	.s sub="0",prtInvDr=""
	.i bankTradeType="OP" d
	..f  s sub=$o(^DHCINVBTP(IBPDr,"C",sub)) q:sub=""  d
	...q:'$d(^DHCINVBTP(IBPDr,"C",sub))
	...s s=$g(^DHCINVBTP(IBPDr,"C",sub))
	...s invprtDr=$p(s,"^",1)
	...i prtInvDr="" s prtInvDr=invprtDr
	...e  s prtInvDr=prtInvDr_"|"_invprtDr
	.i bankTradeType="IP" d
	..;f  s sub=$o(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub)) q:sub=""  d
	..;.q:'$d(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub))
	..;.s s=$g(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub))
	..;.s invprtDr=$p(s,"^",1)
	..;.i prtInvDr="" s prtInvDr=invprtDr
	..;.e  s prtInvDr=prtInvDr_"|"_invprtDr
	.i bankTradeType="DEP" d
	..;f  s sub=$o(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub)) q:sub=""  d
	..;.q:'$d(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub))
	..;.s s=$g(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub))
	..;.s invprtDr=$p(s,"^",1)
	..;.i prtInvDr="" s prtInvDr=invprtDr
	..;.e  s prtInvDr=prtInvDr_"|"_invprtDr
	.s rc=$p(data,"^",1)
	.q:rc'="00"
	.s rcDetail=$p(data,"^",2)
	.s pan=$p(data,"^",3)
	.s trAmt=$p(data,"^",4)
	.s merSystrace=$p(data,"^",5)
	.s invoiceNO=$p(data,"^",6)
	.s RRN=$p(data,"^",7)
	.s authNO=$p(data,"^",8)
	.s tid=$p(data,"^",9)
	.s mchid=$p(data,"^",10)
	.s batchNO=$p(data,"^",11)
	.s tellerNO=$p(data,"^",12)
	.s bankName=$p(data,"^",13)
	.s txnDate=$p(data,"^",14)
	.s txnTime=$p(data,"^",15)
	.s expDate=$p(data,"^",16)
	.s appendInfo=$p(data,"^",17)
	.s cardType=$p(data,"^",27)
	.s tradeType=$p(data,"^",26)
	.s rtn=prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.;i rtn="" s rtn=prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.;e  s rtn=rtn_$c(2)_prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.d stream.WriteLine(rtn)
	q stream
}

ClassMethod test()
{
	;w ##class(web.DHCBillBankLogic).test()
	
	;测试保存数据
	//s bankInfo="02"_$c(33)_"10001^00^交易成功^02^9999990100026855^000000000100^000296^^000000000868^^290009510001007^290009510001^^1234567890^^0225^195725^1202^^"	
	//s bankInfo=bankInfo_$c(34)_"10002^00^交易成功^02^9999990100026855^000000000200^000297^^000000000869^^290009510001007^290009510001^^1234567890^^0225^195731^1202^^"
	f i=1:1:30000 d
	.s bankInfo="01"_$c(33)_(10009+1)_"^00^交易成功^02^9999990100026855^000000000100^000296^^000000000868^^290009510001007^290009510001^^1234567890^^0225^195725^1202^^"	
	.s patType="OP",guser=1,tradeType="C",expStr="^^^^^^^^^"
    .s rtnValue=..SaveBankCardInfo(patType, guser, tradeType, bankInfo, expStr)
    
    q rtnValue
}

/// ///在指定FTP服务器上生成对账数据///////////////////////////////
/// Lid
/// 2011-03-11
/// 生成核对数据，做任务每晚自动生成数据(在指定的FTP服务器上生成文件)
/// ;^DHCINVBTPi(0,"TypeDate",{IBP_BankTradeType},{IBP_TradeDate},{IBP_RowID})
ClassMethod SetCheckUpDateFTPold()
{
	;w ##class(web.DHCBillBankLogic).SetCheckUpDateFTP()
	//s tradeDate=62229
	s tradeDate=+$h-1
	/*s ftpIP="10.0.11.14"
	s userName="administrator"
	s password="ceshi123"
	s port=290
	*/
	s ftpIP="10.0.11.41"
	s userName="HisData"
	s password="HisData"
	s port=21
	;门诊对账数据
	s fileName=$zd(tradeDate,8)
	s OPData=..GetTradeDataSteam(tradeDate,"OP")
	if ('(OPData.IsNull())){
		s file="OP"_fileName_".txt"
		Set ftp=##class(%Net.FtpSession).%New()
		If 'ftp.Connect(ftpIP,userName,password,port) Quit
		if 'ftp.Append(file,OPData) Quit
	}
	s end=$p($h,",",2)
	
	;住院对账数据
	s IPData=..GetTradeDataSteam(tradeDate,"IP")
	s DEPData=..GetTradeDataSteam(tradeDate,"DEP")
	if (('(IPData.IsNull()))!('(DEPData.IsNull()))){
		s file="IP"_fileName_".txt"
		Set ftp=##class(%Net.FtpSession).%New()
		If 'ftp.Connect(ftpIP,userName,password,port) Quit
		i 'ftp.Append(file,IPData) Quit
		i 'ftp.Append(file,DEPData) Quit
	}
	q 0
}

/// ///在指定FTP服务器上生成对账数据///////////////////////////////
/// Lid
/// 2011-03-11  ljr
/// 生成核对数据，做任务每晚自动生成数据(在指定的FTP服务器上生成文件)
/// ;^DHCINVBTPi(0,"TypeDate",{IBP_BankTradeType},{IBP_TradeDate},{IBP_RowID})
ClassMethod SetCheckUpDateFTP()
{
	;w ##class(web.DHCBillBankLogic).SetCheckUpDateFTP()
	//s tradeDate=62229
	s tradeDate=+$h-1
	/*s ftpIP="10.0.11.14"
	s userName="administrator"
	s password="ceshi123"
	s port=290
	*/
	s ftpIP="10.0.11.41"
	s userName="HisData"
	s password="HisData"
	s port=21
	;门诊对账数据
	s fileName=$zd(tradeDate,8)
	s OPData=..GetTradeDataSteamNew(tradeDate,"OP")
	if ('(OPData.IsNull())){
		s file="OP"_fileName_".txt"
		Set ftp=##class(%Net.FtpSession).%New()
		If 'ftp.Connect(ftpIP,userName,password,port) Quit
		if 'ftp.Append(file,OPData) Quit
	}
	s end=$p($h,",",2)
	
	;住院对账数据
	/*
	s IPData=..GetTradeDataSteamNew(tradeDate,"IP")
	s DEPData=..GetTradeDataSteamNew(tradeDate,"DEP")
	if (('(IPData.IsNull()))!('(DEPData.IsNull()))){
		s file="IP"_fileName_".txt"
		Set ftp=##class(%Net.FtpSession).%New()
		If 'ftp.Connect(ftpIP,userName,password,port) Quit
		i 'ftp.Append(file,IPData) Quit
		i 'ftp.Append(file,DEPData) Quit
	}   
	*/
	
	q 0
}

ClassMethod GetTradeDataSteam(tradeDate, bankTradeType) As %GlobalCharacterStream
{
    ///w ##class(web.DHCBillBankLogic).GetTradeDataSteam("62238","OP")
	n (tradeDate,bankTradeType)
    s $ZT="ERROR"                   //设置一个异常
	Set stream=##class(%GlobalCharacterStream).%New()
	s IBPDr="",rtn=""
	f  s IBPDr=$o(^DHCINVBTPi(0,"TypeDate",bankTradeType,tradeDate,IBPDr)) q:IBPDr=""  d
	.q:'$d(^DHCINVBTP(IBPDr))
	.s data=$g(^DHCINVBTP(IBPDr))
	.s sub="0",prtInvDr=""
	.i bankTradeType="OP" d
	..f  s sub=$o(^DHCINVBTP(IBPDr,"C",sub)) q:sub=""  d
	...q:'$d(^DHCINVBTP(IBPDr,"C",sub))
	...s s=$g(^DHCINVBTP(IBPDr,"C",sub))
	...s invprtDr=$p(s,"^",1)
	...i prtInvDr="" s prtInvDr=invprtDr
	...e  s prtInvDr=prtInvDr_"|"_invprtDr
	.i bankTradeType="IP" d
	..;f  s sub=$o(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub)) q:sub=""  d
	..;.q:'$d(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub))
	..;.s s=$g(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub))
	..;.s invprtDr=$p(s,"^",1)
	..;.i prtInvDr="" s prtInvDr=invprtDr
	..;.e  s prtInvDr=prtInvDr_"|"_invprtDr
	.i bankTradeType="DEP" d
	..;f  s sub=$o(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub)) q:sub=""  d
	..;.q:'$d(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub))
	..;.s s=$g(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub))
	..;.s invprtDr=$p(s,"^",1)
	..;.i prtInvDr="" s prtInvDr=invprtDr
	..;.e  s prtInvDr=prtInvDr_"|"_invprtDr
	.s rc=$p(data,"^",1)
	.q:rc'="00"
	.s rcDetail=$p(data,"^",2)
	.s pan=$p(data,"^",3)
	.s trAmt=$p(data,"^",4)
	.s merSystrace=$p(data,"^",5)
	.s invoiceNO=$p(data,"^",6)
	.s RRN=$p(data,"^",7)
	.s authNO=$p(data,"^",8)
	.s tid=$p(data,"^",9)
	.s mchid=$p(data,"^",10)
	.s batchNO=$p(data,"^",11)
	.s tellerNO=$p(data,"^",12)
	.s bankName=$p(data,"^",13)
	.s txnDate=$p(data,"^",14)
	.s txnTime=$p(data,"^",15)
	.s expDate=$p(data,"^",16)
	.s appendInfo=$p(data,"^",17)
	.s cardType=$p(data,"^",27)
	.s tradeType=$p(data,"^",26)
	.s rtn=prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.;i rtn="" s rtn=prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.;e  s rtn=rtn_$c(2)_prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.d stream.WriteLine(rtn)
	.;w rtn,!
	
	i ((stream.IsNull())&(bankTradeType="OP")) d
	.d stream.Write("")
	q stream
	
ERROR
	Set $ZT=""	
	s ErrorMsg=$ZE                  //$ZE 获取错误信息
	s ^TMPBankTradeErrorLog("BankTradeErrorLog",+$h,$p($h,",",2),tradeDate)=ErrorMsg
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("")
	q stream
}

/// Lid 
/// 2011-03-17
/// 获取收费员组长结算时间.
ClassMethod GetFootDateTime()
{
	;w ##class(web.DHCBillBankLogic).GetFootDateTime()
	s recDate=+$h
	q:'$d(^DHCOPReceipt(0,"RecDate",recDate)) "1001|今天未结算.|||||||"
	
	;如果多次结算，则取最后一次的结算时间
	s recRowid=$o(^DHCOPReceipt(0,"RecDate",recDate,""),-1)
	s recDate=$p(^DHCOPReceipt(recRowid),"^",2)
	s recTime=$p(^DHCOPReceipt(recRowid),"^",3)
	s recDateF=$zd(recDate,3)
	s recTimeF=$zt(recTime,1)
	s rtn=0_"|"_recDateF_"|"_recTimeF_"|"_recDate_"|"_recTime_"|"_recRowid_"|||"
	q rtn
}

ClassMethod CheckData()
{
	;w ##class(web.DHCBillBankLogic).CheckData()
	k ^TMP("TEST")
	k ^TMP("TESTInvRowid")
    s footDate=+$h
	s HisId=""
	f  s HisId=$o(^DHCOPInsFootI(0,"Date",footDate,HisId)) q:HisId=""  d
	.q:$d(^DHCOPInsFoot(HisId))=10
	.s FootFlag=$p($g(^DHCOPInsFoot(HisId)),"^",15) ;HIS_INSFootUser
	.s FootDr=$p($g(^DHCOPInsFoot(HisId)),"^",67)        ;HIS_ReportNote
	.s RowId=""
	.f  s RowId=$o(^DHCINVPRT(0,"Report",HisId,RowId)) q:RowId=""  d
    ..s invInfo=$g(^DHCINVPRT(RowId))
    ..s prtfairtype=$p(invInfo,"^",34)
    ..s IPM="0"
    ..f  s IPM=$o(^DHCINVPRT(RowId,"P",IPM)) q:IPM=""  d
    ...s payMDr=$p(^DHCINVPRT(RowId,"P",IPM),"^",1)
    ...s payMDesc=$p(^CT("CTPM",payMDr),"^",2)
    ...s payMAmt=+$p(^DHCINVPRT(RowId,"P",IPM),"^",3)
    ...s ^TMP("TEST",payMDesc)=+$g(^TMP("TEST",payMDesc))+payMAmt
    ...s ^TMP("TESTInvRowid",RowId,payMDesc)=+$g(^TMP("TEST",RowId,payMDesc))+payMAmt
    
    s rtn=""
    s payM=""
    f  s payM=$o(^TMP("TEST",payM)) q:payM=""  d
    .s rtn=rtn_"!"_payM_"^"_^TMP("TEST",payM)
    
    
    
    q rtn
}

/// Lid
/// 2011-03-22
/// 判断是否调用银行接口(非空则调用)
/// Insert	into	DHC_CTPayModeExp (PME_HardCom_DR,pme_ifmode,pme_iotype,PME_PayMode_DR) values (1,'WS','IP',27)
/// Insert	into	DHC_CTPayModeExp (PME_HardCom_DR,pme_ifmode,pme_iotype,PME_PayMode_DR) values (1,'DLL','IP',28)
/// Insert	into	DHC_CTPayModeExp (PME_HardCom_DR,pme_ifmode,pme_iotype,PME_PayMode_DR) values (1,'WS','OP',27)
/// Insert	into	DHC_CTPayModeExp (PME_HardCom_DR,pme_ifmode,pme_iotype,PME_PayMode_DR) values (1,'DLL','OP',28)
/// w ##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",27)
ClassMethod GetPayModeHardComm(invType, PayMode)
{
	n (invType,PayMode)
	i PayMode["POS" s PayMode="38"
	i PayMode["银医卡" s PayMode="37"
	s HardDr=""
	s invType=" "_invType,PayMode=" "_PayMode
	i $d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode)) d
	.s HardRowID=$o(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode,""))
	.s HardDr=$LIST(^User.DHCCTPayModeExpD(HardRowID),3)
	.s IfMode=$LIST(^User.DHCCTPayModeExpD(HardRowID),4)
	.s tmpPayMode=$tr(PayMode," ","")
	.s HardDr=HardDr_"^"_IfMode_"^"_tmpPayMode
	q HardDr
}

/// Lid
/// 2011-03-23
/// 根据支付方式代码获取支付方式Rowid
ClassMethod GetPayMDrByPayMCode(paymCode)
{
	;w ##class(web.DHCBillBankLogic).GetPayMDrByPayMCode("CASH")
	n (paymCode)
	s paymCode=$$ALPHAUP^SSUTIL4(paymCode)
	s rowid=$o(^CT("CTPM",0,"Code",paymCode,""))
	
	q $g(rowid)
}

/// Lid
/// 2011-05-08
/// 生成银行返回信息日志文件
ClassMethod SetBankTradeLog(bankTrdeInfo, Userid)
{
	n (bankTrdeInfo,Userid)
	;w ##class(web.DHCBillBankLogic).SetBankTradeLog("")
	s tradeDate=+$h-1
	s guserName=""
	i Userid'="" s guserName=$p($g(^SSU("SSUSR",Userid)),"^",2)
	/*
	s ftpIP="10.0.11.14"
	s userName="administrator"
	s password="ceshi123"
	s port=290
	*/ 
	;正式库日志
	s ftpIP="10.0.11.41"
	s userName="HisData"
	s password="HisData"
	s port=21
	;门诊对账数据
        
	s logStr="收费员:"_guserName_"  日期:"_$zd(+$h,3)_"  时间:"_$zt($p($h,",",2),1)_"  银行返回信息:"_bankTrdeInfo
	s stream=##class(%GlobalCharacterStream).%New()
    d stream.WriteLine(logStr)

	s fileName=$zd(tradeDate,8)
	s file="TradeLog"_fileName_".txt"
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ftpIP,userName,password,port) Quit
	if 'ftp.Append(file,stream) Quit
}

/// Lid
/// 2011-05-08
/// his插入银行交易信息失败日志.
ClassMethod SetBankTradeInertFaildLog(bankTrdeInfo, Userid)
{
	n (bankTrdeInfo,Userid)
	;w ##class(web.DHCBillBankLogic).SetBankTradeInertFaildLog("","")
	s tradeDate=+$h
	s guserName=""
	i Userid'="" s guserName=$p($g(^SSU("SSUSR",Userid)),"^",2)
	/* 
	s ftpIP="10.0.11.41"
	s userName="administrator"
	s password="nyfy"
	s port=290
	*/
	;正式库日志
	s ftpIP="10.0.11.41"
	s userName="HisData"
	s password="HisData"
	s port=21
	
	;门诊对账数据
	s logStr="收费员:"_guserName_"  日期:"_$zd(+$h,3)_"  时间:"_$zt($p($h,",",2),1)_"  银行返回信息:"_bankTrdeInfo
	s stream=##class(%GlobalCharacterStream).%New()
    d stream.WriteLine(logStr)

	s fileName=$zd(tradeDate,8)
	s file="TradeInertFaildLog"_fileName_".txt"
	Set ftp=##class(%Net.FtpSession).%New()
	If 'ftp.Connect(ftpIP,userName,password,port) Quit
	if 'ftp.Append(file,stream) Quit
}

/// Lid
/// 2011-05-19
/// 获取对账文本
ClassMethod GetTradeDataSteamNewold(tradeDate, bankTradeType) As %GlobalCharacterStream
{
	;w ##class(web.DHCBillBankLogic).GetTradeDataSteamNewold("62270","OP")
	n (tradeDate,bankTradeType)
	//s $ZT="ERROR1"                   //设置一个异常
	s stream=##class(%GlobalCharacterStream).%New()
	s prtRowid=""
	f  s prtRowid=$o(^DHCINVPRT(0,"Date",tradeDate,prtRowid)) q:prtRowid=""  d
	.q:'$d(^DHCINVPRT(prtRowid))
	.s data=$g(^DHCINVPRT(prtRowid))
	.s prtFlag=$p(data,"^",8)
	.s prtInitInvDR=$p(data,"^",13)
	.s prtOldInvDR=$p(data,"^",29)
	.s prtAcount=$p(data,"^",1)
	.s prtCardAmt=..GetOPInvBankCardAmt(prtRowid)  ;病人自付金额(针对医保病人)
	.s formatHisCardAmt=..FormatAmtStr(+$g(prtCardAmt)) ;格式化金额
	.q:prtCardAmt="0.00" ;过滤自负金额为0的记录(金额为0不调用银行接口)
	.q:(+prtAcount<=0)  ;退费都退现金，所以过滤
    .s ipmSub="0",cardPayMFlag=0
    .f  s ipmSub=$o(^DHCINVPRT(prtRowid,"P",ipmSub)) q:((ipmSub="")!(cardPayMFlag=1))  d
    ..s payMDr=$p(^DHCINVPRT(prtRowid,"P",ipmSub),"^",1)
    ..s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s cardPayMFlag=1
    .q:cardPayMFlag=0   ;过滤非银医卡支付记录
    .s abortInvPayMFlag=0
    .i ((prtFlag="A")!(prtFlag="S")) d
    ..s abortInvDR=$o(^DHCINVPRT(0,"InitInvDR",prtRowid,""))
    ..s ipmSub="0"
    ..f  s ipmSub=$o(^DHCINVPRT(abortInvDR,"P",ipmSub)) q:((ipmSub="")!( abortInvPayMFlag=1))  d
    ...s payMDr=$p(^DHCINVPRT(abortInvDR,"P",ipmSub),"^",1)
    ...s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	...i handDr'="" d
	....s abortInvPayMFlag=1
    .q:abortInvPayMFlag=1   ;过滤作废记录
    .s oldAcount=0
	.i (prtOldInvDR'="")
	..i ($d(^DHCINVPRT(0,"OldINV",prtOldInvDR))) d
	...;s oldPrtRowid=$O(^DHCINVPRT(0,"OldINV",prtRowid,""))
	...s oldAcount=$p(^DHCINVPRT(prtOldInvDR),"^",1)
	.q:(prtOldInvDR'="")&(oldAcount=prtAcount) ;过滤作废重打记录（作废重打时，支付方式不变，所以如果原支付方式是银医卡，重打记录的支付方式也是银医卡，但是没有调用银行接口）
	.;
	.s (tradeType,pan,cardType,trAmt,merSystrace,RRN,tid,mchid,batchNO,txnDatetradeType,pan,cardType,trAmt,merSystrace,RRN,tid,mchid,batchNO,txnDate,txnTime,appendInfo,txnTime,appendInfo)=""
	.i $d(^DHCINVBTPi(0,"S","IPDR",prtRowid))  d    ;发票记录存在银行交易记录
	..s IBPDR="0"
	..f  s IBPDR=$o(^DHCINVBTPi(0,"S","IPDR",prtRowid,IBPDR)) q:IBPDR=""  d
	...q:'$d(^DHCINVBTP(IBPDR))
	...s info=$g(^DHCINVBTP(IBPDR))
	...q:bankTradeType'=$p(info,"^",24) ;过滤非门诊交易记录
	...s rc=$p(info,"^",1)
	...q:rc'="00"
	...s rcDetail=$p(info,"^",2)
	...s pan=$p(info,"^",3)
	...s trAmt=$p(info,"^",4)
	...s merSystrace=$p(info,"^",5)
	...s invoiceNO=$p(info,"^",6)
	...s RRN=$p(info,"^",7)
	...s authNO=$p(info,"^",8)
	...s tid=$p(info,"^",9)
	...s mchid=$p(info,"^",10)
	...s batchNO=$p(info,"^",11)
	...s tellerNO=$p(info,"^",12)
	...s bankName=$p(info,"^",13)
	...s txnDate=$p(info,"^",14)
	...s txnTime=$p(info,"^",15)
	...s expDate=$p(info,"^",16)
	...s appendInfo=$p(info,"^",17)
	...s cardType=$p(info,"^",27)
	...s tradeType=$p(info,"^",26)
	...s rtn=prtRowid_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	...d stream.WriteLine(rtn)
    .e  d   ;发票不存在银行交易记录
    ..s trAmt=formatHisCardAmt ;
    ..s rtn=prtRowid_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	..d stream.WriteLine(rtn)
	.w rtn,!
	
	
	i ((stream.IsNull())&(bankTradeType="OP")) d
	.d stream.WriteLine("")
	
	q stream
	
ERROR3
	Set $ZT=""	
	s ErrorMsg=$ZE                  //$ZE 获取错误信息
	s ^TMPBankTradeErrorLog("BankTradeErrorLog",+$h,$p($h,",",2),tradeDate)=ErrorMsg
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("")
	q stream
}

/// Lid
/// 2011-05-20
/// test 
ClassMethod GetTradeDataSteamTest(tradeDate, bankTradeType) As %GlobalCharacterStream
{
   ; w ##class(web.DHCBillBankLogic).GetTradeDataSteamTest("62270","OP")
	n (tradeDate,bankTradeType)
    s $ZT="ERROR2"                   //设置一个异常
	Set stream=##class(%GlobalCharacterStream).%New()
	//s aa=^TMP("dddd",3)
	s IBPDr="",rtn=""
	f  s IBPDr=$o(^DHCINVBTPi(0,"TypeDate",bankTradeType,tradeDate,IBPDr)) q:IBPDr=""  d
	.q:'$d(^DHCINVBTP(IBPDr))
	.s data=$g(^DHCINVBTP(IBPDr))
	.s sub="0",prtInvDr=""
	.i bankTradeType="OP" d
	..f  s sub=$o(^DHCINVBTP(IBPDr,"C",sub)) q:sub=""  d
	...q:'$d(^DHCINVBTP(IBPDr,"C",sub))
	...s s=$g(^DHCINVBTP(IBPDr,"C",sub))
	...s invprtDr=$p(s,"^",1)
	...i prtInvDr="" s prtInvDr=invprtDr
	...e  s prtInvDr=prtInvDr_"|"_invprtDr
	.i bankTradeType="IP" d
	..;f  s sub=$o(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub)) q:sub=""  d
	..;.q:'$d(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub))
	..;.s s=$g(^DHCIPINVBANKTRADESUB(IBPDr,"IPInv",sub))
	..;.s invprtDr=$p(s,"^",1)
	..;.i prtInvDr="" s prtInvDr=invprtDr
	..;.e  s prtInvDr=prtInvDr_"|"_invprtDr
	.i bankTradeType="DEP" d
	..f  s sub=$o(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub)) q:sub=""  d
	..;.q:'$d(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub))
	..;.s s=$g(^DHCIPRCPTBANKTRADESUB(IBPDr,"IPRcpt",sub))
	..;.s invprtDr=$p(s,"^",1)
	..;.i prtInvDr="" s prtInvDr=invprtDr
	..;.e  s prtInvDr=prtInvDr_"|"_invprtDr
	.s rc=$p(data,"^",1)
	.q:rc'="00"
	.s rcDetail=$p(data,"^",2)
	.s pan=$p(data,"^",3)
	.s trAmt=$p(data,"^",4)
	.s merSystrace=$p(data,"^",5)
	.s invoiceNO=$p(data,"^",6)
	.s RRN=$p(data,"^",7)
	.s authNO=$p(data,"^",8)
	.s tid=$p(data,"^",9)
	.s mchid=$p(data,"^",10)
	.s batchNO=$p(data,"^",11)
	.s tellerNO=$p(data,"^",12)
	.s bankName=$p(data,"^",13)
	.s txnDate=$p(data,"^",14)
	.s txnTime=$p(data,"^",15)
	.s expDate=$p(data,"^",16)
	.s appendInfo=$p(data,"^",17)
	.s cardType=$p(data,"^",27)
	.s tradeType=$p(data,"^",26)
	.s rtn=prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.;i rtn="" s rtn=prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.;e  s rtn=rtn_$c(2)_prtInvDr_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	.d stream.WriteLine(rtn)
	.w rtn,!
	.
	i ((stream.IsNull())&(bankTradeType="OP")) d
	.d stream.Write("")
	q stream
	
ERROR2
	Set $ZT=""	
	s ErrorMsg=$ZE                  //$ZE 获取错误信息
	s ^TMPBankTradeErrorLog("BankTradeErrorLog",+$h,$p($h,",",2),tradeDate)=ErrorMsg
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("")
	q stream
}

/// Lid
/// 2011-05-19
/// 获取对账文本
ClassMethod GetTradeDataSteamNew(tradeDate, bankTradeType) As %GlobalCharacterStream
{
	;w ##class(web.DHCBillBankLogic).GetTradeDataSteamNew("62259","OP")
	n (tradeDate,bankTradeType)
	//s $ZT="ERROR1"                   //设置一个异常
	s stream=##class(%GlobalCharacterStream).%New()
	s prtRowid="",rtn=""
	f  s prtRowid=$o(^DHCINVPRT(0,"Date",tradeDate,prtRowid)) q:prtRowid=""  d
	.q:'$d(^DHCINVPRT(prtRowid))
	.s data=$g(^DHCINVPRT(prtRowid))
	.s prtFlag=$p(data,"^",8)
	.s prtInitInvDR=$p(data,"^",13)
	.s prtOldInvDR=$p(data,"^",29)
	.s prtAcount=$p(data,"^",1)
	.s prtUser=$p(data,"^",21)
	.s UserName1=$p(^SSU("SSUSR",prtUser),"^",2)
	.s fairtype=$p(^DHCINVPRT(prtRowid),"^",34)
	.q:((UserName1["自助")&(fairtype="R"))
	.s prtCardAmt=..GetOPInvBankCardAmt(prtRowid)  ;病人自付金额(针对医保病人)
	.s formatHisCardAmt=..FormatAmtStr(+$g(prtCardAmt)) ;格式化金额
	.q:prtCardAmt="0.00" ;过滤自负金额为0的记录(金额为0不调用银行接口)
	.q:(+prtAcount<=0)  ;退费都退现金，所以过滤
    .s ipmSub="0",cardPayMFlag=0
    .f  s ipmSub=$o(^DHCINVPRT(prtRowid,"P",ipmSub)) q:((ipmSub="")!(cardPayMFlag=1))  d
    ..s payMDr=$p(^DHCINVPRT(prtRowid,"P",ipmSub),"^",1)
    ..s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s cardPayMFlag=1
    .q:cardPayMFlag=0   ;过滤非银医卡支付记录
    .s abortInvPayMFlag=0
    .i ((prtFlag="A")!(prtFlag="S")) d
    ..s abortInvDR=$o(^DHCINVPRT(0,"InitInvDR",prtRowid,""))
    ..s ipmSub="0"
    ..f  s ipmSub=$o(^DHCINVPRT(abortInvDR,"P",ipmSub)) q:((ipmSub="")!( abortInvPayMFlag=1))  d
    ...s payMDr=$p(^DHCINVPRT(abortInvDR,"P",ipmSub),"^",1)
    ...s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",payMDr)
	...i handDr'="" d
	....s abortInvPayMFlag=1
    .;q:abortInvPayMFlag=1   ;过滤作废记录
    .s oldAcount=0
	.i (prtOldInvDR'="") s oldAcount=$p(^DHCINVPRT(prtOldInvDR),"^",1)
	.q:(prtOldInvDR'="")&(oldAcount=prtAcount) ;过滤作废重打记录（作废重打时，支付方式不变，所以如果原支付方式是银医卡，重打记录的支付方式也是银医卡，但是没有调用银行接口）
	.s (tradeType,pan,cardType,trAmt,merSystrace,RRN,tid,mchid,batchNO,txnDatetradeType,pan,cardType,trAmt,merSystrace,RRN,tid,mchid,batchNO,txnDate,txnTime,appendInfo,txnTime,appendInfo,hospitaldr,myHospitalDr,hoscode)=""
	.i $d(^DHCINVBTPi(0,"S","IPDR",prtRowid))  d    ;发票记录存在银行交易记录
	..s IBPDR="0"
	..f  s IBPDR=$o(^DHCINVBTPi(0,"S","IPDR",prtRowid,IBPDR)) q:IBPDR=""  d
	...q:'$d(^DHCINVBTP(IBPDR))
	...s info=$g(^DHCINVBTP(IBPDR))
	...q:bankTradeType'=$p(info,"^",24) ;过滤非门诊交易记录
	...s rc=$p(info,"^",1)
	...q:rc'="00"
	...s rcDetail=$p(info,"^",2)
	...s pan=$p(info,"^",3)
	...s trAmt=$p(info,"^",4)
	...s merSystrace=$p(info,"^",5)
	...s invoiceNO=$p(info,"^",6)
	...s RRN=$p(info,"^",7)
	...s authNO=$p(info,"^",8)
	...s tid=$p(info,"^",9)
	...s mchid=$p(info,"^",10)
	...s batchNO=$p(info,"^",11)
	...s tellerNO=$p(info,"^",12)
	...s bankName=$p(info,"^",13)
	...s txnDate=$p(info,"^",14)
	...s txnTime=$p(info,"^",15)
	...s expDate=$p(info,"^",16)
	...s appendInfo=$p(info,"^",17)
	...s cardType=$p(info,"^",27)
	...s tradeType=$p(info,"^",26)
	...s hospital=$p(info,"^",28)
	...s hoscode=$p(^CT("HOSP",hospital),"^",1)
	...;i appendInfo="" s appendInfo=hoscode
	...s rtn=prtRowid_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	...d stream.WriteLine(rtn)
    .e  d   ;发票不存在银行交易记录
    ..;add tangtao 2011-06-30
	..s myHospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(prtUser)
	..s hoscode=$p(^CT("HOSP",myHospitalDr),"^",1)
    ..s trAmt=formatHisCardAmt ;
    ..i pan="" d
    ...i prtRowid'="" d
    ....s papmidr=$p(^DHCINVPRT(prtRowid),"^",15)
    ....s invdate=$p(^DHCINVPRT(prtRowid),"^",5)
    ....s invtime=$p(^DHCINVPRT(prtRowid),"^",20)
    ....s invdatetime=invdate*100000+invtime
    ....s cardrowid=""
    ....f  s cardrowid=$o(^DHCCARDi("CF",0,"PAPMIDR",papmidr,cardrowid),-1) q:cardrowid=""  d
    .....s actieflag=$p(^DHCCARD("CF",cardrowid),"^",10)
    .....s carddate=$p(^DHCCARD("CF",cardrowid),"^",7)
    .....s cardtime=$p(^DHCCARD("CF",cardrowid),"^",8)
    .....s carddatetime=carddate*100000+cardtime
    .....q:pan'=""
    .....i invdatetime>carddatetime d
    ......s pan=$p(^DHCCARD("CF",cardrowid),"^",2)
    ..;end
    ..s rtn=prtRowid_"|"_tradeType_"|"_pan_"|"_cardType_"|"_trAmt_"|"_merSystrace_"|"_RRN_"|"_tid_"|"_mchid_"|"_batchNO_"|"_txnDate_"|"_txnTime_"|"_appendInfo
	..d stream.WriteLine(rtn)
	.w rtn,!
	
	
	i ((stream.IsNull())&(bankTradeType="OP")) d
	.d stream.WriteLine("")
	
	q stream
	
ERROR1
	Set $ZT=""	
	s ErrorMsg=$ZE                  //$ZE 获取错误信息
	s ^TMPBankTradeErrorLog("BankTradeErrorLog",+$h,$p($h,",",2),tradeDate)=ErrorMsg
	s stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("")
	q stream
}

Query GetInvBankTrade(Stdate, Enddate, Sttime, EndTime) As %Query(ROWSPEC = "TPrtInv:%String,TPapmiNo:%String,TPapmiName:%String,TPrtAcount:%String,TPrtDate:%String,TPrtTime:%String,TStatus:%String,TDescpensing:%String,job:%String")
{
}

ClassMethod GetInvBankTradeExecute(ByRef qHandle As %Binary, Stdate, Enddate, Sttime, EndTime) As %Status
{
 	s repid=$I(^CacheTemp)
 	i (Stdate="")!(Enddate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
 	s ind=1
	s job=$j
	s Guser=$G(%session.Data("LOGON.USERID"))
	k ^TMP("InvBankTrage",Guser,job)
	i Stdate["/" s Stdate=$zdh(Stdate,4)
	i Enddate["/" s Enddate=$zdh(Enddate,4)
	i Sttime[":" s Sttime=$zth(Sttime,1)
	i EndTime[":" s EndTime=$zth(EndTime,1)
	s StDateTime=Stdate*100000+Sttime
    s EnddateTime=Enddate*100000+EndTime
	s PrtRowid="",Count=1,SumAmt=0,despensing=0
	f  s PrtRowid=$o(^DHCINVPRT(0,"User",Guser,PrtRowid))  q:PrtRowid=""  d
	.s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	.s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	.s PrtDateTime=PrtDate*100000+PrtTime
	.q:+$g(PrtDateTime)<+$g(StDateTime)
	.q:+$g(PrtDateTime)>+$g(EnddateTime)            ;取时间段内的交易记录
	.s PrtPapmidr=$p(^DHCINVPRT(PrtRowid),"^",15)
	.s PapmiName=$p(^PAPER(PrtPapmidr,"ALL"),"^",1)
	.s PapmiNo=$p(^PAPER(PrtPapmidr,"PAT",1),"^",2)
	.s PrtAcount=$p(^DHCINVPRT(PrtRowid),"^",1)
	.q:+$g(PrtAcount)<0
	.s PrtOldInvDR=$p(^DHCINVPRT(PrtRowid),"^",29)
	.s oldAcount=0
	.i (PrtOldInvDR'="") d
	..i ($d(^DHCINVPRT(0,"OldINV",PrtOldInvDR))) d
	...s oldAcount=$p(^DHCINVPRT(PrtOldInvDR),"^",1)
	.q:(PrtOldInvDR'="")&(oldAcount=PrtAcount) ;过滤作废重打记录（作废重打时，支付方式不变，所以如果原支付方式是银医卡，重打记录的支付方式也是银医卡，但是没有调用银行接口）
	.s PrtInv=$p(^DHCINVPRT(PrtRowid),"^",14)
	.s PaymSub="",BankTradeFlag=0,PrtAcount1=0,PrtAcount1=""
	.f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:PaymSub=""  d
	..s PayModedr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
	..s PayModeCode=$p(^CT("CTPM",PayModedr),"^",1)
	..s PayModeAmt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
	..q:((+$g(PayModeAmt)=0)&((PayModeCode="CASH")!(PayModeCode["CARD")))
	..s PayModeDesc=$p(^CT("CTPM",PayModedr),"^",2)
	..i PayModeDesc["CPP"  s PayModeDesc=$p(PayModeDesc,"CPP",2)
	..i PrtAcount1="" s PrtAcount1="总额:"_PrtAcount_" ("_PayModeDesc_":"_+$g(PayModeAmt)_")"
	..e  s PrtAcount1=PrtAcount1_"("_PayModeDesc_":"_+$g(PayModeAmt)_")"
	..q:((PayModeCode'="CARD1")&(PayModeCode'="CARD2")&(PayModeCode'="CPPCARD1")&(PayModeCode'="CPPCARD2"))
	..s BankTradeFlag=BankTradeFlag+1
	.q:+BankTradeFlag=0
	.s BandTradeSub=""
	.i $d(^DHCINVBTPi(0,"S","IPDR",PrtRowid))  d    ;发票记录存在银行交易记录
	..s PrtDate=$zd(PrtDate,3),PrtTime=$zt(PrtTime,1)
	..s Status="HIS成功,银行成功!"
	..s despensing=despensing+1
    ..d outputrow1
	.e  d    ;发票记录不存在银行交易记录
	..s PrtDate=$zd(PrtDate,3),PrtTime=$zt(PrtTime,1)
	..s Status="HIS成功,银行不成功,请注意核对发票金额!"
	..s ^TMP("InvBankTrage",Guser,job,Count)=PrtInv_"^"_PapmiNo_"^"_PapmiName_"^"_PrtAcount1_"^"_PrtDate_"^"_PrtTime
	..s Count=Count+1
	..s despensing=despensing+1
	..s SumAmt=SumAmt+PrtAcount
    ..d outputrow1
    s PrtAcount1=SumAmt
    s ^TMP("InvBankTrage",Guser,job,Count)=""_"^"_"合计"_"^"_""_"^"_PrtAcount1_"^"_""_"^"_""
    s qHandle=$lb(0,repid,0)
    quit $$$OK
outputrow1
	set Data=$lb(PrtInv,PapmiNo,PapmiName,PrtAcount1,PrtDate,PrtTime,Status,despensing,job)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInvBankTradeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvBankTradeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetInvBankTradeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvBankTradeExecute ]
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

ClassMethod GetInvBankNum(Guser, job)
{
	s num=$o(^TMP("InvBankTrage",Guser,job,""),-1)
	q num
}

ClassMethod GetInvBankData(Guser, job, num)
{
	s str=^TMP("InvBankTrage",Guser,job,num)
	q str
}

ClassMethod JudgeInvBankAcount(StDate, EndDate, HisStartTime, HisEndTime, BankStartTime, BankEndTime, RecDr, PayModeStr, Hospital)
{
	s PrtDate=""
	s job=$j
	s Guser=1
	k ^TMP("JudgeInvBankAcount",Guser,job)
	q:RecDr=""
	;s Guser=$G(%session.Data("LOGON.USERID"))
	s countcard1=1,countcard2=1
	f PrtDate=StDate:1:EndDate d
	.s HisId=""
	.f  s HisId=$o(^DHCOPInsFootI(0,"Date",PrtDate,HisId)) q:HisId=""  d
	..q:$d(^DHCOPInsFoot(HisId))=10
	..s FootFlag=$p($g(^DHCOPInsFoot(HisId)),"^",15)      ;HIS_INSFootUser
	..s FootDr=$p($g(^DHCOPInsFoot(HisId)),"^",67)        ;HIS_ReportNote
	..q:(RecDr'="")&(RecDr'[FootDr)
	..s FootDate=$p($g(^DHCOPInsFoot(HisId)),"^",13) 
	..s FootTime=$p($g(^DHCOPInsFoot(HisId)),"^",14)
	..s Hospitaldr=$p($g(^DHCOPInsFoot(HisId)),"^",66)
	..q:(+$g(Hospital)'=+$g(Hospitaldr))&(Hospital'="")
	..s prtRowid=""
	..f  s prtRowid=$o(^DHCINVPRT(0,"Report",HisId,prtRowid)) q:prtRowid=""  d
	...q:'$d(^DHCINVPRT(prtRowid))
	...s data=$g(^DHCINVPRT(prtRowid))
	...s prtFlag=$p(data,"^",8)
	...s prtInitInvDR=$p(data,"^",13)
	...s prtOldInvDR=$p(data,"^",29)
	...s prtAcount=$p(data,"^",1)
	...s PrtInv=$p(data,"^",14)
	...q:(+prtAcount<=0)  ;退费都退现金，所以过滤
	...s prtUser=$p(data,"^",21)
	...s prtUsername=$p(^SSU("SSUSR",prtUser),"^",2)
	...s prtpapmidr=$p(data,"^",15)
	...s PapmiName=$p(^PAPER(prtpapmidr,"ALL"),"^",1)
	...s PapmiNo=$p(^PAPER(prtpapmidr,"PAT",1),"^",2)
	...s PrtDate=$p(^DHCINVPRT(prtRowid),"^",5)
	...s PrtTime=$p(^DHCINVPRT(prtRowid),"^",20)
	...q:(PrtDate="62272")&(PrtTime<"86399")
	...q:(PrtDate="62273")&(PrtTime<"20290")
	...s userflag=0
	...i $d(^DHCINVPRT(0,"InitInvDR",prtRowid)) d
	....s abortInvDR=$o(^DHCINVPRT(0,"InitInvDR",prtRowid,""))
	....q:abortInvDR=""
	....s user1=$p(^DHCINVPRT(abortInvDR),"^",21)
	....s acount1=0-$p($g(^DHCINVPRT(abortInvDR)),"^",1)
	....s prtUsername1=$p(^SSU("SSUSR",user1),"^",2)
	....i (prtUsername1["自助")&(prtAcount=acount1) s userflag=1
	...q:userflag=1
	...s prtCardAmt=..GetOPInvBankCardAmt(prtRowid)  ;病人自付金额(针对医保病人)
	...q:prtCardAmt="0.00" ;过滤自负金额为0的记录(金额为0不调用银行接口)
    ...s ipmSub="0",cardPayMFlag=0,PayModeCode="CARD"
    ...f  s ipmSub=$o(^DHCINVPRT(prtRowid,"P",ipmSub)) q:((ipmSub="")!(cardPayMFlag=1))  d
    ....s payMDr=$p(^DHCINVPRT(prtRowid,"P",ipmSub),"^",1)
	....s PayModeAmt=$p(^DHCINVPRT(prtRowid,"P",ipmSub),"^",3)
	....s PayModeCode=$p(^CT("CTPM",payMDr),"^",1)
	....q:(PayModeStr'[PayModeCode)&(PayModeStr'="")
	....q:((+$g(PayModeAmt)=0)&(PayModeCode["CARD"))
	....i PayModeCode["CARD" s PayModeCode=$p(PayModeCode,"CPP",2)
	....s cardPayMFlag=1
    ...q:cardPayMFlag=0   ;过滤非银医卡支付记录
    ...s abortInvPayMFlag=0
    ...s oldAcount=0
	...i (prtOldInvDR'="") d
	....s oldAcount=$p(^DHCINVPRT(prtOldInvDR),"^",1)
	...q:(prtOldInvDR'="")&(oldAcount=prtAcount) ;过滤作废重打记录（作废重打时，支付方式不变，所以如果原支付方式是银医卡，重打记录的支付方式也是银医卡，但是没有调用银行接口）
	...i '$d(^DHCINVBTPi(0,"S","IPDR",prtRowid))  d    ;发票记录存在银行交易记录
    ....i PayModeCode["CARD1" d
    .....s ^TMP("JudgeInvBankAcount",Guser,job,PayModeCode,countcard1)=prtRowid_"^"_PrtInv_"^"_PapmiNo_"^"_PapmiName_"^"_prtAcount_"^"_$zd(PrtDate,3)_"^"_$zt(PrtTime,1)_"^"_prtUsername
    .....s countcard1=countcard1+1
    ....i PayModeCode["CARD2" d
    .....s ^TMP("JudgeInvBankAcount",Guser,job,PayModeCode,countcard2)=prtRowid_"^"_PrtInv_"^"_PapmiNo_"^"_PapmiName_"^"_prtAcount_"^"_$zd(PrtDate,3)_"^"_$zt(PrtTime,1)_"^"_prtUsername
    .....s countcard2=countcard2+1
    q
}

Query GetInvBankTradeAll(Stdate, Enddate) As %Query(ROWSPEC = "TPrtInv:%String,TPapmiNo:%String,TPapmiName:%String,TPrtAcount:%String,TPrtDate:%String,TPrtTime:%String,TStatus:%String,TDescpensing:%String,job:%String,TUserName:%String,TPrtFlag:%String,TPrtRowid:%String,THospitalDesc:%String")
{
}

ClassMethod GetInvBankTradeAllExecute(ByRef qHandle As %Binary, Stdate, Enddate) As %Status
{
 	s repid=$I(^CacheTemp)
 	i (Stdate="")!(Enddate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
 	s ind=1
	s job=$j
	s Guser=$G(%session.Data("LOGON.USERID"))
	s CTLocDr=$G(%session.Data("LOGON.CTLOCID"))
	k ^TMP("InvBankTrageAll",Guser,job)
	i Stdate["/" s Stdate=$zdh(Stdate,4)
	i Enddate["/" s Enddate=$zdh(Enddate,4)
	s Count=1,SumAmt=0,despensing=0
    s PrtFlag=""
    f PrtInvDate=Stdate:1:Enddate d
	.s PrtRowid=""
	.f  s PrtRowid=$o(^DHCINVPRT(0,"Date",PrtInvDate,PrtRowid))  q:PrtRowid=""  d
	..s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)
	..s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)
	..s PrtPapmidr=$p(^DHCINVPRT(PrtRowid),"^",15)
	..s PapmiName=$p(^PAPER(PrtPapmidr,"ALL"),"^",1)
	..s PapmiNo=$p(^PAPER(PrtPapmidr,"PAT",1),"^",2)
	..s PrtAcount=$p(^DHCINVPRT(PrtRowid),"^",1)
	..q:+$g(PrtAcount)<0
	..s PrtOldInvDR=$p(^DHCINVPRT(PrtRowid),"^",29)
    ..s fairtype=$p(^DHCINVPRT(PrtRowid),"^",34)
    ..s PrtUser=$p(^DHCINVPRT(PrtRowid),"^",21)
    ..s UserName=$p(^SSU("SSUSR",PrtUser),"^",2)
    ..s PrtPrintFlag=$p(^DHCINVPRT(PrtRowid),"^",3)
    ..s PrtAccInv=$p(^DHCINVPRT(PrtRowid),"^",4)
    ..s HospitalDr=$p(^DHCINVPRT(PrtRowid),"^",39)
    ..s CTLocHosDr=$p(^CTLOC(CTLocDr),"^",22)
    ..i +$g(HospitalDr)=0 s HospitalDr=1
    ..q:((CTLocHosDr'=HospitalDr)&(CTLocHosDr'="")&(HospitalDr'=""))
    ..s HospitalDesc=$p(^CT("HOSP",HospitalDr),"^",2)
    ..s PrtFlag="PRT"
    ..i PrtPrintFlag="N" s PrtFlag="API"
    ..i ((PrtPrintFlag="P")&(PrtAccInv'="")) s PrtFlag="API"
    ..q:((UserName["自助")&(fairtype="R"))
    ..;s initacount=0
    ..;i ($d(^DHCINVPRT(0,"InitInvDR",PrtRowid)))&(fairtype="R") d
    ...;s initrowid=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,""))
    ...;s initacount=$p(^DHCINVPRT(initrowid),"^",1)
    ..;q:(PrtAcount+initacount=0)
	..s oldAcount=0
	..i (PrtOldInvDR'="") d
	...;i ($d(^DHCINVPRT(0,"OldINV",PrtOldInvDR))) d
	...s oldAcount=$p(^DHCINVPRT(PrtOldInvDR),"^",1)
	..q:(PrtOldInvDR'="")&(oldAcount=PrtAcount) ;过滤作废重打记录（作废重打时，支付方式不变，所以如果原支付方式是银医卡，重打记录的支付方式也是银医卡，但是没有调用银行接口）
	..s PrtInv=$p(^DHCINVPRT(PrtRowid),"^",14)
	..s PaymSub="",BankTradeFlag=0,PrtAcount1=0,PrtAcount1="",PrtAcountCardAmt=0
	..f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:PaymSub=""  d
	...s PayModedr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
	...s PayModeCode=$p(^CT("CTPM",PayModedr),"^",1)
	...s PayModeAmt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
	...q:((+$g(PayModeAmt)=0)&((PayModeCode="CASH")!(PayModeCode["CARD")))
	...s PayModeDesc=$p(^CT("CTPM",PayModedr),"^",2)
	...i PayModeDesc["CPP"  s PayModeDesc=$p(PayModeDesc,"CPP",1)
	...i PrtAcount1="" s PrtAcount1="总额:"_$fn(PrtAcount,"",2)_" ("_PayModeDesc_":"_$fn(+$g(PayModeAmt),"",2)_")"
	...e  s PrtAcount1=PrtAcount1_"("_PayModeDesc_":"_$fn(+$g(PayModeAmt),"",2)_")"
	...q:((PayModeCode'="CARD1")&(PayModeCode'="CARD2")&(PayModeCode'="CPPCARD1")&(PayModeCode'="CPPCARD2"))
	...s PrtAcountCardAmt=PayModeAmt
	...s BankTradeFlag=BankTradeFlag+1
	..q:+BankTradeFlag=0
	..s BandTradeSub=""
	..i $d(^DHCINVBTPi(0,"S","IPDR",PrtRowid))  d    ;发票记录存在银行交易记录
	...s PrtDate=$zd(PrtDate,3),PrtTime=$zt(PrtTime,1)
	...s Status="HIS成功,银行成功!"
	...;s despensing=despensing+1
    ...;d outputrowall
	..e  d    ;发票记录不存在银行交易记录
	...s PrtDate=$zd(PrtDate,3),PrtTime=$zt(PrtTime,1)
	...s Status="HIS成功,银行不成功,请注意核对发票金额!"
	...s ^TMP("InvBankTrageAll",Guser,job,Count)=PapmiName_"^"_PapmiNo_"^"_PrtInv_"^"_PrtAcount1_"^"_PrtDate_"^"_PrtTime_"^"_UserName_"^"_PrtFlag_"^"_PrtRowid_"^"_HospitalDr
	...s Count=Count+1
	...s despensing=despensing+1
	...s SumAmt=SumAmt+PrtAcountCardAmt
    ...d outputrowall
    s PrtAcount1=SumAmt
    s ^TMP("InvBankTrageAll",Guser,job,Count)="合计"_"^"_""_"^"_""_"^"_PrtAcount1_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
    s PrtInv="",PapmiNo="",PapmiName="合计",PrtDate="",PrtTime="",Status="",despensing="",UserName="",PrtFlag="",PrtRowid="",HospitalDesc=""
    d outputrowall
    d ..OrderCardType(Guser,job)
    s qHandle=$lb(0,repid,0)
    quit $$$OK
outputrowall
	set Data=$lb(PrtInv,PapmiNo,PapmiName,PrtAcount1,PrtDate,PrtTime,Status,despensing,job,UserName,PrtFlag,PrtRowid,HospitalDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetInvBankTradeAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvBankTradeAllExecute ]
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

ClassMethod GetInvBankTradeAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvBankTradeAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetInvBankAllNum(Guser, job)
{
	s num=$o(^TMP("InvBankTrageAll",Guser,job,""),-1)
	q num
}

ClassMethod GetInvBankAllData(Guser, job, num)
{
	s str=^TMP("InvBankTrageAll",Guser,job,num)
	q str
}

ClassMethod OrderCardType(Guser, job)
{
	s rowid=""
	k ^TMP("InvBankTrageAllHos",Guser,job)
	s count=1
	f  s rowid=$o(^TMP("InvBankTrageAll",Guser,job,rowid)) q:rowid=""  d
	.s str=^TMP("InvBankTrageAll",Guser,job,rowid)
	.s hospitaldr=$p(str,"^",10)
	.i hospitaldr="" s hospitaldr=1
	.s cardtype=""
	.i str["银医卡" s cardtype="银医卡"
	.i str["院内卡" s cardtype="院内卡"
	.q:str["合计"
	.s ^TMP("InvBankTrageAllHos",Guser,job,hospitaldr,cardtype,count)=str
	.s count=count+1
	k ^TMP("InvBankTrageAll",Guser,job)
	s hosrowid="",count=1
	f  s hosrowid=$o(^TMP("InvBankTrageAllHos",Guser,job,hosrowid)) q:hosrowid=""  d
	.s cardtype=""
	.f  s cardtype=$o(^TMP("InvBankTrageAllHos",Guser,job,hosrowid,cardtype)) q:cardtype=""  d
	..s rowid="",sum=0
	..f  s rowid=$o(^TMP("InvBankTrageAllHos",Guser,job,hosrowid,cardtype,rowid)) q:rowid=""  d
	...s hospitaldr=$p(^TMP("InvBankTrageAllHos",Guser,job,hosrowid,cardtype,rowid),"^",10)
	...s hospitaldesc=$p(^CT("HOSP",hospitaldr),"^",2)
	...s ^TMP("InvBankTrageAll",Guser,job,count)=^TMP("InvBankTrageAllHos",Guser,job,hosrowid,cardtype,rowid)
	...s $p(^TMP("InvBankTrageAll",Guser,job,count),"^",10)=hospitaldesc
	...s PrtRowid=$p(^TMP("InvBankTrageAllHos",Guser,job,hosrowid,cardtype,rowid),"^",9)
	...;s PrtAcount=$p(^DHCINVPRT(PrtRowid),"^",1)
	...s PaymSub=0
	...f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:((PaymSub="")!(PaymSub=0))  d
	....s paymdr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
	....s paymcode=$p(^CT("CTPM",paymdr),"^",1)
	....i paymcode["CARD" d
	.....s paymamt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
	.....s sum=+$g(sum)++$g(paymamt)
	...s count=count+1
	..s ^TMP("InvBankTrageAll",Guser,job,count)="合计"_"^"_""_"^"_""_"^"_sum_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	..s count=count+1
	k ^TMP("InvBankTrageAllHos",Guser,job)
	q
}

/// 2011-11-06
/// tangtao
/// 根据发票串获取发票信息
/// 返回发票rowid，POS金额，发票日期时间，交易参考号，原交易时间
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("C",19492863,"")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("C",19759181,"")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D",19027418,19027419)
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D","",19493050)
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("R","","19028397")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("R","19028063","")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D","",19028253)
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D","",19796568)
ClassMethod OrderInvPrtold(tradeType, InvStr, AorSPrt)
{
	n (tradeType, InvStr, AorSPrt)
    s PrtStr=-1
    s ^TMP("tt")=tradeType_","_InvStr_","_AorSPrt

    s HospitalDr=""
    i tradeType="C" d
    .q:InvStr="" 
	.q:InvStr="0"
    .s PrtUser=$p(^DHCINVPRT(InvStr),"^",21)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	e  d
	.q:+AorSPrt=0
	.s PrtUser=$p(^DHCINVPRT(AorSPrt),"^",21)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	;
	i InvStr'="" d
    .s PrtDate=$p(^DHCINVPRT(InvStr),"^",5)
	.s PrtTime=$p(^DHCINVPRT(InvStr),"^",20)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    e  d
    .s PrtDate=$p(^DHCINVPRT(AorSPrt),"^",5)
	.s PrtTime=$p(^DHCINVPRT(AorSPrt),"^",20)
	.s InitRowid=$p(^DHCINVPRT(AorSPrt),"^",13)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    s PaymAmt=..GetOPInvBankCardAmt(InvStr_"|"_AorSPrt)
    ;
    ;生成HIS端交易号
	s myExpStr=""_"^"_InvStr_"|"_AorSPrt
	s TradeInfo=..SetTradeID("",tradeType,HospitalDr,myExpStr)
	s err=$p(TradeInfo,"^",1)
	s IBPRowID=$p(TradeInfo,"^",2)
	s HISTradeID=$p(TradeInfo,"^",3)
    s (IBPRRN,OldTradeDate)=""
    i +AorSPrt'=0 d
	.s InitInvDR=$p(^DHCINVPRT(AorSPrt),"^",13)	;原发票Rowid
	.s OldBankTradePayDR=..GetOriginalTradeRowID(InitInvDR) 
	.s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	.s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	.i OldHISTradeID="" d
	..s OldHISTradeID=OldBankTradePayDR
	.s tmp=$g(^DHCINVBTP(OldHISTradeID))
	.s IBPRRN=$p(tmp,"^",7)
	.s OldTradeDate=$p(tmp,"^",14)
    ;
    ;
    i tradeType="C" s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"16"
	i ((tradeType="D")!(tradeType="R")) d
	.s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_AorSPrt_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"16"
    q PrtStr
    /*
    i tradeType="C" d
	.q:InvStr="" 
	.q:InvStr="0"
	.q:$d(^DHCINVPRT(InvStr))=0
	.s PrtUser=$p(^DHCINVPRT(InvStr),"^",21)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.i HospitalDr="" s HospitalDr="1"
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	.s PrtDate=$p(^DHCINVPRT(InvStr),"^",5)
	.s PrtTime=$p(^DHCINVPRT(InvStr),"^",20)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
	.s sub=""
	.f  s sub=$o(^DHCINVPRT(InvStr,"P",sub)) q:sub=""  d
	..q:sub=0
	..s PayMode=$p(^DHCINVPRT(InvStr,"P",sub),"^",1)
	..s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PayMode)
	..i handDr'="" d
	...s PaymAmt=$p(^DHCINVPRT(InvStr,"P",sub),"^",3)
	...;s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_PrtDate_PrtTime_InvStr
	...s NowDate=$e($tr($zd(+$h,3),"-"),5,8),NowTime=$tr($zt($p($h,",",2),1),":")
	...s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"16"
    
    ;R或D状态有两种情况,软POS和WS，软POS里撤销消费时重一笔、退一笔，退货是退差额.
    ;当撤销消费的时候，R状态情况下，InvStr为负票的id，AorSPrt为空。
    ;为了可与WS退差额统一下面加了判断、重新赋值.
    ;
    ;R状态仅为当日全退使用，D状态为部分退费和隔日退费使用
    ;Sub子表保存正负记录rowid，与WS统一
	i ((tradeType="D")!(tradeType="R")) d
	.q:AorSPrt="0"
	.s AorSPrt1=AorSPrt
	.i AorSPrt="" s AorSPrt=InvStr
	.q:$d(^DHCINVPRT(AorSPrt))=0
	.s PrtUser=$p(^DHCINVPRT(AorSPrt),"^",21)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.i HospitalDr="" s HospitalDr="1"
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	.s PrtDate=$p(^DHCINVPRT(AorSPrt),"^",5)
	.s PrtTime=$p(^DHCINVPRT(AorSPrt),"^",20)
	.s InitRowid=$p(^DHCINVPRT(AorSPrt),"^",13)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
	.s sub=""
	.f  s sub=$o(^DHCINVPRT(AorSPrt,"P",sub)) q:sub=""  d
	..q:sub=0
	..s PayMode=$p(^DHCINVPRT(AorSPrt,"P",sub),"^",1)
	..s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PayMode)
	..i handDr'="" d
	...s PaymAmt=$p(^DHCINVPRT(AorSPrt,"P",sub),"^",3)
	...s PaymAmt=$zabs(PaymAmt)
	...s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1
    .i ((InvStr'="")&(AorSPrt1'="")) d
	..;正常票
	..s sub=""
	..f  s sub=$o(^DHCINVPRT(InvStr,"P",sub)) q:sub=""  d
	...q:sub=0
	...s PayMode=$p(^DHCINVPRT(InvStr,"P",sub),"^",1)
	...s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PayMode)
	...i handDr'="" d
	....s PaymAmt1=$p(^DHCINVPRT(InvStr,"P",sub),"^",3)
	....s PaymAmt=PaymAmt-PaymAmt1
	....s $p(PrtStr,"#",2)=PaymAmt
	
	
	
	
	.s IBPRowid="",IBPRRN="",OldTradeDate=""
	.i InitRowid'="" d
	..f  s IBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",InitRowid,IBPRowid)) q:IBPRowid=""  d
	...q:IBPRowid=0
	...s IBSSub=""
	...f  s IBSSub=$o(^DHCINVBTPi(0,"S","IPDR",InitRowid,IBPRowid,"C",IBSSub)) q:IBSSub=""  d
	....q:IBSSub=0
	....s IBPRRN=$p(^DHCINVBTP(IBPRowid),"^",7)
	....s OldTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)
	.;1、防止作废重打的情况下，取不到原交易参考号，2、多次退费的情况下取最开始的交易参考号(应当有次数限制、现在支持多次)
	.s InitialRowid=""
	.i InitRowid'="" s InitialRowid=$p(^DHCINVPRT(InitRowid),"^",29)
	.i (InitialRowid'="") d
	..s RetStr=..GetIBPRRN(InitialRowid)
	..i RetStr'="^" d
	...s IBPRRN=$p(RetStr,"^",1)
	...s OldTradeDate=$p(RetStr,"^",2)
	.s NowDate=$e($tr($zd(+$h,3),"-"),5,8),NowTime=$tr($zt($p($h,",",2),1),":")
	.s PrtStr=PrtStr_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_AorSPrt_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"16"
	*/
}

/// 2011-11-06
/// tangtao
/// 根据发票串获取发票信息
/// 返回发票rowid，POS金额，发票日期时间，交易参考号，原交易时间
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("C",19028387,"")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D",19027418,19027419)
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D","",19028148)
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("R","","1771457")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("R","19028063","")
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D","",19028253)
/// w ##class(web.DHCBillBankLogic).OrderInvPrt("D","",20393342)
ClassMethod OrderInvPrt(tradeType, InvStr, AorSPrt)
{
	n (tradeType, InvStr, AorSPrt)
    s PrtStr=-1
    s ^TMP("tt")=tradeType_","_InvStr_","_AorSPrt   ;AorSPrt
    s HospitalDr=""
    i tradeType="C" d
    .q:InvStr="" 
	.q:InvStr="0"
    .s PrtUser=$p(^DHCINVPRT(InvStr),"^",21)
	.s HospitalDr=$p(^DHCINVPRT(InvStr),"^",39)
	.;s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	.s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospitalDr) 
	e  d
	.q:+AorSPrt=0
	.s PrtUser=$p(^DHCINVPRT(AorSPrt),"^",21)
	.s HospitalDr=$p(^DHCINVPRT(AorSPrt),"^",39)
	.s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospitalDr)
	;
	i InvStr'="" d
    .s PrtDate=$p(^DHCINVPRT(InvStr),"^",5)
	.s PrtTime=$p(^DHCINVPRT(InvStr),"^",20)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    e  d
    .s PrtDate=$p(^DHCINVPRT(AorSPrt),"^",5)
	.s PrtTime=$p(^DHCINVPRT(AorSPrt),"^",20)
	.s InitRowid=$p(^DHCINVPRT(AorSPrt),"^",13)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    s PaymAmt=..GetOPInvBankCardAmt(InvStr_"|"_AorSPrt)
    ;
    ;生成HIS端交易号
	s myExpStr=""_"^"_InvStr_"|"_AorSPrt
	s TradeInfo=..SetTradeID("",tradeType,HospitalDr,myExpStr)
	s err=$p(TradeInfo,"^",1)
	s IBPRowID=$p(TradeInfo,"^",2)
	s HISTradeID=$p(TradeInfo,"^",3)
    s (IBPRRN,OldTradeDate)=""
    i +AorSPrt'=0 d
	.s InitInvDR=$p(^DHCINVPRT(AorSPrt),"^",13)	;原发票Rowid
	.b ;ljlj
	.;s OldBankTradePayDR=..GetOriginalTradeRowID(InitInvDR)
	.s OrgPrtRowID=##class(web.DHCBillBMCLogic).GetCurrentOrgPrtRowID(AorSPrt,InvStr,"",tradeType)
	.;s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",OrgPrtRowID,"0"))
	.;
	.s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	.b ;lhlh
	.s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	.b ;hlhl
	.i OldHISTradeID="" d
	..s OldHISTradeID=OldBankTradePayDR
	.s tmp=$g(^DHCINVBTP(OldHISTradeID))
	.s IBPRRN=$p(tmp,"^",7)
	.s OldTradeDate=$p(tmp,"^",14)
    ;
    ;
    i tradeType="C" s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"16"
	i ((tradeType="D")!(tradeType="R")) d
	.s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_AorSPrt_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"16"
    q PrtStr
}

/// tangtao 
/// 2011-12-07
/// 根据预交金rowid生成POS交易流水号和传参
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("R","","710486")
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("R","","710535")
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("C","710487","")
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("D","","710486")
ClassMethod OrderIPDEPPrtOLD(tradeType, InvStr, AorSPrt)
{
	n (tradeType, InvStr, AorSPrt)
    s PrtStr=-1
    s ^TMP("tt")=tradeType_","_InvStr_","_AorSPrt

    s HospitalDr=""
    i tradeType="C" d
    .q:InvStr="" 
	.q:InvStr="0"
    .s PrtUser=$p(^DHCSFPRINTDETAIL(InvStr),"^",14)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	e  d
	.q:+AorSPrt=0
	.s PrtUser=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",14)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	;
	i InvStr'="" d
    .s PrtDate=$p(^DHCSFPRINTDETAIL(InvStr),"^",2)
	.s PrtTime=$p(^DHCSFPRINTDETAIL(InvStr),"^",3)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    e  d
    .s PrtDate=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",2)
	.s PrtTime=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",3)
	.s InitRowid=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",7)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    s PaymAmt=..GetIPDepBankCardAmt(InvStr_"|"_AorSPrt)
    ;
    ;生成HIS端交易号
	s myExpStr=""_"^"_InvStr_"|"_AorSPrt
	s TradeInfo=..SetTradeID("",tradeType,HospitalDr,myExpStr)
	s err=$p(TradeInfo,"^",1)
	s IBPRowID=$p(TradeInfo,"^",2)
	s HISTradeID=$p(TradeInfo,"^",3)
    s (IBPRRN,OldTradeDate)=""
    
    
    i +AorSPrt'=0 d
    
    .s PrtStatus=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",8)
    .i PrtStatus=3 d
	..s InitInvNo=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",7)	;原预交金收据号
	..s InitInvDR=$o(^DHCSFPRINTDETAIL(0,"RcptNo",InitInvNo,""))
	..s OldBankTradePayDR=..GetDEPOriginalTradeRowID(InitInvDR)
	..s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	..s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	..i OldHISTradeID="" d
	...s OldHISTradeID=OldBankTradePayDR
	..s tmp=$g(^DHCINVBTP(OldHISTradeID))
	..s IBPRRN=$p(tmp,"^",7)
	..s OldTradeDate=$p(tmp,"^",14)
	.i PrtStatus=2 d
	..s OldBankTradePayDR=..GetDEPOriginalTradeRowID(AorSPrt)
	..s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	..s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	..i OldHISTradeID="" d
	...s OldHISTradeID=OldBankTradePayDR
	..s tmp=$g(^DHCINVBTP(OldHISTradeID))
	..s IBPRRN=$p(tmp,"^",7)
	..s OldTradeDate=$p(tmp,"^",14)
    ;
    ;
    i tradeType="C" s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"
	i ((tradeType="D")!(tradeType="R")) d
	.s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_AorSPrt_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"
    
    q PrtStr
}

/// tangtao 
/// 2011-12-07
/// 根据住院发票rowid生成POS交易流水号和传参
/// 需要注意的是省立出院结算的时候只退POS金额,不收软POS,所以这里有一个需要注意的地方就是
/// DHC_INVBankTradePay表里面的IBPTradeType是根据AR_RcptPayMode中退的软POS的TradeType来确定的.
/// 有当日退费 R 状态和隔日退货及当日部分退为退货 D状态。
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("280033",^TMP("tt"),"")
/// ^TMP("tt")="软POS^500^10011112152201000656-500-622848*********8514&软POS^600^10011112160936000657-600-622848*********8514&软POS^1000^10011112152200000655-1000-622848*********8514"
/// 280033
/// ^TMP("tt")="软POS^5000^10011202291436004705-5000-622150*********2834"
ClassMethod OrderIPInvPrt(InvStr, POSTradeNoStr, CARDCPPTradeNoStr)
{
	n (InvStr,POSTradeNoStr,CARDCPPTradeNoStr)
    s PrtStr=""
	s ^TMP("tt",121)=InvStr_","_POSTradeNoStr_","_CARDCPPTradeNoStr
	
    s PrtUser=$p(^DHCINVPRTZY(InvStr),"^",7)
	s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)

    s PaymAmtStr=..GetIPInvBankCardAmt(InvStr)
    s tradeType=""
    i POSTradeNoStr'="" d
    .s POSStrLen=$l(POSTradeNoStr,"&")
    .f i=1:1:POSStrLen d
    ..q:($p(POSTradeNoStr,"&",i))=""
    ..s TradeNo=$p($p($p(POSTradeNoStr,"&",i),"^",3),"-",1)
    ..s IBPRowid=$o(^DHCINVBTPi(0,"PTN",TradeNo,""))
    ..s PrtDate=$p(^DHCINVBTP(IBPRowid),"^",21)
    ..s PrtTime=$p(^DHCINVBTP(IBPRowid),"^",22)
    ..s IBPRRN=$p(^DHCINVBTP(IBPRowid),"^",7)
    ..s OldTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)
    ..s IPRcptSub=$o(^DHCIPRCPTBANKTRADESUB(IBPRowid,"IPRcpt",""),-1)
    ..s PrePrtDr=$p(^DHCIPRCPTBANKTRADESUB(IBPRowid,"IPRcpt",IPRcptSub),"^",3)
    ..s ARRCPPayRowid=$p($p(PaymAmtStr,"&",i),"^",3)
    ..s PaymAmt=$p($p(PaymAmtStr,"&",i),"^",1)
    ..s JudgeFlag=##class(web.DHCBillBankLogic).JudgeIPINVDEPDate(PrePrtDr,ARRCPPayRowid)
    ..i JudgeFlag=1 s tradeType="R"
    ..i JudgeFlag=2 s tradeType="D"

    ..;生成HIS端交易号
	..s myExpStr=""_"^"_PrePrtDr_"|"_""
	..s TradeInfo=..SetTradeID("",tradeType,HospitalDr,myExpStr)
	..s err=$p(TradeInfo,"^",1)
	..s IBPRowID=$p(TradeInfo,"^",2)
	..s HISTradeID=$p(TradeInfo,"^",3)
    ..s PrtDate=$p(^DHCINVBTP(IBPRowID),"^",21)
    ..s PrtTime=$p(^DHCINVBTP(IBPRowID),"^",22)
	..s PrtDate1=$zd(PrtDate,8)
	..s PrtTime1=$tr($zt(PrtTime,1),":")
	..i ((tradeType="D")!(tradeType="R")) d
	...i PrtStr="" s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"_"&"_tradeType_"&"_PrePrtDr_"&"_ARRCPPayRowid
	...e  s PrtStr=PrtStr_"^"_InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"_"&"_tradeType_"&"_PrePrtDr_"&"_ARRCPPayRowid
    ..e  s PrtStr=-1
    
    q PrtStr
}

/// tangtao
/// 2011-11-28
/// 多次循环取第一次的交易参考号
ClassMethod GetIBPRRN(InitRowid)
{
	s IBPRRN="",OldTradeDate=""
	while(InitRowid'=""){
		s IBPRowid=""
		f  s IBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",InitRowid,IBPRowid)) q:IBPRowid=""  d      
		.q:IBPRowid=0
		.s IBSSub=""
		.f  s IBSSub=$o(^DHCINVBTPi(0,"S","IPDR",InitRowid,IBPRowid,"C",IBSSub)) q:IBSSub=""  d
		..q:IBSSub=0
		..s IBPRRN=$p(^DHCINVBTP(IBPRowid),"^",7)
		..s OldTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)
		s InitRowid=$p(^DHCINVPRT(InitRowid),"^",29)
	}
	q IBPRRN_"^"_OldTradeDate
}

/// Creator：  tangtao
/// Date：     2011-11-06
/// Function： 保存POS返回数据
/// w ##class(web.DHCBillBankLogic).GetPOSRetInfo("OP","C","DLL",^TMPPOSInfo("2012-01-14","08:57:46"),"19027598","INV","12",1,"")
/// w ##class(web.DHCBillBankLogic).GetPOSRetInfo("OP","C","DLL",^TMPPOSInfo("2012-02-01","15:58:21"),"","INV","12",1,"20195082")
ClassMethod GetPOSRetInfoold(PatType, TradeType, Status, POSInfo, PrtRowid, INVOrAPI, PaymDr, HospiDr, ParkRowid) As %String
{
	;记录日志
	s Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	s ^TMPPOSInfo(Date,Time)=POSInfo
	s rtn=0
	i POSInfo["VOU" d
	.s CertInfo=$p(POSInfo,"VOU",2)
	.s TradeRetNo="00"                       ;交易结果
	.s TradeRet="成功"                       ;交易成功
	.s AccName=$p(CertInfo,"|",2)            ;商户名称
	.s AccNo=$p(CertInfo,"|",3)              ;商户编号
	.s TerminalNo=$p(CertInfo,"|",4)         ;终端编号
	.s UserId=$p(CertInfo,"|",5)             ;操作员编号
	.s CardName=$p(CertInfo,"|",6)           ;卡种类
	.s CardNo=$p(CertInfo,"|",7)             ;卡号
    .s OrderNo=$p(CertInfo,"|",8)            ;卡顺序号
    .s TradeType=$p(CertInfo,"|",9)          ;交易类型
    .s FailDate=$p(CertInfo,"|",10)          ;卡失效期
    .s BatchNo=$p(CertInfo,"|",11)           ;批次号
    .s CertNo=$p(CertInfo,"|",12)            ;凭证号
    .s BankTradeDate=$p(CertInfo,"|",13)     ;交易日期时间
    .s AuthNo=$p(CertInfo,"|",14)            ;授权码
    .s TransRefNo=$p(CertInfo,"|",15)        ;交易参考号
    .s BankTradeAmt=$p(CertInfo,"|",16)      ;交易金额
    .s RemarkInfo=$p(CertInfo,"|",17)        ;备注
    .s SetType=$p(CertInfo,"|",18)           ;结算类型
    .s SetDate=$p(CertInfo,"|",19)           ;结算日期时间
    .s TradeStatictics=$p(CertInfo,"|",20)   ;交易统计
    .s HisTradeNo=$p(CertInfo,"|",21)        ;HIS交易流水号
    .i PatType="OP" d
    ..i PrtRowid'="" d
    ...s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCINVPRT(PrtRowid),"^",8)
    ..e  d
    ...s PrtDate=$p(^DHCINVPRT(ParkRowid),"^",5)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCINVPRT(ParkRowid),"^",20)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCINVPRT(ParkRowid),"^",8)
    .i PatType="DEP" d
    ..i PrtRowid'="" d
    ...s PrtDate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",2)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",3)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",8)
    ..e  d
    ...s PrtDate=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",2)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",3)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",8)
    .i PatType="IP" d
    ..s PrtDate=$p(^DHCINVPRTZY(PrtRowid),"^",2)      ;HIS打发票日期
    ..s PrtTime=$p(^DHCINVPRTZY(PrtRowid),"^",3)      ;HIS打发票日期
    ..s PrtFlag=$p(^DHCINVPRTZY(PrtRowid),"^",8)
    .i PrtFlag="S" s PrtFlag="A"
    .i TradeType="消费" s TradeType="C"
    .i TradeType="消费撤销" s TradeType="R"
    .i TradeType="退货" s TradeType="D"
    .;
    .s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HisTradeNo,"0"))
	.b ;更新银行交易信息表
	.s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)

    .k PLIST
    .s PLIST(2)=TradeRetNo
    .s PLIST(3)=TradeRet
    .s PLIST(4)=CardNo
    .s PLIST(5)=BankTradeAmt
    .s PLIST(6)=CertNo
    .s PLIST(8)=TransRefNo
    .s PLIST(9)=AuthNo
    .s PLIST(10)=TerminalNo
    .s PLIST(11)=AccNo
    .s PLIST(12)=BatchNo
    .s PLIST(13)=UserId
    .s PLIST(14)=CardName 
    .s PLIST(15)=$p($zd(+$h,3),"-",1)_$e(BankTradeDate,1,4)         ;月日，转换
    .s PLIST(16)=$e(BankTradeDate,5,10)        ;时分秒，转换
    .s PLIST(17)=FailDate                      ;月日
    .s PLIST(18)=RemarkInfo
    .s PLIST(19)=PrtFlag
    .s PLIST(20)=TransRefNo 
    .s PLIST(21)=""                            ;原交易参考号
    .s PLIST(22)=PrtDate
    .s PLIST(23)=PrtTime
    .s PLIST(24)=BankTradeAmt/100
    .s PLIST(25)=PatType
    .s PLIST(26)=UserId
    .s PLIST(27)=TradeType 
    .s PLIST(29)=HospiDr                       ;医院代码
    .s PLIST(32)="26"                            ;暂时写死,交易渠道
    .s PLIST(33)=HisTradeNo
    .s PLIST(34)=""                            ;原HIS交易流水号
    .s PLIST(35)=AccName
    .s PLIST(36)=SetType
    .s PLIST(37)=SetDate
    .s PLIST(38)=TradeStatictics
    .s PLIST(39)=INVOrAPI
    .s PLIST(40)="05"
    .d ..tb()
	.s myRtn=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	.b ;tttt21`
	.s rtn=$p(myRtn,"^",1)
	.i +rtn=0 d
	..i PatType="OP" d
	...s err=..UpdateTradeSub(HisTradeNo,PrtRowid, ParkRowid)
	...b ;tttt1234
	...s rtn=$p(err,"^",1)
	..e  i PatType="DEP" d
	...s err=..UpdateDEPTradeSub(HisTradeNo,PrtRowid, ParkRowid)
	...s rtn=0
	..e  i PatType="IP" d
	...b ;ttt123
	...s err=..UpdateIPINVTradeSub(HisTradeNo,PrtRowid,DEPPrtRowid,ArrcpRowid)
	...s rtn=0
	..e  d
	...s rtn=0

	.b ;tro
	.i +rtn=0 d
	..d ..tc()
	.e  d
	..Trollback
	..s ^TMPPOSInfo(Date,Time)=POSInfo_"^"_PrtRowid_"^"_ParkRowid_"^"_rtn
    q rtn
}

ClassMethod INVBankINSERT()
{
	K PLIST(1)
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVBankConSub Values PLIST())
	;d ..tc()
	
	q SQLCODE
}

/// tangtao
/// 2011-11-13
/// 回滚时，取回滚的发票串。多张发票时，中间失败的情况回滚的问题，以此取需要回滚的发票串
ClassMethod GetDelPrt(PrtStr, SucPrt)
{
	s PrtStr=$e(PrtStr,3,$l(PrtStr))

	s DelPrtStr=""
	i SucPrt="" d
	.s DelPrtStr=PrtStr
	e  d
	.s DelPrtStr=$p(PrtStr,SucPrt,2)
	q DelPrtStr
}

/// tangtao
/// 2011-11-29
/// 保存失败的POS记录
ClassMethod SaveWrongPOSInfo(POSInfo, ParkRowid)
{
	;只记录异常情况，并记录异常次数
	q:ParkRowid="" "0"
	s RetInfo=$e(POSInfo,1,2)
	s num=$i(^TMPSaveWrongPOSInfo(ParkRowid))
	s ^TMPSaveWrongPOSInfo(+$h,$p($h,",",2),ParkRowid,num)=POSInfo
	q 0
}

/// w ##class(web.DHCBillBankLogic).GetPOSWrongCode(19028360)
ClassMethod GetPOSWrongCode(ParkRowid)
{
	q:ParkRowid="" "0"
	q:$d(^TMPSaveWrongPOSInfo(ParkRowid))=0 "0"
	s flag=0
	s num=""
	s wnum=^TMPSaveWrongPOSInfo(ParkRowid)
	f  s num=$o(^TMPSaveWrongPOSInfo(ParkRowid,num)) q:num=""  d
	.q:num=0
	.s str=^TMPSaveWrongPOSInfo(ParkRowid,num)
	.s retn=$e(str,1,2)
	.q:flag=1
	.s Info=..JudgeWrongInfo(retn)
	.i $p(Info,"^",1)="F" s flag=1
	.e  s flag=0
	q flag_"^"_wnum
}

/// tangtao
/// 2011-11-29
/// 判断错误类别 
/// w ##class(web.DHCBillBankLogic).JudgeWrongInfo("01")
ClassMethod JudgeWrongInfo(RefInfo)
{
	s RefInfo=" "_RefInfo
	s Rowid=$o(^User.DHCPOSTradeCodeI("BankCode",RefInfo,""))
	s IBPOSType=$LIST(^User.DHCPOSTradeCodeD(Rowid),4)
	s IBPOSMesage=$LIST(^User.DHCPOSTradeCodeD(Rowid),3)
	q IBPOSType_"^"_IBPOSMesage
}

/// tangtao
/// 2011-11-15
/// 打印凭条信息
/// w ##class(web.DHCBillBankLogic).PrintAccInfo("C",19027628,0)
/// w ##class(web.DHCBillBankLogic).PrintAccInfo("R",19028402,1)
ClassMethod PrintAccInfoOLD(TradeType, PrtRowid, ExpStr)
{
	q:PrtRowid="" ""
	q:PrtRowid=0 ""
	q:$d(^DHCINVPRT(PrtRowid))=0 ""
	s Flag=$p(ExpStr,"^",1)
	i Flag="0" d
	.s IBPRowid="",PrintInfo=""
	.f  s IBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,IBPRowid)) q:IBPRowid=""  d
	..q:IBPRowid=0
	..s AccName=$p(^DHCINVBTP(IBPRowid),"^",34)             ;商户名称
	..s AccNo=$p(^DHCINVBTP(IBPRowid),"^",10)               ;商户编号
	..s TerminalNo=$p(^DHCINVBTP(IBPRowid),"^",9)           ;终端编号
	..s UserId=$p(^DHCINVBTP(IBPRowid),"^",12)              ;操作员号
	..s Bank=$p(^DHCINVBTP(IBPRowid),"^",13)                ;发 卡 行
	..s Bank=$tr($e(Bank,23,$l(Bank))," ")
	..s CardNo=$p(^DHCINVBTP(IBPRowid),"^",3)               ;卡    号
	..s FailDate=$p(^DHCINVBTP(IBPRowid),"^",16)            ;卡有效期
	..s TradeType=$p(^DHCINVBTP(IBPRowid),"^",24)           ;交易类型
	..s BatchNo=$p(^DHCINVBTP(IBPRowid),"^",11)             ;批 次 号
	..s CertNo=$p(^DHCINVBTP(IBPRowid),"^",5)               ;凭 证 号
	..s AuthNo=$p(^DHCINVBTP(IBPRowid),"^",8)               ;授 权 码
	..s BankTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)       ;日期
	..s BankTradeTime=$p(^DHCINVBTP(IBPRowid),"^",15)       ;时间
	..s TransRefNo=$p(^DHCINVBTP(IBPRowid),"^",7)           ;系统参考号
	..s TradeAmt=$p(^DHCINVBTP(IBPRowid),"^",23)            ;金额(RMB)
	..s TradeAmt=$fn(TradeAmt,"",2)
	..s TRemarkInfo=$p(^DHCINVBTP(IBPRowid),"^",17)            ;备注
	..i TradeType="C" s TradeType="消费"
    ..i TradeType="R" s TradeType="消费撤销"
    ..i TradeType="D" s TradeType="退货"
	i Flag="1" d
	.s IBPRowid="",PrintInfo=""
	.;f  s IBPRowid=$o(^DHCINVBTPi(0,"S","InitDr",PrtRowid,IBPRowid)) q:IBPRowid=""  d
	.f  s IBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,IBPRowid)) q:IBPRowid=""  d
	..q:IBPRowid=0
	..s AccName=$p(^DHCINVBTP(IBPRowid),"^",34)             ;商户名称
	..s AccNo=$p(^DHCINVBTP(IBPRowid),"^",10)               ;商户编号
	..s TerminalNo=$p(^DHCINVBTP(IBPRowid),"^",9)           ;终端编号
	..s UserId=$p(^DHCINVBTP(IBPRowid),"^",12)              ;操作员号
	..s Bank=$p(^DHCINVBTP(IBPRowid),"^",13)                ;发 卡 行
	..s Bank=$tr($e(Bank,23,$l(Bank))," ")
	..s CardNo=$p(^DHCINVBTP(IBPRowid),"^",3)               ;卡    号
	..s FailDate=$p(^DHCINVBTP(IBPRowid),"^",16)            ;卡有效期
	..s TradeType=$p(^DHCINVBTP(IBPRowid),"^",24)           ;交易类型
	..s BatchNo=$p(^DHCINVBTP(IBPRowid),"^",11)             ;批 次 号
	..s CertNo=$p(^DHCINVBTP(IBPRowid),"^",5)               ;凭 证 号
	..s AuthNo=$p(^DHCINVBTP(IBPRowid),"^",8)               ;授 权 码
	..s BankTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)       ;日期
	..s BankTradeTime=$p(^DHCINVBTP(IBPRowid),"^",15)       ;时间
	..s TransRefNo=$p(^DHCINVBTP(IBPRowid),"^",7)           ;系统参考号
	..s TradeAmt=$p(^DHCINVBTP(IBPRowid),"^",23)            ;金额(RMB)
	..s TRemarkInfo=$p(^DHCINVBTP(IBPRowid),"^",17)            ;备注
	..s TradeAmt=$fn(TradeAmt,"",2)
	..i TradeType="C" s TradeType="消费"
    ..i TradeType="R" s TradeType="消费撤销"
    ..i TradeType="D" s TradeType="退货"

    s BankTradeDate1=$e(BankTradeDate,1,4)_"/"_$e(BankTradeDate,5,6)_"/"_$e(BankTradeDate,7,8)
    s BankTradeTime1=$e(BankTradeTime,1,2)_":"_$e(BankTradeTime,3,4)_":"_$e(BankTradeTime,5,6)
    s BankTradeDate=BankTradeDate1,BankTradeTime=BankTradeTime1
    
    i $p(ExpStr,"^",2)="1" s STR2="         (商户联)  (重打)",STR11="         (商户联)  (重打)"
    s PrintInfo="AccName"_$c(2)_"商户名称:"_AccName_"^"_"AccNo"_$c(2)_"商户编号:"_AccNo_"^"_"TerminalNo"_$c(2)_"终端编号:"_TerminalNo
    s PrintInfo=PrintInfo_"^"_"UserId"_$c(2)_"操作员号:"_UserId_"^"_"Bank"_$c(2)_"发 卡 行:"_Bank_"^"_"CardNo"_$c(2)_"卡    号:"_CardNo
    s PrintInfo=PrintInfo_"^"_"FailDate"_$c(2)_"卡有效期:"_FailDate_"^"_"TradeType"_$c(2)_"交易类型:"_TradeType_"^"_"BatchNo"_$c(2)_"批 次 号:"_BatchNo
    s PrintInfo=PrintInfo_"^"_"CertNo"_$c(2)_"凭 证 号:"_CertNo_"^"_"AuthNo"_$c(2)_"授 权 码:"_AuthNo_"^"_"BankTradeDate"_$c(2)_"日期时间:"_BankTradeDate_" "_BankTradeTime
    s PrintInfo=PrintInfo_"^"_"TransRefNo"_$c(2)_"系统参考号:"_TransRefNo_"^"_"TradeAmt"_$c(2)_"金额(RMB):"_TradeAmt_"^"_"TRemarkInfo"_$c(2)_"备    注:"_TRemarkInfo
    s PrintInfo=PrintInfo_"^"_"STR1"_$c(2)_""_"^"_"STR2"_$c(2)_""_"^"_"STR3"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR4"_$c(2)_""_"^"_"STR5"_$c(2)_""_"^"_"STR6"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR7"_$c(2)_""_"^"_"STR8"_$c(2)_""_"^"_"STR9"_$c(2)_""

    s PrintInfo=PrintInfo_"^"_"STR10"_$c(2)_""_"^"_"STR11"_$c(2)_""_"^"_"STR12"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR13"_$c(2)_""_"^"_"STR14"_$c(2)_""_"^"_"STR15"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR16"_$c(2)_""_"^"_"STR17"_$c(2)_""
	
	q PrintInfo
}

/// 补打凭条
/// w ##class(web.DHCBillBankLogic).RePrintAccInfo(19028402)
ClassMethod RePrintAccInfo(PrtRowid)
{
	q:PrtRowid="" ""
	q:PrtRowid=0 ""
	q:$d(^DHCINVPRT(PrtRowid))=0 ""
	s SelfAsInitRowid=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,""))
	s RePrintInfo=""
	i SelfAsInitRowid="" d
	.s IBPRowid1=""
	.f  s IBPRowid1=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,IBPRowid1)) q:IBPRowid1=""  d
	..q:IBPRowid1=0
	..s Sub=""
	..f  s Sub=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,IBPRowid1,"C",Sub)) q:Sub=""  d
	...q:Sub=0
	...s TradeType=$p(^DHCINVBTP(IBPRowid1,"C",Sub),"^",5)
	...s RePrintInfo=..PrintAccInfo(TradeType,PrtRowid,"0^1^OP")
	e  d
	.s IBPRowid1=""
	.;f  s IBPRowid1=$o(^DHCINVBTPi(0,"S","InitDr",SelfAsInitRowid,IBPRowid1)) q:IBPRowid1=""  d
	.f  s IBPRowid1=$o(^DHCINVBTPi(0,"S","IPDR",SelfAsInitRowid,IBPRowid1)) q:IBPRowid1=""  d
	..q:IBPRowid1=0
	..s Sub=""
	..w IBPRowid1,!
	..;f  s Sub=$o(^DHCINVBTPi(0,"S","InitDr",SelfAsInitRowid,IBPRowid1,"C",Sub)) q:Sub=""  d
    ..f  s Sub=$o(^DHCINVBTPi(0,"S","IPDR",SelfAsInitRowid,IBPRowid1,"C",Sub)) q:Sub=""  d
	...q:Sub=0
	...s TradeType=$p(^DHCINVBTP(IBPRowid1,"C",Sub),"^",5)
	...s RePrintInfo=..PrintAccInfo(TradeType,SelfAsInitRowid,"1^1^OP")
	
	q RePrintInfo
}

/// ///在指定FTP服务器上获取对账数据///////////////////////////////
/// tangtao
/// 2011-11-18
/// Modily Lid 2013-01-08
/// 导入POS对账文件，使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(web.DHCBillBankLogic).GetRecTXTFromFTP()
ClassMethod GetRecTXTFromFTP()
{
	;w ##class(web.DHCBillBankLogic).GetRecTXTFromFTP()
	//s tradeDate=62229

	s ftpIP="172.172.10.20"
	s userName="pos"
	s password="2011dhcc1201"
	s port=2011
	;门诊对账数据
	s path="/DOWNLOAD/05/"
	;s fileName="AHSLYY_05_"_$zd(+$h-1,8)       
    s fileName="AHSLYY_05_20120503"
	s file=path_fileName_".txt"
	
	s stream=##class(%GlobalCharacterStream).%New()
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.TranslateTable="UTF8"
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "请查证IP地址,用户名,密码,端口号是否正确"
	;获取文本列表
	n fileArray,key
	i 'ftp.NameList(path,.fileArray) q "获取FTP目录文件列表失败"
	s key="",i=$i(BanList)
	f  s BanList(i)=fileArray.GetNext(.key),i=i+1 q:(key="")
	s num=""

	f  s num=$o(BanList(num)) q:num=""  d
	.s BanListInfo=BanList(num)
	.q:BanListInfo'[fileName
	.s file=path_BanListInfo
	;得到正确文本

	if 'ftp.Retrieve(file,stream) Quit "对账文本不存在"
	s Len=0,FalseNum=0,strflag=1
    while ('stream.AtEnd) {
	    s Info=stream.ReadLine()
	    if (strflag'=1) {
    		q:(Info="")
    		;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..SaveBalanceInfo(Info)
    		;w Info,!
    		;s rtn=0
    		i +rtn'=0 d
    		.s FalseNum=FalseNum+1
			.;失败记录
			.s ^TMPSaveBalance(fileName,FalseNum)=Info
		}
		s strflag=strflag+1
	}
    If 'ftp.Logout() Quit
    
	q FalseNum
}

/// ///在指定FTP服务器上获取对账数据///////////////////////////////
/// tangtao
/// 2011-11-18
/// 使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(web.DHCBillBankLogic).GetRecTXTFromFTP()
ClassMethod GetRecTXTFromFTPold()
{
	;w ##class(web.DHCBillBankLogic).GetRecTXTFromFTP()
	//s tradeDate=62229

	s ftpIP="172.172.10.20:2011"
	s userName="pos"
	s password="2011dhcc1201"
	s port=21
	;门诊对账数据
	s fileName="DOWNLOAD\05\AHSLYY_05_"_$tr($zd(+$h-1,3),"-")
	;s fileName="DOWNLOAD\05\AHSLYY_05_20120503"

	s stream=##class(%GlobalCharacterStream).%New()
	s stream1=##class(%GlobalCharacterStream).%New()
	s file=fileName_".txt"
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.TranslateTable="UTF8"
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "FTP打开失败"
	if 'ftp.Retrieve(file,stream) Quit "文本不存在"
	;w $tr($tr($p($ZDATETIME($ZUTIL(188),3,1,6)," ",2),":"),"."),!
	s Len=0,FalseNum=0,strflag=1
	s stream1=stream
    while ('stream.AtEnd) {
	    s Info=stream.ReadLine()
	    if (strflag'=1) {
    		q:(Info="")
    		;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..SaveBalanceInfo(Info)
    		;w Info,!
    		;s rtn=0
    		i +rtn'=0 d
    		.s FalseNum=FalseNum+1
			.;失败记录
			.s ^TMPSaveBalance(fileName,FalseNum)=Info
		}
		s strflag=strflag+1
	}
	
	;s file="DOWNLOAD\05\AHSLYY_05_20111201bak"
	;s file=file_".txt"
	;if 'ftp.Append(file,stream1) Quit

    If 'ftp.Logout() Quit
    
	q FalseNum
}

/// 获取各银行对账文本FTP目录
/// w ##class(web.DHCBillBankLogic).BanlanceBankInfo()
ClassMethod BanlanceBankInfo()
{
	s ftpIP="172.23.6.12"
	s userName="FtpUser",password="ftp_123",port=21,fileName=""
	s ghrtn=0,nhrtn=0,zhrtn=0,jhrtn=0

	s fileName="SDSLYY_01_"_$zd(+$h,8)       ;工行
	s ghrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,1)
	
	s fileName="SDSLYY_02_"_$zd(+$h,8)       ;农行
	s nhrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,2)
	
	s fileName="SDSLYY_03_"_$zd(+$h,8)       ;中行
	s zhrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,3)
	
	s fileName="SDSLYY_04_"_$zd(+$h-1,8)       ;建行
	s jhrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,4)
	
	q ghrtn_"^"_nhrtn_"^"_zhrtn_"^"_jhrtn
}

/// ///在指定FTP服务器上获取对账数据///////////////////////////////
/// tangtao
/// 2011-11-18
/// Modily Lid 2013-01-08
/// 导入银医卡对账文件，使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.23.6.12","FtpUser","ftp_123","21","SDSLYY_02_20130411","2")
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.23.6.12","FtpUser","ftp_123","21","SDSLYY_03_20130112","3")
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.23.6.12","FtpUser","ftp_123","21","SDSLYY_04_20130116","4")
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.172.10.20","dhcc","dhcc","2011","AHSLYY_04_20120218175336","1")
ClassMethod GetCARDCPPTXTFromFTP(ftpIP, userName, password, port, fileName, bankid)
{
	s stream=##class(%GlobalCharacterStream).%New()
	;s stream.LineTerminator=$c(10) 		;文件是UNIX格式时须设置分割符
	s path=""
	i bankid="1" d
	.s path="/DOWNLOAD/ICBC/"
	.s file=path_fileName_".txt"
	i bankid="2" d
	.s path="/DOWNLOAD/ABC/"
	.s file=path_fileName_".txt"
	i bankid="3" d
	.s path="/DOWNLOAD/BC/"
	.s file=path_fileName_".txt"
	i bankid="4" d
	.s path="/DOWNLOAD/CBC/"
	.s file=path_fileName_".txt"
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.TranslateTable="UTF8"
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "请查证IP地址,用户名,密码,端口号是否正确"
	b ;获取文本列表
	n fileArray,key

	i 'ftp.NameList(path,.fileArray) q "获取FTP目录文件列表失败"
	s key="",i=$i(BanList)
	f  s BanList(i)=fileArray.GetNext(.key),i=i+1 q:(key="")
	s num=""
	f  s num=$o(BanList(num)) q:num=""  d
	.s BanListInfo=BanList(num)
	.q:BanListInfo'[fileName
	.s file=path_BanListInfo
	.//s file=BanListInfo
	b ;得到正确文本

	if 'ftp.Retrieve(file,stream) Quit "对账文本不存在"
	b ;222
	s Len=0,FalseNum=0,strflag=1
	//s Len=0,FalseNum=0,strflag=0
    while ('stream.AtEnd) {
	    s Info=stream.ReadLine()
	    b ;bbbb
	    if (strflag'=1) {
    		q:(Info="")
    		;b ;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..SaveCARDCPPBalanceInfo(Info)
    		;w Info,!
    		;s rtn=0
    		i +rtn'=0 d
    		.s FalseNum=FalseNum+1
			.;失败记录
			.s ^TMPSaveBalance(fileName,FalseNum)=Info
		}
		s strflag=strflag+1
	}

    If 'ftp.Logout() Quit "文本导入成功,FTP关闭失败."
    
	q FalseNum
}

/// tangtao
/// 2011-11-19
/// 保存对账数据
ClassMethod SaveCARDCPPBalanceInfo(BalanceInfo)
{
	q:BalanceInfo="" 0
	s rtn=0
	s BanLen=$l(BalanceInfo,",")
	i BanLen<15 d
	.k PLIST
	.f BanNum=1:1:10 d
	..s BanInfo=$p(BalanceInfo,",",BanNum)
	..s PLIST(BanNum+1)=BanInfo
	.s PLIST(12)=1
	.f BanNum=11:1:15 d
	..s BanInfo=$p(BalanceInfo,",",BanNum)
	..s PLIST(BanNum+2)=$tr(BanInfo,$C(13))
	e  d
	.k PLIST
	.f BanNum=1:1:BanLen d
	..s BanInfo=$p(BalanceInfo,",",BanNum)
	..s PLIST(BanNum+1)=$tr(BanInfo,$C(13))
	
    d ..tb()
	s myRtn=..DHCINVBankBalanceINSERT()
	s rtn=$p(myRtn,"^",1)
	b ;b00000
	i +rtn=0 d
	.d ..tc()
	e  d
	.Trollback

	q rtn
}

/// tangtao
/// 2011-11-19
/// 保存对账数据
ClassMethod SaveBalanceInfo(BalanceInfo)
{
	q:BalanceInfo="" 0
	s rtn=0
	s BanLen=$l(BalanceInfo)
	q:BanLen<200 "-1"
	
	k PLIST
	s PLIST(2)=$tr($E($g(BalanceInfo),1,4)," ")
	s PLIST(3)=$tr($E($g(BalanceInfo),5,6)," ")
	s PLIST(4)=$tr($E($g(BalanceInfo),7,12)," ")
	s PLIST(5)=$tr($E($g(BalanceInfo),13,14)," ")
	s PLIST(6)=$tr($E($g(BalanceInfo),15,34)," ")
	s PLIST(7)=$tr($E($g(BalanceInfo),35,54)," ")
	s PLIST(8)=$tr($E($g(BalanceInfo),55,84)," ")
	s PLIST(9)=$tr($E($g(BalanceInfo),85,98)," ")
	s PLIST(10)=$tr($E($g(BalanceInfo),99,118)," ")
	s PLIST(11)=$tr($E($g(BalanceInfo),119,119)," ")
	s PLIST(12)=$tr($E($g(BalanceInfo),120,139)," ")
	s PLIST(13)=$tr($E($g(BalanceInfo),140,158)," ")
	s PLIST(14)=$tr($E($g(BalanceInfo),159,172)," ")
	s PLIST(15)=$tr($E($g(BalanceInfo),173,192)," ")
	s PLIST(16)=$tr($E($g(BalanceInfo),193,200)," ")
	/*
	f i=1:1:BanLen d
    .s PLIST(i+1)=$p(BalanceInfo,"^",i)
	*/
    d ..tb()
	s myRtn=..DHCINVBankBalanceINSERT()
	s rtn=$p(myRtn,"^",1)
	i +rtn=0 d
	.d ..tc()
	e  d
	.Trollback

	s rtn=0
	q rtn
}

ClassMethod DHCINVBankBalanceINSERT()
{
	K PLIST(1)
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVBankBalance Values PLIST())
	;d ..tc()
	
	s myRowID=%ROWID
	i 'SQLCODE d ..DHCINVBankBalanceSELECT(myRowID)
	
	q SQLCODE_"^"_myRowID
}

ClassMethod DHCINVBankBalanceSELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVBankBalance WHERE IBT_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
	q SQLCODE
}

/// Lid
/// 2011-03-07
/// 字节流测试
/// w ##class(web.DHCBillBankLogic).TestStream()
ClassMethod TestStream() As %GlobalCharacterStream [ WebMethod ]
{
	;w ##class(web.DHCOPBillAutoPaySOAP).TestStream()
	;%Library.CharacterStream
	;%GlobalCharacterStream
	;%Library.GlobalBinaryStream
	Set newstream=##class(%GlobalCharacterStream).%New()
	s tmp=""
	f i=1:1:10 d
	.;s tmp=tmp_"a"
	.Set tmp="测试数据流^测试数据流2^测试数据流4^测试数据流5sh9ik^lajdsflakjdf^al0.12ge[12*4]"
	.d newstream.Write(tmp)
	
	i 'newstream.AtEnd d
	.w newstream.Read()
	.w !,"051385107561"
	
	q newstream
}

Query JudgeBankTradePay(StDate, StTime, EndDate, EndTime) As %Query(ROWSPEC = "Tind:%String,TBankNo:%String,THopDr:%String,TTrannelNo:%String,TUserId:%String,TBankCardNo:%String,THISTradeTime:%String,THISTradeNo:%String,TTradeFlag:%String,TTradeAmt:%String,TIBTAmt:%String,TBankTradeTime:%String,TBankTradeNo:%String,TBankFinDate:%String,Tjob:%String")
{
}

/// tangtao
/// 2011-11-21
/// 对账，显示差错交易
/// d ##class(%ResultSet).RunQuery("web.DHCBillBankLogic","JudgeBankTradePay",62471,00000,62471,86399)
ClassMethod JudgeBankTradePayExecute(ByRef qHandle As %Binary, StDate, StTime, EndDate, EndTime) As %Status
{
 	s repid=$I(^CacheTemp)
 	i (StDate="")!(EndDate="") Set qHandle=$lb(0,repid,0) 	Quit $$$OK
 	s ind=1
	s Guser=%session.Get("LOGON.USERID")
	s job=$j
    k ^TMPDHCINVBankBalance
    k ^TMP("UDHCJFJudgeBankTradePay",Guser,job)
    ;TimeFlag=1  按HIS交易时间查询
    s TimeFlag="1"
    i TimeFlag="1" s TimeCode="HISDTIME"
    i TimeFlag="2" s TimeCode="BANKTRADETIME"
    i StTime="" s StTime="00000"
    i EndTime="" s EndTime="86399"
	s ^TMP("tt")=StDate_","_StTime_","_EndDate_","_EndTime
    i StTime'="" s IBTSTDATETIME=$tr($zd(StDate,3),"-")_$tr($zt(StTime,1),":")
    e  s IBTSTDATETIME=$tr($zd(StDate,3),"-")_"00001"
    i EndTime'="" s IBTENDDATETIME=$tr($zd(EndDate,3),"-")_$tr($zt(EndTime,1),":")
    e  s IBTENDDATETIME=$tr($zd(EndDate,3),"-")_"86399"
	
    i ((TimeFlag="1")!(TimeFlag="2")) d
    .s Rowid=""
    .f Date=StDate:1:EndDate d
    ..s PrtRowid=""
    ..f  s PrtRowid=$o(^DHCINVPRT(0,"Date",Date,PrtRowid)) q:PrtRowid=""  d
    ...s OldInvDr=$p(^DHCINVPRT(PrtRowid),"^",29)
    ...q:OldInvDr'=""
    ...s PrtFlag=0
    ...s InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)
    ...i InitInvDr'="" d
    ....s InitInvAmt=$p(^DHCINVPRT(InitInvDr),"^",1)
    ....s PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,""))
    ....i PrtOldDr'="" d
    .....s PrtOldDrAmt=$p(^DHCINVPRT(PrtOldDr),"^",1)
    .....i PrtOldDrAmt=InitInvAmt s PrtFlag=1
    ...q:PrtFlag=1
    ...s PaymSub="",Flag=0
    ...f  s PaymSub=$o(^DHCINVPRT(PrtRowid,"P",PaymSub)) q:PaymSub=""  d
    ....q:PaymSub=0
    ....s PaymDr=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",1)
    ....s PaymAmt=$p(^DHCINVPRT(PrtRowid,"P",PaymSub),"^",3)
    ....s HandDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PaymDr)
    ....i ((HandDr'="")&(PaymDr'=13)) d
    .....i +$g(PaymAmt)'=0 s Flag=1
    ...q:Flag=0
    ...s Rowid=""
    ...i $d(^DHCINVBTPi(0,"S","IPDR",PrtRowid))'=0 d
    ....s Rowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,Rowid))
	....s Rc=$p(^DHCINVBTP(Rowid),"^",1)
	....q:Rc'="00"
	....s HISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
	....s TradeAmt=$p(^DHCINVBTP(Rowid),"^",4)
	....s TradeAmt=+$g(TradeAmt)
	....i HISTradeNo'="" d
	.....s IBTRowID=$o(^User.DHCINVBankBalanceI("TRADENO",HISTradeNo,""))
	.....i IBTRowID'="" d
	......s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
	......s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
	......s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
	......s ^TMPDHCINVBankBalance(IBTRowID)=IBTRowID
	......q:((HISTradeNo=THISTradeNo)&(TradeAmt=IBTAmt))
	......s IBTAmt=$fn(IBTAmt/100,"",2)
	......s TradeAmt=$fn(TradeAmt/100,"",2)
	......s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
	......i +$g(TBankNo)=5 s TBankNo="软POS"
	......s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
	......i THopDr="1001" s THopDr="安徽省立医院"
	......s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
	......i TTrannelNo="26" s TTrannelNo="门诊收费处"
	......;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
	......s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
	......s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
	......s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),1)
	......s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
	......s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
	......s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
	......s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
	......s TTradeFlag=""
	......i IBTTradeFlag=0 s TTradeFlag="扣费"
	......i IBTTradeFlag=1 s TTradeFlag="退费"
	......s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
	......;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
	......i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
	......i IBTPaymodeDr=1 s IBTPaymDesc="银医卡"
	......s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
	......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
	......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
	......s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
	......s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
	......s TTradeAmt=TradeAmt
	......s TBankTradeNo=IBTBankTradeNo
	......d outputrowpay
	.....e  d
	......s TBankNo=$p(^DHCINVBTP(Rowid),"^",41)
	......i TBankNo="" s TBankNo=05
	......i +$g(TBankNo)=5 s TBankNo="软POS"
	......s THopDr=$p(^DHCINVBTP(Rowid),"^",28)
	......i THopDr'="" s THopDr=$p(^CT("HOSP",THopDr),"^",1)
	......e  s THopDr="1001"
	......i THopDr="1001" s THopDr="安徽省立医院"
	......s TTrannelNo=$p(^DHCINVBTP(Rowid),"^",31)
	......i TTrannelNo="5" s TTrannelNo="26"
	......i TTrannelNo="26" s TTrannelNo="门诊收费处"
	......i TTrannelNo="16" s TTrannelNo="门诊收费处"
	......;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
	......s TUserId=$p(^DHCINVBTP(Rowid),"^",25)
	......i TUserId'="" s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
	......s TBankCardNo=$p(^DHCINVBTP(Rowid),"^",3)
	......s THISTradeTime=$zd($p(^DHCINVBTP(Rowid),"^",21),3)_" "_$zt($p(^DHCINVBTP(Rowid),"^",22),1)
	......s THISTradeNo=$p(^DHCINVBTP(Rowid),"^",32)
	......s TTradeFlag=$p(^DHCINVBTP(Rowid),"^",24)
	......i TTradeFlag="C" s TTradeFlag="扣费"
	......i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
	......i TBankNo="05" s IBTPaymDesc="软POS"
	......i ((+$g(TBankNo)=1)!(+$g(TBankNo)=2)!(+$g(TBankNo)=3)!(+$g(TBankNo)=4)) s IBTPaymDesc="银医卡"
	......s TBankTradeTime1=$p(^DHCINVBTP(Rowid),"^",14)_$p(^DHCINVBTP(Rowid),"^",15)
	......s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
	......s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
	......s TBankFinDate=""
	......s TTradeAmt=$fn($p(^DHCINVBTP(Rowid),"^",23),"",2)
	......s IBTAmt="0.00"
	......s TBankTradeNo=$p(^DHCINVBTP(Rowid),"^",19)
	......d outputrowpay
	...e  d
	....s TBankNo=""
	....i TBankNo="" s TBankNo=05
	....i +$g(TBankNo)=5 s TBankNo=""
	....i +$g(TBankNo)=2 s TBankNo="中国农业银行"
	....s THopDr=1
	....s THopDr=$p(^CT("HOSP",THopDr),"^",1)
	....i THopDr="1001" s THopDr="安徽省立医院"
	....s CTRowid=$p(^DHCINVPRT(PrtRowid),"^",40)
	....s TTrannelNo=$p(^CTLOC(CTRowid),"^",2)
	....;s IBTTerminalNo=$p(^DHCINVBTP(Rowid),"^",41)
	....s TUserId=$p(^DHCINVPRT(PrtRowid),"^",21)
	....s TUserId=$p(^SSU("SSUSR",TUserId),"^",2)
	....s TBankCardNo=""
	....s THISTradeTime=$zd($p(^DHCINVPRT(PrtRowid),"^",5),3)_" "_$zt($p(^DHCINVPRT(PrtRowid),"^",20),1)
	....s THISTradeNo=""
	....i PaymAmt>0 s TTradeFlag="C"
	....e  s TTradeFlag="R"
	....i TTradeFlag="C" s TTradeFlag="扣费"
	....i ((TTradeFlag="R")!(TTradeFlag="D")) s TTradeFlag="退费"
	....i TBankNo="05" s IBTPaymDesc="软POS"
	....i ((+$g(TBankNo)=1)!(+$g(TBankNo)=2)!(+$g(TBankNo)=3)!(+$g(TBankNo)=4)) s IBTPaymDesc="银医卡"
	....s TBankTradeTime=""
	....s TBankFinDate=""
	....i PaymAmt<0 d
    .....s InitInvDr=$p(^DHCINVPRT(PrtRowid),"^",13)
    .....i InitInvDr'="" d
    ......s PrtOldDr=$o(^DHCINVPRT(0,"OldINV",InitInvDr,""))
    ......s TTradeAmt=..GetOPInvBankCardAmt(PrtOldDr_"|"_PrtRowid)
    ....e  d
	.....s TTradeAmt=$fn($zabs(PaymAmt),"",2)
	....s IBTAmt="0.00"
	....s TBankTradeNo=""
	....d outputrowpay
	.s Date=""
    .i TimeFlag="1" s TimeCode="HISTIME"
    .i TimeFlag="2" s TimeCode="BANKTRADETIME"
	.f Date=IBTSTDATETIME:1:IBTENDDATETIME d
	..s IBTRowID=""
	..f  s IBTRowID=$o(^User.DHCINVBankBalanceI(TimeCode,Date,IBTRowID)) q:IBTRowID=""  d
	...q:IBTRowID=0
	...q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
	...s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
	...;s IBTPaymDesc=$p(^CT("CTPM",IBTPaymodeDr),"^",2)
	...i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
	...q:(IBTPaymodeDr'=2)
	...s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
	...s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
	...s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
	...s IBTAmt=$fn(IBTAmt/100,"",2)
	...s TradeAmt="0.00"
	...s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
	...i +$g(TBankNo)=5 s TBankNo="软POS"
 	...s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
	...i THopDr="1001" s THopDr="安徽省立医院"
	...s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
	...i TTrannelNo="26" s TTrannelNo="门诊收费处"
	...i TTrannelNo="16" s TTrannelNo="门诊收费处"
	...;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
	...s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
	...s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
	...s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
	...s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
	...s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
	...s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
	...s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
	...s TTradeFlag=""
	...i IBTTradeFlag=0 s TTradeFlag="扣费"
	...i IBTTradeFlag=1 s TTradeFlag="退费"
	...s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
	...s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
	...s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
	...s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
	...s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
	...s TTradeAmt=TradeAmt
	...s TBankTradeNo=IBTBankTradeNo
	...d outputrowpay
	i StDate="62470" d           ;特殊处理
	.s DateStr=".3201201140857^.3201201140859^.3201201140900^.3201201140900^.3201201140903^.3201201140904^.3201201140950"
	.f i=1:1:7 d
	..s Date=$p(DateStr,"^",i)
	..s IBTRowID=$o(^User.DHCINVBankBalanceI("HISTIME",Date,0))
	..q:IBTRowID=0
	..q:$d(^TMPDHCINVBankBalance(IBTRowID))=1
	..s IBTPaymodeDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),10)
	..s IBTPaymDesc=""
	..i IBTPaymodeDr=2 s IBTPaymDesc="软POS"
	..s IBTAmt=$LIST(^User.DHCINVBankBalanceD(IBTRowID),12)
	..s IBTBankTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),5)
	..s THISTradeNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),7)
	..s IBTAmt=$fn(IBTAmt/100,"",2)
	..s TradeAmt="0.00"
	..s TBankNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),4)
	..i +$g(TBankNo)=5 s TBankNo="软POS"
 	..s THopDr=$LIST(^User.DHCINVBankBalanceD(IBTRowID),9)
	..i THopDr="1001" s THopDr="安徽省立医院"
	..s TTrannelNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),15)
	..i TTrannelNo="26" s TTrannelNo="门诊收费处"
	..i TTrannelNo="16" s TTrannelNo="门诊收费处"
	..;s IBTTerminalNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),11)
	..s IBTUserId=$LIST(^User.DHCINVBankBalanceD(IBTRowID),16)
	..s TUserId=$p(^SSU("SSUSR",IBTUserId),"^",2)
	..s TBankCardNo=$LIST(^User.DHCINVBankBalanceD(IBTRowID),2)
	..s THISTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),8)
	..s THISTradeTime1=$e(THISTradeTime1,3,$l(THISTradeTime1))
	..s THISTradeTime=$e(THISTradeTime1,1,4)_"-"_$e(THISTradeTime1,5,6)_"-"_$e(THISTradeTime1,7,8)
	..s THISTradeTime=THISTradeTime_" "_$e(THISTradeTime1,9,10)_":"_$e(THISTradeTime1,11,12)_":"_$e(THISTradeTime1,13,14)
	..s IBTTradeFlag=$LIST(^User.DHCINVBankBalanceD(IBTRowID),13)
	..s TTradeFlag=""
	..i IBTTradeFlag=0 s TTradeFlag="扣费"
	..i IBTTradeFlag=1 s TTradeFlag="退费"
	..s TBankTradeTime1=$LIST(^User.DHCINVBankBalanceD(IBTRowID),6)
	..s TBankTradeTime=$e(TBankTradeTime1,1,4)_"-"_$e(TBankTradeTime1,5,6)_"-"_$e(TBankTradeTime1,7,8)
	..s TBankTradeTime=TBankTradeTime_" "_$e(TBankTradeTime1,9,10)_":"_$e(TBankTradeTime1,11,12)_":"_$e(TBankTradeTime1,13,14)
	..s TBankFinDate=$LIST(^User.DHCINVBankBalanceD(IBTRowID),3)
	..s TBankFinDate=$e(TBankFinDate,1,4)_"-"_$e(TBankFinDate,5,6)_"-"_$e(TBankFinDate,7,8)
	..s TTradeAmt=TradeAmt
	..s TBankTradeNo=IBTBankTradeNo
	..s THopDr="安徽省立医院"
	..s TBankNo="软POS"
	..s THISTradeNo="异常"
	..d outputrowpay
    s qHandle=$lb(0,repid,0)
    quit $$$OK
outputrowpay
	s ^TMP("UDHCJFJudgeBankTradePay",Guser,job,ind)=ind_"^"_TBankNo_"^"_THopDr_"^"_TTrannelNo_"^"_TUserId_"^"_TBankCardNo_"^"_THISTradeTime_"^"_THISTradeNo_"^"_TTradeFlag_"^"_TTradeAmt_"^"_IBTAmt_"^"_TBankTradeTime_"^"_TBankTradeNo_"^"_TBankFinDate
	;set Data=$lb(ind,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TBankTradeTime,TBankFinDate,TTradeAmt,TBankTradeNo,job,IBTAmt)
	set Data=$lb(ind,TBankNo,THopDr,TTrannelNo,TUserId,TBankCardNo,THISTradeTime,THISTradeNo,TTradeFlag,TTradeAmt,IBTAmt,TBankTradeTime,TBankTradeNo,TBankFinDate,job)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod JudgeBankTradePayFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = JudgeBankTradePayExecute ]
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

ClassMethod JudgeBankTradePayClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = JudgeBankTradePayExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod SaveBalanceSubInfo() As %String
{
	s StDate=+$h-1,StTime="00000",EndDate=+$h-1,EndTime="86399"
	If $g(index)="" Set index=1
	Set repid=$I(^CacheTemp)
	Set rset=##class(%ResultSet).%New("web.DHCBillBankLogic:JudgeBankTradePay")
	d rset.Execute(StDate, StTime, EndDate, EndTime)
	Set columns = rset.GetColumnCount()     ///出参的个数
	While (rset.Next()) {
		s Data=""
		f i=1:1:columns d
		.i Data="" s Data=rset.GetData(i)
		.e  s Data=Data_"^"_rset.GetData(i)
		w !,Data
		Set ^CacheTemp(repid,index)=Data
		Set index=index+1
	 }
	d rset.Close()
	q 0
}

/// tangtao
/// 2011-11-22
/// 异常处理
/// -1 当日撤销失败，-2 当日退货失败，-3 隔日退货失败
/// w ##class(web.DHCBillBankLogic).GetPRTForYCCL(19027892)  --000000235
/// w ##class(web.DHCBillBankLogic).GetPRTForYCCL(19027895)  --000000236
/// w ##class(web.DHCBillBankLogic).GetPRTForYCCL(20392489)
ClassMethod GetPRTForYCCL(PrtRowid)
{
	q:PrtRowid="" "0^无发票号!"_$c(2)
	s PrtFlag=0,RetStr=""
	s StrikeRowid=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,""))
	s NormalRowid=$o(^DHCINVPRT(0,"OldINV",PrtRowid,""))
	s DayFlag=..JudgePrtDate(PrtRowid)
	i StrikeRowid'="" d
	.i DayFlag=0 d
	..s TBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",StrikeRowid,""))
	..i TBPRowid="" d
	...i NormalRowid="" d
	....s PrtFlag=-1
	....s RetStr=PrtFlag_"^"_StrikeRowid_$c(2)
	...e  d
	....s PrtFlag=-2
	....s RetStr=PrtFlag_"^"_NormalRowid_"^"_StrikeRowid_$c(2)
	.e  d
	..s TBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",StrikeRowid,""))
	..i TBPRowid="" d
	...s PrtFlag=-3
	...s RetStr=PrtFlag_"^"_NormalRowid_"^"_StrikeRowid_$c(2)
	e  d
	.s RetStr=PrtFlag_"^"_"此票未做退费!"_$c(2)
	
	i RetStr="" s RetStr=PrtFlag_"^"_"此票已经成功退费,无需补交易!"_$c(2)
	
	q RetStr
}

ClassMethod JudgePrtDate(invRowId)
{
	set rtn=0
	set invDate = $p(^DHCINVPRT(invRowId),"^",5)
	set:+invDate'=+$h rtn=-1
	quit rtn
}

ClassMethod GetNowTime()
{
	s PreTime="00:00:00"
	;s NowTime=$zt($p($h,",",2),1)
	s NowTime="23:59:59"
	q PreTime_"^"_NowTime
}

ClassMethod GetNum(Guser, job)
{
	q:$d(^TMP("UDHCJFJudgeBankTradePay",Guser,job))=0 "0"
	s num=$o(^TMP("UDHCJFJudgeBankTradePay",Guser,job,""),-1)
	q num
}

ClassMethod GetStr(Guser, job, num)
{
	s str=^TMP("UDHCJFJudgeBankTradePay",Guser,job,num)
	q str
}

ClassMethod teaterewr()
{
	;w ##class(web.DHCBillBankLogic).teaterewr()
	//s tradeDate=62229

	s ftpIP="192.168.1.103"
	s userName="ABC"
	s password="dhcc"
	s port=21
	;门诊对账数据
	;s fileName="AHSLYY_05_"_$tr($zd(+$h,3),"-")
	s fileName="201111291"
	
	s stream=##class(%GlobalCharacterStream).%New()
	s file=fileName_".txt"
	s ftp=##class(%Net.FtpSession).%New()
	;s char=##class(%IO.I.TranslationDevice).GetCharEncodingTable("GB18030")
	s ftp.TranslateTable="UTF8"  ;char       ;编码转换
	If 'ftp.Connect(ftpIP,userName,password,port) Quit
	if 'ftp.Retrieve(file,stream) Quit
	s FalseNum=0
	while('stream.AtEnd){
		s Info=stream.ReadLine()
    	;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    	s rtn=..SaveBalanceInfo1(Info)
    	i +rtn'=0 d
    	.s FalseNum=FalseNum+1
		.;失败记录
		.s ^TMPSaveBalance(fileName,FalseNum)=Info
	}

    If 'ftp.Logout() Quit
	q FalseNum
}

/// tangtao
/// 2011-11-19
/// 保存对账数据
ClassMethod SaveBalanceInfo1(BalanceInfo)
{
	q:BalanceInfo="" 0
	s rtn=0
	
	k PLIST
	f i=1:1:4 d
    .s PLIST(i+1)=$p(BalanceInfo,"^",i)

    d ..tb()
	s myRtn=..DHCINVBankBalanceINSERT1()
	s rtn=$p(myRtn,"^",1)
	i +rtn=0 d
	.d ..tc()
	e  d
	.Trollback

	s rtn=0
	q rtn
}

ClassMethod DHCINVBankBalanceINSERT1()
{
	K PLIST(1)
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_POSTradeCode Values PLIST())
	;d ..tc()
	
	q SQLCODE
}

ClassMethod test1130()
{
	//s str="00^A^承兑或交易成功^交易成功#01^C^查发卡行^交易失败,请联系发卡行#02^C^可电话向发卡行查询^交易失败,请联系发卡行#03^C^商户需要在银行或中心登记^商户未登记#04^D^操作员没收卡^没收卡,请联系收单行#05^C^发卡不予承兑^交易失败,请联系发卡行#06^E^发卡行故障^交易失败,请联系发卡行#07^D^特殊条件下没收卡^没收卡,请联系收单行#09^B^重新提交交易请求^交易失败,请重试#12^C^发卡行不支持的交易^交易失败,请重试#13^B^金额为0 或太大^交易金额超限,请重试#14^B^卡种未在中心登记或读卡号有误^无效卡号,请联系发卡行#15^C^此发卡行未与中心开通业务^此卡不能受理#19^C^刷卡读取数据有误,可重新刷卡^交易失败,请联系发卡行#20^C^无效应答^交易失败,请联系发卡行#21^C^不做任何处理^交易失败,请联系发卡行#22^C^POS状态与中心不符,可重新签到^操作有误,请重试#23^C^不可接受的交易费^交易失败,请联系发卡行#25^C^发卡行未能找到有关记录^交易失败,请联系发卡行#30^C^格式错误^交易失败,请重试#31^C^此发卡方未与中心开通业务^此卡不能受理#33^D^过期的卡,操作员可以没收^过期卡,请联系发卡行#34^D^有作弊嫌疑的卡,操作员可以没收^没收卡,请联系收单行#35^D^有作弊嫌疑的卡,操作员可以没收^没收卡,请联系收单行#36^D^有作弊嫌疑的卡,操作员可以没收^此卡有误,请换卡重试#37^D^有作弊嫌疑的卡,操作员可以没收^没收卡,请联系收单行#38^D^密码错次数超限,操作员可以没收^密码错误次数超限#39^C^可能刷卡操作有误^交易失败,请联系发卡行#40^C^发卡行不支持的交易类型^交易失败,请联系发卡行#41^D^挂失的卡,操作员可以没收^没收卡,请联系收单行#42^B^发卡行找不到此账户^交易失败,请联系发卡方#43^D^被窃卡,操作员可以没收^没收卡,请联系收单行#44^C^可能刷卡操作有误^交易失败,请联系发卡行#51^C^账户内余额不足^余额不足,请查询#52^C^无此支票账户^交易失败,请联系发卡行#53^C^无此储蓄卡账户^交易失败,请联系发卡行#54^C^过期的卡^过期卡,请联系发卡行#55^C^密码输错^密码错,请重试#56^C^发卡行找不到此账户^交易失败,请联系发卡行#57^C^不允许持卡人进行的交易^交易失败,请联系发卡行#58^C^该商户不允许进行的交易^终端无效,请联系收单行或银联#59^C^^交易失败,请联系发卡行#60^C^^交易失败,请联系发卡行#61^C^一次交易的金额太大^金额太大#62^C^^交易失败,请联系发卡行#63^C^违反安全保密规定^交易失败,请联系发卡行#64^C^原始金额不正确^交易失败,请联系发卡行#65^C^超出取款次数限制^超出取款次数限制#66^C^受卡方呼受理方安全保密部门^交易失败,请联系收单行或银联#67^C^捕捉(没收卡)^没收卡#68^C^发卡行规定时间内没有回答^交易超时,请重试#75^C^允许的输入PIN次数超限^密码错误次数超限#77^D^POS批次与网络中心不一致^请向网络中心签到#79^C^POS终端上传的脱机数据对账不平^POS终端重传脱机数据#90^C^日期切换正在处理^交易失败,请稍后重试#91^C^电话查询发卡方或银联,可重作^交易失败,请稍后重试#92^C^电话查询发卡方或网络中心,可重作^交易失败,请稍后重试#93^C^交易违法,不能完成^交易失败,请联系发卡行#94^C^查询网络中心,可重新签到作交易^交易失败,请稍后重试#95^C^调节控制错^交易失败,请稍后重试#96^C^发卡方或网络中心出现故障^交易失败,请稍后重试#97^D^终端未在中心或银行登记^终端未登记,请联系收单行或银联#98^E^银联收不到发卡行应答^交易超时,请重试#99^B^可重新签到作交易^校验错,请重新签到#A0^B^可重新签到作交易^校验错,请重新签到"
	//s str="#TT^F^交易超时,退货交易不允许重新发起^#FF^D^尝试签到是否成功,如果成功,重试交易,如果不成功,请管理员处理^#ER^B^^#X4^B^交易取消,重试交易^#"
	s strlen=$l(str,"#")
	f i=1:1:strlen d
	.s a=$p(str,"#",i)
	.q:a=""
	.K PLIST
	.s PLIST(2)=$p(a,"^",1)
	.s PLIST(3)=$p(a,"^",2)
	.s PLIST(4)=$p(a,"^",3)
	.s PLIST(5)=$p(a,"^",4)
	.&sql(INSERT INTO DHC_POSTradeCode Values PLIST())
	
	q 0
}

/// /////////////////////////////////////
/// Creator:Lid
/// CreatDate:2011-10-19
/// Descritpion:生成支付小票号,HIS生成，唯一(20位,医院编号(4)+日期(6)+时间(4)+发票表Rowid(6))
/// Input:IBPRowid:银行交易信息表Rowid(DHC_INVBankTradePay),HospDR(医院ID)
/// Output:
/// Return:格式化后的交易流水号
/// Other:
/// Debug:w ##class(web.DHCBillBankLogic).SetHISPrtInvID(1234567899,"1")
ClassMethod SetHISPrtInvID(PrtRowID, HospDR)
{
	n (PrtRowID,HospDR)
	i +HospDR=0 d
	.s HospCode="1001"
	e  d
	.s HospCode=$p(^CT("HOSP",HospDR),"^",1)		
	s CurrDate=$e($zd(+$h,8),3,8)
	s CurrTime=$tr($zt($p($h,",",2),2),":","")
	s tmp="000000"
	s:$l(PrtRowID)>6 PrtRowID=$e(PrtRowID,$l(PrtRowID)-5,$l(PrtRowID))
	s FormatPrtRowid=$e(tmp,1,$l(tmp)-$l(PrtRowID))_PrtRowID
	s rtn=HospCode_CurrDate_CurrTime_FormatPrtRowid
	q rtn
}

/// /////////////////////////////////////
/// Creator:Lid
/// CreatDate:2011-12-05
/// Descritpion:生成HIS的唯一交易号(20位,医院编号(4)+日期(6)+时间(4)+银行交易信息表Rowid(6))
/// Input:
/// Output:
/// Return:格式化后的交易流水号
/// Other:
/// Debug:w ##class(web.DHCBillBankLogic).SetTransactionId(1234567899,"1")
ClassMethod SetTransactionId(IBPRowid, HospDR)
{
	n (IBPRowid,HospDR)
	i +HospDR=0 d
	.s HospCode="1001"
	e  d
	.s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospDR)
	.;s HospCode=$p(^CT("HOSP",HospDR),"^",1)
	.s HospCode=+HospCode
	.
	s ServerCode=$g(^HISServerCode)
	s:ServerCode="" ServerCode=1		
	s CurrDate=$e($zd(+$h,8),3,8)
	s CurrTime=$tr($zt($p($h,",",2),2),":","")
	s tmp="000000"
	s:$l(IBPRowid)>6 IBPRowid=$e(IBPRowid,$l(IBPRowid)-5,$l(IBPRowid))
	s FormatIBPRowid=$e(tmp,1,$l(tmp)-$l(IBPRowid))_IBPRowid
	s rtn=HospCode_CurrDate_CurrTime_FormatIBPRowid
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-10-21
/// Descripiton:生成交易流水号
/// Input:BankCardNO:银行卡号,BankTradeType:交易类型,HospDR:医院ID,ExpStr:扩展信息
/// Output:	
/// Return:	err_"^"_IBPRowID_"^"_TradeID(成功标志^银行交易信息表Rowid^HIS交易流水号)
/// Other:
/// Debug:w ##class(web.DHCBillBankLogic).SetTradeID("","C","1","1^")
ClassMethod SetTradeID(BankCardNO As %String, BankTradeType As %String, HospDR As %String, ExpStr As %String) As %String
{
	n (BankCardNO, BankTradeType,HospDR,ExpStr)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s Guser=$p(ExpStr,"^",1)
	s PrtInvStr=$p(ExpStr,"^",2)
	s BankCode=""
	i +BankCardNO'=0 d
	.s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNO)
	.s BankCode=$p(CardInfo,"^",5)
	s TradeID=""
	;
	;Insert DHC_INVBankTradePay
	k PLIST
	s PLIST(4)=BankCardNO		;IBP_Pan	卡号
	;s CardRowid=$o(^DHCCARDi("CF",0,"CardNo",BankCardNO,""))
	;s myBankCardID=$p(^DHCCARD("CF"),"^",20)
	s TradeDate=+$h
	s TradeTime=$p($h,",",2)
	s PLIST(22)=TradeDate		;IBP_TradeDate HIS交易日期
	s PLIST(23)=TradeTime		;IBP_TradeTime	HIS交易时间
	s PLIST(26)=Guser
	s PLIST(27)=BankTradeType	;IBP_BankTradeType	银行交易类型
	s PLIST(28)=BankCode		;IBP_CardType	卡类型
	s PLIST(29)=HospDR			;IBP_Hospital_Dr 医院指针
	;s PLIST(40)=myBankCardID    ;银行ID
	s PLIST(45)=PrtInvStr
	s myRtn=##class(web.DHCOPBillINVBankPay).INSERT()
	s err=$p(myRtn,"^",1)
	s IBPRowID=$p(myRtn,"^",2)
	q:+err'=0 err_"^^"
	b ;nhcs
	s TradeID=..SetTransactionId(IBPRowID,HospDR)	;生成HIS端交易号
	;更新银行交易信息表
	s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	b ;tro
	i +err'=0 TROLLBACK
	q:+err'=0 err_"^^"
	s PLIST(33)=TradeID	;IBPHISTradeID	HIS交易流水号
	s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)
	i +err'=0 TROLLBACK
	q:+err'=0 err_"^^"
	d ..tc()
	s rtn=err_"^"_IBPRowID_"^"_TradeID
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-11-18
/// Description:保存POS返回信息
/// Input:
/// Return:
/// Other:
/// 													 "OP$2480$$551073$$S2$011111191236000000029$371^29^2^^^"
/// Debug:w ##class(web.DHCBillBankLogic).POSDataSave("OP","2480","","551073","","S2","011111191236000000029",^Lid("POSData",2),"371^29^2^^^")
ClassMethod BMCDataSave(PatType As %String, Guser As %String, PrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, HISTradeID As %String, BankData As %String, ExpStr As %String)
{
	n (PatType, Guser, PrtRowid, AbortPrtRowID, BankCardNO, BankTradeType,HISTradeID,BankData, ExpStr)

	s $ZT="ERROR^DHCSSERR" 
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HISTradeID,"0"))
	d ..tb()
	s err=0
	b ;更新银行交易信息表
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		;00|交易成功|S2|4|5|6|1000000001|20151111|9|10|11|12|13|20111120|20111119|235959|17|0000000002222|CCB|20|建行|22
		s BankData=$g(BankData)
		s Rc=$p(BankData,"|",1)
		s PLIST(2)=Rc								;IBPRc
		s RcDetail=$p(BankData,"|",2)
		s PLIST(3)=RcDetail							;IBP_Rc_detail
		;s PLIST(27)=$p(BankData,"|",3)				;IBP_BankTradePay_DR 交易类型
		s PLIST(37)=$p(BankData,"|",4)				;IBP_mch_Name	商户名称
		s PLIST(11)=$p(BankData,"|",5)				;IBP_mch_id	商户编号
		s PLIST(10)=$p(BankData,"|",6)				;IBP_Tid	终端编号
		s PLIST(4)=$p(BankData,"|",7)				;IBP_Pan	交易卡号
		s PLIST(17)=$p(BankData,"|",8)				;IBP_exp_date	卡片有效期
		s PLIST(12)=$p(BankData,"|",9)				;IBP_batch_no	交易批次号
		s PLIST(38)=$p(BankData,"|",10)				;IBP_oldbatch_no	原交易批次号
		s PLIST(6)=$p(BankData,"|",11)				;IBP_mer_systrace	交易凭证号
		s PLIST(7)=$p(BankData,"|",12)				;IBP_invoice_no	原交易凭证号
		s PLIST(8)=$p(BankData,"|",13)				;IBP_RRN	交易系统检索号
		s PLIST(36)=$p(BankData,"|",14)				;IBP_AccountingDate	银行记账日期
		s PLIST(15)=$p(BankData,"|",15)				;IBP_txn_date	交易日期
		s PLIST(16)=$p(BankData,"|",16)				;IBP_txn_time	交易时间
		s PLIST(9)=$p(BankData,"|",17)				;IBP_Auth_no	授权号
		s PLIST(5)=$p(BankData,"|",18)				;IBP_Tr_amt	银行交易金额
		s PLIST(39)=$p(BankData,"|",19)				;IBP_BankCardType	卡类型(银行)
		s PLIST(35)=$p(BankData,"|",20)				;IBP_Bank_Code	发卡行代码
		s PLIST(14)=$p(BankData,"|",21)				;IBP_Bank_name	发卡行名称
		s PLIST(18)=$p(BankData,"|",22)				;IBP_append_info	凭单内容
		;
		s PLIST(24)=(+$p(BankData,"|",18))/100		;IBP_TradeAmt	his交易金额
		s PLIST(25)=PatType			;IBP_TradeType
		s PLIST(26)=Guser		;IBP_TradeUser_DR
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	}
	i +err=0 {
		s rtn=..UpdateTradeSub(HISTradeID,PrtRowid, AbortPrtRowID)
		s err=$p(rtn,"^",1)
	}
	;
	i +err'=0 d
	.TROLLBACK
	e  d
	.d ..tc()
	;
	q err_$c(2)_$g(IBPRowID)_$c(2)_$g(Rc)_$c(2)_$g(RcDetail)
}

/// Creator:Lid
/// CreatDate:2011-10-26
/// Description:更新银医卡交易明表及在其子表插入对应的发票记录
/// Input:
/// Output:
/// Return:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).UpdateTradeSub("111111111111111111111","180159","")
ClassMethod UpdateTradeSub(TransactionId, PrtRowid, AbortPrtRowid)
{
	n (TransactionId,PrtRowid,AbortPrtRowid)
	s err=0
	;
	;获取原交易记录信息
	s (BankTradeType,OldBankTradePayDR,PaidTransactionId,BankCardNo)=""
	i AbortPrtRowid'="" d
	.s InitInvDR=$p(^DHCINVPRT(AbortPrtRowid),"^",13)	;原发票Rowid
	.s OldBankTradePayDR=..GetCurrentOriginalTradeRowID(InitInvDR) 
	.;s OldBankTradePayDR=..GetOriginalTradeRowID(InitInvDR)
	.s PaidTransactionId=$p(^DHCINVBTP(OldBankTradePayDR),"^",33)	;IBP_HISOldTradeID 为空说明是第一次退费,不为空,则把它挪到新交易记录上,以方便再次退费
	.i PaidTransactionId="" d
	..s PaidTransactionId=OldBankTradePayDR ;IBP_HISTradeID原交易流水
	.s BankCardNo=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
	;
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",TransactionId,"0"))
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		s PLIST(21)=OldBankTradePayDR	;IBP_OldBankTradePay_DR 被撤销的交易记录指针
		s PLIST(34)=PaidTransactionId	;IBP_HISOldTradeID	HIS原交易流水号
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	}
	;
	if +err=0 {
		b ;插子表(DHC_InvBankConSub)
		s PrtRowIDStr=PrtRowid_"|"_AbortPrtRowid
		s InvCount=$L(PrtRowIDStr,"|")
		f k=1:1:InvCount d  q:+err'=0
		.k PLIST
		.s PLIST(0)=+IBPRowID
		.s myPrtRowID=+$p(PrtRowIDStr,"|",k)
		.q:+myPrtRowID=0
		.s PLIST(3)=myPrtRowID
		.i k=1 s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
		.i k=2 s PLIST(4)="A"
		.q:((k=1)&((BankTradeType="V")!(BankTradeType="D"))) 	;撤销预授权及退费时,子表中不插入新记录Rowid
		.s myPayModeDr=""
		.s IPM="0"
		.f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:IPM=""  d
		..s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
		..s PayModeDr=$p(s,"^",1)
		..b
		..s HandComFlag=..GetPayModeHardComm("OP",PayModeDr)
		..q:+HandComFlag=0
		..s myPayModeDr=PayModeDr
		.s IPMDRSub=$o(^DHCINVPRTi(0,"PMDR",myPrtRowID,myPayModeDr,"P","0"))
		.s PLIST(5)=myPrtRowID_"||"_IPMDRSub	;IBS_InvPayMode_DR
		.s PLIST(6)="N"
		.s err=##class(web.DHCOPBillINVBankConSub).INSERT()	
	}
	if ((+err=0)&(+PrtRowid'=0)&(+AbortPrtRowid'=0)){
		 ;部分退费时，把新发票号关联到原交易记录中
		 ;s err=..BankRefundReplay(PrtRowid, AbortPrtRowid,"")
	}
	;
	q err_"^"_IBPRowID
}

/// Creator:tangtao
/// CreatDate:2011-12-07
/// Description:更新银医卡交易明表及在其子表插入对应的发票记录(住院预交金)
/// Input:
/// Output:
/// Return:
/// Debug:w ##class(web.DHCBillBankLogic).UpdateDEPTradeSub("111111111111111111111","180159","")
ClassMethod UpdateDEPTradeSub(TransactionId, PrtRowid, AbortPrtRowid)
{
	n (TransactionId,PrtRowid,AbortPrtRowid)
	s err=0
	;
	;获取原交易记录信息
	s (BankTradeType,OldBankTradePayDR,PaidTransactionId,BankCardNo)=""
	i AbortPrtRowid'="" d
	
    .s PrtStatus=$p(^DHCSFPRINTDETAIL(AbortPrtRowid),"^",8)
    .i PrtStatus=3 d
	..s InitInvNo=$p(^DHCSFPRINTDETAIL(AbortPrtRowid),"^",7)	  ;原预交金收据号
	..s InitInvDR=$o(^DHCSFPRINTDETAIL(0,"RcptNo",InitInvNo,""))
	..s OldBankTradePayDR=..GetDEPOriginalTradeRowID(InitInvDR)
	.i PrtStatus=2 d
	..s OldBankTradePayDR=..GetDEPOriginalTradeRowID(AbortPrtRowid)
	.s PaidTransactionId=$p(^DHCINVBTP(OldBankTradePayDR),"^",33)	;IBP_HISOldTradeID 为空说明是第一次退费,不为空,则把它挪到新交易记录上,以方便再次退费
	.i PaidTransactionId="" d
	..s PaidTransactionId=OldBankTradePayDR ;IBP_HISTradeID原交易流水
	.s BankCardNo=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",TransactionId,"0"))
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		s PLIST(21)=OldBankTradePayDR	;IBP_OldBankTradePay_DR 被撤销的交易记录指针
		s PLIST(34)=PaidTransactionId	;IBP_HISOldTradeID	HIS原交易流水号
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	}
	;
	if +err=0 {
		b ;插子表(DHC_InvBankConSub)
		s PrtRowIDStr=PrtRowid_"|"_AbortPrtRowid
		s InvCount=$L(PrtRowIDStr,"|")
		f k=1:1:InvCount d  q:+err'=0
		.k PLIST
		.s PLIST(0)=+IBPRowID
		.s myPrtRowID=+$p(PrtRowIDStr,"|",k)
		.q:+myPrtRowID=0
		.s PLIST(3)=myPrtRowID
		.i k=1 s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
		.i k=2 s PLIST(4)="A"
		.q:((k=1)&((BankTradeType="V")!(BankTradeType="D"))) 	;撤销预授权及退费时,子表中不插入新记录Rowid
		.s myPayModeDr=""
		.s PayModeDr=$p(^DHCSFPRINTDETAIL(myPrtRowID),"^",9)
		.s ArrcpRowid=$p(^DHCSFPRINTDETAIL(myPrtRowID),"^",5)
		.s HandComFlag=..GetPayModeHardComm("IP",PayModeDr)
		.q:+HandComFlag=0
		.s myPayModeDr=PayModeDr
		.s PLIST(6)="N"
		.;s err=##class(web.DHCIPBillIPRcptBankTrade).INSERT()	
	}
	if ((+err=0)&(+PrtRowid'=0)&(+AbortPrtRowid'=0)) {
		 ;部分退费时，把新发票号关联到原交易记录中
		 ;s err=..BankRefundReplay(PrtRowid, AbortPrtRowid,"")
	}
	;
	q err_"^"_IBPRowID
}

/// Creator:Lid
/// CreatDate:2011-11-18
/// Description:银医卡作废重打
/// Debug:w ##class(web.DHCBillBankLogic).BankRefundReplay(19028414,19028413,"")
ClassMethod BankRefundReplay(NewPrtRowID, AbortRowID, ExpStr)
{
	n (NewPrtRowID,AbortRowID, ExpStr)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s err=0
	b ;获取原发票记录上的银行交易记录指针
	s InitInvRowID=$p(^DHCINVPRT(AbortRowID),"^",13)
	b ;00
	s PaidTransactionId=..GetOriginalTradeRowID(InitInvRowID)
    s OldBankTradePayDR=$p(^DHCINVBTP(PaidTransactionId),"^",33)	;IBP_HISOldTradeID 为空说明是第一次退费,不为空,则把它挪到新交易记录上,以方便再次退费
	i OldBankTradePayDR="" d
	.s OldBankTradePayDR=PaidTransactionId ;IBP_HISTradeID原交易流水
	
	b ;11
	i ((err=0)&(OldBankTradePayDR'="")) d
	.s IBSSub="0"
	.f  s IBSSub=$o(^DHCINVBTP(OldBankTradePayDR,"C",IBSSub)) q:IBSSub=""  d
	..s IBSRowID=OldBankTradePayDR_"||"_IBSSub
	..&sql(UPDATE DHC_INVBankConSub SET IBS_Status='A' WHERE IBS_RowID=:IBSRowID)
	..s err=SQLCODE
	.b ;插入新发票记录
	.k PLIST
	.s PLIST(0)=+OldBankTradePayDR
	.s PLIST(3)=NewPrtRowID
	.s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
	.s myPayModeDr=""
	.s IPM="0"
	.f  s IPM=$o(^DHCINVPRT(NewPrtRowID,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(NewPrtRowID,"P",IPM))
	..s PayModeDr=$p(s,"^",1)
	..s HandComFlag=..GetPayModeHardComm("OP",PayModeDr)
	..q:+HandComFlag=0
	..s myPayModeDr=PayModeDr
	.s IPMDRSub=$o(^DHCINVPRTi(0,"PMDR",NewPrtRowID,myPayModeDr,"P","0"))
	.s PLIST(5)=NewPrtRowID_"||"_IPMDRSub	;IBS_InvPayMode_DR
	.s PLIST(6)="N" 
	.s err=##class(web.DHCOPBillINVBankConSub).INSERT()
	b ;作废重打End
	i err=0 d
	.d ..tc()
	e  d
	.TROLLBACK
	;
	q err
}

/// Creator:Lid
/// CreatDate:2011-10-28
/// Description:验证银医卡支付金额的退费模式()
/// Input:AbortPrtRowID:退费发票的负记录Rowid,PrtRowID:新发票RowID
/// Return:0:全退,1:部分退,2:作废重打
/// Other:
/// Debug:w ##class(web.DHCBillBankLogic).CheckRefundMode("180251","180250")
ClassMethod CheckRefundMode(AbortPrtRowID, PrtRowID)
{
	n (AbortPrtRowID,PrtRowID)
    s Amt1=0,Amt2=0,rtn=""
    q:PrtRowID="" 0	;没有新发票记录，说明是全退
    ;
    i PrtRowID'="" d
    .s IPM="0"
	.f  s IPM=$o(^DHCINVPRT(PrtRowID,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(PrtRowID,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s HandDr=..GetPayModeHardComm("OP",payMDr)
	..i HandDr'="" d
	...s Amt1=Amt1+payMAmt
	;
	i AbortPrtRowID'="" d
	.s IPM="0"
	.f  s IPM=$o(^DHCINVPRT(AbortPrtRowID,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(AbortPrtRowID,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s HandDr=..GetPayModeHardComm("OP",payMDr)
	..i HandDr'="" d
	...s Amt2=Amt2+payMAmt
    ;
    s Amt1=$zabs(Amt1),Amt2=$zabs(Amt2)
    q:Amt1=0 0					;新发票记录的银医卡金额为0时,全退
    q:((Amt1'=0)&(Amt1<Amt2)) 1	;新发票记录的银医卡金额不为0时,部分退
    q:((Amt1'=0)&(Amt1=Amt2)) 2	;作废重打
    q 0
}

/// Creator:Lid
/// CreatDAte:2011-11-10
/// Description: 根据退费发票Rowid获取获取原交易记录信息
/// Input:InitInvDR:原发票RowID
/// Return:
/// Debug: w ##class(web.DHCBillBankLogic).GetOriginalTradeRowID()
ClassMethod GetOriginalTradeRowID(InitInvDR)
{
	new (InitInvDR)
	set OldBankTradePayDR=""
	do {
		if ($d(^DHCINVBTPi(0,"S","IPDR",InitInvDR))){
			set IBPRowID=$o(^DHCINVBTPi(0,"S","IPDR",InitInvDR,""),-1)
			set IBPRc=$p($g(^DHCINVBTP(+IBPRowID)),"^",1)
			set IBPBankTradeType=$p($g(^DHCINVBTP(+IBPRowID)),"^",24)
			if ((IBPBankTradeType="C")&&(IBPRc="00")) {
				set OldBankTradePayDR=IBPRowID
			}
		}
		set InitInvDR=$p(^DHCINVPRT(InitInvDR),"^",29)
	}while((OldBankTradePayDR="")&&(InitInvDR'=""))

	quit OldBankTradePayDR
}

ClassMethod GetCurrentOriginalTradeRowID(InitInvDR)
{
	n (InitInvDR)
	s OldBankTradePayDR=""
	i ($d(^DHCINVBTPi(0,"S","IPDR",InitInvDR))) {	
		s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",InitInvDR,""),-1)	;原交交易记录指针(取最后一条记录)
	}
	s myOldInvDR=$p(^DHCINVPRT(InitInvDR),"^",29)		;正票
	while (+myOldInvDR'=0){
		s InitInvDR=myOldInvDR
		s myOldInvDR=$p(^DHCINVPRT(InitInvDR),"^",29)	;PRT_OldINV_DR		
		;if (+myOldInvDR'=0){
		;	s InitInvDR=myOldInvDR
		;}
		i ($d(^DHCINVBTPi(0,"S","IPDR",InitInvDR))){
		s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",InitInvDR,""),-1)
		}
	}
	q OldBankTradePayDR
}

/// Creator:Lid
/// CreatDate:2011-10-24
/// Description:验证是否需要调用银医卡支付接口.
/// Input:
/// Output:
/// Return:0^:不调用,1^支付方式RowID:调用
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).CheckPayMByPrtRowID("180159","")
ClassMethod CheckPayMByPrtRowID(PrtRowID, AbortPrtRowID)
{
	n (PrtRowID,AbortPrtRowID)
    s rtn=0,Amt=0,HandFlag=0,PayModeDR=""
    s RowidStr=PrtRowID_"|"_AbortPrtRowID
	s num=$l(RowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(RowidStr,"|",i)
	.q:rowid=""
	.s IPM="0"
	.q:'$d(^DHCINVPRT(rowid,"P",IPM))
	.f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(rowid,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s handDr=..GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s Amt=Amt+payMAmt
	...s HandFlag=1
	...s PayModeDR=payMDr
	;
	i ((HandFlag=1)&(Amt'=0)) s rtn=1	//金额为0时也不调用银行接口
	;i (HandFlag=1) s rtn=1
	;
	q rtn_"^"_PayModeDR
}

/// Creator:Lid
/// CreatDate:2011-10-24
/// Description:验证是否需要调用银医卡支付接口.
/// Input:
/// Output:
/// Return:0^:不调用,1^支付方式RowID:调用
/// Other:
/// Modify:tangtao   判断预交金支付方式
/// Debug:w ##class(web.DHCBillBankLogic).CheckPayMByRcptRowID("710653","")
ClassMethod CheckPayMByRcptRowID(PrtRowID, AbortPrtRowID)
{
	n (PrtRowID,AbortPrtRowID)
    s rtn=0,Amt=0,HandFlag=0,PayModeDR=""
    s RowidStr=PrtRowID_"|"_AbortPrtRowID
	s num=$l(RowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(RowidStr,"|",i)
	.q:rowid=""
	.s IPM="0"
	.q:'$d(^DHCSFPRINTDETAIL(rowid))
	.s payMDr=$p(^DHCSFPRINTDETAIL(rowid),"^",9)
	.s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	.s payMAmt=$p(^DHCSFPRINTDETAIL(rowid),"^",6)
	.s handDr=..GetPayModeHardComm("IP",payMDr)
	.i handDr'="" d
	..s Amt=Amt+payMAmt
	..s HandFlag=1
	..s PayModeDR=payMDr
	;
	i ((HandFlag=1)&(Amt'=0)) s rtn=1	//金额为0时也不调用银行接口
	;i (HandFlag=1) s rtn=1
	;
	q rtn_"^"_PayModeDR
}

/// Lid
/// 2011-03-23
/// 银医卡交易失败后，更新支付方式按现金结算
ClassMethod UpdateCARDToCASH(invRowid As %String = "")
{
	;w ##class(web.DHCBillBankLogic).UpdateCARDToCASH(551053)
	n (invRowid)
    s myrtn=1
	s IPMSub="0"
	f  s IPMSub=$o(^DHCINVPRT(invRowid,"P",IPMSub)) q:((IPMSub="")!(+myrtn=0))  d
	.s info=$g(^DHCINVPRT(invRowid,"P",IPMSub))
	.s payMFlag=+$p(info,"^",12)	;自费标志(1:自费，0/空:医保)
	.s PayMDR=$p(info,"^",1)
	.s HandComFlag=..GetPayModeHardComm("OP",PayMDR)
	.q:+HandComFlag=0
	.k PLIST
	.s myIPMRowID=invRowid_"||"_IPMSub
    .s myrtn=##class(web.UDHCINVPayMode).SELECT(myIPMRowID)
	.s PLIST(3)=..GetPayMDrByPayMCode("CASH")
	.s myrtn=##class(web.UDHCINVPayMode).UPDATE(myIPMRowID)
    q myrtn
}

/// Creator:Lid
/// CreatDate:2011-10-29
/// Description:退费时验证交易类型
/// Input:PrtRowID:需退费的发票Rowid
/// Return:S2:退费,S3:退货
/// Debug:w ##class(web.DHCBillBankLogic).CheckRefundTradeType("538572")
ClassMethod CheckRefundTradeType(PrtRowID)
{
	n (PrtRowID)
	s rtn=""
	s IBPRowID=..GetOriginalTradeRowID(PrtRowID)
	q:+IBPRowID=0 rtn
	s TxtDate=$p(^DHCINVBTP(IBPRowID),"^",14)	;IBP_txn_date 银行交易日期
	q:+TxtDate=0 rtn
	s CasheTxtDate=$zdh(TxtDate,8)
	;
	i CasheTxtDate=+$h s rtn="S2"	;南宁需求--银行交易日期与HIS当前日期比较，如果相同是退费，否则为退货。
	e  s rtn="S3"
	;
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-11-08
/// Description:格式化字符串
/// Input:SourceStr:源字符串,FormatLength:格式化长度,FormatChar:补齐字符,Direction:方向(前补(默认):0,后补:1)
/// Return:
/// Other:注:(如果源字符串是金额,则需要先四舍五入,并保留两位有效数字)
/// Debug:w ##class(web.DHCBillBankLogicBJXH).FormatStr("1.00","15"," ")
ClassMethod FormatStr(SourceStr, FormatLength, FormatChar, Direction As %String = "")
{
	n (SourceStr,FormatLength,FormatChar,Direction)
	;替换源代码中的"小数点","空格"
	s SourceStr=$tr(SourceStr,".","")
	s SourceStr=$tr(SourceStr," ","")
	;s SourceStr=##class(web.UDHCJFBaseCommon).Replace(SourceStr,"　","")
	s SourceStr=$TR(SourceStr,"　","")
	s:Direction="" Direction=0	;默认前补
	s tmp=""
	f i=1:1:FormatLength d
	.s tmp=tmp_FormatChar
	i Direction=0 d
	.s FormatStr=$e(tmp,1,FormatLength-$l(SourceStr))_SourceStr
	e  d
	.s FormatStr=SourceStr_$e(tmp,1,FormatLength-$l(SourceStr))
	q FormatStr
}

/// Creator:Lid
/// CreatDate:2011-12-01
/// Description:删除交易明显表记录
/// Input:
/// Return:
/// Debug:w ##class(web.DHCBillBankLogic).DeleteIBP(410,"")
ClassMethod DeleteIBP(IPBRowID, ExpStr)
{
	n (IPBRowID,ExpStr)
	s myrtn=##class(web.DHCOPBillINVBankPay).DELETE(IPBRowID)
	q myrtn
}

/// 门诊预交金
ClassMethod OrderOPDEPPrt(tradeType, InvStr, AorSPrt)
{
 	n (tradeType, InvStr, AorSPrt)
    s PrtStr=-1
    s ^TMP("tt")=tradeType_","_InvStr_","_AorSPrt

    s HospitalDr=""
    i tradeType="C" d
    .q:InvStr="" 
	.q:InvStr="0"
    .s PrtUser=$p(^DHCACD("AccM",+InvStr,"AccPD",$p(InvStr,"||",2)),"^",5)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	e  d
	.q:+AorSPrt=0
	.s PrtUser=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",14)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	;
	i InvStr'="" d
    .s PrtDate=$p(^DHCACD("AccM",+InvStr,"AccPD",$p(InvStr,"||",2)),"^",3)
	.s PrtTime=$p(^DHCACD("AccM",+InvStr,"AccPD",$p(InvStr,"||",2)),"^",4)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    e  d
    .s PrtDate=$p(^DHCACD("AccM",+InvStr,"AccPD",$p(InvStr,"||",2)),"^",3)
	.s PrtTime=$p(^DHCACD("AccM",+InvStr,"AccPD",$p(InvStr,"||",2)),"^",4)
	.s InitRowid=$p(^DHCACD("AccM",+InvStr,"AccPD",$p(InvStr,"||",2)),"^",22) ;退押金对应的原押金
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    s PaymAmt=..GetOPDepBankCardAmt(InvStr_"|"_AorSPrt)  //根据选择获取交退金额
    ;
    ;生成HIS端交易号
	s myExpStr=""_"^"_InvStr_"|"_AorSPrt
	s TradeInfo=..SetTradeID("",tradeType,HospitalDr,myExpStr)
	s err=$p(TradeInfo,"^",1)
	s IBPRowID=$p(TradeInfo,"^",2)
	s HISTradeID=$p(TradeInfo,"^",3)
    s (IBPRRN,OldTradeDate)=""
    
    
    i +AorSPrt'=0 d
    
    .s PrtStatus=$p(^DHCACD("AccM",+AorSPrt,"AccPD",$p(AorSPrt,"||",2)),"^",8)
    .i PrtStatus=3 d
	..s InitInvNo=$p(^DHCACD("AccM",+AorSPrt,"AccPD",$p(AorSPrt,"||",2)),"^",7)	;原预交金收据号
	..s InitInvDR=$o(^DHCACD("AccM",+AorSPrt,"AccPD",$p(AorSPrt,"||",2),""))  ;原预交金
	..s OldBankTradePayDR=..GetPREOriginalTradeRowID(InitInvDR)
	..s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	..s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	..i OldHISTradeID="" d
	...s OldHISTradeID=OldBankTradePayDR
	..s tmp=$g(^DHCINVBTP(OldHISTradeID))
	..s IBPRRN=$p(tmp,"^",7)
	..s OldTradeDate=$p(tmp,"^",14)
	.i PrtStatus=2 d
	..s OldBankTradePayDR=..GetPREOriginalTradeRowID(AorSPrt)
	..s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	..s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	..i OldHISTradeID="" d
	...s OldHISTradeID=OldBankTradePayDR
	..s tmp=$g(^DHCINVBTP(OldHISTradeID))
	..s IBPRRN=$p(tmp,"^",7)
	..s OldTradeDate=$p(tmp,"^",14)
    ;
    ;
    i tradeType="C" s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"
	i ((tradeType="D")!(tradeType="R")) d
	.s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_AorSPrt_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"
    
    q PrtStr
}

// 返回可退押金金额

ClassMethod GetOPDepBankCardAmt(rowidStr)
{
	n (rowidStr)
	s myAmt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.s PayMode=$p(^DHCSFPRINTDETAIL(rowid),"^",9)
	.s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("IP",PayMode)
	.s PayAmt=$p(^DHCSFPRINTDETAIL(rowid),"^",6)
	.i handDr'="" d
	..s myAmt=myAmt+PayAmt

	s myAmt=$fn($zabs(myAmt),"",2)
	q myAmt
}

/// ------------------------------------------------------------------
/// tangtao 
/// 2011-12-07
/// 根据预交金rowid生成POS交易流水号和传参
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("R","","710486")
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("R","","710535")
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("C","710487","")
/// w ##class(web.DHCBillBankLogic).OrderIPInvPrt("D","","710486")
ClassMethod OrderIPDEPPrt(tradeType, InvStr, AorSPrt)
{
	n (tradeType, InvStr, AorSPrt)
    s PrtStr=-1
    s ^TMP("tt")=tradeType_","_InvStr_","_AorSPrt

    s HospitalDr=""
    i tradeType="C" d
    .q:InvStr="" 
	.q:InvStr="0"
    .s PrtUser=$p(^DHCSFPRINTDETAIL(InvStr),"^",14)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	e  d
	.q:+AorSPrt=0
	.s PrtUser=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",14)
	.s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	.s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	;
	i InvStr'="" d
    .s PrtDate=$p(^DHCSFPRINTDETAIL(InvStr),"^",2)
	.s PrtTime=$p(^DHCSFPRINTDETAIL(InvStr),"^",3)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    e  d
    .s PrtDate=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",2)
	.s PrtTime=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",3)
	.s InitRowid=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",7)
	.s PrtDate1=$zd(PrtDate,8)
	.s PrtTime1=$tr($zt(PrtTime,1),":")
    s PaymAmt=..GetIPDepBankCardAmt(InvStr_"|"_AorSPrt)
    ;
    ;生成HIS端交易号
	s myExpStr=""_"^"_InvStr_"|"_AorSPrt
	s TradeInfo=..SetTradeID("",tradeType,HospitalDr,myExpStr)
	s err=$p(TradeInfo,"^",1)
	s IBPRowID=$p(TradeInfo,"^",2)
	s HISTradeID=$p(TradeInfo,"^",3)
    s (IBPRRN,OldTradeDate)=""
    
    
    i +AorSPrt'=0 d
    
    .s PrtStatus=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",8)
    .i PrtStatus=3 d
	..s InitInvNo=$p(^DHCSFPRINTDETAIL(AorSPrt),"^",7)	;原预交金收据号
	..s InitInvDR=$o(^DHCSFPRINTDETAIL(0,"RcptNo",InitInvNo,""))
	..s OldBankTradePayDR=..GetDEPOriginalTradeRowID(InitInvDR)
	..s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	..s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	..i OldHISTradeID="" d
	...s OldHISTradeID=OldBankTradePayDR
	..s tmp=$g(^DHCINVBTP(OldHISTradeID))
	..s IBPRRN=$p(tmp,"^",7)
	..s OldTradeDate=$p(tmp,"^",14)
	.i PrtStatus=2 d
	..s OldBankTradePayDR=..GetDEPOriginalTradeRowID(AorSPrt)
	..s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	..s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	..i OldHISTradeID="" d
	...s OldHISTradeID=OldBankTradePayDR
	..s tmp=$g(^DHCINVBTP(OldHISTradeID))
	..s IBPRRN=$p(tmp,"^",7)
	..s OldTradeDate=$p(tmp,"^",14)
    ;
    ;
    i tradeType="C" s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_""_"#"_""_"#"_""_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"
	i ((tradeType="D")!(tradeType="R")) d
	.s PrtStr=InvStr_"#"_PaymAmt_"#"_PrtDate1_PrtTime1_"#"_IBPRRN_"#"_$e(OldTradeDate,5,8)_"#"_AorSPrt_"#"_HISTradeID_"#"_"05"_"#"_HospCode_"#"_"26"
    
    q PrtStr
}

/// 保存Pos押金数据
ClassMethod GetPOSPreRetInfo()
{
	;记录日志

	s Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	s ^TMPPOSInfo(Date,Time)=POSInfo
	s rtn=0
	b ;111
	i POSInfo["VOL" d
	.s CertInfo=$p(POSInfo,"VOL",2)
	.s TradeRetNo="00"                       ;交易结果
	.s TradeRet="成功"                       ;交易成功
	.s AccName=$p(CertInfo,"|",2)            ;商户名称
	.s AccNo=$p(CertInfo,"|",3)              ;商户编号
	.s TerminalNo=$p(CertInfo,"|",4)         ;终端编号
	.s UserId=$p(CertInfo,"|",5)             ;操作员编号
	.s CardName=$p(CertInfo,"|",6)           ;卡种类
	.s CardNo=$p(CertInfo,"|",7)             ;卡号
    .s OrderNo=$p(CertInfo,"|",8)            ;卡顺序号
    .s TradeType=$p(CertInfo,"|",9)          ;交易类型
    .s FailDate=$p(CertInfo,"|",10)          ;卡失效期
    .s BatchNo=$p(CertInfo,"|",11)           ;批次号
    .s CertNo=$p(CertInfo,"|",12)            ;凭证号
    .s BankTradeDate=$p(CertInfo,"|",13)     ;交易日期时间
    .s AuthNo=$p(CertInfo,"|",14)            ;授权码
    .s TransRefNo=$p(CertInfo,"|",15)        ;交易参考号
    .s BankTradeAmt=$p(CertInfo,"|",16)      ;交易金额
    .s RemarkInfo=$p(CertInfo,"|",17)        ;备注
    .s SetType=$p(CertInfo,"|",18)           ;结算类型
    .s SetDate=$p(CertInfo,"|",19)           ;结算日期时间
    .s TradeStatictics=$p(CertInfo,"|",20)   ;交易统计
    .s HisTradeNo=$p(CertInfo,"|",21)        ;HIS交易流水号
    .i PatType="OP" d
    ..i PrtRowid'="" d
    ...s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCINVPRT(PrtRowid),"^",8)
    ..e  d
    ...s PrtDate=$p(^DHCINVPRT(ParkRowid),"^",5)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCINVPRT(ParkRowid),"^",20)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCINVPRT(ParkRowid),"^",8)
    .i PatType="DEP" d
    ..i PrtRowid'="" d
    ...s PrtDate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",2)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",3)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",8)
    ..e  d
    ...s PrtDate=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",2)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",3)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",8)
    .i PatType="IP" d
    ..s PrtDate=$p(^DHCINVPRTZY(PrtRowid),"^",2)      ;HIS打发票日期
    ..s PrtTime=$p(^DHCINVPRTZY(PrtRowid),"^",3)      ;HIS打发票日期
    ..s PrtFlag=$p(^DHCINVPRTZY(PrtRowid),"^",8)
    .i PrtFlag="S" s PrtFlag="A"
    .i PrtFlag="I" s PrtFlag="N"
    .i ((PrtFlag=2)!(PrtFlag=3)) s PrtFlag="A"
    .i ((PrtFlag=1)) s PrtFlag="N"
    .i TradeType="消费" s TradeType="C"
    .i TradeType="消费撤销" s TradeType="R"
    .i TradeType="退货" s TradeType="D"
    .;
    .s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HisTradeNo,"0"))
	.b ;更新银行交易信息表
	.s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
    .;
    .k PLIST
    .s PLIST(2)=TradeRetNo
    .s PLIST(3)=TradeRet
    .s PLIST(4)=CardNo
    .s PLIST(5)=BankTradeAmt
    .s PLIST(6)=CertNo
    .s PLIST(8)=TransRefNo
    .s PLIST(9)=AuthNo
    .s PLIST(10)=TerminalNo
    .s PLIST(11)=AccNo
    .s PLIST(12)=BatchNo
    .s PLIST(13)=UserId
    .s PLIST(14)=CardName 
    .s PLIST(15)=$p($zd(+$h,3),"-",1)_$e(BankTradeDate,1,4)         ;月日，转换
    .s PLIST(16)=$e(BankTradeDate,5,10)        ;时分秒，转换
    .s PLIST(17)=FailDate                      ;月日
    .s PLIST(18)=RemarkInfo
    .;s PLIST(19)=PrtFlag
    .s PLIST(20)=TransRefNo 
    .s PLIST(21)=""                            ;原交易参考号
    .s PLIST(22)=PrtDate
    .s PLIST(23)=PrtTime
    .s PLIST(24)=BankTradeAmt/100
    .s PLIST(25)=PatType
    .s PLIST(26)=UserId
    .s PLIST(27)=TradeType 
    .s PLIST(29)=HospiDr                       ;医院代码
    .s PLIST(32)="26"                            ;暂时写死,交易渠道
    .s PLIST(33)=HisTradeNo
    .s PLIST(34)=""                            ;原HIS交易流水号
    .s PLIST(35)=AccName
    .s PLIST(36)=SetType
    .s PLIST(37)=SetDate
    .s PLIST(38)=TradeStatictics
    .s PLIST(39)=INVOrAPI
    .s PLIST(40)="05"
    .d ..tb()
	.s myRtn=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	.b ;ttt3
	.s rtn=$p(myRtn,"^",1)
	.i +rtn=0 d
	..i PatType="OP" d
	...s err=..UpdateTradeSub(HisTradeNo,PrtRowid, ParkRowid)
	...s rtn=$p(err,"^",1)
	..e  i PatType="DEP" d
	...s err=..UpdateDEPTradeSub(HisTradeNo,PrtRowid, ParkRowid)
	...s rtn=$p(err,"^",1)
	..e  i PatType="IP" d
	...b ;ttt123
	...s err=..UpdateIPINVTradeSub(HisTradeNo,PrtRowid,DEPPrtRowid,ArrcpRowid)
	...s rtn=$p(err,"^",1)
	...b 
	..e  d
	...s rtn=0
	.i +rtn=0 d
	..d ..tc()
	.e  d
	..Trollback
	..s ^TMPPOSInfo(Date,Time)=POSInfo_"^"_PrtRowid_"^"_ParkRowid_"^"_rtn
    q rtn
}

/// Creator：  tangtao
/// Date：     2011-11-06
/// Function： 保存POS返回数据
/// 												OP,C,DLL,,1263405,INV,28,1,,,"								
/// w ##class(web.DHCBillBankLogic).GetPOSRetInfo("OP","C","DLL",^TMPPOSInfo("2013-05-15","17:23:38"),"1771486","INV","28",1,"","","")
/// w ##class(web.DHCBillBankLogic).GetPOSRetInfo("DEP","R","DLL",^TMPPOSInfo("2011-12-15","20:06:05"),"","DEP","12",1,"710612")
/// w ##class(web.DHCBillBankLogic).GetPOSRetInfo("IP","D","DLL",^TMPPOSInfo("2011-12-17","16:40:35"),"253865","IP","12",1,"",710621,"19251770||1")
ClassMethod GetPOSRetInfo(PatType, TradeType, Status, POSInfo, PrtRowid, INVOrAPI, PaymDr, HospiDr, ParkRowid, DEPPrtRowid, ArrcpRowid) As %String
{
	;记录日志
	s Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	s ^TMPPOSInfo(Date,Time)=POSInfo
	s rtn=0
	b ;111
	i POSInfo["VOU" d
	.s CertInfo=POSInfo ;$p(POSInfo,"VOL",2)
	.s TradeRetNo="00"                       ;交易结果
	.s TradeRet="成功"                       ;交易成功
	.s AccName="山东省立医院"  ;$p(CertInfo,"|",2)            ;商户名称
	.s AccNo=$p(CertInfo,"|",9)              ;商户编号
	.s TerminalNo=$p(CertInfo,"|",10)         ;终端编号
	.s UserId=$p(CertInfo,"|",11)             ;操作员编号
	.s CardName=$p(CertInfo,"|",12)           ;卡种类
	.s CardNo=$p(CertInfo,"|",13)             ;卡号
    .s OrderNo=$p(CertInfo,"|",14)            ;卡顺序号
    .s TradeType=$p(CertInfo,"|",4)          ;交易类型
    .s FailDate=$p(CertInfo,"|",16)          ;卡失效期
    .s BatchNo=$p(CertInfo,"|",17)           ;批次号
    .s CertNo=$p(CertInfo,"|",18)            ;凭证号
    .s BankTradeDate=$p(CertInfo,"|",19)     ;交易日期时间
    .s AuthNo=$p(CertInfo,"|",20)            ;授权码
    .s TransRefNo=$p(CertInfo,"|",21)        ;交易参考号
    .s BankTradeAmt=$p(CertInfo,"|",22)      ;交易金额
    .s RemarkInfo=$p(CertInfo,"|",23)        ;备注
    .s SetType=$p(CertInfo,"|",24)           ;结算类型
    .s SetDate=$p(CertInfo,"|",25)           ;结算日期时间
    .s TradeStatictics=$p(CertInfo,"|",26)   ;交易统计
    .s HisTradeNo=$p(CertInfo,"|",27)        ;HIS交易流水号
    .i PatType="OP" d
    ..i PrtRowid'="" d
    ...s PrtDate=$p(^DHCINVPRT(PrtRowid),"^",5)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCINVPRT(PrtRowid),"^",20)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCINVPRT(PrtRowid),"^",8)
    ..e  d
    ...s PrtDate=$p(^DHCINVPRT(ParkRowid),"^",5)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCINVPRT(ParkRowid),"^",20)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCINVPRT(ParkRowid),"^",8)
    .i PatType="DEP" d
    ..i PrtRowid'="" d
    ...s PrtDate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",2)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",3)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",8)
    ..e  d
    ...s PrtDate=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",2)      ;HIS打发票日期
    ...s PrtTime=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",3)      ;HIS打发票日期
    ...s PrtFlag=$p(^DHCSFPRINTDETAIL(ParkRowid),"^",8)
    .i PatType="IP" d
    ..s PrtDate=$p(^DHCINVPRTZY(PrtRowid),"^",2)      ;HIS打发票日期
    ..s PrtTime=$p(^DHCINVPRTZY(PrtRowid),"^",3)      ;HIS打发票日期
    ..s PrtFlag=$p(^DHCINVPRTZY(PrtRowid),"^",8)
    .i PrtFlag="S" s PrtFlag="A"
    .i PrtFlag="I" s PrtFlag="N"
    .i ((PrtFlag=2)!(PrtFlag=3)) s PrtFlag="A"
    .i ((PrtFlag=1)) s PrtFlag="N"
    .i TradeType["消费" s TradeType="C"
    .i TradeType["消费撤销" s TradeType="R"
    .i TradeType["退货" s TradeType="D"
    .;
    .s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HisTradeNo,"0"))
	.b ;更新银行交易信息表
	.s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
    .;
    .k PLIST
    .s PLIST(2)=TradeRetNo
    .s PLIST(3)=TradeRet
    .s PLIST(4)=CardNo
    .s PLIST(5)=BankTradeAmt
    .s PLIST(6)=CertNo
    .s PLIST(8)=TransRefNo
    .s PLIST(9)=AuthNo
    .s PLIST(10)=TerminalNo
    .s PLIST(11)=AccNo
    .s PLIST(12)=BatchNo
    .s PLIST(13)=UserId
    .s PLIST(14)=CardName 
    .s PLIST(15)=$e(BankTradeDate,1,4)  ;$p($zd(+$h,3),"-",1)_$e(BankTradeDate,1,4)         ;月日，转换
    .s PLIST(16)=$e(BankTradeDate,5,10)        ;时分秒，转换
    .s PIST(17)=FailDate                      ;月日
    .s PLIST(18)=RemarkInfo
    .;s PLIST(19)=PrtFlag
    .s PLIST(20)=TransRefNo 
    .s PLIST(21)=""                            ;原交易参考号
    .s PLIST(22)=PrtDate
    .s PLIST(23)=PrtTime
    .s PLIST(24)=BankTradeAmt/100
    .s PLIST(25)=PatType
    .s PLIST(26)=UserId
    .s PLIST(27)=TradeType 
    .s PLIST(29)=HospiDr                       ;医院代码
    .s PLIST(32)="26"                            ;暂时写死,交易渠道
    .s PLIST(33)=HisTradeNo
    .s PLIST(34)=""                            ;原HIS交易流水号
    .s PLIST(35)=AccName
    .s PLIST(36)=SetType
    .s PLIST(37)=SetDate
    .s PLIST(38)=TradeStatictics
    .s PLIST(39)=INVOrAPI
    .s PLIST(40)="05"
    .d ..tb()
	.s myRtn=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	.b ;ttt3
	.s rtn=$p(myRtn,"^",1)
	.i +rtn=0 d
	..i PatType="OP" d
	...s err=..UpdateTradeSub(HisTradeNo,PrtRowid, ParkRowid)
	...s rtn=$p(err,"^",1)
	..e  i PatType="DEP" d
	...s err=..UpdateDEPTradeSub(HisTradeNo,PrtRowid, ParkRowid)
	...s rtn=$p(err,"^",1)
	..e  i PatType="IP" d
	...b ;ttt123
	...s err=..UpdateIPINVTradeSub(HisTradeNo,PrtRowid,DEPPrtRowid,ArrcpRowid)
	...s rtn=$p(err,"^",1)
	...b 
	..e  d
	...s rtn=0
	.i +rtn=0 d
	..d ..tc()
	.e  d
	..Trollback
	..;s ^TMPPOSInfo(Date,Time)=POSInfo_"^"_PrtRowid_"^"_ParkRowid_"^"_rtn
    q rtn
}

// 删除门诊预交金数据

// w ##class(web.DHCBillBankLogic).DeletePreDeposit("299974||3")

ClassMethod DeletePreDeposit(PreRowid)
{
	n (PreRowid)
	s ^TMP("DELDHCSFPRINTDETAIL")=PreRowid
	;1.删除预交金表 dhc_accpredeposit及子表 dhc_accprepaymode
	;2.更新账户余额
	
	s $ZT="ERROR^DHCSSERR"
	s err=0
	s sum=$p(^DHCACD("AccM",+PreRowid,"AccPD",$p(PreRowid,"||",2)),"^",2)
	s accRowid=+PreRowid
	d ..tb()
	&sql(DELETE FROM dhc_accprepaymode WHERE APPM_AccPD_ParRef= :PreRowid)	
 	s err=SQLCODE
	i err=0 d
	&sql(DELETE FROM dhc_accpredeposit WHERE AccPD_RowID= :PreRowid)	
	s err=SQLCODE
	i err=0 d
	&sql(update dhc_accmanager set AccM_Balance=AccM_Balance-:sum where AccM_RowID=:accRowid)
	s err=SQLCODE
	i +err=0 d
	.d ..tc()
	e  d
	.trollback
	
	q err
}

/// tangtao
/// 2011-12-08
/// 调用POS或者银医卡交预交金失败后回滚
/// w ##class(web.DHCBillBankLogic).DeleteYJInvPrt(710507)
ClassMethod DeleteYJInvPrt(PrtRowid)
{
	n (PrtRowid)
	s ^TMP("DELDHCSFPRINTDETAIL")=PrtRowid
	;1.删除预交金表 dhc_sfprintdetial
	;2.删除ar_receipts及其子表
	;3.更新预交金发放表 dhc_sfreceipt
	
	s $ZT="ERROR^DHCSSERR"
	
	s myrtn=0
	
	q:PrtRowid="" "0"
	q:PrtRowid=0 "0"
	q:($d(^DHCSFPRINTDETAIL(PrtRowid))=10)
	
	s myHandDate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^", 21)
	s:(myHandDate'="") myrtn=111			;结算过的预交金不能删除
	s myFlag=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",8)
	s myUserDR=$p(^DHCSFPRINTDETAIL(PrtRowid),"^", 14)
	s arrcprowid=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",5)
	s myPRTINV=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",1)
	q:(myFlag'="1")
	
	d ..tb()
	
	;删除预交金表
	s myrtn=##class(web.DHCBillBankLogic).DHCSFPRINTDETAILDELETE(PrtRowid)

	;删除ar_receipts
	if (+myrtn=0) d
	.s myrtn=##class(web.DHCBillBankLogic).ARRECEIPTSDELETE(arrcprowid)

	;删除预交金发放表
	if (+myrtn=0) d
	.s myINVRowID=0
	.f  s myINVRowID=$o(^DHCSFRECEIPT(0,"lquser",myUserDR, myINVRowID))  q:(myINVRowID="")  D
	..q:myINVRowID=0
	..s myBegINV=$p(^DHCSFRECEIPT(myINVRowID),"^",3)
	..s myEndINV=$p(^DHCSFRECEIPT(myINVRowID),"^",4)
	..s myLastINV=$p(^DHCSFRECEIPT(myINVRowID),"^",5)
	..s myINVType=$p(^DHCSFRECEIPT(myINVRowID),"^",15)		;"I"
	..q:(myINVType'="I")		;不是住院押金
	..q:'((+myBegINV<=+myPRTINV)&(+myPRTINV<=+myEndINV))
	..i '(+myLastINV=(+myPRTINV+1)) d
	...;如果不是最后一张发票报错，不能办理删除
	...s myrtn=110
	..q:(+myrtn)
	..s myrtn=##class(web.DHCBillBankLogic).UpdateDHCSFReceipt(myUserDR, myPRTINV)

	b	;Tro
	i +myrtn=0 d
	.d ..tc()
	e  d
	.trollback
	
	q myrtn
}

/// 2011-12-08
ClassMethod DHCSFPRINTDETAILDELETE(RowId)
{
	s $ZT="ERROR^SSERR" 
	d ..tb()

	&sql(DELETE FROM dhc_sfprintdetail WHERE prt_rowid= :RowId)
	d ..tc()

	q SQLCODE
}

/// 删除预交金数据（回滚调用）
ClassMethod PreDepositDELETE(Rowid)
{
	s $ZT="ERROR^SSERR" 
	d ..tb()

	&sql(DELETE FROM DHC_AccPreDeposit WHERE AccPD_RowID= :RowId)
	d ..tc()

	q SQLCODE
}

ClassMethod ARRECEIPTSDELETE(RowId)
{
	s $ZT="ERROR^SSERR" 
	d ..tb()

	&sql(DELETE FROM AR_Receipts WHERE ARRCP_RowId= :RowId)
	d ..tc()

	q SQLCODE
}

/// tangtao
/// 2011-12-08
/// 更新预交金发放表
/// w ##class(web.DHCBillBankLogic).UpdateDHCSFReceipt("22104","110069061")
ClassMethod UpdateDHCSFReceipt(suser As %String, rcpno As %String)
{
	n (suser, rcpno)
	s endno="",rowid=""
	&sql(select rcpt_endno,rcpt_rowid into :endno,:rowid from dhc_sfreceipt 
	     where rcpt_rowid=(select min(rcpt_rowid) from dhc_sfreceipt 
	     where rcpt_lquser= :suser and rcpt_useflag="1" and rcpt_loc="I"))
	b	;;UpdateReceipNO
	s len=$LENGTH(endno)
	if $LENGTH(rcpno)<len d
	.s prelen=len-$LENGTH(rcpno)
	.for i=1:1:prelen s rcpno="0"_rcpno
	
	i rcpno>endno  d
	.&sql(update dhc_sfreceipt set rcpt_useflag="2" where rcpt_rowid= :rowid)
	.s rtn=SQLCODE
	.q:SQLCODE
	.&sql(select count(*) into :num from dhc_sfreceipt where (rcpt_useflag="" or rcpt_useflag is null) and rcpt_rowid<>"0" and rcpt_lquser=:suser and rcpt_loc="O")
	.s rtn=SQLCODE
	.q:SQLCODE
	.i num'=0  d
	..&sql(select min(rcpt_rowid) into :rowid1  from dhc_sfreceipt where (rcpt_useflag="" or rcpt_useflag is null) and rcpt_rowid<>"0" and rcpt_lquser=:suser and rcpt_loc="O")
	..s rtn=SQLCODE
	..q:SQLCODE
	..&sql(update dhc_sfreceipt set rcpt_useflag="Y" where rcpt_rowid=:rowid1)
	..s rtn=SQLCODE
	..q:SQLCODE
	e  d
	.&sql(update dhc_sfreceipt set rcpt_currentno= :rcpno where rcpt_rowid= :rowid)
	.s rtn=SQLCODE
	.q:SQLCODE
	
	q rtn
}

/// Creator:tangtao
/// CreatDate:2011-12-09
/// Description:预交金作废重打(安徽省立有此功能，实际是把原预交金状态置为作废,重新收取一次预交金,
/// 			无负记录),此时入参NewPrtRowID为新预交金rowid，AbortRowID为原预交金rowid
/// Debug:w ##class(web.DHCBillBankLogic).BankRefundDEPReplay(710560,"","")
/// Debug:w ##class(web.DHCBillBankLogic).BankRefundDEPReplay(710573,710572,"")
ClassMethod BankRefundDEPReplay(NewPrtRowID, AbortRowID, ExpStr)
{
	n (NewPrtRowID,AbortRowID, ExpStr)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s err=0
	b ;获取原发票记录上的银行交易记录指针
	s PaidTransactionId=..GetDEPOriginalTradeRowID(AbortRowID)
    s OldBankTradePayDR=$p(^DHCINVBTP(PaidTransactionId),"^",33)	;IBP_HISOldTradeID 为空说明是第一次退费,不为空,则把它挪到新交易记录上,以方便再次退费
	i OldBankTradePayDR="" d
	.s OldBankTradePayDR=PaidTransactionId ;IBP_HISTradeID原交易流水
	
	i ((err=0)&(OldBankTradePayDR'="")) d
	.s IPRcptSub="0"
	.f  s IPRcptSub=$o(^DHCIPRCPTBANKTRADESUB(OldBankTradePayDR,"IPRcpt",IPRcptSub)) q:IPRcptSub=""  d
	..s IPRcptRowID=OldBankTradePayDR_"||"_IPRcptSub
	..;&sql(UPDATE DHC_IPRcptBankTradeSub SET IPRcpt_Status='A' WHERE IPRcpt_RowId=:IPRcptRowID)
	..s err=SQLCODE
	.b ;插入新预交金记录
	.
	.k PLIST
	.s PLIST(0)=+OldBankTradePayDR
	.s PLIST(3)=NewPrtRowID
	.s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid)
	.s myPayModeDr=""
	.s PayModeDr=$p(^DHCSFPRINTDETAIL(NewPrtRowID),"^",9)
	.s ArrcpRowid=$p(^DHCSFPRINTDETAIL(NewPrtRowID),"^",5)
	.s HandComFlag=..GetPayModeHardComm("IP",PayModeDr)
	.q:+HandComFlag=0
	.s myPayModeDr=PayModeDr
	.s PLIST(6)="N"
	.;s err=##class(web.DHCIPBillIPRcptBankTrade).INSERT()	
	.
	b ;作废重打End
	i err=0 d
	.d ..tc()
	e  d
	.TROLLBACK
	;
	q err
}

/// 	Creator:tangtao
/// 	CreatDAte:2011-12-07
/// 	Description:根据退预交金收据Rowid获取获取原交易记录信息
/// 	Input:InitInvDR:原预交金收据Rowid
/// 	Return:
/// 	Debug:
ClassMethod GetDEPOriginalTradeRowID(InitInvDR)
{
	n (InitInvDR)
	s OldBankTradePayDR=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",InitInvDR,""),-1)	;原交交易记录指针(取最后一条记录)
	q OldBankTradePayDR
}

ClassMethod GetPREOriginalTradeRowID(InitInvDR)
{
	n (InitInvDR)
	s OldBankTradePayDR=$o(^DHCACD("AccM",+PreRowid,"AccPD",$p(PreRowid,"||",2)),-1)	;预交金原交交易记录指针(取最后一条记录)
	q OldBankTradePayDR
}

/// 	Creator:tangtao
/// 	CreatDAte:2011-12-07
/// 	Description:根据退预交金收据Rowid获取获取原交易记录信息,异常处理时使用，这里专门给作废
/// 				押金做处理，作废押金时DHC_IPRcptBankTradeSub中IPRcpt_Deposit_Dr存的是原押金
/// 				的rowid,只能通过IPRcpt_ConsultStatus这个状态区别是收费交易还是退费交易,"N"
/// 				为收费交易，"A"为作废交易
/// 	Input:InitInvDR:原预交金收据Rowid
/// 	Return:
/// 	Debug:
ClassMethod GetDEPOriginalYCCL(InitInvDR)
{
	n (InitInvDR)
	s OldBankTradePayDR=""
	s Nflag=0,Aflag=0
	f  s OldBankTradePayDR=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",InitInvDR,OldBankTradePayDR)) q:OldBankTradePayDR=""  d
	.s IPRcptSub=""
	.f  s IPRcptSub=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",InitInvDR,OldBankTradePayDR,"IPRcpt",IPRcptSub)) q:IPRcptSub=""  d
	..q:IPRcptSub=0
	..s IPRcptConsultStatus=$P(^DHCIPRCPTBANKTRADESUB(OldBankTradePayDR,"IPRcpt",IPRcptSub),"^",4)
	..i IPRcptConsultStatus="N" d
	...s Nflag=1
	..e  d
	...s Aflag=1
	q Nflag_"^"_Aflag
}

/// tangtao
/// 2011-12-08
/// 判断退预交金是当日退费还是隔日退货
/// 0    入参为空
/// 1    当日退费
/// 2    隔日退货
/// w ##class(web.DHCBillBankLogic).JudgeDEPDate(710478,710524)
ClassMethod JudgeDEPDate(PrtRowid, AOrSRowid)
{
	q:PrtRowid="" "0"
	q:AOrSRowid="" "0"
	s flag=0
	s PrtDate=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",2)
	s AOrSDate=$p(^DHCSFPRINTDETAIL(AOrSRowid),"^",2)
	i PrtDate'=AOrSDate d
	.s flag="2"
	e  d
	.s flag="1"
	
	q flag
}

/// tangtao
/// 2011-12-08
/// 出院结算的时候POS的话只退不收，此处判断出院结算的押金是退费还是退货
/// 0    入参为空
/// 1    当日全退退费
/// 2    当日部分退费退货、隔日退货
/// 入参为原预交金rowid、住院收费对应的ar_rcptpaymodede的rowid
/// w ##class(web.DHCBillBankLogic).JudgeIPINVDEPDate(710622,"19251748||1")
ClassMethod JudgeIPINVDEPDate(PrePrtRowid, ARRCPPayRowid)
{
	q:PrePrtRowid="" "0"
	q:ARRCPPayRowid="" "0"
	s flag=0
	s PrtDate=$p(^DHCSFPRINTDETAIL(PrePrtRowid),"^",2)
	s PrtAmt=$p(^DHCSFPRINTDETAIL(PrePrtRowid),"^",6)
	s PrtAmt=$zabs(PrtAmt)
	s AOrSDate=$p(^ARRCP($p(ARRCPPayRowid,"||",1)),"^",26)
	s AOrSAmt=$p(^ARRCP($p(ARRCPPayRowid,"||",1),"PAYM",$p(ARRCPPayRowid,"||",2)),"^",3)
	s AOrSAmt=$zabs(AOrSAmt)
	i PrtDate'=AOrSDate d
	.s flag="2"
	e  d
	.i AOrSAmt<PrtAmt s flag="2"
	.e  s flag="1"
	
	q flag
}

/// w ##class(web.DHCBillBankLogic).GetYJRowid(710644)
ClassMethod GetYJRowid(PrtRowid)
{
	q:PrtRowid="" "-1"
	s RcptNo=$p(^DHCSFPRINTDETAIL(PrtRowid),"^",1)
	s YJRowid=$o(^DHCSFPRINTDETAIL(0,"RefundRcpt",RcptNo,""))
	q YJRowid
}

/// tangtao
/// 2011-12-28
/// 出院结算发票异常处理判断
/// 	;^TMPDHCINVPRTZY(27809764)=软POS^11^10011112290945001251-11-622848*********8514&软POS^10^10011112291556001296-150-622848*********8514
ClassMethod JudgeInvPrtFalseInfo(PrtInvNo, BillNo)
{
	q:((BillNo="")!(PrtInvNo="")) "-1"
	q:$d(^TMPDHCINVPRTZY(BillNo))=0 "-2"
	s PrtRowid=$o(^DHCINVPRTZY(0,"INV",PrtInvNo,""))
	s POSPayInfo=^TMPDHCINVPRTZY(BillNo)
	s ArrcpPaymStr=""
	s IBPRowid=""
	f  s IBPRowid=$o(^DHCIPINVBANKTRADESUB(0,"Invoice",PrtRowid,IBPRowid)) q:IBPRowid=""  d
	.q:IBPRowid=0
	.s IPInvSub=""
	.f  s IPInvSub=$o(^DHCIPINVBANKTRADESUB(0,"Invoice",PrtRowid,IBPRowid,"IPInv",IPInvSub)) q:IPInvSub=""  d
	..q:IPInvSub=0
	..s ArrcpPaym=$p(^DHCIPINVBANKTRADESUB(IBPRowid,"IPInv",IPInvSub),"^",5)
	..i ArrcpPaymStr="" s ArrcpPaymStr=ArrcpPaym
	..e  s ArrcpPaymStr=ArrcpPaymStr_"^"_ArrcpPaym
	
	s ArrcpPaymLen=$l(ArrcpPaymStr,"^")
	f i=1:1:ArrcpPaymLen d
	.s $p(POSPayInfo,"&",i)=""
	
	s JudgeFlag=0
	f i=1:1:$l(POSPayInfo,"&") d
	.s POSPay=$p(POSPayInfo,"&",i)
	.q:POSPay=""
	.s JudgeFlag=1
	
	i JudgeFlag=0 s POSPayInfo=0

	q POSPayInfo
}

/// Lid
/// 2011-03-03
/// 根据住院发票表Rowid获取软POS支付金额
ClassMethod GetIPInvBankCardAmt(rowid)
{
	n (rowid)
	q:'$d(^DHCINVPRTZY(rowid)) 0.00
	s BillNo=$p(^DHCINVPRTZY(rowid),"^",5)
    s ArrcpId="",amt=0.00,TrueArrcpId=""
	f  s ArrcpId=$o(^ARRCP("ARPBL",BillNo,ArrcpId),-1) q:ArrcpId=""  d
	.q:ArrcpId=0
	.s ArrcpASub=""
	.f  s ArrcpASub=$o(^ARRCP("ARPBL",BillNo,ArrcpId,ArrcpASub)) q:((ArrcpASub="")!(TrueArrcpId'=""))  d
	..s DepositDr=$p(^ARRCP(ArrcpId,"RAL",ArrcpASub),"^",18)
	..q:DepositDr=1
	..s TrueArrcpId=ArrcpId
	
	q:TrueArrcpId="" 0.00
	s ArrcpPSub="0"
	f  s ArrcpPSub=$o(^ARRCP(TrueArrcpId,"PAYM",ArrcpPSub)) q:ArrcpPSub=""  d
	.q:ArrcpPSub=0
	.s PayInfo=^ARRCP(TrueArrcpId,"PAYM",ArrcpPSub)    
	.s PayMode=$p(PayInfo,"^",1)
	.s PayModeCode=$p(^CT("CTPM",PayMode),"^",1)
	.s PayAmt=+$p(PayInfo,"^",3)
	.i PayAmt<0 s AmtFlag=0
	.e  s AmtFlag=1
	.s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("IP",PayMode)
	.i handDr'="" d
	..i PayModeCode="MISPOS" d
	...i amt=0.00 s amt=$fn($zabs(PayAmt),"",2)_"^"_AmtFlag_"^"_TrueArrcpId_"||"_ArrcpPSub
	...e  s amt=amt_"&"_$fn($zabs(PayAmt),"",2)_"^"_AmtFlag_"^"_TrueArrcpId_"||"_ArrcpPSub
	..i PayModeCode="CARDCPP" d
	...s amt=amt+PayAmt
	
	i ((amt'["||")&(amt'["^")) s amt=$fn($zabs(amt),"",2)
	q amt
}

/// Lid
/// 2011-03-03
/// 根据住院押金表Rowid获取软POS及银医卡支付金额
ClassMethod GetIPDepBankCardAmt(rowidStr)
{
	n (rowidStr)
	s myAmt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:rowid=""
	.s PayMode=$p(^DHCSFPRINTDETAIL(rowid),"^",9)
	.s handDr=##class(web.DHCBillBankLogic).GetPayModeHardComm("IP",PayMode)
	.s PayAmt=$p(^DHCSFPRINTDETAIL(rowid),"^",6)
	.i handDr'="" d
	..s myAmt=myAmt+PayAmt

	s myAmt=$fn($zabs(myAmt),"",2)
	q myAmt
}

/// tangtao
/// 2011-11-15
/// 打印凭条信息
/// w ##class(web.DHCBillBankLogic).PrintAccInfo("C",19027628,0)
/// w ##class(web.DHCBillBankLogic).PrintAccInfo("R",19028402,1)
/// w ##class(web.DHCBillBankLogic).PrintAccInfo("D","19251804||1","1^0^IP")
ClassMethod PrintAccInfo(TradeType, PrtRowid, ExpStr)
{
	q:PrtRowid="" ""
	q:PrtRowid=0 ""
	s PatType=$p(ExpStr,"^",3)
	s IBPRowid=""
	i PatType="OP" d
	.s IBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,""))
	i PatType="DEP" d
	.s IBPRowid=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",PrtRowid,""))
	i PatType="IP" d
	.s IBPRowid=$o(^DHCIPINVBANKTRADESUB(0,"ARPayM",PrtRowid,""))
	q:IBPRowid=0 ""
	q:((PatType="IP")!(PatType="DEP")) ""
	
	s PrintInfo=""	
	s AccName=$p(^DHCINVBTP(IBPRowid),"^",34)             ;商户名称
	s AccNo=$p(^DHCINVBTP(IBPRowid),"^",10)               ;商户编号
	s TerminalNo=$p(^DHCINVBTP(IBPRowid),"^",9)           ;终端编号
	s UserId=$p(^DHCINVBTP(IBPRowid),"^",12)              ;操作员号
	s Bank=$p(^DHCINVBTP(IBPRowid),"^",13)                ;发 卡 行
	s Bank=$tr($e(Bank,23,$l(Bank))," ")
	s CardNo=$p(^DHCINVBTP(IBPRowid),"^",3)               ;卡    号
	s FailDate=$p(^DHCINVBTP(IBPRowid),"^",16)            ;卡有效期
	s TradeType=$p(^DHCINVBTP(IBPRowid),"^",24)           ;交易类型
	s BatchNo=$p(^DHCINVBTP(IBPRowid),"^",11)             ;批 次 号
	s CertNo=$p(^DHCINVBTP(IBPRowid),"^",5)               ;凭 证 号
	s AuthNo=$p(^DHCINVBTP(IBPRowid),"^",8)               ;授 权 码
	s BankTradeDate=$p(^DHCINVBTP(IBPRowid),"^",14)       ;日期
	s BankTradeTime=$p(^DHCINVBTP(IBPRowid),"^",15)       ;时间
	s TransRefNo=$p(^DHCINVBTP(IBPRowid),"^",7)           ;系统参考号
	s TradeAmt=$p(^DHCINVBTP(IBPRowid),"^",23)            ;金额(RMB)
	s TradeAmt=$fn(TradeAmt,"",2)
	s TRemarkInfo=$p(^DHCINVBTP(IBPRowid),"^",17)            ;备注
	i TradeType="C" s TradeType="消费"
    i TradeType="R" s TradeType="消费撤销"
    i TradeType="D" s TradeType="退货"

    s BankTradeDate1=$e(BankTradeDate,1,4)_"/"_$e(BankTradeDate,5,6)_"/"_$e(BankTradeDate,7,8)
    s BankTradeTime1=$e(BankTradeTime,1,2)_":"_$e(BankTradeTime,3,4)_":"_$e(BankTradeTime,5,6)
    s BankTradeDate=BankTradeDate1,BankTradeTime=BankTradeTime1
    
    i $p(ExpStr,"^",2)="1" s STR2="         (商户联)  (重打)",STR11="         (商户联)  (重打)"
    e  s STR2="",STR11=""
    s PrintInfo="AccName"_$c(2)_"商户名称:"_AccName_"^"_"AccNo"_$c(2)_"商户编号:"_AccNo_"^"_"TerminalNo"_$c(2)_"终端编号:"_TerminalNo
    s PrintInfo=PrintInfo_"^"_"UserId"_$c(2)_"操作员号:"_UserId_"^"_"Bank"_$c(2)_"发 卡 行:"_Bank_"^"_"CardNo"_$c(2)_"卡    号:"_CardNo
    s PrintInfo=PrintInfo_"^"_"FailDate"_$c(2)_"卡有效期:"_FailDate_"^"_"TradeType"_$c(2)_"交易类型:"_TradeType_"^"_"BatchNo"_$c(2)_"批 次 号:"_BatchNo
    s PrintInfo=PrintInfo_"^"_"CertNo"_$c(2)_"凭 证 号:"_CertNo_"^"_"AuthNo"_$c(2)_"授 权 码:"_AuthNo_"^"_"BankTradeDate"_$c(2)_"日期时间:"_BankTradeDate_" "_BankTradeTime
    s PrintInfo=PrintInfo_"^"_"TransRefNo"_$c(2)_"系统参考号:"_TransRefNo_"^"_"TradeAmt"_$c(2)_"金额(RMB):"_TradeAmt_"^"_"TRemarkInfo"_$c(2)_"备    注:"_TRemarkInfo
    s PrintInfo=PrintInfo_"^"_"STR1"_$c(2)_""_"^"_"STR2"_$c(2)_STR2_"^"_"STR3"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR4"_$c(2)_""_"^"_"STR5"_$c(2)_""_"^"_"STR6"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR7"_$c(2)_""_"^"_"STR8"_$c(2)_""_"^"_"STR9"_$c(2)_""

    s PrintInfo=PrintInfo_"^"_"STR10"_$c(2)_""_"^"_"STR11"_$c(2)_STR11_"^"_"STR12"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR13"_$c(2)_""_"^"_"STR14"_$c(2)_""_"^"_"STR15"_$c(2)_""
    s PrintInfo=PrintInfo_"^"_"STR16"_$c(2)_""_"^"_"STR17"_$c(2)_""
	
	q PrintInfo
}

/// Creator:tangtao
/// CreatDate:2011-12-07
/// Description:更新银医卡交易明表及在其子表插入对应的发票记录(住院收费发票)
/// Input:
/// Output:
/// Return:
/// Debug:w ##class(web.DHCBillBankLogic).UpdateIPINVTradeSub("10011112171640000680","253865",710621,"19251770||1")
ClassMethod UpdateIPINVTradeSub(TransactionId, PrtRowid, DEPPrtRowid, ArrcpRowid)
{
	n (TransactionId,PrtRowid,DEPPrtRowid, ArrcpRowid)
	s err=0
	
	s ^TMP("ttt",1)=TransactionId_","_PrtRowid_","_DEPPrtRowid_","_ArrcpRowid
	;获取原交易记录信息
	s (BankTradeType,OldBankTradePayDR,PaidTransactionId,BankCardNo)=""

	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",TransactionId,"0"))
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		s PLIST(21)=OldBankTradePayDR	;IBP_OldBankTradePay_DR 被撤销的交易记录指针
		s PLIST(34)=""	                ;IBP_HISOldTradeID	HIS原交易流水号  住院收费不存在一张发票多次退的问题
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	}
	;
	if +err=0 {
		b ;插子表(DHC_InvBankConSub)
		k PLIST
		
		s PLIST(0)=+IBPRowID
		s PLIST(3)=PrtRowid
		s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
		s PLIST(5)=ArrcpRowid
		s PLIST(6)=DEPPrtRowid
		s PLIST(7)="N"
		;s err=##class(web.DHCIPBillInvBankTrade).INSERT()	
	}
	;if ((+err=0)&(+PrtRowid'=0)&(+AbortPrtRowid'=0)) {
		 ;部分退费时，把新发票号关联到原交易记录中
		 ;s err=..BankRefundReplay(PrtRowid, AbortPrtRowid,"")
	;}
	;
	q err_"^"_IBPRowID
}

/// ------------------------------------------------------------------
/// w ##class(web.DHCBillBankLogic).test12321()
ClassMethod test12321()
{
	s ftpIP="192.192.10.104"
	s userName="pos"
	s password="2011dhcc1201"
	s port=21
	;门诊对账数据
	s fileName="AHSLYY_05_"_$tr($zd(+$h-2,3),"-")
	;s file="DOWNLOAD\05\AHSLYY_02_20120117083014.txt"
	b ;11
	s stream=##class(%GlobalCharacterStream).%New()
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.TranslateTable="UTF8"
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "请查证IP地址,用户名,密码,端口号是否正确"
	b ;11223
	if 'ftp.Retrieve(file,stream) Quit "对账文本不存在"
	;w $tr($tr($p($ZDATETIME($ZUTIL(188),3,1,6)," ",2),":"),"."),!
	s Len=0,FalseNum=0,strflag=1
    while ('stream.AtEnd) {
	    s Info=stream.ReadLine()
	    b ;bbbbb
	    if (strflag'=1) {
    		q:(Info="")
    		;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..SaveCARDCPPBalanceInfo(Info)
    		i +rtn'=0 d
    		.s FalseNum=FalseNum+1
			.;失败记录
			.s ^TMPSaveBalance(fileName,FalseNum)=Info
		}
		s strflag=strflag+1
	}
	
    If 'ftp.Logout() Quit "文本导入成功,FTP关闭失败."
    
	q FalseNum
}

}
