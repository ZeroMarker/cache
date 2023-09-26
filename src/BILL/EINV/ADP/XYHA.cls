Class BILL.EINV.ADP.XYHA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XYHA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).Invoice开始")
	
	s RtnFlag="0"
	
	b ;Invoice 0
	//组织开具接口入参
	q:ObjInvUpDetail.IUDPayAdmType="DEP" "-1"	;预交金不开票
 	i (ObjInvUpDetail.IUDPayAdmType="IP"){ 
		s InputJson=..InvoiceIP(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  
	}else{
		s InputJson=..InvoiceOP(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}
	s:InputJson="" InvociePam.ErrMsgInfo="组织开具入参发生错误"
	q:InputJson="" "-1"   ;组织入参发生错误
	
	
	d ##class(BILL.EINV.COM.Common).WriteLog(InputJson)
	b ;Invoice 1
	
	s ObjInvUpDetail.Xstr1=ObjInvPrtInfo.PatAdmInfo.AdmNo
	
	//开票前,调用票据查询接口,如果已经开票直接保存开票结果
	s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;查询开票情况
	q:InvStatusRtn="-9999" "-1"	;调用服务异常
	q:InvStatusRtn="0" RtnFlag
	b ;Invoice 2
	
	//查询不到开票信息时 调用开票业务
	s ServiceCode="ticketNew"	;接口服务名称
	s Message=InputJson							;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest(ServiceCode,Message, InvociePam, .OutputObj)
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
		s InvStatusRtn=..GetInvStatusOfInvoice(ObjInvUpDetail, ObjInvPrtInfo, InvociePam)  ;查询开票情况	
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
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).SetInvResultOfInvoice开始.")

	s ResultMegObj=OutputObj.data
	b ;SetInvResultOfInvoice 2
	
			
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.einvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.einvoiceNumber		;电子票据号码
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.einvoiceCode_ResultMegObj.einvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.billUrl		;电子票据 pdf 地址
	i ResultMegObj.time="" d
	.s ObjInvUpDetail.IUDCreatDate=+$h			;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)	;电子票据生成时间
	e  d
	.s createDateTime=##class(BILL.EINV.COM.Common).GetTimeStampToDateTime(ResultMegObj.time)
	.s createDate=$p(createDateTime," ",1)
	.s createTime=$p(createDateTime," ",2)
	.s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)		;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$zth(createTime,1)		;电子票据生成时间
	
	s RtnFlg="0"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).SetInvResultOfInvoice结束.")
	q RtnFlg
}

/// 功能说明：票据查询(状态)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 			ObjUPConfig		-->配置对象
/// 返 回 值：返回接口文档对应的json格式           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XYHA).GetEINVResultByBusNo("","","") 
ClassMethod GetInvStatusOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).GetInvStatusOfInvoice开始.")
	
	//1.组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail,ObjInvPrtInfo)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag
	b ;GetInvStatusOfInvoice 1
	
	s ServiceCode="ticketSearch"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest(ServiceCode,Message, InvociePam, .OutputObj)
	b ;
	q:RtnCode'="0" RtnCode
	
	b ;//4.保存结果信息
	q:OutputObj.data.Size=0 "-1"	;查询无结果时认为查询失败。
	s ResultMegObj=OutputObj.data
	b ;GetInvStatusOfInvoice 2
	;q:ResultMegObj.GetAt(1).State'="1" "-1"	;开票状态 0 失败，1 正常
	
	;s ObjInvUpDetail.IUDAcceptid=ResultMegObj.GetAt(1).SerialNumber			;第三方的业务流水号
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.GetAt(1).einvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.GetAt(1).einvoiceNumber		;电子票据号码
	;s ObjInvUpDetail.IUDCheckCode=ResultMegObj.RandomNumber		;电子校验码
	i ResultMegObj.GetAt(1).issuetTime="" d
	.s ObjInvUpDetail.IUDCreatDate=+$h			;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)	;电子票据生成时间
	e  d
	.s createDateTime=ResultMegObj.GetAt(1).issuetTime
	.s createDate=$p(createDateTime," ",1)
	.s createTime=$p(createDateTime," ",2)
	.s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,3)		;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$zth(createTime,1)		;电子票据生成时间
	s ObjInvUpDetail.IUDBillPictureData=ResultMegObj.GetAt(1).imgStr	;电子票据图片 BASE64
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.GetAt(1).pdfPath		;电子票据 pdf 地址
	s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=OutputObj.code	
	s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.GetAt(1).States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
	s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.GetAt(1).State	;电子票据状态(0 失败，1 正常)
	s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.GetAt(1).States.Reversal.IsReversal	;是否已开红票
	s ObjInvUpDetail.Xstr2=ResultMegObj.GetAt(1).webPdfPath		;外网地址
	s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"									;发票状态
	b ;GetInvStatusOfInvoice 3
	s RtnFlag="0"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).GetInvStatusOfInvoice结束.RtnFlag="_RtnFlag)
	
	q RtnFlag
}

