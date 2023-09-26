Import SQLUser

/// Lid
/// 2011-11-05
/// 银医卡业务处理类
Class web.DHCBillBMCLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:Lid
/// CreatDate:2011-10-19
/// Descripiton:获取银医卡支付入参信息
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院),PayModeDr:支付方式
/// 		NewPrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HospDR:医院指针
/// 		ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
/// Output:	
/// Return:
/// Other:		
/// 											OP!19028860!!6222001302101206350!C!949^118^^26^23298^23298^^^     
/// 											"DEP!710664!!6228450670001413919!C!796^135^^26^22104^22104^^^"
/// 											     OP!1263457!!6228480258000002471!C!112^253^^26^4982^4982^^^"
/// 1770624,1770625
/// Debug:农行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","1263457","","6228480258000002471","C","112^253^2^26^4982^4982^^^")
/// Debug:农行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","","1770625","","R","112^253^2^26^4982^4982^^^")
/// Debug:农行 w ##class(web.DHCBillBMCLogic).BMCPay("OP",1263375,"","6228480258000002471","C","112^253^2^25^100000000004982^4982")
/// Debug:w ##class(web.DHCBillBMCLogic).BMCPay("OP","19029821","19029820","","R","949^118^^26^23298^23298^^^")
/// Debug:农行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","19029344","","9559900660388591214","C","949^118^^26^23298^23298^^^")
/// Debug:w ##class(web.DHCBillBMCLogic).BMCPay("DEP","710664","","6228450670001413919","C","796^135^^26^22104^22104^^^")
/// Debug:工行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","19029379","","6222001302101206350","C","949^118^^26^23298^23298^^^")
/// Debug:工行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","19029383","19029382","6222001302101206350","R","949^118^^26^23298^23298^^^")
/// Debug:中行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","19028707","","4563511500009554779","C","949^118^^26^23298^23298^^^")
/// Debug:中行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","","19028724","4563511500009554779","R","949^118^^26^23298^23298^^^")
/// Debug:建行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","19028707","","6227001636810776438","C","949^118^^26^23298^23298^^^")
/// Debug:建行 w ##class(web.DHCBillBMCLogic).BMCPay("OP","","19028724","6227001636810776438","R","949^118^^26^23298^23298^^^")
ClassMethod BMCPay(PatType As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PatType, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr)
	s BMCPayNum=$i(^TMPBMCPay)
	s ^TMPBMCPay("BMCPay",BMCPayNum)=PatType_"!"_NewPrtRowid_"!"_AbortPrtRowID_"!"_BankCardNO_"!"_BankTradeType_"!"_ExpStr
	;判断发票是否为银医卡支付
	q:"C^S^R"'[BankTradeType "-1001^"_"^获取银行入参失败,交易类型不正确."
	i PatType="OP" s PayMInfo=##class(web.DHCBillBankLogic).CheckPayMByPrtRowID(NewPrtRowid,AbortPrtRowID)
    i PatType="DEP" s PayMInfo=##class(web.DHCBillBankLogic).CheckPayMByRcptRowID(NewPrtRowid,AbortPrtRowID)
    b ;bzhho
    s CardPayFlag=$p(PayMInfo,"^",1)
    s PayModeDr=$p(PayMInfo,"^",2)
	q:+CardPayFlag=0 "-1"	;非银医卡支付

	i BankTradeType="C" d
	.;记录发票对应的卡号,避免HIS成功,银行失败时没有交易信息,无法获得发票对应的卡号
	.s prtrtn=##class(web.DHCBillBMCLogic).InsertPrtAndBankNo(NewPrtRowid,BankCardNO)
	
	s RefundMode=0
	i PatType="OP" d
	.s RefundMode=##class(web.DHCBillBankLogic).CheckRefundMode(AbortPrtRowID,NewPrtRowid)
	q:+RefundMode=2 "-1"	;作废重打不调用银行接口 
	
	b ;获取银行入参
	s Input=##class(web.DHCEntity.PCA.BankTradeInput).%New()
	s rtn=##class(web.DHCBillBMCLogic).BMCPayInput(PatType, PayModeDr, NewPrtRowid, AbortPrtRowID, BankCardNO, BankTradeType, ExpStr, .Input)
	s err=+$p(rtn,$c(2),1) ;_$c(2)_$g(IBPRowID)_$c(2)_$g(TransactionId)_$c(2)_$g(PaySeqNoStr)
	b ;支付返回
	q:(+err'=0) "-1003^"_"-1003"_"^"_"HIS没有银医卡号信息"
	s IBPRowID=$p(rtn,$c(2),2)
	s HISTradeNo=$p(rtn,$c(2),3)
	s PaySeqNoStr=$p(rtn,$c(2),4)
	if ((+err'=0)&&(+IBPRowID'=0)) {
		s rtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowID,"")	
	}
	q:+err'=0 "-1001^"_err_"^获取银行入参失败."
	s InputXML=""
	d Input.XMLExportToString(.InputXML,"Request")
	s ^TMP("BMCPay","InputXML",$zd(+$h,8),$tr($zt($p($h,",",2),1),":"),BankTradeType)=InputXML
	b ;调用平台组接口
    s BankCardPayObj=##class(DHCENS.BANK.BS.SOAP.CardpaymentSoap).%New()
    s BankOutputXML=BankCardPayObj.Cardpayment(InputXML)
    b ;bbbbbbbbbb
    s ^TMP("BMCPay","OutputXML",$zd(+$h,8),$tr($zt($p($h,",",2),1),":"),BankTradeType)=BankOutputXML
    b ;return

	b ;更新交易明细表及插入交易明细表子表
	s rtn=##class(web.DHCBillBMCLogic).BMCUpdateTradeData(PatType,NewPrtRowid,AbortPrtRowID,BankTradeType,HISTradeNo,BankOutputXML, ExpStr)
	b ;3333
	s err=$p(rtn,"^",1)	;err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)_"^"_$g(ResultContent)
	s IBPRowID=$p(rtn,"^",2)
	s ResultCode=$p(rtn,"^",3)
	s ResultContent=$p(rtn,"^",4)
	if ((+err'=0)&&(ResultCode'="0000")){
		s rtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowID,"")	
	}
	b ;333333
	q:((+err'=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	q:((+err=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	q:((+err'=0)&&(ResultCode="0000")) "-1002^"_err_"^银行交易成功,HIS更新交易记录记录失败,请联系信息中心."
	;
	q err_"^"_ResultCode_"^"_ResultContent
}

