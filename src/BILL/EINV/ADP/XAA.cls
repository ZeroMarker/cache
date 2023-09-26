/// 河南省信息化发展有限公司
Class BILL.EINV.ADP.XAA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2021-01-07  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XAA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).Invoice开始")
	
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
	s ServiceCode="invoice"	;接口服务名称
	s Message=InputJson							;业务入参
	s HISUniqueID=ObjInvUpDetail.IUDBusNo		;唯一流水号
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
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
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).Invoice结束")
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutputObj As BILL.EINV.DTO.PGA.EInvResultRes) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).SetInvResultOfInvoice开始.")
	s ResultMegObj=OutputObj.data
	b ;SetInvResultOfInvoice 2
	
	s ObjInvUpDetail.IUDAcceptid=ResultMegObj.serialNumber			;业务流水号	
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.eInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.eInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCreatDate=+$h			;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.billPdfAddr			;财政厅电子票据查看地址
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.eInvoiceCode_ResultMegObj.eInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.innerPdfAddr	;电子票据下载地址
	s ObjInvUpDetail.IUDResultCode=OutputObj.code

	s RtnFlg="0"
	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).SetInvResultOfInvoice结束.")
	q RtnFlg
}

/// 功能说明：票据查询
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XAA).GetEINVResultByBusNo("","","") 
ClassMethod GetEInvResultByBusNo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).GetEInvResultByBusNo开始.")
	
	//1.组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.XAA.InvoiceStatesQryReq).%New()
	s InvStatusRt.hospBizNumber=ObjInvUpDetail.IUDBusNo				;HIS业务流水号

	//2.调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s InputJson=Stream.Read()
	
	s ServiceCode="invoiceResult"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	q:ResultMegObj.reversal.isReversal="1" RtnFlag		;已开红票退出
	s ResultMegObj=OutputObj.data
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.eInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.eInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCreatDate=$zdh($p(ResultMegObj.eInvoiceTime," ",1),3)	;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth($p(ResultMegObj.eInvoiceTime," ",2),1)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillPictureData=ResultMegObj.eInvoiceLayoutFile			;二维码预览地址	
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.eInvoiceCode_ResultMegObj.eInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=OutputObj.code	
	s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.exchangePaper.isExchangePaper	;是否打印纸质票据
	s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.reversal.isReversal	;是否已开红票
	s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"									;发票状态	
	b ;GetEInvResultByBusNo 2
	s RtnFlag="0"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).GetEInvResultByBusNo结束.RtnFlag="_RtnFlag)
	
	q RtnFlag
}

/// 功能说明：票据查询(状态)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XAA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).GetInvStatusOfInvoice开始.")
	
	//组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag
	b ;GetInvStatusOfInvoice 1

	s ServiceCode="invoiceResult"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType)			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	b ;GetInvStatusOfInvoice 2
	
	//4.保存结果信息
	s ResultMegObj=OutputObj.data
	
	b ;GetInvStatusOfInvoice 3
	q:ResultMegObj.reversal.isReversal="1" RtnFlag		;已开红票退出
	s ResultMegObj=OutputObj.data
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.eInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.eInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCreatDate=$zdh($p(ResultMegObj.eInvoiceTime," ",1),3)	;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$zth($p(ResultMegObj.eInvoiceTime," ",2),1)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillPictureData=ResultMegObj.eInvoiceLayoutFile			;二维码预览地址	
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.eInvoiceCode_ResultMegObj.eInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=OutputObj.code	
	s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.exchangePaper.isExchangePaper	;是否打印纸质票据
	s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.reversal.isReversal	;是否已开红票
	s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"									;发票状态		
	s RtnFlag="0"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).GetInvStatusOfInvoice结束.RtnFlag="_RtnFlag)
	
	q RtnFlag
}

