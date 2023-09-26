Class BILL.EINV.ADP.PGA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.PGA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).Invoice开始")
	
	s RtnFlag="0"
	
	//组织开具接口入参
	s InputJson=..InvoicePam(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误
	b ;Invoice 1
	
	//开票前,调用票据查询接口,如果已经开票直接保存开票结果
	s InvStatusRtn=..GetEInvResultByBusNo(ObjInvUpDetail,InvociePam)  ;查询开票情况
	q:InvStatusRtn="-9999" "-1"	;调用服务异常
	q:InvStatusRtn="0" RtnFlag
	b ;Invoice 2
	
	//查询不到开票信息时 调用开票业务
	s ServiceCode="createInvoice"	;接口服务名称
	s Message=InputJson							;业务入参
	s HISUniqueID=ObjInvUpDetail.IUDBusNo		;唯一流水号
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode="-9999" "-1"		;调用服务异常
	b ;Invoice 3
	i (RtnCode="0"){
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, .OutputObj)  ;把开票结果信息保存到交易表
	}else{
		s ObjInvUpDetail.IUDResultCode=OutputObj.code ;错误信息编码
		s ObjInvUpDetail.IUDResultMeg=OutputObj.message     ;错误信息描述
		s InvociePam.ErrMsgInfo=OutputObj.message
		s RtnFlag="-1"
	}
	
	b ;Invoice 4
	// 开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s OutputObj=""
		s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail,InvociePam)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	b ;Invoice 5
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).Invoice结束")
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutputObj As BILL.EINV.DTO.PGA.EInvResultRes) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).SetInvResultOfInvoice开始.")
	
	;b ;SetInvResultOfInvoice 1
	;s ResultMegObj=##class(BILL.EINV.DTO.PGA.InvoiceRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutputObj.data)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	
	s ResultMegObj=OutputObj.data
	b ;SetInvResultOfInvoice 2
	
	s ObjInvUpDetail.IUDAcceptid=ResultMegObj.SerialNumber		;电子票据代码		
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.EInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.EInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.IssueDate,3)	;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.IssueTime,1)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.BillPdfAddr			;本系统提供的下载、核验地址，值为BillPdfUrl二维码的内容
	s ObjInvUpDetail.IUDBillPictureData=ResultMegObj.BillPdfUrl		;二维码预览地址,扫码核验后可以进行电子票据下载，base64编码
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.EInvoiceCode_ResultMegObj.EInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.Xstr1=ResultMegObj.File      					;票据文件
	s ObjInvUpDetail.Xstr2=ResultMegObj.FileName  					;文件名称
	s ObjInvUpDetail.Xstr4=ResultMegObj.NowStock 					;剩余库存
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.PlatformCheckUrl	;平台核验地址	
	s ObjInvUpDetail.IUDResultCode=OutputObj.code
	//s ObjInvUpDetail.IUDResultMeg="上传成功"
	
	s RtnFlg="0"
	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).SetInvResultOfInvoice结束.")
	q RtnFlg
}

/// 功能说明：票据查询
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.PGA).GetEINVResultByBusNo("","","") 
ClassMethod GetEInvResultByBusNo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).GetEInvResultByBusNo开始.")
	
	//1.组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.PGA.InvoiceStatesQryReq).%New()
	s InvStatusRt.hospBizNumber=ObjInvUpDetail.IUDBusNo				;HIS业务流水号

	//2.调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s InputJson=Stream.Read()
	
	s ServiceCode="queryInvoice"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	;s ResultMegObj=##class(BILL.EINV.DTO.PGA.InvoiceStatesQryRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutputObj.data)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	s ResultMegObj=OutputObj.data
	
	;b ;GetEInvResultByBusNo 1
	s ObjInvUpDetail.IUDAcceptid=ResultMegObj.SerialNumber			;第三方的业务流水号
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.EInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.EInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.EinvoiceContent.IssueDate,3)	;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.EinvoiceContent.IssueTime,1)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.EinvoiceContent.BillPdfAddr			;二维码预览地址	
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.EInvoiceCode_ResultMegObj.EInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.Xstr1=ResultMegObj.EinvoiceContent.MainContent ;票据文件
	s ObjInvUpDetail.Xstr2=ResultMegObj.EinvoiceContent.BillPdfAddr  ;二维码预览地址
	s ObjInvUpDetail.Xstr3=ResultMegObj.EinvoiceContent.EinvoiceDetailCount  ;收费明细文件个数
	s ObjInvUpDetail.IUDResultCode=OutputObj.code	
	s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.State	;电子票据状态(0 失败，1 正常)
	s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.States.Reversal.IsReversal	;是否已开红票
	s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"									;发票状态
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.EinvoiceContent.PlatformCheckUrl	;平台核验地址	
	b ;GetEInvResultByBusNo 2
	s RtnFlag="0"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).GetEInvResultByBusNo结束.RtnFlag="_RtnFlag)
	
	q RtnFlag
}

