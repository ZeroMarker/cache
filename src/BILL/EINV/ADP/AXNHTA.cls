Class BILL.EINV.ADP.AXNHTA Extends %RegisteredObject
{

/// 		公司：上海爱信诺航天信息有限公司	
/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2019-09-17  新做成
///           董科锋   2019-09-19  开票前判断是否已经开过电子发票、把开票结果信息保存到对象中抽取成了一个小方法
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).Invoice开始")
	
	s RtnFlag="0"
	i (ObjInvUpDetail.IUDPayAdmType="OP"){   			;门诊发票
		//组织门诊开具接口入参
		s ServiceCode="invoiceEBillOutpatient"			;接口服务名称
		s InputXml=..InvoiceOP(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}elseif(ObjInvUpDetail.IUDPayAdmType="REG"){		;挂号发票
		//组织挂号开具接口入参
		s ServiceCode="invEBillRegistration"			;接口服务名称
		s InputXml=..InvoiceOP(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}elseif(ObjInvUpDetail.IUDPayAdmType="IP"){  		;住院发票
		//组织住院开具接口入参
		s ServiceCode="invEBillHospitalized"			;接口服务名称
		s InputXml=..InvoiceIP(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}elseif(ObjInvUpDetail.IUDPayAdmType="DEP"){  		;住院预交金
		//组织住院押金开具接口入参
		s ServiceCode="invoicePayMentVoucher"			;接口服务名称
		s InputXml=..InvoiceIPPreDopsit(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}elseif(ObjInvUpDetail.IUDPayAdmType="API"){   			;门诊发票
		;？？？？？是否需要去判断集中打印发票是门诊收费还是挂号
		;（建议:门诊收费和挂号参数一致，公用一个，否则，收费挂号分开）
		//组织门诊开具接口入参
		s ServiceCode="invoiceEBillOutpatient"			;接口服务名称
		s InputXml=..InvoiceOP(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}
	q:(InputXml="") "-1"   ;组织入参发生错误
	
	//查询不到开票信息时 调用开票业务
	s HISUniqueID=ObjInvUpDetail.IUDBusNo				;唯一流水号
	s Message=InputXml									;业务入参
	s outData=##class(BILL.EINV.BI.AXNHTA.WebServiceRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)	;调用博思http接口
	s OutputXml=""
	//s Rtn=..DecryptionResult(outData, .OutputXml)     ;对返回结果进行解密
	s Rtn=..GetInvNo(outData,.OutputXml)
	if (Rtn'="") {
		s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, outData)  ;把开票结果信息保存到交易表
		;d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("OutJsonStream:"_OutJsonStream)  ;在日志中保存返回信息
	}else{
		s ObjInvUpDetail.IUDResultCode=Rtn                ;错误信息编码
		;s ObjInvUpDetail.IUDResultMeg=	OutJsonXml     ;错误信息描述
		;s InvociePam.ErrMsgInfo=OutJsonXml
		s RtnFlag="-1"
	}
	
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){
		s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).Invoice结束")
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).SetInvResultOfInvoice开始.")
	
	s ResultObj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceRes).%New()
	Do ResultObj.XMLNodeDeserialize(.ResultObj,"siiscmd",Response)
	s sendbackinvobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInv).%New()
	s sendbackinvobj=ResultObj.sendbackinv
	s sendbackinvrecordobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInvRecord).%New()
	s sendbackinvrecordobj=sendbackinvobj.sendbackinvrecord
	s sendbackinvrecordheadobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInvRecordhead).%New()
	s sendbackinvrecordheadobj=sendbackinvrecordobj.sendbackinvrecordhead
	//对返回结果的时间戳进行分割
	s createTime=sendbackinvrecordheadobj.binvdate
	s createDateTime=createTime_"00"
	s createDate=$zdh($e(createDateTime,1,8),8)
	s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	s ObjInvUpDetail.IUDBillBatchCode=sendbackinvrecordheadobj.binvcode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=sendbackinvrecordheadobj.binvnr			    	;电子票据号码
	s ObjInvUpDetail.IUDCheckCode="" //ResultMegObj.random					;电子校验码
	s ObjInvUpDetail.IUDCreatDate=createDate							;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=createTime							;;电子票据生成时间
	s ObjInvUpDetail.IUDBillQRCode="" //ResultMegObj.billQRCode				;电子票据二维码图片数据				
	s ObjInvUpDetail.IUDPictureUrl=""  //ResultMegObj.pictureUrl				;电子票据H5页面URL
	
	;+dongkf 2020-04-02 start
	s ObjInvUpDetail.EinvprtNo=sendbackinvrecordheadobj.binvcode_sendbackinvrecordheadobj.binvnr  ;发票编码+发票号码
	s ObjInvUpDetail.Xstr1="" //ResultMegObj.wxCardUrl      ;微信卡包地址
	s ObjInvUpDetail.Xstr2="" //ResultMegObj.pictureNetUrl  ;网络地址
	;+dongkf 2020-04-02 end
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：调用服务接口获取开具服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfInvoice("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfInvoice开始.")
	
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s ServiceCode="getEBillStatesByBillInfo"			;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	b ;GetInvStatusOfInvoice 1
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
	b ;GetInvStatusOfInvoice 2
	
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d 
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	.s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state				;状态
	.s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.isPrtPaper				;是否打印纸质票据
	.s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.isScarlet			;是否已开红票
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="I"										;发票状态
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.billBatchCode	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.billNo			    ;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResultMegObj.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end

	s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功

	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfInvoice结束.")
	q RtnFlag
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：苏惠德   2019-09-17   
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	i (ObjInvUpDetail.IUDPayAdmType="OP")||(ObjInvUpDetail.IUDPayAdmType="REG"){
		//组织门诊冲红接口入参
		s ServiceCode="writeOffEBill"					;接口服务名称
		s InputJson=..InvalidOP(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	}elseif(ObjInvUpDetail.IUDPayAdmType="IP"){
		//组织住院冲红接口入参
		s ServiceCode="writeOffEBill"		                ;电子票据冲红接口服务
		;s ServiceCode="cancelPayMentVoucherBalance"		;接口服务名称（撤销预交金电子凭证接口服务）
		s InputJson=..InvalidIP(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)	
	}elseif(ObjInvUpDetail.IUDPayAdmType="DEP"){
	    //组织住院预交金冲红接口入参
	   	s ServiceCode="writeOffPayMentVoucher"			;接口服务名称
	    s InputJson=..InvalidPreDeposit(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	}
	q:InputJson="" RtnFlag 
	
	
	//查询不到红冲开票信息时 调用红冲开票业务
	s HISUniqueID=ObjInvUpDetail.IUDBusNo				;唯一流水号
	s Message=InputJson									;业务入参
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)	;调用博思http接口
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)     ;对返回结果进行解密
	if (Rtn="S0000") {
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail,OutJsonStream)  ;;把红冲开票结果信息保存到交易表
	}else{
		//s ObjInvUpDetail.IUDResultCode=Rtn                	;错误信息编码
		//s ObjInvUpDetail.IUDResultMeg=OutJsonStream     	;错误信息描述
		//s InvociePam.ErrMsgInfo=OutJsonStream
		//s RtnFlag="-1"
		s RtnFlag="0"
	}
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){ 
		s InvStatusRtn=..GetInvStatusOfInvalid(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	
	q RtnFlag
}

/// 功能说明：设置红冲开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
/// 编写：    guoyunlong
/// 时间：    2019-09-20
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.PO.InvUpDetails, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.BSA.OPInvalidMegRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	//对返回结果的时间戳进行分割
	s createTime=ResultMegObj.createTime
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

/// 功能说明：设置住院预交金红冲开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
/// 编写：   guoyunlong
/// 时间：    2019-09-20
ClassMethod SetInvResultOfInvalidPreDeposit(ObjInvUpDetail As BILL.EINV.PO.InvUpDetails, BusUserDesc As %String, OutJsonStream As %String) As %String
{
	s RtnFlg="-1"
	
	s ResultMegObj=##class(BILL.EINV.DTO.BSA.PreDepositInvalidRes).%New()
	s Stream=##class(%GlobalCharacterStream).%New()
	d Stream.Write(OutJsonStream)
	d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	//对返回结果的时间戳进行分割
	s createTime=ResultMegObj.createTime
	s createDateTime=$e(createTime,1,$l(createTime)-3)
	s createDate=$zdh($e(createDateTime,1,8),8)
	s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	s ObjInvUpDetail.IUDResultMeg="冲红成功"									;上传结果描述
	;??????预交金红票凭证代码,预交金红票凭证号码,预交金红票凭证校验码 增加字段保存 
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.eScarletBillBatchCode		;电子红票票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.eScarletBillNo				    ;电子红票票据号码
	s ObjInvUpDetail.IUDCheckCode=ResultMegObj.eScarletRandom					;电子红票票据校验码
	s ObjInvUpDetail.IUDCreatDate=createDate									;电子红票生成时间
	s ObjInvUpDetail.IUDCreatTime=createTime									;电子红票生成时间
	s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.billQRCode						;电子红票二维码图片数据				
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.pictureUrl						;电子红票二维码图片数据
	s ObjInvUpDetail.IUDServiceCode=ServiceCode								    ;电子票据服务接口名
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：调用服务接口获取冲红服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfInvalid("","","") 
ClassMethod GetInvStatusOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s ServiceCode="getEBillStatesByBillInfo"			;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d 
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	.s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state				;状态
	.s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.isPrtPaper				;是否打印纸质票据
	.s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.isScarlet			;是否已开红票
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.billBatchCode	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.billNo			    ;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResultMegObj.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end
	
	.//根据原电子票据查询结果时，如果未返回红票票号和红票票据代码则冲红失败
	.i (ResultMegObj.scarletBillNo="")&&(ResultMegObj.scarletBillBatchCode="") d  	
	..s Rtn="E0001"      
	.e  d     ;成功则更新红票信息
	..s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.scarletBillBatchCode	;红票票据代码
	..s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.scarletBillNo			;红票票据号码
	..s ObjInvUpDetail.IUDCheckCode=ResultMegObj.scarletRandom				;红票校验码
	..s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.scarletBillQRCode        	;红票电子票据二维码图片数据
	..s ObjInvUpDetail.IUDResultMeg="冲红成功"
	..s ObjInvUpDetail.EInvFlg="S"											;发票状态
	s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功

	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：整理门诊电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvoiceOP("","","") 
ClassMethod InvoiceOP(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceOP开始")
	
	s rtn=""
	
	//票据信息  SajtIssueInvoiceService 开票服务接口名称					///BILL_EINV_PO.DicData表的DicType ,DicCode
	s HaveRateDeviceFlg=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("EInv_Device_List","Have_RateDevice_Flg", 5)   ;是否有税控设备标志 1 有 0 无
	
	s invobj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceReq).%New()
	s InvoiceInvobj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceInv).%New()
	s invrecordobj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceRecord).%New()
	s invrecordheadobj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceRecordHead).%New()
	
	s invrecordheadobj.machinenr=$p(HaveRateDeviceFlg,"^",5)  //BILL_EINV_PO.DicData表的DicBill1
	s invrecordheadobj.machinetaxnr=$p(HaveRateDeviceFlg,"^",6)  ////BILL_EINV_PO.DicData表的DicBill2
	s invkindobj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceKind).%New()
	s invkindobj.value=2 ///0-专用发票、2 –普通发票、11-货运发票、41-卷票普通发票、51-电子普通发票
	s invrecordheadobj.invkind=invkindobj
	
	s doctypeobj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceDocType).%New() 
	s doctypeobj.value=1 ///1 -正常单据、2 -红冲单据、3 -折扣单据(不用于开票,发票上不体现)
	s invrecordheadobj.doctype=doctypeobj 

	s invrecordheadobj.docnr=ObjInvUpDetail.IUDBusNo      		 ;业务系统单据号(确保单据号的唯一性)
	s invrecordheadobj.custnr=""									;客户编号
	s invrecordheadobj.custname=ObjInvPrtInfo.PatBaseInfo.PatName	      				 ;患者姓名
	s invrecordheadobj.docdate=..GetBusDate(ObjInvPrtInfo.BusDate, ObjInvPrtInfo.BusTime)  //业务系统单据日期
	s invrecordheadobj.custtaxnr=""			//客户税号
	s invrecordheadobj.custaddrtel=ObjInvPrtInfo.PatBaseInfo.Address_" "_ObjInvPrtInfo.PatBaseInfo.Mobphone      			;客户地址电话
	s invrecordheadobj.custbankacct=""     //客户银行及帐号
	s invrecordheadobj.memo=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0  //备注  医保结算信息
	s invrecordheadobj.memo2=""        //业务备注
	s invrecordheadobj.refinvcode=""   //对应正数发票代码
	s invrecordheadobj.refinvnr=""     //普通发票红票对应正数发票号码
	s invrecordheadobj.rednoticenr=""  ///专用发票红票通知单号
	s invrecordheadobj.issuer=InvociePam.UserCode  ///开票人
	s invrecordheadobj.checker=InvociePam.UserCode  ///复核人
	s invrecordheadobj.payee=ObjInvPrtInfo.BusUserCode   ;收款人
	s invrecordheadobj.sellerbankacct="" ;销方银行及帐号
	s invrecordheadobj.selleraddresstel="" ;销方地址电话
	s invrecordheadobj.consignerName="" ;收货人
	s invrecordheadobj.consignerTaxNr="" ;收货人纳税人识别号
	s invrecordheadobj.shipperName="" ;发货人
	s invrecordheadobj.shipperTaxNr="" ;发货人纳税人识别号
	s invrecordheadobj.originViaArrivalPlace="" ;起运地、经由、到达地
	s invrecordheadobj.vehicleKindNo="" ;车种车号
	s invrecordheadobj.vehicleTonnage="" ;车船吨位
	s invrecordheadobj.freightMemo="" ;运输货物信息
	s invrecordheadobj.taxdeduction="" ;扣除额
	s invrecordheadobj.listName="" ;详见销货清单
	s invrecordheadobj.emails=ObjInvPrtInfo.PatBaseInfo.PatEmail ;电子发票发送邮件地址
	s invrecordobj.invrecordhead=invrecordheadobj
	do invrecordheadobj.%Close()
	;+dongkf 2020-02-24 start
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateBS_ConFlag",5)  ;费用是否对照 1 对照 0 不独照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	;+dongkf 2020-02-24 end
	
	//发票费用分类
	;add by xubaobao 2020 03 30  Start  ----------------------------------
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s No=1
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, "OP")
	.f num=1:1:$l(FeeConStr,",") d
	..s ChargeDetailobj=##class(BILL.EINV.DTO.AXNHTA.OPListDetail).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..;s ChargeDetailobj.sortNo=""						;序号
	..s ChargeDetailobj.prodnr=$p(CatFeeInfo,"^",1)   //费用分类编码
	..s ChargeDetailobj.prodname=$p(CatFeeInfo,"^",2)   //费用分类名称
	..s ChargeDetailobj.spec=""
	..s ChargeDetailobj.unit=""			//计量单位
	..s ChargeDetailobj.pirce=$p(CatFeeInfo,"^",3) 		//收费标准
	..s ChargeDetailobj.quantity="1"			        //数量
	..s ChargeDetailobj.amount=$p(CatFeeInfo,"^",3)		//金额
	..s ChargeDetailobj.taxrate="免税"		
	..s ChargeDetailobj.tax=""			;税额
	..d invrecordobj.invrecorditem.Insert(ChargeDetailobj)
	..Do ChargeDetailobj.%Close()
	..s No=No+1
	e  d
	.s No=1
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s ChargeDetailobj=##class(BILL.EINV.DTO.AXNHTA.OPListDetail).%New()
	..s ChargeDetailobj.prodnr=$p(CatFeeInfo,"^",1)   //费用分类编码
	..s ChargeDetailobj.prodname=$p(CatFeeInfo,"^",2)   //费用分类名称
	..s ChargeDetailobj.spec=""
	..s ChargeDetailobj.unit=""			;计量单位
	..s ChargeDetailobj.pirce=$p(CatFeeInfo,"^",3) 			;收费标准
	..s ChargeDetailobj.quantity="1"			;数量
	..s ChargeDetailobj.amount=$p(CatFeeInfo,"^",3)			;金额
	..s ChargeDetailobj.taxrate="免税"		
	..s ChargeDetailobj.tax=""			;税额
	..d invrecordobj.invrecorditem.Insert(ChargeDetailobj)
	..do ChargeDetailobj.%Close()
	..s No=No+1
	s InvoiceInvobj.invrecord=invrecordobj
	do invrecordobj.%Close()
	s invobj.issueinv=InvoiceInvobj
	
	s rtn=""
	d invobj.XMLExportToString(.rtn,"siiscmd")
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceOP结束")
	q rtn
}