/// 功能说明：整理根据电子票据代码和电子票据号获取票据状态入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XAA).QueryInvStatus("","","") 
ClassMethod QueryInvStatus(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo) As %String
{
	s rtn=""
	
	//1.组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.XAA.InvoiceStatesQryReq).%New()
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
/// 其    他：w ##class(BILL.EINV.ADP.XAA).InvoiceCom("","","") 
ClassMethod InvoicePam(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).InvoicePam开始")
	
	//票据基础信息
	s invobj=##class(BILL.EINV.DTO.XAA.InvoiceReq).%New()
	s invobj.serialNumber=ObjInvUpDetail.IUDBusNo		;业务流水号
	s invobj.theType=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"2",:"1")	;票据类型 1门诊 2住院 3政府非税收入 4:社会团体会费 5:公益事业捐赠 6:资金往来结算 7:其他票据
	s invobj.totalAmount=$fn(+ObjInvPrtInfo.InvAmt,"",2)      			;总金额
	s invobj.recName=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","recName", 5)		;收款人名称				可走字典配置
	s invobj.recOpBk=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","recOpBk", 5)		;收款人开户行
	s invobj.recAcct=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","recAcct", 5)		;收款人账号
	s invobj.payerPartyType="1"			;交款人类型(1:个人2:单位)
	s:(ObjInvUpDetail.IUDPayAdmType="PE")&&(ObjInvPrtInfo.PEBaseInfo.InvType="G") invobj.payerPartyType="2"
	s invobj.payerPartyCode=ObjInvPrtInfo.PatBaseInfo.PatID			;交款人代码
	s invobj.payerPartyName=ObjInvPrtInfo.PatBaseInfo.PatName		;交款人名称
	s invobj.payerAcct=""			;交款人账号
	s invobj.payerOpBk=""			;交款人开户行
	s invobj.gender=ObjInvPrtInfo.PatBaseInfo.Sex		;性别(男/女)
	s invobj.payMode=""				;交款方式 1-现金、2-POS 刷卡3-批量代扣 4-终端支付???
	s invobj.businessNumber=""		;业务单号
	s invobj.handlingPerson=ObjInvPrtInfo.BusUserDesc		;开票人
	s invobj.checker=ObjInvPrtInfo.BusUserDesc				;复核人
	s invobj.patientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo	;门诊号
	s invobj.medicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate			;就诊日期
	s invobj.orgType=ObjInvPrtInfo.InsuDivInfo.HospitalType			;医疗机构类型
	s invobj.medicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型
	s invobj.medicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId		;医保编号
	s invobj.fundPayAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1,"",2)	;医保统筹基金支付
	s invobj.otherPayAmount="0.00"		;其他支付
	s invobj.accountPayAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0,"",2)	;个人账户支付
	s invobj.ownPayAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)		;个人现金支付
	s invobj.selfpaymentCost=$fn(+ObjInvPrtInfo.InsuDivInfo.SelfAmt,"",2)		;个人自费
	s invobj.selfpaymentAmount=$fn(+ObjInvPrtInfo.InsuDivInfo.selfPayAmt,"",2)	;个人自付
	s invobj.caseNumber=ObjInvPrtInfo.PatBaseInfo.PAPMINO			;病例号
	s invobj.hospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo	;住院号
	s invobj.departmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc		;科别
	s invobj.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate		;住院日期
	s invobj.outHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate		;出院日期
	s invobj.prepayAmount=$fn(+ObjInvPrtInfo.DepositAmt,"",2)	;预缴金额
	s invobj.rechargeAmount=$fn(+ObjInvPrtInfo.RecAmt,"",2)	;补缴金额
	s invobj.refundAmount=$fn(+ObjInvPrtInfo.RefAmt,"",2)	;退费金额
	s invobj.remark=""	;备注
	s invobj.spstand=""	;起付标准
	s invobj.bselfpayment=""	;乙类首自付
	s invobj.ptnselfpayment=""	;按比例自付
	s invobj.civilSubsidy=""	;公务员补助
	s invobj.teacherSubsidy=""	;师职补助
	s invobj.linsuranceReimbursement=""	;大额保险报销
	s invobj.lsubsidiaryInsuranceReimbursement=""	;大病补充保险报销
	s invobj.medicalHelp=""	;医疗救助
	s invobj.antenatalClinic=""	;产前检查费
	s invobj.medicalInsuranceNumber=""	;社会保障卡号

	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCate_ConFlag",5)  ;费用是否对照 1 对照 0 不对照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	
	//发票费用分类明细信息
	s Type=$Case(invobj.theType,"2":"IP",:"OP")
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, Type)
	.f num=1:1:$l(FeeConStr,",") d
	..s itemsObj=##class(BILL.EINV.DTO.XAA.Invoiceitems).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s itemsObj.itemCode=$p(CatFeeInfo,"^",1)	;项目编码
	..s itemsObj.itemName=$p(CatFeeInfo,"^",2)	;项目名称
	..s itemsObj.itemUnit=""					;计量单位
	..s itemsObj.itemStd=$p(CatFeeInfo,"^",3)	;收费标准
	..s itemsObj.itemQuantity=1					;数量
	..s itemsObj.itemAmount=$p(CatFeeInfo,"^",3)	;金额
	..s itemsObj.itemRemark=""					;项目备注
	..d invobj.items.Insert(itemsObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s itemsObj=##class(BILL.EINV.DTO.XAA.Invoiceitems).%New()
	..s itemsObj.itemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;项目编码
	..s itemsObj.itemName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc ;项目名称
	..s itemsObj.itemUnit=""										;计量单位
	..s itemsObj.itemStd=bjInvPrtInfo.InvCateInfo.GetAt(i).Amt	 	;收费标准
	..s itemsObj.itemQuantity=1											;数量
	..s itemsObj.itemAmount=bjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	..s itemsObj.itemRemark=""										;项目备注
	..d invobj.items.Insert(itemsObj)

	b ;//清单项目明细信息
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s auxItemsObj=##class(BILL.EINV.DTO.XAA.InvoiceauxItems).%New()                     
	.s auxItemsObj.auxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode		;对应项目编码
	.s auxItemsObj.auxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc		;对应项目名称	
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  		;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCate"_Type_"ConXA",FeeCateKey,0)  ;对照信息
	..s auxItemsObj.auxItemRelatedCode=$p(FeeItmCateConInfo, "^", 5)  			;对应项目编码
	..s auxItemsObj.auxItemRelatedName=$p(FeeItmCateConInfo, "^", 6)  			;对应项目名称                    
	.s auxItemsObj.auxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode		;收费明细项目编码
	.s auxItemsObj.auxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;收费明细项目名称
	.s auxItemsObj.auxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty		;收费明细项目数量
	.s auxItemsObj.auxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit		;收费明细项目单位
	.s auxItemsObj.auxItemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price		;收费明细项目标准
	.s auxItemsObj.auxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt		;收费明细项目金额
	.s auxItemsObj.auxItemRemark=""		;收费明细项目备注
	.d invobj.auxItems.Insert(auxItemsObj)
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.Stream)
	s rtn=Stream.Read(Stream.Size)
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).InvoicePam结束")
	q rtn
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2021-01-07  新做成   
/// 其    他：w ##class(BILL.EINV.ADP.XAA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//1.组织冲红接口入参
	s InputJson=..InvalidPam(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" RtnFlag   ;组织入参发生错误
	b ;Invalid 1
	
	//2.调用冲红接口
	s ServiceCode="cancellation"			;接口服务名称
	s Message=InputJson						;业务入参
	s HISUniqueID=ObjInvUpDetail.IUDBusNo	;唯一流水号
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
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
/// 其    他：w ##class(BILL.EINV.ADP.XAA).InvalidOP("","","") 
/// 备注说明：
ClassMethod InvalidPam(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织电子票据冲红入参
	s InvRefundRt=##class(BILL.EINV.DTO.XAA.InvalidReq).%New()
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
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XAA).SetInvResultOfInvalid开始.")
	
	s ResultMegObj=OutputObj.data
	b ;SetInvResultOfInvalid 1
	//对返回结果的时间戳进行分割	
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.eInvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.eInvoiceNumber		;电子票据号码
	s ObjInvUpDetail.IUDCreatDate=+$h			;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)	;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.billPdfAddr			;财政厅电子票据查看地址
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.eInvoiceCode_ResultMegObj.eInvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.innerPdfAddr	;电子票据下载地址
	s ObjInvUpDetail.IUDResultCode=OutputObj.code
	b ;SetInvResultOfInvalid 2	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XCA).SetInvResultOfInvalid结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：调用服务接口获取冲红服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：徐保保   2020-10-28  新做成 
