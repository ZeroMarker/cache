Import sqluser

/// Creator:xiongwang
/// CreatDate:2018-03-19
/// Descripiton:成都淘乐思网络科技有限公司微信支付(扫码)对接类
Class DHCBILL.ScanPay.Adapter.TLSAdapter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 调用第三方生成订单标准
Parameter CreateFlag = "N";

/// Creator:xiongwang	
/// CreatDate:2018-03-07
/// Descripiton:根据第三方接口要求,是否根据接口生成订单或需要存其他数据到订单表调用
/// Input:
/// 	ETPRowID:订单表RowID
/// 	ScanCode:支付码
/// 	ExpStr:扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))
/// Return:	是否成功^订单ID^描述
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).CreateScanCodePay("OP",30,300,"12^23^2^34^1^2^192017#^^C")
ClassMethod CreateScanCodePay(ETPRowID As %String, ScanCode As %String, ExpStr As %String)
{
	new (ETPRowID,ScanCode,ExpStr)
	set err=0
	;根据二维码判断是支付宝还是微信
	set Channel=..TransChannelByScanCode(ScanCode)
	;全局变量是否调用接口生成订单
	set CreateFlag=..#CreateFlag  
	set ExtroNo=""
	;调用第三方接口生成订单
	if (CreateFlag="Y") do
	.;组织调用第三方生成订单接口入参
	.set Input=..FormatScanInput(ETPRowID,"", "Create")  	   
	.set Output=..InvokingWebService(Input,"Create")	    
	.set OutputXML=..FormatScanOutput(Output)
    .set OutputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()	
    .do OutputObj.XMLNodeDeserialize(.InputObj,"Response",ScanOutputXML) 
    .set rtn=OutputObj.IBPRc    
	.set ExtroNo=OutputObj.ExtrTradeNo
	.if ExtroNo="" set err="-1"
	quit:+err'=0 err_"^^调用生成订单失败"
	TSTART
	set err=##class(web.DHCBillExtTradePay).SELECT(ETPRowID)
	set PLIST(47)=Channel		;ETP_ExtTradeChannel	支付渠道 
    set PLIST(48)=ExtroNo 		;ETP_ExtTradeNo	第三方订单
    set PLIST(32)="ScanPayTSL"	;ETP_TradeChannel	交易途径/渠道(POSLD POSXL ScanPay)
	set err=##class(web.DHCBillExtTradePay).UPDATE(ETPRowID)
	if +err'=0 TROLLBACK
	quit:+err'=0 err_"^^创建订单失败"
	TCOMMIT

	quit err_"^"_ETPRowID_"^成功"
}

