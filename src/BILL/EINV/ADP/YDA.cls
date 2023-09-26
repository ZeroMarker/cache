/// 山东远得电子发票接口组织第三方参数
Class BILL.EINV.ADP.YDA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong  2022-06-21  新做成
/// 其    他：w ##class(BILL.EINV.ADP.YDA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).Invoice开始")
	s RtnFlag="-1"
	
	;;;开票之前先查询开票信息
	s flag=..EInvQueryInfo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	///查询成功后quit出去不在进行开票
	q:flag="0" "0"
	//1.组织开具接口入参
	s InputReqXml=..InvoiceData(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;InputReqXml
	
	//2.调用第三方接口处理返回值
	s ResultRtn=""
	;s InvoiceRtn=..XMLPathData(ResultRtn,"/RetData/RetCode")
    ;q:InvoiceRtn'="0" RtnFlag
	
	;;;处理返回值结果
	s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, ResultRtn, InvociePam)
	
	
	;;;开票成功后，推送开票信息
	s SendFlag=..EInvSendInfo(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	
	q RtnFlag
}

/// 功能说明：整理电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的XML格式
///           
/// 修改履历：guoyunlong  2022-06-21 
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvoiceData("","","") 
ClassMethod InvoiceData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{

	;s IPInvoiceReqObj=##class(BILL.EINV.DTO.TBTCA.IPInvoiceReq).%New()
	s InvoiceReqObj=##class(BILL.EINV.DTO.YDA.EInvoiceReq).%New()
	s InvoiceContentObj=##class(BILL.EINV.DTO.YDA.EInvoiceContentReq).%New()
	s InvoiceContentInfoMasterObj=##class(BILL.EINV.DTO.YDA.EInvoiceContentInfoMasterReq).%New()

	/// 		单据编号
    s InvoiceContentInfoMasterObj.BillNumber=ObjInvUpDetail.IUDInvDr
    s InvoiceContentInfoMasterObj.BusNo=""	    //订单编号	VARCHAR (30)	是
    s InvoiceContentInfoMasterObj.Organ=InvociePam.HospitalInfoMap.GetAt("Organ")	    //	组织机构代码	VARCHAR (20)	
    s InvoiceContentInfoMasterObj.ClientName=ObjInvPrtInfo.PatBaseInfo.PatName	    //	购方名称	VARCHAR (100)	
    s InvoiceContentInfoMasterObj.ClientTaxCode=ObjInvPrtInfo.PatBaseInfo.PatID	    //	购方税号	VARCHAR（20）	
    s InvoiceContentInfoMasterObj.ClientBankAccount=""	    //	购方银行及账号	VARCHAR (100)	
    s InvoiceContentInfoMasterObj.ClientAddressPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone	    //	购方地址及电话	VARCHAR (100)	
    s InvoiceContentInfoMasterObj.ClientPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone	    //	客户手机号	VARCHAR（11）
    s InvoiceContentInfoMasterObj.ClientMail=ObjInvPrtInfo.PatBaseInfo.PatEmail	    //	客户邮箱	VARCHAR（50）		
    
    s InvoiceContentInfoMasterObj.BillType="1"	    //	发票性质	VARCHAR (1)	是	值为 1 代表蓝字发票,值为 0 代表红字发票
    if ObjInvPrtInfo.InvShareAmt<0 d
    .s InvoiceContentInfoMasterObj.BillType="0"
    s InvoiceContentInfoMasterObj.InfoKind="51"	    //	发票类型	VARCHAR (2)	是	发票的类型：0-专票，2-普票，41-卷票，51-电子发票
    s InvoiceContentInfoMasterObj.Notes=""	        //	发票备注	VARCHAR（200）				
    s InvoiceContentInfoMasterObj.InvoiceCode=""	//	蓝字发票代码	VARCHAR (20)		红字发票必填
    s InvoiceContentInfoMasterObj.InvoiceNo=""	    //	蓝字发票号码	VARCHAR (10)		红字发票必填
    ////如果发票原记录存在电子发票，则发票是红冲
    if ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode'=""  d
    .s InvoiceContentInfoMasterObj.InvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	//	蓝字发票代码	VARCHAR (20)		红字发票必填
    .s InvoiceContentInfoMasterObj.InvoiceNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo	    //	蓝字发票号码	VARCHAR (10)		红字发票必填 
    
    s InvoiceContentInfoMasterObj.Invoicer=InvociePam.UserDesc	    //	开票人	VARCHAR (8)		
    s InvoiceContentInfoMasterObj.Checker=InvociePam.UserDesc	    //	复核人	VARCHAR (8)		
    s InvoiceContentInfoMasterObj.Cashier=InvociePam.UserDesc	    //	收款人	VARCHAR (8)		
    s InvoiceContentInfoMasterObj.InvoicerCode=InvociePam.UserCode	    //	开票人代码	VARCHAR (20)	是	见注 5
    s InvoiceContentInfoMasterObj.SumMoney=ObjInvPrtInfo.InvShareAmt	    //	开票金额	DECIMAL(14,2)	是	实际开票金额
    s InvoiceContentInfoMasterObj.Times=$zd(+$h,3)	    //	单据日期	VARCHAR (10)		2018-11-16
    s InvoiceContentInfoMasterObj.Remark1=""	    //	头信息备用字段 1	VARCHAR（200）		
    s InvoiceContentInfoMasterObj.Remark2=""	    //	头信息备用字段 2	VARCHAR（200）		
    s InvoiceContentInfoMasterObj.SpecialInvoice=""	    //	特殊票种	CHAR (1)		见注 11
   s InvoiceContentInfoDetailsObj=##class(BILL.EINV.DTO.YDA.EInvoiceContentInfoDetailsReq).%New()
   for ItmIndex=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
    .s InvoiceContentInfoDetailsObj.GoodsName=ObjInvPrtInfo.InvItmDetInfo.GetAt(ItmIndex).TarDesc   /// 		<![CDATA[商品名称]]
    .s InvoiceContentInfoDetailsObj.Standard=ObjInvPrtInfo.InvItmDetInfo.GetAt(ItmIndex).Spec      /// 			<![CDATA[规格型号]]>
    .s InvoiceContentInfoDetailsObj.Unit=ObjInvPrtInfo.InvItmDetInfo.GetAt(ItmIndex).Unit       /// 			<![CDATA[计量单位]]>
    .s InvoiceContentInfoDetailsObj.Number=ObjInvPrtInfo.InvItmDetInfo.GetAt(ItmIndex).Qty   /// 			数量
    .s InvoiceContentInfoDetailsObj.Price=ObjInvPrtInfo.InvItmDetInfo.GetAt(ItmIndex).Price        /// 			单价
    .s InvoiceContentInfoDetailsObj.Amount=ObjInvPrtInfo.InvItmDetInfo.GetAt(ItmIndex).Amt        /// 			金额
    .s InvoiceContentInfoDetailsObj.PriceKind="0"       /// 			含税标志:0-不含税,1-含税
    .s InvoiceContentInfoDetailsObj.TaxAmount=""        /// 			税额
    .s InvoiceContentInfoDetailsObj.TaxRate=""         /// 			税率，17，13，6
    .s InvoiceContentInfoDetailsObj.GoodsNoVer=""        /// 			编码版本号
    .s InvoiceContentInfoDetailsObj.GoodsTaxNo="0"         /// 			税收分类编码
    .s InvoiceContentInfoDetailsObj.TaxPre=""       /// 			是否享受税收优惠政策<!--0：不享受，1：享受-->
    .s InvoiceContentInfoDetailsObj.TaxPreCon=""       /// 			<![CDATA[]]>
    .s InvoiceContentInfoDetailsObj.ZeroTax=""      /// 			零税率标识空< !-- 零税率标识  空：非零税率，0：出口退税，1：免税，2：不征收，3 普通零税率 -->
    .s InvoiceContentInfoDetailsObj.CropGoodsNo=""      /// 			企业自编码
    .s InvoiceContentInfoDetailsObj.TaxDeduction=""      /// 			扣除额

    s InvoiceContentObj.InfoMaster=InvoiceContentInfoMasterObj
    d InvoiceContentObj.InfoDetails.Insert(InvoiceContentInfoDetailsObj)
    
    s InvoiceReqObj.Content=InvoiceContentObj			
    s ReqInputXml=""
	d InvoiceReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	s ReqInputXml=..GetXMLTitle()_ReqInputXml   ;加上xml文件头数据
    q ReqInputXml
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultRtn As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlg="-1"
	set OutputObj=##class(BILL.EINV.DTO.YDA.EInvoiceRes).%New()
 	Do OutputObj.XMLNodeDeserialize(.OutputObj,"RetData",ResultRtn)
	b ;SetInvResultOfInvoice -1
	//对返回结果的时间戳进行分割
	if OutputObj.IsInvEmpty'="1" d
	.s InvociePam.ErrMsgInfo="无可用票据"
	else  d
	.s ObjInvUpDetail.IUDBillBatchCode=OutputObj.InfoTypeCode		;电子票据代码
	.s ObjInvUpDetail.IUDBillBatchNo=OutputObj.InfoNumber			;电子票据号码
	.s ObjInvUpDetail.IUDCheckCode=""			;电子校验码
	.s ObjInvUpDetail.IUDCreatDate=OutputObj.InfoInvDate   ;+$h									;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="I"										;发票状态
	.s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	.s ObjInvUpDetail.EinvprtNo=OutputObj.InfoTypeCode_OutputObj.InfoNumber  ;发票编码+发票号码
	.s ObjInvUpDetail.IUDResultCode=OutputObj.RetCode
	.s RtnFlg="0"
	q RtnFlg
}