/// Creator:Lid
/// CreatDate:2011-10-19
/// Descripiton:获取银医卡支付入参信息
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院),PayModeDr:支付方式
/// 		NewPrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HospDR:医院指针
/// 		ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
/// Output:	
/// Return:
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).BMCPayInput("OP","23298","13","19028535","","04777424","C","949^118^1^16^23298^23298^","")
ClassMethod BMCPayInput(PatType As %String, PayModeDr As %String, NewPrtRowid As %String, AbortPrtRowID As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String, Input As web.DHCEntity.PCA.BankTradeInput)
{
	n (PatType, PayModeDr, NewPrtRowid,AbortPrtRowID, BankCardNO, BankTradeType, ExpStr,Input)
	;s $ZT="ERROR^DHCSSERR" 
	s ^TMPBMCPayInput("BMCPayInput",$zd(+$h,8),$tr($zt($p($h,",",2),1),":"))=PatType_"^"_PayModeDr_"^"_NewPrtRowid_"^"_AbortPrtRowID_"^"_BankCardNO_"^"_BankTradeType_"^"_ExpStr
	s CTLocDR=$p(ExpStr,"^",1)
	s GroupDR=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",3)
	s ClientType=$p(ExpStr,"^",4)
	s TerminalID=$p(ExpStr,"^",5)
	s TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId(TerminalID)
	s ExtUserID=$p(ExpStr,"^",6)
	;
	if (+AbortPrtRowID'=0) {
		;根据发票Rowid取原始的发票Rowid
		s IBPRowID="",IBSSub=""
		if (PatType="OP"){
			s OrgPrtRowID=##class(web.DHCBillBMCLogic).GetOrgPrtRowID(AbortPrtRowID,NewPrtRowid,"")
			;s IBPRowID=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowID,"0"))
			;s IBSSub=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowID,IBPRowID,"C",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
			s IBPRowID=$o(^DHCINVBTPi(0,"S","IPDR",OrgPrtRowID,"0"))
			s IBSSub=$o(^DHCINVBTPi(0,"S","IPDR",OrgPrtRowID,IBPRowID,"C",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
		} elseif (PatType="IP") {
			;住院
			s IBPRowID=""
			s IBSSub=""
		} else {
			;住院押金
    		s PrtStatus=$p(^DHCSFPRINTDETAIL(AbortPrtRowID),"^",8)
    		i PrtStatus=3 d
			.s InitInvNo=$p(^DHCSFPRINTDETAIL(AbortPrtRowID),"^",7)	;原预交金收据号
			.s InitInvDR=$o(^DHCSFPRINTDETAIL(0,"RcptNo",InitInvNo,""))
			.s IBPRowID=##class(web.DHCBillBankLogic).GetDEPOriginalTradeRowID(InitInvDR)
			.s IBSSub=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",InitInvDR,IBPRowID,"IPRcpt",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
			i PrtStatus=2 d
			.s IBPRowID=##class(web.DHCBillBankLogic).GetDEPOriginalTradeRowID(AbortPrtRowID)
			.s IBSSub=$o(^DHCIPRCPTBANKTRADESUB(0,"DepositDr",AbortPrtRowID,IBPRowID,"IPRcpt",""),-1)	;取第一条还是最后一条？(一般情况下收费都是一对一)	
		}
		;根据原始发票Rowid获取原交易信息
		s OrgTradeInfo=##class(web.DHCBillBMCLogic).GetOrgTradeData(PatType,IBPRowID,IBSSub,"")
		s OldBankCardNO=$p(OrgTradeInfo,"^",1)
		s BankCardNO=OldBankCardNO		;退费时,可能不传卡号,所以需要查询原来的交易卡号
		s OldRRN=$p(OrgTradeInfo,"^",2)
		s OldAcctDate=$p(OrgTradeInfo,"^",3)
		s OldHisTradeID=$p(OrgTradeInfo,"^",4)
		s OldPaySeqNo=$p(OrgTradeInfo,"^",5)
	}
	;
	d ..tb()	
	b ;ddddddd
	s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNO)
	b ;222222222
	q:CardInfo="-1" "-1"
	s TradeCode=..GetTradeCodeByBankTradeType(BankTradeType)
	s PatientID=$p(CardInfo,"^",2)
	s PatientNo=$p(CardInfo,"^",3)
	b ;s TelNo=$p(^PAPER(PatientID,"PAT",3),"^",6)		;PAPMI_DVAnumber 电话
	s MobPhone=$p(^PAPER(PatientID,"PER",4),"^",21)   
	s TelNo=$p(^PAPER(PatientID,"PER",1),"^",11)
	s BankCardNo=BankCardNO
	s:NewPrtRowid["^" NewPrtRowid=$TR(NewPrtRowid,"^","|")
	;
	;根据收费员取医院ID
    ;s HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(ExtUserID)
    if HospDR="" Set HospDR=2 
	s HospCode=$p(^CT("HOSP",HospDR),"^",1)
	s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospDR)
	b ;zhho
	s HospDesc=$p(^CT("HOSP",HospDR),"^",2)
    ;
	;收费时,TotalAmt是所有发票的总金额;退费时,TotalAmt是新发票和负票的差额;如果是全退,TotalAmt是负票的金额
	if (PatType="OP"){
		s TotalAmt=##class(web.DHCBillBankLogic).GetOPInvBankCardAmt(NewPrtRowid_"|"_AbortPrtRowID)	
	}elseif(PatType="IP"){
		s TotalAmt=##class(web.DHCBillBankLogic).GetIPInvBankCardAmt(NewPrtRowid_"|"_AbortPrtRowID)
	}else{
		s TotalAmt=##class(web.DHCBillBankLogic).GetIPDepBankCardAmt(NewPrtRowid_"|"_AbortPrtRowID)
	}
	;
	s err=0,IBPRowID=""
	if +err=0 {
		;生成HIS端交易号
		s myExpStr=""_"^"_NewPrtRowid_"|"_AbortPrtRowID
		;b ;0
		s TradeInfo=##class(web.DHCBillBankLogic).SetTradeID(BankCardNO,BankTradeType,HospDR,myExpStr)	
		;b ;返回err
		s err=$p(TradeInfo,"^",1)
		s IBPRowID=$p(TradeInfo,"^",2)
		s TransactionId=$p(TradeInfo,"^",3)
	}
	;
	if (BankTradeType="C"){
		s RevTranFlag=0		;正反交易标志 0-扣费，1-退费
	}else{
		s RevTranFlag=1	
	}
	;
	if +err=0 {
		s HospCode=##class(web.DHCBillBMCLogic).FormatHospiCode(HospDR)
		s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospDR)
		s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
		s InputObj.TradeCode=TradeCode			;交易编码
		s BankCode=##class(web.DHCBillBMCLogic).GetBankCode(BankCardNO,"")
		s InputObj.BankID=BankCode			;银行代码
	    s InputObj.HospitalID=HospCode		;医院编码
	    s InputObj.ClientType=ClientType		;渠道代码
	    s InputObj.TerminalID=TerminalID		;科室代码
	    s InputObj.ExtUserID=ExtUserID		;操作员代码
	    s CTxnDtTm=$zd(+$h,8)_$tr($zt($p($h,",",2),1),":","")
	    ;i BankCode="01" s CTxnDtTm="20120214"_$tr($zt($p($h,",",2),1),":","")  ;给工行写死
	    s InputObj.HISDate=CTxnDtTm				;HIS交易时间 YYYYMMDDHHMMSS
	    s InputObj.HISTradeNo=TransactionId			;HIS唯一流水号
		s InputObj.PayCardNo=BankCardNo				;银联卡号
	    s InputObj.RevTranFlag=RevTranFlag				;正反交易标志 0-扣费，1-退费
	    s InputObj.PatientID=PatientNo		;患者主索引,登记号
	    ;s InputObj.TelNo=TelNo			;手机/电话号码
	    i MobPhone="" s MobPhone=0
	    s InputObj.MobileNo=MobPhone			;手机/电话号码
	    s InputObj.PayAmt=##class(web.DHCBillBankLogic).FormatAmtStr(TotalAmt)					;扣款总金额
	    s PaySeqNoStr=""
	    if (BankTradeType="C") {
			for i=1:1:$l(NewPrtRowid,"|") {
				s myPrtRowID=$p(NewPrtRowid,"|",i)
			    if (+myPrtRowID=0) CONTINUE
			    if (PatType="OP"){
				    s myCharge=##class(web.DHCBillBankLogic).GetOPInvBankCardAmt(myPrtRowID)
				}elseif(PatType="IP"){
					s myCharge=##class(web.DHCBillBankLogic).GetIPInvBankCardAmt(myPrtRowID)
				}else{
					s myCharge=##class(web.DHCBillBankLogic).GetIPDepBankCardAmt(myPrtRowID)
				}
			    s myPaySeqNo=##class(web.DHCBillBankLogic).SetHISPrtInvID(myPrtRowID,HospDR) ;生成支付小条流水号
			    s PayDetailObj=##class(web.DHCEntity.PCA.PayDetail).%New()
			    ;s PayDetailObj.PaySeqNo=myPaySeqNo		;暂不支持一对多
			    s PayDetailObj.PaySeqNo=TransactionId	;暂时按一张发票一次交易,支付小条流水号暂取HIS交易流水号
			    s PayDetailObj.Charge=##class(web.DHCBillBankLogic).FormatAmtStr(myCharge)
			    d InputObj.PayDetails.Insert(PayDetailObj)	;支付明细集合
			    if (PaySeqNoStr=""){
				 	s PaySeqNoStr=myPrtRowID_"^"_myPaySeqNo_"^"_myCharge   
				}else{
					s PaySeqNoStr=PaySeqNoStr_"!"_myPrtRowID_"^"_myPaySeqNo_"^"_myCharge 
				} 	
			}
		}
	    if (BankTradeType="R"){
		 	s InputObj.OrgBankAccDate=OldAcctDate			;原扣费账务日期
		    s InputObj.OrgBankTradeNo=OldRRN			;原银行交易流水号
		    s InputObj.RecAmt=##class(web.DHCBillBankLogic).FormatAmtStr(TotalAmt)			;退款金额（差额）
		    s InputObj.OrgPaySeqNo=OldPaySeqNo		;原支付小票号HIS生成，唯一
		    s InputObj.OrgHISTradeNo=OldHisTradeID				;原HIS流水号
		}
		;
		s Input=InputObj
		s InputXML=""
		d InputObj.XMLExportToString(.InputXML,"Request")   
	    ;b ;InputXML2
	}
    b ;TROLLBACK
    i +err'=0 d
    .TROLLBACK
    e  d
    .d ..tc()
	q err_$c(2)_$g(IBPRowID)_$c(2)_$g(TransactionId)_$c(2)_$g(PaySeqNoStr)
}