/// 功能说明：整理根据电子票据代码和电子票据号获取票据状态入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式          
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XYHA).QueryInvStatus("","","") 
ClassMethod QueryInvStatus(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s rtn=""
	
	//1.组织电子票据开票状况入参
	s InvStatusRt=##class(BILL.EINV.DTO.XYHA.InvoiceStatesQryReq).%New()
	s InvStatusRt.orgCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	s InvStatusRt.mainType=$Case(ObjInvUpDetail.IUDPayAdmType,"IP":"2",:"1")
	;s InvStatusRt.bizCode=ObjInvUpDetail.IUDBusNo				;HIS业务流水号
	i (ObjInvUpDetail.IUDUploadPathCode="InvalidInvSvr")||(ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="RePrintPaper"){
		s InvStatusRt.bizCode=ObjInvUpDetail.OriInvUpDetail.IUDBusNo				;业务流水号
	} elseif ((ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv")){
		s EInvTradDr=ObjInvUpDetail.OriInvUpDetail.IUDInitRowID  ;纸质票据对应的电子票据交易表dr
		if (EInvTradDr'=""){
			s objEinvTrade=##class(BILL.EINV.PO.InvUpDetails).%OpenId(EInvTradDr)
			if ($isobject(objEinvTrade)'=0) {
				s InvStatusRt.bizCode=objEinvTrade.IUDBusNo				;HIS业务流水号
			}
		}
	}else{
		s InvStatusRt.bizCode=ObjInvUpDetail.IUDBusNo				;HIS业务流水号
	}
	//2.调用固定方法进行对象转Json
	s InvStatusRt.bizCode=ObjInvPrtInfo.PatAdmInfo.AdmNo_InvStatusRt.bizCode
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s rtn=Stream.Read()
	
	q rtn
}

/// 功能说明：整理门诊电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XYHA).InvoiceOP("","","") 
ClassMethod InvoiceOP(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).InvoicePam开始")
	
	s signContentObj=##class(BILL.EINV.DTO.XYHA.OPInvoiceContent).%New()
	
	//门诊票面信息表
	s invMainObj=##class(BILL.EINV.DTO.XYHA.OPInvoiceMain).%New()
	s invMainObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	;s invMainObj.EINVOICENAME=""	;电子票据名称N
	s invMainObj.INVOICENO=ObjInvUpDetail.IUDBusNo	;医院票据号（唯一）
	s invMainObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;门诊号
	s invMainObj.EINVOICECODE=""	;电子票据代码（来源财政）N
	s invMainObj.EINVOICENUMBER=""	;电子票据号码（来源财政）N
	s invMainObj.INVOICETYPE="1"	;开票类型（１：新开；０：作废）
	s invMainObj.VISITDATEJ=$replace(ObjInvPrtInfo.PatAdmInfo.AdmDate,"-","")_"-"_ObjInvPrtInfo.PatAdmInfo.AdmTime	;就诊时间 20201104-03:11:05
	s invMainObj.OFFICECODE=ObjInvPrtInfo.PatAdmInfo.DepCode	;就诊科室代码（医院内部）
	s invMainObj.OFFICENAME=ObjInvPrtInfo.PatAdmInfo.DepDesc	;就诊科室名称（医院内部）
	s invMainObj.FDRCODE=ObjInvPrtInfo.PatAdmInfo.DocCode	;就诊医师代码（医院内部）
	s invMainObj.FDR=ObjInvPrtInfo.PatAdmInfo.DocDesc		;就诊医师姓名（医院内部）
	s invMainObj.TOTALAMOUNT=$fn(+ObjInvPrtInfo.InvAmt,"",2)	;总金额
	s invMainObj.ISSUETIMEJ=$zd(ObjInvPrtInfo.BusDate,8)_"-"_$zt(ObjInvPrtInfo.BusTime,1)	;开票时间
	;s invMainObj.INVOICINGCLERK=ObjInvPrtInfo.BusUserCode	;开票员代码
	s invMainObj.INVOICINGCLERK=InvociePam.UserCode	;开票员代码
	;b ;invMainObj.INVOICINGCLERK 开票员代码
	s invMainObj.HANDLINGPERSON=ObjInvPrtInfo.BusUserDesc		;开票人
	s invMainObj.CHECKER=ObjInvPrtInfo.BusUserDesc				;复核人
	;s invMainObj.CARDTYPE=ObjInvPrtInfo.PatBaseInfo.CardType	;卡类型
	s invMainObj.CARDTYPE=##class(BILL.EINV.COM.Common).GetBusCardType(ObjInvPrtInfo.PatBaseInfo.CardType, InvociePam.ObjUPConfig)    ;卡类型 (需要对照)
	s invMainObj.CARDNO=ObjInvPrtInfo.PatBaseInfo.CardNo		;卡号
	s invMainObj.PAYERPARTYTYPE="1"			;交款人类型(1:个人2:单位)
	s:(ObjInvUpDetail.IUDPayAdmType="PE")&&(ObjInvPrtInfo.PEBaseInfo.InvType="G") invMainObj.PAYERPARTYTYPE="2"
	s invMainObj.PAYERPARTYCODE=ObjInvPrtInfo.PatBaseInfo.PatID		;交款人代码(单位一般为统一社会信用代码；个人一般为身份证号)N
	s invMainObj.PAYERPARTYNAME=ObjInvPrtInfo.PatBaseInfo.PatName	;患者名称
	s invMainObj.GENDER=ObjInvPrtInfo.PatBaseInfo.Sex		;性别
	s invMainObj.AGE=ObjInvPrtInfo.PatBaseInfo.Age			;年龄
	s invMainObj.ADDRESS=ObjInvPrtInfo.PatBaseInfo.Address	;地址N
	s invMainObj.TEL=ObjInvPrtInfo.PatBaseInfo.Mobphone		;联系电话N
	s invMainObj.PAYERACCT=""	;患者账号N
	s invMainObj.PAYEROPBK=""	;患者开户行N
	s invMainObj.PAYMODE=""		;交款方式(字典)N
	;b ;invMainObj.PAYMODE
	s invMainObj.CURRENCYTYPE=""	;货币种类(字典)N
	s invMainObj.EXCHANGERATE=""	;汇率N
	s invMainObj.SUPERVISORREMARK=""	;备注N
	s invMainObj.PATIENTTYPE="0"	;;病人类型(０:自费,1:医保)
	s:ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc'="" invMainObj.PATIENTTYPE="1"
	;s invMainObj.MEDICALINSURANCETYPE=##class(BILL.EINV.COM.Common).GetBusInsuType(ObjInvPrtInfo.InsuDivInfo.InsuTypeCode, InvociePam.ObjUPConfig)	;医保类型:(字典)
	
	s invMainObj.MEDICALINSURANCETYPE=$p($g(^PAC("ADMREA",ObjInvPrtInfo.InsTypeDr)),"^",1)	;医保类型:(字典)
	s invMainObj.MEDICALINSURANCEID=ObjInvPrtInfo.InsuDivInfo.InsuId	;医保编号
	
	s invMainObj.CBDQ=ObjInvPrtInfo.InsuDivInfo.CenterNo	;参保地区
	s invMainObj.PREPAYAMOUNT="0.00"	;预缴金额
	s invMainObj.RECHARGEAMOUNT="0.00"	;补缴金额
	s invMainObj.REFUNDAMOUNT="0.00"	;退费金额
	;需核实医保取值-----------------------------------------------------------------------
	s invMainObj.DEDUCTIBLE=$fn(+ObjInvPrtInfo.InsuDivInfo.qfx,"",2)	;起付线
	s invMainObj.SELFPAYMENTCOST=$fn(+ObjInvPrtInfo.InsuDivInfo.SelfAmt,"",2)	;个人自费
	s invMainObj.YLSZF=""	;乙类首自付
	s invMainObj.ABLZF=""	;按比例自付
	s invMainObj.OWNPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)	;个人现金支付
	s invMainObj.ACCOUNTPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0,"",2)	;个人账户支付
	s invMainObj.FUNDPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay1,"",2)	;医保统筹基金支付
	s invMainObj.GWYBZ=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3,"",2)	;$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3,"",2)		;公务员补助
	s invMainObj.SZBZ=""		;师职补助
	s invMainObj.DEBXBX=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2,"",2)		;大额保险报销
	s invMainObj.CDEBX=""		;超大额报销
	s invMainObj.DBBXBX=""		;大病保险报销
	s invMainObj.DBBCBXBX=""	;大病补充保险报销
	s invMainObj.YLJZ=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay6,"",2)		;医疗救助
	s invMainObj.YYCDFY=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay9,"",2)		;医院承担费用
	s invMainObj.CQJCF=""		;产前检查费
	s invMainObj.OTHERPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.qfzf,"",2)	;其他支付
	
	;20201210 修改工程公司等记账支付方式的费别不是按医保结算但是需要在发票上显示相关费别
	s payModeObj=##class(BILL.EINV.DTO.XYHA.OPInvoiceDetails).%New()
	s payModeObj=ObjInvPrtInfo.PayModeInfo.GetAt(1)
	i payModeObj.Code="JZ" d
	.s invMainObj.OWNPAYAMOUNT="0.00"
	.s invMainObj.OTHERPAYAMOUNT=invMainObj.OTHERPAYAMOUNT+$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)
	.s invMainObj.PATIENTTYPE="1"	;;病人类型(０:自费,1:医保)
	

	s invMainObj.SELFPAYMENTAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.selfPayAmt,"",2)	;个人自付
	s invMainObj.SELFMAINEXT=""	;个性化其他项目信息
	s invMainObj.CREATETIMEJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳N
	s signContentObj.main=invMainObj
	
	//门诊单据表(费用分类信息)
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCate_ConFlag",5)  ;费用是否对照 1 对照 0 不对照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, "OP")
	.f num=1:1:$l(FeeConStr,",") d
	..s datadetailsObj=##class(BILL.EINV.DTO.XYHA.OPInvoiceDetails).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s datadetailsObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	..s datadetailsObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;门诊号
	..s datadetailsObj.INVOICENO=ObjInvUpDetail.IUDBusNo		;医院票据号
	..s datadetailsObj.DOCUMENTNUMBER=ObjInvUpDetail.IUDInvDr	;单据号
	..s datadetailsObj.EXECOFFICECODE=ObjInvPrtInfo.PatAdmInfo.DepCode	;执行科室代码
	..s datadetailsObj.EXECOFFICENAME=ObjInvPrtInfo.PatAdmInfo.DepDesc	;执行科室名称
	..s datadetailsObj.FDRCODE=ObjInvPrtInfo.PatAdmInfo.DocCode	;开单医生代码
	..s datadetailsObj.FDR=ObjInvPrtInfo.PatAdmInfo.DocDesc		;开单医生名称
	..s datadetailsObj.ITEMCODE=$p(CatFeeInfo,"^",1)	;大类项目编码（医院内部）
	..s datadetailsObj.ITEMNAME=$p(CatFeeInfo,"^",2)	;大类项目名称（医院内部）
	..s datadetailsObj.ITEMUNIT=""						;计量单位
	..s datadetailsObj.ITEMSTD=$p(CatFeeInfo,"^",3)	 	;收费标准
	..s datadetailsObj.ITEMQUANTITY=1					;数量
	..s datadetailsObj.ITEMAMOUNT=$p(CatFeeInfo,"^",3)	;金额
	..s datadetailsObj.ITEMREMARK=""					;项目备注
	..s datadetailsObj.CREATETIMEJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳N
	..d signContentObj.details.Insert(datadetailsObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s datadetailsObj=##class(BILL.EINV.DTO.XYHA.OPInvoiceDetails).%New()
	..s datadetailsObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	..s datadetailsObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;门诊号
	..s datadetailsObj.INVOICENO=ObjInvUpDetail.IUDBusNo		;医院票据号
	..s datadetailsObj.DOCUMENTNUMBER=ObjInvUpDetail.IUDInvDr	;单据号
	..s datadetailsObj.EXECOFFICECODE=ObjInvPrtInfo.PatAdmInfo.DepCode	;执行科室代码
	..s datadetailsObj.EXECOFFICENAME=ObjInvPrtInfo.PatAdmInfo.DepDesc	;执行科室名称
	..s datadetailsObj.FDRCODE=ObjInvPrtInfo.PatAdmInfo.DocCode	;开单医生代码
	..s datadetailsObj.FDR=ObjInvPrtInfo.PatAdmInfo.DocDesc		;开单医生名称
	..s datadetailsObj.ITEMCODE=ObjInvPrtInfo.InvCateInfo.GetAt(i).ID	;大类项目编码（医院内部）
	..s datadetailsObj.ITEMNAME=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;大类项目名称（医院内部）
	..s datadetailsObj.ITEMUNIT="null"						;计量单位
	..s datadetailsObj.ITEMSTD=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt	 	;收费标准
	..s datadetailsObj.ITEMQUANTITY=1					;数量
	..s datadetailsObj.ITEMAMOUNT=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt	;金额
	..s datadetailsObj.ITEMREMARK="null"					;项目备注
	..s datadetailsObj.CREATETIMEJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳N
	..d signContentObj.details.Insert(datadetailsObj)
	
	//门诊费用明细表(清单项目明细信息)
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s detailObj=##class(BILL.EINV.DTO.XYHA.OPInvoiceAuxDetails).%New()  
	.s detailObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	.s detailObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;门诊号
	.s detailObj.INVOICENO=ObjInvUpDetail.IUDBusNo		;医院票据号
	.s detailObj.DOCUMENTNUMBER=ObjInvUpDetail.IUDInvDr	;单据号                  
	.s detailObj.ITEMCODE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateID	;医院项目分类编码（医院内部）
	.s detailObj.FITEMHOSCLASSNAME=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;医院项目分类名称
	.;b ;89
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  		;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConXYH",FeeCateKey,0)  ;对照信息
	..s detailObj.ITEMCODE=$p(FeeItmCateConInfo, "^", 5)  			;费用分类编码
	..s detailObj.FITEMHOSCLASSNAME=$p(FeeItmCateConInfo, "^", 6)  			;费用分类名称                       
	.s detailObj.FITEMHOSCODE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;明细项目医院编码
	.s detailObj.FITEMNAME=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;明细项目名称
	.b ;000001
	.;i ObjInvUpDetail.IUDBusNo="HRSQDHW781973OP20201211165141635"  d     ;20201204 
	.s detailObj.FITEMNAME=$replace(detailObj.FITEMNAME,"[","(")
	.s detailObj.FITEMNAME=$replace(detailObj.FITEMNAME,"]",")")
	.b ;000002
	.s detailObj.FITEMSIZE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec		;明细项目规格
	.s detailObj.FITEMSIZE=$replace(detailObj.FITEMSIZE,"[","(")	;20201224
	.s detailObj.FITEMSIZE=$replace(detailObj.FITEMSIZE,"]",")")
	.s detailObj.FITEMUNIT=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit		;明细项目单位
	.s detailObj.FITEMUNIT=$replace(detailObj.FITEMUNIT,"[","(")	;20201224
	.s detailObj.FITEMUNIT=$replace(detailObj.FITEMUNIT,"]",")")
	.s detailObj.FPRICE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;明细项目单价
	.s detailObj.FQUA=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty				;明细数量
	.s detailObj.FMONEY=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;金额
	.s detailObj.FPAYDATEJ=$zd(ObjInvPrtInfo.BusDate,8)_"-"_$zt(ObjInvPrtInfo.BusTime,1)			;收费时间
	.s detailObj.HAMOUNT="null"				;付数
	.s detailObj.HFORMSNAME=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Form		;剂型名称
	.s detailObj.HFORMSCODE="null"	;ObjInvPrtInfo.InvItmDetInfo.GetAt(i).FormCode	;药物剂型代码
	.s detailObj.HDORCODE=ObjInvPrtInfo.PatAdmInfo.DocCode		;医院his处方医生编码
	.s detailObj.HDORNAME=ObjInvPrtInfo.PatAdmInfo.DocDesc		;处方医生姓名
	.s detailObj.HGROUPCODE="null"	;医嘱分组编号N
	.s detailObj.GROUPSER="null"	;医嘱组内序号N
	.s detailObj.HUSAGE="null"		;用药途径代码
	.s detailObj.HDOSAGE="null"		;用量
	.s detailObj.HDOSAGEUNIT="null"	;用量单位
	.s detailObj.HFREQUENCIES="null"	;药物使用频次
	.s detailObj.HDAY="null"		;用药天数
	.s detailObj.HISDEPTCODE="null"		;下达医嘱科室编码N
	.s detailObj.HISDEPTNAME="null"		;下达医嘱科室名称N
	.s detailObj.HDOSE="null"		;剂量
	.s detailObj.HDOSEUNIT="null"	;剂量单位
	.s detailObj.FTIMESTAMPJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳
	.d signContentObj.auxdetails.Insert(detailObj)	
	b ;signContentObj
	//将主报文转成json
	//调用固定方法进行对象转Json
	
	s extJsonObj=##class(ext.util.JsonObject).%New()
	s extJsonObj.ContainNullValue="1"
	
	s ^XUBAOBAO("INVOICE","OP",1)=$zd(+$h,3)_"-"_$zt($p($h,",",2),1)
	
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(signContentObj,.Stream,"",extJsonObj)
	;s signJson=Stream.Read()
	s signJson=Stream.Read(Stream.Size)
	s signJson=$replace(signJson,"null","")
	s signJson=##class(ext.util.String).EvalJSON2(signJson)
	s signJson="\|"_signJson_"\|"
	
	s ^XUBAOBAO("INVOICE","OP",2)=$zd(+$h,3)_"-"_$zt($p($h,",",2),1)
	
	//开票对象
	s invobj=##class(BILL.EINV.DTO.XYHA.OPInvoiceReq).%New()
	s invobj.orgCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5) 	;机构编码						
	s invobj.billType="1"		;开票类型(1：门诊；2：住院)
	s invobj.signContent=signJson
	
	//调用固定方法进行对象转Json
	s InvStream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.InvStream)
	;s jsonstr=InvStream.Read()
	s jsonstr=InvStream.Read(InvStream.Size)
	
	s jsonstr=$replace(jsonstr,"\\|","")
	s jsonstr=$replace(jsonstr,"\\","")
	s ^XUBAOBAO("INVOICE","OP",3)=$zd(+$h,3)_"-"_$zt($p($h,",",2),1)
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).InvoicePam结束")
	q jsonstr
}

