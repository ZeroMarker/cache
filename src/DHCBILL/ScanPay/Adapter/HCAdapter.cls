Class DHCBILL.ScanPay.Adapter.HCAdapter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 调用第三方生成订单标准
Parameter CreateFlag = "N";

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:生成扫码付订单
/// Input:
/// 		TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,CANCEL:冲销)
/// 		PayModeDr:支付方式
/// 		TradeAmt:交易金额
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))
/// Return:	是否成功^订单ID^描述
/// Debug:w ##class(web.DHCBillBarCodeLogic).CreateScanCodePay("OP",30,300,"12^23^2^34^1^2^192017#^^C")
ClassMethod CreateScanCodePay(ETPRowID As %String, ScanCode As %String, ExpStr As %String)
{
	n (ETPRowID,ScanCode,ExpStr)	
	s HospDR=$p(ExpStr,"^",3)
	s Guser=$p(ExpStr,"^",4)
	s PatId=$p(ExpStr,"^",5)
	s Adm=$p(ExpStr,"^",6)
	s PrtStr=$p(ExpStr,"^",7)
	
	s Channel=..TransChannelByScanCode(ScanCode)	
	
	;更新银行交易信息表
	s err=##class(web.DHCBillExtTradePay).SELECT(ETPRowID)	
	q:+err'=0 err_"^^"
		
	s ExtroNo=""
	s CreateFlag=..#CreateFlag  ;是否改到支付方式扩展表配置
	;i TradeFlag="D" s CreateFlag="N" ;退费不需调用接口  如需注释
	;调用第三方接口生成订单
	i (CreateFlag="Y"){
		s InputXML=..FormatScanInput(ETPRowID,"", "Create")  ;组织调用第三方生成订单接口入参	   
	    s ScanOutputXML=..InvokingWebService(ETPRowID,InputXML,"Create")	    
	    s OutputObj=..FormatScanOutput(ScanOutputXML,"Create")    	
	    s ExtroNo=OutputObj.ExtrTradeNo
	    i ExtroNo="" s err="-1"
	}
  
	s PLIST(47)=Channel		;支付渠道 
    s PLIST(48)=ExtroNo 	;第三方订单
    s PLIST(32)="ScanPayHC"	;ETP_TradeChannel	交易途径/渠道(POSLD POSXL ScanPay)
	s err=##class(web.DHCBillExtTradePay).UPDATE(ETPRowID)	
	q:+err'=0 err_"^^更新订单失败"
    
	q err_"^"_ETPRowID_"^成功"
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:提交扫码付支付
/// Input:
/// 		ETPRowID:订单ID
/// 		ScanCode:病人手机支付码
/// Output:	第三方支付返回
/// Return:订单支付状态^his保存返回码
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.HCAdapter).CommitScanCodePay(113,"134816083819344511")
ClassMethod CommitScanCodePay(ETPRowID, ScanCode, ExpStr = "")
{
	s rtn=""	
	s InputXML=..FormatScanInput(ETPRowID,ScanCode,"Commit")
	s ^DHCBillScanCodePayLog($zd(+$h,3),ETPRowID,"In")=InputXML	
    s PayModeDr=$p(^DHCBILLETP(ETPRowID),"^",45)
    s myRtn=..InvokingWebService(ETPRowID,InputXML,"Commit")
    s ErrCode=$p(myRtn,"^",1)
    q:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    s BankData=$p(myRtn,"^",2)
    s ^DHCBillScanCodePayLog($zd(+$h,3),ETPRowID,"Out")=BankData
    s OutputObj=..FormatScanOutput(BankData,"Commit")    
    s rtn=OutputObj.ETPRc
    b ;00
	s savertn=""     
    ;保存数据交易数据   
	s savertn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)    	            
    
    
    q rtn_"^"_savertn
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:查询订单支付状态
/// Input:
/// 		ETPRowID:订单ID
/// 		BarCode:手机支付码
/// Output:	
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.HCAdapter).VerifyScanCodePayStatus(245,"")
ClassMethod VerifyScanCodePayStatus(ETPRowID, BarCode)
{
	
	s rtn=""
	s QueryScanXML=..FormatScanInput(ETPRowID,BarCode,"Query")
    s PayModeDr=$p(^DHCBILLETP(ETPRowID),"^",45)
    s myRtn=..InvokingWebService(ETPRowID,QueryScanXML,"Query")
    s ErrCode=$p(myRtn,"^",1)
    q:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    s ScanOutputXML=$p(myRtn,"^",2)
    
    s OutputObj=..FormatScanOutput(ScanOutputXML,"Query")    
    s rtn=OutputObj.ETPRc
    b ;00
	s savertn=""     
    ;保存数据交易数据   
	s savertn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj) 	
	
	q rtn_"^"_savertn
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:关闭订单
/// Input:
/// 		ETPRowID:订单ID
/// 		BarCode:手机支付码
/// Output:	
/// Return:
/// Debug:w ##class(web.DHCBillBarCodeLogic).CancelBarcodePay("")
ClassMethod CancelScanCodePay(ETPRowID, BarCode)
{
	n (ETPRowID,BarCode)
	s rtn=""
	s Request=..FormatScanInput(ETPRowID,BarCode,"Cancel")	
    s PayModeDr=$p(^DHCBILLETP(ETPRowID),"^",45)
    s myRtn=..InvokingWebService(ETPRowID,Request,"Cancel")  
    
    s ErrCode=$p(myRtn,"^",1)
    q:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    s ScanOutputXML=$p(myRtn,"^",2)
        
    s InputObj=..FormatScanOutput(ScanOutputXML,"Cancel")     
    i OutputObj.ETPRc="04" s rtn=0
    
    s savertn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)	
	
	
	q rtn_"^"_savertn
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
/// Debug:w ##class(web.DHCBillBarCodeLogic).RefundBarcodePay()
ClassMethod RefundScanCodePay(ETPRowID, ExpStr = "")
{
	n (ETPRowID,ExpStr)	
	s Request=..FormatScanInput(ETPRowID,"","Refund")	
    s myRtn=..InvokingWebService(ETPRowID,Request,"Refund")
    
    
    s ErrCode=$p(myRtn,"^",1)
    q:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    s ScanOutputXML=$p(myRtn,"^",2)
    
    s OutputObj=..FormatScanOutput(ScanOutputXML,"Refund")   
    i OutputObj.ETPRc="00" s rtn=0
    s SaveRtn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)
    
    q rtn_"^"_SaveRtn
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:webservice调用入口
/// Input:
/// 		Request:调用接口入参
/// 		FormatType:接口标示
/// 		PayMode:支付方式	
/// Output:	
/// Return:
/// Debug:w ##class(web.DHCBillBarCodeLogic).InvokingWebService()
ClassMethod InvokingWebService(ETPRowID, Request, FormatType)
{
	s $zt="InvokingWebServiceET"
	n (ETPRowID, Request, FormatType)
	s ScanOutputXML=""
	s BankCardPayObj=##class(SMFSOAP.SendordToAPISoap).%New()
	if (FormatType="Create"){	
    	s ScanOutputXML=BankCardPayObj.ScanPayment(Request)
	}
	if (FormatType="Commit"){	
    	s ScanOutputXML=BankCardPayObj.BarcodePayment(Request)
	}
	if (FormatType="Query"){	
    	s ScanOutputXML=BankCardPayObj.FaceQuery(Request)
	}
	if (FormatType="Cancel"){	
    	s ScanOutputXML=BankCardPayObj.FaceCancel(Request)
	}
	if (FormatType="Refund"){	
    	s ScanOutputXML=BankCardPayObj.FaceRefund(Request)
	}
    s save=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveLog(ETPRowID,FormatType,ScanOutputXML)
    
 	quit "0"_"^"_ScanOutputXML
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
/// Debug:w ##class(web.DHCBillBarCodeLogic).FormatScanInput(284,"2222","Commit")
ClassMethod FormatScanInput(ETPRowID, BarCode, FormatType)
{
	;根据订单可以取到生成调用接口的所有必要参数
	set Request=""	
	set Papmi=$p(^DHCBILLETP(ETPRowID),"^",40)
	set Adm=$p(^DHCBILLETP(ETPRowID),"^",43)
	set DepName=""
	set DocName=""
	;set BankTradeNo=$p(^DHCBILLETP(ETPRowID),"^",2)
	set PayMode=$p(^DHCBILLETP(ETPRowID),"^",45)
	set HisTradeNo=$p(^DHCBILLETP(ETPRowID),"^",32)
	set TradeAmt=$p(^DHCBILLETP(ETPRowID),"^",23)
	set Chanel=$p(^DHCBILLETP(ETPRowID),"^",46)
	set TradeInputObj=##class(DHCBILL.ScanPay.Entity.HC.ScanTradeInput).%New()
	if (FormatType="Create"){		
		set TradeInputObj.ResourceType="1111"      
		set TradeInputObj.OutTradeNo="111"
		set TradeInputObj.AuthCode    ="222"
		set TradeInputObj.TradeFee    ="5"
		set TradeInputObj.Channel   =BankTradeNo
		set TradeInputObj.Subject     ="45"
		set TradeInputObj.HisOrderNo="6"
		set TradeInputObj.HisBizType      =""
		set TradeInputObj.PatName     =""
		set TradeInputObj.PatSex    =""
		set TradeInputObj.PatAge  =""
		set TradeInputObj.CertificateType   =""
		set TradeInputObj.CertificateNo   =""
		set TradeInputObj.DeptName=""
		set TradeInputObj.DoctorName  =""
		set TradeInputObj.ExtendParams      =DepName
		set TradeInputObj.PayChannel      =DocName
		set TradeInputObj.ThirdCheckNo       =""	
		set TradeInputObj.RefundFee       =""
		
	}elseif (FormatType="Commit"){
		set TradeInputObj.ResourceType="1111"      
		set TradeInputObj.OutTradeNo="111"
		set TradeInputObj.AuthCode    ="222"
		set TradeInputObj.TradeFee    ="5"
		set TradeInputObj.Channel   =BankTradeNo
		set TradeInputObj.Subject     ="45"
		set TradeInputObj.HisOrderNo="6"
		set TradeInputObj.HisBizType      =""
		set TradeInputObj.PatName     =""
		set TradeInputObj.PatSex    =""
		set TradeInputObj.PatAge  =""
		set TradeInputObj.CertificateType   =""
		set TradeInputObj.CertificateNo   =""
		set TradeInputObj.DeptName=""
		set TradeInputObj.DoctorName  =""
		set TradeInputObj.ExtendParams      =DepName
		set TradeInputObj.PayChannel      =DocName
		set TradeInputObj.ThirdCheckNo       =""	
		set TradeInputObj.RefundFee       =""	
		
	}elseif (FormatType="Query"){		
		set TradeInputObj.ResourceType="1111"      
		set TradeInputObj.OutTradeNo="111"
		set TradeInputObj.AuthCode    ="222"
		set TradeInputObj.TradeFee    ="5"
		set TradeInputObj.Channel   =BankTradeNo
		set TradeInputObj.Subject     ="45"
		set TradeInputObj.HisOrderNo="6"
		set TradeInputObj.HisBizType      =""
		set TradeInputObj.PatName     =""
		set TradeInputObj.PatSex    =""
		set TradeInputObj.PatAge  =""
		set TradeInputObj.CertificateType   =""
		set TradeInputObj.CertificateNo   =""
		set TradeInputObj.DeptName=""
		set TradeInputObj.DoctorName  =""
		set TradeInputObj.ExtendParams      =DepName
		set TradeInputObj.PayChannel      =DocName
		set TradeInputObj.ThirdCheckNo       =""	
		set TradeInputObj.RefundFee       =""	

	}elseif (FormatType="Cancel"){		
		set TradeInputObj.ResourceType="1111"      
		set TradeInputObj.OutTradeNo="111"
		set TradeInputObj.AuthCode    ="222"
		set TradeInputObj.TradeFee    ="5"
		set TradeInputObj.Channel   =BankTradeNo
		set TradeInputObj.Subject     ="45"
		set TradeInputObj.HisOrderNo="6"
		set TradeInputObj.HisBizType      =""
		set TradeInputObj.PatName     =""
		set TradeInputObj.PatSex    =""
		set TradeInputObj.PatAge  =""
		set TradeInputObj.CertificateType   =""
		set TradeInputObj.CertificateNo   =""
		set TradeInputObj.DeptName=""
		set TradeInputObj.DoctorName  =""
		set TradeInputObj.ExtendParams      =DepName
		set TradeInputObj.PayChannel      =DocName
		set TradeInputObj.ThirdCheckNo       =""	
		set TradeInputObj.RefundFee       =""	

	}elseif (FormatType="Refund"){
		set TradeInputObj.ResourceType="1111"      
		set TradeInputObj.OutTradeNo="111"
		set TradeInputObj.AuthCode    ="222"
		set TradeInputObj.TradeFee    ="5"
		set TradeInputObj.Channel   =BankTradeNo
		set TradeInputObj.Subject     ="45"
		set TradeInputObj.HisOrderNo="6"
		set TradeInputObj.HisBizType      =""
		set TradeInputObj.PatName     =""
		set TradeInputObj.PatSex    =""
		set TradeInputObj.PatAge  =""
		set TradeInputObj.CertificateType   =""
		set TradeInputObj.CertificateNo   =""
		set TradeInputObj.DeptName=""
		set TradeInputObj.DoctorName  =""
		set TradeInputObj.ExtendParams      =DepName
		set TradeInputObj.PayChannel      =DocName
		set TradeInputObj.ThirdCheckNo       =""	
		set TradeInputObj.RefundFee       =""	
	}	
	Do TradeInputObj.XMLExportToString(.Request,"Request")
	
	Quit Request
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:格式化接口返回
/// Input:
/// 		ETPRowID:订单ID
/// 		BankData:返回参数
/// Return:格式化后的对象
/// Debug:w ##class(web.DHCBillBarCodeLogic).FormatScanOutput("<Response><PayState>1</PayState><PayStateDes>1</PayStateDes><HisBizType>1</HisBizType><HisOrderNo>1</HisOrderNo><GmtTime>1</GmtTime><OutTradeNo>1</OutTradeNo><ThirdTradeNo>1</ThirdTradeNo><RevTranFlag>1</RevTranFlag><PatientID>1</PatientID><PayAmt>1</PayAmt><PayChannel>1</PayChannel><RefundFee></RefundFee><FullPaymentFlag></FullPaymentFlag><Balance></Balance></Response>","Create")
ClassMethod FormatScanOutput(BankData, FormatType) As DHCBILL.ScanPay.Entity.ScanPayTradeHis
{
	set FomatInputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()	
	if (FormatType="Commit"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HC.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.ETPRc="0"  s InputObj.ETPRc="00" ;支付成功
	    else  if InputObj.ETPRc="1"  s InputObj.ETPRc="01"
		else  if InputObj.ETPRc="2"	s InputObj.ETPRc="02"
		else  s InputObj.ETPRc="01"
		Do FomatInputObj.ExchangeData(InputObj)
	}elseif (FormatType="Query"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HC.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.ETPRc="0"  set InputObj.ETPRc="00" ;支付成功
	    else  if InputObj.ETPRc="1"  set InputObj.ETPRc="01"
		else  if InputObj.ETPRc="2"	set InputObj.ETPRc="02"
		else  set InputObj.ETPRc="01"
		set InputObj.ETPStatus=""
		Do FomatInputObj.ExchangeData(InputObj)
	}elseif (FormatType="Cancel"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HC.ScanCancelOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.ETPRc="0" {
		    set InputObj.ETPStatus="A"
		    set InputObj.ETPRc="04"
	    }
		Do FomatInputObj.ExchangeData(InputObj)
		
	}elseif (FormatType="Refund"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HC.ScanRefOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if (InputObj.ResultCode="0") set InputObj.ETPRc="00"
		Do FomatInputObj.ExchangeData(InputObj)
	}
	
    i (FomatInputObj.ETPExtDate="") {
		set FomatInputObj.ETPExtDate=+$h
		set FomatInputObj.ETPExtTime=$p($h,",",2)
    }
    else {
	    set FomatInputObj.ETPExtTime=$zth($e(FomatInputObj.ETPExtDate,12,19),1) 
    	set FomatInputObj.ETPExtDate=$zdh($e(FomatInputObj.ETPExtDate,1,10),3)
    }    
	Quit FomatInputObj
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:根据扫码转换支付渠道
/// Input:
/// 		ScanCode:手机支付码
/// Return:返回第三方支付宝微信对应渠道
/// Debug:w ##class(web.DHCBillBarCodeLogic).
ClassMethod TransChannelByScanCode(ScanCode)
{
	s Chanel=""
	s HeadCode=","_$e(ScanCode,1,2)_","
	;微信以10、11、12、13、14、15开头18位数字
	;支付宝以25~30开头的长度为16~24位的数字
	s wechatStr=",10,11,12,13,14,15,"
	s alipayStr=",25,26,27,28,29,30,"
	s:wechatStr[HeadCode Chanel="WX"
	s:alipayStr[HeadCode Chanel="ZFB"
	
	
	q Chanel
}

}