/// 功能说明：整理住院电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
/// 编写者 ：  guoyunlong  2019-09-16        
/// 修改履历： 苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvoiceIP("","","") 
ClassMethod InvoiceIP(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	do ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceIP开始")
	
	set invRt=##class(BILL.EINV.DTO.BSA.IPInvoiceReq).%New()
	;票据信息
	set invRt.busNo=ObjInvUpDetail.IUDBusNo   			 	 //业务流水号
	;REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
	set invRt.busType=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType, InvociePam.ObjUPConfig)			//业务标识
	set invRt.payer=ObjInvPrtInfo.PatBaseInfo.PatName					        //患者姓名
	set invRt.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate, ObjInvPrtInfo.BusTime)  ;业务发生时间
	
	;+zzw 2020 01 06 start 票据信息保存
	;set invRt.placeCode=ObjInvPrtInfo.BusUserCode					               //开票点编码
	set invRt.placeCode=InvociePam.UserCode				//开票点编码
	;set invRt.payee=ObjInvPrtInfo.BusUserDesc			//收费员
	set invRt.payee=InvociePam.UserDesc					//收费员
	;set invRt.author=ObjInvPrtInfo.BusUserDesc	     	//票据编制人;如收费员与开票人员为同一人，则值与payee相同
	set invRt.author=InvociePam.UserDesc	    	 	//票据编制人;如收费员与开票人员为同一人，则值与payee相同
	;+zzw 2020 01 06 end 票据信息保存
	
	set invRt.totalAmt=ObjInvPrtInfo.InvAmt				//开票总金额
	set invRt.remark=""										//备注
	;缴费信息
	set invRt.alipayCode=""									//患者支付宝账户
	set invRt.weChatOrderNo=""								//微信支付订单号
	set invRt.openID=""                                     //微信公众号或者小程序ID
	;通知
	set invRt.tel=ObjInvPrtInfo.PatBaseInfo.Mobphone						//患者手机号码
	set invRt.email=ObjInvPrtInfo.PatBaseInfo.PatEmail										//患者邮箱地址
	set invRt.idCardNo=ObjInvPrtInfo.PatBaseInfo.PatID					//患者身份证号码
	set invRt.cardType=..GetBusCardType(ObjInvPrtInfo.PatBaseInfo.CardType, InvociePam.ObjUPConfig)						        	//卡类型
	set invRt.cardNo=ObjInvPrtInfo.PatBaseInfo.CardNo				//卡号
	
	;就诊信息
	set invRt.medicalInstitution=ObjInvPrtInfo.InsuDivInfo.HospitalType      				;医疗机构类型
	set invRt.medCareInstitution=ObjInvPrtInfo.InsuDivInfo.HospitalNo						;医保机构编码
	set invRt.medCareTypeCode=ObjInvPrtInfo.InsuDivInfo.InsuTypeCode		;医保机构编码
	set invRt.medicalCareType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc       	;医保类型名称
	set invRt.payerType=ObjInvPrtInfo.InsuDivInfo.PatType									//人员类别
	set invRt.category=ObjInvPrtInfo.PatAdmInfo.DepDesc				//入院科室名称
	Set invRt.categoryCode=ObjInvPrtInfo.PatAdmInfo.DepCode            //入院科室编码
	set invRt.leaveCategory=ObjInvPrtInfo.PatAdmInfo.OutDepDesc	                        //出院科室名称
	Set invRt.leaveCategoryCode=ObjInvPrtInfo.PatAdmInfo.OutDepCode	                          //出院科室编码
	set invRt.hospitalNo=ObjInvPrtInfo.PatAdmInfo.MedicalCode			//患者住院号
	set invRt.visitNo=ObjInvPrtInfo.PatAdmInfo.AdmNo           		    //住院就诊编号
	set invRt.patientId=ObjInvPrtInfo.PatBaseInfo.PAPMINO               //患者唯一ID
	set invRt.patientNo= ObjInvPrtInfo.PatAdmInfo.AdmDr                                 //患者就诊编号
	set invRt.sex=ObjInvPrtInfo.PatBaseInfo.Sex					        //性别
	set invRt.age=ObjInvPrtInfo.PatBaseInfo.Age					     	//年龄
	set invRt.hospitalArea=ObjInvPrtInfo.PatAdmInfo.WardDesc	        	//病区
	set invRt.bedNo=ObjInvPrtInfo.PatAdmInfo.BedCode				//床号
	set invRt.caseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode			  //病历号
	set invRt.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate			//住院日期
	set invRt.outHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate			//出院日期	
	set invRt.hospitalDays=ObjInvPrtInfo.PatAdmInfo.IPDays			//住院天数
	
	;费用
	set invRt.accountPay=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0,"",2)				//个人账户支付
	set invRt.fundPay=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1,"",2)				//医保统筹基金支付
	set invRt.otherfundPay=$fn(0,"",2)							//其它医保支付
	set invRt.ownPay=$fn(ObjInvPrtInfo.InsuDivInfo.SelfAmt,"",2)                                	//自费金额
    set invRt.selfConceitedAmt=$fn(ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt,"",2)                            //个人自负
    set invRt.selfPayAmt=$fn(ObjInvPrtInfo.InsuDivInfo.selfPayAmt,"",2)                                  //个人自付
    set invRt.selfCashPay=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)			;个人现金支付                                 //个人现金支付
	set invRt.cashPay=$fn(0,"",2)                 					//现金预交款金额
	set invRt.chequePay=$fn(0,"",2)									//支票预交款金额
	set invRt.transferAccountPay=$fn(0,"",2)							//转账预交款金额
	set invRt.cashRecharge=$fn(0,"",2)								//补交金额(现金)
	set invRt.chequeRecharge=$fn(0,"",2)								//补交金额(支票)
	set invRt.transferAccountPay=$fn(0,"",2)							//补交金额（转账）
	set invRt.cashRefund=$fn(0,"",2)									//退还金额(现金)
	set invRt.chequeRefund=$fn(0,"",2)								//退交金额(支票)
	set invRt.transferRefund=$fn(0,"",2)								//退交金额(转账)
	set invRt.ownAcBalance=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYZstr23,"",2)								//个人账户余额
	
	set invRt.reimbursementAmt=$fn(ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0,"",2)                           //报销总金额
	set invRt.balanceNumber=ObjInvPrtInfo.InsuDivInfo.INPAYdjlsh0                              //结算号
	set invRt.eBillRelateNo=""								//业务票据关联号
	set invRt.isArrears="1"									//是否可流通
	set invRt.arrearsReason=""								//不可流通原因
	
    //根据账单号获取住院结算支付方式信息	
	for i=1:1:ObjInvPrtInfo.PayModeInfo.Size  d
	.set payChobj=##class(BILL.EINV.DTO.BSA.IPPayChannelDetail).%New()
	.set payChobj.payChannelCode=..GetBusPayMode(ObjInvPrtInfo.PayModeInfo.GetAt(i).Code,InvociePam.ObjUPConfig)	    ;交费渠道编码
	.;b:payChobj.payChannelCode="" ;payChannelCode
	.set payChobj.payChannelValue=ObjInvPrtInfo.PayModeInfo.GetAt(i).Amt			;交费渠道金额
	.d invRt.payChannelDetail.Insert(payChobj)
	;d payChobj.%Close()
	
	;+dongkf 2020-02-26 start
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateBS_ConFlag",5)  ;费用是否对照 1 对照 0 不独照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	;+dongkf 2020-02-26 end
    
    //住院收费项目明细列表
    ;add by xubaobao 2020 03 30
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s No=1
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo,InvociePam.ObjUPConfig, "IP")
	.f num=1:1:$l(FeeConStr,",") d
	..s ChargeDetailobj=##class(BILL.EINV.DTO.BSA.OPChargeDetail).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s ChargeDetailobj.sortNo=""						;序号
	..s ChargeDetailobj.chargeCode=$p(CatFeeInfo,"^",1)   //费用分类编码
	..s ChargeDetailobj.chargeName=$p(CatFeeInfo,"^",2)   //费用分类名称
	..s ChargeDetailobj.unit=""			;计量单位
	..s ChargeDetailobj.std=$p(CatFeeInfo,"^",3) 			;收费标准
	..s ChargeDetailobj.number="1"			;数量
	..s ChargeDetailobj.amt=$p(CatFeeInfo,"^",3)			;金额
	..s ChargeDetailobj.selfAmt=$p(CatFeeInfo,"^",3)		;自费金额
	..s ChargeDetailobj.remark=""			;备注
	..d invRt.chargeDetail.Insert(ChargeDetailobj)
	..s No=No+1
	e  d
    .s No=1
	.for i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..set ChargeDetailobj=##class(BILL.EINV.DTO.BSA.IPChargeDetail).%New()
	..set ChargeDetailobj.sortNo=No			    ;序号
	..set ChargeDetailobj.chargeCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code			;收费项目代码
	..set ChargeDetailobj.chargeName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc		    ;收费项目名称
	..set ChargeDetailobj.unit=""			        ;计量单位
	..set ChargeDetailobj.std=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		     	    ;收费标准/单价
	..set ChargeDetailobj.number="1"			    ;数量
	..set ChargeDetailobj.amt=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt			        ;金额
	..set ChargeDetailobj.selfAmt=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		        ;自费金额
	..set ChargeDetailobj.remark=""			    ;备注
	..d invRt.chargeDetail.Insert(ChargeDetailobj)
	..s No=No+1
    
    ;s No=1
	;for i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	;.set ChargeDetailobj=##class(BILL.EINV.DTO.BSA.IPChargeDetail).%New()
	;.set ChargeDetailobj.sortNo=No			    ;序号
	;.set ChargeDetailobj.chargeCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code			;收费项目代码
	;.set ChargeDetailobj.chargeName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc		    ;收费项目名称
	;.;+dongkf 2020-02-26 start
	;.i FeeCateConFlag="1" d
	;..s FeeCateKey=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code  ;费用分类编码
	;..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateIPConBS",FeeCateKey,0)  ;对照信息
	;..q:FeeItmCateConInfo=""
	;..s ChargeDetailobj.chargeCode=$p(FeeItmCateConInfo, "^", 5)  ;费用分类编码
	;..s ChargeDetailobj.chargeName=$p(FeeItmCateConInfo, "^", 6)  ;费用分类名称
	;.;+dongkf 2020-02-26 end
	;.set ChargeDetailobj.unit=""			        ;计量单位
	;.set ChargeDetailobj.std=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		     	    ;收费标准/单价
	;.set ChargeDetailobj.number="1"			    ;数量
	;.set ChargeDetailobj.amt=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt			        ;金额
	;.set ChargeDetailobj.selfAmt=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		        ;自费金额
	;.set ChargeDetailobj.remark=""			    ;备注
	;.d invRt.chargeDetail.Insert(ChargeDetailobj)
	;.s No=No+1
	;;d ChargeDetailobj.%Close()
    
    //根据账单号获取住院住院费用明细
    //清单项目明细列表
	for i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.set detailObj=##class(BILL.EINV.DTO.BSA.IPListDetail).%New()
	.set detailObj.listDetailNo=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).DetailNo                         //明细流水号 
	.set detailObj.chargeCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode				       	    //收费项目代码
	.set detailObj.chargeName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc					    	//收费项目名称
	.;+dongkf 2020-02-26 start
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  ;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateIPConBS",FeeCateKey,0)  ;对照信息
	..q:FeeItmCateConInfo=""
	..s detailObj.chargeCode=$p(FeeItmCateConInfo, "^", 5)  ;费用分类编码
	..s detailObj.chargeName=$p(FeeItmCateConInfo, "^", 6)  ;费用分类名称
	.;+dongkf 2020-02-26 end
	.set detailObj.prescribeCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).PresNo                        //处方编码                          
	.set detailObj.listTypeCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).DrugTypeCode                         //药品类别编码
	.set detailObj.listTypeName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).DrugTypeDesc                         //药品类别名称
	.set detailObj.code=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode                                 //药品编码
	.set detailObj.name=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc                                 //药品名称
	.set detailObj.form=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Form                                 //剂型
	.set detailObj.specification=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec                     //规格
	.set detailObj.unit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit									//计量单位
	.set detailObj.std=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price  							    	//单价
	.set detailObj.number=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty								//数量
	.set detailObj.amt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt							    	//金额
	.set detailObj.selfAmt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).SelfAmt                              //自付金额
	.set detailObj.receivableAmt=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).RecAmt                         //应收费用
	.set detailObj.medCareItemType=	ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Insutjdm				    //医保药品分类
	.set detailObj.medReimburseRate=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).InsuScale                      //医保报销比例
	.set detailObj.remark=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Remark							//备注
	.set detailObj.sortNo=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).SortNo                                //序号
	.set detailObj.chrgtype=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).ChrgType                             //费用类型
	.do invRt.listDetail.Insert(detailObj)			
    ;do detailObj.%Close()    
    //根据账单号获取其它医保信息
    //其它医保信息列表
   	set otherMedicalobj=##class(BILL.EINV.DTO.BSA.IPOtherMedicalList).%New()
   	set otherMedicalobj.infoNo=""                 ;序号
   	set otherMedicalobj.infoName=""               ;医保信息名称
   	set otherMedicalobj.infoValue=""              ;医保信息值
   	set otherMedicalobj.infoOther=""              ;医保其他信息
   	do invRt.otherMedicalList.Insert(otherMedicalobj)
   	;do otherMedicalobj.%Close()
   	
   	//其它扩展信息列表
	set otherobj=##class(BILL.EINV.DTO.BSA.IPOtherInfo).%New()
	set otherobj.infoNo=""			;序号
	set otherobj.infoName=""			;扩展信息名称
	set otherobj.infoValue=""			;扩展信息值
	d invRt.otherInfo.Insert(otherobj)
	;do otherobj.%Close()
	;预交金凭证消费扣款列表
	;调用->根据账单号获取参与结算的预交金明细 
	for i=1:1:ObjInvPrtInfo.IPPreDepositInfo.Size  d
	.s payMentVoucherObj = ##class(BILL.EINV.DTO.BSA.IPPayMentVoucher).%New()
	.s payMentVoucherObj.voucherAmt =ObjInvPrtInfo.IPPreDepositInfo.GetAt(i).voucherAmt       ;预交金凭证消费金额
	.s payMentVoucherObj.voucherBatchCode =ObjInvPrtInfo.IPPreDepositInfo.GetAt(i).voucherBatchCode    ;预交金凭证代码
	.s payMentVoucherObj.voucherNo =ObjInvPrtInfo.IPPreDepositInfo.GetAt(i).voucherNo             ;预交金凭证号码
	.do invRt.payMentVoucher.Insert(payMentVoucherObj)
	;do payMentVoucherObj.%Close()
   	
	set Stream=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(invRt, .Stream)
	set jsonStr=Stream.Read()
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceIP结束."_jsonStr)
   	quit jsonStr
}

