Import SQLUser

/// Creator:Lid
/// CreatDate:2011-10-17
/// Description:银医卡业务处理类
Class web.DHCBillBankLogicBJXH Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Lid
/// CreatDate:2011-10-27
/// Description:银医卡退费业务
/// Return:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).BankRefund("OP","3881","180490","","","^^3")
ClassMethod BankRefund(PatType, Guser, AbortPrtRowID, NewPrtRowID, BankCardNO, ExpStr)
{
	n (PatType, Guser,AbortPrtRowID,NewPrtRowID, BankCardNO, ExpStr)
	s rtn=0
	;判断发票是否为银医卡支付
	s PayMInfo=..CheckPayMByPrtRowID(NewPrtRowID,AbortPrtRowID)
    s CardPayFlag=$p(PayMInfo,"^",1)
    s PayModeDR=$p(PayMInfo,"^",2)
	q:+CardPayFlag=0 "-1"	;非银医卡支付
	;
	;获取发票Rwoid获取原交易的银医卡卡号
	s InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;原发票Rowid
	s OldBankTradePayDR=..GetOriginalTradeRowID(InitInvDR)
	s BankCardNO=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
	;
	;获取银行交易类型
	s InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;原发票Rowid
	s BankTradeType=..CheckRefundTradeType(InitInvDR)
	;
	b ;验证退费模式
	s RefundMode=..CheckRefundMode(AbortPrtRowID,NewPrtRowID)
	i RefundMode=0 d
	.b ;作废
	.s rtn=..BankRefundAll(PatType, Guser, NewPrtRowID,AbortPrtRowID, PayModeDR, BankCardNO, BankTradeType, ExpStr)
	;
	i RefundMode=1 d
	.i BankTradeType="D" d
	..b ;部分退费,当日退费:先撤销原预授权,在重新做预授权
	..s rtn=..BankRefundAll(PatType, Guser, "",AbortPrtRowID, PayModeDR, BankCardNO, BankTradeType, ExpStr)
	..s err=..BankPay(PatType, Guser, NewPrtRowID,"", BankCardNO,"C", ExpStr)
	..s rtn=$p(err,"^",1)
	.i BankTradeType="T" d
	..b ;部分退费,隔日退货:只退差额
	..s rtn=..BankRefundAll(PatType, Guser, NewPrtRowID,AbortPrtRowID, PayModeDR, BankCardNO, BankTradeType, ExpStr)
	;
	i RefundMode=2 d
	.b ;作废重打(不需要调用银行接口,只需把原交易记录的指针更新到新发票记录)
	.s rtn=..BankRefundReplay(NewPrtRowID,AbortPrtRowID,BankTradeType,ExpStr)
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-10-29
/// Description:银医卡作废(全退)
ClassMethod BankRefundAll(PatType, Guser, NewPrtRowID, AbortPrtRowID, PayModeDR, BankCardNO, BankTradeType, ExpStr)
{
	;HIS端插入银行交易信息并获取银医卡交易的入参
	s Input=""
	s returnValue=..GetTradeRefundInput(PatType, Guser, NewPrtRowID,AbortPrtRowID,PayModeDR, BankCardNO, BankTradeType, ExpStr,.Input)
	s rtn=$p(returnValue,"^",1)
	s IBPRowID=$p(returnValue,"^",2)
	s InputXML=""
	d Input.XMLExportToString(.InputXML,"Request")
	s HISTradeNO=Input.TransactionId
	q:+rtn'=0 rtn
	;
	b ;调用银行接口
	s HandComFlag=..GetPayModeHardComm("OP",PayModeDR)
	i HandComFlag=1 d
	.;调用平台组接口
	.s Output=""
	.;
	.s TestTradeID=Input.TransactionId
	.s PatientID=Input.PatientID
	.s AccDate=$zd(+$h,3)
	.s AcctTime=$zt($p($h,",",2))
	.i BankTradeType="T" d ;北京协和医院--银医卡退费不调用银行接口，走批量退费,HIS默认是退费成功.
	..s Output="<Response><AcctDate>"_AccDate_"</AcctDate><AcctTime>"_AcctTime_"</AcctTime><TransactionId>"_TestTradeID_"</TransactionId><PatientID>"_PatientID_"</PatientID ><ResultCode>000</ResultCode><ErrorMsg>成功!</ErrorMsg></Response>"
	.e  d
	..s DHCENSSOAP=##class(DHCENS.SOAP.CardpaymentSoap).%New()
	..s Output=DHCENSSOAP.Cardpayment(InputXML)
	..d DHCENSSOAP.%Close()
	b ;更新银医卡交易信息
	s returnValue=..UpdateTradeInfo(PatType,Guser,BankTradeType,HISTradeNO,NewPrtRowID,AbortPrtRowID,Output,ExpStr)
	s rtn=$p(returnValue,"^",1)
	s IBPRowID=$p(returnValue,"^",2)
	s BankResultCode=$p(returnValue,"^",3)
	b ;End
	;
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-10-29
/// Description:银医卡部分退费
ClassMethod BankRefundPart(PatType, Guser, PrtRowID, AbortPrtRowID, PayModeDR, BankCardNO, BankTradeType, ExpStr)
{
}

/// Creator:Lid
/// CreatDate:2011-11-18
/// Description:银医卡作废重打
/// Debug:w ##class(web.DHCBillBankLogic).BankRefundReplay(19028414,19028413,"")
ClassMethod BankRefundReplay(NewPrtRowID, AbortRowID, BankTradeType, ExpStr)
{
	n (NewPrtRowID,AbortRowID,BankTradeType, ExpStr)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s err=0
	b ;获取原发票记录上的银行交易记录指针
	s InitInvRowID=$p(^DHCINVPRT(AbortRowID),"^",13)
	s PaidTransactionId=..GetOriginalTradeRowID(InitInvRowID)
    s OldBankTradePayDR=$p(^DHCINVBTP(PaidTransactionId),"^",33)	;IBP_HISOldTradeID 为空说明是第一次退费,不为空,则把它挪到新交易记录上,以方便再次退费
	i OldBankTradePayDR="" d
	.s OldBankTradePayDR=PaidTransactionId ;IBP_HISTradeID原交易流水
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

/*
/// Creator:Lid
/// CreatDate:2011-10-29
/// Description:银医卡作废重打
/// Debug:w ##class(web.DHCBillBankLogicBJXH).BankRefundReplay("180673","180672","","")
ClassMethod BankRefundReplayOLD(NewPrtRowID, AbortRowID, BankTradeType, ExpStr)
{
	n (NewPrtRowID,AbortRowID,BankTradeType, ExpStr)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	;
	s TradeIdDR="",PaidTradeIdDR="",RefundDR=""
	b ;获取原发票记录上的银行交易记录指针
	s InitInvRowID=$p(^DHCINVPRT(AbortRowID),"^",13)
	s IPMSub="0" 
	f  s IPMSub=$o(^DHCINVPRT(InitInvRowID,"P",IPMSub)) q:IPMSub=""  d
	.s s=^DHCINVPRT(InitInvRowID,"P",IPMSub)
	.s IPMPayMDR=$p(s,"^",1)
	.s HandDr=..GetPayModeHardComm("OP",IPMPayMDR)
	.q:+HandDr=0
	.s TradeIdDR=$p(s,"^",16)
	.s PaidTradeIdDR=$p(s,"^",17)
	.s RefundDR=$p(s,"^",18)
	;更新发票的银医交易记录指针
	s IPMSub="0" 
	f  s IPMSub=$o(^DHCINVPRT(NewPrtRowID,"P",IPMSub)) q:IPMSub=""  d
	.s s=^DHCINVPRT(NewPrtRowID,"P",IPMSub)
	.s IPMPayMDR=$p(s,"^",1)
	.s HandDr=..GetPayModeHardComm("OP",IPMPayMDR)
	.q:HandDr=0
	.s IPMRowID=NewPrtRowID_"||"_IPMSub
	.&sql(UPDATE DHC_InvPayMode SET IPM_TradeId_DR=:TradeIdDR,IPM_PaidTradeId_DR=:PaidTradeIdDR,IPM_Refund_DR=:RefundDR  WHERE IPM_ROWID=:IPMRowID)
	.s err=SQLCODE
	i PaidTradeIdDR'="" s TradeIdDR=PaidTradeIdDR	;如果预授权已完成,则只需把完成交易的指针挪到新发票记录,原预授权的交易指针不用挪下来.
	;
	b ;在交易明细表子表中插入新发票记录,同时把原发票记录更新成作废状态
	i ((err=0)&(TradeIdDR'="")) d
	.s IBSSub="0"
	.f  s IBSSub=$o(^DHCINVBTP(TradeIdDR,"C",IBSSub)) q:IBSSub=""  d
	..s IBSRowID=TradeIdDR_"||"_IBSSub
	..&sql(UPDATE DHC_INVBankConSub SET IBS_Status='A' WHERE IBS_RowID=:IBSRowID)
	..s err=SQLCODE
	.b ;插入新发票记录
	.k PLIST
	.s PLIST(0)=+TradeIdDR
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
*/
/// Creator:Lid
/// CreatDate:2011-10-25
/// Description:医院卡支付
/// Input:ExpStr=科室^安全组^医院^^^;
/// Output:
/// Return:-1:非银医卡支付
/// 
/// 														"OP$3881$180615$$9558820200899998175$P$823^93^3^^^"
/// Debug:w ##class(web.DHCBillBankLogicBJXH).BankPay("OP","3881","180630","","9558820200899998175","P","823^93^3^^^")
ClassMethod BankPay(PatType, Guser, PrtRowID, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr As %String = "")
{
	n (PatType,Guser,PrtRowID,BankCardNO,AbortPrtRowID,BankTradeType,ExpStr)
	s rtn=0,Input=""
	;
	s PayMInfo=##class(web.DHCBillBankLogicBJXH).CheckPayMByPrtRowID(PrtRowID,"")
    s CardPayFlag=$p(PayMInfo,"^",1)
    s PayModeDR=$p(PayMInfo,"^",2)
	q:+CardPayFlag=0 "-1"	;非银医卡支付
	;
	;HIS端插入银行交易信息并获取银医卡交易的入参
	s returnValue=..GetTradePayInput(PatType,Guser,PayModeDR, PrtRowID,AbortPrtRowID,BankCardNO, BankTradeType, ExpStr,.Input)
	s rtn=$p(returnValue,"^",1)
	q:+rtn'=0 rtn
	s IBPRowID=$p(returnValue,"^",2)
	s InputXML=""
	d Input.XMLExportToString(.InputXML,"Request")
	s HISTradeNO=Input.TransactionId
	i +rtn'=0 d
	.s err=##class(web.DHCBillBankLogicBJXH).DeleteIBP(IBPRowID,"")
	q:+rtn'=0 rtn
	;
	b ;调用银行接口
	s HandComFlag=..GetPayModeHardComm("OP",PayModeDR)
	i HandComFlag=1 d
	.;调用平台组接口
	.s Output=""
	.;Test
	.s AccDate=$zd(+$h,3)
	.;s Output="<Response><AcctDate>"_AccDate_"</AcctDate><AcctTime></AcctTime><TransactionId>"_TestTradeID_"</TransactionId><PatientID>395</PatientID ><ResultCode>000</ResultCode><ErrorMsg>成功!</ErrorMsg></Response>"
	.;Test
	.s DHCENSSOAP=##class(DHCENS.SOAP.CardpaymentSoap).%New()
	.s Output=DHCENSSOAP.Cardpayment(InputXML)
	.d DHCENSSOAP.%Close()
	q:Output="" "-2^^^"	;银行返回值为空
	b ;更新银医卡交易信息
	s returnValue=..UpdateTradeInfo(PatType,Guser,BankTradeType,HISTradeNO,PrtRowID,AbortPrtRowID,Output,ExpStr)
	s rtn=$p(returnValue,"^",1)
	s IBPRowID=$p(returnValue,"^",2)
	s BankResultCode=$p(returnValue,"^",3)
	b ;End
	q rtn_"^"_IBPRowID_"^"_BankResultCode
}

/// Creator:Lid
/// CreatDate:2011-10-21
/// Descripiton:生成交易流水号
/// Input:BankCardNO:银行卡号,BankTradeType:交易类型,HospDR:医院ID,ExpStr:扩展信息
/// Output:	
/// Return:	err_"^"_IBPRowID_"^"_TradeID(成功标志^银行交易信息表Rowid^HIS交易流水号)
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).SetTradeID("1000002","C","2","^^^^^")
ClassMethod SetTradeID(BankCardNO As %String, BankTradeType As %String, HospDR As %String, ExpStr As %String) As %String
{
	n (BankCardNO, BankTradeType,HospDR,ExpStr)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNO)
	s BankCode=$p(CardInfo,"^",8)
	s TradeID=""
	;
	;Insert DHC_INVBankTradePay
	k PLIST
	s PLIST(4)=BankCardNO		;IBP_Pan	卡号
	s TradeDate=+$h
	s TradeTime=$p($h,",",2)
	s PLIST(22)=TradeDate		;IBP_TradeDate HIS交易日期
	s PLIST(23)=TradeTime		;IBP_TradeTime	HIS交易时间
	s PLIST(27)=BankTradeType	;IBP_BankTradeType	银行交易类型
	s PLIST(28)=BankCode		;IBP_CardType	卡类型
	s PLIST(29)=HospDR			;IBP_Hospital_Dr 医院指针
	s myRtn=##class(web.DHCOPBillINVBankPay).INSERT()
	s err=$p(myRtn,"^",1)
	s IBPRowID=$p(myRtn,"^",2)
	q:+err'=0 err_"^^"
	;
	s TradeID=..SetTransactionId(IBPRowID)	;生成HIS端交易号
	;更新银行交易信息表
	s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	i +err'=0 TROLLBACK
	q:+err'=0 err_"^^"
	s PLIST(33)=TradeID	;IBPHISTradeID	HIS交易流水号
	s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)
	i +err'=0 TROLLBACK
	q:+err'=0 err_"^^"
	;
	d ..tc()
	;
	s rtn=err_"^"_IBPRowID_"^"_TradeID
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-10-19
/// Descripiton:获取银医卡支付入参信息
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院),Guser:收费员ID,PayModeDr:支付方式
/// 		PrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HospDR:医院指针
/// 			ExpStr:扩展串
/// Output:	InputXML:银行交易入参信息
/// Return:	0:成功,非0:不成功
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).GetTradePayInput("OP","3883","14","180583","","9558820200899998175","S","^^3^^","")
ClassMethod GetTradePayInput(PatType As %String, Guser As %String, PayModeDr As %String, PrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String, Input As web.DHCEntity.PCA.BankTradeInput)
{
	n (PatType, Guser, PayModeDr, PrtRowid,AbortPrtRowID, BankCardNO, BankTradeType, ExpStr,Input)
	;s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s HospDR=$p(ExpStr,"^",3)
	s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNO)
	s TradeCode=..GetTradeCodeByBankTradeType(BankTradeType)
	s PapmiDR=$p(CardInfo,"^",2)
	s PatientID=$p(^PAPER(PapmiDR,"PAT",1),"^",2)
	s BankCode=$p(CardInfo,"^",8)
	s TelNo=$p(^PAPER(PapmiDR,"PAT",3),"^",6)		;PAPMI_DVAnumber 电话
	s TerminalID=Guser
	s HospCode=$p($get(^CT("HOSP",HospDR)),"^",1)
	if (HospCode="") set HospCode=HospDR
	s HospitalID=HospCode
	s BankCardNo=BankCardNO
	s Charge=..GetOPInvBankCardAmt(PrtRowid)
	s TotalCharge=""	;预授权确认金额
	s TradeChannel="02"	;交易渠道
	s err=0,IBPRowID=""
	;
	if +err=0 {
		;生成HIS端交易号
		s TradeInfo=..SetTradeID(BankCardNO,BankTradeType,HospDR,ExpStr)	
		s err=$p(TradeInfo,"^",1)
		s IBPRowID=$p(TradeInfo,"^",2)
		s TransactionId=$p(TradeInfo,"^",3)
	
	}
	if +err=0 {
		;生成银行入参信息
		s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
		s InputObj.TradeCode=TradeCode
	    s InputObj.BankCode=BankCode
	    s InputObj.TerminalID=TerminalID
	    s InputObj.HospitalID=HospitalID
	    s InputObj.BankCardNo=BankCardNo
	    s InputObj.TransactionId=TransactionId
	    s InputObj.Charge=Charge
	    s InputObj.PatientID=PatientID
		s InputObj.TelNo=TelNo
	    s InputObj.PaidTransactionId=""
	    s InputObj.TranWay=TradeChannel
		s CTxnDtTm=$e($zd(+$h,8),3,8)_$tr($zt($p($h,",",2),1),":","")
	    s InputObj.CTxnDtTm=CTxnDtTm
	    s Input=InputObj
	    s InputXML=""
	    d InputObj.XMLExportToString(.InputXML,"Request")
	}
    ;
    i +err'=0 d
    .TROLLBACK
    e  d
    .d ..tc()
    ;
	q err_"^"_$g(IBPRowID)
}

