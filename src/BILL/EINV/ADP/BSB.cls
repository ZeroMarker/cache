Class BILL.EINV.ADP.BSB Extends %RegisteredObject
{

/// guoyunlong
/// 2022-10-13
/// 博思V2.0票据开具接口
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSA).Invoice开始")
	
	s RtnFlag="0"
	
	//组织开具接口入参   --收费流水转入开票
	s ServiceCode="serialInvoice"			;接口服务名称
	s InputJson=..InvoiceComData(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	
	q:InputJson="" "-1"   ;组织入参发生错误
	//再开票前查询一次是否已经有当前发票的电子票据信息,已经存在的情况下 直接保存获取到的电子发票结果(博思开票成功,我们保存结果是失败的时候会有这种情况)
	s OutJsonStream=""
	s ResultRtn=..GetEINVResultByBusNo(ObjInvUpDetail, InvociePam.ObjUPConfig, .OutJsonStream,InvociePam)  ;查询开票情况
	q:ResultRtn="-1" "-1"
	i (ResultRtn="S0000") {
		//有开票信息时 直接获取开票结果信息
		s RtnFlag=..SetInvQueryResultOfInvoice(ObjInvUpDetail, OutJsonStream)   ;把开票结果信息保存到交易表
	}else{
		//查询不到开票信息时 调用开票业务
		s HISUniqueID=ObjInvUpDetail.IUDBusNo				;唯一流水号
		s Message=InputJson									;业务入参
		s outData=##class(BILL.EINV.BI.BSB.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)	;调用博思http接口
		s OutJsonStream=""
		s Rtn=..DecryptionResult(outData, .OutJsonStream)     ;对返回结果进行解密
		if (Rtn="S0000") {
			s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, OutJsonStream)  ;把开票结果信息保存到交易表
			;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("OutJsonStream:"_OutJsonStream)  ;在日志中保存返回信息
		}else{
			s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
			s ObjInvUpDetail.IUDResultMeg=	OutJsonStream     ;错误信息描述
			s InvociePam.ErrMsgInfo=OutJsonStream
			s RtnFlag="-1"
		}
	}
	/*
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	*/
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSA).Invoice结束")
	q RtnFlag
}

/// guoyunlong
/// 2022-10-13
/// 博思V2.0
/// 4.1	开票结果接收
/// 开票业务场景中，平台将流水开票处理完成后，异步调用该接口将开票结果信息通知给业务系统
/// InputJson   --第三方回调接口入参
ClassMethod InvoiceReceive(InputJson As %String) As %String
{
	s ReceFlag="-1"
	q:InputJson="" ReceFlag
	
	s Rtn=..DecryptionResult(InputJson, .OutJsonStream)
	if (Rtn="S0000") {
		 s ReceiceReqObj=##class(BILL.EINV.DTO.BSB.EInvReceiceReq).%New()
	     s ResultStream=##class(%GlobalCharacterStream).%New()
	     d ResultStream.Write(OutJsonStream)
	     d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ReceiceReqObj,"")
		 s BusNo=ReceiceReqObj.busNo
		 ///Index IdxBusinessNo On IUDBusNo As Exact;
		 s ID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxBusinessNo", BusNo, ""),-1)
	     q:ID="" ReceFlag
	     s ObjInvUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ID)
		 s ObjInvUpDetail.IUDBillBatchCode=ReceiceReqObj.invoiceInfo.invoiceCode		;电子票据代码
	     s ObjInvUpDetail.IUDBillBatchNo=ReceiceReqObj.invoiceInfo.invoiceNum			    	;电子票据号码
	     s ObjInvUpDetail.IUDCheckCode=ReceiceReqObj.invoiceInfo.checkCode					;电子校验码
	     s ObjInvUpDetail.IUDCreatDate=$zdh(ReceiceReqObj.invoiceInfo.invoiceDate,3)				;电子票据生成日期
	     s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;;电子票据生成时间
         s ObjInvUpDetail.IUDBillBatchStatus=ReceiceReqObj.invoiceInfo.issueState
	     ;+dongkf 2020-04-02 start
	     s ObjInvUpDetail.EinvprtNo=ReceiceReqObj.invoiceInfo.invoiceCode_ReceiceReqObj.invoiceInfo.invoiceNum  ;发票编码+发票号码
	     s ObjInvUpDetail.Xstr1=ReceiceReqObj.busNo      ;流水号
	     s ReceFlag="0"
	}

   q ReceFlag
}

