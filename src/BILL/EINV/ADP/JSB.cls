/// 江苏南通电子发票
Class BILL.EINV.ADP.JSB Extends %RegisteredObject
{

/// 功能说明：调用开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-05-24  新做成         
/// 其    他：w ##class(BILL.EINV.ADP.JSB).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" "-1"   ;组织入参发生错误
	
	s Message=InputJson									;业务入参
	s outData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用吾爱科技http接口
    s OutJsonStream=""
    s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
	if (Rtn="00000") {
		 s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail,ResponseData)
		
	}else{
		 s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
		 s ObjInvUpDetail.IUDResultMeg=OutJsonStream     ;错误信息描述
		 s InvociePam.ErrMsgInfo=OutJsonStream
		 s RtnFlag="-1"
	}
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){ 
		;如果开具成功，开始调用查询交易查询开票状态
		s InputJson=..QueryCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,ResponseData)
		q:InputJson="" "-1"   ;组织入参发生错误
		s QueryoutData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用吾爱科技http接口
        s OutJsonStream=""
        s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
        s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
		 ;获取开票状态(01：开票成功 04：冲红成功)	
		if ResponseData."invoice_status"'="01" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：guoyunlong   2020-05-24  
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	;接口服务名称
	s InputJson=..InvalidCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputJson="" RtnFlag 
	
	s Message=InputJson									;业务入参
	s outData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用http接口
	s OutJsonStream=""
    s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)     ;对返回结果进行解密
	if (Rtn="00000") {
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail,OutJsonStream)  ;;把红冲开票结果信息保存到交易表
	}else{
		//s ObjInvUpDetail.IUDResultCode=Rtn                	;错误信息编码
		//s ObjInvUpDetail.IUDResultMeg=OutJsonStream     	;错误信息描述
		//s InvociePam.ErrMsgInfo=OutJsonStream
		s RtnFlag="-1"
		//s RtnFlag="0"
	}
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){ 
		;如果开具成功，开始调用查询交易查询开票状态
		s InputJson=..QueryCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,ResponseData)
		q:InputJson="" "-1"   ;组织入参发生错误
		s QueryoutData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用吾爱科技http接口
        s OutJsonStream=""
        s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
        s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
		 ;获取开票状态(01：开票成功 04：冲红成功)	
		if ResponseData."invoice_status"'="04" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	q RtnFlag
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong   2020-05-24 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ResponseData As BILL.EINV.DTO.JSB.EInvInvoiceRes) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryCom(ObjInvUpDetail,ObjInvPrtInfo, InvociePam,ResponseData)
    q:InputJson="" RtnFlag 
	s Message=InputJson									;业务入参
	
	//调用http接口
	s outData=##class(BILL.EINV.BI.JSB.HTTPRequest).InvoiceRequest( Message, InvociePam.ObjUPConfig)	
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s ResponseData=##class(BILL.EINV.DTO.JSB.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)     ;对返回结果进行解密 
	i Rtn="00000"  d 
	.s ObjInvUpDetail.IUDBillBatchName=ResponseData.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResponseData."invoice_status"			;状态
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="I"										;发票状态
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResponseData."invoice_code"	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResponseData."invoice_number"		;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResponseData.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end
	.s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="00000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 组织开具接口参数
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSB.EInvInvoiceReq).%New()
   s invobj.method="Invoicehisissue"     ;开具接口方法名
   s invobj."channel_code"=""
   s invobj."org_code"=""
   s invobj.timestamp=..GetBusDate($zd(+$h,3), $zt($p($h,",",2),1))   ;开票时间
   s invobj.sign=##class(web.Util.Encryption).MD5HexStr($zcvt("Invoicehisissue"_invobj.timestamp,"O","UTF8"))  ;MD5加密
   s invobj."invoice_type_code"=""
   s invobj."total_amount"=ObjInvPrtInfo.InvAmt
   s invobj."rec_name"=""
   s invobj."rec_acct"=""
   s invobj."rec_opbk"=""
   s invobj."payer_party_type"="1"
   s invobj."payer_party_code"=ObjInvPrtInfo.PatBaseInfo.PatID
   s invobj."payer_party_name"=ObjInvPrtInfo.PatBaseInfo.PatName
   s invobj."payer_acct"=""
   s invobj."payer_opbk"=""
   s invobj.paymode=""
   s invobj.bizcode=ObjInvUpDetail.IUDBusNo
   s invobj."currency_type"=""
   s invobj."exchange_rate"=""
   s invobj.remark=""
   s invobj."handling_person"=InvociePam.UserDesc
   s invobj.checker=""
   s invobj."supervisor_remark"=""
   s invobj."main_ext"."pay_code"=""
   
   //票据明细信息
   f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
   .s detailObj=##class(BILL.EINV.DTO.JSB.EInvDetailList).%New()
   .s detailObj."item_code"=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code
   .s detailObj."item_name"=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc
   .s detailObj."item_amount"=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt
   .s detailObj.unit=""
   .s detailObj.num="1"
   .s detailObj.stdtype=""
   .s detailObj.Itemext."self_amt"=""
   .s detailObj.Itemext.remark=""
   .d invobj."detail_item_list".Insert(detailObj)
   
   s invobj."aux_item_list"=""
   s invobj."recipient_addr".email=ObjInvPrtInfo.PatBaseInfo.PatEmail
   s invobj."recipient_addr".telephone=ObjInvPrtInfo.PatBaseInfo.Mobphone
   s invobj."recipient_addr"."alipay_code"=""
   s invobj."recipient_addr"."wechat_orderno"=""
   
   s invobj."attach_info"=""
   
   s invobj."his_info"."card_type"=ObjInvPrtInfo.PatBaseInfo.CardType
   s invobj."his_info"."card_no"=ObjInvPrtInfo.PatBaseInfo.CardNo
   s invobj."his_info".biztime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)
   s invobj."his_info"."place_code"=InvociePam.UserCode
   s invobj."his_info".payee=InvociePam.UserDesc
   s invobj."his_info"."trade_info"."account_pay"=""
   s invobj."his_info"."trade_info"."fund_pay"=""
   s invobj."his_info"."trade_info"."otherfund_pay"=""
   s invobj."his_info"."trade_info"."own_pay"=""
   s invobj."his_info"."trade_info"."cash_pay"=""
   s invobj."his_info"."trade_info"."cheque_pay"=""
   s invobj."his_info"."trade_info"."transfer_account_pay"=""
   s invobj."his_info"."trade_info"."cash_recharge"=""
   s invobj."his_info"."trade_info"."cheque_recharge"=""
   s invobj."his_info"."trade_info"."transfer_recharge"=""
   s invobj."his_info"."trade_info"."cash_refund"=""
   s invobj."his_info"."trade_info"."cheque_refund"=""
   s invobj."his_info"."trade_info"."transfer_refund"=""
   s invobj."his_info"."trade_info"."acct_Balance"=""
   
   f i=1:1:ObjInvPrtInfo.PayModeInfo.Size  d
   .s channellistObj=##class(BILL.EINV.DTO.JSB.EInvPayChannelList).%New()
   .s channellistObj."channel_amt"=ObjInvPrtInfo.PayModeInfo.GetAt(i).Amt
   .s channellistObj."channel_code"=ObjInvPrtInfo.PayModeInfo.GetAt(i).Code
   .d invobj."his_info"."trade_info"."pay_channel_list".Insert(channellistObj)
   
   ;医保分解金额，根据项目实际保存情况修改
   s invobj."his_info"."reimburse_info"."ill_assist"=""
   s invobj."his_info"."reimburse_info"."ill_insur"=""
   s invobj."his_info"."reimburse_info"."civil_assist"=""
   s invobj."his_info"."reimburse_info"."med_insur"=""
   s invobj."his_info"."reimburse_info"."self_pay"=""
   
   s invobj."his_info".bizinfo.biztype=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType,InvociePam.ObjUPConfig)	 ;业务标识
   s invobj."his_info".bizinfo.biztype=""    ;业务类型
   s invobj."his_info".bizinfo."medcare_type"=""
   s invobj."his_info".bizinfo."medcare_type_code"=""
   s invobj."his_info".bizinfo."med_inst_type"=""
   s invobj."his_info".bizinfo."patient_id"=ObjInvPrtInfo.PatBaseInfo.PatID
   s invobj."his_info".bizinfo."patient_name"=ObjInvPrtInfo.PatBaseInfo.PatName
   s invobj."his_info".bizinfo."patient_id_no"=ObjInvPrtInfo.PatBaseInfo.PAPMINO
   s invobj."his_info".bizinfo.sex=ObjInvPrtInfo.PatBaseInfo.Sex
   s invobj."his_info".bizinfo.age=ObjInvPrtInfo.PatBaseInfo.Age
   
   
   s invobj."his_info".bizinfo."med_outinfo".category=ObjInvPrtInfo.PatAdmInfo.DepDesc
   s invobj."his_info".bizinfo."med_outinfo"."category_code"=ObjInvPrtInfo.PatAdmInfo.DepCode
   s invobj."his_info".bizinfo."med_outinfo"."patient_no"=ObjInvPrtInfo.PatAdmInfo.AdmNo
   s invobj."his_info".bizinfo."med_outinfo"."case_no"=""
   s invobj."his_info".bizinfo."med_outinfo"."sp_dis_name"=""
   
   s invobj."his_info".bizinfo."med_bedinfo"."patient_type"=""
   s invobj."his_info".bizinfo."med_bedinfo"."in_category"=ObjInvPrtInfo.PatAdmInfo.DepDesc
   s invobj."his_info".bizinfo."med_bedinfo"."in_category_code"=ObjInvPrtInfo.PatAdmInfo.DepCode
   s invobj."his_info".bizinfo."med_bedinfo"."out_category"=ObjInvPrtInfo.PatAdmInfo.OutDepDesc
   s invobj."his_info".bizinfo."med_bedinfo"."out_category_code"=ObjInvPrtInfo.PatAdmInfo.OutDepCode
   s invobj."his_info".bizinfo."med_bedinfo"."hospital_no"=ObjInvPrtInfo.PatAdmInfo.MedicalCode
   s invobj."his_info".bizinfo."med_bedinfo"."hospital_area"=ObjInvPrtInfo.PatAdmInfo.WardDesc
   s invobj."his_info".bizinfo."med_bedinfo"."bed_no"=ObjInvPrtInfo.PatAdmInfo.BedCode
   s invobj."his_info".bizinfo."med_bedinfo"."case_no"=""
   s invobj."his_info".bizinfo."med_bedinfo"."in_date"=ObjInvPrtInfo.PatAdmInfo.AdmDate
   s invobj."his_info".bizinfo."med_bedinfo"."out_date"=ObjInvPrtInfo.PatAdmInfo.OutDate
   s invobj."his_info".bizinfo."med_bedinfo".hospitalDays=ObjInvPrtInfo.PatAdmInfo.IPDays
   
    
   s invobj."his_info".bizinfo."med_reginfo".category=ObjInvPrtInfo.PatAdmInfo.DepDesc
   s invobj."his_info".bizinfo."med_reginfo"."category_code"=ObjInvPrtInfo.PatAdmInfo.DepCode
   
   
   s invobj."his_info".bizinfo."med_examinfo".category=ObjInvPrtInfo.PatAdmInfo.DepDesc
   s invobj."his_info".bizinfo."med_examinfo"."category_code"=ObjInvPrtInfo.PatAdmInfo.DepCode
   s invobj."his_info".bizinfo."med_examinfo"."exam_no"=""
   
   
   //清单项目明细
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s MeditemlistObj=##class(BILL.EINV.DTO.JSB.EInvMeditemlist).%New()
	.s MeditemlistObj."chrg_type_code"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode
	.s MeditemlistObj."chrg_type_name"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc
	.s MeditemlistObj."item_code"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode
	.s MeditemlistObj."item_name"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc
	.s MeditemlistObj.unit=""
	.s MeditemlistObj.std=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price
	.s MeditemlistObj.num=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty
	.s MeditemlistObj.amt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt
	.s MeditemlistObj."self_amt"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).SelfAmt
	.s MeditemlistObj."receivable_amt"=""
	.s MeditemlistObj."medcare_item_type"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Insuxmlb
	.s MeditemlistObj."med_reimburse_rate"=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Insutjdm
	.s MeditemlistObj.remark=""
	.d invobj."his_info"."med_item_list".Insert(MeditemlistObj)
	
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 组织红冲接口参数
ClassMethod InvalidCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
   s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSB.EInvInvalidReq).%New()
   s invobj.method="Invoicehiswriteoff"
   s invobj."channel_code"=""
   s invobj."org_code"=""
   s invobj.timestamp=..GetBusDate($zd(+$h,3), $zt($p($h,",",2),1))   ;开票时间
   s invobj.sign=##class(web.Util.Encryption).MD5HexStr($zcvt("Invoicehisissue"_invobj.timestamp,"O","UTF8"))  ;MD5加密
   s invobj."total_amount"=ObjInvPrtInfo.InvAmt
   s invobj."rec_name"=ObjInvPrtInfo.BusUserDesc
   s invobj."rec_acct"=""
   s invobj."rec_opbk"=""
   s invobj."payer_party_type"="1"         ;/// 交款人类型  1:个人 2:单位
   s invobj."payer_party_code"=ObjInvPrtInfo.PatBaseInfo.PatID
   s invobj."payer_party_name"=ObjInvPrtInfo.PatBaseInfo.PatName
   s invobj."payer_acct"=""
   s invobj."payer_opbk"=""
   s invobj.paymode=""
   s invobj.bizcode=ObjInvUpDetail.IUDBusNo
   s invobj."currency_type"=""
   s invobj."exchange_rate"=""
   s invobj.remark=""
   s invobj."handling_person"=InvociePam.UserDesc        ;开票人
   s invobj.checker=""
   s invobj."supervisor_remark"=""
   s invobj."main_ext"."related_invoice_code"=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode
   s invobj."main_ext"."related_invoice_number"=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo
   s invobj."main_ext"."pay_code"=""
   
   f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
   .s detailObj=##class(BILL.EINV.DTO.JSB.EInvDetailList).%New()
   .s detailObj."item_code"=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code
   .s detailObj."item_name"=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc
   .s detailObj."item_amount"=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt
   .s detailObj.unit=""
   .s detailObj.num="1" 
   .s detailObj.stdtype=""
   .s detailObj.Itemext."self_amt"=""
   .s detailObj.Itemext.remark=""
   .d invobj."detail_item_list".Insert(detailObj)
   
   s invobj."aux_item_list"=""
   s invobj."recipient_addr".email=ObjInvPrtInfo.PatBaseInfo.PatEmail
   s invobj."recipient_addr".telephone=ObjInvPrtInfo.PatBaseInfo.Mobphone
   s invobj."recipient_addr"."alipay_code"=""
   s invobj."recipient_addr"."wechat_orderno"=""
   
    s invobj."attach_info"=""
   
   //调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 单条查询状态