/// Creator:Lid
/// CreatDate:2011-11-04
/// Description:获取发票RowID对应的银行交易信息
/// Input:
/// Output:
/// Return:
/// Other:
/// Debug:
ClassMethod GetBankCardNOByPrtRowID(PrtRowID As %String)
{
	n (PrtRowID)
	s IPMSub=""
	s IPMSub=$o(^DHCINVPRTi(0,"PMDR",InitPrtDR,PayModeDr,"P","0"))
	s IPMRowID=InitPrtDR_"||"_IPMSub
	s TradePayDR=$p(^DHCINVPRT(InitPrtDR,"P",IPMSub),"^",16)	;IPM_TradeId_DR 原交易记录
	s PaidTradeIdDR=$p(^DHCINVPRT(InitPrtDR,"P",IPMSub),"^",17)
	s RefundDR=$p(^DHCINVPRT(InitPrtDR,"P",IPMSub),"^",18)
	i BankTradeType="V" s OldBankTradePayDR=TradePayDR		;撤销预授权,取原预授权记录的交易号
	i BankTradeType="T" s OldBankTradePayDR=PaidTradeIdDR	;退货,取完成预授权记录的交易号
	s PaidTransactionId=$p(^DHCINVBTP(OldBankTradePayDR),"^",32) ;IBP_HISTradeID原交易流水号
	s BankCardNO=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
}

