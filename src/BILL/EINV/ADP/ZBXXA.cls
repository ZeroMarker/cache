/// 中博信息有限公司
Class BILL.EINV.ADP.ZBXXA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：guoyunlong  2021-04-20
/// 其    他：w ##class(BILL.EINV.ADP.ZBXXA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
    s $zt="InvoiceErr"
	s StatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据流水号查询是否存在已经已经开具的电子票据
	q:StatusRtn="0" RtnFlag  ;存在的开具记录的时 获取结果直接返回
	
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)  ;组织开具电子票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[开具电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	s ServiceCode="EInvoiceSynService"		;服务名称
	s ResOutput=##class(BILL.EINV.DTO.ZBXXA.EInvoiceRes).%New()  ;接收返回
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.ZBXXA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput)	;调用富深http接口
	if (SRVRtnFlg="0"){
	  s ObjInvUpDetail.IUDBillBatchCode=ResOutput.EInvoiceList.EInvoiceCode    ;电子票据代码
	  s ObjInvUpDetail.IUDBillBatchNo=ResOutput.EInvoiceList.EInvoiceNumber    ;电子票据号码
	  s ObjInvUpDetail.IUDDate=$zdh(ResOutput.EInvoiceList.IssueDate ,3)              ;开票日期
	  s ObjInvUpDetail.IUDPictureUrl=ResOutput.EInvoiceList.PdfUrl             ;板式文件地址
	  s ObjInvUpDetail.Xstr1=ResOutput.EInvoiceList.TotalAmount                ;开票金额
	  ;中博接口只是单纯的查询电子票据数据，没有票据状态信息，有必要查询吗？？？待确定  guoyunlong 2021-07-31
	  ;s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取开票状态信息
	  ;s:InvStatusRtn'="0" RtnFlag="0"
	  s ObjInvUpDetail.IUDCreatDate=$zdh(ResOutput.EInvoiceList.IssueDate ,3)							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
	  s ObjInvUpDetail.IUDCreatTime=""							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
	  s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	  s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
	  s ObjInvUpDetail.EInvFlg="I"
	}else{ 
	   //;为开票失败或异常，不能进行后续的开票状态查询。
	   s Errmsg="电子票据开具失败！"
	   s RtnFlag="-1"
	}		
	q RtnFlag
InvoiceErr
    s $zt=""
    s RtnFlag="-1"
    q RtnFlag
}