/// guoyunlong
/// 2022-10-13
/// 博思V2.0  3.3	打印电子发票接口
ClassMethod InvoiceDownLoad(IUDRowID As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s DownLoadReqObj=##class(BILL.EINV.DTO.BSB.EInvoiceDownLoadReq).%New()
	s DownLoadReqObj.agencyId=""
	s DownLoadReqObj.invoiceCode=""
	s DownLoadReqObj.invoiceNum=""
	s DownLoadReqObj.checkCode=""		
    //调用固定方法进行对象转Json
    s Stream=##class(%GlobalCharacterStream).%New()
    d ##class(ext.util.JsonObject).ObjectToJSONStream(DownLoadReqObj,.Stream)
    s InputJson=Stream.Read()
    //查询不到开票信息时 调用开票业务
	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("Print",30,"")				;唯一流水号
	s ServiceCode="invoicePrint"
	s Message=InputJson									;业务入参
	s outData=##class(BILL.EINV.BI.BSB.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)	;调用博思http接口
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	b ;OutJsonStream
    q OutJsonStream
}

/// 功能说明：整理门诊电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：guoyunlong  2022-10-13 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).InvoiceOP("","","") 
ClassMethod InvoiceComData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSB).InvoiceComData开始")
	
	s rtn=""
	
	//票据信息
	s invobj=##class(BILL.EINV.DTO.BSB.EInvoiceReq).%New()
	s invobj.batchNo=""   ;批次号
   /// totalCount	总笔数	Number	10	是	最大支持 99
   s invobj.totalCount=""   
   /// serialList	流水详情	节点	不限	是	
    s serialListobj=##class(BILL.EINV.DTO.BSB.EInvoiceserialList).%New()
   /// systemNoise	系统标识	String	32	是	由票据云分配
   s invobj.systemNoise=InvociePam.HospitalInfoMap.GetAt("systemNoise")  
   /// agencyId	单位识别码	String	32	是	由票据云分配
   s invobj.agencyId=InvociePam.HospitalInfoMap.GetAt("agencyId") 
   
   
 /// busNo	流水号	String	32	是	全局唯一
 s serialListobj.busNo=ObjInvUpDetail.IUDBusNo 
 /// chargeDate	收费日期	String	10	是	格式：yyyy-MM-dd
 s serialListobj.chargeDate=ObjInvPrtInfo.BusDate
 /// agencyTaxNum	单位税号	String	20	是
 s serialListobj.agencyTaxNum=InvociePam.HospitalInfoMap.GetAt("agencyTaxNum")
 /// invoiceType	发票类型	String	2	是	0-电子票
 s serialListobj.invoiceType="0"
 /// payer	交款人	String	100	是
 s serialListobj.payer=ObjInvPrtInfo.PatBaseInfo.PatName
 /// payerPhone	发票接收手机号	String	11	否	交付信息
 s serialListobj.payerPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone
 /// payerEmail	发票接收邮箱	String	64	否
 s serialListobj.payerEmail=ObjInvPrtInfo.PatBaseInfo.PatEmail
 /// payerCode	交款人用户编号	String	100	是	确定交款人唯一业务身份的编号（身份证号、学号、报名流水号、车牌号、手机号等）
 s serialListobj.payerCode=ObjInvPrtInfo.PatBaseInfo.PatID
 /// chargeType	收费类型	String	2	是	0：收款 1：退款
 s serialListobj.chargeType="0"
 if ObjInvPrtInfo.InvShareAmt<0 d
 .s serialListobj.chargeType="1"
 /// department	收费部门名称	String	100	是	
 s serialListobj.department=InvociePam.HospitalInfoMap.GetAt("department")    //通过配置取数据
 /// channel	缴费渠道	String	32	否	渠道中文名或统一编码
 s serialListobj.channel=""
 /// channelId	支付账户 id	String	100	否	缴费渠道是微信或者支付宝支付时，传对应的微信 id 或者支付宝id
 s serialListobj.channelId=""
 /// orderId	订单号	String	32	否	支付订单号
 s serialListobj.orderId=""
 /// recer	收款人	String	8	是	
 s serialListobj.recer=ObjInvPrtInfo.BusUserDesc
 /// reviewer 复核人	String	8	否	
 s serialListobj.reviewer=InvociePam.HospitalInfoMap.GetAt("reviewer")
 /// operator	开票人	String	8	否	
 s serialListobj.operator=InvociePam.UserDesc
 /// oldBusNo	原流水号	String	32	否	退款时必填，用于发票冲红填写原发票号码
 s serialListobj.oldBusNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo
 /// chargeAmt	收费金额	Number	18,2	是
 s serialListobj.chargeAmt=ObjInvPrtInfo.InvShareAmt
 /// buyerName	购方名称	String	100	否
 s serialListobj.buyerName=ObjInvPrtInfo.PatBaseInfo.PatName
 /// buyerTaxNum	购方税号	String	20	否
 s serialListobj.buyerTaxNum=""
 /// buyerAddress	购方地址	String	85	否	发票抬头信息
 s serialListobj.buyerAddress=""
 /// buyerPhone	购方电话	String	11	否
 s serialListobj.buyerPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone
 /// buyerBank	购方开户行	String	80	否
 s serialListobj.buyerBank=""
 /// buyerAccount	购方账号	String	18	否
 s serialListobj.buyerAccount=""
 /// remark	备注	String	130	否
 s serialListobj.remark=""
 /// extendInfo	扩展信息	JSON	不限	否	业务扩展数据
 s serialListobj.extendInfo=""
 /// custom1	发票版式定制字段	String	200	否
 s serialListobj.custom1=""
 /// custom2	发票版式定制字段	String	200	否	发票定制字段
 s serialListobj.custom2=""
 /// custom3	发票版式定制字段	String	200	否	
 s serialListobj.custom3=""
 /// callBackUrl	回调地址	String	500	否	开票成功后的结果通知地址，规范详见：3.2
 s serialListobj.callBackUrl=""
 /// callBackPwd	回调口令	String	100	否	
 s serialListobj.callBackPwd=""
 ///清单项目明细
 f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
  ./// ItemInfos	项目信息	节点	不限	是
  .s serialListobjItemInfoobj=##class(BILL.EINV.DTO.BSB.EInvoiceserialItemInfos).%New()
  ./// itemCode	项目编码	String	20	否	
  .s serialListobjItemInfoobj.itemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode
  ./// itemName	项目名称	String	100	是	
  .s serialListobjItemInfoobj.itemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc
  ./// specification	规格型号	String	40	否
  .s serialListobjItemInfoobj.specification=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec
  ./// units	单位	String	20	否	
  .s serialListobjItemInfoobj.units=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit
  ./// count	数量	Number	18	否	默认为  1
  .s serialListobjItemInfoobj.count=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty
  ./// unitPrice	单价	Number	18,6	否	
  .s serialListobjItemInfoobj.unitPrice=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price
  ./// amount	金额	Number	18,2	是	价税合计额
  .s serialListobjItemInfoobj.amount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt
  ./// itemExtendInfo	扩展信息	JSON	不限	否
  .s serialListobjItemInfoobj.itemExtendInfo=""
  .d serialListobj.ItemInfos.Insert(serialListobjItemInfoobj)
  
  d invobj.serialList.Insert(serialListobj)
	
  //调用固定方法进行对象转Json
  s Stream=##class(%GlobalCharacterStream).%New()
  d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
  ;s rtn=Stream.Read()
	
  ;add by xubaobao 2020 11 25  循环读取数据
  s rtn=Stream.Read(Stream.Size)
  q rtn
}