/// 功能说明：票据查询(状态)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.PGA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).GetInvStatusOfInvoice开始.")
	
	//组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag
	b ;GetInvStatusOfInvoice 1

	s ServiceCode="queryInvoice"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType)			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	b ;GetInvStatusOfInvoice 2
	
	//4.保存结果信息
	;s ResultMegObj=##class(BILL.EINV.DTO.PGA.InvoiceStatesQryRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutputObj.data)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	s ResultMegObj=OutputObj.data
	
	b ;GetInvStatusOfInvoice 3
	s ObjInvUpDetail.IUDAcceptid=ResultMegObj.SerialNumber			;第三方的业务流水号
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.EInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.EInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.EinvoiceContent.IssueDate,3)	;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.EinvoiceContent.IssueTime,1)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.EinvoiceContent.BillPdfAddr			;二维码预览地址	
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.EInvoiceCode_ResultMegObj.EInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.Xstr1=ResultMegObj.EinvoiceContent.MainContent ;票据文件
	s ObjInvUpDetail.Xstr2=ResultMegObj.EinvoiceContent.BillPdfAddr  ;二维码预览地址
	s ObjInvUpDetail.Xstr3=ResultMegObj.EinvoiceContent.EinvoiceDetailCount  ;收费明细文件个数
	s ObjInvUpDetail.IUDResultCode=OutputObj.code	
	s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.State			;电子票据状态(0 失败，1 正常)
	s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.States.Reversal.IsReversal	;是否已开红票
	s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"									;发票状态
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.EinvoiceContent.PlatformCheckUrl	;平台核验地址	
	s RtnFlg="0"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).GetInvStatusOfInvoice结束.RtnFlag="_RtnFlag)
	
	q RtnFlg
}