/// 功能说明：住院预交金入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
/// 编写者 ：  guoyunlong  2019-09-20            
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvalidIP("","","") 
ClassMethod InvoiceIPPreDopsit(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceIPPreDopsit开始.")
	
	set ObjIPPreDopsit=##class(BILL.EINV.DTO.BSA.PreDepositInvoiceReq).%New()
	;票据信息
	set ObjIPPreDopsit.busType=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType,InvociePam.ObjUPConfig)			 	 ;业务标识
	set ObjIPPreDopsit.busNo=ObjInvPrtInfo.BusinessNo		 	         ;预交金业务流水号
	set ObjIPPreDopsit.payer=ObjInvPrtInfo.PatBaseInfo.PatName		 	     ;患者姓名
	set ObjIPPreDopsit.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime) 			 	 ;业务发生时间
	
	;+zzw 2020 01 06 start 票据信息保存
	;set ObjIPPreDopsit.placeCode=ObjInvPrtInfo.BusUserCode				 ;开票点编码
	set ObjIPPreDopsit.placeCode=InvociePam.UserCode				 	 ;开票点编码
	;set ObjIPPreDopsit.payee=ObjInvPrtInfo.BusUserDesc			 	     ;收费员
	set ObjIPPreDopsit.payee=InvociePam.UserDesc			 	    	 ;收费员
	;set ObjIPPreDopsit.drawee=ObjInvPrtInfo.BusUserDesc			 	 ;缴款人
	set ObjIPPreDopsit.drawee=InvociePam.UserDesc			 	         ;缴款人
	;set ObjIPPreDopsit.author=ObjInvPrtInfo.BusUserDesc			     ;编制人
	set ObjIPPreDopsit.author=InvociePam.UserDesc			    	     ;编制人
	;+zzw 2020 01 06 end 票据信息保存
	
	set ObjIPPreDopsit.tel=ObjInvPrtInfo.PatBaseInfo.Mobphone			 	 ;患者手机号码
	set ObjIPPreDopsit.email=ObjInvPrtInfo.PatBaseInfo.PatEmail			 	 ;患者邮箱地址
	set ObjIPPreDopsit.idCardNo=ObjInvPrtInfo.PatBaseInfo.PatID			 	 ;患者身份证号码
	set ObjIPPreDopsit.cardType=ObjInvPrtInfo.PatBaseInfo.CardType			 	 ;卡类型
	set ObjIPPreDopsit.cardNo=ObjInvPrtInfo.PatBaseInfo.CardNo			 	 ;卡号
	set ObjIPPreDopsit.amt=$fn(ObjInvPrtInfo.InvAmt,"",2) 	                         ;预缴金金额
	set ObjIPPreDopsit.ownAcBalance=$fn((ObjInvPrtInfo.DepositAmt-ObjInvPrtInfo.InvAmt),"",2)		 	             ;预缴金账户余额
	set ObjIPPreDopsit.category=ObjInvPrtInfo.PatAdmInfo.DepDesc			 	 ;入院科室名称
	set ObjIPPreDopsit.categoryCode=ObjInvPrtInfo.PatAdmInfo.DepCode			 	 ;入院科室编码
	set ObjIPPreDopsit.inHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate			 	     ;入院日期
	set ObjIPPreDopsit.hospitalNo=ObjInvPrtInfo.PatAdmInfo.IPNo			 	 ;患者住院号
	set ObjIPPreDopsit.visitNo=ObjInvPrtInfo.PatAdmInfo.AdmNo			 	 ;住院就诊编号
	set ObjIPPreDopsit.patientId=ObjInvPrtInfo.PatBaseInfo.PAPMINO			 	 ;患者唯一ID
	set ObjIPPreDopsit.patientNo=ObjInvPrtInfo.PatAdmInfo.AdmDr			 	     ;患者就诊编号
    ;交费渠道列表
	set ObjPayMent=##class(BILL.EINV.DTO.BSA.IPPayChannelDetail).%New()
	for i=1:1:ObjInvPrtInfo.IPPreDepositInfo.Size   d
	.set ObjPayMent.payChannelCode=ObjInvPrtInfo.PayModeInfo.GetAt(i).Code  ;交费渠道编码
	.set ObjPayMent.payChannelValue=ObjInvPrtInfo.PayModeInfo.GetAt(i).Amt	;交费渠道金额
	.do ObjIPPreDopsit.payChannelDetail.Insert(ObjPayMent)
	do ObjPayMent.%Close() 
	set ObjIPPreDopsit.accountName=""			    	 ;账户名称
	set ObjIPPreDopsit.accountNo=""			 	         ;账户号码
	set ObjIPPreDopsit.accountBank=""			 	     ;账户开户行
	set ObjIPPreDopsit.remark=""			 	     ;备注
	
	set Stream=##class(%GlobalCharacterStream).%New()
	do ##class(ext.util.JsonObject).ObjectToJSONStream(ObjIPPreDopsit,.Stream)
	set jsonStr=Stream.Read()
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceIPPreDopsit结束."_jsonStr)
   	quit jsonStr
}