/// 功能说明：整理电子票据开具组织入参(住院、门诊公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 		  PayAdmType        --> 票据业务类型
/// 返 回 值：返回接口文档对应的json格式
/// 修改履历：guoyunlong 2021-04-20
/// 其    他：w ##class(BILL.EINV.ADP.ZBXXA).InvoiceCom("","","","1") 
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
     //票据信息  
	s invobj=##class(BILL.EINV.DTO.ZBXXA.EInvoiceReq).%New()
	s invobj.REQUESTID=ObjInvUpDetail.IUDBusNo   ;开具请求流水号
	s invobj.BizCode=ObjInvUpDetail.IUDBusNo  ;业务流水号
	s invobj.InvoiceType=""     ;票据种类代码  门诊：1,住院：2 
    s invobj.ArrearsMarking=""    ;欠费标识
    s invobj.InvoicingPartyCode=""    ;开票单位代码	String	30	开票单位社会信用代码
    s invobj.InvoicingPartyName=""    ;开票单位名称	String	100
    s invobj.PlaceCode=""     ;开票点编号	String	20	如果是多院区，此处为院区编号，如果冲红，此项可为空
    s invobj.PayerPartyType="1"   ;交款人类型	String	1	1:个人2:单位
    s invobj.PayerPartyCode=""  ;交款人代码	String	30	单位为社会信用代码个人一般为身份证号
    s invobj.PayerPartyName=ObjInvPrtInfo.PatBaseInfo.PatName   ;交款人名称	String	200
    s invobj.TotalAmount=ObjInvPrtInfo.InvShareAmt  ;总金额	Currency
    s invobj.Remark=""   ;备注字段
    s invobj.HandlingPerson=ObjInvPrtInfo.BusUserDesc      ;收款人名称	String	100
    s invobj.Checker=ObjInvPrtInfo.BusUserDesc   ;复核人名称	String	20 
    s invobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex    ;性别	String	2
    s invobj.SmsPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone  ;交款人手机号	String	20	用于电子票据短信通知
    s invobj.SmsEmail=ObjInvPrtInfo.PatBaseInfo.PatEmail   ;交款人邮箱	String	100
   
	//项目信息
	f index=1:1:ObjInvPrtInfo.InvCateInfo.Size d
	.s detailslistobj=##class(BILL.EINV.DTO.ZBXXA.EInvDetails).%New()
	.s detailslistobj.ItemNO=index
	.s detailslistobj.ItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(index).Code		;项目编码
	.s detailslistobj.ItemName=ObjInvPrtInfo.InvCateInfo.GetAt(index).Desc		;项目名称
	.s detailslistobj.ItemQuantity="1" 										;数量
	.s detailslistobj.ItemUnit=""											;单位
	.s detailslistobj.ItemAmount=ObjInvPrtInfo.InvCateInfo.GetAt(index).Amt		;金额
	.s detailslistobj.ItemRemark=""											;项目备注
	.d invobj.Details.Insert(detailslistobj)
	
	//项目清单
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s auxdetailslistobj=##class(BILL.EINV.DTO.ZBXXA.EInvAuxDetails).%New()
	.s auxdetailslistobj.AuxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;收费明细项目名称
	.s auxdetailslistobj.AuxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	.s auxdetailslistobj.AuxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	.d invobj.AuxDetails.Insert(auxdetailslistobj)
	
	
	///票面其他信息
    s ObjPatieentObj=##class(BILL.EINV.DTO.ZBXXA.EInvOtherInfo).%New()
    s ObjPatieentObj.OutpatientCode=ObjInvPrtInfo.PatAdmInfo.AdmNo   ;门诊号	String	30	
    s ObjPatieentObj.VisitingTime=ObjInvPrtInfo.PatAdmInfo.AdmDate   ;就诊日期	Date
   
    
    s ObjPatieentObj.MedInstitutionType=""   ;医疗机构类型
    s ObjPatieentObj.MedInsuranceType=""  ;医保类型	String	30
    s ObjPatieentObj.MedInsuranceCode=ObjInvPrtInfo.InsuDivInfo.InsuId  ;医保编号	String	30	参保人在医保系统中的唯一标识（医保号）
   
    s ObjPatieentObj.Sex=ObjInvPrtInfo.PatBaseInfo.Sex
   
    s ObjPatieentObj.MedInsurancePay=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0  ;医保统筹基金支付
    s ObjPatieentObj.OtherPay="" ;ObjInvPrtInfo.InsuDivInfo  ;其他支付
    s ObjPatieentObj.PersonalAccountPay=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0  ;个人账户支付
    s ObjPatieentObj.PersonalCashPay=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0  ;;个人现金支付
    s ObjPatieentObj.PersonalPay=ObjInvPrtInfo.InsuDivInfo.SelfAmt  ;个人自付
    s ObjPatieentObj.PersonalExpense=ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt  ;个人自费
    
    s ObjPatieentObj.MedRecordNO =ObjInvPrtInfo.PatAdmInfo.MedicalCode  ;病例号	String	50	病历号
    s ObjPatieentObj.HosptztNumber=ObjInvPrtInfo.PatAdmInfo.IPNo    ;住院号
    s ObjPatieentObj.HosptztDepartment=ObjInvPrtInfo.PatAdmInfo.DepDesc  ;科室名称	String	50
    s ObjPatieentObj.HosptztDate=ObjInvPrtInfo.PatAdmInfo.AdmDate  ;住院日期
    s ObjPatieentObj.PrepaidAmount=ObjInvPrtInfo.RecAmt   ;预缴金额
    s ObjPatieentObj.SupplementAmount=ObjInvPrtInfo.RefAmt  ;补缴金额
    s ObjPatieentObj.RefundAmount=""	;退费金额
    s invobj.OtherInfo=ObjPatieentObj    ;门诊票据
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	;组织开票参数
    s EInvDataObj=##class(BILL.EINV.DTO.ZBXXA.EInvComData).%New()
    s EInvDataObj.ifCode="EInvoiceSynService"   ;开具接口参数
    s EInvDataObj.ifUser="his"
    s EInvDataObj.ifPwd="123"
    s EInvDataObj.randKey=$l(rtn)
    s EInvDataObj.jsonData=rtn
    
    s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvDataObj,.Stream)
	s EInvData=Stream.Read()
	q EInvData
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong  2021-04-10
/// 其    他：w ##class(BILL.EINV.ADP.ZBXXA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s $zt="GetInvStatusOfInvoiceErr"
	s RtnFlag="-1"	
	s InputJson="{""BizCode"":"_ObjInvUpDetail.IUDBusNo_",""InvoicingPartyCode"":"_ObjInvUpDetail.IUDBusNo_"}"		;流水号 
	;组织开票参数
    s EInvDataObj=##class(BILL.EINV.DTO.ZBXXA.EInvComData).%New()
    s EInvDataObj.ifCode="EInvoiceQueryService"   ;电子票据查询接口
    s EInvDataObj.ifUser="his"
    s EInvDataObj.ifPwd="123"
    s EInvDataObj.randKey=$l(InputJson)
    s EInvDataObj.jsonData=InputJson
    s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvDataObj,.Stream)
	s ReqJsonStr=Stream.Read()   		;业务入参
	
	s ServiceCode="EInvoiceQueryService"     ;接口服务名称

	s ResOutput=##class(BILL.EINV.DTO.ZBXXA.EInvoiceRes).%New()    ;接收返回
	//调用诺诺网接口
	s SRVRtnFlg=##class(BILL.EINV.BI.ZBXXA.HTTPRequest).InvoiceRequest(ServiceCode, ReqJsonStr, InvociePam, .ResOutput)
	//获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg=0){	
	  s ObjInvUpDetail.IUDBillBatchCode=ResOutput.EInvoiceList.EInvoiceCode    ;电子票据代码
	  s ObjInvUpDetail.IUDBillBatchNo=ResOutput.EInvoiceList.EInvoiceNumber    ;电子票据号码
	  s ObjInvUpDetail.IUDDate=$zdh(ResOutput.EInvoiceList.IssueDate ,3)              ;开票日期
	  s ObjInvUpDetail.IUDPictureUrl=ResOutput.EInvoiceList.PdfUrl             ;板式文件地址
	  s ObjInvUpDetail.Xstr1=ResOutput.EInvoiceList.TotalAmount                ;开票金额
	  s ObjInvUpDetail.IUDCreatDate=$zdh(ResOutput.EInvoiceList.IssueDate ,3)							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
	  s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
	  s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	  s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
	  s ObjInvUpDetail.EInvFlg="I"								   ;发票状态
	  s RtnFlag="0"
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="查询开票结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	q RtnFlag
GetInvStatusOfInvoiceErr
    s $zt=""
    s RtnFlag="-1"
    q RtnFlag
}