/// Creator:Lid
/// CreatDate:2011-10-25
/// Descripiton:获取退费,退货交易参数
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院),Guser:收费员ID,PayModeDr:支付方式
/// 		PrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HospDR:医院指针
/// 			ExpStr:扩展串
/// Output:	InputXML:银行交易入参信息
/// Return:	0:成功,非0:不成功
/// Other:	
/// Debug:w ##class(web.DHCBillBankLogicBJXH).GetTradeRefundInput("OP","3881","180204","","15","","V","^^3","")
ClassMethod GetTradeRefundInput(PatType As %String, Guser As %String, NewPrtRowid As %String, AbortPrtRowid As %String, PayModeDr As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String, ByRef Input As web.DHCEntity.PCA.BankTradeInput)
{
	n (PatType, Guser, NewPrtRowid,AbortPrtRowid,PayModeDr, BankCardNO, BankTradeType, ExpStr,Input)
	;
	s $ZT="ERROR^DHCSSERR" 
	d ..tb()
	s HospDR=$p(ExpStr,"^",3)
	s TerminalID=Guser
	s HospCode=$p($get(^CT("HOSP",HospDR)),"^",1)
	if (HospCode="") set HospCode=HospDR
	s HospitalID=HospCode
	b ;根据发票号获取原交易记录信息
	s InitInvDR=$p(^DHCINVPRT(AbortPrtRowid),"^",13)	;原发票Rowid
	s OldBankTradePayDR=..GetOriginalTradeRowID(InitInvDR)
	s PaidTransactionId=$p(^DHCINVBTP(OldBankTradePayDR),"^",32) ;IBP_HISTradeID原交易流水号
	s BankCardNo=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
	s Charge=..GetOPInvBankCardAmt(NewPrtRowid_"|"_AbortPrtRowid)
	s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNo)
	s TradeCode=..GetTradeCodeByBankTradeType(BankTradeType)
	s PapmiDR=$p(CardInfo,"^",2)
	s PatientID=$p(^PAPER(PapmiDR,"PAT",1),"^",2)
	s BankCode=$p(CardInfo,"^",8)
	s TelNo=$p(^PAPER(PapmiDR,"PAT",3),"^",6)		;PAPMI_DVAnumber 电话
	s TotalCharge=""	;预授权确认金额
	;
	s TradeChannel="02"	;交易渠道
	s err=0,IBPRowID=""
	;
	if +err=0 {
		b ;生成HIS端交易号
		s TradeInfo=..SetTradeID(BankCardNo,BankTradeType,HospDR,ExpStr)	
		s err=$p(TradeInfo,"^",1)
		s IBPRowID=$p(TradeInfo,"^",2)
		s TransactionId=$p(TradeInfo,"^",3)	
	}
	;
	if +err=0{
		b ;生成银行入参信息
		s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
		s InputObj.TradeCode=TradeCode
	    s InputObj.BankCode=BankCode
	    s InputObj.TerminalID=TerminalID
	    s InputObj.HospitalID=HospitalID
	    s InputObj.BankCardNo=BankCardNo
	    s InputObj.TransactionId=TransactionId
	    s InputObj.Charge=Charge
	    s InputObj.PatientID=PatientID
		s InputObj.TelNo=TelNo
	    s InputObj.PaidTransactionId=PaidTransactionId
	    ;s InputObj.TotalCharge=TotalCharge
	    s InputObj.TranWay=TradeChannel
		s CTxnDtTm=$e($zd(+$h,8),3,8)_$tr($zt($p($h,",",2),1),":","")
	    s InputObj.CTxnDtTm=CTxnDtTm
	    s Input=InputObj
	    d InputObj.XMLExportToString(.InputXML,"Request")
	}
   	;
    i +err'=0 d
    .TROLLBACK
	e  d
	.d ..tc()
	
	q err_"^"_$g(IBPRowID)
}

/// 	Creator:Lid
/// 	CreatDAte:2011-11-10
/// 	Description:根据退费发票Rowid获取获取原交易记录信息
/// 	Input:InitInvDR:原发票RowID
/// 	Return:
/// 	Debug:
ClassMethod GetOriginalTradeRowID(InitInvDR)
{
	n (InitInvDR)
	s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",InitInvDR,""),-1)	;原交交易记录指针(取最后一条记录)
	q OldBankTradePayDR
	
	/*s IPMSub=$o(^DHCINVPRTi(0,"PMDR",InitPrtDR,PayModeDr,"P","0"))
	s IPMRowID=InitPrtDR_"||"_IPMSub
	s TradePayDR=$p(^DHCINVPRT(InitPrtDR,"P",IPMSub),"^",16)	;IPM_TradeId_DR 原交易记录
	s PaidTradeIdDR=$p(^DHCINVPRT(InitPrtDR,"P",IPMSub),"^",17)
	s RefundDR=$p(^DHCINVPRT(InitPrtDR,"P",IPMSub),"^",18)
	i BankTradeType="V" s OldBankTradePayDR=TradePayDR		;撤销预授权,取原预授权记录的交易号
	i BankTradeType="T" s OldBankTradePayDR=PaidTradeIdDR	;退货,取完成预授权记录的交易号
	s PaidTransactionId=$p(^DHCINVBTP(OldBankTradePayDR),"^",32) ;IBP_HISTradeID原交易流水号
	s BankCardNO=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
	*/
}