/// 功能说明：整理门诊电子票据冲红入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvalidOP("","","") 
/// 备注说明：博思V2.0.0.3版本电子发票红冲接口不区分门诊住院等就诊类型，公用一个接口 ？？是否需要分开
ClassMethod InvalidOP(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织电子票据冲红入参
	s InvRefundRt=##class(BILL.EINV.DTO.AXNHTA.InvoiceAbortReq).%New()
	s cancelinv=##class(BILL.EINV.DTO.AXNHTA.InvoicePrint).%New()
	s key=##class(BILL.EINV.DTO.AXNHTA.InvoiceKey).%New()
	s invkind=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceKind).%New()
	s invkind.value=ObjInvUpDetail.OriInvUpDetail.IUDStyle
	s key.invkind=invkind
	d invkind.%Close() 
	s key.invcode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;电子票据代码
	s key.invnr=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo				;电子票据号码
	/*
	s InvRefundRt.reason="患者要求"										;冲红原因
	s InvRefundRt.operator=ObjInvPrtInfo.BusUserDesc					;经办人
	s InvRefundRt.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)
	
	;s InvRefundRt.placeCode=ObjInvPrtInfo.BusUserCode					;开票点编码
	s InvRefundRt.placeCode=InvociePam.UserCode					;开票点编码 ;+zzw 2020 01 06 
	*/
	s cancelinv.key=key
	d key.%Close() 
	s InvRefundRt.cancelinv=cancelinv
	d cancelinv.%Close() 
	
	//调用固定方法进行对象转xml
	//s Stream=##class(%GlobalCharacterStream).%New()
	//d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	//s rtn=Stream.Read()
	s rtn=""
	d InvRefundRt.XMLExportToString(.rtn, "siiscmd")
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).InvoiceOP结束")
	
	q rtn
}

/// 功能说明：整理住院电子票据冲红入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
/// 编写者 ：  guoyunlong  2019-09-16            
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvalidIP("","","") 
ClassMethod InvalidIP(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织电子票据冲红入参
	s InvRefundRt=##class(BILL.EINV.DTO.BSA.IPInvalidReq).%New()
	s InvRefundRt.billBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;电子票据代码
	s InvRefundRt.billNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo					;电子票据号码
	s InvRefundRt.reason="患者要求"										;冲红原因
	s InvRefundRt.operator=ObjInvPrtInfo.BusUserDesc					;经办人
	s InvRefundRt.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)
	
	;s InvRefundRt.placeCode=ObjInvPrtInfo.BusUserCode					;开票点编码
	s InvRefundRt.placeCode=InvociePam.UserCode					;开票点编码 ;+zzw 2020 01 06
	
	s InvRefundRt.patientId=ObjInvPrtInfo.PatBaseInfo.PAPMINO			;患者唯一ID
	s InvRefundRt.hospitalNo=ObjInvPrtInfo.PatAdmInfo.MedicalCode		;患者住院号
	s InvRefundRt.remark=""												;备注

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：4.2.2	预交金退款电子凭证开具接口,组织住院预交金电子票据冲红入参组织,
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：guoyunlong  2019-09-20 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).PreDepositInvalid("","","") 
ClassMethod InvalidPreDeposit(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//组织住院预交金电子票据冲红入参
	s InvRefundRt=##class(BILL.EINV.DTO.BSA.PreDepositInvalidReq).%New()
	s InvRefundRt.busType=..GetBusTypeByAdmType(ObjInvUpDetail.IUDPayAdmType,InvociePam.ObjUPConfig)                                          ;业务标识
	s InvRefundRt.billBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;电子票据代码
	s InvRefundRt.billNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo					;电子票据号码
	s InvRefundRt.reason="患者要求"										;冲红原因
	s InvRefundRt.operator=ObjInvPrtInfo.BusUserDesc					;经办人
	s InvRefundRt.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)   ;业务发生时间	
				
	;s InvRefundRt.placeCode=ObjInvPrtInfo.BusUserCode					;开票点编码
	s InvRefundRt.placeCode=InvociePam.UserCode					;开票点编码 ;+zzw 2020 01 06
	
    s InvRefundRt.voucherBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDVoucherBatchCode                        ;预交金凭证代码
    s InvRefundRt.voucherNo=ObjInvUpDetail.OriInvUpDetail.IUDVoucherNo                                ;预交金凭证号码
    s InvRefundRt.amt=$fn(ObjInvPrtInfo.InvAmt,"",2)                       ;预缴金退款金额   
    s InvRefundRt.ownAcBalance=$fn((ObjInvPrtInfo.DepositAmt+ObjInvPrtInfo.InvAmt),"",2)   ;预缴金账户余额
    s InvRefundRt.remark=""                                      

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：4.2.3	撤销住院预交金电子凭证结算接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：guoyunlong  2019-09-20 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvalidPreDepositRefund("","","") 
ClassMethod InvalidPreDepositRefundBak(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//撤销预交金电子凭证结算接口入参
	s InvRefundRt=##class(BILL.EINV.DTO.BSA.PreDepositRefundReq).%New()
	s InvRefundRt.billBatchCode=ObjInvUpDetail.IUDBillBatchCode			;电子票据代码
	s InvRefundRt.billNo=ObjInvUpDetail.IUDBillBatchNo					;电子票据号码
	s InvRefundRt.reason="患者要求"										;冲红原因
	
	;s InvRefundRt.operator=ObjInvPrtInfo.BusUserDesc					;经办人
	s InvRefundRt.operator=InvociePam.UserDesc					;经办人 ;+zzw 2020 01 06
	
	s InvRefundRt.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)   ;业务发生时间					
	
	;s InvRefundRt.placeCode=ObjInvPrtInfo.BusUserCode					;开票点编码
    s InvRefundRt.placeCode=InvociePam.UserCode					;开票点编码 ;+zzw 2020 01 06
    
    s InvRefundRt.patientId=ObjInvPrtInfo.PatBaseInfo.PAPMINO           ;患者唯一ID
    s InvRefundRt.hospitalNo=ObjInvPrtInfo.PatAdmInfo.AdmNo             ;患者住院号
    s InvRefundRt.remark=""                                             ;备注

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvRefundRt,.Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：4.3.2	换开纸质票据（电子票据打印）接口
///           4.3.3	重新换开纸质票据接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：guoyunlong  2019-09-20 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).TurnPaperInvoice("","","") 
ClassMethod TurnPaperInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	//换开纸质票据
	s ObjInvUpDetail.IUDPrtDate=+$h              ;换开时存业务发生日期
	s ObjInvUpDetail.IUDPrtTime=$p($h,"",2)      ;换开时存业务发生时间
	s TurnPaperRt=##class(BILL.EINV.DTO.AXNHTA.InovicePrintReq).%New()
	s printinv=##class(BILL.EINV.DTO.AXNHTA.InvoicePrint).%New()
	s key=##class(BILL.EINV.DTO.AXNHTA.InvoiceKey).%New()
	s invkind=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceKind).%New()
	s invkind.value=ObjInvUpDetail.OriInvUpDetail.IUDStyle
	s key.invkind=invkind
	d invkind.%Close()
	
	//s TurnPaperRt.billBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode		    ;电子票据代码
	//s TurnPaperRt.billNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo		        	;电子票据号码
	s key.invcode =InvociePam.pBillBatchCode                               ;纸质票据代码								
	s key.invnr=InvociePam.pBillNo					                        ;纸质票据号
	//s TurnPaperRt.busDateTime=..GetBusDate(ObjInvUpDetail.IUDPrtDate,ObjInvUpDetail.IUDPrtTime)			;业务发生时间					
	//s TurnPaperRt.placeCode=InvociePam.UserCode							;开票点编码
    //s TurnPaperRt.operator=InvociePam.UserDesc                   		;经办人
	s printinv.key=key
	d key.%Close()
	s TurnPaperRt.printinv=printinv
	d printinv.%Close()
	//调用固定方法进行对象转xml
	//s Stream=##class(%GlobalCharacterStream).%New()
	//d ##class(ext.util.JsonObject).ObjectToJSONStream(TurnPaperRt,.Stream)
	//s rtn=Stream.Read()
	s rtn=""
	d InvRefundRt.XMLExportToString(.rtn, "siiscmd")
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).TurnPaperInvoice结束")
	q rtn
}

