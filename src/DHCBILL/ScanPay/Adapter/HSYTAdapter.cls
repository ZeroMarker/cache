/// Creator:zhenghao
/// CreatDate:2018-03-07
/// Descripiton:杭州恒生芸泰网络科技有限公司(扫码支付)对接类
Class DHCBILL.ScanPay.Adapter.HSYTAdapter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
/// Debug:w ##class(web.DHCBillBarCodeLogic).CreateScanCodePay("OP",30,300,"12^23^2^34^1^2^192017")
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
  
	s PLIST(47)=Channel			;支付渠道 
    s PLIST(48)=ExtroNo 		;第三方订单
    s PLIST(32)="ScanPayHSYT"	;ETP_TradeChannel	交易途径/渠道(POSLD POSXL ScanPay)
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
/// Debug:w ##class(web.DHCBillBarCodeLogic).CommitBarcodePay("01002680020171118121456664276487","134816083819344511")
ClassMethod CommitScanCodePay(ETPRowID, ScanCode, ExpStr = "")
{
	s rtn="^"	
	s InputXML=..FormatScanInput(ETPRowID,ScanCode,"Commit")
	;s ^DHCBillScanCodePayLog($zd(+$h,3),ETPRowID,"In")=InputXML	
    s PayModeDr=$p(^DHCBILLETP(ETPRowID),"^",45)
    s myRtn=..InvokingWebService(ETPRowID,InputXML,"Commit")
    s ErrCode=$p(myRtn,"^",1)
    q:ErrCode'=0 ErrCode_"^"	
    s BankData=$p(myRtn,"^",2)
    
    s ^DHCBillScanCodePayLog($zd(+$h,3),ETPRowID,"Out")=BankData
    s OutputObj=..FormatScanOutput(BankData,"Commit")
    s rtn=OutputObj.ETPRc   ;00 交易成功 01 支付中 02 失败
    i rtn="" s rtn="01"
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
/// Debug:w ##class(web.DHCBillBarCodeLogic).CheckBarcodePayStatus("01002680020171115123711198686059")
ClassMethod VerifyScanCodePayStatus(ETPRowID, BarCode)
{
	n (ETPRowID,BarCode)
	s rtn=""
	s QueryScanXML=..FormatScanInput(ETPRowID,BarCode,"Query")
    s PayModeDr=$p(^DHCBILLETP(ETPRowID),"^",45)
    s myRtn=..InvokingWebService(ETPRowID,QueryScanXML,"Query")
    s ErrCode=$p(myRtn,"^",1)
    q:ErrCode'=0 ErrCode_"^"	
    s ScanOutputXML=$p(myRtn,"^",2)
    s OutputObj=..FormatScanOutput(ScanOutputXML,"Query")
    s rtn=OutputObj.ETPRc   ;00 交易成功 01 支付中 02 失败
    i rtn="" s rtn="01"
    s savertn=""    
    ;确认完成保存数据
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
    q:ErrCode'=0 ErrCode_"^"	
    s ScanOutputXML=$p(myRtn,"^",2)    
    s OutputObj=..FormatScanOutput(ScanOutputXML,"Cancel")
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
    q:ErrCode'=0 ErrCode_"^"	
    s ScanOutputXML=$p(myRtn,"^",2)   
    q:ScanOutputXML="" "-1^^调用接口返回空"
    s OutputObj=..FormatScanOutput(ScanOutputXML,"Refund")   
    i OutputObj.IBPRc="00" s rtn=0
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
ClassMethod InvokingWebService(ETPRowID, Request As %Text, FormatType)
{
	set $ZT="InvokingWebServiceET"
	new (ETPRowID,Request,FormatType)
	s ScanOutputXML=""
	s FacePayWSObj=##class(DHCBILL.ScanPay.Service.HSYT.FacePayWebServiceImplPort).%New()
	
	s OutputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceResponse).%New()
	
	if (FormatType="Create"){
    	s OutputObj=FacePayWSObj.wsFacePayService(InputObj)
	}
	if (FormatType="Commit"){	
		s InputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceRequest).%New()
		s InputObj.BizCode="S0002"
		s InputObj.RequestData=Request
    	s OutputObj=FacePayWSObj.wsFacePayService(InputObj)
	}
	if (FormatType="Query"){
		s InputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceRequest).%New()
		s InputObj.BizCode="S0003"
		s InputObj.RequestData=Request	
    	s OutputObj=FacePayWSObj.wsFacePayService(InputObj)
	}
	if (FormatType="Cancel"){
		s InputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceRequest).%New()
		s InputObj.BizCode="S0004"
		s InputObj.RequestData=Request	
    	s OutputObj=FacePayWSObj.wsFacePayService(InputObj)
	}
	if (FormatType="Refund"){
		s InputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceRequest).%New()
		s InputObj.BizCode="S0005"
		s InputObj.RequestData=Request	
    	s OutputObj=FacePayWSObj.wsFacePayService(InputObj)
			
	}
	s ScanOutputXML=OutputObj.ResponseData
	set ScanOutputXML=$tr(ScanOutputXML,$c(10),"")
    d ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveLog(IBPRowID,FormatType,ScanOutputXML)
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.HSYTAdapter).FormatScanInput(108,"2222","Commit")
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
	set TradeInputObj=##class(DHCBILL.ScanPay.Entity.HSYT.ScanTradeInput).%New()	
	if (FormatType="Create"){
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.HSYT.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.HSYT.ScanBody).%New()
	
		set TradeInputObj.Body=TradeInputObjBody
		set TradeInputObj.Header=TradeInputObjHead
	}elseif (FormatType="Commit"){
		set Subject=""
		If TradeType="OP" set Subject="门诊窗口缴费"
		b ;
		set HisBizType="99"
		set PatInfo=..GetPatBaseInfo(Papmi)
		set PatName=$p(PatInfo,"^",1)
		set PatSex=$p(PatInfo,"^",2)
		set PatAge=$p(PatInfo,"^",3)
		set CertificateType=$p(PatInfo,"^",4)
		set CertificateNo=$p(PatInfo,"^",5)
		set DepName=""
		set DocName=""
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.HSYT.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.HSYT.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="BarcodePayment"
		set TradeInputObjHead.RequestSn=HisTradeNo
		
		set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.HisOrderNo=HisTradeNo
		set TradeInputObjBody.OutTradeNo=HisTradeNo   
		set TradeInputObjBody.AuthCode=ScanCode
		set TradeInputObjBody.TradeFee=$fn(TradeAmt,"",2)
		set TradeInputObjBody.Channel=Channel
		set TradeInputObjBody.Subject=Subject
		set TradeInputObjBody.HisBizType=HisBizType
		set TradeInputObjBody.PatName=PatName
		set TradeInputObjBody.PatSex=PatSex
		set TradeInputObjBody.PatAge=PatAge
		set TradeInputObjBody.CertificateType=CertificateType
		set TradeInputObjBody.CertificateNo=CertificateNo
		set TradeInputObjBody.DeptName=DepName
		set TradeInputObjBody.DoctorName=DocName
		set TradeInputObjBody.ExtendParams=""	
		set TradeInputObj.Body=TradeInputObjBody

		set TradeInputObj.Header=TradeInputObjHead
	}elseif (FormatType="Query"){
	set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.HSYT.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.HSYT.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="FaceQuery"
		set TradeInputObjHead.RequestSn=HisTradeNo
		
		set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.OutTradeNo=HisTradeNo      
		set TradeInputObjBody.ExtendParams=""
		set TradeInputObjBody.PayChannel="1" ;默认窗口扫条码
		
		set TradeInputObj.Body=TradeInputObjBody
		set TradeInputObj.Header=TradeInputObjHead
	}elseif (FormatType="Cancel"){
	set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.HSYT.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.HSYT.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="FaceCancel"
		set TradeInputObjHead.RequestSn=HisTradeNo
		
		set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.OutTradeNo=HisTradeNo      
		set TradeInputObjBody.ExtendParams=""
		set TradeInputObjBody.PayChannel="1" ;默认窗口扫条码
		
		set TradeInputObj.Body=TradeInputObjBody
		set TradeInputObj.Header=TradeInputObjHead
	}elseif (FormatType="Refund"){
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.HSYT.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.HSYT.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="BarcodePayment"
		set TradeInputObjHead.RequestSn=HisTradeNo
		
		set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.OutTradeNo=HisTradeNo      
		set TradeInputObjBody.AuthCode=BarCode
		set TradeInputObjBody.TradeFee=TradeAmt
		set TradeInputObjBody.Channel=Chanel
		d TradeInputObj.Body.Insert(TradeInputObjBody)
		;set TradeInputObj.Header=TradeInputObjHead
	}	
	
	Do TradeInputObj.XMLExportToString(.Request,"Request")
	d ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(IBPRowID,FormatType,Request,"Input")

	Quit Request
}

