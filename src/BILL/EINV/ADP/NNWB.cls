/// 诺诺网开票请求2.0版本
/// 适用医院（浙江慈林，浙江舟山广安医院）
Class BILL.EINV.ADP.NNWB Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：guoyunlong  2022-08-11
/// 其    他：w ##class(BILL.EINV.ADP.NNWA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
    s $zt="InvoiceErr"
	s QueryRtn=..InvoiceQuery(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据流水号查询是否存在已经已经开具的电子票据
	q:QueryRtn="0" "0"  ;存在的开具记录的时 获取结果直接返回,查询成功后直接返回
	
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)  ;组织开具电子票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[开具电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	s ServiceCode="issueEInvoiceRecord.do"		;服务名称
	s ResOutput=""   ; ##class(BILL.EINV.DTO.FSA.EInvComRes).%New()  ;接收返回
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.NNWB.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput,.ObjInvUpDetail)	;调用富深http接口
	s ObjJsonStream=##class(%GlobalBinaryStream).%New()
	s JsonStr={}.%FromJSON(ResOutput)
	s code=JsonStr.code
	if (code="E0000"){
	  s resultdata=JsonStr.data
	  s ObjInvUpDetail.Xstr1=JsonStr.result.invoiceSerialNum    ;请求流水号
	  ///s ObjInvUpDetail.IUDBusNo =JsonStr.result.invoiceSerialNum    ;请求流水号
	  //s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取开票状态信息
	  //s:InvStatusRtn'="0" RtnFlag="0"
	  //s Errmsg="电子发票开票成功！查询票据信息失败"
	}else{ 
	   //;为开票失败或异常，不能进行后续的开票状态查询。
	   s Errmsg="电子票据开具失败！"
	   s RtnFlag="-1"
	}		
	q RtnFlag
InvoiceErr
    s RtnFlag="-1"
    b ;$ze
    q RtnFlag
}