/// Creator:Lid
/// CreatDate:2011-10-19
/// Descripiton:更新银医卡交易信息
/// Input:
/// Output:	
/// Return:	0:成功,非0:不成功
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).UpdateTradeInfo("","","")
ClassMethod UpdateTradeInfo(PatType As %String, Guser As %String, BankTradeType As %String, HISTradeNO As %String, PrtRowid As %String, AbortPrtRowID As %String, BankOutputXML As %String, ExpStr As %String) As %String
{
	n (PatType ,Guser,BankTradeType,HISTradeNO,PrtRowid,AbortPrtRowID, BankOutputXML, ExpStr)
	;
	;s $ZT="ERROR^DHCSSERR"
	s err=0
	;解析银行返回值
	s OutputObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankOutputXML)
	s AcctDate=OutputObj.AcctDate
	s AcctTime=OutputObj.AcctTime
	s TransactionId=OutputObj.TransactionId
	s PatientID=OutputObj.PatientID
	s ResultCode=OutputObj.ResultCode
	;b 
	//s ErrorMsg=OutputObj.ErrorMsg
	s ErrorMsg=OutputObj.ResultContent
	;
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HISTradeNO,"0"))
	;
	;d ..tb()
	;
	;b ;更新银行交易信息表
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		s PLIST(2)=ResultCode		;IBPRc
		s PLIST(3)=ErrorMsg			;IBP_Rc_detail
		s PLIST(6)=TransactionId	;IBP_mer_systrace	银行交易流水号
		s PLIST(7)=""				;IBP_invoice_no	银行原交易流水号
		s:AcctDate["-" AcctDate=$zdh(AcctDate,3)
		s:AcctTime[":" AcctTime=$zth(AcctTime,1)
		s PLIST(15)=AcctDate		;IBP_txn_date
		i AcctTime'="" s PLIST(16)=AcctTime		;IBP_txn_time
		;s PLIST(24)=TradeAmt		;IBP_TradeAmt
		s PLIST(25)=PatType			;IBP_TradeType
		s PLIST(26)=Guser		;IBP_TradeUser_DR
		;s PLIST(33)=TransactionId	;IBPHISTradeID	HIS交易流水号
		;s PLIST(34)=HISOldTradeID	;IBP_HISOldTradeID	HIS原交易流水号
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	}
	if +err=0 {
		;b ;更新交易明细表及插入子表	
    	s rtn=..UpdateTradeSub(HISTradeNO,PrtRowid,AbortPrtRowID)
    	s err=$p(rtn,"^",1)		
	}
	;
	/*
	if +err=0 {
		;b ;更新发票支付方式表
		s BankTradeType=$p(^DHCINVBTP(IBPRowID),"^",24)
		s PrtRowid="" , AbortPrtRowid=""
		s IBSSub="0"
		f  s IBSSub=$o(^DHCINVBTP(IBPRowID,"C",IBSSub)) q:IBSSub=""  d
		.s s=$g(^DHCINVBTP(IBPRowID,"C",IBSSub))
		.s ConsultStatus=$p(s,"^",2)
		.s Status=$p(s,"^",4)	;IBS_Status 该记录对应的发票记录是否是作废(N:正常,A:作废)
		.q:Status="A"
		.s InvPrtDR=$p(s,"^",1)
		.i ConsultStatus="N" s PrtRowid=InvPrtDR
		.i ConsultStatus="A" s AbortPrtRowid=InvPrtDR
		.s PrtRowIDStr=PrtRowid_"|"_AbortPrtRowid
		.s IPMDRSub="0"
		.f  s IPMDRSub=$o(^DHCINVPRT(InvPrtDR,"P",IPMDRSub)) q:IPMDRSub=""  d
		..s IPMPayMDR=$p(^DHCINVPRT(InvPrtDR,"P",IPMDRSub),"^",1)
		..s HandComFlag=..GetPayModeHardComm("OP",IPMPayMDR)
		..q:+HandComFlag=0
		..s IPMDR=InvPrtDR_"||"_IPMDRSub
		..i BankTradeType="S" d
		...&sql(UPDATE DHC_INVPAYMODE SET IPM_PaidTradeId_DR=:IBPRowID WHERE IPM_RowID=:IPMDR)
		...s err=SQLCODE
		..e  i BankTradeType="T" d
		...&sql(UPDATE DHC_INVPAYMODE SET IPM_Refund_DR=:IBPRowID WHERE IPM_RowID=:IPMDR)
		...s err=SQLCODE
		..e  d
		...&sql(UPDATE DHC_INVPAYMODE SET IPM_TradeId_DR=:IBPRowID WHERE IPM_RowID=:IPMDR)
		...s err=SQLCODE
	}
	*/
	;
	/*
	i +err'=0 d
	.TROLLBACK
	e  d
	.d ..tc()
	*/
	;
	q:(ResultCode'="000") ResultCode_"^"_IBPRowID_"^"_ErrorMsg
	;
	q err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)
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
	.s InitInvDR=$p(^DHCINVPRT(AbortPrtRowid),"^",13)
	.s BankTradeType=..CheckRefundTradeType(InitInvDR)
	.s InitInvDR=$p(^DHCINVPRT(AbortPrtRowid),"^",13)	;原发票Rowid
	.s OldBankTradePayDR=..GetOriginalTradeRowID(InitInvDR)
	.s PaidTransactionId=$p(^DHCINVBTP(OldBankTradePayDR),"^",33)	;IBP_HISOldTradeID 为空说明是第一次退费,不为空,则把它挪到新交易记录上,以方便再次退费
	.i PaidTransactionId="" d
	..s PaidTransactionId=OldBankTradePayDR ;IBP_HISTradeID原交易流水
	.s BankCardNo=$p(^DHCINVBTP(OldBankTradePayDR),"^",3)	;卡号(原交易卡号),退费时不一定先读卡
	;
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",TransactionId,"0"))
	;
	s PrtRowIDStr=PrtRowid_"|"_AbortPrtRowid
	;获取交易金额
	s Charge=..GetOPInvBankCardAmt(PrtRowIDStr)
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		s PLIST(21)=OldBankTradePayDR	;IBP_OldBankTradePay_DR 被完成或被撤销的交易记录指针
		s PLIST(24)=Charge			;IBP_TradeAmt
		s PLIST(34)=PaidTransactionId	;IBP_HISOldTradeID	HIS原交易流水号
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
	}
	;
	;b ;更新原交易记录
	i ((+err=0)&(OldBankTradePayDR'="")) d
    .s err=##class(web.DHCOPBillINVBankPay).SELECT(OldBankTradePayDR)
	.q:+err'=0
	.s CompleteFlag=""
	.i BankTradeType="V" s CompleteFlag=2	;撤销预授权标志
	.;i BankTradeType="S" s CompleteFlag=1	;预授权完成确认标志
	.s PLIST(30)=CompleteFlag	;IBP_CompleteFlag 预授权完成/撤销标志(空:未完成/未撤销,1:完成,2:撤销)
	.s err=##class(web.DHCOPBillINVBankPay).UPDATE(OldBankTradePayDR)
	;
	if +err=0 {
		;b ;插子表(DHC_InvBankConSub)
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
		..s HandComFlag=..GetPayModeHardComm("OP",PayModeDr)
		..q:+HandComFlag=0
		..s myPayModeDr=PayModeDr
		.s IPMDRSub=$o(^DHCINVPRTi(0,"PMDR",myPrtRowID,myPayModeDr,"P","0"))
		.s PLIST(5)=myPrtRowID_"||"_IPMDRSub	;IBS_InvPayMode_DR
		.s PLIST(6)="N"
		.s err=##class(web.DHCOPBillINVBankConSub).INSERT()	
	}
	;
	q err_"^"_IBPRowID
}

/// Creator:Lid
/// CreatDate:2011-10-20
/// 
/// Lid
/// 2011-10-20
/// 根据门诊发票表Rowid获取银医卡支付金
ClassMethod GetOPInvBankCardAmt(rowidStr)
{
	n (rowidStr)
	s amt=0.00
	s num=$l(rowidStr,"|")
	f i=1:1:num d
	.s rowid=$p(rowidStr,"|",i)
	.q:+rowid=0
	.s IPM="0"
	.q:'$d(^DHCINVPRT(rowid,"P",IPM))
	.f  s IPM=$o(^DHCINVPRT(rowid,"P",IPM)) q:IPM=""  d
	..s s=$g(^DHCINVPRT(rowid,"P",IPM))
	..s payMDr=$p(s,"^",1)
	..s payMCode=$p(^CT("CTPM",payMDr),"^",1)
	..s payMAmt=+$p(s,"^",3)
	..s handDr=..GetPayModeHardComm("OP",payMDr)
	..i handDr'="" d
	...s amt=amt+payMAmt
	s amt=$fn($zabs(amt),"",2)
	;
	q amt
}

/// Creator:Lid
/// CreatDate:2011-10-20
/// Description:根据HIS交易类型获取银行交易代码
/// Input:BankTradeType(P:预授权,S:完成预授权,V:撤销预授权,C:支付,D:退费,T:退货,B:批量退货)
/// Output:
/// Return:银行交易代码
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).GetTradeCodeByBankTradeType("C")
ClassMethod GetTradeCodeByBankTradeType(BankTradeType)
{
	n (BankTradeType)
	q:BankTradeType="C" 4101	;支付
	q:BankTradeType="D" 4102	;退费
	q:BankTradeType="T" 4103	;退货
	q:BankTradeType="B" 4104	;批量退货
	q:BankTradeType="P" 4105	;预授权
	q:BankTradeType="V" 4106	;取消预授权
	q:BankTradeType="S" 4107	;完成预授权
	q 0
}