/// 功能说明：整理根据电子票据代码和电子票据号获取票据状态入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.PGA).QueryInvStatus("","","") 
ClassMethod QueryInvStatus(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo) As %String
{
	s rtn=""
	
	//1.组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.PGA.InvoiceStatesQryReq).%New()
	i (ObjInvUpDetail.IUDUploadPathCode="InvalidInvSvr")||(ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="RePrintPaper"){
		s InvStatusRt.eInvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;电子票据代码
		s InvStatusRt.eInvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;电子票据号码
		;s InvStatusRt.serialNumber=ObjInvUpDetail.OriInvUpDetail.IUDAcceptid				;业务流水号
	} elseif ((ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv")){
		s EInvTradDr=ObjInvUpDetail.OriInvUpDetail.IUDInitRowID  ;纸质票据对应的电子票据交易表dr
		if (EInvTradDr'=""){
			s objEinvTrade=##class(BILL.EINV.PO.InvUpDetails).%OpenId(EInvTradDr)
			if ($isobject(objEinvTrade)'=0) {
				s InvStatusRt.eInvoiceCode=objEinvTrade.IUDBillBatchCode			;电子票据代码
				s InvStatusRt.eInvoiceNumber=objEinvTrade.IUDBillBatchNo			;电子票据号码
				;s InvStatusRt.serialNumber=objEinvTrade.IUDAcceptid				;业务流水号
			}
		}
	}else{
		s InvStatusRt.eInvoiceCode=ObjInvUpDetail.IUDBillBatchCode			;电子票据代码
		s InvStatusRt.eInvoiceNumber=ObjInvUpDetail.IUDBillBatchNo			;电子票据号码
		;s InvStatusRt.serialNumber=ObjInvUpDetail.IUDAcceptid				;业务流水号
	}

	//2.调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：整理电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.PGA).InvoiceCom("","","") 
ClassMethod InvoicePam(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).InvoicePam开始")
	
	//票据基础信息
	s invobj=##class(BILL.EINV.DTO.PGA.InvoiceReq).%New()
	;s invobj.RegionCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","RegionCode", 5) 	;区划编码						
	s invobj.reqSource="2"		;开票请求来源，1:自己的客户端 2:HIS 3:公众号 4:自助机 5:APP
	s invobj.patType=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"2",:"1")	;就诊类型 1门诊 2住院 3急诊
	s invobj.patNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo		;就诊号
	s invobj.email=ObjInvPrtInfo.PatBaseInfo.PatEmail		;邮箱地址
	s invobj.phone=ObjInvPrtInfo.PatBaseInfo.Mobphone		;交款人手机号
	s invobj.idcardNo=ObjInvPrtInfo.PatBaseInfo.PatID		;身份证号
	;b ;
	s invobj.type=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"2",:"1")	;开票类型 1门诊 2住院
	s invobj.payerPartyType="1"			;交款人类型(1:个人2:单位)
	s:(ObjInvUpDetail.IUDPayAdmType="PE")&&(ObjInvPrtInfo.PEBaseInfo.InvType="G") invobj.payerPartyType="2"
	s invobj.payerPartyCode=ObjInvPrtInfo.PatBaseInfo.PatID			;交款人代码
	s invobj.payerPartyName=ObjInvPrtInfo.PatBaseInfo.PatName		;交款人名称
	s invobj.payerAcct=""			;交款人账号
	s invobj.payerOpBk=""			;交款人开户行
	s invobj.payMode="1"				;交款方式 1现金 2pos刷卡 3批量代扣 4终端支付
	s invobj.recName=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","recName", 5)		;收款人名称				可走字典配置
	s invobj.recOpBk=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","recOpBk", 5)		;收款人开户银行名称
	s invobj.recAcct=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","recAcct", 5)		;收款人账号
	s invobj.totalAmount=$fn(+ObjInvPrtInfo.InvAmt,"",2)      			;总金额
	s invobj.repCreater=ObjInvPrtInfo.BusUserDesc			;开票人
	s invobj.checker=ObjInvPrtInfo.BusUserDesc				;复核人
	;b ;
	
	//其他信息
	s invobj.mainExt=##class(BILL.EINV.DTO.PGA.InvoiceMainExt).%New()
	s invobj.mainExt.businessNumber=ObjInvUpDetail.IUDBusNo		;流水号码
	s invobj.mainExt.businessDate=$zd(ObjInvPrtInfo.BusDate,3)			;业务日期
	s invobj.mainExt.gender=ObjInvPrtInfo.PatBaseInfo.Sex		;性别
	s invobj.mainExt.age=ObjInvPrtInfo.PatBaseInfo.Age		;年龄
	s invobj.mainExt.medicalType=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"住院",:"门诊")		;医疗类别
	s invobj.mainExt.patientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo			;门诊号
	s invobj.mainExt.medicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate			;就诊日期
	s invobj.mainExt.orgType=ObjInvPrtInfo.InsuDivInfo.HospitalType			;医疗机构类型
	s invobj.mainExt.medicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型
	s invobj.mainExt.medicalInsuranceId=ObjInvPrtInfo.InsuDivInfo.InsuId		;医保编号
	b ;0
	s invobj.mainExt.fundPayAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0,"",2)	;医保统筹基金支付
	b ;1
	s invobj.mainExt.otherPayAmount="0.00"		;其他支付
	s invobj.mainExt.accountPayAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0,"",2)	;个人账户支付
	s invobj.mainExt.ownPayAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)		;个人现金支付
	s invobj.mainExt.selfPaymentCost=$fn(+ObjInvPrtInfo.InsuDivInfo.SelfAmt,"",2)		;个人自费
	s invobj.mainExt.selfPaymentAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.selfPayAmt,"",2)	;个人自付
	s invobj.mainExt.caseNumber=ObjInvPrtInfo.PatBaseInfo.PAPMINO			;病例号
	s invobj.mainExt.hospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo	;住院号
	s invobj.mainExt.departmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc		;科别
	s invobj.mainExt.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate		;住院日期
	s invobj.mainExt.outHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate		;出院日期
	s invobj.mainExt.prePayAmount=$fn(+ObjInvPrtInfo.DepositAmt,"",2)	;预缴金额
	s invobj.mainExt.rechargeAmount=$fn(+ObjInvPrtInfo.RecAmt,"",2)	;补缴金额
	s invobj.mainExt.refundAmount=$fn(+ObjInvPrtInfo.RefAmt,"",2)	;退费金额
	s invobj.mainExt.selfMainExt=""		;个性化其他项目信息
	
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCate_ConFlag",5)  ;费用是否对照 1 对照 0 不对照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	
	//发票费用分类明细信息
	s Type=$Case(invobj.type,"2":"IP",:"OP")
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, Type)
	.f num=1:1:$l(FeeConStr,",") d
	..s datadetailsObj=##class(BILL.EINV.DTO.PGA.InvoiceItems).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s datadetailsObj.itemCode=$p(CatFeeInfo,"^",1)	;项目编码
	..s datadetailsObj.itemName=$p(CatFeeInfo,"^",2)	;项目名称
	..s datadetailsObj.itemUnit="/"						;计量单位
	..s datadetailsObj.itemStd=$p(CatFeeInfo,"^",3)	 	;收费标准
	..s datadetailsObj.itemAmount=1							;数量
	..s datadetailsObj.amount=$p(CatFeeInfo,"^",3)		;金额
	..s datadetailsObj.note="/"						;项目备注
	..f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	...s auxItemObj=##class(BILL.EINV.DTO.PGA.InvoiceAuxItem).%New()
	...s auxItemObj.auxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode		;对应项目编码
	...s auxItemObj.auxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;对应项目名称	
	...i FeeCateConFlag="1" d
	....s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  		;费用分类编码
	....s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCate"_Type_"ConPG",FeeCateKey,0)  ;对照信息
	....s auxItemObj.auxItemRelatedCode=$p(FeeItmCateConInfo, "^", 5)  			;费用分类编码
	....s auxItemObj.auxItemRelatedName=$p(FeeItmCateConInfo, "^", 6)  			;费用分类名称 
	...q:auxItemObj.auxItemRelatedCode'=datadetailsObj.itemCode                  
	...s auxItemObj.auxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;收费明细项目编码
	...s auxItemObj.auxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;收费明细项目名称
	...s auxItemObj.auxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty			;收费明细项目数量
	...s auxItemObj.auxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	...s auxItemObj.auxItemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;收费明细项目标准
	...s auxItemObj.auxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	...s auxItemObj.auxItemRemark="/"		;收费明细项目备注
	...d datadetailsObj.auxItem.Insert(auxItemObj)
	..d invobj.items.Insert(datadetailsObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s datadetailsObj=##class(BILL.EINV.DTO.PGA.InvoiceItems).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s datadetailsObj.ItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;项目编码
	..;s datadetailsObj.XMMC=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc ;项目名称
	..s datadetailsObj.ItemUnit=""										;计量单位
	..s datadetailsObj.ItemStd=bjInvPrtInfo.InvCateInfo.GetAt(i).Amt	 	;收费标准
	..s datadetailsObj.ItemAmount=1											;数量
	..s datadetailsObj.Amount=bjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	..s datadetailsObj.Note=""										;项目备注
	..f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	...s auxItemObj=##class(BILL.EINV.DTO.PGA.InvoiceAuxItem).%New()
	...s auxItemObj.auxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode		;对应项目编码
	...s auxItemObj.auxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;对应项目名称
	...q:auxItemObj.auxItemRelatedCode'=datadetailsObj.itemCode 	                   
	...s auxItemObj.auxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;收费明细项目编码
	...s auxItemObj.auxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;收费明细项目名称
	...s auxItemObj.auxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty			;收费明细项目数量
	...s auxItemObj.auxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	...s auxItemObj.auxItemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;收费明细项目标准
	...s auxItemObj.auxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	...s auxItemObj.auxItemRemark="/"		;收费明细项目备注
	...d datadetailsObj.auxItem.Insert(auxItemObj)
	..d invobj.items.Insert(datadetailsObj)

	//清单项目明细信息
	;f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	;.s detailObj=##class(BILL.EINV.DTO.STGLA.InvoiceDataAuxdetails).%New()                     
	;.s detailObj.XMBM=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode		;对应项目编码
	;.s detailObj.XMMC=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;对应项目名称	
	;.i FeeCateConFlag="1" d
	;..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  		;费用分类编码
	;..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConSTGL",FeeCateKey,0)  ;对照信息
	;..s detailObj.chargeCode=$p(FeeItmCateConInfo, "^", 5)  			;费用分类编码
	;..s detailObj.chargeName=$p(FeeItmCateConInfo, "^", 6)  			;费用分类名称                       
	;.s detailObj.SFXMBM=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;收费明细项目编码
	;.s detailObj.SFXMMC=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;收费明细项目名称
	;.s detailObj.SL=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty			;收费明细项目数量
	;.s detailObj.DW=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit			;收费明细项目单位
	;.s detailObj.BZ=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;收费明细项目标准
	;.s detailObj.JE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;收费明细项目金额
	;.s detailObj.XMBZ=""		;收费明细项目备注
	;.d invobj.DATA.dataauxdetails.Insert(detailObj)	
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read()
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).InvoicePam结束")
	q rtn
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2020-10-28  新做成   
/// 其    他：w ##class(BILL.EINV.ADP.PGA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//1.组织冲红接口入参
	s InputJson=..InvalidPam(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" RtnFlag   ;组织入参发生错误
	b ;Invalid 1
	
	//2.调用冲红接口
	s ServiceCode="cancelInvoice"			;接口服务名称
	s Message=InputJson						;业务入参
	s HISUniqueID=ObjInvUpDetail.IUDBusNo	;唯一流水号
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode="-9999" RtnFlag		;调用服务异常
	b ;Invalid 2
	if (RtnCode="0"){
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail, .OutputObj)  ;把红冲开票结果信息保存到交易表
	}else{
		s RtnFlag="0"
	}
	b ;Invalid 3
	//3.开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s InvStatusRtn=..GetInvStatusOfInvalid(ObjInvUpDetail, InvociePam)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	b ;Invalid 4
	q RtnFlag
}

