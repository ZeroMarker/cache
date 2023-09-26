Class BILL.EINV.ADP.LSA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败)
/// 修改履历：xubaobao   2020-07-23  新做成
/// 其    他：w ##class(BILL.EINV.ADP.FSA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	
	s StatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;根据流水号查询是否存在已经已经开具的电子票据
	q:StatusRtn="0" RtnFlag  ;存在的开具记录的时 获取结果直接返回
	
	s InputJson=..InvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam,ObjInvUpDetail.IUDPayAdmType)  ;组织开具电子票据的参数
	s:InputJson="" InvociePam.ErrMsgInfo="组织[开具电子票据]的参数失败!"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	s ServiceCode="mkomedicaleinvoice"		;服务名称
	s ResOutput= ##class(BILL.EINV.DTO.FSA.EInvComRes).%New()  ;接收返回
	// 调用"开具医疗电子票据请求"接口，根据返回状态判断是否继续操作
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, InputJson, InvociePam, ResOutput)	;调用富深http接口
	i SRVRtnFlg="0" d 
	.s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;获取开票状态信息
	.s:InvStatusRtn'="0" RtnFlag="-1"
	e  d  ;为开票失败或异常，不能进行后续的开票状态查询。
	.s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：发票状态查询接口(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：xubaobao   2020-07-23  新做成    
/// 其    他：w ##class(BILL.EINV.ADP.FSA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"	
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.LSA).GetInvStatusOfInvoice开始.")
	
	//组织电子票据开票状况入参
	s EInvStatesReq=##class(BILL.EINV.DTO.LSA.EInvStatesQueryReq).%New()
	s EInvStatesReq.appID=InvociePam.ObjUPConfig.IUCAPPID					;系统标识
	s EInvStatesReq.time=##class(BILL.EINV.COM.Common).GetNowToTimeStamp()	;当前时间戳
	s EInvStatesReq.token=..getToken(InvociePam.ObjUPConfig.IUCAPPID,InvociePam.ObjUPConfig.IUCSecretKey,EInvStatesReq.time)	;加密字符串
	s EInvStatesReq.sellName=""			;销售方名称
	s EInvStatesReq.sellTaxNo=""		;销售方税号
	s EInvStatesReq.billGuid=ObjInvUpDetail.IUDBusNo		;单据流水号
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvStatesReq,.Stream)
	s InputJson=Stream.Read()
	
	//调用乐税http接口
	s ServiceCode="invoice/getInvoiceResultList.shtml"    ;接口服务名称
	s EInvStatesRes=##class(BILL.EINV.DTO.LSA.EInvStatesQueryRes).%New()
	s SRVRtnFlg=##class(BILL.EINV.BI.FSA.HTTPRequest).InvoiceRequest(ServiceCode, ReqJsonStr, InvociePam, .EInvStatesRes)
	
	//获取返回数据成功后，根据state值来判断开票是否成功，开票成功后才能发起获取票据文件的请求。
	if (SRVRtnFlg=0){
			s ObjInvUpDetail.IUDBillBatchCode=EInvStatesRes.objects.invCode   ;电子票据代码
			s ObjInvUpDetail.IUDBillBatchNo=EInvStatesRes.objects.invNo       ;电子票据号码
			;s ObjInvUpDetail.IUDCheckCode=ResOutput.data.randomnumber        ;校验码
			s ObjInvUpDetail.IUDBillBatchStatus=EInvStatesRes.objects.status  ;开票状态:0为正常票,1为作废票,2为红冲票              
			if (EInvStatesRes.objects.status=0) {
				s ObjInvUpDetail.IUDCreatDate=$zdh(EInvStatesRes.objects.invDate,3) 	;电子票据生成日期(有返回日期的时候，以返回日期为准)
				;s ObjInvUpDetail.IUDCreatTime=""	
			}else{
				s ObjInvUpDetail.IUDCreatDate=$zdh(EInvStatesRes.objects.cancelDate,3) 	;电子票据生成日期(有返回日期的时候，以返回日期为准)
				;s ObjInvUpDetail.IUDCreatTime=""	
			}
			
			s ObjInvUpDetail.IUDStyle=EInvStatesRes.objects.invType		;开票类型:0专票,2普票,51电子票
			s ObjInvUpDetail.IUDPictureUrl=EInvStatesRes.objects.pdfUrl	;电子票pdf下载路径
			s ObjInvUpDetail.Xstr1=EInvStatesRes.objects.sellName		;销方名称
			s ObjInvUpDetail.Xstr2=EInvStatesRes.objects.sellTaxNo		;销方税号
			s ObjInvUpDetail.Xstr3=EInvStatesRes.objects.pdfMsg		;签章信息
			s ObjInvUpDetail.Xstr5=EInvStatesRes.objects.note		;备注
			
			
			
			s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
			s ObjInvUpDetail.IUDResultCode=EInvStatesRes.code
			s ObjInvUpDetail.IUDResultMeg="上传成功"   						   ;查询状态 信息是否成功
			s ObjInvUpDetail.EInvFlg="I"									   ;发票状态
			
			s RtnFlag="0"
	
	}else{
		s tmpErrMsg=EInvStatesRes.msg
		s:tmpErrMsg="" tmpErrMsg="查询开票结果失败"
		s InvociePam.ErrMsgInfo=tmpErrMsg
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.LSA).GetInvStatusOfInvoice结束.返回值RtnFlag="_RtnFlag)
	q RtnFlag
}