/// 功能说明：整理电子票据开具组织入参(住院、门诊公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 		  PayAdmType        --> 票据业务类型
/// 返 回 值：返回接口文档对应的json格式
/// 修改履历：guoyunlong 2022-08-11
/// 其    他：w ##class(BILL.EINV.ADP.NNWA).InvoiceCom("","","","1") 
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
     //票据信息  
    s invobj=##class(BILL.EINV.DTO.NNWB.EInvoiceReq).%New()
	s invobj.buyerName=ObjInvPrtInfo.PatBaseInfo.PatName	///String	Y	企业名称/个人	100	购方名称
    s invobj.buyerTaxNum=""	  ///	String	N		20	购方税号（企业要填，个人可为空）
    s invobj.buyerTel=ObjInvPrtInfo.PatBaseInfo.Mobphone	  ///	String	N	0571-88888888	20	购方电话
    s invobj.buyerAddress=ObjInvPrtInfo.PatBaseInfo.Address	  ///	String	N	杭州市	80	购方地址
    s invobj.buyerAccount=""	  ///	String	中国工商银行 111111N	100	购方银行账号及开户行地址
    s invobj.salerTaxNum=""	  ///	String	Y	20	销方税号（使用沙箱环境请求时消息体参数salerTaxNum和消息头参数userTax			9		填写🡪🡪9901999999142）
    s invobj.salerTel=""	  ///	String	Y	0571-77777777	20	销方电话
    s invobj.salerAddress=""	  ///	String	Y		80	销方地址
    s invobj.salerAccount=""	  ///	String	N		100	销方银行账号和开户行地址			201701051202079		
    s invobj.orderNo=ObjInvUpDetail.IUDBusNo	  ///	String	Y	20	订单号（每个企业唯一）
    s invobj.invoiceDate=$zd(+$h,3)_" "_$zt($P($h,",",2),1)  ///	String	Y2016-01-1🡪 12:🡪0:0020	订单时间
    s invobj.invoiceNum=""	  ///	String	N	001🡪0865	8冲红时填写的对应蓝票发票号码（红票必填，不满8位请左补0）
    s invobj.invoiceCode=""	  ///	String	N	1259999156🡪0	12冲红时填写的对应蓝票发票代码（红票必填，不满12位请左补0）
    if ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo'=""  d
    .s invobj.invoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode 
    .s invobj.invoiceNum=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo
    s invobj.billInfoNo=""	  ///	String	N	16	发票信息表编号ZZZZZZZZZZZZZZZ72Z”字样，其  中“Z”为开具红字增值税专用发票所需要的长度为16位信息表编号。
    s invobj.departmentId=""	  ///	String	N	9F7E94🡪9CA8B4 C60A2FFF🡪EA🡪2	部门门店id（诺诺系统中的id）90B088
    s invobj.clerkId=""	  ///	String	N		🡪2	开票员id（诺诺系统中的id）
    s invobj.remark=""	  ///	String	N	
   /// 备注信息	冲红时，在备注中注明“对应正数发票代码:XXXXXXXXX号码:YYYYYYYY”
   /// 2🡪0	文案，其中“X”为发票代码，“Y”为发票号码，可以不填，接口会自动添加该文案；机动车发票蓝票时备注只能为空
   s invobj.checker=InvociePam.UserCode	  ///	String	N	王五	20	复核人
   s invobj.payee=InvociePam.UserCode	  ///	String	N	李四	20	收款人
   s invobj.clerk=InvociePam.UserCode	  ///	String	Y	张三	20	开票员
   s invobj.listFlag="0"	  ///	String	N	0	1	清单标志：非清单:0；清单:1，默认:0
   s invobj.listName=""	  ///	String	N	详见销货清单	清单项目名称：对应发票票面项目名称（li92	stFlag为1时，必填，默认为“详见销货清单”）
   s invobj.pushMode="1"	  ///	String	N	1	推送方式：-1,不推送;0,邮箱;1,手机（默认2）;2,邮箱、手机
   s invobj.buyerPhone=ObjInvPrtInfo.PatBaseInfo.Mobphone	  ///	String	Y	15858585858	购方手机（pushMode为1或2时，此项为20必填）
   s invobj.email=ObjInvPrtInfo.PatBaseInfo.PatEmail	  ///	String	Y	test@xx.com推送邮箱（pushMode为0或2时，此项为50必填）
   s invobj.invoiceType="1"	  ///	String	Y	1	1	开票类型：1:蓝票;2:红票
   if ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo'=""  d
   .s invobj.invoiceType="2"	
   s invobj.invoiceLine="p"	  ///	String	N	p	1	发票种类：p,普通发票(电票)(默认);c,普通
   s invobj.productOilFlag=""	  ///	String	N	0	1	成品油标志：非成品油(默认):0;成品油:1代开标志：0非代开;1代开。代开蓝票时备注要求填写文案：代开企业税号:***,代开企
   s invobj.proxyInvoiceFlag=""	  ///	String	N	0	1	业名称:***；代开红票时备注要求填写文案：对应正数发票代码:***号码:***代开企业税号:***代开企业名称:***
   s invobj.callBackUrl=""	  ////// http:127.0.0.1/invoicallBackUrl	String	N	开票完成 传发票信息地址ce/callback/	
   s invobj.extensionNumber=""	  ///	String	N		5	分机号（只能为空或者数字）
   s invobj.terminalNumber=""	  ///String	N		4	终端号（开票终端号，只能 为空或数字）
	
	//项目清单
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s InvoiceDetailsobj=##class(BILL.EINV.DTO.NNWB.EInvoiceDetails).%New()
    .s InvoiceDetailsobj.goodsCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	///String	N10905110🡪000001900000商品编码（商品税收分类编码开发者自行填写）
    .s InvoiceDetailsobj.selfCode=""   ///	String	N1🡪000542600000000020	自行编码（可不填）
    .s InvoiceDetailsobj.withTaxFlag="0"   ///	String	Y	1	1	单价含税标志：0:不含税,1:含税
    .s InvoiceDetailsobj.price=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price   ///	String	N	1	16单价，当单价(price)为空时，数量(num)也必须为空；(price)为空时，含税金额(ta xIncludedAmount)、不含税金额(taxEx cludedAmount)、税额(tax)都不能为空
    .s InvoiceDetailsobj.num=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty  ///	String	N	1	16	数量（开具红票时数量为负数）
    .s InvoiceDetailsobj.unit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit   ///	String	N	台	20	单位
    .s InvoiceDetailsobj.specType=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec   ///	String	N	y460	40	规格型号
    .s InvoiceDetailsobj.tax="0"   ///	String	N	0.12	税额，[不含税金额] * [税率] = [税额]；税额允许误差为 0.06。红票为负。不含税金16	额、税额、含税金额任何一个不传时，会根据传入的单价，数量进行计算，可能和实际数值存在误差，建议都传入
    .s InvoiceDetailsobj.taxRate="0"   ///	String	Y	0.1🡪	10	税率，注：纸票清单红票存在为null的情况
    .s InvoiceDetailsobj.taxExcludedAmount="0"   ///	String	N	0.88 不含税金额。红票为负。不含税金额、税额、含税金额任何一个不传时，会根据传16入的单价，数量进行计算，可能和实际数值存在误差，建议都传入
    .s InvoiceDetailsobj.taxIncludedAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt   ///	String	N	1	16	含税金额，[不含税金额] + [税额] = [含税金额]，红票为负。不含税金额、税额、含税金额任何一个不传时，会根据传入的单价，数量进行计算，可能和实际数值存在误差，建议都传入
    .s InvoiceDetailsobj.invoiceLineProperty="0"   ///	String	N	0	1	发票行性质：0,正常行;1,折扣行;2,被折扣行
    .s InvoiceDetailsobj.favouredPolicyFlag="0"   ///	String	N	0	1	优惠政策标识：0,不使用;1,使用增值税特殊管理（优惠政策名称）,当favo
    .s InvoiceDetailsobj.favouredPolicyName=""   ///	String	N	0	50uredPolicyFlag为1时，此项必填扣除额，差额征收时填写，目前只支持填写一项。  注意：当传0、空或字段不传时
    .s InvoiceDetailsobj.zeroRateFlag="1"   ///
    .d invobj.invoiceDetail.Insert(InvoiceDetailsobj)
    /// 零税率标识：空,非零税率;1,免税;2,不征税;🡪,普通零税率；1、当税率为：0%，且增值税特殊管理：为“免税”， 零税率标识	
   /// 0	1	：需传“1” 2、当税率为：0%，且增值税特殊管理：为"不征税" 零税率标识：需传“2”  🡪、当税率为：0%，且增值税特殊管理：为空 零税率标识：需传“🡪”
	
	s InvoicevehicleInfoobj=##class(BILL.EINV.DTO.NNWB.EInvoicevehicleInfo).%New()
	s InvoicevehicleInfoobj.vehicleType=""   ///车辆类型");
    s InvoicevehicleInfoobj.brandModel=""   ///厂牌型号");
    s InvoicevehicleInfoobj.productOrigin=""   ///原产地");
    s InvoicevehicleInfoobj.certificate=""   ///合格证号");
    s InvoicevehicleInfoobj.importCerNum=""   ///进出口证明书号");
    s InvoicevehicleInfoobj.insOddNum=""   ///商检单号");
    s InvoicevehicleInfoobj.engineNum=""   ///发动机号码");
    s InvoicevehicleInfoobj.vehicleCode=""   ///车辆识别号码");
    s InvoicevehicleInfoobj.intactCerNum=""   ///完税证明号码");
    s InvoicevehicleInfoobj.tonnage=""   ///吨位");
    s InvoicevehicleInfoobj.maxCapacity=""   ///限乘人数");
    s InvoicevehicleInfoobj.idNumOrgCode=""   ///身份证号或者组织机构代码");
    s InvoicevehicleInfoobj.manufactureName=""   ///生产厂家");
    s invobj.vehicleInfo=InvoicevehicleInfoobj
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong  2021-04-10
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"	
	s InputJson="{""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_",""bizcode"":"_ObjInvUpDetail.IUDBusNo_"}"		;流水号 
	s ServiceCode="queryEInvoiceRecord.do"                      ;接口服务名称
	s ReqJsonStr=InputJson										;业务入参
	
	s ResOutput=""    ;##class(BILL.EINV.DTO.FSA.EInvoiceRes).%New()    ;接收返回
	//调用诺诺网接口
	s SRVRtnFlg=##class(BILL.EINV.BI.NNWB.HTTPRequest).InvoiceRequest(ServiceCode, ReqJsonStr, InvociePam, .ResOutput)
	//获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg>0){
		s state=ResOutput.data.state  ;开票状态 1成功，0失败
		if (state="1") {
			s ObjInvUpDetail.IUDBillBatchCode=ResOutput.data.einvoicecode       ;电子票据代码
			s ObjInvUpDetail.IUDBillBatchNo=ResOutput.data.einvoicenumber       ;电子票据号码
			s ObjInvUpDetail.IUDCheckCode=ResOutput.data.randomnumber           ;校验码
			s ObjInvUpDetail.IUDBillBatchStatus=state                           ;开票状态 1成功，0失败
			s ObjInvUpDetail.Xstr1=ResOutput.data.einvoiceid                    ;电子票据ID
			s ObjInvUpDetail.Xstr2=ResOutput.data.einvoicefilename              ;电子票据文件名称
			s ObjInvUpDetail.Xstr3=ResOutput.data.bizcode                       ;业务流水号(服务商返回的)
			
			s NowDateTimeStr=$h
			s iNowDate=$p(NowDateTimeStr, ",", 1)
			s iNowTime=$p(NowDateTimeStr, ",", 2)
			s ObjInvUpDetail.IUDCreatDate=iNowDate							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
			s ObjInvUpDetail.IUDCreatTime=iNowTime							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
			
			s RtnFlag="0"
		}else{
			s tmpErrMsg=ResOutput.msg
			s:tmpErrMsg="" tmpErrMsg="获取开票状态信息为失败状态["_state_"]"
			s InvociePam.ErrMsgInfo=tmpErrMsg	
		}
	}else{
		s tmpErrMsg=ResOutput.msg
		s:tmpErrMsg="" tmpErrMsg="查询开票结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	
	
	q RtnFlag
}