/// 功能说明：电子票据红冲接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：guoyunlong  2021-04-20
/// 其    他：w ##class(BILL.EINV.ADP.ZBXXA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
    s $zt="InvalidErr"
	s InputJson=..InvalidCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)  ;组织开具电子票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[红冲电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	s ServiceCode="issueEInvoiceRecord.do"		;服务名称
	s ResOutput=##class(BILL.EINV.DTO.ZBXXA.EInvalidRes).%New()  ;接收返回
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.ZBXXA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, .ResOutput)	;调用富深http接口
	if (SRVRtnFlg="0"){
	  s ObjInvUpDetail.IUDBillBatchCode=ResOutput.EInvoiceCode   ;电子票据代码
	  s ObjInvUpDetail.IUDBillBatchNo=ResOutput.EInvoiceNumber   ;电子票据号码
	  s ObjInvUpDetail.IUDDate=$zdh(ResOutput.IssueDate,3)             ;开票日期
	  s ObjInvUpDetail.IUDPictureUrl=ResOutput.PdfUrl           ;板式文件地址
	  s ObjInvUpDetail.IUDBillBatchStatus=ResOutput.REDRUSHSTATE
	  s ObjInvUpDetail.IUDCreatDate=$zdh(ResOutput.EInvoiceList.IssueDate ,3)	;电子票据生成日期(有返回日期的时候，以返回日期为准)
	  s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
	  s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	  s ObjInvUpDetail.IUDResultMeg="红冲成功"   						   ;查询状态 信息是否成功
	  s ObjInvUpDetail.EInvFlg="S"								   ;发票状态
	  s RtnFlag="0"
	}else{ 
	   //;为开票失败或异常，不能进行后续的开票状态查询。
	   s Errmsg="电子票据开具失败！"
	   s RtnFlag="-1"
	}		
	q RtnFlag
InvalidErr
    s $zt=""
    s RtnFlag="-1"
    q RtnFlag
}

