/// 徐州中心电子发票接口（接口公司-江苏启航开创软件）
Class BILL.EINV.ADP.JSC Extends %RegisteredObject
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
	s outData=##class(BILL.EINV.BI.JSC.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用江苏启航开创软件http接口
    s OutJsonStream=""
    s ResponseData=##class(BILL.EINV.DTO.JSC.EInvInvoiceRes).%New()
    s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
	if (Rtn="0") {
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
		s QueryoutData=##class(BILL.EINV.BI.JSC.HTTPRequest).InvoiceRequest(Message, InvociePam.ObjUPConfig)	;调用吾爱科技http接口
        s OutJsonStream=""
        s ResponseData=##class(BILL.EINV.DTO.JSC.EInvInvoiceRes).%New()
        s Rtn=..DecryptionResult(outData,OutJsonStream,ResponseData)
		 ;获取开票状态(01：开票成功 04：冲红成功)	
		if ResponseData.BODY.RCPTLIST.invoicestatus'="01" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}else{
			s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail,ResponseData)
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
   s invobj=##class(BILL.EINV.DTO.JSC.EInvInvoiceReq).%New()
   s HeaderObj=##class(BILL.EINV.DTO.JSC.EInvHeadData).%New()
   
   s HeaderObj.MODULE=""
   s HeaderObj.CZLX=""
   s HeaderObj.TYPE=""
   s HeaderObj.SOURCE=""
   
   s BodyObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceCom).%New()
   s BodyObj.HOSID=""   ;医疗结构
   s BodyObj.appid=""   ;业务服务的编码，一个医疗机构有多个专用业务系统时通过app_id区分
   s BodyObj.Rcptno=""  ;HIS自己的发票号码
   s BodyObj.Sftype=""  ;收费类型（1 门诊 2住院）
   s BodyObj.totalamount=""        ;总金额
   s BodyObj.payerpartytype="1"    ;交款人类型 ;1:个人  2:单位
   s BodyObj.payerpartycode=""     ;患者身份证号码
   s BodyObj.payerpartyname=""     ;患者名称
   s BodyObj.recname=""     ;收款人全称
   s BodyObj.recacct=""
   s BodyObj.recopbk=""
   s BodyObj.payeracct=""
   s BodyObj.payeropbk=""
   s BodyObj.paymode=""
   s BodyObj.bizcode=""
   s BodyObj.currencytype=""
   s BodyObj.exchangerate=""
   s BodyObj.remark=""
   s BodyObj.handlingperson=""
   s BodyObj.checker=""
   s BodyObj.supervisorremark=""
   s MainExtObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceMainext).%New()
   s MainExtObj.relatedinvoicecode=""
   s MainExtObj.relatedinvoicenumber=""
   s MainExtObj.paycode=""
   s BodyObj.mainext=MainExtObj
   
   //票据明细信息
   f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
   .s detailObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceDetailitemlist).%New()
   .s detailObj.itemcode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code
   .s detailObj.itemname=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc
   .s detailObj.itemamount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt
   .s detailObj.unit=""
   .s detailObj.num="1"
   .s detailObj.stdtype=""
   .s ItemExtObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceDetailItemext).%New()
   .s ItemExtObj.selfamt=""
   .s ItemExtObj.remark=""
   .s detailObj.Itemext=ItemExtObj
   .d BodyObj.detailitemlist.Insert(detailObj)
   
   ///辅助明细信息，数组
   s BodyObj.auxitemlist=""
   
   ///票据开具后的寄送\通知目的
   s recipientaddrObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceRecipientaddr).%New()
   s recipientaddrObj.email=""
   s recipientaddrObj.telephone=""
   s recipientaddrObj.alipaycode=""
   s recipientaddrObj.wechatorderno=""
   
   ///附加信息，在业务上有特殊要求的在此协商增加扩展参数，格式一般约定为JSON ARRAY格式的字符串。
   s BodyObj.attachinfo=""
   
   ;医疗票相关信息
   s HisInfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceHisinfo).%New()
   s HisInfoObj.cardtype=""
   s HisInfoObj.cardno=""
   s HisInfoObj.biztime=""
   s HisInfoObj.placecode=""
   s HisInfoObj.payee=""
   s HisInfoObj.ylmantype=""
   s HisInfoObj.unitName=""
   s HisInfoObj.insuranceType=""
   s HisInfoObj.insuredSite=""
   s HisInfoObj.medicalLnsuranceNo=""
   s HisInfoObj.personType=""
   s HisInfoObj.treatment=""
   s HisInfoObj.payType=""
   s HisInfoObj.medicalout=""
   
   ///收费信息
   s tradeinfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceTradeinfo).%New()
   s tradeinfoObj.accountpay=""
   s tradeinfoObj.fundpay=""
   s tradeinfoObj.otherfundpay=""
   s tradeinfoObj.ownpay=""
   s tradeinfoObj.cashpay=""
   s tradeinfoObj.chequepay=""
   s tradeinfoObj.transferaccountpay=""
   s tradeinfoObj.cashrecharge=""
   s tradeinfoObj.chequerecharge=""
   s tradeinfoObj.transferrecharge=""
   s tradeinfoObj.cashrefund=""
   s tradeinfoObj.chequerefund=""
   s tradeinfoObj.transferrefund=""
   s tradeinfoObj.acctBalance=""
   s paychannellistObj=##class(BILL.EINV.DTO.JSC.EInvInvoicePaychannellist).%New()
   s paychannellistObj.channelcode=""
   s paychannellistObj.channelamt=""
   s tradeinfoObj.paychannellist=paychannellistObj
   s HisInfoObj.tradeinfo=tradeinfoObj
   
   ///报销信息
   s reimburseinfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceReimburseinfo).%New()
   s reimburseinfoObj.illassist=""
   s reimburseinfoObj.illinsur=""
   s reimburseinfoObj.civilassist=""
   s reimburseinfoObj.medinsur=""
   s reimburseinfoObj.selfpay=""
   s reimburseinfoObj.civilServantNum=""
   s reimburseinfoObj.personAccountPayNum=""
   s reimburseinfoObj.personAccountCareNum=""
    s reimburseinfoObj.cashPayNum=""
   s reimburseinfoObj.cashCareNum=""
   s reimburseinfoObj.personPay=""
   s reimburseinfoObj.inBalance=""
   s reimburseinfoObj.payLevel=""
   s reimburseinfoObj.genFee=""
   s reimburseinfoObj.pubSelf=""
   s reimburseinfoObj.helpSelf=""
   s reimburseinfoObj.supplyPay=""
   s reimburseinfoObj.supplySelf=""
   s reimburseinfoObj.bankAccPay=""
   
   //就诊信息明细
   s BizInfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceBizinfo).%New()
   s BizInfoObj.biztype=""
   s BizInfoObj.medcaretype=""
   s BizInfoObj.medcaretypecode=""
   s BizInfoObj.medinsttype=""
   s BizInfoObj.patientid=""
   s BizInfoObj.sex=""
   s BizInfoObj.age=""
   ///门诊信息， biztype为02、03、04时必填
   s medoutinfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceMedoutinfo).%New()
   s medoutinfoObj.category=""
   s medoutinfoObj.categorycode=""
   s medoutinfoObj.patientno=""
   s medoutinfoObj.caseno=""
   s medoutinfoObj.spdisname=""
   s medoutinfoObj.docno=""
   s medoutinfoObj.docname=""
   s medoutinfoObj.inDisName=""
   s medoutinfoObj.inDisCode="" 
   s BizInfoObj.medoutinfo=medoutinfoObj
   ///住院信息， biztype为01时必填
   s medbedinfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceMedbedinfo).%New()
   s medbedinfoObj.patienttype=""
   s medbedinfoObj.incategory=""
   s medbedinfoObj.incategorycode=""
   s medbedinfoObj.outcategory=""
   s medbedinfoObj.outcategorycode=""
   s medbedinfoObj.hospitalno=""
   s medbedinfoObj.hospitalarea=""
   s medbedinfoObj.hospitalareaout=""
   s medbedinfoObj.bedno=""
   s medbedinfoObj.caseno=""
   s medbedinfoObj.indate=""
   s medbedinfoObj.outdate=""
   s medbedinfoObj.inDisName=""
   s medbedinfoObj.inDisCode=""
   s medbedinfoObj.outDisName=""
   s medbedinfoObj.outDisCode=""
   s medbedinfoObj.outDisName2=""
   s medbedinfoObj.outDisCode2=""
   s medbedinfoObj.outStatus=""
   s medbedinfoObj.inWay=""
   s medbedinfoObj.inNumber=""
   s medbedinfoObj.docno=""
   s medbedinfoObj.docname=""
   s BizInfoObj.medbedinfo=medbedinfoObj
   
   ///挂号信息， biztype为06时必填
   s medreginfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceMedreginfo).%New()
   s medreginfoObj.category=""
   s medreginfoObj.categorycode=""
   s BizInfoObj.medreginfo=medreginfoObj
   
   ///体检信息， biztype为05时必填
   s medexaminfoObj=##class(BILL.EINV.DTO.JSC.EInvInvoiceMedexaminfo).%New()
   s medexaminfoObj.category=""
   s medexaminfoObj.categorycode=""
   s medexaminfoObj.examno=""
   s BizInfoObj.medexaminfo=medexaminfoObj
   s HisInfoObj.bizinfo=BizInfoObj
   
   ///医疗清单明细
   f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
   .s meditemlist=##class(BILL.EINV.DTO.JSC.EInvInvoiceMeditemlist).%New()
   .s meditemlist.listno=""
   .s meditemlist.chrgtypecode=""
   .s meditemlist.chrgtypename=""
   .s meditemlist.itemcode=""
   .s meditemlist.itemname=""
   .s meditemlist.unit=""
   .s meditemlist.std=""
   .s meditemlist.num=""
   .s meditemlist.amt=""
   .s meditemlist.selfamt=""
   .s meditemlist.receivableamt=""
   .s meditemlist.medcareitemtype=""
   .s meditemlist.medreimburserate=""
   .s meditemlist.remark=""
   .s meditemlist.itemgg=""
   .s meditemlist.zfrate=""
   .s meditemlist.zfsx=""
   .s meditemlist.zfje=""
   .s meditemlist.zlje=""
   .s meditemlist.recipeNum=""
   .s meditemlist.recipeSerialNum=""
   .s meditemlist.recipeDate=""
   .s meditemlist.centreChargeCode=""
   .s meditemlist.medicareFeeitemName=""
   .s meditemlist.formulation=""
   .s meditemlist.deptNum=""
   .s meditemlist.deptName=""
   .s meditemlist.doctorCode=""
   .s meditemlist.doctorName=""
   .s meditemlist.updateBy=""
   .s meditemlist.execDeptName=""
   .s meditemlist.itemLevel=""
   .s meditemlist.itemId=""
   .s meditemlist.orderType=""
   .s meditemlist.billNum=""
   .d HisInfoObj.meditemlist.Insert(meditemlist)
	
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.JSC.EInvInvoiceRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj.BODY.RCPTLIST.issuedate						;返回日期"20191217"
	s createDate=$zdh(createDate,8)
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.BODY.CLBZ					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMegObj.BODY.CLJG				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.BODY.RCPTLIST.invoicecode      ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.BODY.RCPTLIST.invoicenumber     ;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.BODY.RCPTLIST.rcptno                 ;校验码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.BODY.RCPTLIST.invoiceurl		;电子票据H5页面URL
	s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.BODY.RCPTLIST.invoicingpartyname    ;开票单位名称
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.BODY.RCPTLIST.invoicestatus    ;开票状态
	s ObjInvUpDetail.IUDBusNo=ResultMegObj.BODY.RCPTLIST.bizcode        ;开票流水号
    s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s RtnFlg="0"
	
	q RtnFlg
}

