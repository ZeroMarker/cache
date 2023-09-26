Import SQLUser

/// wangjian
/// 2014-07-10
/// 支付宝业务处理类
Class DHCAliPay.ChargeInterface.AliPayLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:wangjian
/// CreatDate:2014-07-10
/// Descripiton:获取支付宝入参信息
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院),PayModeDr:支付方式
/// 		NewPrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HospDR:医院指针
/// 		ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员ID^退费原因)
/// BankTradeType=D NewPrtRowid 不为空  AbortPrtRowid 为空时候为医保分解
/// BankTradeType=D AbortPrtRowid 不为空时候为退费
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).AliPay("OP","2347088","","","D","166^281^5^^^5^")
/// OP!!2244280!!D!166^281^5^
ClassMethod AliPay(PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	New (PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	Set rtn=0
	Set Amt=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(NewPrtRowid_"|"_AbortPrtRowID)
	b ;
	If (+Amt>0) Set rtn=..AliPayNew(PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	/*Set Mark=$p(ExpStr,"^",7)
	if (Mark="") Set Mark="退号"
	Set err=$p(rtn,"^",1)
	If (err=0)&&(+Amt>0) Do
	.If +NewPrtRowid'=0 Set PrtPatientId=$p(^DHCINVPRT(NewPrtRowid),"^",15)
	.If +AbortPrtRowID'=0 Set PrtPatientId=$p(^DHCINVPRT(AbortPrtRowID),"^",15)
	.Set Message=Mark_"成功,退费金额"_Amt_"元"
	.Set Mesrtn=##class(MHC.PublicMessage).SendToAli(PrtPatientId,Message,"REFOUNDFEE","","")
	*/
	Quit rtn
}

ClassMethod AliPayNew(PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	s ^WANGJIAN("AliPay")=PatType_"!"_NewPrtRowid_"!"_AbortPrtRowID_"!"_BankCardNO_"!"_BankTradeType_"!"_ExpStr
	;q 0
	q:"C^D"'[BankTradeType "-1001^"_"^获取入参失败,交易类型不正确."
	i PatType="OP" s PayMInfo=..CheckPayMByPrtRowID(NewPrtRowid,AbortPrtRowID)
    s CardPayFlag=$p(PayMInfo,"^",1)
    s PayModeDr=$p(PayMInfo,"^",2)
	q:+CardPayFlag=0 "-1"	;非支付宝支付
	s ExtUserID=$p(ExpStr,"^",6)
	i BankTradeType="C" d
	.;记录发票对应的卡号,避免HIS成功,银行失败时没有交易信息,无法获得发票对应的卡号
	.;s prtrtn=##class(web.DHCBillBMCLogic).InsertPrtAndBankNo(NewPrtRowid,BankCardNO)
	
	s RefundMode=0
	i PatType="OP" d
	.s RefundMode=..CheckRefundMode(AbortPrtRowID,NewPrtRowid)
	q:+RefundMode=2 "-1"	;作废重打不调接口 
	
	s rtn=..GetPayInput(PatType, PayModeDr, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	s err=+$p(rtn,$c(2),1) ;_$c(2)_$g(IBPRowID)_$c(2)_$g(TransactionId)_$c(2)_$g(PaySeqNoStr)
	b ;支付返回
	s IBPRowID=$p(rtn,$c(2),2)
	s HISTradeNo=$p(rtn,$c(2),3)
	s RefTradeInfo=$p(rtn,$c(2),4)
	if ((+err'=0)&&(+IBPRowID'=0)) {
		;s rtn=##class(DHCAliPay.ChargeInterface.AliPayLogic).DeleteIBP(IBPRowID,"")	
	}
	q:+err'=0 "-1001^"_err_"^获取入参失败."
	
	;收费时,TotalAmt是所有发票的总金额;退费时,TotalAmt是新发票和负票的差额;如果是全退,TotalAmt是负票的金额
	i (PatType="OP")&&(+AbortPrtRowID'=0){
		s TotalAmt=..GetOPInvAliPayAmt(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
	}
	i (PatType="OP")&&(+AbortPrtRowID=0)&&(+NewPrtRowid'=0){
		s TotalAmt=..GetOPInvAliPayAmtForYB(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
	}
	i (BankTradeType="D"){
	s Mark=$p(ExpStr,"^",7)
	i (Mark="") Set Mark="退号"
	;OldAliPayNo_"^"_OldHisTradeNo_"^"_Patientid_"^"_AdmInfo_"^"_PayMode
	s AdmInfo=$p(RefTradeInfo,"^",4)
	s OldHisTradeNo=$p(RefTradeInfo,"^",2)
	s OldAliPayNo=$p(RefTradeInfo,"^",1)
	s Patientid=$p(RefTradeInfo,"^",3)
	s PayMode=$p(RefTradeInfo,"^",5)
	B ;;;
	s ^DHCBillAliPay("MZJF","HisTradeNOConPrt",HISTradeNo)=NewPrtRowid_"^"_AbortPrtRowID ;异步更新交易子表用
	;s rtnstr="<orderpayreturn><error></error><issuccess>T</issuccess><tradeno>2014071115539223</tradeno><money>0.02</money><memo>é????????·</memo><batchno>KMYK1407111841463434</batchno><patientid>416826</patientid></orderpayreturn>"
	s rtnstr=##Class(MHC.PublicPay).ReturnPay(OldAliPayNo,HISTradeNo,Patientid,TotalAmt,Mark)
	;记录同步消息不以同步消息为准
	b ;;222
	
	s ^DHCBillAliPay("MZJF","RefoudInfo",HISTradeNo)=rtnstr ;记录请求退费同步消息
	s AliObj=##class(DHCAliPay.DHCEntity.PCA.orderpayreturn).%New()
    d AliObj.XMLNodeDeserialize(.AliObj,"orderpayreturn",rtnstr)
    s Alierror=AliObj.error
    s Aliissuccess=AliObj.issuccess ;T 成功 F 失败
    s Alitradeno=AliObj.tradeno ;交易流水号
    s Alimoney=AliObj.money
    s Alimemo=AliObj.memo
    s Alibatchno=AliObj.batchno ;订单号
    s Alipatientid=AliObj.patientid
	s PrtStr=NewPrtRowid_"^"_AbortPrtRowID
	i Aliissuccess="T" d
	.;保存支付宝返回信息
	.;s ReTradeInfo=HISTradeNo_"^"_Alimoney_"^"_Alitradeno_"^"_"" 
	.;his订单号^交易金额^支付宝交易流水号^支付宝账号
	.;s rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).UpdateAliPayInfo(AdmInfo,ReTradeInfo,ExtUserID,BankTradeType,PrtStr,PayMode,"")
	.s rtn=0
	e  d
	.s rtn=-1008_Alierror_"调用支付宝退费请求失败"
	}
	s err=$p(rtn,"^",1)
	/*
	s err=$p(rtn,"^",1)
	s IBPRowID=$p(rtn,"^",2)
	s ResultCode=$p(rtn,"^",3)
	s ResultContent=$p(rtn,"^",4)
	if ((+err'=0)&&(ResultCode'="0000")){
		;s rtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowID,"")	
	}
	q:((+err'=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	q:((+err=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	q:((+err'=0)&&(ResultCode="0000")) "-1002^"_err_"^支付宝交易成功,HIS更新交易记录记录失败"
	;
	q err_"^"_ResultCode_"^"_ResultContent
	*/
	q err
}

/// Creator:wangjian
/// CreatDate:2014-07-10
/// Description:验证是否需要调用支付宝接口.
/// Input:
/// Output:
/// Return:0^:不调用,1^支付方式RowID:调用
/// Other:
/// Debug:w ##class(DHCAliPay.ChargeInterface.AliPayLogic).CheckPayMByPrtRowID("2244232","")
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
	..s handInfo=..GetPayModeHardComm("OP",payMDr)
	..s handDr=$p(handInfo,"^",1)
	..i handDr'="" d
	...s Amt=Amt+payMAmt
	...s HandFlag=handDr
	...s PayModeDR=payMDr
	;
	i ((HandFlag>0)&(Amt'=0)) s rtn=HandFlag	//金额为0时也不调用银行接口
	;i (HandFlag=1) s rtn=1
	;
	q rtn_"^"_PayModeDR
}

/// wangjian
/// 2014-07-11
/// 判断是否调用接口(非空则调用)
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetPayModeHardComm("OP",32)
ClassMethod GetPayModeHardComm(invType, PayMode)
{
	n (invType,PayMode)
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

/// Creator:wangjian
/// CreatDate:2014-07-11
/// Description:验证支付宝金额的退费模式()
/// Input:AbortPrtRowID:退费发票的负记录Rowid,PrtRowID:新发票RowID
/// Return:0:全退,1:部分退,2:作废重打
/// Other:
/// Debug:w ##class(DHCAliPay.ChargeInterface.AliPayLogic).CheckRefundMode("","")
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

ClassMethod GetPayInput(PatType As %String, PayModeDr As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PatType, PayModeDr, NewPrtRowid,AbortPrtRowID, BankCardNO, BankTradeType, ExpStr,Input)
	s CTLocDR=$p(ExpStr,"^",1)
	s GroupDR=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",3)
	s ClientType=$p(ExpStr,"^",4)
	s TerminalID=$p(ExpStr,"^",5)
	;s TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId(TerminalID)
	s ExtUserID=$p(ExpStr,"^",6)
	i HospDR="" s HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
	i (+AbortPrtRowID'=0) {
		;根据发票Rowid取原始的发票Rowid
		s IBPRowID="",IBSSub=""
		i (PatType="OP"){
			s OrgPrtRowID=..GetOrgPrtRowID(AbortPrtRowID,NewPrtRowid,"")
			s IBPRowID=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,"0"))
			s IBSSub=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,IBPRowID,"C",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
			s TotalAmt=..GetOPInvAliPayAmt(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
		} ;根据原始发票Rowid获取原交易信息
		s OrgTradeInfo=..GetOrgTradeData(PatType,IBPRowID,IBSSub,"")
		s AdmInfo=$p(OrgTradeInfo,"^",4)
		s CardNO=""
		s PatientId=$p(OrgTradeInfo,"^",3)
	}
	;针对医保分解
	i (+NewPrtRowid'=0)&&(+AbortPrtRowID=0) {
		;根据发票Rowid取原始的发票Rowid
		s IBPRowID="",IBSSub=""
		i (PatType="OP"){
			s OrgPrtRowID=NewPrtRowid
			s IBPRowID=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,"0"))
			s IBSSub=$o(^DHCINVALITPi(0,"S","IPDR",OrgPrtRowID,IBPRowID,"C",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
			s TotalAmt=..GetOPInvAliPayAmtForYB(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
		} ;根据原始发票Rowid获取原交易信息
		s OrgTradeInfo=..GetOrgTradeData(PatType,IBPRowID,IBSSub,"")
		s AdmInfo=$p(OrgTradeInfo,"^",4)
		s CardNO=""
		s PatientId=$p(OrgTradeInfo,"^",3)
	 }
	
	s myExpstr=ExtUserID_"^3^"_PatType_"^"_TotalAmt_"^"_IBPRowID
	s rtn=##class(DHCAliPay.ChargeInterface.DHCOPBillAliPayExp).SetHisTradeNoInfo(AdmInfo,PatientId,CardNO,BankTradeType,HospDR,myExpstr)
	b ;22
	q:+rtn'=0 "SetTradeErr"
	s HisTradeNo=$p(rtn,"^",3)
	s IBPRowID=$p(rtn,"^",2)
	s err=+rtn
	q err_$c(2)_$g(IBPRowID)_$c(2)_$g(HisTradeNo)_$c(2)_$g(OrgTradeInfo)
}

/// Creator:Lid
/// CreatDate:2011-12-01
/// Description:删除交易明显表记录
/// Input:
/// Return:
/// Debug:w ##class(DHCAliPay.ChargeInterface.AliPayLogic).DeleteIBP(410,"")
ClassMethod DeleteIBP(IPBRowID, ExpStr)
{
	n (IPBRowID,ExpStr)
	s myrtn=##class(web.DHCOPBillINVBankPay).DELETE(IPBRowID)
	q myrtn
}

/// Creator:wangjian
/// CreatDate:2014-07-11
/// Description:根据发票RowID获取最原始的发票rowid
/// Input:AbortPrtRowID:负票Rowid,NewPrtRowid:新发票Rowid,ExpStr:扩展信息("^^^^^^")
/// Output:
/// Return:
/// Other:
/// Debug:w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOrgPrtRowID("19028776","19028777","")
ClassMethod GetOrgPrtRowID(AbortPrtRowID, NewPrtRowid, ExpStr)
{
	New (AbortPrtRowID,NewPrtRowid,ExpStr)
	Set myPrtRowID=""
	If (+NewPrtRowid=0) {
		b ;新发票Rowid为空,一定上全退,负责为部分退费
		Set InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;PRT_initInv_DR
		Set myPrtRowID=InitInvDR
	}Else{
		Set OldInvDR=$p(^DHCINVPRT(NewPrtRowid),"^",29)	;PRT_OldINV_DR
		Set myPrtRowID=OldInvDR	
	}
	Set myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)
	While (+myOldInvDR'=0) {
		Set myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	;PRT_OldINV_DR
		If (+myOldInvDR'=0){
			Set myPrtRowID=myOldInvDR
		}
	}
	Quit myPrtRowID
}

/// Creator:wangjian
/// CreatDate:2014-07-11
/// Description:获取原交易信息
/// Input:IBPRowID:原交易明细表Rowid,IBSSub:原交易明细表子表Sub,ExpStr:扩展信息("^^^^^^")
/// Output:
/// Return:
/// Other:
/// Debug:w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOrgTradeData("OP","850","1","")
ClassMethod GetOrgTradeData(PatType, IBPRowID, IBSSub, ExpStr)
{
	n (PatType,IBPRowID,IBSSub,ExpStr)
	;
	s IBSRowd=IBPRowID_"||"_IBSSub
	s AdmInfo=$p(^DHCINVALITP(IBPRowID),"^",45)
	s OldAliPayNo=$p(^DHCINVALITP(IBPRowID),"^",7)
	s OldHisTradeNo=$p(^DHCINVALITP(IBPRowID),"^",32)
	s Patientid=$p(^DHCINVALITP(IBPRowID),"^",48)
	s PayMode=$p(^DHCINVALITP(IBPRowID),"^",46)
	i (PatType="OP"){
		s OldPaySeqNo=$p(^DHCINVALITP(IBPRowID,"C",IBSSub),"^",5)
	}elseif(PatType="IP"){
		s OldPaySeqNo=""
	}else{
		s OldPaySeqNo=OldHisTradeID
	}
	;
	s rtn=OldAliPayNo_"^"_OldHisTradeNo_"^"_Patientid_"^"_AdmInfo_"^"_PayMode
	b ;rtn 111
	q rtn
}

/// wangjian
/// 2014-07-11
/// 根据门诊发票表Rowid获取支付宝支付额
/// 要考虑医保扩展表
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt("2244307|2244311")
ClassMethod GetOPInvAliPayAmt(rowidStr)
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
	...i handDr'="" d
	....s amt=amt+payMAmt
	.e  d
	..s InsuInvID=$o(^DHCINVPRTInsu("0","PRT",rowid,""))
	..s InsuIPM=0
	..q:'$d(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM))
	..f  s InsuIPM=$o(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM)) q:InsuIPM=""  d
	...s s=$g(^DHCINVPRTInsu(InsuInvID,"P",InsuIPM))
	...s payMDr=$p(s,"^",1)
	...s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	...i payMCode="ALIPAY" b ;;
	...s payMAmt=+$p(s,"^",3)
	...s handDr=..GetPayModeHardComm("OP",payMDr)
	...i handDr'="" d
	....s amt=amt+payMAmt
	
	s amt=$fn($zabs(amt),"",2)
	
	q amt
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
	..s handDr=..GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s amt=amt+payMAmt
	
	s amt=$fn($zabs(amt),"",2)
	
	q amt
}

/// 医保分解成功后消息推送
/// 入参：DHC_INVPRT表ID
/// wangjian 2014-07-15
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).SendInsuMessageToAli(2244455)
ClassMethod SendInsuMessageToAli(myPRTRowIDStr, ExpStr)
{
	New (myPRTRowIDStr,ExpStr)
	Set rtn=0
	;推送消息
	For i=1:1:$l(myPRTRowIDStr,"^")   Do
	.Set myPRTRowID=$p(myPRTRowIDStr,"^",i)
	.Quit:+myPRTRowID=0
	.Set PRTAmt=$p(^DHCINVPRT(myPRTRowID),"^",1)
	.Set PRTPatient=$p(^DHCINVPRT(myPRTRowID),"^",15)
	.Set SelfAmt=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetOPInvAliPayAmt(myPRTRowID)
	.Set RefAmt=PRTAmt-SelfAmt
	.Set Message="医保结算成功^您的就诊费用总金额"_$fn(PRTAmt,"",2)_"元,个人支付"_$fn(SelfAmt,"",2)_"元,医保支付"_$fn(RefAmt,"",2)_"元,其中"_$fn(RefAmt,"",2)_"元将于3个工作日内退还至您的支付账户."	
	.Set rtn=##class(MHC.PublicMessage).SendToAli(PRTPatient,Message,"INSU","","")
	If rtn=200 Set rtn=0
	Quit 0
}

ClassMethod test()
{
    s rtnstr="<orderpayreturn><error></error><is_success>T</is_success><trade_no>交易号</trade_no><money>0.01</money><memo>东华退款测试</memo><batch_no>新订单</batch_no><patientid>21341241</patientid></orderpayreturn>"
	s AliObj=##class(DHCAliPay.DHCEntity.PCA.orderpayreturn).%New()
    d AliObj.XMLNodeDeserialize(.AliObj,"orderpayreturn",rtnstr)
    s Alierror=AliObj.error
    s Aliissuccess=AliObj.issuccess ;T 成功 F 失败
    s Alitradeno=AliObj.tradeno ;交易流水号
    s Alimoney=AliObj.money
    s Alimemo=AliObj.memo
    s Alibatchno=AliObj.batchno ;订单号
    s Alipatientid=AliObj.patientid
	b ;;;
}

/// wangjian
/// 2014-07-16
/// 根据门诊发票表Rowid推送结算的医嘱导诊
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).SendOrderMessageToAli(2244739)
ClassMethod SendOrderMessageToAli(InvStr)
{
    New (InvStr)
	New SendMessToAli
	Set PrtPatientID=""
	For i=1:1:$l(InvStr,"^") Do
	.Set InvDr=$p(InvStr,"^",i)
	.Quit:+InvDr=0
	.Set Condr=""
	.For  Set Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  Quit:Condr=""  Do
	..Set Bill=$p($g(^DHCBCI(Condr)),"^",2)
	..Set BillOrd=""
	..For  Set BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  Quit:BillOrd=""   Do
	...Quit:BillOrd=0
	...Set OrderId=$p(^DHCPB(Bill,"O",BillOrd),"^",4)
	...Set OrderRowid=+OrderId ,itemsub=$p(OrderId,"||",2)
	...Set OrdRecLoc=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	...Set RecLocDesc=$p($g(^CTLOC(OrdRecLoc)),"^",2)
	...If RecLocDesc["-" Set RecLocDesc=$p(RecLocDesc,"-",2)
	...Set LocAdress=$g(^CTLOC(OrdRecLoc,"ADDR",1))
	...;If RecLocDesc["药房" Set PHWindow=##class(web.UDHCOPINVPrtData12).GetPrescWinByPrtRowID(InvDr),RecLocDesc=RecLocDesc_"("_PHWindow_")"
	...Set SendMessToAli("MZJF","OrderLoc",$j,OrdRecLoc)=LocAdress_"--"_RecLocDesc
	...Set PrtPatientID=$p(^DHCINVPRT(InvDr),"^",15)
	Set PrtPatient=PrtPatientID
	;
	Set Str=""
	Set myOrdRecLoc=""
	For  Set myOrdRecLoc=$o(SendMessToAli("MZJF","OrderLoc",$j,myOrdRecLoc)) Q:myOrdRecLoc=""  Do
	.If Str="" Set Str=$g(SendMessToAli("MZJF","OrderLoc",$j,myOrdRecLoc))
	.Else  Set Str=Str_"^"_$g(SendMessToAli("MZJF","OrderLoc",$j,myOrdRecLoc))
	b ;Str
	If $l(Str,",")=1 Set Message="请您到:"_Str_"^检查、检验、治疗或取药.^^注意:如需打印发票或退费请到任意收费窗口办理。"
	Else  Set Message="请您分别到"_Str_"就诊或取药"
	Set rtn=##class(MHC.PublicMessage).SendToAli(PrtPatient,Message,"PAYEDORDER","","")
	Quit 0
}

ClassMethod DHCINVBankBalanceINSERT()
{
	k PLIST(1)
	;s $ZT="ERROR^DHCSSERR" d ..tb()
	&sql(INSERT INTO DHC_INVAliBalance Values PLIST())
	;d ..tc()
	
	s myRowID=%ROWID
	i 'SQLCODE d ..DHCINVBankBalanceSELECT(myRowID)
	
	q SQLCODE_"^"_myRowID
}

ClassMethod DHCINVBankBalanceSELECT(RowId)
{
	k PLIST
	&sql(SELECT * INTO PLIST() FROM DHC_INVAliBalance WHERE IAT_RowID= :RowId) 
	s PLIST=$o(PLIST(""),-1)
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

/// wangjian
/// 2014-07-28
/// 按日期批量生产对账文件
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).BuildFTPFileByDate("2015-03-09","2015-03-10")
ClassMethod BuildFTPFileByDate(StDate, EndDate)
{
	i StDate["-" s StDate=$zdh(StDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	f Date=StDate:1:EndDate d
	.s myfileName="ZYDY_"_$zd(Date,8)_"_ZHANGWUMINGXI" 
	.;"KYDFEY_"_$zd(+$h-1,8)_"_ZHANGWUMINGXI"
	.s rtn=##class(DHCAliPay.ChargeInterface.AliPayLogic).GetRecTXTFromFTPNew(myfileName)
	.w !, myfileName_" 导入状态:"_rtn
	q 0
}

/// wangjian
/// 2014-12-24
/// 支付宝绑卡给没有账户的卡号建账户
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).BuildAccount()
ClassMethod BuildAccount(CardNo)
{
 ;str=AccountNo_"^"_papmi_"^"_RegNo_"^"_CardNo_"^"_user_"^"_Password_"^"_Depprice_"^"_AccountType_"^"_CredType_"^"_IDCardNo_"^"_CardID
 n (CardNo)
 s rtn=0
 s CardRowid=$O(^DHCCARDi("CF",0,"CardNo",CardNo,""))
 q:CardRowid="" 0
 s CardAccDr=$p(^DHCCARD("CF",CardRowid),"^",1)
 q:+CardAccDr'=0 rtn
 s PapmiDr=$p(^DHCCARD("CF",CardRowid),"^",4)
 s RegNo=$p(^DHCCARD("CF",CardRowid),"^",6)
 s User=$o(^SSU("SSUSR",0,"SSUSR_Initials","ALIPAY001",""))
 s CardType=$p(^DHCCARD("CF",CardRowid),"^",16)
 s AccInfo="^"_PapmiDr_"^"_RegNo_"^"_CardNo_"^"_User_"^^0^^"_CardType_"^"_CardNo_"^"_CardRowid
 b ;
 s rtn=##class(web.UDHCAccManageCLS).NewAccount("","",AccInfo,"")
 b ;rtn
 q rtn
}

/// ///在指定FTP服务器上获取对账数据///////////////////////////////
/// wangjian
/// 2014-07-18
/// 导入POS对账文件，使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(DHCAliPay.ChargeInterface.AliPayLogic).GetRecTXTFromFTPNew("")
/// ftp://10.4.132.26   
ClassMethod GetRecTXTFromFTPNew(inputName)
{
	n (inputName)
	s ftpIP="172.26.199.176"
	s userName="administrator"
	s password="!QAZ2wsxZXCasd"
	s port=21
	;门诊对账数据
	s path="/alifile/"
    i inputName="" d
    .s fileName="ZYDY_"_$zd(+$h-1,8)_"_ZHANGWUMINGXI"  ;
    e   s fileName=inputName
	s file=path_fileName_".txt"
	
	;b ;1
	s stream=##class(%GlobalCharacterStream).%New()
	s ftp=##class(%Net.FtpSession).%New()
	;s ftp.TranslateTable="UTF8"
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "请查证IP地址,用户名,密码,端口号是否正确"
	;获取文本列表
	n fileArray,key
	i 'ftp.NameList(path,.fileArray) q "获取FTP目录文件列表失败"
	s key="",i=$i(BanList)
	f  s BanList(i)=fileArray.GetNext(.key),i=i+1 q:(key="")
	;b ;zw BanList
	s num=""
	f  s num=$o(BanList(num)) q:num=""  d
	.s BanListInfo=BanList(num)
	.q:BanListInfo'=file
	.;s file=path_BanListInfo
	.;b ;2
	.s file=BanListInfo
	;b ;得到正确文本
	if 'ftp.Retrieve(file,stream) Quit "对账文本不存在"
	s job=$j
	k ^TMP("TransBalanceInfo",job)
	s Len=0,FalseNum=0,strflag=1
	s rtn=0
    while ('stream.AtEnd)&&(rtn'="end") {
	    s Info=stream.ReadLine()
	    s Info=$zcvt(Info,"I","GB18030")
	    ;b ;Info
	    if (strflag>5) {
    		q:(Info="")
    		;b ;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..TransBalanceInfo(Info,job)
    		;i +rtn'=0 d
    		;.s FalseNum=FalseNum+1
			;.;失败记录
			;.s ^TMPSaveBalance(fileName,FalseNum)=Info
		}
		s strflag=strflag+1
	}
	b ;^TMP("TransBalanceInfo",job)
	s FalseNum=..SaveBalanceInfoNew(job)
	k ^TMP("TransBalanceInfo",job)
    If 'ftp.Logout() Quit
    
	q FalseNum
}

/// wangjian
/// 2015-03-10
/// 把对账文本转换成临时Global(针对支付宝多条记录对应His一个交易号)
ClassMethod TransBalanceInfo(BalanceInfo, job)
{
	
	q:BalanceInfo="" 0
	s rtn=0
	s BanLen=$l(BalanceInfo)
	s EndFlag=$p(BalanceInfo,"#",2)
	q:EndFlag["账务明细列表结束" "end"
	s TradeFlagDesc=$tr($p(BalanceInfo,",",11),$c(9),"")
	q:TradeFlagDesc["提现" 0
	s TradeAmt=$tr($p(BalanceInfo,",",7),$c(9),"")+$tr($p(BalanceInfo,",",8),$c(9),"")
	i (TradeFlagDesc["在线支付")!(TradeAmt>0) s TradeFlag=0
	e  i (TradeFlagDesc["交易退款")!(TradeAmt<0) s TradeFlag=1
	e  s TradeFlag=0
	s Date=$tr($p(BalanceInfo,",",5),$c(9),"")
	s IBTFinDate=$zdh($p(Date," "),3)
	s IBTTradeTime=$tr($p(Date," "),"-","")_$tr($p(Date," ",2),":","")
	s IATHISTradeNo=""
	i TradeFlag=0 s IATHISTradeNo=$tr($p(BalanceInfo,",",3),$c(9),"")
	i TradeFlag=1 s IATHISTradeNo=$tr($p(BalanceInfo,",",13),$c(9),"")
	q:IATHISTradeNo="" 0
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",2)=$tr($p(BalanceInfo,",",1),$c(9),"")
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",4)=$o(^CT("HOSP","0"))
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",10)=IATHISTradeNo
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",11)=TradeFlag   ;收退标志
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",12)=$o(^CT("CTPM",0,"Code","ALIPAY",""))
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",13)=$p($g(^TMP("TransBalanceInfo",job,IATHISTradeNo)),"^",13)+$zabs(TradeAmt)
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",14)=IBTTradeTime
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",15)=$tr($p(BalanceInfo,",",2),$c(9),"")
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",16)=IBTFinDate
	
	q 0
}

ClassMethod SaveBalanceInfoNew(job)
{
	
	s FalseNum=0
	s HISTradeNo=""
	f  s HISTradeNo=$o(^TMP("TransBalanceInfo",job,HISTradeNo)) q:HISTradeNo=""  d
	.s BalanceInfo=$g(^TMP("TransBalanceInfo",job,HISTradeNo))
	.k PLIST
	.s PLIST(2)=$p(BalanceInfo,"^",2)
	.s PLIST(10)=$p(BalanceInfo,"^",10)
	.s PLIST(11)=$p(BalanceInfo,"^",11)
	.s PLIST(12)=$p(BalanceInfo,"^",12)
	.s PLIST(13)=$p(BalanceInfo,"^",13)
	.s PLIST(14)=$p(BalanceInfo,"^",14)
	.s PLIST(15)=$p(BalanceInfo,"^",15)
	.s PLIST(16)=$p(BalanceInfo,"^",16)
    .d ..tb()
	.s myRtn=..DHCINVBankBalanceINSERT()
	.s rtn=$p(myRtn,"^",1)
	.i +rtn=0 d
	..d ..tc()
	.e  d
	..Trollback
	..s FalseNum=FalseNum+1
	q FalseNum
}

}