/// 功能说明：整理住院电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保   2020-10-28  新做成
/// 其    他：w ##class(BILL.EINV.ADP.XYHA).InvoiceIP("","","") 
ClassMethod InvoiceIP(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).InvoicePam开始")
	s ^XUBAOBAOTMP("ObjToJson",1)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	s signContentObj=##class(BILL.EINV.DTO.XYHA.IPInvoiceContent).%New()
	
	//住院票面信息表
	s invMainObj=##class(BILL.EINV.DTO.XYHA.IPInvoiceMain).%New()
	s invMainObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	s invMainObj.EINVOICENAME=""	;电子票据名称N
	s invMainObj.EINVOICECODE=""	;电子票据代码（来源财政）N
	s invMainObj.EINVOICENUMBER=""	;电子票据号码（来源财政）N
	s invMainObj.INVOICETYPE="1"	;开票类型（１：新开；０：作废）
	s invMainObj.VISITDATEJ=$replace(ObjInvPrtInfo.PatAdmInfo.AdmDate,"-","")_"-"_ObjInvPrtInfo.PatAdmInfo.AdmTime	;就诊时间 20201104-03:11:05
	s invMainObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;住院号
	s invMainObj.INVOICENO=ObjInvUpDetail.IUDBusNo				;住院结算单据号
	s invMainObj.FINHOSPDEPT=ObjInvPrtInfo.PatAdmInfo.DepCode		;入院科室代码
	s invMainObj.FINHOSPDEPTNAME=ObjInvPrtInfo.PatAdmInfo.DepDesc	;入院科室名称
	s invMainObj.FINHOSPSTATUS=""		;入院状态
	s invMainObj.FINHOSPDIA=""			;入院诊断代码
	s invMainObj.FINHOSPDIANAME=""		;入院诊断名称
	s invMainObj.FOUTHOSPDATEJ=$replace(ObjInvPrtInfo.PatAdmInfo.OutDate,"-","")_"-"_ObjInvPrtInfo.PatAdmInfo.OutTime	;出院时间
	s invMainObj.FOUTHOSPDEPT=ObjInvPrtInfo.PatAdmInfo.OutDepCode		;出院科室代码
	s invMainObj.FOUTHOSPDEPTNAME=ObjInvPrtInfo.PatAdmInfo.OutDepDesc	;出院科室名称
	s invMainObj.FOUTHOSPSTATE=""		;出院状态
	s invMainObj.FOUTHOSPDIA=""			;出院诊断代码
	s invMainObj.FOUTHOSPDIANAME=""		;出院诊断名称
	s invMainObj.FFACTINHOSPDAYS=ObjInvPrtInfo.PatAdmInfo.IPDays		;实际住院天数
	s invMainObj.FDRCODE=ObjInvPrtInfo.PatAdmInfo.DocCode	;主治医师代码
	s invMainObj.FDR=ObjInvPrtInfo.PatAdmInfo.DocDesc		;主治医师
	s invMainObj.FOPECODE=""			;手术代码
	s invMainObj.FOPENAME=""			;手术名称
	s invMainObj.TOTALAMOUNT=$fn(+ObjInvPrtInfo.InvAmt,"",2)	;总金额
	s invMainObj.ISSUETIMEJ=$zd(ObjInvPrtInfo.BusDate,8)_"-"_$zt(ObjInvPrtInfo.BusTime,1)	;开票时间
	s invMainObj.INVOICINGCLERK=ObjInvPrtInfo.BusUserCode	;开票员代码
	s invMainObj.HANDLINGPERSON=ObjInvPrtInfo.BusUserDesc		;开票人
	s invMainObj.CHECKER=ObjInvPrtInfo.BusUserDesc				;复核人
	;s invMainObj.CARDTYPE=ObjInvPrtInfo.PatBaseInfo.CardType	;卡类型
	s invMainObj.CARDTYPE=##class(BILL.EINV.COM.Common).GetBusCardType(ObjInvPrtInfo.PatBaseInfo.CardType, InvociePam.ObjUPConfig)    ;卡类型 (需要对照)
	s invMainObj.CARDNO=ObjInvPrtInfo.PatBaseInfo.CardNo		;卡号
	s invMainObj.PAYERPARTYTYPE="1"			;交款人类型(1:个人2:单位)
	s invMainObj.PAYERPARTYCODE=ObjInvPrtInfo.PatBaseInfo.PatID		;交款人代码(单位一般为统一社会信用代码；个人一般为身份证号)N
	s invMainObj.PAYERPARTYNAME=ObjInvPrtInfo.PatBaseInfo.PatName	;患者名称
	s invMainObj.GENDER=ObjInvPrtInfo.PatBaseInfo.Sex		;性别
	s invMainObj.AGE=ObjInvPrtInfo.PatBaseInfo.Age			;年龄
	s invMainObj.ADDRESS=ObjInvPrtInfo.PatBaseInfo.Address	;地址N
	s invMainObj.TEL=ObjInvPrtInfo.PatBaseInfo.Mobphone		;联系电话N
	s invMainObj.PAYERACCT=""	;患者账号N
	s invMainObj.PAYEROPBK=""	;患者开户行N
	s invMainObj.PAYMODE=""		;交款方式(字典)N
	s invMainObj.CURRENCYTYPE=""	;货币种类(字典)N
	s invMainObj.EXCHANGERATE=""	;汇率N
	s invMainObj.SUPERVISORREMARK=""	;备注N
	s invMainObj.PATIENTTYPE="0"	;;病人类型(０:自费,1:医保)
	s:ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc'="" invMainObj.PATIENTTYPE="1"
	;s invMainObj.MEDICALINSURANCETYPE=##class(BILL.EINV.COM.Common).GetBusInsuType(ObjInvPrtInfo.InsuDivInfo.InsuTypeCode, InvociePam.ObjUPConfig)	;医保类型:(字典)
	s invMainObj.MEDICALINSURANCETYPE=$p($g(^PAC("ADMREA",ObjInvPrtInfo.InsTypeDr)),"^",1)	;医保类型:(字典) 2020.12.23  lid
	s invMainObj.MEDICALINSURANCEID=ObjInvPrtInfo.InsuDivInfo.InsuId	;医保编号
	s invMainObj.CBDQ=ObjInvPrtInfo.InsuDivInfo.CenterNo		;参保地区
	s invMainObj.CASENUMBER=ObjInvPrtInfo.PatBaseInfo.PAPMINO	;病例号
	;以下字段需要核实取值
	s invMainObj.PREPAYAMOUNT=$fn(+ObjInvPrtInfo.DepositAmt,"",2)	;预缴金额
	s invMainObj.RECHARGEAMOUNT=$fn(+ObjInvPrtInfo.RecAmt,"",2)		;补缴金额
	s invMainObj.REFUNDAMOUNT=$fn(+ObjInvPrtInfo.RefAmt,"",2)		;退费金额
	s invMainObj.DEDUCTIBLE=$fn(+ObjInvPrtInfo.InsuDivInfo.qfx,"",2)	;起付线
	s invMainObj.SELFPAYMENTCOST=$fn(+ObjInvPrtInfo.InsuDivInfo.SelfAmt,"",2)	;个人自费
	s invMainObj.YLSZF=""	;乙类首自付
	s invMainObj.ABLZF=""	;按比例自付
	s invMainObj.OWNPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0,"",2)	;个人现金支付
	s invMainObj.ACCOUNTPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0,"",2)	;个人账户支付
	s invMainObj.FUNDPAYAMOUNT=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0,"",2)	;医保统筹基金支付
	s invMainObj.GWYBZ=$fn(+ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3,"",2)		;公务员补助
	b ;999
	s invMainObj.SZBZ=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",11),"",2)		;师职补助
	s invMainObj.DEBXBX=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",12),"",2)		;大额保险报销
	s invMainObj.CDEBX=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",13),"",2)		;超大额报销
	s invMainObj.DBBXBX=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",14),"",2)		;大病保险报销
	s invMainObj.DBBCBXBX=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",15),"",2)	;大病补充保险报销
	s invMainObj.YLJZ=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",16),"",2)		;医疗救助
	s invMainObj.YYCDFY=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",17),"",2)		;医院承担费用
	s invMainObj.CQJCF=$fn(+$p(ObjInvPrtInfo.InsuDivInfo.zffsStr,"^",18),"",2)		;产前检查费
	s invMainObj.SELFMAINEXT=""	;个性化其他项目信息
	s invMainObj.CREATETIMEJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳N
	s signContentObj.main=invMainObj
	b ;11
	
	//住院结算单据表(费用分类信息)
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCate_ConFlag",5)  ;费用是否对照 1 对照 0 不对照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, "IP")
	.f num=1:1:$l(FeeConStr,",") d
	..s datadetailsObj=##class(BILL.EINV.DTO.XYHA.IPInvoiceDetails).%New()
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s datadetailsObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	..s datadetailsObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;院号
	..s datadetailsObj.INVOICENO=ObjInvUpDetail.IUDBusNo		;住院结算单据号
	..s datadetailsObj.ITEMCODE=$p(CatFeeInfo,"^",1)	;大类项目编码（医院内部）
	..s datadetailsObj.ITEMNAME=$p(CatFeeInfo,"^",2)	;大类项目名称（医院内部）
	..s datadetailsObj.ITEMUNIT="元"						;计量单位
	..s datadetailsObj.ITEMSTD=$p(CatFeeInfo,"^",3)	 	;收费标准
	..s datadetailsObj.ITEMQUANTITY="1"					;数量
	..s datadetailsObj.ITEMAMOUNT=$p(CatFeeInfo,"^",3)	;金额
	..s datadetailsObj.ITEMREMARK="null"					;项目备注
	..s datadetailsObj.CREATETIMEJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳N
	..d signContentObj.details.Insert(datadetailsObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s datadetailsObj=##class(BILL.EINV.DTO.XYHA.IPInvoiceDetails).%New()
	..s datadetailsObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	..s datadetailsObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;院号
	..s datadetailsObj.INVOICENO=ObjInvUpDetail.IUDBusNo		;住院结算单据号
	..s datadetailsObj.ITEMCODE=ObjInvPrtInfo.InvCateInfo.GetAt(i).ID	;大类项目编码（医院内部）
	..s datadetailsObj.ITEMNAME=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;大类项目名称（医院内部）
	..s datadetailsObj.ITEMUNIT="元"						;计量单位
	..s datadetailsObj.ITEMSTD=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt	 	;收费标准
	..s datadetailsObj.ITEMQUANTITY="1"					;数量
	..s datadetailsObj.ITEMAMOUNT=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt	;金额
	..s datadetailsObj.ITEMREMARK="null"					;项目备注
	..s datadetailsObj.CREATETIMEJ=$zd(+$h,8)_"-"_$zt($p($h,",",2),1)	;时间戳N
	..d signContentObj.details.Insert(datadetailsObj)
	
	s ^XUBAOBAOTMP("ObjToJson",2)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	b ;12
	//门诊费用明细表(清单项目明细信息)
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s detailObj=##class(BILL.EINV.DTO.XYHA.IPInvoiceAuxDetails).%New()  
	.s detailObj.ORGID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编号
	.s detailObj.PATIENTNUMBER=ObjInvPrtInfo.PatAdmInfo.AdmNo	;住院号
	.s detailObj.INVOICENO=ObjInvUpDetail.IUDBusNo		;住院结算单据号  
	.s detailObj.FPAYDATEJ=$zd(ObjInvPrtInfo.BusDate,8)_"-"_$zt(ObjInvPrtInfo.BusTime,1)			;收费时间 
	.s detailObj.FITEMTYPE="1"			;项目类型 0、药品1、诊疗  
	.i ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc["药" d
	..s detailObj.FITEMTYPE="0"			;项目类型 0、药品1、诊疗   
	.s detailObj.EXECOFFICECODE=ObjInvPrtInfo.PatAdmInfo.DepCode	;执行科室代码
	.s detailObj.EXECOFFICENAME=ObjInvPrtInfo.PatAdmInfo.DepDesc	;执行科室名称
	.s detailObj.FDRCODE=ObjInvPrtInfo.PatAdmInfo.DocCode	;开单医生代码
	.s detailObj.FDR=ObjInvPrtInfo.PatAdmInfo.DocDesc		;开单医生名称
	.s detailObj.FITEMHOSCODE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;明细项目医院编码
	.s detailObj.FITEMNAME=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc		;明细项目名称
	.s detailObj.FITEMSIZE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Spec		;明细项目规格
	.s detailObj.FITEMUNIT=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit		;明细项目单位
	.s detailObj.FPRICE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price			;明细项目单价
	.s detailObj.FQUA=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty				;明细数量
	.s detailObj.FAMOUNT="null"				;付数
	.s detailObj.FMONEY=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt			;金额
	.s detailObj.FDRNAME=ObjInvPrtInfo.PatAdmInfo.DocDesc					;开单医生名称     
	.s detailObj.ITEMCODE=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateID		;医院项目分类编码（医院内部）
	.s detailObj.FITEMHOSCLASSNAME=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;医院项目分类名称
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  		;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConXYH",FeeCateKey,0)  ;对照信息
	..s detailObj.ITEMCODE=$p(FeeItmCateConInfo, "^", 5)  			;费用分类编码
	..s detailObj.FITEMHOSCLASSNAME=$p(FeeItmCateConInfo, "^", 6)  			;费用分类名称                       
	.s detailObj.FOVERPRICESELFEE="null"	;超限价金额
	.s detailObj.FSCALESELFEE="null"		;按比例自付金额
	.s detailObj.FCOMPROPORTION="null"		;补偿比例
	.s detailObj.HAMOUNT="null"				;付数
	.s detailObj.HFORMSNAME=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Form		;剂型名称
	.s detailObj.HFORMSCODE="null" ;ObjInvPrtInfo.InvItmDetInfo.GetAt(i).FormCode	;药物剂型代码
	.s detailObj.HDORCODE=ObjInvPrtInfo.PatAdmInfo.DocCode		;医院his处方医生编码
	.s detailObj.HDORNAME=ObjInvPrtInfo.PatAdmInfo.DocDesc		;处方医生姓名
	.s detailObj.HGROUPCODE="null"		;医嘱分组编号N
	.s detailObj.GROUPSER="null"		;医嘱组内序号N
	.s detailObj.HUSAGE="null"			;用药途径代码
	.s detailObj.HDOSAGE="null"			;用量
	.s detailObj.HDOSAGEUNIT="null"		;用量单位
	.s detailObj.HFREQUENCIES="null"	;药物使用频次
	.s detailObj.HDAY="null"			;用药天数
	.s detailObj.HDATEJ=$zd(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).BillDate,8)_"-"_$zt(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).BillTime)			;实际用药时间
	.s detailObj.HDOCTORTYPE="null"		;医嘱类别
	.s detailObj.HISDEPTCODE="null"		;下达医嘱科室编码N
	.s detailObj.HISDEPTNAME="null"		;下达医嘱科室名称N
	.s detailObj.HDOSE="null"		;剂量
	.s detailObj.HDOSEUNIT="null"	;剂量单位		；$zd(+$h,8)_"-"_$zt($p($h,",",2),1)
	.s detailObj.FTIMESTAMPJ=$zd(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).BillDate,8)_"-"_$zt(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).BillTime)	;时间戳
	.d signContentObj.auxdetails.Insert(detailObj)
	s ^XUBAOBAOTMP("ObjToJson",3)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	
	//将主报文转成json
	//调用固定方法进行对象转Json
	s extJsonObj=##class(ext.util.JsonObject).%New()
	s extJsonObj.ContainNullValue="1"
	s Stream=##class(%GlobalCharacterStream).%New()
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,1)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	d ##class(ext.util.JsonObject).ObjectToJSONStream(signContentObj,.Stream,"",extJsonObj)
	;s signJson=Stream.Read()
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,2)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	
	s signJson=Stream.Read(Stream.Size)
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,3)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	s signJson=$replace(signJson,"null","")
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,4)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	s signJson=##class(ext.util.String).EvalJSON2(signJson)
	s signJson="\|"_signJson_"\|"
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,5)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	
	//开票对象
	s invobj=##class(BILL.EINV.DTO.XYHA.IPInvoiceReq).%New()
	s invobj.orgCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5) 	;区划编码						
	s invobj.billType="2"		;开票类型(1：门诊；2：住院)
	s invobj.signContent=signJson
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,6)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	
	//调用固定方法进行对象转Json
	s InvStream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(invobj,.InvStream)
	;s rtn=Stream.Read()
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,7)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	s jsonstr=InvStream.Read(InvStream.Size)
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,8)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	
	s jsonstr=$replace(jsonstr,"\\|","")
	s jsonstr=$replace(jsonstr,"\\","")
	s ^XUBAOBAOTMP("ObjToJson",ObjInvPrtInfo.InvItmDetInfo.Size,9)=$zd(+$h,3)_" "_$zt($p($h,",",2))
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).InvoicePam结束")
	q jsonstr
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
	s ServiceCode="ticketRed"			;接口服务名称
	s Message=InputJson						;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest(ServiceCode,Message, InvociePam, .OutputObj)
	q:RtnCode="-9999" RtnFlag		;调用服务异常
	b ;Invalid 2
	if (RtnCode="0"){
		s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail, .OutputObj)  ;把红冲开票结果信息保存到交易表
	}else{
		s RtnFlag="0"
	}
	b ;Invalid 3
	
	//红冲接口可以重复调用，已经红冲过的票据，再次调用返回原先红冲数据，此处就不在调用查询接口
	//3.开票成功的情况下, 调用服务接口获取开票状态
	/*if (RtnFlag="0"){
		s InvStatusRtn=..GetInvStatusOfInvalid(ObjInvUpDetail,ObjInvPrtInfo, InvociePam)  ;查询开票情况	
		i (InvStatusRtn'="0"){
			s RtnFlag="-1"
			s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
		}

	}*/
	
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
	s InvRefundRt=##class(BILL.EINV.DTO.XYHA.InvalidReq).%New()
	s InvRefundRt.orgCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","OrgID", 5)	;机构编码
	s InvRefundRt.einvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;票据代码
	s InvRefundRt.einvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo	;票据号码
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
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).SetInvResultOfInvalid开始.")
	
	s ResultMegObj=OutputObj.data
	b ;SetInvResultOfInvalid 1
	
	//对返回结果的时间戳进行分割		
	s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.einvoiceCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.einvoiceNumber		;电子票据号码
	s ObjInvUpDetail.EinvprtNo=ResultMegObj.einvoiceCode_ResultMegObj.einvoiceNumber  ;发票编码+发票号码
	s ObjInvUpDetail.IUDPictureUrl=ResultMegObj.billUrl		;电子票据 pdf 地址
	i ResultMegObj.time="" d
	.s ObjInvUpDetail.IUDCreatDate=+$h			;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)	;电子票据生成时间
	e  d
	.s createDateTime=##class(BILL.EINV.COM.Common).GetTimeStampToDateTime(ResultMegObj.time)
	.s createDate=$p(createDateTime," ",1)
	.s createTime=$p(createDateTime," ",2)
	.s ObjInvUpDetail.IUDCreatDate=$zdh(createDate,8)		;电子票据生成日期
	.s ObjInvUpDetail.IUDCreatTime=$zth(createTime,1)		;电子票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="冲红成功"
	s ObjInvUpDetail.EInvFlg="S"									;发票状态
	
	b ;SetInvResultOfInvalid 2	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.XYHA).SetInvResultOfInvalid结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：调用服务接口获取冲红服务结果(获取已开电子票据的实际状态信息)