/// 功能说明：设置红票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ResultMegObj As BILL.EINV.DTO.JSC.EInvolidRes) As %String
{
	s RtnFlg="-1"
	
	//对返回结果的时间戳进行分割
	s createDate=ResultMegObj.BODY.RCPTLIST.issuedate						;返回日期"20191217"
	s createDate=$zdh(createDate,8)
	s ObjInvUpDetail.IUDResultCode=ResultMegObj.BODY.CLBZ					;处理结果代码
	s ObjInvUpDetail.IUDResultMeg=ResultMegObj.BODY.CLJG				;详细信息
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.BODY.RCPTLIST.invoicecode      ;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.BODY.RCPTLIST.invoicenumber     ;电子票据号码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.BODY.RCPTLIST.invoiceurl		;电子票据H5页面URL
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.BODY.RCPTLIST.invoicestatus    ;开票状态
    s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="红冲成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s RtnFlg="0"
	
	q RtnFlg
}

/// 查询状态
ClassMethod QueryCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ResponseData As BILL.EINV.DTO.JSC.EInvInvoiceRes) As %String
{
	s rtn=""
   //票据信息
   s invobj=##class(BILL.EINV.DTO.JSC.EInvComBody).%New()
   s invobj.HOSID=""
   s invobj.APPID=""
   s invobj.invoicecode=""
   s invobj.invoicenumber=""	
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
   s invobj=##class(BILL.EINV.DTO.JSC.EInvolidReq).%New()
   s HEADERObj=##class(BILL.EINV.DTO.JSC.EInvalidHeaderReq).%New()
   s HEADERObj.MODULE=""
   s HEADERObj.SOURCE=""
   s HEADERObj.TYPE=""
   s HEADERObj.CZLX=""
   s invobj.HEADER=HEADERObj
   s BODYObj= ##class(BILL.EINV.DTO.JSC.EInvalidBodyReq).%New()
   s BODYObj.APPID=""
   s BODYObj.HOSID=""
   s RCPTLISTObj=##class(BILL.EINV.DTO.JSC.EInvalidDataReq).%New()
   s RCPTLISTObj.invoicecode=""
   s RCPTLISTObj.invoicenumber=""
   s RCPTLISTObj.Sftype=""
   s RCPTLISTObj.applyuserid=""
   s RCPTLISTObj.applyusername=""
   s BODYObj.RCPTLIST=RCPTLISTObj
   s invobj.BODY=BODYObj
   //调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明： 对第三方返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.JSC).DecryptionResult("","")
ClassMethod DecryptionResult(Response, ByRef ErrMsg As %String, ByRef ResultObj As BILL.EINV.DTO.JSC.EInvInvoiceRes) As %String
{
	s Rtn="-1"
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Response)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.BODY.CLBZ
	s ErrMsg=ResultObj.BODY.CLJG
	q Rtn
}

}