/// 功能说明：电子票据冲红入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.STGLA).InvalidOP("","","") 
/// 备注说明：
ClassMethod InvalidPam(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织电子票据冲红入参
	s InvRefundRt=##class(BILL.EINV.DTO.PGA.InvalidReq).%New()
	s InvRefundRt.eInvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;票据代码
	s InvRefundRt.eInvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo	;票据号码
	s InvRefundRt.reason="患者要求"												;冲红原因
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutputObj As BILL.EINV.DTO.XCA.EInvResultMessage) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.PGA).SetInvResultOfInvalid开始.")
	
	;s ResultMegObj=##class(BILL.EINV.DTO.PGA.InvalidRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutputObj.data)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	s ResultMegObj=OutputObj.data
	b ;SetInvResultOfInvalid 1
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.EInvoiceCode	;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.EInvoiceNumber	;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.IssueDate,3)	;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.IssueTime,1)	;电子票据生成时间
a	s ObjInvUpDetail.EinvprtNo=ResultMegObj.EInvoiceCode_ResultMegObj.EInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=OutputObj.code
	s ObjInvUpDetail.Xstr1=ResultMegObj.File      			;票据文件
	s ObjInvUpDetail.Xstr2=ResultMegObj.FileName  			;文件名称
	b ;SetInvResultOfInvalid 2	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XCA).SetInvResultOfInvalid结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：调用服务接口获取冲红服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：徐保保   2020-10-28  新做成 