/// 功能说明：4.3.4	作废换开的纸质票据接口入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：guoyunlong  2019-09-20 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).TurnPaperInvalid("","","") 
ClassMethod TurnPaperInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn=""
	
	//作废换开纸质票据接口入参
	s EInvTurnPaper=##class(BILL.EINV.DTO.BSA.EInvTurnPaperInvalidReq).%New()
	s EInvTurnPaper.pBillBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode		        	;纸质票据代码
	s EInvTurnPaper.pBillNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo       	        ;纸质票据号
	
	;s EInvTurnPaper.placeCode=ObjInvPrtInfo.BusUserCode					;开票点编码
	s EInvTurnPaper.placeCode=InvociePam.UserCode					;开票点编码 ;+zzw 2020 01 06 
    ;s EInvTurnPaper.author=ObjInvPrtInfo.BusUserDesc                      ;作废人
    s EInvTurnPaper.author=InvociePam.UserDesc                      ;作废人 ;+zzw 2020 01 06
	
	s EInvTurnPaper.reason="患者要求"                      ;作废原因							
	s EInvTurnPaper.busDateTime=..GetBusDate(ObjInvPrtInfo.BusDate, ObjInvPrtInfo.BusTime)   ;业务发生时间					
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvTurnPaper, .Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：4.3.5	空白纸质票据作废接口入参组织
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：guoyunlong  2019-09-20 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).BlankPaperInvalid("","","") 
ClassMethod BlankPaperInvalid(dataStr As %String) As %String
{
	s rtn=""
	s UserID=$p(dataStr,"^",1)      //操作人ID
	s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)        ;操作员编码
	s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	
	//空白纸质票据作废接口入参
	s EInvTurnPaper=##class(BILL.EINV.DTO.BSA.BlankPaperInvalidReq).%New()
	s EInvTurnPaper.pBillBatchCode=$p(dataStr,"^",2)		        	;纸质票据代码
	s EInvTurnPaper.pBillNoStart=$p(dataStr,"^",3)        	        ;起始纸质票据号
	s EInvTurnPaper.pBillNoEnd=$p(dataStr,"^",4)				    	;终止纸质票据号
    s EInvTurnPaper.placeCode=UserCode             ;开票点编码
	s EInvTurnPaper.author=UserDesc               ;作废人
	s EInvTurnPaper.reason="发票破损"							;作废原因
	s:$p(dataStr,"^",5)'="" EInvTurnPaper.reason=$p(dataStr,"^",5)
	s EInvTurnPaper.busDateTime=..GetBusDate(+$h, $p($h,"",2))    ;业务发生时间					
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvTurnPaper, .Stream)
	s rtn=Stream.Read()
	q rtn
}

/// 功能说明：调用空白纸质票据作废接口
/// 入参说明: dataStr    --> 入参数据
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong   2019-09-26
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).InvalidBlankInv("","","") 
ClassMethod InvalidBlankInv(dataStr As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
  	s Rtn="-1"
 	s InputJson=..BlankPaperInvalid(dataStr)
 	q:InputJson="" Rtn
    s ServiceCode="invalidBlankBillNo"			     ;接口服务名称
  	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo($p(dataStr,"^",1),30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)
	//对返回结果进行解密
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d 
	.;返回成功
	.s Rtn="0"
	e  d
	.s Rtn="-1"
	
	q Rtn
}