ClassMethod QueryCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ResponseData As BILL.EINV.DTO.JSB.EInvInvoiceRes) As %String
{
	s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSB.EInvQueryOnlyReq).%New()
   s invobj.method="Invoicequery"
   s invobj."channel_code"=""
   s invobj."org_code"=""
   s invobj.timestamp=..GetBusDate($zd(+$h,3), $zt($p($h,",",2),1))   ;开票时间
   s invobj.sign=##class(web.Util.Encryption).MD5HexStr($zcvt("Invoicehisissue"_invobj.timestamp,"O","UTF8"))  ;MD5加密
   s invobj."invoice_code"=ResponseData."invoice_code"
   s invobj."invoice_number"=ResponseData."invoice_number"
	
   //调用固定方法进行对象转Json
   s Stream=##class(%GlobalCharacterStream).%New()
   d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
   s rtn=Stream.Read()
   q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.JSB.EInvInvoiceRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj."issue_date"						;返回日期"20191217"
	s createDate=$zdh(createDate,8)
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.result					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMegObj.information				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj."invoice_code"       ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj."invoice_number"       ;电子票据号码
	s ObjInvUpDetail.IUDBillBatchName=ResultMegObj."invoicing_party_name"    ;开票单位名称
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj."invoice_status"    ;开票状态
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.random                    ;校验码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj."invoice_url"			;电子票据H5页面URL
	
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：设置红冲开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
/// 编写：    guoyunlong
/// 时间：    2019-09-20
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.PO.InvUpDetails, ResultMegObj As BILL.EINV.DTO.JSB.EInvInvoiceRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s createTime=ResultMegObj."issue_date"
	s createDateTime=$e(createTime,1,$l(createTime)-3)
	s createDate=$zdh($e(createDateTime,1,8),8)
	s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.eScarletBillBatchCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.eScarletBillNo				   ;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.eScarletRandom					;电子校验码
	s ObjInvUpDetail.IUDCreatDate=createDate									;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=createTime									;;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.billQRCode						;电子票据二维码图片数据				
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.pictureUrl						;电子票据H5页面URL
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：   通过日期时间获取对应的第三方上传时间格式
/// 入参：       Date：日期
/// 				 Time: 时间
/// 出参：       第三方接口对应的上传时间格式(格式：yyyyMMddHHmmssSSS)
ClassMethod GetBusDate(Date, Time) As %String
{
	s rtnDate=""
	i Date'["-" d  s Date=$zd(Date,3)
	i Time'[":" d  s Time=$zt(Time,1)
	s rtnDate=$replace(Date,"-","")_$replace(Time,":","")
	q rtnDate
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.JSB).DecryptionResult("","")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String, ByRef ResultObj As BILL.EINV.DTO.JSB.EInvInvoiceRes) As %String
{
	s Rtn="-1"
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.result
	s ErrMsg=ResultObj.information
	q Rtn
}

/// 功能说明：   通过HIs就诊类型获取对应的第三方的业务标识
/// 入参：       AdmType：就诊类型
/// (REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金) 
/// 出参：       第三方接口对应的业务标识
/// 编写：       guoyunlong
/// 备注说明：   目前根据就诊类型和第三方接口文档里面提供的业务标识在程序里面进行匹配
ClassMethod GetBusTypeByAdmType(AdmType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	//s BusType=$Case(AdmType,"IP":"01","OP":"02","API":"02","OT":"02","IT":"01","PE":"05","REG":"06","DEP":"07",:0)    				 
    s BusType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessTypeCon"_ObjUPConfig.FactoryCode,AdmType,5)
    q BusType
}

}