/// 组织红冲接口参数
ClassMethod InvalidCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	s EInvalidReqObj=##class(BILL.EINV.DTO.ZBXXA.EInvalidReq).%New()
	s EInvalidReqObj.REQUESTID=ObjInvUpDetail.IUDBusNo  ;红请求流水号	Y	String	32
	s EInvalidReqObj.InvoicingPartyCode=""  ;开票单位编码	Y	String	30
	s EInvalidReqObj.PlaceCode=""    ;开票点编码	Y	String	20
	s EInvalidReqObj.EInvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode   ;票据代码	Y	String	8
	s EInvalidReqObj.EInvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo  ;票据号码	Y	String	10
	s EInvalidReqObj.IssueDate=$tr($zd(+$h,3),"-","")    ;开票日期	Y	Date
	s EInvalidReqObj.TotalAmount=ObjInvUpDetail.IUDCreatAmt   ;开票金额	Y	decimal(18, 6)
	s EInvalidReqObj.PInvoiceCode=""  ;红冲票据对应红冲纸票代码	N	String	10	如原电子票据已打印，则该项必填
	s EInvalidReqObj.PInvoiceNumber=""  ;红冲票据对应红冲纸票号码	N	String	10	如原电子票据已打印，则该项必填
	s EInvalidReqObj.Memo="患者要求"   ;红冲原因	Y	String	100
	s EInvalidReqObj.SMSEmail=ObjInvPrtInfo.PatBaseInfo.PatEmail  ;推送邮箱号	N	String	32	用于接收电子票据文件URL的邮件推送，非空时推送
	s EInvalidReqObj.SMSPHONE=ObjInvPrtInfo.PatBaseInfo.Mobphone   ;推送手机号	N	String	32	用于接收电子票据文件URL的短信推送，非空时推送
    s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvalidReqObj,.Stream)
	s rtn=Stream.Read()
	
	s EInvDataObj=##class(BILL.EINV.DTO.ZBXXA.EInvComData).%New()
    s EInvDataObj.ifCode="EInvoiceRedRushService"   ;电子票据查询接口
    s EInvDataObj.ifUser="his"   ;测试第三方暂定参数，后续从医院信息字典配置里面取
    s EInvDataObj.ifPwd="123"
    s EInvDataObj.randKey=$l(rtn)
    s EInvDataObj.jsonData=rtn
    s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvDataObj,.Stream)
	s ResJsonStr=Stream.Read()   		;业务入参
	q ResJsonStr
}

/// 功能说明：电票纸票关系接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：guoyunlong  2021-04-20
/// 其    他：w ##class(BILL.EINV.ADP.ZBXXA).Invalid("","","") 
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
    s $zt="PrintPaperErr"
    ;组织电票纸票关联接口参数
	s InputJson="{""REQUEST_ID"":"""_ObjInvUpDetail.IUDBusNo_""",""EInvoiceCode"":"""_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode
	s InputJson=InputJson_""",""EInvoiceNumber"":"""_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo_""",""PInvoiceCode"":"""_InvociePam.pBillBatchCode
	s InputJson=InputJson_""",""PInvoiceNumber"":"""_InvociePam.pBillNo_""",""Reprint"":""0""}"
	s EInvDataObj=##class(BILL.EINV.DTO.ZBXXA.EInvComData).%New()
    s EInvDataObj.ifCode="EInvoiceRedRushService"   ;电子票据查询接口
    s EInvDataObj.ifUser="his"   ;测试第三方暂定参数，后续从医院信息字典配置里面取
    s EInvDataObj.ifPwd="123"
    s EInvDataObj.randKey=""_$l(InputJson)_""
    s EInvDataObj.jsonData=InputJson
    s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvDataObj,.Stream)
	s ResJsonStr=Stream.Read()   		;业务入参
	
	s ServiceCode="ETicketRelationService"		;服务名称
	s OutPutJson=""
	// 调用"电票纸票关系接口"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.ZBXXA.HTTPRequest).InvoiceRequest(ServiceCode, ResJsonStr, InvociePam, .OutPutJson)	;调用富深http接口
	b ;SRVRtnFlg
	if (SRVRtnFlg="0"){
	  s ObjInvUpDetail.IUDBillBatchCode=InvociePam.pBillBatchCode   ;纸质票据代码
	  s ObjInvUpDetail.IUDBillBatchNo=InvociePam.pBillNo            ;纸质票据号码
	  s ObjInvUpDetail.IUDDate=+$H            ;开票日期
	  ;s ObjInvUpDetail.IUDCreatDate=""	;电子票据生成日期(有返回日期的时候，以返回日期为准)
	  s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
	  s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	  s ObjInvUpDetail.IUDResultMeg="换开成功"   						   ;查询状态 信息是否成功
	  s ObjInvUpDetail.EInvFlg="I"								   ;发票状态
	  s RtnFlag="0"
	}else{ 
	   s Errmsg="换开票据失败！"
	   s RtnFlag="-1"
	}		
	q RtnFlag
PrintPaperErr
    s $zt=""
    s RtnFlag="-1"
    q RtnFlag
}

}