/// 功能说明：整理根据电子票据代码和电子票据号获取票据状态入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式
/// 编写者 ：  guoyunlong  2019-09-16            
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).QueryInvStatus("","","") 
ClassMethod QueryInvStatus(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo) As %String
{
	s rtn=""
	
	//组织获取电子票据状态入参
	s InvStatusRt=##class(BILL.EINV.DTO.BSA.IPInvalidReq).%New()
	
	;i (ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="RePrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv"){
	i (ObjInvUpDetail.IUDUploadPathCode="InvalidInvSvr")||(ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="RePrintPaper"){
		s InvStatusRt.billBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;电子票据代码
		s InvStatusRt.billNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo					;电子票据号码
	} elseif ((ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv")){
		s EInvTradDr=ObjInvUpDetail.OriInvUpDetail.IUDInitRowID  ;纸质票据对应的电子票据交易表dr
		if (EInvTradDr'=""){
			s objEinvTrade=##class(BILL.EINV.PO.InvUpDetails).%OpenId(EInvTradDr)
			if ($IsObject(objEinvTrade)) {
				s InvStatusRt.billBatchCode=objEinvTrade.IUDBillBatchCode			;电子票据代码
				s InvStatusRt.billNo=objEinvTrade.IUDBillBatchNo					;电子票据号码
			}
		}
	}else{
		s InvStatusRt.billBatchCode=ObjInvUpDetail.IUDBillBatchCode			;电子票据代码
		s InvStatusRt.billNo=ObjInvUpDetail.IUDBillBatchNo					;电子票据号码
	}

	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt, .Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：调用服务接口获取服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetInvStatusRes("","","") 
ClassMethod GetInvStatusRes(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s ServiceCode="getEBillStatesByBillInfo"			;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType, 30, "") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d 
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	.s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state				;状态
	.s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.isPrtPaper				;是否打印纸质票据
	.s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.isScarlet			;是否已开红票
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="I"									;发票状态
	.s createTime=ResultMegObj.ivcDateTime								;开票时间
	.s createDateTime=$e(createTime,1,$l(createTime)-3)
	.s createDate=$zdh($e(createDateTime,1,8),8)
	.s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	.;s ObjInvUpDetail.IUDCreatDate=createDate			;此处不应该更新时间，冲红时此交易返回的是开票时间，而不是冲红时间
	.;s ObjInvUpDetail.IUDCreatTime=createTime

	.i (ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv") d
	..i (ResultMegObj.scarletBillNo="")&&(ObjInvUpDetail.IUDUploadPathCode="InvalidInv") d           //如果未返回红票号，认为冲红失败
	...s Rtn="E0001"
	..e  i (ResultMegObj.state'="2")&&(ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv") d
	...s Rtn="E0001"
	..e   d
	...s:ObjInvUpDetail.IUDUploadPathCode="InvalidInv" ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.scarletBillBatchCode		;红票票据代码
	...s:ObjInvUpDetail.IUDUploadPathCode="InvalidInv" ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.scarletBillNo				;红票票据号码
	...s:ObjInvUpDetail.IUDUploadPathCode="InvalidInv" ObjInvUpDetail.IUDCheckCode=ResultMegObj.scarletRandom					;红票校验码
	...s:ObjInvUpDetail.IUDUploadPathCode="InvalidInv" ObjInvUpDetail.IUDBillQRCode=ResultMegObj.scarletBillQRCode         	;红票电子票据二维码图片数据
	...s ObjInvUpDetail.IUDResultMeg="冲红成功"
	...s ObjInvUpDetail.EInvFlg="S"											;;发票状态
	...s ObjInvUpDetail.IUDPrintType="E"	;更新票据模式 add by xubaobao 2019 09 28
	
	.e  i (ObjInvUpDetail.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="RePrintPaper") d 
	..i (ObjInvUpDetail.IUDUploadPathCode="RePrintPaper")&&(InvociePam.pBillNo'=ResultMegObj.pBillNo) d
	...s Rtn="E0001"               ;重新换开时，如果传入当前的纸质票据号码与返回的纸质票据号码不一致，认为重新换开失败
	..e  i (ResultMegObj.isPrtPaper'="1")&&(ObjInvUpDetail.IUDUploadPathCode="PrintPaper") d
	...s Rtn="E0001"               ;换开时，如果打印标志不为1，默认换开失败
	..s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.pBillBatchCode			;纸质票据代码
	..s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.pBillNo					;纸质票据号码
	..s ObjInvUpDetail.IUDResultMeg="已换开成功"
	..s ObjInvUpDetail.EInvFlg="I"	


	s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功

	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取开票状况服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetEINVResultByBusNo("","","") 
ClassMethod GetEINVResultByBusNo(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef OutJsonStream As %String) As %String
{
	s RtnFlag="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).GetEINVResultByBusNo开始.")
	
	//组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.BSA.OPInvoiceReq).%New()
	s InvStatusRt.busNo=ObjInvUpDetail.IUDBusNo					;业务流水号

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s InputJson=Stream.Read()
	s ServiceCode="getEBillByBusNo"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.AXNHTA).GetEINVResultByBusNo结束.Rtn="_Rtn)
	q Rtn
}

/// 功能说明：调用服务接口获取纸质/电子票据有效票据号段接口服务结果
/// 入参说明:	placeCode(收费员编码)
/// 			billCode:票据类型(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
///             billBatchCode:票据代码(是否纸质票据/电子票据)
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.AXNHTA).InvReceive("","","") 
ClassMethod InvReceive(UserID As %String, billCode As %String, billBatchCode As %String, ByRef objValidBillNo As BILL.EINV.DTO.COM.ValidBillNo, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s RtnFlag="-1"
	s placeCode=$p($g(^SSU("SSUSR",UserID)),"^",1)
	//组织票据有效票据号段入参
	s ValidBillRt=##class(BILL.EINV.DTO.BSA.ValidBillNoReq).%New()
	s ValidBillRt.placeCode=placeCode					;开票点编码
	s ValidBillRt.billBatchCode=billBatchCode			;票据代码
	s ValidBillRt.billCode=billCode						;票据种类代码
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ValidBillRt,.Stream)
	s InputJson=Stream.Read()
	s ServiceCode="getValidBillNo"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("PAPER",30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)

	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	//对返回的json串数据进行解析并保存objValidBillNo对象中
	i ('$IsObject(objValidBillNo))	d
	.s objValidBillNo=##class(BILL.EINV.DTO.COM.ValidBillNo).%New()
	
	i (Rtn="S0000") d
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.ValidBillNoRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	.s objValidBillNo.INVCount=ResultMegObj.count
	.q:objValidBillNo.INVCount=0
	.;s objValidBillNo.INVBillNoList=ResultMegObj.billNoList
	.f i=1:1:ResultMegObj.count  do
	..s DHCInvoiceObj = ##class(BILL.EINV.DTO.COM.DHCInvoiceInfo).%New()
    ..s DHCInvoiceObj.INVtype=ResultMegObj.billNoList.GetAt(i).billCode			;票据种类编码
	..;测试时确认一下票据种类编码是否一致(博思返回票据种类)
	..s DHCInvoiceObj.INVtype=$case(DHCInvoiceObj.INVtype,"4014":"PO","4002":"EO","4012":"EI","4015":"PI",:"")
	..;暂时不保存电子票据
	..q:(DHCInvoiceObj.INVtype="EI")||(DHCInvoiceObj.INVtype="EO")
	..;s DHCInvoiceObj.INVcomment1=ResultMegObj.billNoList.GetAt(i).billBatchCode  			;票据代码
	..s DHCInvoiceObj.INVBillInvCode=ResultMegObj.billNoList.GetAt(i).billBatchCode  	;票据代码
	..s DHCInvoiceObj.INVStartInv=ResultMegObj.billNoList.GetAt(i).billBgnNo            ;票据起始号码
	..s DHCInvoiceObj.INVEndInv=ResultMegObj.billNoList.GetAt(i).billEndNo		   	    ;票据终止号码
	..s DHCInvoiceObj.INVUsr=UserID
	..s DHCInvoiceObj.INVhospital=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
	..d objValidBillNo.INVBillNoList.Insert(DHCInvoiceObj)	
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取当前纸质票据可用号码服务结果
/// 入参说明:	placeCode(收费员编码)
/// 			pBillBatchCode:纸质票据代码(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
/// 返 回 值：	成功标志^纸质票据代码^纸质票据号  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.AXNHTA).CurrPaperInv("","","") 
ClassMethod CurrPaperInv(InputPam As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef ObjPaperBillNo As BILL.EINV.DTO.COM.PaperBillNo) As %String
{
	s RtnFlag="-1"
	
	//组织票据有效票据号段入参
	s UserID=$p(InputPam,"^",1)
	s EInvTurnPaper=##class(BILL.EINV.DTO.BSA.BlankPaperInvalidReq).%New()
	s EInvTurnPaper.placeCode=$p(InputPam,"^",1)             ;开票点编码
	//s EInvTurnPaper.placeCode=$p($g(^SSU("SSUSR",UserID)),"^",1)  ;开票点编码
	s EInvTurnPaper.pBillBatchCode=$p(InputPam,"^",2)		 ;纸质票据代码
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(EInvTurnPaper,.Stream)
	s InputJson=Stream.Read()
	s ServiceCode="getPaperBillNo"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("CURRNO",30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)

	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	i ('$IsObject(ObjPaperBillNo)) d
	.s ObjPaperBillNo=##class(BILL.EINV.DTO.COM.PaperBillNo).%New()
	
	i (Rtn="S0000") d
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	.s ObjPaperBillNo.pBillBatchCode=ResultMegObj.pBillBatchCode		;纸质票据代码
	.s ObjPaperBillNo.pBillNo=ResultMegObj.pBillNo						;纸质票据号
	
	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取换开纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.AXNHTA).PrintPaper("","") 
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s InputJson=..TurnPaperInvoice(ObjInvUpDetail,InvociePam)
	s ServiceCode="turnPaper"			;接口服务名称
 	s HISUniqueID=ObjInvUpDetail.IUDBusNo			;唯一流水号
	s Message=InputJson								;业务入参
	
	b ;PrintPaper 1
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
	
	b ;PrintPaper 2
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	b ;PrintPaper 3
	i Rtn="S0000"  s RtnFlag=0
	;+dongkf 2020 05 27 start 如果患者在自助机上做了换开这里返回失败信息
	i Rtn'="S0000" d
	.s RtnFlag="-1"
	.s InvociePam.ErrMsgInfo=OutJsonStream
	;+dongkf 2020 05 27 end
	
	//换开纸质票据成功之后, 调用服务接口根据原电子发票代码、原电子发票号码获取电子票据状态
	if (RtnFlag="0"){ 
		b ;PrintPaper 4
		s InvStatusRtn=..GetInvStatusOfPaper(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		b ;PrintPaper 5
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取换开纸质票据服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfPaper("","","") 
ClassMethod GetInvStatusOfPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s ServiceCode="getEBillStatesByBillInfo"			;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d 
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	.s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state				;状态
	.s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.isPrtPaper				;是否打印纸质票据
	.s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.isScarlet			;是否已开红票
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.billBatchCode	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.billNo			    ;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResultMegObj.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end
	
	.//换开纸质票据时，如果打印标志不为1则换开纸质票据失败
	.i (ResultMegObj.isPrtPaper'="1") d
	..s Rtn="E0001" 
	.e  d              
	..s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.pBillBatchCode			;纸质票据代码
	..s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.pBillNo					;纸质票据号码
	..s ObjInvUpDetail.IUDResultMeg="已换开成功"
	..s ObjInvUpDetail.EInvFlg="I"
	..s ObjInvUpDetail.IUDUser=InvociePam.UserID              ;开票人	

	s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功

	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取重新换开纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.AXNHTA).RePrintPaper("","") 
ClassMethod RePrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	b ;RePrintPaper 0
	s InputJson=..TurnPaperInvoice(ObjInvUpDetail,InvociePam)
	b ;RePrintPaper 0-1
	s ServiceCode="reTurnPaper"			;接口服务名称
 	s HISUniqueID=ObjInvUpDetail.IUDBusNo 			;唯一流水号
	s Message=InputJson							;业务入参

	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)

	b ;RePrintPaper 1
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	b ;RePrintPaper 2
	i Rtn="S0000"  s RtnFlag=0
	
	//重新换开纸质票据成功之后, 调用服务接口根据原电子发票代码、原电子发票号码获取电子票据状态
	if (RtnFlag="0"){ 
		s InvStatusRtn=..GetInvStatusOfRePaper(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
	}
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取重新换开纸质票据服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfRePaper("","","") 
ClassMethod GetInvStatusOfRePaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s ServiceCode="getEBillStatesByBillInfo"			;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	.s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state				;状态
	.s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.isPrtPaper				;是否打印纸质票据
	.s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.isScarlet			;是否已开红票
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.billBatchCode	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.billNo			    ;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResultMegObj.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end
	.//重新换开纸质票据时,如果传入当前的纸质票据号码与返回的纸质票据号码不一致则重新换开失败
	.i (InvociePam.pBillNo'=ResultMegObj.pBillNo) d
	..s Rtn="E0001"
	.e  d
	..s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.pBillBatchCode			;纸质票据代码
	..s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.pBillNo					;纸质票据号码
	..s ObjInvUpDetail.IUDResultMeg="已换开成功"
	..s ObjInvUpDetail.EInvFlg="I"	
	..s ObjInvUpDetail.IUDUser=InvociePam.UserID              ;开票人

	s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功

	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取作废换开的纸质票据接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.AXNHTA).InvalidPaperInv("","") 
ClassMethod InvalidPaperInv(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="0"
	s InputJson=..TurnPaperInvalid(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	s ServiceCode="invalidPaper"					;接口服务名称
 	s HISUniqueID=ObjInvUpDetail.IUDBusNo			;唯一流水号
	s Message=InputJson								;业务入参

	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)

	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	if (Rtn="S0000") {
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail,OutJsonStream)  ;;把红冲开票结果信息保存到交易表
	}else{
		//s ObjInvUpDetail.IUDResultCode=Rtn                	;错误信息编码
		//s ObjInvUpDetail.IUDResultMeg=OutJsonStream     		;错误信息描述
		//s InvociePam.ErrMsgInfo=OutJsonStream
		//s RtnFlag="-1"
		s RtnFlag="0"
	}
	//开票成功的情况下, 调用服务接口获取开票状态
	if (RtnFlag="0"){ 
		//如果成功，保存作废换开返回值
		;s eScarletBillBatchCode=ObjInvUpDetail.IUDBillBatchCode      ;电子红票票据代码
		;s eScarletBillNo=ObjInvUpDetail.IUDBillBatchNo             ;电子红票票据号码
		s InvStatusRtn=..GetInvStatusOfInvalidPaper(ObjInvUpDetail, InvociePam)  ;获取开票状态	
		if InvStatusRtn'="0" {
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}
		
		//重新将值赋给红票对象
		;s ObjInvUpDetail.IUDBillBatchCode=eScarletBillBatchCode
		;s ObjInvUpDetail.IUDBillBatchNo =eScarletBillNo
	}
	
	q RtnFlag
}

/// 功能说明：调用服务接口获取作废换开纸质票据服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：苏惠德   2019-09-17 
/// 其    他：w ##class(BILL.EINV.ADP.AXNHTA).GetInvStatusOfInvalidPaper("","","") 
ClassMethod GetInvStatusOfInvalidPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s ServiceCode="getEBillStatesByBillInfo"			;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType, 30, "") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, InvociePam.ObjUPConfig)
		
	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)

	i Rtn="S0000"  d 
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.EInvStatesMegRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultMegObj,"")
	.s ObjInvUpDetail.IUDBillBatchName=ResultMegObj.billName			;电子票据种类名称
	.s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.state				;状态
	.s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.isPrtPaper				;是否打印纸质票据
	.s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.isScarlet			;是否已开红票
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	
	.;+zzw 2020 01 03 start 票据号码信息保存
	.s:ObjInvUpDetail.IUDBillBatchCode="" ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.billBatchCode	;电子票据代码
	.s:ObjInvUpDetail.IUDBillBatchNo="" ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.billNo			    ;电子票据号码
	.s:ObjInvUpDetail.IUDCheckCode="" ObjInvUpDetail.IUDCheckCode=ResultMegObj.random					;电子校验码
	.s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
	.s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	.;+zzw 2020 01 03 end
	
	.i ((ResultMegObj.scarletBillBatchCode="")||(ResultMegObj.scarletBillNo="")) d
	..s Rtn="E0001"
	.e  d
	..s ObjInvUpDetail.IUDResultMeg="冲红成功"
	..s ObjInvUpDetail.EInvFlg="S"											;;发票状态
	..s ObjInvUpDetail.IUDPrintType="E"	;;更新票据模式 add by xubaobao 2019 09 28
	..;add by xubaobao 2020 04 02 ---------------------------------
	..;s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.billBatchCode
	..;s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.billNo
	..s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.scarletBillBatchCode
	..s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.scarletBillNo
	..s ObjInvUpDetail.IUDCheckCode=ResultMegObj.scarletRandom
	..s ObjInvUpDetail.IUDBillQRCode=ResultMegObj.scarletBillQRCode
	
	s ObjInvUpDetail.IUDResultCode=Rtn   ;查询状态 信息是否成功

	//对结果进行判断，成功返回0，失败返回-1
	i (Rtn="S0000") s RtnFlag=0
	e   s RtnFlag="-1"
	
	q RtnFlag
}

/// 功能说明： 对第三方返回的json加密数据进行解析
ClassMethod DecryptionResult(Response, ByRef OutJsonStream As %String) As %String
{
	//宁波鄞州人民测试用--调用平台组接口
	//如果是我们自己与第三方（博思）对接，此处代码需要注释掉
	;s Rtn=..DecryptionResultToENS(Response, .OutJsonStream)
	;q Rtn
	
	s Rtn="-1"
	s ResultObj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceRes).%New()
	d ResultObj.XMLNodeDeserialize(.ResultObj, "siiscmd", Response)
	s sendbackinvobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInv).%New()
	s sendbackinvobj=ResultObj.sendbackinv
	s sendbackinvrecordobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInvRecord).%New()
	s sendbackinvrecordobj=sendbackinvobj.sendbackinvrecord
	s sendbackinvrecordheadobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInvRecordhead).%New()
	s sendbackinvrecordheadobj=sendbackinvrecordobj.sendbackinvrecordhead
	
	s Rtn=sendbackinvrecordheadobj.binvcode_sendbackinvrecordheadobj.binvnr
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
	//s BusType=$case(AdmType,"IP":"01","OP":"02","API":"02","OT":"02","IT":"01","PE":"05","REG":"06","DEP":"07",:0)    				 
    s BusType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessTypeCon"_ObjUPConfig.FactoryCode, AdmType, 5)
    q BusType
}

