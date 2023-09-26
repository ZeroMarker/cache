Import sqluser

/// Creator:xiongwang
/// CreatDate:2018-03-19
/// Descripiton:成都赛诺普信息技术有限公司(扫码支付)对接类
Class DHCBILL.ScanPay.Adapter.CDSNPAdapter Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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
	;set Channel=..TransChannelByScanCode(ScanCode)
	;全局变量是否调用接口生成订单
	set CreateFlag=..#CreateFlag  
	set ExtroNo=""
	;调用第三方接口生成订单
	if (CreateFlag="Y") do
	.;组织调用第三方生成订单接口入参
	.set Input=..FormatScanInput(ETPRowID,"", "Create")  	   
	.set myRtn=..InvokingWebService(Input,"Create")
	.set err=err+$p(myRtn,"^",1)
	.set Output=$p(myRtn,"^",2)	 
	.quit:err'=0  
	.set OutputObj=..FormatScanOutput(Output)
    .;set OutputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()	
    .;do OutputObj.XMLNodeDeserialize(.InputObj,"Response",ScanOutputXML) 
    .set rtn=OutputObj.ETPRc    
	.set ExtroNo=OutputObj.ExtrTradeNo
	.if ExtroNo="" set err="-1"
	quit:+err'=0 err_"^^调用生成订单失败"
	TSTART
	;根据支付方式区分渠道号
	set Channel=""
	set PayMode=$p(^DHCBILLETP(ETPRowID),"^",45)
	
	if PayMode="43" set Channel="26"		;WXSM	微信扫码
	else  if PayMode="44" set Channel="25"	;支付宝扫码
	set err=##class(web.DHCBillExtTradePay).SELECT(ETPRowID)
	if +err=0  do
	.set PLIST(47)=Channel			;ETP_ExtTradeChannel	支付渠道 
    .set PLIST(48)=ExtroNo 			;ETP_ExtTradeNo	第三方订单
    .set PLIST(32)="ScanPayCDSNP"	;ETP_TradeChannel	交易途径/渠道(POSLD POSXL ScanPay)
	.set err=##class(web.DHCBillExtTradePay).UPDATE(ETPRowID)
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.CDSNPAdapter).CommitScanCodePay("45040","134816083819344511")
ClassMethod CommitScanCodePay(ETPRowID, ScanCode, ExpStr = "")
{
	new (ETPRowID, ScanCode,ExpStr)
	
	;默认订单状态为支付中
	set OrderRtn="01"
	
	;1.根据交易类型组织入参
	set Input=..FormatScanInput(ETPRowID,ScanCode,"Commit")
    b ;2.根据交易类型调用第三方接口
    set myRtn=..InvokingWebService(ETPRowID,Input,"Commit")
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set Output=$p(myRtn,"^",2)	
    b ;3.转换返回对象
    set OutputObj=..FormatScanOutput(Output,"Commit")
    set OrderRtn=OutputObj.ETPRc
    if OrderRtn="" set OrderRtn="01"
	    
    b ;4.保存数据交易数据  
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.CDSNPAdapter).VerifyScanCodePayStatus(45062,"")
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
    b ;3.
    set OutputObj=..FormatScanOutput(ScanOutput,"Query")
    
    set OrderRtn=OutputObj.ETPRc
    if OrderRtn="" set OrderRtn="01"
    
    set SaveRtn=""    
    b ;4.保存数据
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.CDSNPAdapter).CancelScanCodePay(45039)
ClassMethod CancelScanCodePay(ETPRowID, ExpStr = "")
{
	new (ETPRowID, ExpStr)
    set Rtn=""  
	b ;1.组织关闭订单入参
	set Input=..FormatScanInput(ETPRowID,"","Cancel")	
	b ;2.调用第三方关闭订单接口
    set myRtn=..InvokingWebService(ETPRowID,Input,"Cancel")
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set Output=$p(myRtn,"^",2)
    b ;3.转换返回数据为XML
    set OutputObj=..FormatScanOutput( Output,"Cancel")
    
       
    if OutputObj.ETPRc="04" set Rtn=0
    
    set savertn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)	
    
	quit Rtn_"^"_savertn
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.CDSNPAdapter).RefundScanCodePay(10)
ClassMethod RefundScanCodePay(ETPRowID, ExpStr = "")
{
    new (ETPRowID, ExpStr)
	set OrderRtn=""
	
	b ;1.组织退费入参	
	set Request=..FormatScanInput(ETPRowID,"","Refund")	
	
	b ;2.调用退费接口
    set myRtn=..InvokingWebService(ETPRowID,Request,"Refund")   
    set ErrCode=$p(myRtn,"^",1)
    quit:ErrCode'=0 ErrCode_"^"	//返回异常信息(程序异常,超时)
    set Output=$p(myRtn,"^",2)
    b ;3.转换返回数据为XML
    set OutputObj=..FormatScanOutput(Output,"Refund")
 
    set OrderRtn=OutputObj.ETPRc
    
    b ;5.更新退费订单
    set SaveRtn=##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanPayInfo(ETPRowID,OutputObj)
    
    quit OrderRtn_"^"_SaveRtn
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
	set $ZT="InvokingWebServiceET"
	new (ETPRowID,Request,FormatType)
	set ScanOutput=""
	set FacePayObj=##class(DHCBILL.ScanPay.Service.CDSNP.ScanCodeWebServiceImplPort).%New()
	set FacePayObj.Timeout=10
	;记录入参
	set ^DHCBillScanCodePayLog($zd(+$h,3),$zt($p($h,",",2)),ETPRowID,FormatType,"In")=Request
	set Stream =##class(%GlobalCharacterStream).%New()
	if (FormatType="Create"){	
    	//s ScanOutputXML=BankCardPayObj.ScanPayment(Request)
	}
	if (FormatType="Commit"){	
		;
    	set ScanOutput=FacePayObj.BarcodePayment(Request)
    	;set ScanOutput="<Response><Header><RequestSn>CDSDERMYY180424134300045040</RequestSn><BizName>BarcodePayment</BizName><ResultCode>0</ResultCode><ErrorMsg>成功</ErrorMsg></Header><Body><PayState>0</PayState><PayStateDesc>成功</PayStateDesc><OutTradeNo>CDSDERMYY180424134300045040</OutTradeNo><HisOrderNo>CDSDERMYY180424134300045040</HisOrderNo><ThirdTradeNo>2018042421001004230598283888</ThirdTradeNo><YuntaiTradeNo>201804241343431290000017</YuntaiTradeNo><GmtTime>2018-04-24 13:43:44</GmtTime><TradeFee>0.01</TradeFee></Body></Response>"
	}
	if (FormatType="Query"){	
    	set ScanOutput=FacePayObj.FaceQuery(Request)
	}
	if (FormatType="Cancel"){	
    	set ScanOutput=FacePayObj.FaceCancel(Request)
	}
	if (FormatType="Refund"){	
    	set ScanOutput=FacePayObj.FaceRefund(Request)
	}
	 ;记录出参
	;保存原始数据到交易表??? 多次交易会覆盖原来信息
	set ScanOutput=$tr(ScanOutput,$c(10),"")
	;set ScanOutput=$tr(ScanOutput," ","")
	do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveLog(ETPRowID,FormatType,ScanOutput)
	
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.TLSAdapter).FormatScanInput(450,"2222","Commit")
ClassMethod FormatScanInput(ETPRowID, ScanCode, FormatType)
{
	new (ETPRowID, ScanCode, FormatType)
	;根据订单可以取到生成调用接口的所有必要参数
	set Return=""	
	set Papmi=$p(^DHCBILLETP(ETPRowID),"^",40)
	set Adm=$p(^DHCBILLETP(ETPRowID),"^",43)
	set TradeType=$p(^DHCBILLETP(ETPRowID),"^",25) 
	set HisTradeNo=$p(^DHCBILLETP(ETPRowID),"^",32)
	set TradeAmt=$p(^DHCBILLETP(ETPRowID),"^",23)
	set TradeAmt=$fn(TradeAmt,"",2)	
	set Channel=$p(^DHCBILLETP(ETPRowID),"^",46)
	
	set TradeInputObj=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanTradeInput).%New()	
	if (FormatType="Create"){
		
	}elseif (FormatType="Commit"){
		;1、提交订单
		set Subject=""
		If TradeType="OP" set Subject="门诊窗口缴费"

		set HisBizType="99"
		set PatInfo=..GetPatBaseInfo(Papmi)
		set PatName=$p(PatInfo,"^",1)
		set PatSex=$p(PatInfo,"^",2)
		set PatAge=$p(PatInfo,"^",3)
		set CertificateType=$p(PatInfo,"^",4)
		set CertificateNo=$p(PatInfo,"^",5)
		set DepName=""
		set DocName=""
		
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="8094" ;安全校验码 第三方固定
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
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="FaceQuery"
		set TradeInputObjHead.RequestSn=HisTradeNo
		;2、查询
		;set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.OutTradeNo=HisTradeNo      
		set TradeInputObjBody.ExtendParams=""
		set TradeInputObjBody.PayChannel="1" ;默认窗口扫条码
		
		set TradeInputObj.Body=TradeInputObjBody
		set TradeInputObj.Header=TradeInputObjHead
	}elseif (FormatType="Cancel"){
		;3、撤销
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="FaceCancel"
		set TradeInputObjHead.RequestSn=HisTradeNo
		
		set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.OutTradeNo=HisTradeNo      
		set TradeInputObjBody.ExtendParams=""
		set TradeInputObjBody.PayChannel="1" ;默认窗口扫条码
		
		set TradeInputObj.Body=TradeInputObjBody
		set TradeInputObj.Header=TradeInputObjHead
		b ;
	}elseif (FormatType="Refund"){
		
		;4、退费
		set TradeInputObjHead=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanHead).%New()
		set TradeInputObjBody=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanBody).%New()
		set TradeInputObjHead.SecurityCode="" ;安全校验码 第三方固定
		set TradeInputObjHead.BizName="FaceRefund"
		set TradeInputObjHead.RequestSn=HisTradeNo
		
		set TradeInputObjBody.ResourceType="5"
		set TradeInputObjBody.RefundNo =HisTradeNo   
		
		set OldETPRowID=$p(^DHCBILLETP(ETPRowID),"^",20)
		set OldIBPRRN=$p(^DHCBILLETP(OldETPRowID),"^",7)
		set OldExtTradeNo=$p(^DHCBILLETP(OldETPRowID),"^",47)
		set OldTradeAmt=$p(^DHCBILLETP(OldETPRowID),"^",4)
		set TradeInputObjBody.ThirdTradeNo=OldExtTradeNo
		set TradeInputObjBody.ThirdTradeFee=OldTradeAmt
		   
		set TradeInputObjBody.YuntaiTradeNo=OldIBPRRN

		
		set TradeInputObjBody.RefundFee=TradeAmt
		set TradeInputObjBody.RefundReason="退款原因"
		set TradeInputObj.Body=TradeInputObjBody
		set TradeInputObj.Header=TradeInputObjHead
	}	
	
	;1.对象转XML
	do TradeInputObj.XMLExportToString(.Return,"Request")
	Do TradeInputObj.%Close()
	;2.对象转Json
	;set Stream =##class(%GlobalCharacterStream).%New()
	;do ##class(ext.util.JsonObject).ObjectToJSONStream(TradeInputObj,.Stream)
	;set Return=Stream.Read()
	
	 ;保存日志
	do ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog(ETPRowID,FormatType,Return,"Input")
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
/// Debug:w ##class(DHCBILL.ScanPay.Adapter.CDSNPAdapter).FormatScanOutput("","Refund")
ClassMethod FormatScanOutput(BankData, FormatType) As DHCBILL.ScanPay.Entity.ScanPayTradeHis
{
	new (BankData, FormatType)
	;set BankData="<Response><Header><RequestSn>DHCC180424170400045063</RequestSn><BizName>FaceRefund</BizName><ResultCode>0</ResultCode><ErrorMsg>成功</ErrorMsg></Header><Body>  <Status>0</Status>  <ThirdTradeNo>2018042421001004230599219925</ThirdTradeNo>  <YuntaiRefundNo>201804241702579180000019</YuntaiRefundNo>  <RefundFee>0.01</RefundFee></Body></Response>"
	set FomatInputObj=##class(DHCBILL.ScanPay.Entity.ScanPayTradeHis).%New()	
	if (FormatType="Commit"){
		set OutputObj=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanTradeOutput).%New()	   		
	    Do OutputObj.XMLNodeDeserialize(.OutputObj,"Response",BankData)
	    if OutputObj.Body.ETPRc="0"  Do
	    .set OutputObj.Body.ETPRc="00" ;支付成功
	    .if OutputObj.Body.ETPRcDetail="" set OutputObj.Body.ETPRcDetail="支付成功"
	    else  if OutputObj.Body.ETPRc="1"  do
	    .set OutputObj.Body.ETPRc="01"
	    .set OutputObj.Body.ETPRcDetail="支付中"
		else  if OutputObj.Body.ETPRc="2"	do
		.set OutputObj.Body.ETPRc="02"
		.set OutputObj.Body.ETPRcDetail="支付失败"
		else  do
		.set OutputObj.Body.ETPRc="01"
		.set OutputObj.Body.ETPRcDetail="支付中"
		Do FomatInputObj.ExchangeData(OutputObj.Body)
	}elseif (FormatType="Query"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	     else  if InputObj.Body.ETPRc="1"  do
	    .set InputObj.Body.ETPRc="01"
	    .set InputObj.Body.ETPRcDetail="支付中"
		else  if InputObj.Body.ETPRc="2"	do
		.set InputObj.Body.ETPRc="02"
		.set InputObj.Body.ETPRcDetail="支付失败"
		else  do
		set InputObj.Body.ETPRc="01"
		.set InputObj.Body.ETPRcDetail="支付中"
		;set InputObj.Body.IBPStatus=""
		Do FomatInputObj.ExchangeData(InputObj.Body)
	}elseif (FormatType="Cancel"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanTradeOutput).%New()	   		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if InputObj.Body.ETPHISTradeID'="" {
		    set InputObj.Body.ETPStatus="A"
		    set InputObj.Body.ETPRc="04"
		    set InputObj.Body.ETPRcDetail="撤销成功"
	    }
		Do FomatInputObj.ExchangeData(InputObj.Body)
	}elseif (FormatType="Refund"){
		set InputObj=##class(DHCBILL.ScanPay.Entity.CDSNP.ScanRefOutput).%New()	 		
	    Do InputObj.XMLNodeDeserialize(.InputObj,"Response",BankData)
	    if (InputObj.Body.ETPRc="0") do
	    .set InputObj.Body.ETPRc="00"
	    .set InputObj.Body.ETPRcDetail="退费成功"
	    else  do 
	    .set InputObj.Body.ETPRc="02"
	    .set InputObj.Body.ETPRcDetail="退费失败"
	  
		Do FomatInputObj.ExchangeData(InputObj.Body)
	
	}
	
    if (FomatInputObj.ETPExtDate="") {
		set FomatInputObj.ETPExtDate=+$h
		set FomatInputObj.ETPExtTime=$p($h,",",2)
    }else {
		set DateTime=FomatInputObj.ETPExtDate
		set FomatInputObj.ETPExtDate=$ZDH($e(DateTime,1,10),3)
		set FomatInputObj.ETPExtTime=$ZTH($e(DateTime,12,19),1)
		
    }    
	quit FomatInputObj
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