/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的XML格式
///           
/// 修改履历：guoyunlong  2022-06-21 
ClassMethod EInvSendInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	///1.组织推送信息参数
	s InvSendInfoReqObj=##class(BILL.EINV.DTO.YDA.EInvSendInfoReq).%New()
	s InvSendInfoReqObj.InvoiceCode=ObjInvUpDetail.IUDBillBatchCode      ;票据代码
	s InvSendInfoReqObj.InvoiceNo=ObjInvUpDetail.IUDBillBatchNo          ;票据号码
	s InvSendInfoReqObj.Times=$zd(ObjInvUpDetail.IUDDate,3)              ;开票日期
	s InvSendInfoReqObj.ClientPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone   ;手机号
	s InvSendInfoReqObj.ClientMail=ObjInvPrtInfo.PatBaseInfo.PatEmail    ;邮箱
    s ReqInputXml=""
	d InvSendInfoReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	s ReqInputXml=..GetXMLTitle()_ReqInputXml   ;加上xml文件头数据
	
	//2.调用第三方接口处理返回值
	s ResultRtn=""
	s InvoiceRtn=..XMLPathData(ResultRtn,"/RetData/RetCode")
    i InvoiceRtn'="0" s InvociePam.ErrMsgInfo=..XMLPathData(ResultRtn,"/RetData/RetMsg")
    q:InvoiceRtn'="0" RtnFlag
	s RtnFlag="0"
	q RtnFlag
}