/// Creator:zhenghao	
/// CreatDate:2018-03-07
/// Descripiton:格式化接口返回
/// Input:
/// 		ETPRowID:订单ID
/// 		BankData:返回参数
/// Output:	格式化后的返回参数
/// Return:
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.HSYTAdapter).FormatScanOutput("<Response><Header></Header><Body><PayState></PayState><PayStateDesc></PayStateDesc><OutTradeNo>123123123123</OutTradeNo><HisOrderNo>1</HisOrderNo><ThirdTradeNo>123123123123</ThirdTradeNo><YuntaiTradeNo>123123123123</YuntaiTradeNo><GmtTime>2016-12-05 14:07:01</GmtTime><TradeFee>2</TradeFee><Buyer>2321312@163.com</Buyer><ExtendParams></ExtendParams></Body></Response>","Commit")
/// w ##class(DHCBILL.ScanPay.Adapter.HSYTAdapter).FormatScanOutput("<Response><PayState>1</PayState><PayStateDes>交易中</PayStateDes><HisBizType></HisBizType><HisOrderNo></HisOrderNo><GmtTime>2016-12-05 14:07:01</GmtTime><OutTradeNo>22222222222</OutTradeNo><ThirdTradeNo>666666</ThirdTradeNo><RevTranFlag></RevTranFlag><PatientID></PatientID><PayAmt>600</PayAmt><PayChannel></PayChannel><RefundFee></RefundFee><FullPaymentFlag></FullPaymentFlag><Balance></Balance></Response>","Commit")
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.HSYTAdapter).FormatScanOutput("<Response><Header></Header><Body><OutTradeNo>123123123123</OutTradeNo><ThirdCheckNo>4564556456</ThirdCheckNo><HisOrderNo>1</HisOrderNo><ThirdRefundNo>123123123123</ThirdRefundNo><YuntaiRefundNo>123123123123</YuntaiRefundNo><RefundFee>2.00</RefundFee><ExtendParams></ExtendParams></Body></Response>","Refund")
ClassMethod FormatScanOutput(BankData, FormatType) As DHCBILL.ScanPay.Entity.ScanPayTradeHis
{
	s ^tstlog=BankData_","_FormatType
	set FomatInputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()	
	if (FormatType="Commit"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HSYT.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.Body.ETPRc="0"  s InputObj.Body.ETPRc="00" ;支付成功
	    else  if InputObj.Body.ETPRc="1"  s InputObj.Body.ETPRc="01"
		else  if InputObj.Body.ETPRc="2"	s InputObj.Body.ETPRc="02"
		else  s InputObj.Body.ETPRc="01"
		b ;kk
		Do FomatInputObj.ExchangeData(InputObj.Body)
	}elseif (FormatType="Query"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HSYT.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.Body.ETPRc="0"  set InputObj.Body.ETPRc="00" ;支付成功
	    else  if InputObj.Body.ETPRc="1"  set InputObj.Body.ETPRc="01"
		else  if InputObj.Body.ETPRc="2"	set InputObj.Body.ETPRc="02"
		else  set InputObj.Body.ETPRc="01"
		set InputObj.Body.ETPStatus=""
		Do FomatInputObj.ExchangeData(InputObj.Body)
	}elseif (FormatType="Cancel"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HSYT.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.Body.IBPHISTradeID'="" {
		    set InputObj.Body.ETPStatus="A"
		    set InputObj.Body.ETPRc="04"
	    }
		Do FomatInputObj.ExchangeData(InputObj.Body)
		
	}elseif (FormatType="Refund"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.HSYT.ScanRefOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if (InputObj.Header.ResultCode="0") set InputObj.Body.ETPRc="00"
		Do FomatInputObj.ExchangeData(InputObj.Body)
	}
	
    i (FomatInputObj.ETPExpDate="") {
		set FomatInputObj.ETPExpDate=+$h
		set FomatInputObj.ETPExtTime=$p($h,",",2)
    }
    else {
    	set FomatInputObj.ETPExtTime=$zth($e(FomatInputObj.ETPExpDate,12,19),1) 
    	set FomatInputObj.ETPExpDate=$zdh($e(FomatInputObj.ETPExpDate,1,10),3)
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
	s:wechatStr[HeadCode Chanel="26"
	s:alipayStr[HeadCode Chanel="25"
	
	
	q Chanel
}

/// wangjian
/// 2018-03-29
/// w ##class(DHCBILL.ScanPay.Adapter.HSYTAdapter).NetTest()
ClassMethod NetTest()
{
	
	s FacePayWSObj=##class(DHCBILL.ScanPay.Service.HSYT.FacePayWebServiceImplPort).%New()
	s InputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceRequest).%New()
	s InputObj.BizCode="S0000"
	s InputObj.RequestData="<Request><Header><SecurityCode></SecurityCode><BizName>netTest</BizName><RequestSn>201803290000001</RequestSn></Header><Body><RequestDT>"_$zd(+$h,3)_" "_ $zt($p($h,",",2))_"</RequestDT></Body></Request>"
    
    s ScanOutputXML=""
	s ScanOutputObj=##class(DHCBILL.ScanPay.Service.HSYT.ns1.facePayServiceResponse).%New()
    s ScanOutputObj=FacePayWSObj.wsNetTest(InputObj)
    
    s ScanOutputXML=ScanOutputObj.ResponseData
    b ;
}

ClassMethod GetPatBaseInfo(Papmi As %String) As %String
{
	s Rtn="^^^^^"
	q:Papmi="" Rtn
	i Papmi'="" d
	.s PatName=$p(^PAPER(Papmi,"ALL"),"^",1),PatRegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	.s SexID=$p(^PAPER(Papmi,"ALL"),"^",7),SexDesc=$p(^CT("SEX",SexID),"^",2)
	
	.s CurDate=$zd(+$h,3)
	.s DobDate=$zd($p($g(^PAPER(Papmi,"ALL")),"^",6),3)
	.s PatAge=..GetAgeDesc(DobDate,CurDate)
	.s CredNo=$p($g(^PAPER(Papmi,"PAT",3)),"^",6) ;证件号
	.s CredTypeDr=$p($g(^PAPER(Papmi,"PAT",3)),"^",7) ;证件类型指针
	.i CredNo="" s CredNo=$p(^PAPER(Papmi,"ALL"),"^",9)
	.s CredTypeDesc=""
	.i CredTypeDr'="" s CredTypeDesc=$p(^PAC("CARD",CredTypeDr),"^",2)
	.s Sex=$case(SexDesc,"男":"1","女":2,:"0")
	.s CredType=$case(CredTypeDesc,"身份证":"0","军官证":"4","护照":2,:"99")
	.s Rtn=PatName_"^"_Sex_"^"_PatAge_"^"_CredType_"^"_CredNo

	q Rtn
}

ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	n (DOB,CalDate)
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	n (AgeYear,AgeMonth,AgeDay)
	if AgeYear>0 s AgeDesc=AgeYear
	else  d
	s AgeDesc=1
	Q AgeDesc
}

}