/// tangtao
/// 2011-12-25
/// w ##class(web.DHCBillBMCLogic).BMCZZPay("OP","19029649","","C","20120109001001000531","9559980660562552316","2000","974^199^1^25^^22086")
ClassMethod BMCZZPay(PatType As %String, NewPrtRowid As %String, AbortPrtRowid As %String, BankTradeType As %String, HISTradeNo As %String, BankCardNO As %String, TotalAmt As %String, ExpStr As %String)
{
	s ^TMPBMCZZPay("BMCZZPay")=PatType_"^"_NewPrtRowid_"^"_AbortPrtRowid_"^"_BankTradeType_"^"_HISTradeNo_"^"_BankCardNO_"^"_TotalAmt_"^"_ExpStr
	i BankTradeType="C" d
	.;记录发票对应的卡号,避免HIS成功,银行失败时没有交易信息,无法获得发票对应的卡号
	.s prtrtn=##class(web.DHCBillBMCLogic).InsertPrtAndBankNo(NewPrtRowid,BankCardNO)
	s CTLocDR=$p(ExpStr,"^",1)
	s GroupDR=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",3)
	s ClientType=$p(ExpStr,"^",4)
	s TerminalID=$p(ExpStr,"^",5)
	s TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId(TerminalID)   //15位
	s ExtUserID=$p(ExpStr,"^",6)

	s CardInfo=##class(web.UDHCJFBaseCommon).GetPapmiByCardNO(BankCardNO)
	s TradeCode=..GetTradeCodeByBankTradeType(BankTradeType)
	s PatientID=$p(CardInfo,"^",2)
	s PatientNo=$p(CardInfo,"^",3)
	s MobPhone=$p(^PAPER(PatientID,"PER",4),"^",21)   
	s TelNo=$p(^PAPER(PatientID,"PER",1),"^",11)
	s BankCardNo=BankCardNO
	s:NewPrtRowid["^" NewPrtRowid=$TR(NewPrtRowid,"^","|")
	;
	if (BankTradeType="C"){
		s RevTranFlag=0		;正反交易标志 0-扣费，1-退费
	}else{
		s RevTranFlag=1	
	}
	;根据收费员取医院ID
	;

    ;s HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(ExtUserID)

	s HospCode=##class(web.DHCBillBMCLogic).FormatHospiCode(HospDR)
	s ZZInputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
	s ZZInputObj.TradeCode=TradeCode			;交易编码
	s BankCode=##class(web.DHCBillBMCLogic).GetBankCode(BankCardNO,"")
	s ZZInputObj.BankID=BankCode			;银行代码
	s ZZInputObj.HospitalID=HospCode		;医院编码
	s ZZInputObj.ClientType=ClientType		;渠道代码
	s ZZInputObj.TerminalID=TerminalID		;科室代码
	s ZZInputObj.ExtUserID=ExtUserID		;操作员代码
	;s CTxnDtTm=$e($zd(+$h,8),3,8)_$tr($zt($p($h,",",2),1),":","")
	s CTxnDtTm=$zd(+$h,8)_$tr($zt($p($h,",",2),1),":","")
	;i BankCode="01" s CTxnDtTm="20120214"_$tr($zt($p($h,",",2),1),":","")  ;给工行写死
	s ZZInputObj.HISDate=CTxnDtTm				;HIS交易时间 YYYYMMDDHHMMSS
	s ZZInputObj.HISTradeNo=HISTradeNo			;HIS唯一流水号
	s ZZInputObj.PayCardNo=BankCardNO				;银联卡号
	s ZZInputObj.RevTranFlag=RevTranFlag				;正反交易标志 0-扣费，1-退费
	s ZZInputObj.PatientID=PatientNo		;患者主索引,登记号
	;s ZZInputObj.TelNo=TelNo			;手机/电话号码
	i MobPhone="" s MobPhone=0
	s ZZInputObj.MobileNo=MobPhone			;手机/电话号码
	;s ZZInputObj.PayAmt=##class(web.DHCBillBankLogic).FormatAmtStr(TotalAmt)					;扣款总金额
	s ZZInputObj.PayAmt=TotalAmt					;扣款总金额
	s PaySeqNoStr=""
	if (BankTradeType="C") {
		for i=1:1:$l(NewPrtRowid,"|") {
			s myPrtRowID=$p(NewPrtRowid,"|",i)
			if (+myPrtRowID=0) CONTINUE
			if (PatType="OP"){
				s myCharge=##class(web.DHCBillBankLogic).GetOPInvBankCardAmt(myPrtRowID)
			}else{
				s myCharge="0.00"
			}
			s PayDetailObj=##class(web.DHCEntity.PCA.PayDetail).%New()
			s PayDetailObj.PaySeqNo=HISTradeNo	;暂时按一张发票一次交易,支付小条流水号暂取HIS交易流水号
			s PayDetailObj.Charge=##class(web.DHCBillBankLogic).FormatAmtStr(myCharge)
			d ZZInputObj.PayDetails.Insert(PayDetailObj)	;支付明细集合
			/*
			if (PaySeqNoStr=""){
				s PaySeqNoStr=myPrtRowID_"^"_myPaySeqNo_"^"_myCharge   
			}else{
				s PaySeqNoStr=PaySeqNoStr_"!"_myPrtRowID_"^"_myPaySeqNo_"^"_myCharge 
			}
			*/
		}
	}
	s Input=ZZInputObj
	s InputXML=""
	d ZZInputObj.XMLExportToString(.InputXML,"Request")   
	s ^TMP("BMCPay","OutputXML",$zd(+$h,8),$tr($zt($p($h,",",2),1),":"),BankTradeType)=InputXML
    s BankCardPayObj=##class(DHCENS.BANK.BS.SOAP.CardpaymentSoap).%New()
    s BankOutputXML=BankCardPayObj.Cardpayment(InputXML)
    s ^TMP("BMCPay","OutputXML",$zd(+$h,8),$tr($zt($p($h,",",2),1),":"),BankTradeType)=BankOutputXML
    b ;return

	;s BankOutputXML="<Response><TradeCode>3000</TradeCode><BankID>02</BankID><BankDate>"_BankDate_"</BankDate><BankTradeNo>"_BankTradeNo_"</BankTradeNo><ResultCode>0000</ResultCode><ResultContent>交易成功</ResultContent><PayCardNo>"_PayCardNo_"</PayCardNo><BankAccDate>"_BankAccDate_"</BankAccDate><RevTranFlag>0</RevTranFlag><PatientID></PatientID><PayAmt>"_PayAmt_"</PayAmt><HISTradeNo>"_HISTradeNo_"</HISTradeNo></Response>"
	;更新交易明细表及插入交易明细表子表
	s rtn=##class(web.DHCBillBMCLogic).BMCUpdateTradeData(PatType,NewPrtRowid,AbortPrtRowid,BankTradeType,HISTradeNo,BankOutputXML, ExpStr)
	;B ;rtn ttttt9
	s err=$p(rtn,"^",1)	;err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)_"^"_$g(ResultContent)
	s IBPRowID=$p(rtn,"^",2)
	s ResultCode=$p(rtn,"^",3)
	s ResultContent=$p(rtn,"^",4)
	if ((+err'=0)&&(ResultCode'="0000")){
		s rtn=##class(web.DHCBillBankLogic).DeleteIBP(IBPRowID,"")	
	}
	;B ;rtn ttttt10
	q:((+err'=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	q:((+err=0)&&(ResultCode'="0000")) "-1003^"_ResultCode_"^"_ResultContent
	q:((+err'=0)&&(ResultCode="0000")) "-1002^"_err_"^银行交易成功,HIS更新交易记录记录失败,请联系信息中心."
	;
	q err_"^"_IBPRowID_"^"_ResultCode_"^"_ResultContent
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Descripiton:更新银医卡交易信息
/// Input:
/// 		PatType:病人类型(OP:门诊,IP:住院)
/// 		NewPrtRowid:新发票Rowid串,AbortPrtRowid:作废或红冲发票负记录的Rowid
/// 		BankCardNO:银医卡卡号(用于校验)
/// 		BankTradeType:交易类型,HISTradeNo:HIS交易流水号(如果银行返回值中有,可以不传)
/// 		ExpStr:扩展串(科室^安全组^医院^渠道代码^科室代码^操作员代码)
/// Output:	
/// Return:
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).BMCUpdateTradeData("","","")
ClassMethod BMCUpdateTradeData(PatType As %String, NewPrtRowid As %String, AbortPrtRowid As %String, BankTradeType As %String, HISTradeNo As %String, BankOutputXML As %String, ExpStr As %String)
{
	n (PatType,NewPrtRowid,AbortPrtRowid,BankTradeType,HISTradeNo,BankOutputXML, ExpStr)
	;
	;s $ZT="ERROR^DHCSSERR" 
	s i=$i(^TMPBankOutputXML)
	s ^TMPBankOutputXML("CARDCPP","UPDATE",$zd(+$h,3),$zt($p($h,",",2),1),i)=HISTradeNo_"^"_BankOutputXML
	s CTLocDR=$p(ExpStr,"^",1)
	s GroupDR=$p(ExpStr,"^",2)
	s HospDR=$p(ExpStr,"^",3)
	s ClientType=$p(ExpStr,"^",4)
	s TerminalID=$p(ExpStr,"^",5)
	s TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId(TerminalID)   //15位
	s ExtUserID=$p(ExpStr,"^",6)
	;
	s err=0
	i BankOutputXML[$c(10) s BankOutputXML=$tr(BankOutputXML,$c(10))
	b ;解析银行返回值
	s OutputObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankOutputXML)
    b
    s TradeCode=OutputObj.TradeCode	//交易代码
	s BankID=OutputObj.BankID	//银行代码
	s BankDate=OutputObj.BankDate	//银行交易时间YYYYMMDDHHMMSS
	s BankTradeNo=OutputObj.BankTradeNo	//银行唯一流水号
	s ResultCode=OutputObj.ResultCode	//交易结果,错误代码表 0000：成功
	s ResultContent=OutputObj.ResultContent	//对错误/异常的详细描述信息
	s PayCardNo=OutputObj.PayCardNo	//银联卡号
	s BankAccDate=OutputObj.BankAccDate	//银行账务日期
	s RevTranFlag=OutputObj.RevTranFlag	//正反交易标志 1-退费
	s PatientID=OutputObj.PatientID	//患者主索引,登记号
	s PayAmt=OutputObj.PayAmt	//退款金额
	;s HISTradeNo=OutputObj.HISTradeNo	//HIS交易流水号
	s OrgHISTradeNo=OutputObj.OrgHISTradeNo	//原HIS流水号
	s OrgPaySeqNo=OutputObj.OrgPaySeqNo	//原支付小票号 HIS生成，唯一
	
	b ;ttttt3
	d ..tb()
	;
	b ;更新银行交易信息表
	i $d(^DHCINVBTPi(0,"PTN",HISTradeNo))'=0 d
	.s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HISTradeNo,"0"))
	e  d
	.s err="-1007"
	.s IBPRowID=""
	.s ResultCode=""
	.s ResultContent=""
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;b ;ttttt4
	if ((+err=0)&(ResultCode="0000")) {
		s PLIST(2)=ResultCode		;IBPRc
		s PLIST(3)=ResultContent			;IBP_Rc_detail
		s PLIST(5)=+$g(PayAmt)
		s PLIST(8)=BankTradeNo	;IBP_RRN
		s PLIST(15)=$e(BankDate,1,8)
		s PLIST(16)=$e(BankDate,9,$l(BankDate))
		s PLIST(37)=BankAccDate		
		s PLIST(24)=(+PayAmt)/100
		s PLIST(25)=PatType			;IBP_TradeType
		s PLIST(26)=ExtUserID
		s PLIST(32)=ClientType
		s PLIST(40)=BankID
		s PLIST(41)=RevTranFlag
		s PLIST(42)=TradeCode
		s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	
		;b ;ttttt5
	}else {
		s ^TMPBankOutputXML("CARDCPP","FALSE",$zd(+$h,3),$zt($p($h,",",2),1),HISTradeNo)=BankOutputXML
	}
	;
	if ((+err=0)&(ResultCode="0000")) {
		if (PatType="OP"){
			s rtn=##class(web.DHCBillBMCLogic).InsertTradeSub(PatType,HISTradeNo,NewPrtRowid,AbortPrtRowid)
			s err=$p(rtn,"^",1)	
			;b ;ttttt6
		}elseif(PatType="IP"){

		}else{
			s rtn=##class(web.DHCBillBankLogic).UpdateDEPTradeSub(HISTradeNo, NewPrtRowid, AbortPrtRowid)
			s err=$p(rtn,"^",1)
			;b ;ttttt7
		}
	}
	;
	i +err'=0 d
	.TROLLBACK
	e  d
	.d ..tc()
	
	q err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)_"^"_$g(ResultContent)
}