/// 功能说明：   通过HIs卡类型获取对应的第三方的卡类型
/// 入参：       CardType：卡类型
/// 出参：       第三方接口对应的卡类型
/// 备注说明：   目前根据HIs卡类型和第三方接口文档里面提供的卡类型在程序里面进行匹配
ClassMethod GetBusCardType(CardType As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	;第三方卡类型(1102:社会保险号;3101:诊疗卡/就诊卡;4101:4101)
	//s BusCardType=$case(CardType,"1":"1102","2":"3101","16":"3101","17":"1102","19":"3101","20":"3101","":"")    				 
    s BusCardType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("CardTypeCon"_ObjUPConfig.FactoryCode, CardType, 5)
    q BusCardType
}

/// 功能说明：   通过支付方式编码获取对应的第三方的交费渠道信息
/// 入参：       PayModeCode：支付方式编码
/// 出参：       第三方接口对应的交费渠道
/// 备注说明：   目前根据HIs卡类型和第三方接口文档里面提供的卡类型在程序里面进行匹配
ClassMethod GetBusPayMode(PayModeCode As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	;第三方交费渠道
	//s BusPayModeCode=$Case(PayModeCode,"CASH":"02","CPP":"12","YHK":"07","CARDCPP":"08","ZP":"06","YBINSU1":"11",:"02")    				 
    s BusPayModeCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("PayModeCon"_ObjUPConfig.FactoryCode, PayModeCode, 5)
    q BusPayModeCode
}

/// 功能说明：   通过日期时间获取对应的第三方上传时间格式
/// 入参：       Date：日期
/// 				 Time: 时间
/// 出参：       第三方接口对应的上传时间格式(格式：yyyyMMddHHmmssSSS)
ClassMethod GetBusDate(Date, Time) As %String
{
	s rtnDate=""
	i Date'["-" s Date=$zd(Date,3)
	i Time'[":" s Time=$zt(Time,1)
	
	s rtnDate=Date_" "_Time
	q rtnDate
}

/// Base64解密
ClassMethod Base64Decode(Base64Str, CharSet = "UTF8")
{
	set Src=##class(%SYSTEM.Encryption).Base64Decode(Base64Str)
	set Src=$zcvt(Src,"I",CharSet)
	quit Src
}

/// Base64加密
ClassMethod Base64Encode(Base64Str, CharSet = "UTF8")
{
	set Src=$zcvt(Base64Str,"O",CharSet)
	quit ##class(%SYSTEM.Encryption).Base64Encode(Src)
}

/// 组织第三方接口需要的Json参数
/// HISUniqueID： HIS端唯一流水
/// Message: 	  交易服务入参
/// ObjUPConfig： 服务配置对象
/// 出参：        第三方返回结果
ClassMethod InvoiceENSRequest(ServiceCode As %String, HISUniqueID As %String, Message As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s rtn="-1"
	
	set SecretKey=ObjUPConfig.IUCSecretKey						;秘钥
	set AppID=ObjUPConfig.IUCAPPID								;应用账户										
	set Version=ObjUPConfig.IUCVersion							;版本号
	set Noise=HISUniqueID	;HIS端唯一流水
	Set Data64=..Base64Encode(Message)       	 ;Base64加密
	
	set Input="appid="_AppID_"&"_"data="_Data64_"&"_"noise="_Noise_"&"_"key="_SecretKey_"&"_"version="_Version
	Set Sign=##class(web.Util.Encryption).MD5HexStr($zcvt(Input,"O","UTF8"))  ;MD5加密
	set Sign=$zcvt(Sign,"U")                   ;签名
	
	s ENSObj=##class(BILL.EINV.DTO.BSA.ENSReq).%New()
	s ENSObj.appid=AppID   ;应用账号
	s ENSObj.data=Data64				   ;请求业务参数
	s ENSObj.noise=Noise   ;请求随机标识
	s ENSObj.version=Version   ;版本号
	s ENSObj.sign=Sign   ;签名
	
	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ENSObj,.Stream)
	;s rtn=Stream.Read()
	s EnsJson=Stream.Read()
	q:EnsJson="" rtn
	
	//调用平台组接口
	s rtn=##class(web.DHCENS.EnsHISService).SendBillInfo(ServiceCode,EnsJson)
	//对平台组返回值进行解析
	//s rtn=..DecryptionResultToENS(EnsRtnData,.OutJsonStream)
	
	q rtn
}

/// 调用平台组接口对返回值进行解密
/// 功能说明： 对HIS平台组返回的json加密数据进行解析
/// w ##class(BILL.EINV.ADP.AXNHTA).DecryptionResultToENS("","")
ClassMethod DecryptionResultToENS(DataStream, ByRef OutJsonStream As %String) As %String
{
	s Rtn="-1"
	set ResultENSObj=##class(BILL.EINV.DTO.BSA.ENSReq).%New()
	If DataStream'="" {
		//set DataStream=DataStream.Read(DataStream.Size)
		set Stream=##class(%GlobalCharacterStream).%New()
		do Stream.Write(DataStream)
		do ##class(ext.util.JsonObject).JSONStreamToObject(Stream,.ResultENSObj,"")
		set Data=..Base64Decode(ResultENSObj.data,"UTF8")
	}
	set ResultObj=##class(BILL.EINV.DTO.BSA.OPInvoiceRes).%New()
	s ResultStream=##class(%GlobalCharacterStream).%New()
	d ResultStream.Write(Data)
	d ##class(ext.util.JsonObject).JSONStreamToObject(ResultStream,.ResultObj,"")
	s Rtn=ResultObj.result
	s OutJsonStream=..Base64Decode(ResultObj.message,"UTF8")
	;w !,Rtn
	;w !,OutJsonStream
	b ;ENS02
	q Rtn
}