/// 功能说明： 对第三方返回的json加密数据进行解析
ClassMethod DecryptionResult(Response, ByRef OutJsonStream As %String) As %String
{
	//宁波鄞州人民测试用--调用平台组接口
	//如果是我们自己与第三方（博思）对接，此处代码需要注释掉
	;s Rtn=..DecryptionResultToENS(Response, .OutJsonStream)
	;q Rtn
	
	s Rtn="-1"
	s ResultObj=##class(BILL.EINV.DTO.BSB.EInvoiceComRes).%New()
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.result
	s OutJsonStream=##class(web.Util.Encryption).Base64Decode(ResultObj.message,"UTF8")
	q Rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvQueryResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSA).SetInvResultOfInvoice开始.")
	
	s ResultMegObj=##class(BILL.EINV.DTO.BSB.EInvoiceQuerymessageRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	//对返回结果的时间戳进行分割

	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.invoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.invoiceNum			    	;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.checkCode					;电子校验码
	s ObjInvUpDetail.IUDCreatDate=+$h							;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;;电子票据生成时间
    s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state
	;+dongkf 2020-04-02 start
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.invoiceCode_ResultMegObj.invoiceNum  ;发票编码+发票号码
	s ObjInvUpDetail.Xstr1=ResultMegObj.busNo      ;流水号
	s ObjInvUpDetail.IUDUplodeFlag="Y"
	s ObjInvUpDetail.EInvFlg="I"
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	;+dongkf 2020-04-02 end
	;add by xubaobao 2020 11 27增加预交金开具返参
	if ObjInvUpDetail.IUDPayAdmType="DEP" {
		s ObjInvUpDetail.IUDVoucherBatchCode=ResultMegObj.voucherBatchCode	;预交金凭证代码
		s ObjInvUpDetail.IUDVoucherNo=ResultMegObj.voucherNo				;预交金凭证号码				
		s ObjInvUpDetail.IUDVoucherRandom=ResultMegObj.voucherRandom		;预交金凭证校验码
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSB).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSA).SetInvResultOfInvoice开始.")
	
	s ResultMegObj=##class(BILL.EINV.DTO.BSB.EInvoiceMessageRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	//对返回结果的时间戳进行分割

    
    for index=1:1:ResultMegObj.failList.Size  d
	  .s ObjInvUpDetail.Xstr1=ResultMegObj.failList.GetAt(index).busNo      ;流水号
	  .s payer=ResultMegObj.failList.GetAt(index).payer	///交款人	String	100	是
      .s chargeAmt=ResultMegObj.failList.GetAt(index).chargeAmt	///收费金额	Number	18,2	是
      .s reason=ResultMegObj.failList.GetAt(index).reason	///失败原因	String	200	是

	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSB).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：调用服务接口获取开票状况服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetEINVResultByBusNo("","","") 
ClassMethod GetEINVResultByBusNo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutJsonStream As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSB).GetEINVResultByBusNo开始.")
	
	//组织电子票据开票状况入参
	s EInvoiceQuery=##class(BILL.EINV.DTO.BSB.EInvoiceQueryReq).%New()
	s EInvoiceQuery.busNo=ObjInvUpDetail.IUDBusNo					;业务流水号
	s EInvoiceQuery.agencyId=InvociePam.HospitalInfoMap.GetAt("agencyId")     //单位识别码

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvoiceQuery,.Stream)
	s InputJson=Stream.Read()
	s ServiceCode="serialInvoiceQuery"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	
	s RtnCode=""
	s outData=##class(BILL.EINV.BI.BSB.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig, .RtnCode)
	q:RtnCode="-1" RtnFlag
	;+upd by dongkf 2020 06 28 end
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.BSA).GetEINVResultByBusNo结束.Rtn="_Rtn)
	q Rtn
}

}