/// Creator:Lid
/// CreatDate:2011-12-07
/// Description:插入门诊子表
ClassMethod InsertTradeSub(PatType, HISTradeNo, NewPrtRowid, AbortPrtRowid)
{
	n (PatType,HISTradeNo,NewPrtRowid,AbortPrtRowid)
	s err=0
	s IBPRowID=$o(^DHCINVBTPi(0,"PTN",HISTradeNo,"0"))
	q:+IBPRowID=0 "-1^"
	;
	;更新银行交易信息表(DHC_InvBankTradePay)
	i +err=0 s err=##class(web.DHCOPBillINVBankPay).SELECT(IBPRowID)
	;
	if +err=0 {
		b ;插子表(DHC_InvBankConSub)
		s PrtRowIDStr=NewPrtRowid_"|"_AbortPrtRowid
		s InvCount=$L(PrtRowIDStr,"|")
		f k=1:1:InvCount d  q:+err'=0
		.k PLIST
		.s PLIST(0)=+IBPRowID
		.s myPrtRowID=+$p(PrtRowIDStr,"|",k)
		.q:+myPrtRowID=0
		.s PLIST(3)=myPrtRowID
		.i k=1 s PLIST(4)="N" 	;对应发票的参照状态(N:新的发票Rowid,A:退费时负记录的Rowid)
		.i k=2 s PLIST(4)="A"
		.s myPayModeDr=""
		.s IPM="0"
		.f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:IPM=""  d
		..s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
		..s PayModeDr=$p(s,"^",1)
		..s HandComFlag=##class(web.DHCBillBankLogic).GetPayModeHardComm(PatType,PayModeDr)
		..q:+HandComFlag=0
		..s myPayModeDr=PayModeDr
		.s IPMDRSub=$o(^DHCINVPRTi(0,"PMDR",myPrtRowID,myPayModeDr,"P","0"))
		.s PLIST(5)=myPrtRowID_"||"_IPMDRSub	;IBS_InvPayMode_DR
		.s PLIST(6)="N"
		.s PLIST(7)=HISTradeNo	
		.s err=##class(web.DHCOPBillINVBankConSub).INSERT()	
	}	
	;
	q err_"^"_IBPRowID
}