/// Creator:xiongwang	
/// CreatDate:2018-03-07
/// Descripiton:提交扫码付支付
/// Input:ETPRowID:订单ID,ScanCode:病人手机支付码	
/// Output:	第三方支付返回
/// Return:订单支付状态^his保存返回码
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).CommitBarcodePay("118","134816083819344511")
ClassMethod CommitScanCodePay(ETPRowID, ScanCode, ExpStr = "")
{
	new (ETPRowID, ScanCode,ExpStr)
	
	;默认订单状态为支付中
	set OrderRtn="1"
	
	;1.根据交易类型组织入参
	set Input=..FormatScanInput(ETPRowID,ScanCode,"Commit")
    b ;2.根据交易类型调用第三方接口
    set myRtn=..InvokingWebService(ETPRowID,Input,"Commit")
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set Output=$p(myRtn,"^",2)
    b ;3.转换返回数据为XML
    set OutputXML=..FormatScanOutput(ETPRowID,Output,"Commit")
    
    b ;4.解析XML为对象
	set OutputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()
    do OutputObj.XMLNodeDeserialize(.OutputObj,"Response",OutputXML)
    
    b ;5.订单状态 00 交易成功 01 支付中 02 失败(提交订单时强制)
    ;s OutputObj.ResultCode="01"
    set OrderRtn=OutputObj.ETPRc
    
	    
    b ;6.保存数据交易数据  
    set SaveRtn=""  
	set SaveRtn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)    	            
    
    b ;完成
    q OrderRtn_"^"_SaveRtn
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:查询订单支付状态
/// Input:
/// 		ETPRowID:订单ID
/// 		BarCode:手机支付码
/// Output:	
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.HCAdapter).VerifyScanCodePayStatus(104,"")
ClassMethod VerifyScanCodePayStatus(ETPRowID, ExpStr = "")
{
	new (ETPRowID,ExpStr)
	set OrderRtn=""
	b ;1.组织入参
	set QueryScanIuput=..FormatScanInput(ETPRowID,"","Query")
    ;s PayModeDr=$p(^DHCBILLETP(ETPRowID),"^",45)
    b ;2.根据交易类型调用第三方接口
    set myRtn=..InvokingWebService(ETPRowID,QueryScanIuput,"Query")
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set ScanOutput=$p(myRtn,"^",2)
    b ;3.转换返回数据为XML
    set OutputXML=..FormatScanOutput(ETPRowID, ScanOutput,"Query")
    
    b ;4.解析XML为对象
	set OutputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()
    do OutputObj.XMLNodeDeserialize(.OutputObj,"Response",OutputXML)
    
    b ;5.订单状态 00 交易成功 01 支付中 02 失败
    ;s OutputObj.ResultCode="01"
    set OrderRtn=OutputObj.ETPRc
    
    set SaveRtn=""    
    b ;6.保存数据
    set SaveRtn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)		
	
	quit OrderRtn_"^"_SaveRtn
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:关闭订单
/// Input:
/// 		ETPRowID:订单ID
/// 		BarCode:手机支付码
/// Output:	
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).CancelBarcodePay("")
ClassMethod CancelScanCodePay(ETPRowID, ExpStr = "")
{
	new (ETPRowID, ExpStr)
    set OrderRtn=""  
	b ;1.组织关闭订单入参
	set Input=..FormatScanInput(ETPRowID,"","Cancel")	
	b ;2.调用第三方关闭订单接口
    set myRtn=..InvokingWebService(ETPRowID,Input,"Cancel")
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set Output=$p(myRtn,"^",2)
    b ;3.转换返回数据为XML
    set OutputXML=..FormatScanOutput(ETPRowID, Output,"Cancel")
    
    b ;4.解析XML为对象
	set OutputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()
    d OutputObj.XMLNodeDeserialize(.OutputObj,"Response",OutputXML)
       
    i OutputObj.ETPRc="04" s rtn=0
    
    s savertn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)	
    
	quit OrderRtn_"^"_ResultContent
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:退费接口
/// Input:
/// 		OldTradeType:原业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,CANCEL:冲销),PayModeDr:支付方式
/// 		ETPRowID:冲销订单ID（冲销必传项）
/// 		ReceipRowid:原业务交易记录		
/// 		TradeType:住院结算退押金、医保分解退收费 等交叉业务
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))
/// Output:	
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).RefundBarcodePay()
ClassMethod RefundScanCodePay(ETPRowID, ExpStr = "")
{
    new (TETPRowID, ExpStr)
	set OrderRtn=""
	
	b ;1.组织退费入参	
	set Request=..FormatScanInput(ETPRowID,"","Refund")	
	
	b ;2.调用退费接口
    set myRtn=..InvokingWebService(ETPRowID,Request,"Refund")   
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set Output=$p(myRtn,"^",2)
    b ;3.转换返回数据为XML
    set OutputXML=..FormatScanOutput(ETPRowID,Output,"Refund")
    
    b ;4.解析XML为对象
	set OutputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()
    do OutputObj.XMLNodeDeserialize(.OutputObj,"Response",OutputXML)
    set OrderRtn=OutputObj.ETPRc
    
    b ;5.更新退费订单
    set SaveRtn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)
    
    quit OrderRtn_"^"_OutputXML
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:webservice调用入口
/// Input:
/// 		Request:调用接口入参
/// 		FormatType:接口标示
/// Output:	
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).InvokingWebService()
ClassMethod InvokingWebService(ETPRowID, Request, FormatType)
{
	set $zt="InvokingWebServiceET"
	new (ETPRowID,Request,FormatType)
	set Rtnobj=""
	set FacePayObj=##class(DHCBILL.ScanPay.Service.TSL.OphiuxWechatPayServicePort).%New()
	;记录入参
	set ^DHCBillScanCodePayLog($zd(+$h,3),$zt($p($h,",",2)),ETPRowID,FormatType,"In")=Request
	if (FormatType="Create"){	
    	//s ScanOutputXML=BankCardPayObj.ScanPayment(Request)
	}
	if (FormatType="Commit"){	
    	set ScanOutput=FacePayObj.micropay(Request)
	}
	if (FormatType="Query"){	
    	set ScanOutput=FacePayObj.queryOrderResult(Request)
	}
	if (FormatType="Cancel"){	
    	set ScanOutput=FacePayObj.closeOrder(Request)
	}
	if (FormatType="Refund"){	
    	set ScanOutput=FacePayObj.refund(Request)
	}
	;记录出参
	;set ^DHCBillScanCodePayLog($zd(+$h,3),$zt($p($h,",",2)),ETPRowID,FormatType,"Out")=ScanOutput
	;保存原始数据到交易表??? 多次交易会覆盖原来信息
	do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveLog(ETPRowID,FormatType,ScanOutput)
	
    quit ScanOutput
    quit "0"_"^"_ScanOutput
InvokingWebServiceET
    quit "200^"_$ZERROR
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:实例化扫码付接口入参
/// Input:
/// 		ETPRowID:订单ID
/// 		TradeInfo:病人手机支付码
/// 		FormatType:接口标示（Create:创建订单 Commit:提交支付 Cancel:交易关闭 Query:查询订单状态 Refund:退费）
/// Output:	返回调用接口入参
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).FormatScanInput(104,"2222","Commit")
ClassMethod FormatScanInput(ETPRowID, BarCode, FormatType)
{
	new (ETPRowID, BarCode, FormatType)
	;根据订单可以取到生成调用接口的所有必要参数
	set Return=""	
	set PatNo=$p(^DHCBILLETP(ETPRowID),"^",1)
	set Adm=$p(^DHCBILLETP(ETPRowID),"^",2)
	set DepName=""
	set DocName=""
	set BankTradeNo=$p(^DHCBILLETP(ETPRowID),"^",2)
	set PayMode=$p(^DHCBILLETP(ETPRowID),"^",2)
	set ChargeAmt=$p(^DHCBILLETP(ETPRowID),"^",2)
	set ChargeAmt=ChargeAmt*100  ;入参以分为单位
	set TradeInputObj=##class(DHCBILL.ScanPay.Entity.TSL.ScanTradeInput).%New()
	if (FormatType="Commit"){		
		b ;1.1 ;刷卡支付
		/*
		set TradeInputObj."mch_token"="1"		;商户标识   
		set TradeInputObj."device_info"="1"		;设备号
		set TradeInputObj."nonce_str"="1"		;随机字符串
		set TradeInputObj.sign="1"				;签名
		set TradeInputObj."sign_type"="MD5"		;签名类型
		set TradeInputObj.body="1"				;商品描述
		set TradeInputObj."out_trade_no"="1"	;商户订单号
		set TradeInputObj."total_fee"="1"		;订单总金额
		set TradeInputObj."pay_type"="1"		;申请扣款方式
		set TradeInputObj."fee_type"="1"		;货币类型
		set TradeInputObj."spbill_create_ip"="1"	;终端IP
		set TradeInputObj."limit_pay"="1"		;指定支付方式
		set TradeInputObj."auth_code"="1"		;授权码（付款码）
		set TradeInputObj.cashier="1"		;收银员
		set TradeInputObj.attach="1"			;附加数据
		*/
		set ^||TMPScanCodePay($j,FormatType,"mch_token")=1
		set ^||TMPScanCodePay($j,FormatType,"device_info")=1
		set ^||TMPScanCodePay($j,FormatType,"sign")=1
		set ^||TMPScanCodePay($j,FormatType,"sign_type")=1
		set ^||TMPScanCodePay($j,FormatType,"body")=1
		set ^||TMPScanCodePay($j,FormatType,"out_trade_no")=1
		set ^||TMPScanCodePay($j,FormatType,"total_fee")=1
		set ^||TMPScanCodePay($j,FormatType,"pay_type")=1
		set ^||TMPScanCodePay($j,FormatType,"fee_type")=1
		set ^||TMPScanCodePay($j,FormatType,"spbill_create_ip")=1
		set ^||TMPScanCodePay($j,FormatType,"limit_pay")=1
		set ^||TMPScanCodePay($j,FormatType,"auth_code")=1
		set ^||TMPScanCodePay($j,FormatType,"cashier")=1
		set ^||TMPScanCodePay($j,FormatType,"attach")=1
		;根据第三方要求加密
		set Sign=..MD5Encryption($j,FormatType)
		
	}elseif (FormatType="Query"){		
		b ;1.2;查询订单结果(查证订单)
		set TradeInputObj."mch_token"=""		;商户标识   
		set TradeInputObj."nonce_str"=""		;随机字符串
		set TradeInputObj.sign=""			;签名
		set TradeInputObj."out_trade_no"=""		;商户订单号
		set TradeInputObj."transaction_id"=""	;微信订单号
	}elseif (FormatType="Cancel"){
		b ;1.3;取消订单(关闭订单)
		set TradeInputObj."mch_token"=""		;商户标识   
		set TradeInputObj."nonce_str"=""		;随机字符串
		set TradeInputObj."out_trade_no"=""		;商户订单号
		set TradeInputObj.sign=""			;签名
	}elseif (FormatType="Refund"){
		b ;1.4;申请退款
		set TradeInputObj."mch_token"=""		;商户标识   
		set TradeInputObj."nonce_str"=""		;随机字符串
		set TradeInputObj."out_trade_no"=""		;商户订单号
		set TradeInputObj."out_refund_no"=""	;商户退款单号
		set TradeInputObj."transaction_id"=""	;微信订单号
		set TradeInputObj."total_fee"=""		;订单总金额
		set TradeInputObj."refund_fee"=""		;申请退款金额
		set TradeInputObj."refund_fee_type"="MD5"	;货币种类
		set TradeInputObj.sign=""			;签名
	}elseif(FormatType="SMPay"){
		b ;1.5;扫码支付下单(生成二维码链接)		;暂时不做
	}elseif (FormatType="Acount"){
		b ;1.6对账明细
		set TradeInputObj."out_trade_no"="1"		;HIS订单号  
		set TradeInputObj."transaction_id"="1"		;第三方订单号
		set TradeInputObj."pay_type"="1"		;申请扣款方式
		set TradeInputObj.cashier="1"			;收银员
		set TradeInputObj."start_date"="1"		;开始时间 yyyyy-MM-dd HH:mm:ss
		set TradeInputObj."end_date"="MD5"		;结束时间 yyyyy-MM-dd HH:mm:ss
		
	}
	
	;1.对象转XML
	;d TradeInputObj.XMLExportToString(.Return,"Request")
	
	;2.对象转Json
	set Stream =##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(TradeInputObj,.Stream)
	set Return=Stream.Read()
	quit Return
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:格式化接口返回
/// Input:
/// 		ETPRowID:订单ID
/// 		BankData:返回参数
/// Output:	格式化后的返回参数
/// Return: 
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).FormatScanOutput("<Response><PayState>1</PayState><PayStateDes>1</PayStateDes><HisBizType>1</HisBizType><HisOrderNo>1</HisOrderNo><GmtTime>1</GmtTime><OutTradeNo>1</OutTradeNo><ThirdTradeNo>1</ThirdTradeNo><RevTranFlag>1</RevTranFlag><PatientID>1</PatientID><PayAmt>1</PayAmt><PayChannel>1</PayChannel><RefundFee></RefundFee><FullPaymentFlag></FullPaymentFlag><Balance></Balance></Response>","Create")
ClassMethod FormatScanOutput(ETPRowID, RtnData, FormatType)
{
	new (ETPRowID, RtnData,FormatType)
	Set OutputXML=""
	;3.1 第三方数据转换成HIS对象
	set OutputObj=##class(DHCBILL.ScanPay.Entity.TSL.ScanTradeOutput).%New()
	
	;xml转对象
	//Do OutputObj.XMLNodeDeserialize(.OutputObj,"Response",RtnData)
	
	;Json转对象
	set Stream=##class(%GlobalCharacterStream).%New()
	set Rtn = Stream.Write(RtnData)
	do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.OutputObj,"")
	
	;3.2 对象之间转换,根据交易类型转换
	set HisObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()	
	;set HisObj=##class(User.DHCINVBankTradePay).%New()
	if (FormatType="Commit"){		
		b ;3.2.1;提交订单
		if (OutputObj.RESULT="success") do
		.;提交订单未返回订单状态,只能通过查证接口查询,提交订单时写死为支付中
		.set HisObj.ETPRc="01"
		.set HisObj.ETPRcDetail="支付中"
		.;其他信息
		.;set HisObj.ETPHISTradeID=OutputObj.DATA."out_trade_no"			;HIS订单号
		.set HisObj.ETPExtTradeNo=OutputObj.DATA."transaction_id"			;第三方订单
		.set Date = $e(OutputObj.DATA."time_end",1,8)					;时间yyyyMMddHHmmss
		.if Date'="" set HisObj.ETPExtDate=$zdh(Date,8)
		.set Time= $e(OutputObj.DATA."time_end",9,$l(OutputObj.DATA."time_end"))
		.if (Time'="") do
		..set Time=$e(Time,1,2)_":"_$e(Time,3,4)_":"_$e(Time,5,6)
		..set HisObj.ETPExtTime=$zth(Time,1)
		.set HisObj.ETPExtAmt=OutputObj.DATA."total_fee"				;金额
	    else  do
	    .set HisObj.ETPRc="02"
	    .set HisObj.ETPRcDetail="支付失败"
	  
	}elseif (FormatType="Query"){		
		b ;3.2.2;查询订单结果(查证订单)
		if (OutputObj.RESULT="success") do
		.if (OutputObj.DATA."trade_state"="success") do
		..;SUCCESS—支付成功
		..set HisObj.ETPRc="00"
		..set HisObj.ETPRcDetail="支付成功"
		.else  if (OutputObj.DATA."trade_state"="USERPAYING") do
		..;USERPAYING--用户支付中
		..set HisObj.ETPRc="01"
		..set HisObj.ETPRcDetail="支付中"
		.else  if (OutputObj.DATA."trade_state"="NOTPAY")  do
		..;NOTPAY—未支付
		..set HisObj.ETPRc="02"
		..set HisObj.ETPRcDetail="未支付"
		.else  do
		..set HisObj.ETPRc="01"
		..set HisObj.ETPRcDetail="支付中"
		.;其他信息
		.set HisObj.ETPExtAmt=OutputObj.DATA."total_fee"					;金额
		.;set HisObj.HisTradeNo=OutputObj.DATA."out_trade_no"			;HIS订单号
		.set HisObj.ETPExtTradeNo=OutputObj.DATA."transaction_id"			;第三方订单
		.set Date = $e(OutputObj.DATA."time_end",1,8)					;时间yyyyMMddHHmmss
		.if Date'="" set HisObj.ETPExtDate=$zdh(Date,8)
		.set Time= $e(OutputObj.DATA."time_end",9,$l(OutputObj.DATA."time_end"))
		.if (Time'="") do
		..set Time=$e(Time,1,2)_":"_$e(Time,3,4)_":"_$e(Time,5,6)
		..set HisObj.ETPExtTime=$zth(Time,1)
		.;OutputObj.DATA."trade_state_desc"
	    else  do
	    .set HisObj.ETPRc="02"
	    .set HisObj.ETPRcDetail="支付失败"
		
	}elseif (FormatType="Cancel"){
		b ;3.2.3;取消订单(关闭订单)
		if (OutputObj.RESULT="success") do
		.set HisObj.ETPRc="04"
		.set HisObj.ETPRcDetail="关闭订单成功"
		else  do
	    .set HisObj.ETPRc="02"
	    .set HisObj.ETPRcDetail="关闭订单失败"
		
	}elseif (FormatType="Refund"){
		b ;3.2.4;申请退款
		if (OutputObj.RESULT="success") do
		.set HisObj.ETPRc="00"
		.set HisObj.ETPRcDetail="退款成功"
		.;set HisObj.a=OutputObj.DATA."out_refund_no"		;HIS原订单号
		.set HisObj.ETPExtTradeNo=OutputObj.DATA."refund_id"	;第三方退款单号
		.set HisObj.ETPExtAmt=OutputObj.DATA."refund_fee"		;退款金额
		else  do
	    .set HisObj.ETPRc="03"
	    .set HisObj.ETPRcDetail="退款失败"
	}elseif(FormatType="SMPay"){
		;扫码支付下单(生成二维码链接)		;暂时不做
	}
	;3.5 转出XML返回
	do HisObj.XMLExportToString(.OutputXML,"Response")
	quit OutputXML
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:根据扫码转换支付渠道
/// Input:
/// 	ScanCode:手机支付码
/// Return:返回第三方支付宝微信对应渠道
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).
ClassMethod TransChannelByScanCode(ScanCode)
{
	new (ScanCode)
	set Chanel=""
	set HeadCode=","_$e(ScanCode,1,2)_","
	;微信以10、11、12、13、14、15开头18位数字
	;支付宝以25~30开头的长度为16~24位的数字
	set wechatStr=",10,11,12,13,14,15,"
	set alipayStr=",25,26,27,28,29,30,"
	set:wechatStr[HeadCode Chanel="wechat"
	set:alipayStr[HeadCode Chanel="alipay"
	quit Chanel
}

/// Creator:xiongwang	
/// CreatDate:2018-03-07
/// Descripiton:组织字符串调用MD5加密
/// Input:job,进程号
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).
ClassMethod MD5Encryption(Job, FormatType)
{
	new (Job,FormatType)
	set token="123"
	set ^||TMPScanCodePay(Job,FormatType,"token")=token
	set Data=""
	set Index=""
	for  set Index=$o(^||TMPScanCodePay(Job,FormatType,Index)) quit:Index=""  do
	.set Value=$g(^||TMPScanCodePay(Job,FormatType,Index))
	.if Data=""  set Data=Index_"="_Value
	.else  set Data=Data_"&"_Index_"="_Value
	;MD5加密
	set myrtn=##class(web.Util.Encryption).MD5HexStr(Data)
	set myrtn=$zcvt(myrtn,"U")
	quit myrtn
}

}
