Import SQLUser

/// wangjian
/// 2014-07-10
/// 微信业务处理类
Class DHCWeChatPay.ChargeInterface.WeChatPayLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:wangjian
/// CreatDate:2014-07-10
/// Descripiton:获取微信入参信息
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院),PayModeDr:支付方式
/// 		NewPrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HospDR:医院指针
/// 		ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员ID^退费原因)
/// BankTradeType=D NewPrtRowid 不为空  AbortPrtRowid 为空时候为医保分解
/// BankTradeType=D AbortPrtRowid 不为空时候为退费
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).WeChatPay("OP","","12047954","","D","67^582^1^^^8549^")
/// OP!!2244280!!D!166^281^5^
ClassMethod WeChatPay(PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	New (PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	Set rtn=0
	Set Amt=##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetOPInvWeChatPayAmt(NewPrtRowid_"|"_AbortPrtRowID)
	b ;gao
	If (+Amt>0) Set rtn=..WeChatPayNew(PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	/*Set Mark=$p(ExpStr,"^",7)
	if (Mark="") Set Mark="退号"
	Set err=$p(rtn,"^",1)
	If (err=0)&&(+Amt>0) Do
	.If +NewPrtRowid'=0 Set PrtPatientId=$p(^DHCINVPRT(NewPrtRowid),"^",15)
	.If +AbortPrtRowID'=0 Set PrtPatientId=$p(^DHCINVPRT(AbortPrtRowID),"^",15)
	.Set Message=Mark_"成功,退费金额"_Amt_"元"
	.Set Mesrtn=##class(MHC.PublicMessage).SendToWeChat(PrtPatientId,Message,"REFOUNDFEE","","")
	*/
	Quit rtn
}

ClassMethod WeChatPayNew(PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	s ^WANGJIAN("WeChatPay")=PatType_"!"_NewPrtRowid_"!"_AbortPrtRowID_"!"_BankCardNO_"!"_BankTradeType_"!"_ExpStr
	; "OP!!12450416!!D!3^281^2^^^7480^退费"
	; ;w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).WeChatPayNew("OP","",12450416,"","D","3^281^2^^^7480^退费")
	;q 0
	q:"C^D"'[BankTradeType "-1001^"_"^获取入参失败,交易类型不正确."
	i PatType="OP" s PayMInfo=..CheckPayMByPrtRowID(NewPrtRowid,AbortPrtRowID)
    s CardPayFlag=$p(PayMInfo,"^",1)
    s PayModeDr=$p(PayMInfo,"^",2)
	q:+CardPayFlag=0 "-1"	;非微信支付
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
		;s rtn=##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).DeleteIBP(IBPRowID,"")	
	}
	q:+err'=0 "-1001^"_err_"^获取入参失败."
	
	;收费时,TotalAmt是所有发票的总金额;退费时,TotalAmt是新发票和负票的差额;如果是全退,TotalAmt是负票的金额
	i (PatType="OP")&&(+AbortPrtRowID'=0){
		s TotalAmt=..GetOPInvWeChatPayAmt(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
	}
	i (PatType="OP")&&(+AbortPrtRowID=0)&&(+NewPrtRowid'=0){
		s TotalAmt=..GetOPInvWeChatPayAmtForYB(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
	}
	i (BankTradeType="D"){
		s Mark=$p(ExpStr,"^",7)
		i (Mark="") Set Mark="退号"
		;OldWeChatPayNo_"^"_OldHisTradeNo_"^"_Patientid_"^"_AdmInfo_"^"_PayMode
		s AdmInfo=$p(RefTradeInfo,"^",4)
		s OldHisTradeNo=$p(RefTradeInfo,"^",2)
		s OldWeChatPayNo=$p(RefTradeInfo,"^",1)
		s Patientid=$p(RefTradeInfo,"^",3)
		i Patientid="" s Patientid=$p(^PAADM(AdmInfo),"^",1)
		s PayMode=$p(RefTradeInfo,"^",5)
		s OldTradeAmt=$p(RefTradeInfo,"^",6)
		B ;;;
		s ^DHCBillWeChatPay("MZJF","HisTradeNOConPrt",HISTradeNo)=NewPrtRowid_"^"_AbortPrtRowID ;异步更新交易子表用
		;s rtnstr="<orderpayreturn><error></error><issuccess>T</issuccess><tradeno>2014071115539223</tradeno><money>0.02</money><memo>é????????·</memo><batchno>KMYK1407111841463434</batchno><patientid>416826</patientid></orderpayreturn>"
		;s rtnstr=##Class(MHC.PublicPay).ReturnPay(OldWeChatPayNo,HISTradeNo,Patientid,TotalAmt,Mark)
		s rtnstr=##Class(MHC.PublicPay).SendRefundWxPay(OldWeChatPayNo,OldTradeAmt,TotalAmt,Patientid,HISTradeNo)
	    ;s rtnstr=^DHCBillWeChatPay("MZJF","RefoudInfo","01637651354460026")
		;记录同步消息不以同步消息为准
		b ;;222
		
		s ^DHCBillWeChatPay("MZJF","RefoudInfo",HISTradeNo)=rtnstr ;记录请求退费同步消息
		s WeChatObj=##class(DHCWeChatPay.DHCEntity.PCA.orderpayreturn).%New()
	    d WeChatObj.XMLNodeDeserialize(.WeChatObj,"orderpayreturn",rtnstr)
	    s WeChaterror=WeChatObj.error
	    s WeChatssuccess=WeChatObj.issuccess ;T 成功 F 失败
	    s WeChattradeno=WeChatObj.tradeno ;交易流水号
	    s WeChatmoney=WeChatObj.money
	    s WeChatmemo=WeChatObj.memo
	    s WeChatbatchno=WeChatObj.tradeno ;订单号
	    s WeChatpatientid=WeChatObj.patientid
		s PrtStr=NewPrtRowid_"^"_AbortPrtRowID
		s rtn=0
		b ;WeChatssuccess
		i WeChatssuccess="T" d
		.;保存微信返回信息
		.s ReTradeInfo=HISTradeNo_"^"_WeChatmoney_"^"_WeChattradeno_"^"_"" 
		.;his订单号^交易金额^微信交易流水号^微信账号
		.s rtn=##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayExp).UpdateWeChatPayInfo(AdmInfo,ReTradeInfo,ExtUserID,BankTradeType,PrtStr,PayMode,"结算成功")
		.s rtn=0
		e  d
		.;s rtn=-1008_WeChaterror_"调用微信退费请求失败"
	}
	s err=$p(rtn,"^",1)
	q err
}

/// Creator:wangjian
/// CreatDate:2014-07-10
/// Description:验证是否需要调用微信接口.
/// Input:
/// Output:
/// Return:0^:不调用,1^支付方式RowID:调用
/// Other:
/// Debug:w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).CheckPayMByPrtRowID("2244232","")
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
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPayModeHardComm("OP",32)
ClassMethod GetPayModeHardComm(invType, PayMode)
{
	n (invType,PayMode)
	i PayMode["WECHATPAY" s PayMode=$o(^CT("CTPM",0,"Code",PayMode,""))
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
/// Description:验证微信金额的退费模式()
/// Input:AbortPrtRowID:退费发票的负记录Rowid,PrtRowID:新发票RowID
/// Return:0:全退,1:部分退,2:作废重打
/// Other:
/// Debug:w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).CheckRefundMode("","")
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
			s TotalAmt=..GetOPInvWeChatPayAmt(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
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
			s TotalAmt=..GetOPInvWeChatPayAmtForYB(NewPrtRowid_"|"_AbortPrtRowID)	;要考虑扩展医保表
		} ;根据原始发票Rowid获取原交易信息
		s OrgTradeInfo=..GetOrgTradeData(PatType,IBPRowID,IBSSub,"")
		s AdmInfo=$p(OrgTradeInfo,"^",4)
		s CardNO=""
		s PatientId=$p(OrgTradeInfo,"^",3)
	 }
	
	s myExpstr=ExtUserID_"^3^"_PatType_"^"_TotalAmt_"^"_IBPRowID
	s rtn=##class(DHCWeChatPay.ChargeInterface.DHCOPBillWeChatPayExp).SetHisTradeNoInfo(AdmInfo,PatientId,CardNO,BankTradeType,HospDR,myExpstr)
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
/// Debug:w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).DeleteIBP(410,"")
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
/// Debug:w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetOrgPrtRowID("19028776","19028777","")
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
/// Debug:w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetOrgTradeData("OP","850","1","")
ClassMethod GetOrgTradeData(PatType, IBPRowID, IBSSub, ExpStr)
{
	n (PatType,IBPRowID,IBSSub,ExpStr)
	;
	s IBSRowd=IBPRowID_"||"_IBSSub
	s AdmInfo=$p(^DHCINVALITP(IBPRowID),"^",45)
	s OldWeChatPayNo=$p(^DHCINVALITP(IBPRowID),"^",7)
	s OldHisTradeNo=$p(^DHCINVALITP(IBPRowID),"^",32)
	s Patientid=$p(^DHCINVALITP(IBPRowID),"^",48)
	s PayMode=$p(^DHCINVALITP(IBPRowID),"^",46)
	s OldTradeAmt=$p(^DHCINVALITP(IBPRowID),"^",23)
	i (PatType="OP"){
		s OldPaySeqNo=$p(^DHCINVALITP(IBPRowID,"C",IBSSub),"^",5)
	}elseif(PatType="IP"){
		s OldPaySeqNo=""
	}else{
		s OldPaySeqNo=OldHisTradeID
	}
	;
	s rtn=OldWeChatPayNo_"^"_OldHisTradeNo_"^"_Patientid_"^"_AdmInfo_"^"_PayMode_"^"_OldTradeAmt
	b ;rtn 111
	q rtn
}

/// wangjian
/// 2014-07-11
/// 根据门诊发票表Rowid获取微信支付额
/// 要考虑医保扩展表
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetOPInvWeChatPayAmt("2244307|2244311")
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
	...i payMCode="WECHATPAY" b ;;
	...s payMAmt=+$p(s,"^",3)
	...s handDr=..GetPayModeHardComm("OP",payMDr)
	...i handDr'="" d
	....s amt=amt+payMAmt
	
	s amt=$fn($zabs(amt),"",2)
	
	q amt
}

/// wangjian
/// 2014-07-11
/// 根据门诊发票表Rowid获取微信支付额
/// 医保返钱时候取发票支付表
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetOPInvWeChatPayAmtForYB("2244307|2244311")
ClassMethod GetOPInvWeChatPayAmtForYB(rowidStr)
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
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).SendInsuMessageToWeChat(2244455)
ClassMethod SendInsuMessageToWeChat(myPRTRowIDStr, ExpStr)
{
	New (myPRTRowIDStr,ExpStr)
	Set rtn=0
	;推送消息
	For i=1:1:$l(myPRTRowIDStr,"^")   Do
	.Set myPRTRowID=$p(myPRTRowIDStr,"^",i)
	.Quit:+myPRTRowID=0
	.Set PRTAmt=$p(^DHCINVPRT(myPRTRowID),"^",1)
	.Set PRTPatient=$p(^DHCINVPRT(myPRTRowID),"^",15)
	.Set SelfAmt=##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetOPInvWeChatPayAmt(myPRTRowID)
	.Set RefAmt=PRTAmt-SelfAmt
	.Set Message="医保结算成功^您的就诊费用总金额"_$fn(PRTAmt,"",2)_"元,个人支付"_$fn(SelfAmt,"",2)_"元,医保支付"_$fn(RefAmt,"",2)_"元,其中"_$fn(RefAmt,"",2)_"元将于3个工作日内退还至您的支付账户."	
	.Set rtn=##class(MHC.PublicMessage).SendToWeChat(PRTPatient,Message,"INSU","","")
	If rtn=200 Set rtn=0
	Quit 0
}

ClassMethod test()
{
    s rtnstr="<orderpayreturn><error></error><is_success>T</is_success><trade_no>交易号</trade_no><money>0.01</money><memo>东华退款测试</memo><batch_no>新订单</batch_no><patientid>21341241</patientid></orderpayreturn>"
	s WeChatObj=##class(DHCWeChatPay.DHCEntity.PCA.orderpayreturn).%New()
    d WeChatObj.XMLNodeDeserialize(.WeChatObj,"orderpayreturn",rtnstr)
    s WeChaterror=WeChatObj.error
    s WeChatssuccess=WeChatObj.issuccess ;T 成功 F 失败
    s WeChattradeno=WeChatObj.tradeno ;交易流水号
    s WeChatmoney=WeChatObj.money
    s WeChatmemo=WeChatObj.memo
    s WeChatbatchno=WeChatObj.batchno ;订单号
    s WeChatpatientid=WeChatObj.patientid
	b ;;;
}

/// wangjian
/// 2014-07-16
/// 根据门诊发票表Rowid推送结算的医嘱导诊
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).SendOrderMessageToWeChat(2244739)
ClassMethod SendOrderMessageToWeChat(InvStr)
{
    New (InvStr)
	New SendMessToWeChat
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
	...Set myPresNo=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",14)
	...Set RecLocDesc=$p($g(^CTLOC(OrdRecLoc)),"^",2)
	...If RecLocDesc["-" Set RecLocDesc=$p(RecLocDesc,"-",2)
	...Set LocAdress=$g(^CTLOC(OrdRecLoc,"ADDR",1))
	...If RecLocDesc["药房" Set PHWindow=##class(web.DHCMZYFXTYW02).GetPrtPrescWin(InvDr,myPresNo),RecLocDesc=RecLocDesc_"("_PHWindow_")"
	...Set SendMessToWeChat("MZJF","OrderLoc",$j,OrdRecLoc)=LocAdress_"--"_RecLocDesc
	...Set PrtPatientID=$p(^DHCINVPRT(InvDr),"^",15)
	Set PrtPatient=PrtPatientID
	;
	Set Str=""
	Set myOrdRecLoc=""
	For  Set myOrdRecLoc=$o(SendMessToWeChat("MZJF","OrderLoc",$j,myOrdRecLoc)) Q:myOrdRecLoc=""  Do
	.If Str="" Set Str=$g(SendMessToWeChat("MZJF","OrderLoc",$j,myOrdRecLoc))
	.Else  Set Str=Str_"^"_$g(SendMessToWeChat("MZJF","OrderLoc",$j,myOrdRecLoc))
	b ;Str
	If $l(Str,",")=1 Set Message="请您到:"_Str_"^检查、检验、治疗或取药.^^注意:如需打印发票或退费请到一楼收费窗口办理。"
	Else  Set Message="请您分别到"_Str_"就诊或取药"
	Set rtn=##class(MHC.PublicMessage).SendToWechat(PrtPatient,Message,"PAYEDORDER")
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
/// 2014-12-24
/// 微信绑卡给没有账户的卡号建账户
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).BuildAccount()
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
 s User=$o(^SSU("SSUSR",0,"SSUSR_Initials","wechatpay001",""))
 s CardType=$p(^DHCCARD("CF",CardRowid),"^",16)
 s AccInfo="^"_PapmiDr_"^"_RegNo_"^"_CardNo_"^"_User_"^^0^^"_CardType_"^"_CardNo_"^"_CardRowid
 b ;
 s rtn=##class(web.UDHCAccManageCLS).NewAccount("","",AccInfo,"")
 b ;rtn
 q rtn
}

/// ///在指定FTP服务器上获取对账数据///////////////////////////////
/// wangjian
/// 2015-08-20
/// 导入POS对账文件，使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetRecTXTFromFTPNew("20150818")
/// ftp://10.160.17.11  
ClassMethod GetRecTXTFromFTPNew(inputName)
{
	n (inputName)
	s ftpIP="192.168.33.2"
	s userName="r0bert"
	s password="Admin9394"
	s port=21
	;门诊对账数据
	s path="/wechat/"
    i inputName="" d
    .s fileName=$zd(+$h-1,8)
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
	    ;s Info=$zcvt(Info,"I","GB18030")
	    s Info=$zcvt(Info,"I","UTF8")
	    ;b ;Info
	    if (strflag>1) {
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
	;b ;^TMP("TransBalanceInfo",job)
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
	s EndFlag=$p(BalanceInfo,",",1)
	q:EndFlag["总交易单数" "end"
	s BalanceInfo=$tr(BalanceInfo,"`","")
	s TradeFlagDesc=$p(BalanceInfo,",",10)
	;q:TradeFlagDesc["提现" 0
	s TradeAmt=$p(BalanceInfo,",",13)+$p(BalanceInfo,",",17)
	i (TradeFlagDesc["REFUND") s TradeFlag=1
	;e  i (TradeFlagDesc["交易退款") s TradeFlag=1
	e  s TradeFlag=0
	s Date=$p(BalanceInfo,",",1)
	s IBTFinDate=$zdh($p(Date," "),3)
	s IBTTradeTime=$tr($p(Date," "),"-","")_$tr($p(Date," ",2),":","")
	s IATHISTradeNo=""
	i TradeFlag=0 s IATHISTradeNo=$p(BalanceInfo,",",7),IATTradeNo=$p(BalanceInfo,",",6)
	i TradeFlag=1 s IATHISTradeNo=$p(BalanceInfo,",",16),IATTradeNo=$p(BalanceInfo,",",15)
	q:IATHISTradeNo="" 0
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",2)=$p(BalanceInfo,",",6)
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",4)=$o(^CT("HOSP","0"))
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",10)=IATHISTradeNo
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",11)=TradeFlag   ;收退标志
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",12)=$o(^CT("CTPM",0,"Code","WECHATPAY",""))
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",13)=$p($g(^TMP("TransBalanceInfo",job,IATHISTradeNo)),"^",13)+$zabs(TradeAmt)
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",14)=IBTTradeTime
	s $p(^TMP("TransBalanceInfo",job,IATHISTradeNo),"^",15)=IATTradeNo
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

/// wangjian
/// 2015-09-28
/// 异常处理
/// -1 当日撤销失败，-2 当日退货失败，-3 隔日退货失败
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPRTForYCCL(19027892)  --000000235
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPRTForYCCL(15126038)  --000000236
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).GetPRTForYCCL(20392489)
ClassMethod GetPRTForYCCL(PrtRowid)
{
	q:PrtRowid="" "0^无发票号!"_$c(2)
	s PrtFlag=0,RetStr=""
	s StrikeRowid=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,""))
	s NormalRowid=$o(^DHCINVPRT(0,"OldINV",PrtRowid,""))
	s DayFlag=##class(web.udhcOPRefund).JudgePrtDate(PrtRowid)
	i StrikeRowid'="" d
	.i DayFlag=0 d
	..s TBPRowid=$o(^DHCINVALITPi(0,"S","IPDR",StrikeRowid,""))
	..i TBPRowid="" d
	...i NormalRowid="" d
	....s PrtFlag=-1
	....s RetStr=PrtFlag_"^"_StrikeRowid_$c(2)
	...e  d
	....s PrtFlag=-2
	....s RetStr=PrtFlag_"^"_NormalRowid_"^"_StrikeRowid_$c(2)
	.e  d
	..s TBPRowid=$o(^DHCINVALITPi(0,"S","IPDR",StrikeRowid,""))
	..i TBPRowid="" d
	...s PrtFlag=-3
	...s RetStr=PrtFlag_"^"_NormalRowid_"^"_StrikeRowid_$c(2)
	e  d
	.s RetStr=PrtFlag_"^"_"此票未做退费!"_$c(2)
	
	i RetStr="" s RetStr=PrtFlag_"^"_"此票已经成功退费,无需补交易!"_$c(2)
	
	q RetStr
}

/// wangjian
/// 20151010
/// 下载微信对账文件
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).DowloadWeChatTxt("")
ClassMethod DowloadWeChatTxt(inputName)
{
	n (inputName)
    i inputName="" d
    .s fileName=$zd(+$h-1,8)
    e   s fileName=inputName
    d ##Class(MHC.PublicMessage).GetDowloadbill(fileName,"ALL")

	q 0
}

/// wangjian
/// 2014-07-28
/// 按日期批量生产对账文件
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).BuildFTPFileByDate("2015-08-27","2015-10-09")
ClassMethod BuildFTPFileByDate(StDate, EndDate)
{
	i StDate["-" s StDate=$zdh(StDate,3)
	i EndDate["-" s EndDate=$zdh(EndDate,3)
	f Date=StDate:1:EndDate d
	.s myfileName=$zd(Date,8) 
	.;s rtn=..DowloadWeChatTxt(myfileName)
	.s rtn=..GetRecTXTFromFTPNew(myfileName)
	
	q 0
}

/// wangjian
/// 2015-10-16
/// 根据回款记录补存交易信息
/// w ##class(DHCWeChatPay.ChargeInterface.WeChatPayLogic).UPTradeInfoByHisTradeNo("")
ClassMethod UPTradeInfoByHisTradeNo(HisTradeNo)
{
	New (HisTradeNo)
	Quit:'$d(^User.DHCINVAliBalanceI("TRADENO",HisTradeNo)) "NoBalance"
	Set IBPRowid=$o(^DHCINVALITPi(0,"PTN",HisTradeNo,""))
 	Quit:IBPRowid="" "NoHISTradeNo"
 	Set BankTradeType=$p(^DHCINVALITP(IBPRowid),"^",24)			; 交易类型
	Quit:BankTradeType'="D" "NotRefound"
	Set OldIBPRowid=$p(^DHCINVALITP(IBPRowid),"^",33)
	Set IBSSub="",PrtRowid=""
	For  Set IBSSub=$o(^DHCINVALITP(OldIBPRowid,"C",IBSSub)) Quit:(IBSSub="")!(PrtRowid'="")  Do
	.Quit:IBSSub=0
	.Set PrtRowid=$p(^DHCINVALITP(OldIBPRowid,"C",IBSSub),"^",1)
	b ;
	Set AbortPrtRowID=$o(^DHCINVPRT(0,"InitInvDR",PrtRowid,""))
	Quit:AbortPrtRowID="" "NotAbortInv"
	b ;AbortPrtRowID,IBPRowid
	Set RetCode=0
	d ..tb()
	Set Rc=$p(^DHCINVALITP(OldIBPRowid),"^",1)
	set RcDetail=$p(^DHCINVALITP(OldIBPRowid),"^",2)
	;set WeChatChargeAmt=$p(^DHCINVALITP(OldIBPRowid),"^",4)
	set WeChatChargeAmt=$p(^DHCINVALITP(IBPRowid),"^",23)
	set WeChatTradeNo=$p(^DHCINVALITP(OldIBPRowid),"^",7)
	set PaymDR=$p(^DHCINVALITP(OldIBPRowid),"^",46)
	set AdmId=$p(^DHCINVALITP(OldIBPRowid),"^",45)
	set AbortPrtFlag=$p(^DHCINVPRT(AbortPrtRowID),"^",8)
	&sql(update DHC_INVAliTradePay set IAP_Rc=:Rc,IAP_Rc_detail=:RcDetail,IAP_Tr_amt=:WeChatChargeAmt
               ,IAP_RRN=:WeChatTradeNo,IAP_Paymode=:PaymDR, IAP_Adm_DR=:AdmId
                where IAP_Rowid=:IBPRowid)
               
 	Set RetCode=RetCode+SQLCODE
 	If +RetCode=0  d
 	.&sql(insert into DHC_INVAliConSub (IAS_IAP_ParRef,IAS_INVPRT_DR,IAS_Status) values (:IBPRowid,:AbortPrtRowID,:AbortPrtFlag))
	.Set RetCode=RetCode+SQLCODE
	i +RetCode=0 d
	.d ..tc()
	e  d
	.Trollback
	
	q RetCode
}

}