/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的XML格式
///           
/// 修改履历：guoyunlong  2022-06-21 
ClassMethod EInvQueryInfo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	///1.组织查询信息参数
	s InvQueryReqObj=##class(BILL.EINV.DTO.YDA.EInvQueryReq).%New()
	s InvQueryReqObj.Number=ObjInvUpDetail.IUDInvDr                 ;单据编号
	s InvQueryReqObj.InvoiceCode=ObjInvUpDetail.IUDBillBatchCode      ;票据代码
	s InvQueryReqObj.InvoiceNo=ObjInvUpDetail.IUDBillBatchNo          ;票据号码
	s InvQueryReqObj.Times=$zd(ObjInvUpDetail.IUDDate,3)              ;开票日期
    s ReqInputXml=""
	d InvQueryReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	
	s ReqInputXml=..GetXMLTitle()_ReqInputXml   ;加上xml文件头数据
	
	//2.调用第三方接口处理返回值
	s ResultRtn=""
	s InvoiceRtn=..XMLPathData(ResultRtn,"/RetData/RetCode")
    q:InvoiceRtn'="0" RtnFlag
    
    ///3解析查询返回值
    set OutputObj=##class(BILL.EINV.DTO.YDA.EInvQueryRes).%New()
 	Do OutputObj.XMLNodeDeserialize(.OutputObj,"RetData",ResultRtn)
	b ;SetInvResultOfInvoice -1
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=OutputObj.Invoice.InvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=OutputObj.Invoice.InvoiceNo		;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=""			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(OutputObj.Invoice.Times,1)  ;+$h									;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	s ObjInvUpDetail.EinvprtNo=OutputObj.Invoice.InvoiceCode_OutputObj.Invoice.InvoiceNo  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=OutputObj.RetCode
	s ObjInvUpDetail.IUDPictureUrl=OutputObj.Invoice.Pdfurl
    
	s RtnFlag="0"
	q RtnFlag
}