/// Creator:Lid
/// CreatDate:2011-12-07
/// Description:插入住院结算子表
ClassMethod InsertIPTradeSub()
{
}

/// Creator:Lid
/// CreatDate:2011-12-07
/// Description:插入押金子表
ClassMethod InsertDEPTradeSub()
{
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Description:获取原交易信息
/// Input:IBPRowID:原交易明细表Rowid,IBSSub:原交易明细表子表Sub,ExpStr:扩展信息("^^^^^^")
/// Output:
/// Return:原银行卡号^原银行交易号^原账务日期^原HIS流水号^原HIS支付小条号
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).GetOrgTradeData("OP","850","1","")
ClassMethod GetOrgTradeData(PatType, IBPRowID, IBSSub, ExpStr)
{
	New (PatType,IBPRowID,IBSSub,ExpStr)
	;
	s IBSRowd=IBPRowID_"||"_IBSSub
	s OldHisTradeID=$p(^DHCINVBTP(IBPRowID),"^",32)
	s OldAcctDate=$p(^DHCINVBTP(IBPRowID),"^",36)	;IBP_AcctDate
	s OldRRN=$p(^DHCINVBTP(IBPRowID),"^",7)
	s OldBankCardNO=$p(^DHCINVBTP(IBPRowID),"^",3)
	if (PatType="OP"){
		s OldPaySeqNo=$p(^DHCINVBTP(IBPRowID,"C",IBSSub),"^",5)
	}elseif(PatType="IP"){
		s OldPaySeqNo=""
	}else{
		s OldPaySeqNo=OldHisTradeID
	}
	;
	s rtn=$g(OldBankCardNO)_"^"_$g(OldRRN)_"^"_$g(OldAcctDate)_"^"_$g(OldHisTradeID)_"^"_$g(OldPaySeqNo)
	;
	q rtn
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Description:根据发票RowID获取最原始的发票rowid
/// Input:AbortPrtRowID:负票Rowid,NewPrtRowid:新发票Rowid,ExpStr:扩展信息("^^^^^^")
/// Output:
/// Return:
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).GetOrgPrtRowID("19028776","19028777","")
ClassMethod GetOrgPrtRowID(AbortPrtRowID, NewPrtRowid, ExpStr)
{
	New (AbortPrtRowID,NewPrtRowid,ExpStr)
	s myPrtRowID=""
	if (+NewPrtRowid=0) {
		b ;新发票Rowid为空,一定上全退,负责为部分退费
		s InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;PRT_initInv_DR
		s myPrtRowID=InitInvDR
	}else{
		s OldInvDR=$p(^DHCINVPRT(NewPrtRowid),"^",29)	;PRT_OldINV_DR
		s myPrtRowID=OldInvDR	
	}
	s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)
	while (+myOldInvDR'=0) {
		s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	;PRT_OldINV_DR
		if (+myOldInvDR'=0){
			s myPrtRowID=myOldInvDR
		}
	}
	q myPrtRowID
}