/// 接口函数(博思2.0.3)4.6.2.2	开票点数据核对接口
/// 功能：查询收费员业务时间内的开票数据
/// 编写：guoyunlong
/// 时间：2019-09-29
ClassMethod checkDataByPlace(inputData As %String, ObjCheckData As BILL.EINV.DTO.COM.CheckData, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s Rtn="-1"
	s ObjcheckData=##class(BILL.EINV.DTO.BSA.checkDataByPlaceReq).%New()
	s ObjcheckData.busDate=$p(inputData,"^",1)        ;业务日期
	s ObjcheckData.placeCode=$p(inputData,"^",2)  	 ;开票点编码
	s ObjcheckData.isReturnList=$p(inputData,"^",3)     ;是否返回列表
	s ObjcheckData.pageNo=$p(inputData,"^",4)             ;页码
	s ObjcheckData.pageSize=$p(inputData,"^",5)         ;每页条数

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjcheckData,.Stream)
	s InputJson=Stream.Read()
	
	;???开票点数据核对接口  接口服务名称
	s ServiceCode=""						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("CURRNO",30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)

	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	i ('$IsObject(ObjCheckData)) d
	.s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()
	
	i (Rtn="S0000") d
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.checkDataByPlaceRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	.s ObjCheckData.AllTotalAmt=ResultMegObj.allTotalAmt            ;总金额
	.s ObjCheckData.AllTotalNum=ResultMegObj.allTotalNum            ;总开票数
	.s ObjCheckData.BusDate=ResultMegObj.busDate                ;业务日期
	.s ObjCheckData.CopyNum=ResultMegObj.copyNum                ;总笔数
	.s ObjCheckData.InvBillNoList=ResultMegObj.billNoList
	.f i=1:1:ObjCheckData.InvBillNoList.Size  do
	..s BalanceSubDayObj = ##class(BILL.EINV.DTO.COM.InvBillNoList).%New()
	..s BalanceSubDayObj.bgnNo=ResultMegObj.billNoList.GetAt(i).bgnNo   ;起始号码
	..s BalanceSubDayObj.endNo=ResultMegObj.billNoList.GetAt(i).endNo         ;终止号码
	..s BalanceSubDayObj.billBatchCode=ResultMegObj.billNoList.GetAt(i).billBatchCode  ;票据代码
	..s BalanceSubDayObj.billName=ResultMegObj.billNoList.GetAt(i).billName   ;票据种类名称
	..s BalanceSubDayObj.copyNum=ResultMegObj.billNoList.GetAt(i).copyNum     ;票号段内总开票数
	..s BalanceSubDayObj.totalAmt=ResultMegObj.billNoList.GetAt(i).totalAmt   ;票号段内总金额
	..d ObjCheckData.InvBillNoList.Insert(BalanceSubDayObj)
	//对结果进行判断，成功返回0，失败返回-1
	s Rtn=0
	q Rtn
}

/// 4.6.2.1	总笔数核对接口()
/// 功能：查询业务日期内的明细数据
/// 编写：guoyunlong
/// 时间：2019-09-29
ClassMethod checkTotalData(inputData As %String, ObjCheckData As BILL.EINV.DTO.COM.CheckData, ObjUPConfig As BILL.EINV.PO.InvUpConfig)
{
	s Rtn="-1"
	s ObjcheckData=##class(BILL.EINV.DTO.BSA.checkDataByPlaceReq).%New()
	s ObjcheckData.busDate=$p(inputData,"^",1)        ;业务日期
	s ObjcheckData.isReturnList=$p(inputData,"^",2)     ;是否返回列表
	s ObjcheckData.pageNo=$p(inputData,"^",3)             ;页码
	s ObjcheckData.pageSize=$p(inputData,"^",4)         ;每页条数

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjcheckData,.Stream)
	s InputJson=Stream.Read()
	
	;???开票点数据核对接口  接口服务名称
	s ServiceCode="checkTotalData"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("CURRNO",30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)

	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	i ('$IsObject(ObjCheckData)) d
	.s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()
	
	i (Rtn="S0000") d
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.checkDataByPlaceRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	.s ObjCheckData.AllTotalAmt=ResultMegObj.allTotalAmt            ;总金额
	.s ObjCheckData.AllTotalNum=ResultMegObj.allTotalNum            ;总开票数
	.s ObjCheckData.BusDate=ResultMegObj.busDate                ;业务日期
	.s ObjCheckData.CopyNum=ResultMegObj.copyNum                ;总笔数
	.;s ObjCheckData.InvBillNoList=ResultMegObj.billNoList
	.;b ;000
	.f i=1:1:ResultMegObj.billNoList.Size  do
	..s BalanceSubDayObj = ##class(BILL.EINV.DTO.COM.InvBillNoList).%New()
	..s BalanceSubDayObj.bgnNo=ResultMegObj.billNoList.GetAt(i).bgnNo   ;起始号码
	..s BalanceSubDayObj.endNo=ResultMegObj.billNoList.GetAt(i).endNo         ;终止号码
	..s BalanceSubDayObj.billBatchCode=ResultMegObj.billNoList.GetAt(i).billBatchCode  ;票据代码
	..s BalanceSubDayObj.billName=ResultMegObj.billNoList.GetAt(i).billName   ;票据种类名称
	..s BalanceSubDayObj.copyNum=ResultMegObj.billNoList.GetAt(i).copyNum     ;票号段内总开票数
	..s BalanceSubDayObj.totalAmt=ResultMegObj.billNoList.GetAt(i).totalAmt   ;票号段内总金额
	..d ObjCheckData.InvBillNoList.Insert(BalanceSubDayObj)
	//对结果进行判断，成功返回0，失败返回-1
	s Rtn=0
	q Rtn
}

/// 接口函数博思2.0.3(4.6.2.4	根据业务时间获取开票信息接口)
/// 功能：查询业务日期内的明细数据
/// 编写：guoyunlong
/// 时间：2019-09-29
ClassMethod getBillByBusDate(inputData As %String, ObjCheckData As BILL.EINV.DTO.COM.CheckData, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	s Rtn="-1"
	s ObjGetBillByBusDate=##class(BILL.EINV.DTO.BSA.GetBillByBusDateReq).%New()
	s ObjGetBillByBusDate.busBgnDate=$p(inputData,"^",1)       ;业务起始日期
	s ObjGetBillByBusDate.busEndDate=$p(inputData,"^",2)      ;业务截止日期
	s ObjGetBillByBusDate.placeCode=$p(inputData,"^",3)        ;开票点编码
	s ObjGetBillByBusDate.dataType=$p(inputData,"^",4)     ;数据类型
	s ObjGetBillByBusDate.pageNo=$p(inputData,"^",5)            ;页码
	s ObjGetBillByBusDate.pageSize=$p(inputData,"^",6)     ;每页条数

	//调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(ObjGetBillByBusDate,.Stream)
	s InputJson=Stream.Read()
	
	;???开票点数据核对接口  接口服务名称
	s ServiceCode="getBillByBusDate"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo("CURRNO",30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//调用博思http接口
	s outData=##class(BILL.EINV.BI.BSA.HTTPRequest).InvoiceRequest(ServiceCode, HISUniqueID, Message, ObjUPConfig)

	//对返回结果进行解密并保存
	s OutJsonStream=""
	s Rtn=..DecryptionResult(outData, .OutJsonStream)
	
	i ('$IsObject(ObjCheckData)) d
	.s ObjCheckData=##class(BILL.EINV.DTO.COM.CheckData).%New()
	
	i (Rtn="S0000") d
	.s ResultMegObj=##class(BILL.EINV.DTO.BSA.GetBillByBusDateRes).%New()
	.s Stream=##class(%GlobalCharacterStream).%New()
	.d Stream.Write(OutJsonStream)
	.d ##class(ext.util.JsonObject).JSONStreamToObject(Stream, .ResultMegObj, "")
	.s ObjCheckData.total=ResultMegObj.total             ;总条数
	.s ObjCheckData.pageNo=ResultMegObj.pageNo           ;当前页面
	.;s ObjCheckData.InvBillNoList=ResultMegObj.billList  ;开票明细列表
	.f i=1:1:ResultMegObj.billList.Size  do
	..s InvBillObj = ##class(BILL.EINV.DTO.COM.InvBillNoList).%New()
	..s InvBillObj.busDate=ResultMegObj.billList.GetAt(i).busDate     ;业务日期
	..s InvBillObj.busNo=ResultMegObj.billList.GetAt(i).busNo   ;业务流水号
	..s InvBillObj.placeCode=ResultMegObj.billList.GetAt(i).placeCode        ;开票点编码
	..s InvBillObj.billName=ResultMegObj.billList.GetAt(i).billName        ;票据种类名称
	..s InvBillObj.billBatchCode=ResultMegObj.billList.GetAt(i).billBatchCode  ;票据代码
	..s InvBillObj.billNo=ResultMegObj.billList.GetAt(i).billNo   ;票据号码
	..s InvBillObj.random=ResultMegObj.billList.GetAt(i).random     ;校验码
	..s InvBillObj.totalAmt=ResultMegObj.billList.GetAt(i).totalAmt   ;总金额
	..s InvBillObj.ivcDateTime=ResultMegObj.billList.GetAt(i).ivcDateTime     ;开票时间
	..s InvBillObj.dataType=ResultMegObj.billList.GetAt(i).dataType   ;数据类型
	..s InvBillObj.state=ResultMegObj.billList.GetAt(i).state         ;状态
	..s InvBillObj.relateBillBatchCode=ResultMegObj.billList.GetAt(i).relateBillBatchCode   ;关联电子票据代码
	..s InvBillObj.relateBillNo=ResultMegObj.billList.GetAt(i).relateBillNo   ;关联电子票据号码
	..d ObjCheckData.InvBillNoList.Insert(InvBillObj)
	//对结果进行判断，成功返回0，失败返回-1
	s Rtn=0
	q Rtn
}

/// 功能说明： 对第三方返回的json加密数据进行解析
ClassMethod GetInvNo(Response, ByRef OutJsonStream As %String) As %String
{
	//宁波鄞州人民测试用--调用平台组接口
	//如果是我们自己与第三方（博思）对接，此处代码需要注释掉
	;s Rtn=..DecryptionResultToENS(Response, .OutJsonStream)
	;q Rtn
	
	s Rtn=""
	s ResultObj=##class(BILL.EINV.DTO.AXNHTA.OPInvoiceRes).%New()
	Do ResultObj.XMLNodeDeserialize(.ResultObj,"siiscmd",Response)
	s sendbackinvobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInv).%New()
	s sendbackinvobj=ResultObj.sendbackinv
	s sendbackinvrecordobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInvRecord).%New()
	s sendbackinvrecordobj=sendbackinvobj.sendbackinvrecord
	s sendbackinvrecordheadobj=##class(BILL.EINV.DTO.AXNHTA.SendBackInvRecordhead).%New()
	s sendbackinvrecordheadobj=sendbackinvrecordobj.sendbackinvrecordhead
	
	s Rtn=sendbackinvrecordheadobj.binvcode_sendbackinvrecordheadobj.binvnr
	q Rtn
}

}