/// xiong
/// 2018-03-29
/// w ##class(DHCBILL.ScanPay.Adapter.CDSNPAdapter).NetTest()
ClassMethod NetTest()
{
	
	s FacePayWSObj=##class(DHCBILL.ScanPay.Service.CDSNP.ScanCodeWebServiceImplPort).%New()
	
	//s InputXML="<Request><Head d5p1:type="ScanHead" xmlns:d5p1="http://www.w3.org/2001/XMLSchema-instance"><SecurityCode>8094</SecurityCode><BizName>BarcodePayment</BizName><RequestSn>CDSDERMYY180423131900045012</RequestSn></Head><Body d5p1:type="ScanBody" xmlns:d5p1="http://www.w3.org/2001/XMLSchema-instance"><ResourceType>5</ResourceType><HisOrderNo>CDSDERMYY180423131900045012</HisOrderNo><OutTradeNo>CDSDERMYY180423131900045012</OutTradeNo><AuthCode>134816083819344511</AuthCode><TradeFee>0.01</TradeFee><Channel>26</Channel><Subject>门诊窗口缴费</Subject><HisBizType>99</HisBizType><PatName>唐光明</PatName><PatSex>1</PatSex><PatAge>1</PatAge><CertificateType>0</CertificateType><CertificateNo>510102194609267917</CertificateNo></Body></Request>"_$zd(+$h,3)_" "_ $zt($p($h,",",2))_"</RequestDT></Body></Request>"
    
    s ScanOutputObj=FacePayWSObj.BarcodePayment(InputXML)
    b ;
    s ScanOutputXML=ScanOutputObj.ResponseData
    b ;
}

}