/// 其    他：w ##class(BILL.EINV.ADP.PGA).GetInvStatusOfInvalid("","","") 
ClassMethod GetInvStatusOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag
	;b ;GetInvStatusOfInvalid 1

	s ServiceCode="queryInvoice"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType)			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	;b ;GetInvStatusOfInvalid 2
	
	//4.保存结果信息
	;s ResultMegObj=##class(BILL.EINV.DTO.PGA.InvoiceStatesQryRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutputObj.data)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	s ResultMegObj=OutputObj.data
	b ;GetInvStatusOfInvalid 3 
	i (ResultMegObj.States.Reversal.IsReversal="true")&&(ResultMegObj.States.Reversal.RelatedInvoiceCode'="")&&(ResultMegObj.States.Reversal.RelatedInvoiceNumber'=""){
		;b ;99
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.States.Reversal.RelatedInvoiceCode		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.States.Reversal.RelatedInvoiceNumber		;电子票据号码
		;s ObjInvUpDetail.IUDCheckCode=ResultMegObj.States.Reversal.RelatedRandomNumber			;电子校验码
		s:ResultMegObj.States.Reversal.RedInvoiceDate'="" ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.States.Reversal.RedInvoiceDate,3)	;电子票据生成日期
		s:ResultMegObj.States.Reversal.RedInvoiceTime'="" ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.States.Reversal.RedInvoiceTime,1)	;电子票据生成时间
		;s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.BillPdfAddr		;二维码预览地址	
		s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo  ;发票编码+发票号码
		;s ObjInvUpDetail.Xstr1=ResultMegObj.EinvoiceContent.MainContent ;票据文件
		;s ObjInvUpDetail.Xstr2=ResultMegObj.EinvoiceContent.BillPdfAddr  ;二维码预览地址
		;s ObjInvUpDetail.Xstr3=ResultMegObj.EinvoiceContent.EinvoiceDetailCount  ;收费明细文件个数
		s ObjInvUpDetail.IUDResultCode=OutputObj.code	
		s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.State			;电子票据状态(0 失败，1 正常)
		s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.States.Reversal.IsReversal	;是否已开红票
		s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="冲红成功"
		s ObjInvUpDetail.EInvFlg="S"									;发票状态
		s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
		s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)
		s RtnFlag="0"
	}
	b ;GetInvStatusOfInvalid 4
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取换开纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	徐保保   2020-10-28  新做成
/// 其    他：	w ##class(BILL.EINV.ADP.PGA).PrintPaper("","") 
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	
	//1.组织换开入参
	s InputJson=..TurnPaperInvoice(ObjInvUpDetail,InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	//2.调用冲红接口
	s ServiceCode="cq9106"					;接口服务名称
	s Message=InputJson						;业务入参
	s HISUniqueID=ObjInvUpDetail.IUDBusNo	;唯一流水号
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XCA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam.ObjUPConfig, .OutputObj)
	q:RtnCode="-9999" RtnFlag		;调用服务异常
	if (RtnCode'="0"){
		s InvociePam.ErrMsgInfo=OutputObj.message
		;s RtnFlag="-1"
	}
		
	//3.换开纸质票据成功之后, 调用服务接口根据原电子发票代码、原电子发票号码获取电子票据状态
	if (RtnFlag="0"){
		s OutputObj=""
		s InvStatusRtn=..GetInvStatusOfPaper(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}
	
	q RtnFlag
}