ClassMethod GetCurrentOrgPrtRowID(AbortPrtRowID As %String, NewPrtRowid As %String, ExpStr, TradType As %String)
{
	s ^TMP("logcpos")=AbortPrtRowID_","_NewPrtRowid_","_TradType
	s IBPTRACE=""
	s OldTradType=""
	i (TradType="R"){
	b ;begin
	s myPrtRowID=""
	if (+NewPrtRowid=0){  ;新发票Rowid为空,一定是全退,否则为部分退费	
	s InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;PRT_initInv_DR 负票对应的正票
	s myPrtRowID=InitInvDR   ;正票
	s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	
	}
	else{						;有新票  部分退
	s OldInvDR=$p(^DHCINVPRT(NewPrtRowid),"^",29)	;PRT_OldINV_DR 新票对应的原正票
	s myPrtRowID=OldInvDR	 ;原正票
	s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)		;正票
	}
	b ;b009	
	i ($d(^DHCINVBTPi(0,"S","IPDR",myPrtRowID))){
	s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",myPrtRowID,"0"))
	i (OldBankTradePayDR'=""){
	s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	i OldHISTradeID="" s OldHISTradeID=OldBankTradePayDR	
	s tmp=$g(^DHCINVBTP(OldHISTradeID))
	s IBPTRACE=$p(tmp,"^",5)
	b ;b01
	}
	}	
	b ;bb0
	while ((+myOldInvDR'=0)&&(IBPTRACE="")){
		s myPrtRowID=myOldInvDR
		s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	;PRT_OldINV_DR
		
		i ($d(^DHCINVBTPi(0,"S","IPDR",myPrtRowID))){
		s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",myPrtRowID,"0"))
		s ss=$g(^DHCINVBTP(OldBankTradePayDR))
		s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
		i (OldHISTradeID=""){
		s OldHISTradeID=OldBankTradePayDR
		}
		s tmp=$g(^DHCINVBTP(OldHISTradeID))
		s IBPTRACE=$p(tmp,"^",5)
		}
		b ;b02
	}
	}else{    ;退费取最原始流水号
	s myPrtRowID=""
	if (+NewPrtRowid=0){  ;新发票Rowid为空,一定是全退,否则为部分退费	
	s InitInvDR=$p(^DHCINVPRT(AbortPrtRowID),"^",13)	;PRT_initInv_DR 负票对应的正票
	s myPrtRowID=InitInvDR   ;正票
	s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	
	}
	else{						;有新票  部分退
	s OldInvDR=$p(^DHCINVPRT(NewPrtRowid),"^",29)	;PRT_OldINV_DR 新票对应的原正票
	s myPrtRowID=OldInvDR	 ;原正票
	s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)		;正票
	}
	b ;bzhho1
	i ($d(^DHCINVBTPi(0,"S","IPDR",myPrtRowID))){
	s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",myPrtRowID,"0"))
	i (OldBankTradePayDR'=""){
	s ss=$g(^DHCINVBTP(OldBankTradePayDR))
	s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
	i OldHISTradeID="" s OldHISTradeID=OldBankTradePayDR	
	s tmp=$g(^DHCINVBTP(OldHISTradeID))
	s OldTradType=$p(tmp,"^",24)
	}
	}
	while ((+myOldInvDR'=0) &&(OldTradType'="C")) {
		s myPrtRowID=myOldInvDR
		s myOldInvDR=$p(^DHCINVPRT(myPrtRowID),"^",29)	;PRT_OldINV_DR		
		i ($d(^DHCINVBTPi(0,"S","IPDR",myPrtRowID))){
		s OldBankTradePayDR=$o(^DHCINVBTPi(0,"S","IPDR",myPrtRowID,"0"))
		i (OldBankTradePayDR'=""){
		s ss=$g(^DHCINVBTP(OldBankTradePayDR))
		s OldHISTradeID=$p(ss,"^",33) ;IBP_HISTradeID原交易流水号
		i OldHISTradeID="" d
		s OldHISTradeID=OldBankTradePayDR
		s tmp=$g(^DHCINVBTP(OldHISTradeID))
		s OldTradType=$p(tmp,"^",24)
		}
		}
	}	
	}
	q myPrtRowID
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Description:根据发票RowID获取医院指针
/// Input:PrtRowID:发票RowID,ExpStr:扩展字段("^^^^^^^")
/// Output:
/// Return:医院ID^医院Code^医院描述
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).GetHospDRByPrtRowID("C")
ClassMethod GetHospDRByPrtRowID(PrtRowID, ExpStr)
{
	n (PrtRowID,ExpStr)
	q:+PrtRowID=0 "^^^^^"
	s PrtUser=$p(^DHCINVPRT(PrtRowID),"^",21)
	s HospitalDr=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(PrtUser)
	s HospCode=$p(^CT("HOSP",HospitalDr),"^",1)
	s HospDesc=$p(^CT("HOSP",HospitalDr),"^",2)
	q $g(HospitalDr)_"^"_$g(HospCode)_"^"_$g(HospDesc)
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Description:根据HIS交易类型获取银行交易代码
/// Input:BankTradeType
/// Output:
/// Return:银行交易代码
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).GetBankCode("9559980660562552316","")
ClassMethod GetBankCode(BankCardNO, ExpStr)
{
	n (BankCardNO,ExpStr)
	s Rowid=""
	s BankCode=""
	f  s Rowid=$o(^DHCCARDi("CF",0,"CardNo",BankCardNO,Rowid)) q:Rowid=""  d
	.q:Rowid=0
	.s BankCode=$p(^DHCCARD("CF",Rowid),"^",20)
	i BankCode="" s BankCode="02"
	q BankCode
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Description:根据HIS交易类型获取银行交易代码
/// Input:BankTradeType
/// Output:
/// Return:银行交易代码
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).GetTradeCodeByBankTradeType("C")
ClassMethod GetTradeCodeByBankTradeType(BankTradeType)
{
	n (BankTradeType)
	q:BankTradeType="C" "4200"	;支付
	q:BankTradeType="R" "4201"	;退费/退货
	q:BankTradeType="V" "4202"	;查证
	q:BankTradeType="S" "4203"	;查询余额
	q 0
}