/// 功能说明：整理电子票据开具/红冲组织入参(住院、门诊公用)
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 		  PayAdmType        --> 票据业务类型
/// 返 回 值：返回接口文档对应的json格式
/// 修改履历：xubaobao   2020 07 23  新做成
/// 其    他：w ##class(BILL.EINV.ADP.FSA).InvoiceCom("","","","1") 
ClassMethod InvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, PayAdmType As %String) As %String
{
	s JsonStr=""

	//票据信息
	s invobj=##class(BILL.EINV.DTO.LSA.EInvoiceReq).%New()
	s invobj.appID=InvociePam.ObjUPConfig.IUCAPPID					;Y系统标识
	s invobj.time=##class(BILL.EINV.COM.Common).GetNowToTimeStamp()	;Y当前时间戳
	s invobj.token=..getToken(InvociePam.ObjUPConfig.IUCAPPID,InvociePam.ObjUPConfig.IUCSecretKey,EInvStatesReq.time)	;Y加密字符串
	
	s invobj.billGuid=ObjInvUpDetail.IUDBusNo						;Y单据流水号（唯一）
	s invobj.billNo=ObjInvUpDetail.IUDInvDr							;Y单据编号
	
	//跟医院沟通每个操作员的税盘分机号为固定值
	s invobj.sellMachineNo=""			;Y税盘分机号
	
	s invobj.invType=""												;Y票据类型(0：增值税专用发票（当发票类型为0时，不允许开具零税率发票） 2：增值税普通发票 51：增值税电子普通票)
	s invobj.billType=""											;Y单据类型(乐税可根据单据类型定义备注，对接时再约定值)
	s invobj.billSource="NC"										;Y单据来源（固定值，业务系统名称，传入NC）
	s invobj.bizDate=ObjInvPrtInfo.BusDate_" "_ObjInvPrtInfo.BusTime	;Y业务日期
	s invobj.buyName=""													;Y购方名称
	s invobj.buyTaxNo=""												;Y购方纳税人识别号
	s invobj.buyBankAccount=""											;O购方开户账号
	s invobj.buyAddrTel=""												;O购方地址电话
	s invobj.note="" 					    							;N备注
	s invobj.sellName=""			;Y销方名称
	s invobj.sellTaxNo=""			;Y销方税号
	s invobj.sellAddrTel=""			;O销方地址及电话
	s invobj.sellBankAccount=""		;O销方银行及账号
	s invobj.goodsVersio="33.0"		;N税收分类编码版本号（传默认值：33.0）
	s invobj.cashier=""				;O收款人
	s invobj.checker=""				;O复核人
	s invobj.invoicer=""			;O开票人
	s invobj.totalTaxAmount="0.00"			;N合计税额（不传时，按明细税额累加）
	s invobj.totalAmount=$fn(ObjInvPrtInfo.InvAmt,"",2)			;N价税合计（不传时，按明细价税累加）
	s invobj.totalAmountWithoutTax=$fn(ObjInvPrtInfo.InvAmt,"",2)	;N不含税总额（不传时，按明细不含税金额累加）
	s invobj.sourceinvCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;N(红冲票时必传)源正数发票代码
	s invobj.sourceinvNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo	;N(红冲票时必传)源正数发票号码
	s invobj.negativeFlag="0"						;N值须为数值0（非红冲）或1（红冲），默认0
	i (ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="InvalidInvSvr") d
	.s invobj.negativeFlag="1"
	s invobj.negNativeNo=""				;N专用发票且是负数票时需要输入（需在开票软件中申请红字发票信息表，税局审核通过后可以获取到）
	
	
	//单据明细
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s detailsobj=##class(BILL.EINV.DTO.LSA.EInvoiceDetails).%New()
	.s detailsobj.dtsGuid=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).DetailNo		;明细行流水号Y（唯一）,对应NC字段：发票表体ID
	.s detailsobj.goodsName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;商品名称Y
	.s detailsobj.standard=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec		;规格型号O
	.s detailsobj.unit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;单位O
	.s detailsobj.number=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty			;数量Y
	.s detailsobj.taxPrice=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;含税单价N
	.s detailsobj.withoutTaxPrice=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price	;不含税单价Y
	.s detailsobj.amountWithTax=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt		;含税金额N（保留两位小数）
	.s detailsobj.amountWithoutTax=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt		;不含税金额Y（保留两位小数）
	.s detailsobj.rate=""			;税率O
	.s detailsobj.taxTypeCode=""	;税收分类编码O
	.s detailsobj.discountFlag=""	;是否享受优惠O（0：不享受；1：享受）  默认为不享受
	.s detailsobj.discountType=""	;优惠政策类型O
	.s detailsobj.discountNote=""	;优惠政策说明N
	.s detailsobj.rowIndex=i		;行序O
	.s detailsobj.taxAmount=""		;税额Y
	.s detailsobj.discountFlage=""		;折扣标记N(N，默认0，标记为折扣时值1)
	.s detailsobj.discountAmountWithoutTax=""	;折扣金额(不含税)N
	.s detailsobj.discountRate=""				;折扣率N
	.s detailsobj.discountTaxAmount=""			;折扣税额N
	.s detailsobj.taxZeroRate=""			;零税率标志O(空串:非零税率,0出口退税,1免税,2不征收,3普通零税率)
	.d invobj.details.Insert(detailsobj)
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s JsonStr=Stream.Read()
	
	q JsonStr
}

/// 功能说明：获取加密串
ClassMethod getToken(appid As %String, appkey As %String, time As %String) As %String
{
	q ##class(web.Util.Encryption).MD5HexStr(appid_appkey_time)  ;MD5加密
}

}