/// 功能说明：4.2.3换开纸质票据接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.PGA).TurnPaperInvoice("","","") 
ClassMethod TurnPaperInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	//换开纸质票据
	
	s TurnPaperRt=##class(BILL.EINV.DTO.XCA.EInvTurnPaperReq).%New()
	s TurnPaperRt.EInvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;票据代码
	s TurnPaperRt.EInvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo	;票据号码
	s TurnPaperRt.PInvoiceCode=InvociePam.pBillBatchCode			;换开纸质票据代码								
	s TurnPaperRt.PInvoiceNumber=InvociePam.pBillNo					;换开纸质票据号码
	s TurnPaperRt.PRandomNumber=$e(##class(BILL.EINV.COM.Common).GetBusDate(+$h,$p($h,",",2)),12,17)					;纸质票据校验码
	
	s ObjInvUpDetail.IUDCheckCode=TurnPaperRt.PRandomNumber  
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(TurnPaperRt,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：调用服务接口获取换开纸质票据服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：徐保保   2020-10-28  新做成 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).GetInvStatusOfPaper("","","") 
ClassMethod GetInvStatusOfPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	//组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag

	s ServiceCode="cq9104"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType)			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XCA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam.ObjUPConfig, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	;s ResultMegObj=##class(BILL.EINV.DTO.XCA.InvoiceStatesQryRes).%New()
	;s Stream=##class(%GlobalCharacterStream).%New()
	;d Stream.Write(OutputObj.data)
	;d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	s ResultMegObj=OutputObj.data
	
	i (ResultMegObj.States.ExchangePaper.IsExchangePaper="true")&&(ResultMegObj.States.ExchangePaper.RelatedInvoiceCode'="")&&(ResultMegObj.States.ExchangePaper.RelatedInvoiceNumber'=""){
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.States.ExchangePaper.RelatedInvoiceCode		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.States.ExchangePaper.RelatedInvoiceNumber		;电子票据号码
		;s ObjInvUpDetail.IUDCheckCode=ResultMegObj.States.ExchangePaper.RelatedRandomNumber			;电子校验码
		;s ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.IssueDate,3)	;电子票据生成日期
		;s ObjInvUpDetail.IUDCreatTime=$zdh(ResultMegObj.IssueTime,1)	;电子票据生成时间
		;s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.BillPdfAddr		;二维码预览地址	
		s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo  ;发票编码+发票号码
		;s ObjInvUpDetail.Xstr1=ResultMegObj.EinvoiceContent.MainContent ;票据文件
		;s ObjInvUpDetail.Xstr2=ResultMegObj.EinvoiceContent.BillPdfAddr  ;二维码预览地址
		;s ObjInvUpDetail.Xstr3=ResultMegObj.EinvoiceContent.EinvoiceDetailCount  ;收费明细文件个数
		s ObjInvUpDetail.IUDResultCode=OutputObj.code	
		s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.State			;电子票据状态(0 失败，1 正常)
		s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.States.Reversal.IsReversal	;是否已开红票
		s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="已换开成功"
		s ObjInvUpDetail.EInvFlg="I"							;发票状态
		s ObjInvUpDetail.IUDUser=InvociePam.UserID              ;开票人
		s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
		s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)	
		s RtnFlag="0"
	}
	
	q RtnFlag
}