/// Creator:Lid
/// CreatDate:2011-12-05
/// Description:根据银行交易代码获取HIS交易类型
/// Input:BankTradeType
/// Output:
/// Return:银行交易类型
/// Other:
/// Debug:w ##class(web.DHCBillBMCLogic).GetBankTradeTypeByTradeCode("3001")
ClassMethod GetBankTradeTypeByTradeCode(TradeCode)
{
	n (TradeCode)
	q:TradeCode="4200" "C" 	;支付
	q:TradeCode="4201" "R"	;退费/退货
	q:TradeCode="4202" "V"	;查证
	q:TradeCode="4203" "S"	;查询余额
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

ClassMethod GetClientId(LocId)
{
	i LocId=""
}

/// tangtao
/// 20111218
/// 银医卡消费前查询余额  
/// w ##class(web.DHCBillBMCLogic).SearchBankBalance("2000000","4563511500009554779","S","949^118^1^26^23298^23298^")
/// w ##class(web.DHCBillBMCLogic).SearchBankBalance("200","4563511500009554779","S","949^118^1^26^23298^23298^")
/// w ##class(web.DHCBillBMCLogic).SearchBankBalance("20000000000","4563511500009554779","S","949^118^1^26^23298^23298^")
/// w ##class(web.DHCBillBMCLogic).SearchBankBalance("3000","6282880017850059","S","949^118^1^26^23298^23298^")
ClassMethod SearchBankBalance(PayAmt As %String, BankCardNO As %String, BankTradeType As %String, ExpStr As %String)
{
	n (PayAmt, BankCardNO, BankTradeType, ExpStr)
	d ..tb()
	s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
	s InputObj.TradeCode=##class(web.DHCBillBMCLogic).GetTradeCodeByBankTradeType(BankTradeType)
	s InputObj.BankID=##class(web.DHCBillBMCLogic).GetBankCode(BankCardNO,"")
	s HospDR=$p(ExpStr,"^",3)
	s InputObj.ClientType=$p(ExpStr,"^",4)
	s InputObj.TerminalID=##class(web.DHCBillBMCLogic).FormatTerminalId($p(ExpStr,"^",5))
	s InputObj.ExtUserID=$p(ExpStr,"^",6)
	s ExtUserID=$p(ExpStr,"^",6)
	s HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(ExtUserID)
	s HospCode=##class(web.DHCBillBMCLogic).FormatHospiCode(HospDR)
	s InputObj.HospitalID=HospCode
	;s InputObj.HISDate=$e($zd(+$h,8),3,8)_$tr($zt($p($h,",",2),1),":","")
	s InputObj.HISDate=$zd(+$h,8)_$tr($zt($p($h,",",2),1),":","")
	;i InputObj.BankID="01" s InputObj.HISDate="20120214"_$tr($zt($p($h,",",2),1),":","")  ;给工行写死
	s myExpStr=ExtUserID_"^"_""
	s TradeInfo=##class(web.DHCBillBankLogic).SetTradeID(BankCardNO,BankTradeType,HospDR,myExpStr)
	s err=$p(TradeInfo,"^",1)
	s IBPRowID=$p(TradeInfo,"^",2)
	s TransactionId=$p(TradeInfo,"^",3)
	s InputObj.HISTradeNo=TransactionId
	s InputObj.PayCardNo=BankCardNO
	s InputObj.PayAmt=##class(web.DHCBillBankLogic).FormatAmtStr(PayAmt)
	s ResultCode="0000",ResultContent="",FullPaymentFlag=0,Balance=0
	i +err=0 d
	.s Input=InputObj
	.s InputXML=""
	.d InputObj.XMLExportToString(.InputXML,"Request")   
	.b ;Input
    .s BankCardPayObj=##class(DHCENS.BANK.BS.SOAP.CardpaymentSoap).%New()
    .s BankOutputXML=BankCardPayObj.Cardpayment(InputXML)
    .i BankOutputXML[$c(10) s BankOutputXML=$tr(BankOutputXML,$c(10))
    .s ^TMP("BMCPay",$zd(+$h,8),$tr($zt($p($h,",",2),1),":"),BankTradeType)=BankOutputXML
	.b ;return
	.s OutputObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	.d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankOutputXML)
	.s ResultCode=OutputObj.ResultCode	 //交易结果,错误代码表 0000：成功
	.s ResultContent=OutputObj.ResultContent	//对错误/异常的详细描述信息
	.s FullPaymentFlag=OutputObj.FullPaymentFlag	//足额支付标志（0足额，1可用余额不足）
	.s Balance=OutputObj.Balance	//差额
	.s BankDate=OutputObj.BankDate
	.s BankID=OutputObj.BankID
	.s PayCardNo=OutputObj.PayCardNo
	.s BankTradeNo=OutputObj.BankTradeNo
	
	.k PLIST
	.s PLIST(2)=ResultCode		;IBPRc
	.s PLIST(3)=ResultContent			;IBP_Rc_detail
	.s PLIST(5)=Balance
	.s PLIST(8)=BankTradeNo	;IBP_RRN
	.s PLIST(15)=BankDate
	.s PLIST(40)=BankID		
	.s PLIST(24)=(+Balance)/100
	.s err=##class(web.DHCOPBillINVBankPay).UPDATE(IBPRowID)	

    b ;TROLLBACK
    i +err'=0 d
    .TROLLBACK
    e  d
    .d ..tc()
    ;
	q err_"^"_$g(IBPRowID)_"^"_$g(ResultCode)_"^"_$g(ResultContent)_"^"_FullPaymentFlag_"^"_((+Balance)/100)

	q err
}

ClassMethod FormatHospiCode(HospDR)
{
	i +HospDR=0 d
	.s HospCode="00000"  
	e  d
	.;s HospCode=$p(^CT("HOSP",HospDR),"^",1)		;生成银行入参信息
	.s HospCode=##Class(DHCExternalService.RegInterface.GetRelate).GetOuterHospitalCodeFromHISId(HospDR)
	.s tmp="00000"
	.s HospCode=$e(tmp,1,$l(tmp)-$l(HospCode))_HospCode  ;格式化医院代码
	
	q HospCode
}

/// w ##class(web.DHCBillBMCLogic).FormatTerminalId(19028822)
ClassMethod FormatTerminalId(TerminalId)
{
	s len=$l(TerminalId)
	i len<15 d
	.s tmp="00000000000000"
	.s TerminalId=$e(tmp,1,$l(tmp)-$l(TerminalId))_TerminalId
	.s TerminalId="1"_TerminalId
	q TerminalId
}

/// 跟据门诊发票rowid判断是否为银医卡支付
/// w ##class(web.DHCBillBMCLogic).JudgePayMode(19028822)
/// 空不是银医卡支付，其它为是银医卡支付
ClassMethod JudgePayMode(myPrtRowID)
{
	q:myPrtRowID="" ""
	q:$d(^DHCINVPRT(myPrtRowID))=0
	s IPM="0"
	s myPayModeDr=""
	f  s IPM=$o(^DHCINVPRT(myPrtRowID,"P",IPM)) q:IPM=""  d
	.s s=$g(^DHCINVPRT(myPrtRowID,"P",IPM))
	.s PayModeDr=$p(s,"^",1)
	.b   //PayModeDr
	.s HandComFlag=##class(web.DHCBillBankLogic).GetPayModeHardComm("OP",PayModeDr)
	.q:+HandComFlag=0
	.s myPayModeDr=PayModeDr
	
	q myPayModeDr
}

ClassMethod GetOrgTradeInfo(PrtRowid)
{
	q:PrtRowid="" ""
	s IBPRowid="",RtnInfo=""
	f  s IBPRowid=$o(^DHCINVBTPi(0,"S","IPDR",PrtRowid,IBPRowid)) q:IBPRowid=""  d
	.q:IBPRowid=0
	.s HISTradeNo=$p(^DHCINVBTP(IBPRowid),"^",32)
	.s BankCardNo=$p(^DHCINVBTP(IBPRowid),"^",3)
	.s HospDr=$p(^DHCINVBTP(IBPRowid),"^",28)
	.s BankId=$p(^DHCINVBTP(IBPRowid),"^",27)
	.s ClientType=$p(^DHCINVBTP(IBPRowid),"^",31)
	.s RtnInfo=HISTradeNo_"^"_BankCardNo_"^"_HospDr_"^"_BankId_"^"_ClientType
	
	q RtnInfo
}

/// tangtao
/// 2011-12-23
/// 查证交易
/// w ##class(web.DHCBillBMCLogic).Verification(^TMP("BMCPay","InputXML",20111223,112728,"R"))
/// w ##class(web.DHCBillBMCLogic).Verification(^TMP("BMCPay","InputXML",20120110,144422,"R"))
ClassMethod Verification(Input)
{
	s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
	s TradeCode="4202"			;交易编码
	s InputTradeCode=InputObj.TradeCode
	s BankCode=InputObj.BankID 		;银行代码
	s HospCode=InputObj.HospitalID		;医院编码
	s ClientType=InputObj.ClientType		;渠道代码
	s TerminalID=InputObj.TerminalID		;科室代码
	s ExtUserID=InputObj.ExtUserID		;操作员代码
	s TransactionId=InputObj.HISTradeNo			;HIS唯一流水号
	s BankCardNo=InputObj.PayCardNo				;银联卡号
	s PatientNo=InputObj.PatientID		;患者主索引,登记号
	;s TelNo=InputObj.TelNo			;手机/电话号码
	s TelNo=InputObj.MobileNo			;手机/电话号码
	s PayAmt=InputObj.PayAmt
	
	s myExpStr=ExtUserID_"^"
	s TradeInfo=##class(web.DHCBillBankLogic).SetTradeID(BankCardNo,"V","1",myExpStr)
	s HISTradeNo=$p(TradeInfo,"^",3)
	s OutputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
	s OutputObj.TradeCode=TradeCode			;交易编码
	s OutputObj.BankID=BankCode			;银行代码
	s OutputObj.HospitalID=HospCode		;医院编码
	s OutputObj.ClientType=ClientType		;渠道代码
	s OutputObj.TerminalID=TerminalID		;科室代码
	s OutputObj.ExtUserID=ExtUserID		;操作员代码
	s CTxnDtTm=$zd(+$h,8)_$tr($zt($p($h,",",2),1),":","")
	s OutputObj.HISDate=CTxnDtTm				;HIS交易时间 YYYYMMDDHHMMSS
	s OutputObj.HISTradeNo=HISTradeNo				
	s OutputObj.PayCardNo=BankCardNo				;银联卡号
	s OutputObj.PatientID=PatientNo		;患者主索引,登记号
	;s OutputObj.TelNo=TelNo			;手机/电话号码
	s OutputObj.MobileNo=TelNo			;手机/电话号码
	s OutputObj.OrgHISTradeNo=TransactionId			;查证HIS唯一流水号
	s OutputObj.OrgPayAmt=PayAmt			;查证总金额
	i InputTradeCode="4200" d
	.s OutputObj.RevTranFlag=0			;收款
	i InputTradeCode="4201" d
	.s OutputObj.RevTranFlag=1			;退款
	s InputXML=""
	d OutputObj.XMLExportToString(.InputXML,"Request")   
    s BankCardPayObj=##class(DHCENS.BANK.BS.SOAP.CardpaymentSoap).%New()
    s BankOutputXML=BankCardPayObj.Cardpayment(InputXML)

	q BankOutputXML
}

ClassMethod BMCAccert(Input)
{
	; "<Request><TradeCode>5000</TradeCode><BankID>02</BankCode><HospitalID>010001</HospitalID><ClientType>12</ClientType><TerminalID>1400001</TerminalID><ExtUserID>0820082L</ExtUserID><BankDate>20111021122111</BankDate><BankTradeNo>1</BankTradeNo></Request>"

	s InputObj=##class(web.DHCEntity.PCA.BankTradeInput).%New()
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",Input)
	s TraeCode=InputObj.TraeCode			;交易编码
	s BankCode=InputObj.BankID 		;银行代码
	s HospCode=InputObj.HospitalID		;医院编码
	s ClientType=InputObj.ClientType		;渠道代码
	s TerminalID=InputObj.TerminalID		;科室代码
	s ExtUserID=InputObj.ExtUserID		;操作员代码
	s BankDate=InputObj.BankDate			;银行交易日期
	s BankTradeNo=InputObj.BankTradeNo		;银行交易号
	
	
	; "<Response><TradeCode>3001</TradeCode><HospitalID>010001</HospitalID><HISDate>20111021122111</HISDate><HISTradeNo>1</HISTradeNo><ResultCode>0000</ResultCode><ResultContent>交易成功</ResultContent></Response>"
}

ClassMethod test12321()
{
	s BankOutputXML="<?xml version=1.0 encoding=GBK?><Response><TradeCode>4200</TradeCode><BankDate>20111231163704</BankDate><BankID>01</BankID><BankTradeNo>10011112311636001440</BankTradeNo><ResultCode>0000</ResultCode><ResultContent>成功</ResultContent><ResultStat>0</ResultStat><PayCardNo>6282880017850059</PayCardNo><BankAccDate>20120201</BankAccDate><RevTranFlag>0</RevTranFlag><PatientID>13775055</PatientID><PayAmt>00000000000000029344</PayAmt></Response>"
	;s BankOutputXML="<Response><TradeCode>4200</TradeCode><BankDate>20111231163704</BankDate><BankID>01</BankID><BankTradeNo>10011112311636001440</BankTradeNo><ResultCode>0000</ResultCode><ResultContent>成功</ResultContent><ResultStat>0</ResultStat><PayCardNo>6282880017850059</PayCardNo><BankAccDate>20120201</BankAccDate><RevTranFlag>0</RevTranFlag><PatientID>13775055</PatientID><PayAmt>00000000000000029344</PayAmt></Response>"
	s str=$p(BankOutputXML,"<Response>",1)
	s BankOutputXML=$p(BankOutputXML,str,2)
	s OutputObj=##class(web.DHCEntity.PCA.BankTradeOutput).%New()
	d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankOutputXML)
    s TradeCode=OutputObj.TradeCode	//交易代码
	s BankID=OutputObj.BankID	//银行代码
	s BankDate=OutputObj.BankDate	//银行交易时间YYYYMMDDHHMMSS
	s BankTradeNo=OutputObj.BankTradeNo	//银行唯一流水号
	s ResultCode=OutputObj.ResultCode	//交易结果,错误代码表 0000：成功
	s ResultContent=OutputObj.ResultContent	//对错误/异常的详细描述信息
	s PayCardNo=OutputObj.PayCardNo	//银联卡号
	s BankAccDate=OutputObj.BankAccDate	//银行账务日期
	s RevTranFlag=OutputObj.RevTranFlag	//正反交易标志 1-退费
	s PatientID=OutputObj.PatientID	//患者主索引,登记号
	s PayAmt=OutputObj.PayAmt	//退款金额
	;s HISTradeNo=OutputObj.HISTradeNo	//HIS交易流水号
	s OrgHISTradeNo=OutputObj.OrgHISTradeNo	//原HIS流水号
	s OrgPaySeqNo=OutputObj.OrgPaySeqNo	//原支付小票号 HIS生成，唯一
	b
	q 0
}

/// w ##class(web.DHCBillBMCLogic).InsertPrtAndBankNo("20021924^20022014","5359100660002001")
ClassMethod InsertPrtAndBankNo(PrtStr, BankNo)
{
	q:PrtStr="" "-1"
	q:BankNo="" "-2"
	s PrtStrLen=$l(PrtStr,"^")
	f i=1:1:PrtStrLen d
	.s PrtRowid=$p(PrtStr,"^",i)
	.q:PrtRowid=""
	.q:PrtRowid=0
	.q:$d(PrtRowid)=0
	.s ^TMPInsertPrtAndBankNo(PrtRowid)=BankNo

	q 0
}

}