/// 查询接口参数组织调用
///  guoyunlong
///  2022-08-11
ClassMethod InvoiceQuery(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag=""
	s ReqJsonInput="{""serialNos"":"""_ObjInvUpDetail.Xstr1_""",""orderNos"":"""_ObjInvUpDetail.IUDBusNo_""",""isOfferInvoiceDetail"":"""_0_"""}"
    s ServiceCode="issueEInvoiceRecord.do"		;服务名称
	s ResOutput=""   
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.NNWB.HTTPRequest).InvoiceRequest(ServiceCode, ReqJsonInput, InvociePam, .ResOutput,.ObjInvUpDetail)	;调用富深http接口
	s ObjJsonStream=##class(%GlobalBinaryStream).%New()
	s JsonStr={}.%FromJSON(ResOutput)
	s code=JsonStr.code
    if (code="E0000"){
	  s ObjInvUpDetail.Xstr1=JsonStr.result.invoiceSerialNum    ;请求流水号
	  ///s ObjInvUpDetail.IUDBusNo =JsonStr.result.invoiceSerialNum    ;请求流水号
	  s ObjInvUpDetail.IUDBillBatchCode=JsonStr.result.invoiceCode       ;电子票据代码
	  s ObjInvUpDetail.IUDBillBatchNo=JsonStr.result.invoiceNo       ;电子票据号码
	  s ObjInvUpDetail.IUDCheckCode=JsonStr.result.checkCode           ;校验码
	  s ObjInvUpDetail.IUDBillBatchStatus=JsonStr.result.status                           ;开票状态 1成功，0失败
	  s ObjInvUpDetail.IUDPictureUrl= JsonStr.result.pictureUrl   //JsonStr.result.pdfUrl
	  s ObjInvUpDetail.Xstr1=JsonStr.result.serialNo                    ;电子票据ID
	  s ObjInvUpDetail.Xstr2=JsonStr.result.orderNo             ;电子票据文件名称
	  s ObjInvUpDetail.Xstr3=JsonStr.result.pdfUrl                       ;业务流水号(服务商返回的)	
	  s NowDateTimeStr=$zdt($zdth(JsonStr.result.invoiceTime,-2),3,1)  
	  s iNowDate=$p(NowDateTimeStr, ",", 1)
	  s iNowTime=$p(NowDateTimeStr, ",", 2)
	  s ObjInvUpDetail.IUDCreatDate=iNowDate							   ;电子票据生成日期(有返回日期的时候，以返回日期为准)
	  s ObjInvUpDetail.IUDCreatTime=iNowTime							   ;电子票据生成时间(有返回时间的时候，以返回时间为准)
	  s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	  s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
	  s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
	  s RtnFlag="0"
	}else{ 
	   //;为开票失败或异常，不能进行后续的开票状态查询。
	   s Errmsg="电子票据查询失败！"
	   s RtnFlag="-1"
	}
	q RtnFlag
}

/// /w ##class(BILL.EINV.ADP.NNWB).Test()
ClassMethod Test()
{
	s Obj=##class(%DynamicObject).%New()
	s ObjArry1=##class(%DynamicArray).%New()
	d ObjArry1.%Push(1)
	s Obj.serialNos=ObjArry1
	s ObjArry2=##class(%DynamicArray).%New()
	d ObjArry2.%Push(3)
	s Obj.orderNos=ObjArry2
	s Obj.isOfferInvoiceDetail="0"
	q Obj.%ToJSON()
}

}