/// 功能说明：查询单位信息
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.BSA).TurnPaperInvoice("","","") 
ClassMethod getFeeInfo(ObjConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s FeeStr=""
	
	s ServiceCode="queryItemInfo"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("FEE")			;唯一流水号	
 	s Message="{}"							
	
	b ;01
	//3.调用兴财http票据查询服务请求
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s InvociePam.UserCode="0000"
	s InvociePam.UserDesc="管理员"
	s InvociePam.ObjUPConfig=ObjConfig
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	s ResultMegObj=##class(BILL.EINV.DTO.XCA.ItemDownLoadRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutputObj.data)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	
	f i=1:1:ResultMegObj.Items.Size  d
	.s FeeStr=FeeStr_"^"_ResultMegObj.Items.GetAt(i).ItemCode_"|"_ResultMegObj.Items.GetAt(i).ItemName
	
	q FeeStr
}

/// 功能说明：查询单位信息
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.BSA).TurnPaperInvoice("","","") 
ClassMethod EInvPrint(InputPam As %String, ObjConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s rtn=""
	
	//1.组织电子票据开票状况入参
	s ObjPrintReq=##class(BILL.EINV.DTO.PGA.EInvPrintReq).%New()
	s UserID=$p(InputPam,"^",1)
	s ObjPrintReq.ivcCode=$p(InputPam,"^",2)
	s ObjPrintReq.ivcNo=$p(InputPam,"^",3)
	s ObjPrintReq.checkCode=$p(InputPam,"^",4)
	s ObjPrintReq.format=$p(InputPam,"^",5)
	
	//2.调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjPrintReq,.Stream)
	s Message=Stream.Read()
	b ;Message
	
	s ServiceCode="downloadIvcFile"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("PRT")			;唯一流水号		
	
	//3.调用兴财http票据查询服务请求
	s InvociePam = ##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	i UserID'="" d
	.s InvociePam.UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)        ;操作员编码
	.s InvociePam.UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	s InvociePam.ObjUPConfig=ObjConfig
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.PGA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	s rtn=OutputObj.data.file
	
	q rtn
}

}