/// 按照指定XML节点解析XMl节点值
/// w ##class(BILL.EINV.ADP.TBTCB).XMLPathData("<Response><ReturnCode>456</ReturnCode></Response>","/Response/ReturnCode")
ClassMethod XMLPathData(ResOutput As %String, XMlPathAddress As %String) As %String
{
	
	s tDocument="",RtnCode=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(ResOutput, .tDocument)
	s tRes=""
    //set tSC=tDocument.EvaluateExpression("/business/RESPONSE_COMMON_FPKJ/RETURNCODE","text()",.tRes)
    set tSC=tDocument.EvaluateExpression(XMlPathAddress,"text()",.tRes)	
	if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
		set fieldValue=tRes.GetAt(1).Value
		set RtnCode=$tr(fieldValue,$c(0),"")	
	}
	q RtnCode
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoiceStutas(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoiceStutas
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.EbillBatchCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.EbillNo			;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=VoucherResultObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.EinvprtNo=VoucherResultObj.EbillBatchCode_VoucherResultObj.EbillNo  ;发票编码+发票号码
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s createTime=VoucherResultObj.EbillingTime
	s createDateTime=$e(createTime,1,$l(createTime)-3)
	s createDate=$zdh($e(createDateTime,1,8),8)
	s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	s ObjInvUpDetail.IUDCreatDate=createDate								;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=createTime							;电子票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	s ObjInvUpDetail.IUDResultCode="0000"
	s ObjInvUpDetail.Xstr2=VoucherResultObj.InsuranceSettleNo	;结算号
	b ;saveto
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalidStutas(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoiceStutas
	//对返回结果的时间戳进行分割
	i VoucherResultObj.EbillChargeOffStatus="1" d			;保存红票信息
	.s createTime=VoucherResultObj.EbillChargeOffTime
	.s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.CancelEbillBatchCode		;红票票据编码
	.s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.CancelEbillNo			;红票票据号码
	.s ObjInvUpDetail.IUDCheckCode=VoucherResultObj.RandomNumber			;红票校验码
	.s ObjInvUpDetail.EinvprtNo=VoucherResultObj.CancelEbillBatchCode_VoucherResultObj.CancelEbillNo  ;发票编码+发票号码
	.s ObjInvUpDetail.EInvFlg="S"										;发票状态
	.s createDateTime=$e(createTime,1,$l(createTime)-3)
	.s createDate=$zdh($e(createDateTime,1,8),8)
	.s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	.s ObjInvUpDetail.IUDCreatDate=createDate								;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=createTime							;电子票据生成时间
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	.s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	.s ObjInvUpDetail.IUDResultCode="0000"
	.s ObjInvUpDetail.Xstr2=VoucherResultObj.InsuranceSettleNo	;结算号
	.s RtnFlg="0"
	e  d
	.s RtnFlg="-1"
	b ;saveto
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	
	q RtnFlg
}

/// 功能说明：获取XML文件头部声明部分
ClassMethod GetXMLTitle(Version As %String = "") As %String
{
	q "<?xml version=""1.0"" encoding=""UTF-8""?>"
}

}
