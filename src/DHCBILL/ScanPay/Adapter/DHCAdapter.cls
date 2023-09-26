Import SQLUser

Class DHCBILL.ScanPay.Adapter.DHCAdapter Extends BILL.COM.Abstract
{

/// 调用第三方生成订单标准
Parameter CreateFlag = "Y";

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW
/// Descripiton: 生成扫码付订单
/// Input:  TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,CANCEL:冲销)
/// 		PayModeDr:支付方式
/// 		TradeAmt:交易金额
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))
/// Return:	是否成功^错误描述
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).CreateScanCodePay("OP",30,300,"12^23^2^34^1^2^192017#^^C")
ClassMethod CreateScanCodePay(ETPRowID As %String, ScanCode As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	
	set HospDR=$p(ExpStr,"^",3)
	set Guser=$p(ExpStr,"^",4)
	set PatId=$p(ExpStr,"^",5)
	set Adm=$p(ExpStr,"^",6)
	set PrtStr=$p(ExpStr,"^",7)

	set PayChannel=..PayChannelByScanCode(ScanCode)
	quit:(PayChannel="") -1_"^"_"支付渠道为空"
	set PayMCode=..GetPayMCodeByPayChannel(PayChannel)
	quit:(PayMCode="") -1_"^"_"支付渠道对应支付方式代码为空"
	set PayModeID=##class(DHCBILL.Common.DHCBILLCommon).GetPayMDrByPayMCode(PayMCode)
	quit:(PayModeID="") -1_"^"_"支付方式代码不存在"
	
	//更新订单表中交易渠道、支付方式、支付渠道
    &SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_TradeChannel = 'DHCC', ETP_PayMode = :PayModeID, ETP_ExtTradeChannel = :PayChannel
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	
	set CreateFlag=..#CreateFlag    //是否改到支付方式扩展表配置
	//if (TradeFlag="D") set CreateFlag="N"    //退费不需调用接口  如需注释
	//调用第三方接口生成订单
	if (CreateFlag="Y") {
	    set rtnValue=..InvokingWebService(ETPRowID, ScanCode, "Create")
	    set OutputObj=..FormatScanOutput(rtnValue, "Create")
		set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)   //保存交易数据
		//if (OutputObj.ETPExtTradeNo="") quit -1_"^"_"支付平台订单号为空"
		if (OutputObj.ETPRc'="00") quit -1_"^"_OutputObj.ETPRcDetail
		quit rtnValue
	}
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW 不管交易是否成功都保存
/// Descripiton: 提交扫码付支付
/// Input:  ETPRowID:订单ID, ScanCode:病人手机支付码
/// Return:	订单支付状态^his保存返回码
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).CommitScanCodePay(38,"11265465465")
ClassMethod CommitScanCodePay(ETPRowID As %String, ScanCode As %String, ExpStr As %String = "")
{
    set rtnValue=..InvokingWebService(ETPRowID, ScanCode, "Commit")
    set OutputObj=..FormatScanOutput(rtnValue, "Commit")
    
    //保存数据交易数据
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)
	
    if (OutputObj.ETPRc'="00")  quit OutputObj.ETPRc_"^"_OutputObj.ETPRcDetail   //交易失败时，将失败消息返回
    
    quit OutputObj.ETPRc_"^"_rtnValue
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW 不管交易是否成功都保存
/// Descripiton: 查询订单支付状态
/// Input:  ETPRowID:订单ID
/// 		ScanCode:手机支付码
/// Return: 
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).VerifyScanCodePayStatus(245,"")
ClassMethod VerifyScanCodePayStatus(ETPRowID As %String, ScanCode As %String)
{
    set rtnValue=..InvokingWebService(ETPRowID, ScanCode, "Query")    
    set OutputObj=..FormatScanOutput(rtnValue, "Query")

	//保存交易数据
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)
	
	if (OutputObj.ETPRc'="00")  quit OutputObj.ETPRc_"^"_OutputObj.ETPRcDetail  //交易失败时，将失败消息返回
	
	quit OutputObj.ETPRc_"^"_rtnValue
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW 不管交易是否成功都保存
/// Descripiton: 关闭订单(轮询操作交给服务器,关闭也给服务器)
/// Input: ETPRowID:订单ID, ExpStr:
/// Return: 
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).CancelBarcodePay("")
ClassMethod CancelScanCodePay(ETPRowID As %String, ExpStr As %String = "") As %String
{
	set rtnValue=..InvokingWebService(ETPRowID, "", "Cancel")
    set OutputObj=..FormatScanOutput(rtnValue, "Cancel")
    
    //保存数据交易数据
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)
	
    if (OutputObj.ETPRc'="00")  quit OutputObj.ETPRc_"^"_OutputObj.ETPRcDetail   //交易失败时，将失败消息返回
    
    quit OutputObj.ETPRc_"^"_rtnValue
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW 不管交易是否成功都保存
/// Descripiton: 退费接口
/// Input: ETPRowID:冲销订单ID(冲销必传项), ExpStr:
/// Return: 
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).RefundScanCodePay()
ClassMethod RefundScanCodePay(ETPRowID As %String, ExpStr As %String = "")
{
    set rtnValue=..InvokingWebService(ETPRowID, "", "Refund")
    set OutputObj=..FormatScanOutput(rtnValue, "Refund")
    
    set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).SaveExtPayInfo(ETPRowID, OutputObj)
    
    if (OutputObj.ETPRc'="00")  quit OutputObj.ETPRc_"^"_OutputObj.ETPRcDetail  //交易失败时，将失败消息返回
    
    quit OutputObj.ETPRc_"^"_rtnValue
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW
/// Descripiton: 调用支付平台接口
/// Input: ETPRowID:订单表RowID, ScanCode:支付码, FormatType:
/// Return: 
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).InvokingWebService(73, "111", "Create")
ClassMethod InvokingWebService(ETPRowID As %String, ScanCode As %String, FormatType As %String)
{
	set $zt="ERROR"
	
	set ScanOutput=""
	
	set ETPData=$g(^DHCBILLETP(ETPRowID))
	
	set ETPHISOldTradeDR=$p(ETPData,"^",20)  //ETP_OldTradePay_DR
	set UserDR=$p(ETPData,"^",24)
	set PatientId=$p(ETPData,"^",40)
	set HisTradeNo=$p(ETPData,"^",32)
	set TradeAmt=$p(ETPData,"^",23)
	set TradeAmt=$fn(TradeAmt,"N")
	set TradeType=$p(ETPData,"^",25)
	set PayType=$p(ETPData,"^",26)      //C:收, T:退
	set PayMode=$p(ETPData,"^",45)
	set ExtTradeNo=$p(ETPData,"^",47)      //ETP_ExtTradeNo
	set HisPrtStr=$p(ETPData,"^",48)       //ETP_HisPrtStr
	set SinglePrtRowID=$p(HisPrtStr,"!",1)
	
	set PayChannel=..PayChannelByScanCode(ScanCode)
	set PayModeCode=..GetPayMCodeByPayChannel(PayChannel)  //支付方式代码
	
	set OrderType=..GetOrderTypeByBizType(TradeType)
	
	set OrderTypeDesc=##class(DHCBILL.Common.DHCBILLCommon).GetOrderTypeDescByBizType(TradeType)
	
	if (FormatType="Create") {
		//创建订单
		//do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID, FormatType, $lb(HisTradeNo, PatientId, OrderType, PayModeCode, TradeAmt), "Input")
		set ScanOutput=##class(iH.Pay.PublicPay).BarcodePayCreateOrderNo(HisTradeNo, PatientId, OrderType, PayModeCode, TradeAmt)
	}
	if (FormatType="Commit") {
		//扣费
		//do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID, FormatType, $lb(HisTradeNo, TradeAmt, ScanCode, PatientId, UserDR, "窗口条码支付"_OrderTypeDesc, PayModeCode, "", OrderType, ExtTradeNo), "Input")
		set ScanOutput=##class(iH.Pay.PublicPay).BarcodePay(HisTradeNo, TradeAmt, ScanCode, PatientId, UserDR, "窗口条码支付"_OrderTypeDesc, PayModeCode, "", OrderType, ExtTradeNo)
	}
	if (FormatType="Query") {
		//获取支付平台订单状态
		//do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID, FormatType, $lb(ExtTradeNo, HisTradeNo), "Input")
		set ScanOutput=##class(iH.Pay.PublicPay).BarcodePayQuery(ExtTradeNo, HisTradeNo)
	}
	if (FormatType="Cancel") {
		//撤销订单
		//do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID, FormatType, $lb(ExtTradeNo, "cancel"), "Input")
    	set ScanOutput=##class(iH.Pay.PublicPay).BarcodePayCancel(ExtTradeNo, "cancel")
	}
	if (FormatType="Refund") {
		if (" D T "[(" "_PayType_" ")) {
			set RefPrtRowID=SinglePrtRowID
			set OldETPData=$g(^DHCBILLETP(ETPHISOldTradeDR))
			set ETPRRN=$p(OldETPData,"^",7)
			set Memo="退费"
			set ExpStr=RefPrtRowID    //"^"分割, 第一个是退费发票id[必传,可以控制重复退费]
			//do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID, FormatType, $lb(ETPRRN, TradeAmt, HisTradeNo, Memo, PatientId, UserDR, ExpStr), "Input")
			set ScanOutput=##class(iH.Pay.PublicPay).ReturnPayForHis(ETPRRN, TradeAmt, HisTradeNo, Memo, PatientId, UserDR, ExpStr)
		}else{
			set ScanOutput=-1_"^"_"退款订单交易类型错误"
		}
	}
	
    do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID, FormatType, ScanOutput)
    
 	quit ScanOutput
 	
ERROR
	quit ..AppException()
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Modify: 2022-09-16 ZhYW
/// Descripiton: 格式化接口返回
/// Input: BankData:返回参数
/// Return: 格式化后的对象
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).FormatScanOutput("","Create")
ClassMethod FormatScanOutput(BankData As %String, FormatType As %String) As %DynamicObject
{
	set outputObj=##class(DHCBILL.Common.DHCBILLCommon).GetClsPropJsonO("User.DHCBillExtTradePay")
	set outputObj.ETPExtOutString=BankData
	
	if (FormatType="Create") {
		set rtn=$p(BankData,"^",1)
		set outputObj.ETPRc=$s((rtn=0):"00",1:"02")   //00:下单成功, 02:下单失败
		set outputObj.ETPRcDetail=$p(BankData,"^",2)
		set outputObj.ETPExtTradeNo=$p(BankData,"^",3)
	}elseif(FormatType="Commit") {
		set rtn=$p(BankData,"^",1)
		if (rtn=0) {
			set outputObj.ETPRc="00"
			set outputObj.ETPRcDetail="支付成功"
			set outputObj.ETPRRN=$p($p(BankData,"^",2),"||",2)   //微信支付宝流水号
			set outputObj.ETPExtTradeNo=$p(BankData,"^",3)       //支付平台单号
			set outputObj.ETPExtAmt=$p(BankData,"^",4)           //支付金额
			set tradeDateTime=$p(BankData,"^",5)
			set tradeDateTime=$s((tradeDateTime'=""):$zdth(tradeDateTime,3,1),1:"")
			set outputObj.ETPExtDate=$p(tradeDateTime,",",1)
			set outputObj.ETPExtTime=$p(tradeDateTime,",",2)
		}else {
			set outputObj.ETPRc="02"
			set outputObj.ETPRcDetail=$p($p(BankData,"^",2),"||",1)  //msg
		}
	}elseif (FormatType="Query") {
		set status=$p($p(BankData,"^",3),"||",1)   //WAITPAY 等待支付, CLOSE 关闭 未支付, SUCCESS 成功, REFUND 退费 FINISH 交易结束不可退费
		if ($zcvt(status,"U")="SUCCESS") {
			set outputObj.ETPRc="00"
			set outputObj.ETPRcDetail="支付成功"
			set outputObj.ETPRRN=$p($p(BankData,"^",3),"||",2)   //微信支付宝流水号
			set outputObj.ETPExtTradeNo=$p(BankData,"^",4)       //支付平台单号
			set outputObj.ETPExtAmt=$p(BankData,"^",5)           //金额
			set tradeDateTime=$p(BankData,"^",6)
			set tradeDateTime=$s((tradeDateTime'=""):$zdth(tradeDateTime,3,1),1:"")
			set outputObj.ETPExtDate=$p(tradeDateTime,",",1)
			set outputObj.ETPExtTime=$p(tradeDateTime,",",2)
		}else {
			set outputObj.ETPRc="02"
			set outputObj.ETPRcDetail=$p(BankData,"^",2)
		}
	}elseif (FormatType="Cancel") {
		set rtn=$p(BankData,"^",1)
		if (rtn=0) {
			set outputObj.ETPRc="00"
			set outputObj.ETPRcDetail="撤销成功"
		}else {
			set outputObj.ETPRc="02"
			set outputObj.ETPRcDetail=$p(BankData,"^",2)
		}
	}elseif (FormatType="Refund") {
		set rtn=$p(BankData,"^",1)
		set status=$p(BankData,"^",2)
		if ((rtn=0)&&($zcvt(status,"U")="SUCCESS")) {
			set outputObj.ETPRc="00"
			set outputObj.ETPRcDetail="退款成功"
			set outputObj.ETPRRN=$p(BankData,"^",3)
			set outputObj.ETPExtTradeNo=$p(BankData,"^",5)
			set tradeDateTime=$p(BankData,"^",6)
			set tradeDateTime=$s((tradeDateTime'=""):$zdth(tradeDateTime,3,1),1:"")
			set outputObj.ETPExtDate=$p(tradeDateTime,",",1)
			set outputObj.ETPExtTime=$p(tradeDateTime,",",2)
			set outputObj.ETPExtAmt=$p(BankData,"^",7)         //退款金额
		}else {
			set outputObj.ETPRc="02"
			set outputObj.ETPRcDetail=$p(BankData,"^",2)
		}
	}
	
	if (outputObj.ETPRc="00") {
		if (outputObj.ETPExtDate="") {
			set outputObj.ETPExtDate=+$h
	    }
	    if (outputObj.ETPExtTime="") {
			set outputObj.ETPExtTime=$p($h,",",2)
	    }
	}
    
	quit outputObj
}

/// Creator: liwenhao
/// CreatDate: 2019-03-07
/// Descripiton: 根据扫码转换支付渠道
/// Input: ScanCode:手机支付码
/// Return: 返回第三方支付宝微信对应支付渠道
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).PayChannelByScanCode()
ClassMethod PayChannelByScanCode(ScanCode As %String)
{
	set payChanel=""
	set headCode=","_$e(ScanCode,1,2)_","
	//微信以10、11、12、13、14、15开头18位数字
	//支付宝以25~30开头的长度为16~24位的数字
	set wechatStr=",10,11,12,13,14,15,"
	set alipayStr=",25,26,27,28,29,30,"
	if (wechatStr[headCode) set payChanel="WX"
	if (alipayStr[headCode) set payChanel="ZFB"
	
	quit payChanel
}

/// Creator: ZhYW
/// CreatDate: 2022-09-16
/// Descripiton: 支付渠道转换为HIS支付方式代码
/// Input: PayChannel:支付渠道代码
/// Return: HIS支付方式代码(CT_PayMode.CTPM_Code)
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).GetPayMCodeByPayChannel("WX")
ClassMethod GetPayMCodeByPayChannel(PayChannel As %String)
{
	set PayMCode=$case(PayChannel,"WX":"WECHATPAY","ZFB":"ALIPAY",:"")
	quit PayMCode
}

/// Creator: ZhYW
/// CreatDate: 2022-09-16
/// Descripiton: 业务类型转换为订单类型代码
/// Input: BizType:业务类型代码
/// Return: 订单类型代码
/// Debug: w ##class(DHCBILL.ScanPay.Adapter.DHCAdapter).GetOrderTypeByBizType("OP")
ClassMethod GetOrderTypeByBizType(BizType As %String)
{
	set json=##class(%DynamicObject).%New()
	set json.REG="Reg"            //挂号
	set json.OP="Charge"          //门诊收费
	set json.IP="IPCharge"        //住院收费
	set json.DEP="IPDEP"          //住院押金
	set json.PRE="OPDEP"          //门诊预交金
	set json.CARD="Card"          //卡费
	set json.INSU="INSUCharge"    //线上医保收费
	set json.PE="PE"              //体检收费
	set json.PEDEP="PEDEP"        //体检预交金
	set json.EPDEP="EPDEP"        //留观押金
	do json.%Close()
	set orderType=json.%Get($zcvt(BizType,"U"))
	quit $s((orderType'=""):orderType,1:"Other")   //未定义的返回"Other"
}

}