/// 其    他：w ##class(BILL.EINV.ADP.XAA).GetInvStatusOfInvalid("","","") 
ClassMethod GetInvStatusOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag
	;b ;GetInvStatusOfInvalid 1

	s ServiceCode="invoiceResult"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType)			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	;b ;GetInvStatusOfInvalid 2
	
	//4.保存结果信息
	s ResultMegObj=OutputObj.data
	b ;GetInvStatusOfInvalid 3 
	i (ResultMegObj.reversal.isReversal="true")&&(ResultMegObj.reversal.invoiceReversalCode'="")&&(ResultMegObj.reversal.invoiceReversalNumber'=""){
		;b ;99
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.reversal.invoiceReversalCode		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.reversal.invoiceReversalNumber		;电子票据号码
		s:ResultMegObj.reversal.reversalTime'="" ObjInvUpDetail.IUDCreatDate=$zdh($p(ResultMegObj.reversal.reversalTime," ",1),3)	;电子票据生成日期
		s:ResultMegObj.reversal.reversalTime'="" ObjInvUpDetail.IUDCreatTime=$zth($p(ResultMegObj.reversal.reversalTime," ",2),1)	;电子票据生成时间
		s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo  ;发票编码+发票号码
		s ObjInvUpDetail.IUDResultCode=OutputObj.code	
		s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.exchangePaper.isExchangePaper	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.reversal.isReversal	;是否已开红票
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

/// 功能说明：查询单位信息
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XAA).TurnPaperInvoice("","","") 
ClassMethod getFeeInfo(ObjConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s FeeStr=""
	
	s ServiceCode="items"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("FEE")			;唯一流水号	
 	s Message="{}"	
 							
	s RtnCode=##class(BILL.EINV.BI.XAA.HTTPRequest).InvoiceRequest(ServiceCode,Message,HISUniqueID, InvociePam, .OutputObj)
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

}