/// 入参说明: ObjInvUpDetail    --> 交易对象
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：徐保保   2020-10-28  新做成 
/// 其    他：w ##class(BILL.EINV.ADP.PGA).GetInvStatusOfInvalid("","","") 
ClassMethod GetInvStatusOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//1.组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail,ObjInvPrtInfo)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag
	b ;GetInvStatusOfInvalid 1

	s ServiceCode="ticketSearch"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest(ServiceCode,Message, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	q:OutputObj.data.Size=0 "-1"
	s ResultMegObj=OutputObj.data
	b ;GetInvStatusOfInvalid 3
	;q:ResultMegObj.GetAt(1).State'="1" "-1"	;开票状态 0 失败，1 正常

	i (ResultMegObj.GetAt(1).States.Reversal.IsReversal="true")&&(ResultMegObj.GetAt(1).States.Reversal.RelatedInvoiceCode'="")&&(ResultMegObj.GetAt(1).States.Reversal.RelatedInvoiceNumber'=""){
		;b ;99
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.GetAt(1).States.Reversal.RelatedInvoiceCode		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.GetAt(1).States.Reversal.RelatedInvoiceNumber		;电子票据号码
		;s ObjInvUpDetail.IUDCheckCode=ResultMegObj.States.Reversal.RelatedRandomNumber			;电子校验码
		;s:ResultMegObj.States.Reversal.RedInvoiceDate'="" ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.States.Reversal.RedInvoiceDate,3)	;电子票据生成日期
		;s:ResultMegObj.States.Reversal.RedInvoiceTime'="" ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.States.Reversal.RedInvoiceTime,1)	;电子票据生成时间
		s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo  ;发票编码+发票号码
		s ObjInvUpDetail.IUDResultCode=OutputObj.code	
		s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.GetAt(1).States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.GetAt(1).State			;电子票据状态(0 失败，1 正常)
		s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.GetAt(1).States.Reversal.IsReversal	;是否已开红票
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
	s ServiceCode="ticketChange"			;接口服务名称
	s Message=InputJson						;业务入参
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest(ServiceCode,Message, InvociePam, .OutputObj)
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
	
	s TurnPaperRt=##class(BILL.EINV.DTO.XYHA.EInvTurnPaperReq).%New()
	s InvRefundRt.orgCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","orgCode", 5)	;机构编码
	s TurnPaperRt.einvoiceCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;票据代码
	s TurnPaperRt.einvoiceNumber=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo	;票据号码
	s TurnPaperRt.invoiceCode=InvociePam.pBillBatchCode				;换开纸质票据代码								
	s TurnPaperRt.invoiceNumber=InvociePam.pBillNo					;换开纸质票据号码
	s TurnPaperRt.reason="患者要求"									;换开原因
	
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
	
		//1.组织电子票据开票状况请求入参
	s InputJson=..QueryInvStatus(ObjInvUpDetail)
	s:InputJson="" InvociePam.ErrMsgInfo="组织电子票据开票状况请求入参失败"
	q:InputJson="" RtnFlag

	//2.调用固定方法进行对象转Json
	s Stream=##class(%GlobalCharacterStream).%New()
	d ##class(ext.util.JsonObject).ObjectToJSONStream(InvStatusRt,.Stream)
	s InputJson=Stream.Read()
	
	s ServiceCode="ticketSearch"						;接口服务名称
 	s HISUniqueID=##class(BILL.EINV.COM.Common).CreateBusinessNo(ObjInvUpDetail.IUDPayAdmType,30,"") 			;唯一流水号
	s Message=InputJson									;业务入参
	
	//3.调用兴财http票据查询服务请求
	s OutputObj=""
	s RtnCode=##class(BILL.EINV.BI.XYHA.HTTPRequest).InvoiceRequest(ServiceCode,Message, InvociePam, .OutputObj)
	q:RtnCode'="0" RtnCode
	
	//4.保存结果信息
	s ResultMegObj=OutputObj.data
	b ;GetInvStatusOfInvalid 3
	q:ResultMegObj.State'="1" "-1"	;开票状态 0 失败，1 正常

	i (ResultMegObj.States.ExchangePaper.IsExchangePaper="true")&&(ResultMegObj.States.ExchangePaper.RelatedInvoiceCode'="")&&(ResultMegObj.States.ExchangePaper.RelatedInvoiceNumber'=""){
		;b ;99
		s ObjInvUpDetail.IUDBillBatchCode=ResultMegObj.States.ExchangePaper.RelatedInvoiceCode		;电子票据代码
		s ObjInvUpDetail.IUDBillBatchNo=ResultMegObj.States.ExchangePaper.RelatedInvoiceNumber		;电子票据号码
		;s ObjInvUpDetail.IUDCheckCode=ResultMegObj.States.Reversal.RelatedRandomNumber			;电子校验码
		;s:ResultMegObj.States.Reversal.RedInvoiceDate'="" ObjInvUpDetail.IUDCreatDate=$zdh(ResultMegObj.States.Reversal.RedInvoiceDate,3)	;电子票据生成日期
		;s:ResultMegObj.States.Reversal.RedInvoiceTime'="" ObjInvUpDetail.IUDCreatTime=$zth(ResultMegObj.States.Reversal.RedInvoiceTime,1)	;电子票据生成时间
		s ObjInvUpDetail.EinvprtNo=ObjInvUpDetail.IUDBillBatchCode_ObjInvUpDetail.IUDBillBatchNo  ;发票编码+发票号码
		
		s ObjInvUpDetail.IUDResultCode=OutputObj.code	
		s ObjInvUpDetail.IUDPrintFlag=ResultMegObj.States.ExchangePaper.IsExchangePaper	;是否打印纸质票据
		s ObjInvUpDetail.IUDBillBatchStatus=ResultMegObj.State			;电子票据状态(0 失败，1 正常)
		s ObjInvUpDetail.IUDBillisScarlet=ResultMegObj.States.Reversal.IsReversal	;是否已开红票
		s ObjInvUpDetail.IUDUplodeFlag="Y"                              ;上传标志 Y:上传成功，N:上传失败
		s ObjInvUpDetail.IUDResultMeg="已换开成功"
		s ObjInvUpDetail.EInvFlg="I"									;发票状态
		s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=$p($h,",",1)							;电子票据生成日期
		s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=$p($h,",",2)
		s ObjInvUpDetail.IUDUser=InvociePam.UserID              ;开票人
		s RtnFlag="0"
	}
	
	q RtnFlag
}

}