/// Creator:Lid
/// CreatDate:2011-10-20
/// Description:根据银行交易代码获取HIS交易类型
/// Input:BankTradeType(P:预授权,S:完成预授权,V:撤销预授权,C:支付,D:退费,T:退货,B:批量退货)
/// Output:
/// Return:银行交易类型
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).GetBankTradeTypeByTradeCode("3001")
ClassMethod GetBankTradeTypeByTradeCode(TradeCode)
{
	n (TradeCode)
	q:TradeCode="4101" "C" 	;支付
	q:TradeCode="4102" "D"	;退费
	q:TradeCode="4103" "T"	;退货
	q:TradeCode="4104" "B"	;批量退货
	q:TradeCode="4105" "P"	;预授权
	q:TradeCode="4106" "V" 	;取消预授权
	q:TradeCode="4107" "S" 	;完成预授权
	q 0
}

/// Creator:Lid
/// CreatDate:2011-10-19
/// Description:判断是否调用银行接口(非空则调用)
/// Other:Insert	into	DHC_CTPayModeExp (PME_HardCom_DR,pme_ifmode,pme_iotype,PME_PayMode_DR) values (1,'WS','OP',14)
/// Debug:w ##class(web.DHCBillBankLogicBJXH).GetPayModeHardComm("OP",14)
ClassMethod GetPayModeHardComm(invType, PayMode)
{
	n (invType,PayMode)
	s invType=" "_invType,PayMode=" "_PayMode
	s HardDr=""
	i $d(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode)) d
	.s HardRowID=$o(^User.DHCCTPayModeExpI("PMEPayModeDRIndex",invType,PayMode,""))
	.s HardDr=$LIST(^User.DHCCTPayModeExpD(HardRowID),3)
	q $g(HardDr)
}

