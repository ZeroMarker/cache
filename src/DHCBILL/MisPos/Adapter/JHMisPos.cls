/// Creator:wangjian
/// CreatDate:2018-12-12
/// 中行聚合支付数据处理
Class DHCBILL.MisPos.Adapter.JHMisPos Extends BILL.COM.Abstract
{

/// w ##class(DHCBILL.MisPos.Adapter.JHMisPos).GetMisPosInput(4)
ClassMethod GetMisPosInput(ETPRowID, ExpStr = "")
{
	set Rtn=""
	quit:(ETPRowID="") Rtn
	set BankTradeTypde=$p(^DHCBILLETP(ETPRowID),"^",26)
	set OldETPRowID=$p(^DHCBILLETP(ETPRowID),"^",20)
	
	//1[长度:10]柜台号
	set TellerNo=""
	set TellerNo=##class(BILL.Util.Tools).FormatNO(TellerNo, 10)
	
	//2[长度:10]收款员号
	set UserCode=$p(^DHCBILLETP(ETPRowID),"^",24)
	set UserCode=##class(BILL.Util.Tools).FormatNO(UserCode, 10)
	
	//3[长度:1]交易类型
	set BankTradeCode=..TransBankTradeTypde(BankTradeTypde)
	
	//4[长度:12]交易金额,单位分
	set TradeAmt=$p(^DHCBILLETP(ETPRowID),"^",23)
	set TradeAmt=TradeAmt*100									
	set TradeAmt=##class(BILL.Util.Tools).FormatNO(TradeAmt, 12)
	
	//5[长度:6]支付方式
	set Paymode=$p(^DHCBILLETP(ETPRowID),"^",45)
	set PaymodeCode=$p(^CT("CTPM",Paymode),"^",1)
	set PaymodeCode=$case(PaymodeCode,"JHALI":"00502","JHWECHAT":"00501",:"001") 
	set PaymodeCode=##class(BILL.Util.Tools).FormatNO(PaymodeCode, 6, " ", 1)
	
	//6[长度:6]票据号
	set InvoiceNo=""
	if (OldETPRowID'="") {
		set InvoiceNo=$p(^DHCBILLETP(OldETPRowID),"^",6)
	}
	set InvoiceNo=##class(BILL.Util.Tools).FormatNO(InvoiceNo, 6, " ", 1)
	
	//7[长度:6]授权号
	set AuthNo=""
	if ((OldETPRowID'="")&&(AuthNo="")) {
		set AuthNo=$p(^DHCBILLETP(OldETPRowID),"^",8)
	}
	set AuthNo=##class(BILL.Util.Tools).FormatNO(AuthNo, 6, " ", 1)
	
	//8[长度:6]凭证号
	set VoucherNo=$p(^DHCBILLETP(ETPRowID),"^",37)
	if ((OldETPRowID'="")&&(VoucherNo="")) {
		set VoucherNo=$p(^DHCBILLETP(OldETPRowID),"^",5)
	}
	set VoucherNo=##class(BILL.Util.Tools).FormatNO(VoucherNo, 6, " ", 1)	
	
	//9[长度:14]原交易日期时间
	set OldTradeDateT=""
	if (OldETPRowID'="") {
		set OldTradeDate=$p(^DHCBILLETP(OldETPRowID),"^",14)
		set OldTradeTime=$p(^DHCBILLETP(OldETPRowID),"^",15)
		if (OldTradeDate'="") set OldTradeDate=$zd(OldTradeDate,8)
		if (OldTradeTime'="") set OldTradeTime=$tr($zt(OldTradeTime,1),":","")
		set OldTradeDateT=OldTradeDate_OldTradeTime
	}
	set OldTradeDateT=##class(BILL.Util.Tools).FormatNO(OldTradeDateT, 14, " ", 1)	
	
	//10[长度:12]参考号
	set ExtRRN=$p(^DHCBILLETP(ETPRowID),"^",38)
	if ((OldETPRowID'="")&&(ExtRRN="")) {
		set ExtRRN=$p(^DHCBILLETP(OldETPRowID),"^",7)
	}
	set ExtRRN=##class(BILL.Util.Tools).FormatNO(ExtRRN, 12, " ", 1)				
	
	//11 [长度:30]扫码信息
	set ScanPayCode=""
	set ScanPayCode=##class(BILL.Util.Tools).FormatNO(ScanPayCode, 30, " ", 1)
	//12[长度:40]扫码支付订单号
	set OrderNo=""
	if ((OldETPRowID'="")&&(OrderNo="")) {
		set OrderNo=$p(^DHCBILLETP(OldETPRowID),"^",47)
	}
	set OrderNo=##class(BILL.Util.Tools).FormatNO(OrderNo, 40, " ", 1)
	
	//按顺序拼接
	set Rtn=TellerNo_UserCode_BankTradeCode_TradeAmt_PaymodeCode	//1-5
	set Rtn=Rtn_InvoiceNo_AuthNo_VoucherNo_OldTradeDateT_ExtRRN_ScanPayCode	//6-10
	set Rtn=Rtn_OrderNo

	quit Rtn
}

/// Creator：wangjian
/// CreatDate: 转换银行交易类型
ClassMethod TransBankTradeTypde(BankTradeTypde)
{
	if (BankTradeTypde="C"){
		//收费
		set BankTradeTypde="C"
	}elseif(BankTradeTypde="D"){
		//撤销
		set BankTradeTypde="D"
	}elseif(BankTradeTypde="T"){
		//退货
		set BankTradeTypde="R"
	}elseif(BankTradeTypde="V"){
		//查证(银行卡为查询余额交易，微信、支付宝为查询交易)
		set BankTradeTypde="I"
	}elseif(BankTradeTypde="Q"){
		//签到
		set BankTradeTypde="N"
	}elseif(BankTradeTypde="H"){
		//结算交易
		set BankTradeTypde="S"
	}elseif(BankTradeTypde="P"){
		//重打补打
		set BankTradeTypde="P"
	}elseif(BankTradeTypde="O"){
		//结帐、交易一览和重打票据
		set BankTradeTypde="0"
	}else{
		set BankTradeTypde="I"
	}
	
	quit BankTradeTypde
}

ClassMethod GetOtherServicePara(BankTradeTypde As %String, TerminalNo As %String, ExpStr As %String)
{
	//1[长度:10]柜台号
	set TellerNo=""
	set TellerNo=##class(BILL.Util.Tools).FormatNO(TellerNo, 10)
	
	//2[长度:10]收款员号
	set UserCode=""
	set UserCode=##class(BILL.Util.Tools).FormatNO(UserCode, 10)
	
	//3[长度:1]交易类型
	set BankTradeCode=..TransBankTradeTypde(BankTradeTypde)
	
	//4[长度:12]交易金额,单位分
	set TradeAmt=0
	set TradeAmt=##class(BILL.Util.Tools).FormatNO(TradeAmt, 12)
	
	//5[长度:6]支付方式
	set Paymode=""
	set PaymodeCode=""
	set PaymodeCode=$case(PaymodeCode,"JHALI":"00502","JHWECHAT":"00501",:"001") 
	set PaymodeCode=##class(BILL.Util.Tools).FormatNO(PaymodeCode, 6, " ", 1)
	
	//6[长度:6]票据号
	set InvoiceNo=""
	set InvoiceNo=##class(BILL.Util.Tools).FormatNO(InvoiceNo, 6, " ", 1)
	
	//7[长度:6]授权号
	set AuthNo=""
	set AuthNo=##class(BILL.Util.Tools).FormatNO(AuthNo, 6, " ", 1)
	
	//8[长度:6]凭证号
	set VoucherNo=""
	set VoucherNo=##class(BILL.Util.Tools).FormatNO(VoucherNo, 6, " ", 1)	
	
	//9[长度:14]原交易日期时间
	set OldTradeDateT=""
	set OldTradeDateT=##class(BILL.Util.Tools).FormatNO(OldTradeDateT, 14, " ", 1)	
	
	//10[长度:12]参考号
	set ExtRRN=""
	set ExtRRN=##class(BILL.Util.Tools).FormatNO(ExtRRN, 12)
	
	//按顺序拼接
	set Rtn=TellerNo_UserCode_BankTradeCode_TradeAmt_PaymodeCode   //1-5
	set Rtn=Rtn_InvoiceNo_AuthNo_OldTradeDateT_ExtRRN	           //6-10

	quit Rtn
}

/// Input: bankData pos交易返回的数据串
/// Debug: w ##class(DHCBILL.MisPos.Adapter.JHMisPos).GetOutBankData("23","00622400******1268   C000000000001404 001         AA33441635572018121816355788991122445510432017011888845645321")
ClassMethod GetOutBankData(ETPRowID, bankData)
{
	set $zt="ERROR"
	
	set ReslutCode=-1004		  //默认交易失败
	set ReslutDesc=""
	
	set OutputObj=##class(DHCBILL.Common.DHCBILLCommon).GetClsPropJsonO("User.DHCBillExtTradePay")
	
	set PayRc=$e(bankData,1,2)  //相应码
	if (" 00 16 "[(" "_PayRc_" ")) {
		set ReslutCode=0	//成功
		set PayRc="00"
		set PayRcDesc="交易成功"    //交易结果描述
		set ReslutDesc=PayRcDesc
		set PayAccountNo=$tr($e(bankData,3,21)," ","")		//支付卡号19
		set PayTradeType=$e(bankData,22) 		 //交易类型标志1
		set PayAmt=$e(bankData,23,34) 			 //金额12
		set PayAmt=PayAmt/100
		set ExtCardType=$tr($e(bankData,35,38)," ","")   //银行卡类型(发卡行代码)4
		set PaymodeCode=$tr($e(bankData,39,44)," ","")	 //支付方式 6
		set PayInvoiceNo=$tr($e(bankData,45,50)," ","")  //票据号 6

		set PayAuthNo=$tr($e(bankData,51,56)," ","")		//授权号6
		set PayVoucherNo=$tr($e(bankData,57,62)," ","")		//凭证号6
		set PayDate=$tr($e(bankData,63,70)," ","")			//交易日期14-8
		set PayTime=$tr($e(bankData,71,76)," ","")			//交易时间14-6
		set PayRRN=$tr($e(bankData,77,88)," ","")			//参考号12
		set PayMchNo=$tr($e(bankData,89,103)," ","")		//商户号15
		set TerminalNo=$tr($e(bankData,104,111)," ","")		//银行的终端号8
		set OutPayNo=$tr($e(bankData,112,151)," ","")
		
		if (+PayDate'=0) {
			set PayDate=$zdh(PayDate,8)
		}
		if (+PayTime'=0) {
			set PayTime=$e(PayTime,1,2)_":"_$e(PayTime,3,4)_":"_$e(PayTime,5,6)
			set PayTime=$zth(PayTime,1)
		}
		if ((PayRRN="")&&(OutPayNo'="")) set PayRRN=OutPayNo //扫码支付用订单号提参考号 对账用
		set OutputObj.ETPRc=PayRc			        //ETP_Rc 交易标志
		set OutputObj.ETPRcDetail=PayRcDesc 		//ETP_Rc_Detail 交易描述
		set OutputObj.ETPPan=PayAccountNo	 	    //ETP_Pan 卡号,账户号
		set OutputObj.ETPExtAmt=PayAmt 			    //ETP_Ext_Amt 第三方交易金额
		set OutputObj.ETPVoucherNo=PayVoucherNo 	//ETP_Voucher_No POS凭证号
		set OutputObj.ETPInvoiceNo=PayInvoiceNo 	//ETP_Invoice_No 单据号（POS流水号）
		set OutputObj.ETPRRN=PayRRN	 		        //ETP_RRN 交易唯一号（POS参考号）
		set OutputObj.ETPAuthNo=PayAuthNo 		    //ETP_Auth_No POS授权号
		set OutputObj.ETPTerminalNo=TerminalNo 		//ETP_Terminal_No 终端号
		set OutputObj.ETPMerchNo=PayMchNo 		    //ETP_Merch_No POS商户号
		set OutputObj.ETPExtDate=PayDate 		    //ETP_Ext_Date 第三方交易日期
		set OutputObj.ETPExtTime=PayTime 		    //ETP_Ext_Time 第三方交易时间
		set OutputObj.ETPExtCardType=ExtCardType		//ETP_ExtCardType 银行卡类型（POS开户行）
		set OutputObj.ETPExtTradeChannel=PaymodeCode		//ETP_ExtTradeChannel 第三方交易渠道（app的多种支付渠道）
		set OutputObj.ETPExtTradeNo=OutPayNo 		//ETP_ExtTradeNo 第三方订单号
		set OutputObj.ETPExtOutString=bankData
	}else {
		set ReslutCode=PayRc
		set ReslutDesc="交易失败"   //交易结果描述
		set OutputObj.ETPExtOutString=bankData
	}
	
	//更新交易信息
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)
	set rtn=$p(rtnValue,"^",1)
	if (ReslutCode=0) {
		set ReslutDesc=ReslutDesc_$s((+rtn=0):"",1:("，更新交易表失败："_rtnValue))
	}
	
	quit ReslutCode_"^"_+rtn_"^"_ReslutDesc

ERROR
	quit ..AppException()
}

ClassMethod VerifyBankData(BankInput As %String, BankData As %String) As %String
{
	set VerifyInfo=BankInput, VerifyFlag="2"  //默认失败 返回原入参重新调用
	set PayRc=$e(BankData,1,2)
	set OutPaymode=$tr($e(BankInput,34,39)," ","")
	
	if (OutPaymode="001") {
		//银行卡
		if (PayRc="00") {
		 	set VerifyFlag="0"
		 	set VerifyInfo=""
		}
	}else{
		//扫码
		if (" 00 16 "[(" "_PayRc_" ")) {
		 	set VerifyFlag="0"
		 	set VerifyInfo=""
		}elseif(" 08 18 19 DK "[(" "_PayRc_" ")) {
			set VerifyFlag="1"
			set InputLen=$l(BankInput)
		 	set VerifyInfo=$e(BankInput,1,20)_"I"_$e(BankInput,22,InputLen)
		}else {
			set VerifyInfo=BankInput
			set VerifyFlag="2"
		}
	} 
	quit VerifyFlag_"|"_VerifyInfo
}

}