/// Creator:Lid
/// CreatDate:2011-10-19
/// Descritpion:生成HIS的唯一交易号(20位,医院Code+日期(6)+时间(4)+银行交易信息表Rowid(9))
/// Input:BankTradeType:银行交易类型,IBPRowid:银行交易信息表Rowid(DHC_INVBankTradePay)
/// Output:
/// Return:
/// Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).SetTransactionId(1234567899)
ClassMethod SetTransactionId(IBPRowid)
{
	n (IBPRowid)
	;s ServerCode=$g(^HISServerCode)
	;s:ServerCode="" ServerCode=1	
	s HospDR=$p(^DHCINVBTP(IBPRowid),"^",28)
	s:HospDR'="" HospCode=$Get(^DHCRegInterfaceCodeRelate("HospitalId","Outer",HospDR))    //$p($get(^CT("HOSP",HospDR)),"^",1)
	s:HospCode="" HospCode=1	;协和医院默认传1	
	s CurrDate=$e($zd(+$h,8),3,8)
	s CurrTime=$tr($zt($p($h,",",2),2),":","")
	s tmp="000000000"
	s:$l(IBPRowid)>9 IBPRowid=$e(IBPRowid,$l(IBPRowid)-8,$l(IBPRowid))
	s FormatIBPRowid=$e(tmp,1,$l(tmp)-$l(IBPRowid))_IBPRowid
	s rtn=HospCode_CurrDate_CurrTime_FormatIBPRowid
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-10-29
/// Description:退费时验证交易类型
/// Input:PrtRowID:需退费的发票Rowid
/// 	Return:D:退费,T:退货,V:撤销预授权
/// Debug:
ClassMethod CheckRefundTradeType(PrtRowID)
{
	n (PrtRowID)
    s rtn=""
	s IBPRowID=..GetOriginalTradeRowID(PrtRowID)
	q:+IBPRowID=0 rtn
	s TxtDate=$p(^DHCINVBTP(IBPRowID),"^",14)	;IBP_txn_date 银行交易日期
	q:TxtDate'=+$h "T"
	q "D"
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
	;i ((HandFlag=1)&(Amt'=0)) s rtn=1
	i (HandFlag=1) s rtn=1
	;
	q rtn_"^"_PayModeDR
}

/// Lid
/// 2011-03-23
/// 银医卡交易失败后，更新支付方式按现金结算
ClassMethod UpdateCARDToCASH(invRowid As %String = "")
{
	;w ##class(web.DHCBillBankLogicBJXH).UpdateCARDToCASH(180159)
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

/// Lid
/// 2011-03-23
/// 根据支付方式代码获取支付方式Rowid
ClassMethod GetPayMDrByPayMCode(paymCode)
{
	;w ##class(web.DHCBillBankLogic).GetPayMDrByPayMCode("CASH")
	n (paymCode)
	s paymCode=$$ALPHAUP^SSUTIL4(paymCode)
	s rowid=$o(^CT("CTPM",0,"Code",paymCode,""))
	;
	q $g(rowid)
}

/// Creator:Lid
/// CreatDate:2011-10-28
/// Description:验证银医卡支付金额的退费模式()
/// 	Input:AbortPrtRowID:退费发票的负记录Rowid,PrtRowID:新发票RowID
/// 	Return:0:全退,1:部分退,2:作废重打
/// 	Other:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).CheckRefundMode("180251","180250")
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
	..i HandDr=1 d
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
	..i HandDr=1 d
	...s Amt2=Amt2+payMAmt
    ;
    s Amt1=$zabs(Amt1),Amt2=$zabs(Amt2)
    q:Amt1=0 0	;新发票记录的银医卡金额为0时,全退
    q:((Amt1'=0)&(Amt1<Amt2)) 1	;新发票记录的银医卡金额不为0时,部分退
    q:((Amt1'=0)&(Amt1=Amt2)) 2	;作废重打
}

/// Creator:Lid
/// CreatDate:2011-11-09
/// Description:预授权完成确认
/// Input:
/// Return:
/// Other:^DHCINVBTPi(0,"TxnDate")
/// Debug:d ##class(web.DHCBillBankLogicBJXH).PreAuthorizationConfirm()
ClassMethod PreAuthorizationConfirm()
{
	TRY {
		s err=0
		s AcctDate=+$h
		s CardType=""
		f  s CardType=$o(^DHCINVBTPi(0,"TxnDate",AcctDate,CardType)) q:CardType=""  d
		.s IBPRowID="0"
		.f  s IBPRowID=$o(^DHCINVBTPi(0,"TxnDate",AcctDate,CardType,IBPRowID)) q:IBPRowID=""  d 
		..s s=$g(^DHCINVBTP(IBPRowID))
		..s Rc=$p(s,"^",1)	;IBP_Rc
		..s BankTradeType=$p(s,"^",24)	;IBP_BankTradeType
		..s CompleteFlag=$p(s,"^",29)	;IBP_CompleteFlag
		..q:Rc'="000"	;过滤交易失败记录
		..q:BankTradeType'="P"	;过滤非预授权记录
		..q:((+CompleteFlag'=0)&(CompleteFlag'=3))	;过滤预授权完成记录和撤销预授权记录
		..s BankCardNo=$p(s,"^",3)	;IBP_Pan
		..s TradeCode=..GetTradeCodeByBankTradeType("S")
		..s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNo)
		..s PapmiDR=$p(CardInfo,"^",2)
		..s PatientID=$p(^PAPER(PapmiDR,"PAT",1),"^",2)
		..s BankCode=$p(CardInfo,"^",8)
		..s TerminalID=$p(s,"^",25)	;IBP_TradeUser_DR   
		..s HospitalID=$p(s,"^",28)	;IBP_Hospital_Dr
		..s HospCode=$p(^CT("HOSP",HospitalID),"^",1)
		..;s HospitalID=HospCode
		..s Charge=$p(s,"^",23)
		..s TotalCharge=$p(s,"^",23)	;IBP_TradeAmt
		..s TelNo=$p(^PAPER(PapmiDR,"PAT",3),"^",6)		;PAPMI_DVAnumber 电话
		..s TranWay="02"	;交易渠道
		..s CTxnDtTm=$e($zd(+$h,8),3,8)_$tr($zt($p($h,",",2),1),":","")
		..s PaidTransactionId=$p(s,"^",32)	;IBP_HISTradeID
		..;获取预授权记录对应的发票指针
		..s IBSSub="0",IBSINVPRTDR=""
		..f  s IBSSub=$o(^DHCINVBTP(IBPRowID,"C",IBSSub)) q:IBSSub=""  d
		...s ss=$g(^DHCINVBTP(IBPRowID,"C",IBSSub))
		...s IBSStatus=$p(ss,"^",4)
		...q:IBSStatus="A"
		...s IBSINVPRTDR=$p(ss,"^",1)	;IBS_INVPRT_DR
		..q:IBSINVPRTDR=""
		..;生成"预授权确认"记录的HIS交易流水号
		..s ExpStr="^^"_HospitalID_"^^^"
		..s TradeInfo=..SetTradeID(BankCardNo,"S",HospitalID,ExpStr)	
		..s err=$p(TradeInfo,"^",1)
		..s SIBPRowID=$p(TradeInfo,"^",2)	;新插入记录的Rowid
		..s TransactionId=$p(TradeInfo,"^",3)
		..s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
		..s InputObj.TradeCode=TradeCode
	    ..s InputObj.BankCode=BankCode
	    ..s InputObj.TerminalID=TerminalID	;？需求讨论，是写死一个系统用户，还是使用预授权交易的用户
	    ..s InputObj.HospitalID=HospCode
	    ..s InputObj.BankCardNo=BankCardNo
	    ..s InputObj.PatientID=PatientID
		..s InputObj.TelNo=TelNo
	    ..;s InputObj.TotalCharge=$j(TotalCharge,3,2)
	    ..s InputObj.TranWay=TranWay
		..s CTxnDtTm=$e($zd(+$h,8),3,8)_$tr($zt($p($h,",",2),1),":","")
	    ..s InputObj.CTxnDtTm=CTxnDtTm
	    ..;s PaymentObj=##class(web.DHCEntity.PCA.Payment).%New()
	    ..;s PaymentObj.TransactionId=TransactionId
	    ..;s PaymentObj.PaidTransactionId=PaidTransactionId
	    ..;s PaymentObj.Charge=$j(Charge,3,2)
	    ..;d InputObj.PaymentList.Insert(PaymentObj)
	    ..s InputObj.TransactionId=TransactionId
	    ..s InputObj.PaidTransactionId=PaidTransactionId
	    ..s InputObj.Charge=$j(Charge,3,2)
	    ..s InputXML=""
	    ..d InputObj.XMLExportToString(.InputXML,"Request")
	    ..s PrtRowID=""
	    ..s IBSSub="0"
		..f  s IBSSub=$o(^DHCINVBTP(IBPRowID,"C",IBSSub)) q:IBSSub=""  d
		...s s=$g(^DHCINVBTP(IBPRowID,"C",IBSSub))
		...s ConsultStatus=$p(s,"^",2)
		...s Status=$p(s,"^",4)	;IBS_Status 该记录对应的发票记录是否是作废(N:正常,A:作废)
		...q:Status="A"
		...s PrtRowID=$p(s,"^",1)
		..q:PrtRowID=""
	    ..s Output=""	;调用平台组接口
		..;Test
		..;s AccDate=$zd(+$h,3)
		..;s Output="<Response><AcctDate>"_AccDate_"</AcctDate><AcctTime></AcctTime><TransactionId>"_TransactionId_"</TransactionId><PatientID>395</PatientID ><ResultCode>000</ResultCode><ErrorMsg>成功!</ErrorMsg></Response>"
		..;b ;Test
		..s DHCENSSOAP=##class(DHCENS.SOAP.CardpaymentSoap).%New()
		..s Output=DHCENSSOAP.Cardpayment(InputXML)
		..d DHCENSSOAP.%Close()
		..;b ;更新银医卡交易信息
		..s returnValue=..UpdateTradeInfo("OP",TerminalID,"S",TransactionId,PrtRowID,"",Output,ExpStr)
		..s err=$p(returnValue,"^",1)
		..s NewIBPRowID=$p(returnValue,"^",2)
		..s BankResultCode=$p(returnValue,"^",3)
		..;
		..;b ;更新交易记录表中的原交易记录指针
		..i (+err=0) d
	    ...s err=##class(web.DHCOPBillINVBankPay).SELECT(NewIBPRowID)
		...s PLIST(21)=IBPRowID	;IBP_OldBankTradePay_DR 被完成或被撤销的交易记录指针
		...s PLIST(34)=IBPRowID	;IBP_HISOldTradeID	HIS原交易流水号
		...s err=##class(web.DHCOPBillINVBankPay).UPDATE(NewIBPRowID)
		..;b ;更新原交易记录
		..i (+err=0) d
	    ...s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
		...i BankResultCode="000" s CompleteFlag=1	;预授权完成确认标志
		...e  s CompleteFlag=3	
		...s PLIST(30)=CompleteFlag	;IBP_CompleteFlag 预授权完成/撤销标志(空:未完成/未撤销,1:完成,2:撤销)
		...s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)
		;q err
	}catch{
		Set ^PreAuthorizationConfirmLog("ErrorLog",+$h,$p($h,",",2))=$ZERROR
	}
}

/// Creator:Lid
/// CreatDate:2011-11-14
/// Description:生成银行对账文件
/// Input:
/// Return:
/// Other:
/// Debug:
ClassMethod SetBankReconciliation()
{
	k BankReconciliationDataAry
	s AcctDate=$h,Count=0
	s CardType=""
	f  s CardType=$o(^DHCINVBTPi(0,"TxnDate",AcctDate,CardType)) q:CardType=""  d
	.s IBPRowID="0"
	.f  s IBPRowID=$o(^DHCINVBTPi(0,"TxnDate",AcctDate,CardType,IBPRowID)) q:IBPRowID=""  d 
	..s s=$g(^DHCINVBTP(IBPRowID))
	..s Rc=$p(s,"^",1)	;IBP_Rc
	..s BankTradeType=$p(s,"^",24)	;IBP_BankTradeType
	..s TradeCode=..GetTradeCodeByBankTradeType(BankTradeType)
	..s TxnDate=$p(s,"^",14)	;IBP_txn_date
	..s TradeDate=$p(s,"^",21)	;IBP_TradeDate
	..s TradeTime=$p(s,"^",22)	;IBP_TradeTime
	..s TransactionId=$p(s,"^",32)	;IBP_HISTradeID	
	..s CompleteFlag=$p(s,"^",29)	;IBP_CompleteFlag
	..;q:Rc'="000"	;过滤交易失败记录
	..s BankCardNo=$p(s,"^",3)	;IBP_Pan
	..s Charge=$p(s,"^",23)
	..s YYH=""	;预约号(工行对账文本里有,待定)
	..i ((BankTradeType="P")!(BankTradeType="V")) d
	...s PVCount=+$g(PVCount)+1
	...s PVSum=+$g(PVSum)+Charge
	..e  d
	...s SCDTCount=+$g(SCDTCount)+1
	...s SCDTSum=+$g(SCDTSum)+Charge
	..s Count=Count+1
	..;
	..s FCount=..FormatStr(Count,6,"0")
	..s FTradeDT=$zd(TradeDate,8)_$tr($zt(TradeTime,1),":","")
	..s FTradeID=TransactionId
	..s FCardNO=..FormatStr(BankCardNo,19,"0")
	..s FCharge=..FormatStr($j(Charge,3,2),19,"0")
	..s FYYH=..FormatStr(YYH,20," ")
	..s FTradeCode=..FormatStr(TradeCode,4,"0")
	..s Data=FTradeDT_FTradeID_FCardNO_FCharge_FYYH_FTradeCode
	..s BankReconciliationDataAry(BankTradeType,Count)=Data
	;
	;数据写入流
	s PVStream=##class(%GlobalCharacterStream).%New()
	s AcctDate=$zd(+h,8)
	s PVCount=##class(web.DHCBillBankLogicBJXH).FormatStr(PVCount,6,"0")
	s PVSum=##class(web.DHCBillBankLogicBJXH).FormatStr($j(PVSum,3,2),17,"0")
	s PVTotalData="ICBC"_FAcctDate_PVCount_PVSum
	d PVStream.WriteLine(PVTotalData)
	;
	s SCDTStream=##class(%GlobalCharacterStream).%New()
	s SCDTCount=##class(web.DHCBillBankLogicBJXH).FormatStr(SCDTCount,6,"0")
	s SCDTSum=##class(web.DHCBillBankLogicBJXH).FormatStr($j(SCDTSum,3,2),17,"0")
	s SCDTTotalData="ICBC"_FAcctDate_SCDTCount_SCDTSum
	d SCDTStream.WriteLine(SCDTTotalData)
	;
	s TradeType=""
	f  s TradeType=$o(BankReconciliationDataAry(TradeType)) q:TradeType=""  d
	.s ind=0,PVNum=1,SCDTNum=1
	.f  s ind=$o(BankReconciliationDataAry(TradeType,ind)) q:ind=""  d
	..i TradeType="P"!TradeType="V" d
	...s FPVNum=##class(web.DHCBillBankLogicBJXH).FormatStr(PVNum,6,"0")
	...s tmp=FPVNum_BankReconciliationDataAry(TradeType,ind)
	...d PVStream.WriteLine(tmp)
	...s PVNum=PVNum+1
	..e  d
	...s FSCDTNum=##class(web.DHCBillBankLogicBJXH).FormatStrFSCDTNum(SCDTNum,6,"0")
	...s tmp=FSCDTNum_BankReconciliationDataAry(TradeType,ind)
	...d SCDTStream.WriteLine(tmp)
	...s SCDTNum=SCDTNum+1
	;
	k BankReconciliationDataAry
	;
	;数据上传FTP
	s ftpIP="10.72.16.158"
	s userName="Administrator"
	s password="123456"
	s port=21
	;生成文件名
	s FileName="ICBC"_$zd(+$h,8)_"SCDT"_".txt"
	if ('(PVStream.IsNull())){
		Set file="BankTradeData\"_FileName
		Set ftp=##class(%Net.FtpSession).%New()
		set char = ##class(%IO.I.TranslationDevice).GetCharEncodingTable("GB18030")
		Set ftp.TranslateTable=char	;编码转换
		If 'ftp.Connect(ftpIP,userName,password,port) Quit
		if ftp.Delete(file)
		if 'ftp.Append(file,PVStream) Quit
		d ftp.%Close()
	}
	d PVStream.%Close()
	;
	s FileName="ICBC"_$zd(+$h,8)_"PV"_".txt"
	if ('(SCDTStream.IsNull())){
		Set file="BankTradeData\"_FileName
		Set ftp=##class(%Net.FtpSession).%New()
		set char = ##class(%IO.I.TranslationDevice).GetCharEncodingTable("GB18030")
		Set ftp.TranslateTable=char	;编码转换
		If 'ftp.Connect(ftpIP,userName,password,port) Quit
		if ftp.Delete(file)
		if 'ftp.Append(file,SCDTStream) Quit
		d ftp.%Close()
	}
	d SCDTStream.%Close()
	
	q 0
}

/// Creator:Lid
/// CreatDate:2011-11-08
/// Description:格式化字符串
/// Input:SourceStr:源字符串,FormatLength:格式化长度,FormatChar:补齐字符
/// Return:
/// Other:注:(如果源字符串是金额,则需要先四舍五入,并保留两位有效数字)
/// Debug:w ##class(web.DHCBillBankLogicBJXH).FormatStr("1.00","15"," ")
ClassMethod FormatStr(SourceStr, FormatLength, FormatChar, RightFlag As %String = "L")
{
	n (SourceStr,FormatLength,FormatChar,RightFlag)
	;替换源代码中的"小数点","空格"
	s SourceStr=$tr(SourceStr,".","")
	s SourceStr=$tr(SourceStr," ","")
	;s SourceStr=##class(web.UDHCJFBaseCommon).Replace(SourceStr,"　","")
	s SourceStr=$TR(SourceStr,"　","")
	;
	s tmp=""
	f i=1:1:FormatLength d
	.s tmp=tmp_FormatChar
	if ($get(RightFlag)="R")
	{
		s FormatStr=SourceStr_$e(tmp,1,FormatLength-$l(SourceStr))
	}
	else
	{
		s FormatStr=$e(tmp,1,FormatLength-$l(SourceStr))_SourceStr
		
	}
	q FormatStr
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

/// Creator:Lid
/// CreatDate:2011-12-01
/// Description:删除交易明显表记录
/// Input:
/// Return:
/// Debug:w ##class(web.DHCBillBankLogicBJXH).DeleteIBP(410,"")
ClassMethod DeleteIBP(IPBRowID, ExpStr)
{
	n (IPBRowID,ExpStr)
	s myrtn=##class(web.DHCOPBillINVBankPay).DELETE(IPBRowID)
	q myrtn
}

/// tangtao
/// 2011-11-18
/// 使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(web.DHCBillBankLogic).GetRecTXTFromFTP()
ClassMethod GetRecTXTFromFTP()
{
	;w ##class(web.DHCBillBankLogic).GetRecTXTFromFTP()
	//s tradeDate=62229
	s ftpIP="10.160.15.27"
	s userName="ftpuser"
	s password="dhcc_ftp123"
	s port=21
	;门诊对账数据
	s path="/Accounts/01/"
	;s fileName="AHSLYY_05_"_$zd(+$h-1,8)       
    s fileName="ICBC20120608"
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

/// 获取各银行对账文本FTP目录
/// w ##class(web.DHCBillBankLogicBJXH).BanlanceBankInfo()
ClassMethod BanlanceBankInfo()
{
	s ftpIP="10.160.15.27"
	s userName="ftpuser"
	s password="dhcc_ftp123"
	s port=21,fileName=""
	s ghrtn=0,nhrtn=0,zhrtn=0,jhrtn=0
	s AcctDate=+$h-1
	;s AcctDate=$zdh("2012-10-28",3)	;日期
	s fileName="ICBC"_$zd(AcctDate,8)       ;1 工行
	s ghrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,"01")
	s fileName="CCB"_$zd(AcctDate,8)       ;2 建行
	s nhrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,"02")
	s fileName="BOC"_$zd(AcctDate,8)       ;3 中行
	s zhrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,"04")
	s fileName="BOCM"_$zd(AcctDate,8)    ;4 交行
	s jhrtn=..GetCARDCPPTXTFromFTP(ftpIP,userName,password,port,fileName,"03")
	q ghrtn_"^"_nhrtn_"^"_zhrtn_"^"_jhrtn
}

/// ///在指定FTP服务器上获取对账数据///////////////////////////////
/// tangtao
/// 2011-11-18
/// 使用%Net.FtpSession获取指定路径下的对账文本
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.172.10.20","dhcc","dhcc","2011","AHSLYY_02_20120209083000","2")
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.172.10.20","dhcc","dhcc","2011","AHSLYY_03_20120310020006","3")
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.172.10.20","dhcc","dhcc","2011","AHSLYY_04_20120311103240","4")
/// w ##class(web.DHCBillBankLogic).GetCARDCPPTXTFromFTP("172.172.10.20","dhcc","dhcc","2011","AHSLYY_04_20120218175336","1")
ClassMethod GetCARDCPPTXTFromFTP(ftpIP, userName, password, port, fileName, bankid)
{
	s stream=##class(%GlobalCharacterStream).%New()
	s path=""
	i bankid="01" d		;工行
	.s path="/Accounts/ICBC/"	
	.s file=path_fileName_".txt"
	i bankid="02" d		;建行
	.s path="/Accounts/CCB/"
	.s file=path_fileName_".txt"
	i bankid="04" d		;中行
	.s path="/Accounts/BOC/"
	.s file=path_fileName_".txt"
	i bankid="03" d		;交行
	.s path="/Accounts/BOCM/"
	.s file=path_fileName_".txt"
	s ftp=##class(%Net.FtpSession).%New()
	s ftp.TranslateTable="UTF8"
	If 'ftp.Connect(ftpIP,userName,password,port) Quit "请查证IP地址,用户名,密码,端口号是否正确"
	;
	;b ;获取文本列表
	n fileArray,key
	i 'ftp.NameList(path,.fileArray) q "获取FTP目录文件列表失败"
	;b ;Get Name List
	s key="",i=$i(BanList)
	f  s BanList(i)=fileArray.GetNext(.key),i=i+1 q:(key="")
	s num=""
	f  s num=$o(BanList(num)) q:num=""  d
	.s BanListInfo=BanList(num)
	.q:BanListInfo'[fileName
	.s file=path_BanListInfo
	if 'ftp.Retrieve(file,stream) Quit "对账文本不存在"
	s Len=0,FalseNum=0,strflag=1
	//s Len=0,FalseNum=0,strflag=0
    while ('stream.AtEnd) {
	    s Info=stream.ReadLine()
	    if (strflag'=1) {
    		q:(Info="")
    		;不管中间是否有失败,全部执行完毕,SaveBalanceInfo 这个方法里有存储失败的数据,可单独处理
    		s rtn=..SaveCARDCPPBalanceInfo(Info,bankid)
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
ClassMethod SaveCARDCPPBalanceInfo(BalanceInfo, BankID)
{
	New (BalanceInfo,BankID)
	Quit:BalanceInfo="" 0
	Set rtn=0
	Set Index=$E($g(BalanceInfo),1,6)			;序号（6）
	Set AccDateTime=$E($g(BalanceInfo),7,20)		;日期时间（14)
	;Set AccDate=$E(AccDateTime,1,8)
	;Set AccDate=$zdh(AccDate,8)
	;Set AccTime=$E(AccDateTime,9,10)_":"_$E(AccDateTime,11,12)_":"_$E(AccDateTime,13,14)
	;Set AccTime=$zth(AccTime,1)
	Set HISTradeNO=$E($g(BalanceInfo),21,40)	;HIS交易流水号（20）
	Set HospDR=""
	If +HISTradeNO'=0 Do
	.Set HospCode=$e(HISTradeNO,1,1)				;第一位是医院的代码
	.Set HospCode=$$ALPHAUP^SSUTIL4(HospCode)
	.Set HospDR=$o(^CT("HOSP",0,"Code",HospCode,"0"))
	Set BankCardNO=$E($g(BalanceInfo),41,59)	;银行卡号（19）
	Set TradeAmt=$E($g(BalanceInfo),60,78)		;金额（19，以分为单位）
	Set TradeAmtF=$j((+TradeAmt/100),3,2)
	Set AppointmentNO=""	;$E($g(BalanceInfo),79,108)	;预约号（30）
	Set TradeType=$E($g(BalanceInfo),79,82)	;交易类型（4）
	Set ExpInfo=$E($g(BalanceInfo),83,122)		;扩展信息(40)
	;b ;解析数据
	Kill PLIST
	Set PLIST(2)=TradeType		;IBT_TradeType
	Set PLIST(3)=BankID			;IBT_BankNo
	Set PLIST(4)=HospDR			;IBT_HopDr
	Set PLIST(8)=BankCardNO		;IBT_BankCardNo
	Set PLIST(10)=HISTradeNO	;IBT_HISTradeNo
	Set PLIST(13)=TradeAmtF		;IBT_TradeAmt
	Set PLIST(14)=AccDateTime	;IBT_BankTradeTime
	Set BankFinDate=$zdh($e(AccDateTime,1,8),8)
	Set PLIST(16)=BankFinDate	;IBT_BankFinDate
	Set PLIST(17)=AppointmentNO	;IBT_AppointmentNO
	Set PLIST(18)=ExpInfo		;IBT_ExpInfo
	Set PLIST(19)=+$h			;IBT_Date	;对账记录导入日期
	Set PLIST(20)=$p($h,",",2)	;IBT_Time	;对账记录导入时间
	//Set PLIST(19)=$zdh("2012-10-18",3)			;IBT_Date	;对账记录导入日期
	//Set PLIST(20)=$p($h,",",2)	;IBT_Time	;对账记录导入时间
    Do ..tb()
	Set myRtn=..DHCINVBankBalanceINSERT()
	Set rtn=$p(myRtn,"^",1)
	If +rtn=0 Do
	.Do ..tc()
	Else  Do
	.Trollback

	Quit rtn
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
	;b ;s $ZT="ERROR^DHCSSERR" d ..tb()
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

}
