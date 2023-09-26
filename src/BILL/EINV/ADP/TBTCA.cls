/// 同步天成公司的电子票据接口
Class BILL.EINV.ADP.TBTCA Extends %RegisteredObject
{

/// 功能说明：根据不同的业务类型分别调用不同开具接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 	业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保   2020-09-21  新做成
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).Invoice("","","") 
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).Invoice开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	;s:AccessToken="" InvociePam.ErrMsgInfo="获取授权凭证失败"
	q:AccessToken="" RtnFlag
		
	//2.开具之前调用查询接口查看是否开具成功，开具成功时直接保存开具数据
	s EInvQryFlag=..EInvInfoQueryOfInvoice(AccessToken, ObjInvUpDetail, InvociePam)
	q:EInvQryFlag="0" "0"
	b ;EInvQryFlag
	
	//3.组织开具入参
	i (ObjInvUpDetail.IUDPayAdmType="IP"){   			
		//组织住院开具接口入参
		s InputReqXml=..InvoiceIP(AccessToken, ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}else{  		
		//组织门诊开具接口入参
		s InputReqXml=..InvoiceOP(AccessToken, ObjInvUpDetail, ObjInvPrtInfo, InvociePam)
	}
	
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;InputReqXml
	
	//4.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;ResultRtn
	
    //5.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionInvoiceResult(InvoiceResXML,.InvoiceResObj, .VoucherResultObj)
    i (RtnFlag="0"){
	    //6.保存开具信息数据
	    s RtnFlag=..SetInvResultOfInvoice(ObjInvUpDetail, .InvoiceResObj, .VoucherResultObj)
	    s ObjInvUpDetail.Xstr1=AccessToken
	    s:RtnFlag'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
    }else{
	     s RtnFlag="-1"
	     s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
    //7.开具成功调用查询接口更新开票信息
    i (RtnFlag="0"){
		s EInvQryFlag=..EInvInfoQueryOfInvoice(AccessToken, ObjInvUpDetail, InvociePam)
		i (EInvQryFlag'="0"){
			 s RtnFlag="-1"
	    	 ;s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
		}
    }
    
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).Invoice结束")
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherResult) As %String
{
	s RtnFlg="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoice -1
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.EbillBatchCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.EbillNo			;电子票据号码
	s ObjInvUpDetail.IUDCheckCode=VoucherResultObj.RandomNumber			;电子校验码
	s ObjInvUpDetail.IUDCreatDate=+$h									;电子票据生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子票据生成时间
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.IUDResultMeg="上传成功"   							;查询状态 信息是否成功
	s ObjInvUpDetail.EInvFlg="I"										;发票状态
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
a	s ObjInvUpDetail.EinvprtNo=VoucherResultObj.EbillBatchCode_VoucherResultObj.EbillNo  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=InvoiceResObj.Head.MsgNo
	s ObjInvUpDetail.Xstr2=VoucherResultObj.SettlementNo	;结算号
	b ;SetInvResultOfInvoice -2
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInitResult("","") 
ClassMethod DecryptionInvoiceResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherResult) As %String
{
	s rtn="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionInvoiceResult开始.")
	
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	;b ;0
	//1.将报文头xml转换为对象
	;s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceRes).%New()
	s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.ComRes).%New()
	s InvoiceRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ComRes", .InvoiceResObj)
	q:InvoiceRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InvoiceResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3  VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionInvoiceResult结束.")
    q rtn
}

/// 调用授权接口返回授权凭证
/// 入参：UserCode   	操作人
/// 	  InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：授权凭证
ClassMethod InitLogin(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s AccessToken=""
	
	//组织初始化入参请求XML
	s InitReqXML=..InitXML(InvociePam)
	s:InitReqXML="" InvociePam.ErrMsgInfo="组织授权接口入参失败"
	q:InitReqXML="" AccessToken
	
	//调用同步天成HTTP获取授权接口
    s InitResXML=""
    s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InitReqXML,InvociePam.ObjUPConfig, .InitResXML)
    ;b ;ResultRtn
    s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" AccessToken
    
    //解析获取授权返回结果 
    s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.InitMsgVoucherResult).%New()
    s RtnFlag=..DecryptionInitResult(InitResXML, .VoucherResultObj)
	s:RtnFlag'="0" InvociePam.ErrMsgInfo="解析授权返回值失败:"_VoucherResultObj.ResultMsg
	q:RtnFlag'="0" AccessToken
	
	s AccessToken=VoucherResultObj.AccessToken		;授权凭证
	
	q AccessToken
}

/// 组织授权入参请求XML
ClassMethod InitXML(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s InitReqObj=##class(BILL.EINV.DTO.TBTCA.InitReq).%New()
	
	s Organ=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","Organ", 5) 
	s CompanyID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","CompanyID", 5) 
	
	//报文头
	s InitHeadObj=##class(BILL.EINV.DTO.TBTCA.InitHeaderInfo).%New()
	s InitHeadObj.MsgNo="8901"	
	s InitHeadObj.Organ=Organ
	s InitHeadObj.User=InvociePam.UserCode						;用户名
	s InitHeadObj.Version=InvociePam.ObjUPConfig.IUCVersion		;版本号
	s InitHeadObj.AppId=InvociePam.ObjUPConfig.IUCAPPID
	s InitHeadObj.MsgId=CompanyID_##class(BILL.EINV.COM.Common).CreateBusinessNo("INIT",30,"")	;业务请求编号
	s InitHeadObj.MsgRef=InitHeadObj.MsgId
	s InitHeadObj.DateTime=##class(BILL.EINV.COM.Common).GetBusDate(+$h,$p($h,",",2))	;请求时间
	s InitHeadObj.Reserve=""
	s InitReqObj.Head=InitHeadObj		

	//报文体
	s InitBodyObj=##class(BILL.EINV.DTO.TBTCA.InitMsgBody).%New()
	s InitVoucherObj=##class(BILL.EINV.DTO.TBTCA.InitMsgVoucher).%New()
	s InitVoucherObj.AppId=InvociePam.ObjUPConfig.IUCAPPID
	s InitVoucherObj.AppKey=InvociePam.ObjUPConfig.IUCSecretKey
    s VoucherInput=""
	d InitVoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s InitReqObj.Msg=Msg
	
	s ReqInputXml=""
	d InitReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInitResult("","") 
ClassMethod DecryptionInitResult(XMLRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.InitMsgVoucherResult) As %String
{
	s rtn="-1"
	
	//s XMLRes="<?xml version='1.0' encoding='UTF-8'?><Invoice><Head><MsgNo>5901</MsgNo><Version>1.0</Version><AppId>KPQZDWB5629411</AppId><MsgId>20190703105001999</MsgId><MsgRef>20190703105000000</MsgRef><DateTime>20190703105001999</DateTime><Reserve></Reserve></Head><Msg>PFZvdWNoZXI+PEFjY2Vzc1Rva2VuPmFhYWFiYmJiYjExMTExMzMzMzMzPC9BY2Nlc3NUb2tlbj48RXhwaXJlc0luPjcyMDA8L0V4cGlyZXNJbj48L1ZvdWNoZXI+</Msg></Invoice>"
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	//1.将报文头xml转换为对象
	s InitResObj=##class(BILL.EINV.DTO.TBTCA.InitRes).%New()
	s InitRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.InitRes", .InitResObj)
	q:InitRtn'="0" rtn
	;b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InitResObj.Msg,"UTF8")
	;b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.InitMsgVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.InitMsgVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	;b ;3   VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
    q rtn
}

///  组织入参报文头
ClassMethod InvoiceHead(MsgNo, PayAdmType, AccessToken, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ByRef ComHeadObj As BILL.EINV.DTO.TBTCA.ComHeaderInfo) As %String
{
	s Organ=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","Organ", 5) 
	s CompanyID=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","CompanyID", 5) 
	
	//报文头
	s ComHeadObj=##class(BILL.EINV.DTO.TBTCA.ComHeaderInfo).%New()
	s ComHeadObj.MsgNo=MsgNo	
	s ComHeadObj.Organ=Organ
	s ComHeadObj.User=InvociePam.UserCode		;用户名
	s ComHeadObj.Version=InvociePam.ObjUPConfig.IUCVersion		;版本号
	s ComHeadObj.AppId=InvociePam.ObjUPConfig.IUCAPPID
	s ComHeadObj.MsgId=CompanyID_##class(BILL.EINV.COM.Common).CreateBusinessNo(PayAdmType,30,"")	;业务请求编号
	s ComHeadObj.MsgRef=ComHeadObj.MsgId
	s ComHeadObj.DateTime=##class(BILL.EINV.COM.Common).GetBusDate(+$h,$p($h,",",2))	;请求时间
	s ComHeadObj.Reserve=""
	s ComHeadObj.AccessToken=AccessToken
	
	q "0"
}

/// 功能说明：整理门诊电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保 2020-09-21 
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvoiceOP("","","") 
ClassMethod InvoiceOP(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvoiceOP开始")
	
	;s OPInvoiceReqObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceReq).%New()
	s OPInvoiceReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s ComHeadObj=""
	d ..InvoiceHead("8101",ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s OPInvoiceReqObj.Head=ComHeadObj
	
	b ;InvoiceOP 2
	//组织报文体
	;s OPInvBodyObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgBody).%New()
	s OPInvVoucherObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucher).%New()
	
	s OPInvVoucherMainObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherMain).%New()
	s DateTime=$replace($p($zts,",",2),".","")
	s OPInvVoucherMainObj.RandomNumber=$e(DateTime,$l(DateTime)-3,$l(DateTime))_"01"		;校验码M  校验码要求四位随机数和两位区划编码,测试环境财政端要求,测试环境区划编码填01  2020.11.3
	s OPInvVoucherMainObj.TotalAmount=ObjInvUpDetail.IUDCreatAmt	;总金额M
	s OPInvVoucherMainObj.IssueDate=$replace($zd(ObjInvUpDetail.IUDPrtDate,3),"-","")	;结算日期M(yyyyMMdd)
	s OPInvVoucherMainObj.IssueTime=$zt(ObjInvUpDetail.IUDPrtTime)		;计算时间M(hh:mm:ss)
	s OPInvVoucherMainObj.InvoicingParty=##class(BILL.EINV.DTO.TBTCA.InvoicingParty).%New()	;开票单位
	s HispitalCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","HispitalCode", 5) 
	s HispitalName=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","HispitalName", 5)
	s OPInvVoucherMainObj.InvoicingParty.InvoicingPartyCode=HispitalCode		;开票单位代码M
	s OPInvVoucherMainObj.InvoicingParty.InvoicingPartyName=HispitalName		;开票单位名称M
	s OPInvVoucherMainObj.PayerPartyType="1"	;交款人类型M(1:个人 2:单位)		
	s:ObjInvUpDetail.IUDPayAdmType="PE" OPInvVoucherMainObj.PayerPartyType=$case(ObjInvPrt.PEBaseInfo.InvType,"G":"2",:"1")
	s OPInvVoucherMainObj.PayMode=""			;交款方式O
	s OPInvVoucherMainObj.BizCode=ObjInvUpDetail.IUDBusNo			;业务流水号O
	s OPInvVoucherMainObj.HandlingPerson=ObjInvPrtInfo.BusUserDesc		;开票人M
	s OPInvVoucherMainObj.Checker=ObjInvPrtInfo.BusUserDesc			;复核人O
	s OPInvVoucherMainObj.Remark=""									;备注O
	s OPInvVoucherMainObj.MainExt=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMainExt).%New()	;基本信息扩展
	s OPInvVoucherMainObj.MainExt.MedicalType=""		;医疗类别O
	s OPInvVoucherMainObj.MainExt.PatientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo		;门诊号O
	s OPInvVoucherMainObj.MainExt.OrgType=""		;医疗机构类型O
	s OPInvVoucherMainObj.MainExt.MedicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型O
	s OPInvVoucherMainObj.MainExt.MedicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId	;医保编号O
	s OPInvVoucherMainObj.MainExt.FundPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0	;医保统筹基金支付M
	s OPInvVoucherMainObj.MainExt.OtherPayAmount="0.00"		;其他支付M
	s OPInvVoucherMainObj.MainExt.AccountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0	;个人账户支付M
	s OPInvVoucherMainObj.MainExt.OwnPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0		;个人现金支付M
	s OPInvVoucherMainObj.MainExt.SelfpaymentAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0	;个人自付M
	s OPInvVoucherMainObj.MainExt.CaseNumber=ObjInvPrtInfo.PatBaseInfo.PAPMINO	;病历号O
	s OPInvVoucherMainObj.MainExt.PrepaidAmount="0.00"	;预交金额M      ???
	s OPInvVoucherMainObj.MainExt.RechargeAmount="0.00"	;补缴金额M		???
	s OPInvVoucherMainObj.MainExt.RefundAmount="0.00"	;退费金额M		???
	s OPInvVoucherMainObj.MainExt.Gender=ObjInvPrtInfo.PatBaseInfo.Sex		;性别O
	s OPInvVoucherMainObj.MainExt.Age=ObjInvPrtInfo.PatBaseInfo.Age			;年龄M
	s OPInvVoucherMainObj.MainExt.PayCode=""		;缴款码O
	s OPInvVoucherMainObj.MainExt.InsuranceSettleNo=ObjInvPrtInfo.InsuDivInfo.INPAYdjlsh0	;医保结算号M	???
	s OPInvVoucherMainObj.MainExt.VisitDeptName=ObjInvPrtInfo.PatAdmInfo.DepDesc	;就诊科室O
	s OPInvVoucherMainObj.MainExt.VisitDeptCode=ObjInvPrtInfo.PatAdmInfo.DepCode	;就诊科室编码M
	s OPInvVoucherMainObj.MainExt.InsuranceStatus=""	;医保待遇状态O
	s OPInvVoucherMainObj.MainExt.MedicalAccountPayment="0.00"	;医疗账户支付M
	s OPInvVoucherMainObj.MainExt.HealthAccountPay="0.00"		;健康账户支付M
	s OPInvVoucherMainObj.MainExt.MasonicAccountPay="0.00"		;共济账户支付M
	s OPInvVoucherMainObj.MainExt.MedicalAccountBalance="0.00"	;医疗账户余额M
	s OPInvVoucherMainObj.MainExt.HealthAccountBalance="0.00"	;健康账户余额M
	s OPInvVoucherMainObj.MainExt.SpecialDiseasesName=""	;门诊慢( 特 殊 )病种名称O
	s OPInvVoucherMainObj.MainExt.MedicalAssistance=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4		;医疗救助M		???
	s OPInvVoucherMainObj.MainExt.IllnessInsure=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2			;大病保险M		???
	s OPInvVoucherMainObj.MainExt.HealthCareFund=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5		;保健基金M		???
	s OPInvVoucherMainObj.MainExt.CivilServantSubsidy=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3	;公务员补助M	???
	s OPInvVoucherMainObj.MainExt.HospitalRelief=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay9		;减：医院减免M		???
	s OPInvVoucherMainObj.MainExt.RefundableAmount="0.00"		;应退款M		???
	s OPInvVoucherMainObj.MainExt.OverCapPay="0.00"				;超封顶线费用M		???
	s OPInvVoucherMainObj.MainExt.PrepaidBalance="0.00"			;预交金余额M		???
	s OPInvVoucherMainObj.MainExt.TimesOfMonth="0"			;本月就诊次数M			???
	s OPInvVoucherMainObj.MainExt.MedicalDate=$replace(ObjInvPrtInfo.PatAdmInfo.AdmDate,"-","")			;就诊日期O
	s OPInvVoucherMainObj.MainExt.FamilyMasonicAccountBalance="0.00"	;家庭共济账户余额M
	s OPInvVoucherMainObj.MainExt.PreSelfPay=ObjInvPrtInfo.InsuDivInfo.selfConceitedAmt				;先行自付M		???
	s OPInvVoucherMainObj.MainExt.SelfpaymentCost=ObjInvPrtInfo.InsuDivInfo.selfPayAmt				;个人自费M		???
	s OPInvVoucherMainObj.MainExt.UploadSource=$Case(ObjInvUpDetail.IUDPayAdmType,"API":"2",:"1")			;数据来源M(1：窗口结算上传2：诊间结算上传 3:自助机)
	s OPInvVoucherMainObj.MainExt.PayerPhoneNo=ObjInvPrtInfo.PatBaseInfo.Mobphone	;交款人手机号M
	;s VisitType=$Case(ObjInvPrtInfo.PatAdmInfo.
	s OPInvVoucherMainObj.MainExt.VisitType="2"				;就诊类型M(就诊类型（1、医保 2、自费 3、急诊 4、体检 9、其他）	???
	i ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'="" d  s OPInvVoucherMainObj.MainExt.VisitType="1"
	s OPInvVoucherMainObj.MainExt.SettlementNo=ObjInvUpDetail.IUDBusNo			;结算号M--用流水号
	s OPInvVoucherMainObj.MainExt.SocialCreditCode=""		;医疗机构编码（社会信用代码）O
	s OPInvVoucherMainObj.MainExt.IDCardNo=ObjInvPrtInfo.PatBaseInfo.PatID		;病人身份证号码O
	s OPInvVoucherMainObj.MainExt.SickName=ObjInvPrtInfo.PatBaseInfo.PatName	;病人姓名M
	s OPInvVoucherMainObj.MainExt.SocialSecurityNumber=ObjInvPrtInfo.InsuDivInfo.InsuId	;社会保障号码O
	s OPInvVoucherMainObj.MainExt.PlaceCode="001"				;开票点编码M	???
	s OPInvVoucherMainObj.MainExt.SocialSecurityCardNo=ObjInvPrtInfo.InsuDivInfo.CardNo	;社保卡号O
	s OPInvVoucherMainObj.MainExt.WorkInjuredPay="0.00"			;工伤支付M
	s OPInvVoucherMainObj.MainExt.SPStand=ObjInvPrtInfo.InsuDivInfo.INPAYZstr09				;起付标准		???
	s OPInvVoucherMainObj.MainExt.BSelfpayment="0.00"			;乙类首自付		???
	s OPInvVoucherMainObj.MainExt.PTNSelfpayment="0.00"			;按比例自付		???
	s OPInvVoucherMainObj.MainExt.TeacherSubsidy="0.00"			;师职补助		???
	s OPInvVoucherMainObj.MainExt.AntenatalClinic="0.00"			;产前检查费		???
	s OPInvVoucherMainObj.MainExt.LSubsidiaryInsuranceReimbursement="0.00"			;大病补充报销M
	
	s OPInvVoucherMainObj.MainExt.DiseaseDetails=##class(BILL.EINV.DTO.TBTCA.DiseaseDetails).%New()	;疾病信息
	f num=1:1:ObjInvPrtInfo.PatAdmInfo.ICD.Size d
	.s DiseaseItemObj=##class(BILL.EINV.DTO.TBTCA.DiseaseItem).%New()
	.s DiseaseItemObj.DiseaseCode=ObjInvPrtInfo.PatAdmInfo.ICD.GetAt(num).ICDCode
	.s DiseaseItemObj.DiseaseName=ObjInvPrtInfo.PatAdmInfo.ICD.GetAt(num).ICDDesc
	.s DiseaseItemObj.DiseaseFlag="0"
	.s:num=1 DiseaseItemObj.DiseaseFlag="1"
	.d OPInvVoucherMainObj.MainExt.DiseaseDetails.DiseaseItem.Insert(DiseaseItemObj)
		
	s OPInvVoucherMainObj.MainExt.PayerPartyExt=##class(BILL.EINV.DTO.TBTCA.PayerPartyExt).%New()	;交款人扩展信息
	s OPInvVoucherMainObj.MainExt.PayerPartyExt.SickId=ObjInvPrtInfo.PatBaseInfo.PAPMINO					;病人信息 Id
	s CardInfos=##class(BILL.EINV.DTO.TBTCA.CardInfos).%New()
	s CardInfoObj=##class(BILL.EINV.DTO.TBTCA.CardInfo).%New()
	s CardInfoObj.CardType=##class(BILL.EINV.COM.Common).GetBusCardType(ObjInvPrtInfo.PatBaseInfo.CardType, InvociePam.ObjUPConfig)   ;卡类别M(0：医院就诊卡 1：市民卡 2：健康卡 3：社保卡 4：身份证)
	s CardInfoObj.CardNum=ObjInvPrtInfo.PatBaseInfo.CardNo		;卡号M
	s CardInfoObj.Remark=""	;备注
	;d CardInfos.CardInfo.Insert(CardInfoObj)
	s CardInfos.CardInfo=CardInfoObj
	s OPInvVoucherMainObj.MainExt.PayerPartyExt.CardInfos=CardInfos
	s OPInvVoucherObj.Main=OPInvVoucherMainObj
	//发票费用分类
	s OPInvVoucherDetailObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetails).%New()
	;+dongkf 2020-02-24 start
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateTBTC_ConFlag",5)  ;费用是否对照 1 对照 0 不独照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	;+dongkf 2020-02-24 end
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, "OP")
	.f num=1:1:$l(FeeConStr,",") d
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s ItemObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetailsItem).%New() 
	..s ItemObj.ItemCode=$p(CatFeeInfo,"^",1) 	;收费项目代码
	..s ItemObj.ItemName=$p(CatFeeInfo,"^",2) 	;收费项目名称
	..;s ItemObj.InsuranceItemCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeTypeCon"_ObjInvPrtInfo.InsuDivInfo.InsuTypeCode,ItemObj.ItemCode,5)	;项目医保编码
	..s ItemObj.InsuranceItemCode=$p(CatFeeInfo,"^",1)	;项目医保编码
	..;b ;99
	..s ItemObj.ItemQuantity="1"			;数量
	..s ItemObj.ItemUnit=""				;计量单位
	..s ItemObj.ItemStd=$p(CatFeeInfo,"^",3) 			;收费标准
	..s ItemObj.ItemAmount=$p(CatFeeInfo,"^",3) 		;金额
	..s ItemObj.ItemRemark=""			;项目备注
	..d OPInvVoucherDetailObj.Item.Insert(ItemObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s ItemObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetailsItem).%New() 
	..s ItemObj.ItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;收费项目代码
	..s ItemObj.ItemName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;收费项目名称
	..s ItemObj.InsuranceItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;项目医保编码
	..s ItemObj.ItemName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;收费项目名称
	..s ItemObj.ItemQuantity="1"			;数量
	..s ItemObj.ItemUnit=""				;计量单位
	..s ItemObj.ItemStd=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt			;收费标准
	..s ItemObj.ItemAmount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	..s ItemObj.ItemRemark=""			;项目备注
	..d OPInvVoucherDetailObj.Item.Insert(ItemObj)
	s OPInvVoucherObj.Details=OPInvVoucherDetailObj
	//清单项目明细
	s OPInvVoucherAuxDetailObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxDetails).%New()
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s AuxItemObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxItem).%New() 
	.s AuxItemObj.AuxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode	;对应项目编码
	.s AuxItemObj.AuxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;对应项目名称
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  ;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConTBTC",FeeCateKey,0)  ;对照信息
	..q:FeeItmCateConInfo=""
	..s AuxItemObj.AuxItemRelatedCode=$p(FeeItmCateConInfo, "^", 5)  ;费用分类编码
	..s AuxItemObj.AuxItemRelatedName=$p(FeeItmCateConInfo, "^", 6)  ;费用分类名称
	.s AuxItemObj.AuxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;收费明细项目代码
	.s AuxItemObj.AuxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;收费明细项目名称
	.s AuxItemObj.AuxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty	;收费明细项目数量
	.s AuxItemObj.AuxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit		;收费明细项目单位
	.s AuxItemObj.AuxItemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price		;收费明细项目标准
	.s AuxItemObj.AuxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt	;收费明细项目金额
	.s AuxItemObj.AuxItemRemark=""		;收费明细项目备注
	.s AuxItemObj.AuxItemLateFee="0.00"		;收费明细项目滞纳金金额
	.;s AuxItemObj.AuxItemExtInsuranceItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).InsuCode		;收费明细项目医保编码???
	.s AuxItemObj.AuxItemExtInsuranceItemCode=##class(web.AYFY.Method.CommMethod).GetInsuCode(ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode)		;收费明细项目医保编码???
	.s AuxItemObj.AuxItemExtId=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).DetailNo	;收费明细项目ID
	.s AuxItemObj.AuxExtAccountCode=""		;会计科目代码
	.s AuxItemObj.AuxExtAccountName=""		;会计科目名称
	.s AuxItemObj.AuxExtDeptName=""			;开单科室名称
	.s AuxItemObj.AuxExtDeptAccountCode=""	;科室核算码
	.s AuxItemObj.AuxExtDeptAccountName=""	;科室核算码名称
	.s AuxItemObj.AuxExtExcuteDeptName=""	;执行科室名称
	.s AuxItemObj.AuxExtDrawer=""			;开单人
	.s AuxItemObj.AuxExtExecutor=""			;执行人                      
	.d OPInvVoucherAuxDetailObj.AuxItem.Insert(AuxItemObj)
	s OPInvVoucherObj.AuxDetails=OPInvVoucherAuxDetailObj
	s VoucherInput=""
	d OPInvVoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	;b ;VoucherInput
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s OPInvoiceReqObj.Msg=Msg		
	s ReqInputXml=""
	d OPInvoiceReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvoiceOP结束.")
    q ReqInputXml
}

/// 功能说明：整理住院电子票据开具组织入参
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：返回接口文档对应的json格式
///           
/// 修改履历：徐保保 2020-09-21 
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvoiceOP("","","") 
ClassMethod InvoiceIP(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvoiceIP开始")
	
	;s IPInvoiceReqObj=##class(BILL.EINV.DTO.TBTCA.IPInvoiceReq).%New()
	s IPInvoiceReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s ComHeadObj=""
	d ..InvoiceHead("8102",ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s IPInvoiceReqObj.Head=ComHeadObj
	
	//组织报文体
	;s IPInvBodyObj=##class(BILL.EINV.DTO.TBTCA.IPInvoiceMsgBody).%New()
	s IPInvVoucherObj=##class(BILL.EINV.DTO.TBTCA.IPInvoiceMsgVoucher).%New()
	
	s IPInvVoucherMainObj=##class(BILL.EINV.DTO.TBTCA.IPInvoiceMsgVoucherMain).%New()
	s DateTime=$replace($p($zts,",",2),".","")
	s IPInvVoucherMainObj.RandomNumber=$e(DateTime,$l(DateTime)-3,$l(DateTime))_"01"		;校验码M
	s IPInvVoucherMainObj.TotalAmount=ObjInvUpDetail.IUDCreatAmt	;总金额M
	s IPInvVoucherMainObj.IssueDate=$replace($zd(ObjInvUpDetail.IUDPrtDate,3),"-","")	;结算日期M(yyyyMMdd)
	s IPInvVoucherMainObj.IssueTime=$zt(ObjInvUpDetail.IUDPrtTime)		;计算时间M(hh:mm:ss)
	s IPInvVoucherMainObj.InvoicingParty=##class(BILL.EINV.DTO.TBTCA.InvoicingParty).%New()	;开票单位
	s HispitalCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","HispitalCode", 5) 
	s HispitalName=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","HispitalName", 5)
	s IPInvVoucherMainObj.InvoicingParty.InvoicingPartyCode=HispitalCode		;开票单位代码M
	s IPInvVoucherMainObj.InvoicingParty.InvoicingPartyName=HispitalName		;开票单位名称M
	s IPInvVoucherMainObj.PayerPartyType="1"		;交款人类型M(1:个人 2:单位)
	s IPInvVoucherMainObj.PayMode=""			;交款方式O
	s IPInvVoucherMainObj.BizCode=ObjInvUpDetail.IUDBusNo			;业务流水号O
	s IPInvVoucherMainObj.HandlingPerson=ObjInvPrtInfo.BusUserDesc		;开票人M
	s IPInvVoucherMainObj.Checker=ObjInvPrtInfo.BusUserDesc			;复核人O
	s IPInvVoucherMainObj.Remark=""									;备注O
	s IPInvVoucherMainObj.MainExt=##class(BILL.EINV.DTO.TBTCA.IPInvoiceMainExt).%New()	;基本信息扩展
	s IPInvVoucherMainObj.MainExt.MedicalType=""		;医疗类别O
	s IPInvVoucherMainObj.MainExt.HospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo		;住院号O
	s IPInvVoucherMainObj.MainExt.OrgType=""			;医疗机构类型O
	s IPInvVoucherMainObj.MainExt.MedicalInsuranceType=ObjInvPrtInfo.InsuDivInfo.InsuTypeDesc	;医保类型O
	s IPInvVoucherMainObj.MainExt.DepartmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc			;科别O
	s IPInvVoucherMainObj.MainExt.MedicalInsuranceID=ObjInvPrtInfo.InsuDivInfo.InsuId	;医保编号O
	s IPInvVoucherMainObj.MainExt.FundPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYjjzfe0	;医保统筹基金支付M
	s IPInvVoucherMainObj.MainExt.OtherPayAmount="0.00"		;其他支付M
	s IPInvVoucherMainObj.MainExt.AccountPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYzhzfe0	;个人账户支付M
	s IPInvVoucherMainObj.MainExt.OwnPayAmount=ObjInvPrtInfo.InsuDivInfo.INPAYgrzfe0		;个人现金支付M
	s IPInvVoucherMainObj.MainExt.SelfpaymentAmount=ObjInvPrtInfo.InsuDivInfo.selfPayAmt	;个人自付M
	;s IPInvVoucherMainObj.MainExt.CaseNumber=ObjInvPrtInfo.PatBaseInfo.PAPMINO	;病历号O
	s IPInvVoucherMainObj.MainExt.CaseNumber=##class(web.DHCWMRService).IGetMrNoByEpisodeID(ObjInvPrtInfo.PatAdmInfo.AdmDr)	;2020.11.27 改为取护理病历号O
	s IPInvVoucherMainObj.MainExt.InHospitalDate=$replace(ObjInvPrtInfo.PatAdmInfo.AdmDate,"-","")		;住院日期O
	s IPInvVoucherMainObj.MainExt.OutHospitalDate=$replace(ObjInvPrtInfo.PatAdmInfo.OutDate,"-","")	;出院日期O
	s IPInvVoucherMainObj.MainExt.PrepaidAmount=ObjInvPrtInfo.DepositAmt	;预交金额M
	s IPInvVoucherMainObj.MainExt.RechargeAmount=ObjInvPrtInfo.RecAmt		;补缴金额M
	s IPInvVoucherMainObj.MainExt.RefundAmount=ObjInvPrtInfo.RefAmt			;退费金额M
	s IPInvVoucherMainObj.MainExt.Gender=ObjInvPrtInfo.PatBaseInfo.Sex		;性别O
	s IPInvVoucherMainObj.MainExt.Age=ObjInvPrtInfo.PatBaseInfo.Age			;年龄M
	s IPInvVoucherMainObj.MainExt.PayCode=""		;缴款码O
	s IPInvVoucherMainObj.MainExt.InsuranceSettleNo=ObjInvPrtInfo.InsuDivInfo.INPAYdjlsh0	;医保结算号M
	s IPInvVoucherMainObj.MainExt.InsuranceStatus=""	;医保待遇状态O
	s IPInvVoucherMainObj.MainExt.MedicalAccountPayment="0.00"	;医疗账户支付M
	s IPInvVoucherMainObj.MainExt.HealthAccountPay="0.00"		;健康账户支付M
	s IPInvVoucherMainObj.MainExt.MasonicAccountPay="0.00"		;共济账户支付M
	s IPInvVoucherMainObj.MainExt.MedicalAccountBalance="0.00"	;医疗账户余额M
	s IPInvVoucherMainObj.MainExt.HealthAccountBalance="0.00"	;健康账户余额M
	s IPInvVoucherMainObj.MainExt.MedicalAssistance=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay4		;医疗救助M
	s IPInvVoucherMainObj.MainExt.IllnessInsure=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay2			;大病保险M
	s IPInvVoucherMainObj.MainExt.HealthCareFund=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay5		;保健基金M
	s IPInvVoucherMainObj.MainExt.CivilServantSubsidy=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay3	;公务员补助M
	s IPInvVoucherMainObj.MainExt.HospitalRelief=ObjInvPrtInfo.InsuDivInfo.INPAYInsuPay9		;减：医院减免M
	s IPInvVoucherMainObj.MainExt.OverCapPay="0.00"				;超封顶线费用M
	s IPInvVoucherMainObj.MainExt.FamilyMasonicAccountBalance="0.00"	;家庭共济账户余额M
	s IPInvVoucherMainObj.MainExt.BloodDonationCompensation="0.00"	;应收中心血站献血补偿款
	s IPInvVoucherMainObj.MainExt.PreSelfPay="0.00"				;先行自付M
	s IPInvVoucherMainObj.MainExt.SelfpaymentCost="0.00"		;个人自费M
	s IPInvVoucherMainObj.MainExt.UploadSource="1"			;数据来源M(1：窗口结算上传2：诊间结算上传)
	s IPInvVoucherMainObj.MainExt.PayerPhoneNo=ObjInvPrtInfo.PatBaseInfo.Mobphone	;交款人手机号M
	s IPInvVoucherMainObj.MainExt.VisitType="2"				;就诊类型M(就诊类型（1、医保 2、自费 3、急诊 4、体检 9、其他）????
	i ObjInvPrtInfo.InsuDivInfo.InsuTypeCode'="" d  s IPInvVoucherMainObj.MainExt.VisitType="1"	
	s IPInvVoucherMainObj.MainExt.SettlementNo=ObjInvUpDetail.IUDBusNo			;结算号M  --采用流水号
	s IPInvVoucherMainObj.MainExt.SocialCreditCode=""		;医疗机构编码（社会信用代码）O
	s IPInvVoucherMainObj.MainExt.IDCardNo=ObjInvPrtInfo.PatBaseInfo.PatID		;病人身份证号码O
	s IPInvVoucherMainObj.MainExt.SickName=ObjInvPrtInfo.PatBaseInfo.PatName	;病人姓名M
	s IPInvVoucherMainObj.MainExt.SocialSecurityNumber=ObjInvPrtInfo.InsuDivInfo.InsuId	;社会保障号码O
	s IPInvVoucherMainObj.MainExt.PlaceCode="001"				;开票点编码M
	s IPInvVoucherMainObj.MainExt.SocialSecurityCardNo=ObjInvPrtInfo.InsuDivInfo.CardNo	;社保卡号O
	s IPInvVoucherMainObj.MainExt.WorkInjuredPay="0.00"			;工伤支付M
	s IPInvVoucherMainObj.MainExt.IsDrgs="0"			;是否单病种M
	s IPInvVoucherMainObj.MainExt.DrgsCode=""			;单病种编码
	s IPInvVoucherMainObj.MainExt.DrgsName=""			;单病种名称
	s IPInvVoucherMainObj.MainExt.IsCDrg="0"			;是否C-DRG  M 
	s IPInvVoucherMainObj.MainExt.Payee=""			;领款人
	s IPInvVoucherMainObj.MainExt.MedicalInsuranceCode=""		;医保流水号
	s IPInvVoucherMainObj.MainExt.TimesOfHospital="0"			;住院次数?????
	s IPInvVoucherMainObj.MainExt.SPStand=ObjInvPrtInfo.InsuDivInfo.INPAYZstr09				;起付标准		???
	s IPInvVoucherMainObj.MainExt.BSelfpayment="0.00"			;乙类首自付		???
	s IPInvVoucherMainObj.MainExt.PTNSelfpayment="0.00"			;按比例自付		???
	s IPInvVoucherMainObj.MainExt.TeacherSubsidy="0.00"			;师职补助		???
	s IPInvVoucherMainObj.MainExt.AntenatalClinic="0.00"			;产前检查费		???
	s IPInvVoucherMainObj.MainExt.LSubsidiaryInsuranceReimbursement="0.00"			;大病补充报销M
	s IPInvVoucherMainObj.MainExt.VisitDeptName=ObjInvPrtInfo.PatAdmInfo.DepDesc	;就诊科室O
	s IPInvVoucherMainObj.MainExt.VisitDeptCode=ObjInvPrtInfo.PatAdmInfo.DepCode	;就诊科室编码M
	s IPInvVoucherMainObj.MainExt.DiseaseDetails=##class(BILL.EINV.DTO.TBTCA.DiseaseDetails).%New()	;疾病信息
	s MainDiseaseFlag="0"
	f num=1:1:ObjInvPrtInfo.PatAdmInfo.ICD.Size d
	.s DiseaseItemObj=##class(BILL.EINV.DTO.TBTCA.DiseaseItem).%New()
	.s DiseaseItemObj.DiseaseCode=ObjInvPrtInfo.PatAdmInfo.ICD.GetAt(num).ICDCode
	.s DiseaseItemObj.DiseaseName=ObjInvPrtInfo.PatAdmInfo.ICD.GetAt(num).ICDDesc
	.s DiseaseItemObj.DiseaseFlag="0"
	.i (ObjInvPrtInfo.PatAdmInfo.ICD.GetAt(num).ICDMark="Y")&&(MainDiseaseFlag="0")  s DiseaseItemObj.DiseaseFlag="1",MainDiseaseFlag="1"
	.s:((num=ObjInvPrtInfo.PatAdmInfo.ICD.Size)&&(MainDiseaseFlag="0")) DiseaseItemObj.DiseaseFlag="1"  ;2020.11.26 如果没有主诊断，则最后一个为主诊断
	.d IPInvVoucherMainObj.MainExt.DiseaseDetails.DiseaseItem.Insert(DiseaseItemObj)
	;b ;96
	s IPInvVoucherMainObj.MainExt.PayerPartyExt=##class(BILL.EINV.DTO.TBTCA.PayerPartyExt).%New()	;交款人扩展信息
	s IPInvVoucherMainObj.MainExt.PayerPartyExt.SickId=ObjInvPrtInfo.PatBaseInfo.PAPMINO					;病人信息 Id
	s CardInfos=##class(BILL.EINV.DTO.TBTCA.CardInfos).%New()
	s CardInfoObj=##class(BILL.EINV.DTO.TBTCA.CardInfo).%New()
	s CardInfoObj.CardType=##class(BILL.EINV.COM.Common).GetBusCardType(ObjInvPrtInfo.PatBaseInfo.CardType, InvociePam.ObjUPConfig)   ;卡类别M(0：医院就诊卡 1：市民卡 2：健康卡 3：社保卡 4：身份证)
	s CardInfoObj.CardNum=ObjInvPrtInfo.PatBaseInfo.CardNo		;卡号M
	s CardInfoObj.Remark=""	;备注
	;d CardInfos.CardInfo.Insert(CardInfoObj)
	s CardInfos.CardInfo=CardInfoObj
	s IPInvVoucherMainObj.MainExt.PayerPartyExt.CardInfos=CardInfos
	s IPInvVoucherObj.Main=IPInvVoucherMainObj
	;s IPInvVoucherMainObj.MainExt.PayerPartyExt.CardInfos=##class(BILL.EINV.DTO.TBTCA.CardInfos).%New()
	;s CardInfoObj=##class(BILL.EINV.DTO.TBTCA.CardInfo).%New()
	;s CardInfoObj.CardType=""	;卡类别M(0：医院就诊卡 1：市民卡 2：健康卡 3：社保卡 4：身份证)
	;s CardInfoObj.CardNum=""	;卡号M
	;s CardInfoObj.Remark=""	;备注
	;d IPInvVoucherMainObj.MainExt.PayerPartyExt.CardInfos.CardInfo.Insert(CardInfoObj)
	;s IPInvVoucherObj.Main=IPInvVoucherMainObj
	;b ;97
	//发票费用分类
	s IPInvVoucherDetailObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetails).%New()
	;+dongkf 2020-02-24 start
	s FeeCateConFlag=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateTBTC_ConFlag",5)  ;费用是否对照 1 对照 0 不独照
	s:FeeCateConFlag="" FeeCateConFlag="0" ;默认不对照
	;+dongkf 2020-02-24 end
	i FeeCateConFlag="1" d      //费用分类需要与第三方接口费用分类对照
	.s FeeConStr=##class(BILL.EINV.COM.Common).GetCatFeeByInvDr(ObjInvPrtInfo, InvociePam.ObjUPConfig, "IP")
	.f num=1:1:$l(FeeConStr,",") d
	..s CatFeeInfo=$p(FeeConStr,",",num)
	..s ItemObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetailsItem).%New() 
	..s ItemObj.ItemCode=$p(CatFeeInfo,"^",1) 	;收费项目代码
	..s ItemObj.ItemName=$p(CatFeeInfo,"^",2) 	;收费项目名称
	..;s ItemObj.InsuranceItemCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeTypeCon"_ObjInvPrtInfo.InsuDivInfo.InsuTypeCode,ItemObj.ItemCode,5)	;项目医保编码
	..s ItemObj.InsuranceItemCode=$p(CatFeeInfo,"^",1)	;项目医保编码
	..;b ;99
	..s ItemObj.ItemQuantity="1"			;数量
	..s ItemObj.ItemUnit=""				;计量单位
	..s ItemObj.ItemStd=$p(CatFeeInfo,"^",3) 			;收费标准
	..s ItemObj.ItemAmount=$p(CatFeeInfo,"^",3) 		;金额
	..s ItemObj.ItemRemark=""			;项目备注
	..d IPInvVoucherDetailObj.Item.Insert(ItemObj)
	e  d
	.f i=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
	..s ItemObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetailsItem).%New() 
	..s ItemObj.ItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;收费项目代码
	..s ItemObj.ItemName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;收费项目名称
	..s ItemObj.InsuranceItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(i).Code	;项目医保编码
	..s ItemObj.ItemName=ObjInvPrtInfo.InvCateInfo.GetAt(i).Desc	;收费项目名称
	..s ItemObj.ItemQuantity="1"			;数量
	..s ItemObj.ItemUnit=""				;计量单位
	..s ItemObj.ItemStd=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt			;收费标准
	..s ItemObj.ItemAmount=ObjInvPrtInfo.InvCateInfo.GetAt(i).Amt		;金额
	..s ItemObj.ItemRemark=""			;项目备注
	..d IPInvVoucherDetailObj.Item.Insert(ItemObj)
	s IPInvVoucherObj.Details=IPInvVoucherDetailObj
	b ;98
	//清单项目明细
	s IPInvVoucherAuxDetailObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxDetails).%New()
	f i=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
	.s AuxItemObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxItem).%New() 
	.s AuxItemObj.AuxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode	;对应项目编码
	.s AuxItemObj.AuxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateDesc	;对应项目名称
	.i FeeCateConFlag="1" d
	..s FeeCateKey=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).CateCode  ;费用分类编码
	..s FeeItmCateConInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("FeeItmCateOPConTBTC",FeeCateKey,0)  ;对照信息
	..;q:FeeItmCateConInfo=""
	..s AuxItemObj.AuxItemRelatedCode=$p(FeeItmCateConInfo, "^", 5)  ;费用分类编码
	..s AuxItemObj.AuxItemRelatedName=$p(FeeItmCateConInfo, "^", 6)  ;费用分类名称
	.s AuxItemObj.AuxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarCode	;收费明细项目代码
	.s AuxItemObj.AuxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).TarDesc	;收费明细项目名称
	.s AuxItemObj.AuxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Qty	;收费明细项目数量
	.s AuxItemObj.AuxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Unit		;收费明细项目单位
	.s AuxItemObj.AuxItemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Price		;收费明细项目标准
	.s AuxItemObj.AuxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).Amt	;收费明细项目金额
	.s AuxItemObj.AuxItemRemark=""		;收费明细项目备注
	.s AuxItemObj.AuxItemLateFee="0.00"		;收费明细项目滞纳金金额
	.s AuxItemObj.AuxItemExtInsuranceItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).InsuCode		;收费明细项目医保编码???
	.s AuxItemObj.AuxItemExtId=ObjInvPrtInfo.InvItmDetInfo.GetAt(i).DetailNo	;收费明细项目ID
	.s AuxItemObj.AuxExtAccountCode=""		;会计科目代码
	.s AuxItemObj.AuxExtAccountName=""		;会计科目名称
	.s AuxItemObj.AuxExtDeptName=""			;开单科室名称
	.s AuxItemObj.AuxExtDeptAccountCode=""	;科室核算码
	.s AuxItemObj.AuxExtDeptAccountName=""	;科室核算码名称
	.s AuxItemObj.AuxExtExcuteDeptName=""	;执行科室名称
	.s AuxItemObj.AuxExtDrawer=""			;开单人
	.s AuxItemObj.AuxExtExecutor=""			;执行人                      
	.d IPInvVoucherAuxDetailObj.AuxItem.Insert(AuxItemObj)
	s IPInvVoucherObj.AuxDetails=IPInvVoucherAuxDetailObj
	
	s VoucherInput=""
	d IPInvVoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s IPInvoiceReqObj.Msg=Msg
				
	s ReqInputXml=""
	d IPInvoiceReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvoiceIP结束.")
    q ReqInputXml
}

/// 功能说明：根据不同的业务类型分别调用不同冲红接口服务并返回接口服务结果
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 业务类型：REG:挂号,IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 修改履历：徐保保  2020 09 22 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).Invalid开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;Invalid AccessToken
	
	//2.组织退费入参
	s InputReqXml=..InvalidReq(AccessToken, ObjInvUpDetail ,ObjInvPrtInfo, InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;Invalid  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
    //4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionInvalidResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag="0"){
	    s RtnFlag=..SetInvResultOfInvalid(ObjInvUpDetail , .VoucherResultObj)
	    s ObjInvUpDetail.Xstr1=AccessToken
	    s:RtnFlag'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
    }else{
	    s RtnFlag="0"
    }
    
    //5.冲红成功的情况下, 调用服务接口获取开票状态
    if (RtnFlag="0"){ 
		s EInvQryFlag=..EInvInfoQueryOfInvalid(AccessToken, ObjInvUpDetail, InvociePam)
		i (EInvQryFlag'="0"){
			s RtnFlag="-1"
		}
    }
    b ;RtnFlag
    
    d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).Invalid结束")
	q RtnFlag
}

/// 组织授权入参请求XML
ClassMethod InvalidReq(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	;s InvalidReqObj=##class(BILL.EINV.DTO.TBTCA.InvalidReq).%New()
	s InvalidReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s ComHeadObj=""
	d ..InvoiceHead("8103",ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s InvalidReqObj.Head=ComHeadObj
	
	//组织报文体
	s InvalidBodyObj=##class(BILL.EINV.DTO.TBTCA.InvalidMsgBody).%New()
	s InvalidVoucherObj=##class(BILL.EINV.DTO.TBTCA.InvalidMsgVoucher).%New()
	s InvalidVoucherObj.EbillBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;电子票据代码
	s InvalidVoucherObj.EbillNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;电子票据号码	
	s InvalidVoucherObj.InsuranceSettleNo=ObjInvUpDetail.OriInvUpDetail.Xstr2			;结算号
	s InvalidVoucherObj.Reason="患者要求"												;冲销原因
	s InvalidVoucherObj.ChargeOfflMan=InvociePam.UserCode								;冲销人
	s InvalidVoucherObj.ChargeOffTime=##class(BILL.EINV.COM.Common).GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)	;冲销时间
	
    s VoucherInput=""
	d InvalidVoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s InvalidReqObj.Msg=Msg
	
	s ReqInputXml=""
	d InvalidReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, VoucherResultObj As BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult) As %String
{
	s RtnFlg="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	b ;89
	//对返回结果的时间戳进行分割
	s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.CancelEbillBatchCode		;电子票据代码
	s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.CancelEbillNo				;电子票据号码
	s ObjInvUpDetail.IUDCreatDate=+$h									;电子红票生成日期
	s ObjInvUpDetail.IUDCreatTime=$p($h,",",2)							;电子红票生成时间
	s ObjInvUpDetail.EinvprtNo=VoucherResultObj.CancelEbillBatchCode_VoucherResultObj.CancelEbillNo  ;发票编码+发票号码
	s ObjInvUpDetail.IUDResultCode=VoucherResultObj.ResultCode
	s ObjInvUpDetail.IUDResultMeg=VoucherResultObj.ResultMsg   			;查询状态 信息是否成功
	s ObjInvUpDetail.IUDUplodeFlag="Y"                                  ;上传标志 Y:上传成功，N:上传失败
	s ObjInvUpDetail.EInvFlg="S"										;发票状态
	s ObjInvUpDetail.IUDPrintType="E"                                   ;电子票据
	b ;99
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	s RtnFlg="0"
	q RtnFlg
}

/// 电子票据信息查询接口（8302）
/// 入参：UserCode   	操作人
/// 	  InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：授权凭证
ClassMethod EInvInfoQueryOfInvoice(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s:(AccessToken="") InvociePam.ErrMsgInfo="查询票据信息接口入参不能为空"
	q:(AccessToken="") RtnFlag
	
	//1.组织电子票据查询接口入参
	s EInvInfoReqXML=..EInvInfoQueryReq(AccessToken, ObjInvUpDetail, InvociePam)
	s:EInvInfoReqXML="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:EInvInfoReqXML="" RtnFlag
	b ;EInvInfoQuery-EInvInfoReqXML
	
	//2.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(EInvInfoReqXML,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
    b ;InvoiceResXML
    
    //3.对返回结果解密
    s EInvInfoResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionEInvInfoQryResult(InvoiceResXML, .EInvInfoResObj, .VoucherResultObj)
    b ;RtnFlag
    i (RtnFlag="0"){
	    s RtnFlag=..SetInvResultOfInvoiceStutas(ObjInvUpDetail, .EInvInfoResObj, .VoucherResultObj)
	    s ObjInvUpDetail.Xstr1=AccessToken
	    s:RtnFlag'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
    }else{
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
	
	q RtnFlag
}

/// 电子票据信息查询接口（8302）
/// 入参：UserCode   	操作人
/// 	  InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：授权凭证
ClassMethod EInvInfoQueryOfInvalid(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s:(AccessToken="") InvociePam.ErrMsgInfo="查询票据信息接口入参不能为空"
	q:(AccessToken="") RtnFlag
	
	//1.组织电子票据查询接口入参
	s EInvInfoReqXML=..EInvInfoQueryReq(AccessToken, ObjInvUpDetail, InvociePam)
	s:EInvInfoReqXML="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:EInvInfoReqXML="" RtnFlag
	b ;EInvInfoQuery-EInvInfoReqXML
	
	//2.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(EInvInfoReqXML,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
    b ;InvoiceResXML
    
    //3.对返回结果解密
    s EInvInfoResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionEInvInfoQryResult(InvoiceResXML, .EInvInfoResObj, .VoucherResultObj)
    b ;RtnFlag1
    i (RtnFlag="0"){
	    s RtnFlag=..SetInvResultOfInvalidStutas(ObjInvUpDetail, .EInvInfoResObj, .VoucherResultObj)
	    s ObjInvUpDetail.Xstr1=AccessToken
	    s:RtnFlag'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
    }else{
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
	
	q RtnFlag
}

/// 组织授权入参请求XML
ClassMethod EInvInfoQueryReq(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s EInvInfoReqObj=##class(BILL.EINV.DTO.TBTCA.EInvInfoQryReq).%New()
	
	//组织报文头
	s ComHeadObj=""
	d ..InvoiceHead("8302",ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s EInvInfoReqObj.Head=ComHeadObj
	
	//组织报文体
	s EInvInfoVoucherObj=##class(BILL.EINV.DTO.TBTCA.EInvInfoMsgVoucher).%New()
	i (ObjInvUpDetail.IUDUploadPathCode="InvalidInvSvr")||(ObjInvUpDetail.IUDUploadPathCode="InvalidInv")||(ObjInvUpDetail.IUDUploadPathCode="PrintPaper")||(ObjInvUpDetail.IUDUploadPathCode="RePrintPaper"){
		s EInvInfoVoucherObj.EbillBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode			;电子票据代码
		s EInvInfoVoucherObj.EbillNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo					;电子票据号码
		s EInvInfoVoucherObj.InsuranceSettleNo=ObjInvUpDetail.OriInvUpDetail.IUDBusNo				;结算号
	}elseif ((ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv")){
		s EInvTradDr=ObjInvUpDetail.OriInvUpDetail.IUDInitRowID  ;纸质票据对应的电子票据交易表dr
		if (EInvTradDr'=""){
			s objEinvTrade=##class(BILL.EINV.PO.InvUpDetails).%OpenId(EInvTradDr)
			if ($isobject(objEinvTrade)'=0) {
				s EInvInfoVoucherObj.EbillBatchCode=objEinvTrade.IUDBillBatchCode			;电子票据代码
				s EInvInfoVoucherObj.EbillNo=objEinvTrade.IUDBillBatchNo					;电子票据号码
				s EInvInfoVoucherObj.InsuranceSettleNo=objEinvTrade.Xstr2				;结算号
			}
		}
	}else{
		s EInvInfoVoucherObj.EbillBatchCode=ObjInvUpDetail.IUDBillBatchCode			;电子票据代码
		s EInvInfoVoucherObj.EbillNo=ObjInvUpDetail.IUDBillBatchNo					;电子票据号码
		s EInvInfoVoucherObj.InsuranceSettleNo=ObjInvUpDetail.IUDBusNo				;结算号
	}
	;b ;EInvInfoQueryReq
	
    s VoucherInput=""
	d EInvInfoVoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s EInvInfoReqObj.Msg=Msg
	
	s ReqInputXml=""
	d EInvInfoReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 入参：XMLRes 出参XML
/// 	  InvoiceResObj 响应请求对象
/// 	  VoucherResultObj 响应报文对象
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionEInvInfoQryResult("","") 
ClassMethod DecryptionEInvInfoQryResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s rtn="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionEInvInfoQryResult开始.")
	
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	
	//1.将报文头xml转换为对象
	s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.ComRes).%New()
	s InvoiceRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ComRes", .InvoiceResObj)
	q:InvoiceRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InvoiceResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.EInvInfoMsgResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.EInvInfoMsgResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3  VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionEInvInfoQryResult结束.")
    q rtn
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
a	.s ObjInvUpDetail.IUDResultCode="0000"
	.s ObjInvUpDetail.Xstr2=VoucherResultObj.InsuranceSettleNo	;结算号
	.s RtnFlg="0"
	e  d
	.s RtnFlg="-1"
	b ;saveto
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice结束.")
	
	q RtnFlg
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInvalidResult("","") 
ClassMethod DecryptionInvalidResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult) As %String
{
	s rtn="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionInvoiceResult开始.")
	
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	;b ;0
	//1.将报文头xml转换为对象
	;s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.OPInvoiceRes).%New()
	s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.ComRes).%New()
	s InvoiceRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ComRes", .InvoiceResObj)
	q:InvoiceRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InvoiceResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3  VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionInvoiceResult结束.")
    q rtn
}

/// 单位可用项目查询（8903） 
/// 入参：InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：单位可用项目
ClassMethod getFeeInfo(InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;Invalid AccessToken
	
	//组织初始化入参请求XML
	s UseItemsReqXML=..UseItemsXML(AccessToken,InvociePam)
	s:UseItemsReqXML="" InvociePam.ErrMsgInfo="组织授权接口入参失败"
	q:UseItemsReqXML="" RtnFlag
	b ;UseItemsReqXML
	
	//调用同步天成HTTP接口
    s ItemResXML=""
    s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(UseItemsReqXML,InvociePam.ObjUPConfig, .ItemResXML)
    s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
    b ;ResultRtn
    
    //3.对返回结果解密
    s ItemDLResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionItemDownLoadResult(ItemResXML, .ItemDLResObj, .VoucherResultObj)
    b ;RtnFlag1
    i (RtnFlag="0"){
	    d ##class(BILL.EINV.BL.COM.DicDataCtl).SaveDicdataInfo("SYS^FeeItmCateTBTC^费用分类(同步天成)^^^^")
	    
	    f i=1:1:VoucherResultObj.Items.Item.Size  d
	    .s DicData=VoucherResultObj.Items.Item.GetAt(i).ItemCode_"^"_VoucherResultObj.Items.Item.GetAt(i).ItemName
	    .s DicData="FeeItmCateTBTC"_"^"_DicData_"^^^^^^^"
	    .;b ;测试1
	    .d ##class(BILL.EINV.BL.COM.DicDataCtl).SaveDicdataInfo(DicData)
    }else{
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
	
	q RtnFlag
}

/// 组织授权入参请求XML
ClassMethod UseItemsXML(AccessToken, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s ItemDLReqObj=##class(BILL.EINV.DTO.TBTCA.ItemDownLoadReq).%New()
	
	//组织报文头
	s ComHeadObj=""
	d ..InvoiceHead("8903","DL",AccessToken,InvociePam, .ComHeadObj)
	s ItemDLReqObj.Head=ComHeadObj	
	//报文体
	
	s VoucherObj=##class(BILL.EINV.DTO.TBTCA.ItemDownLoadMsgVoucher).%New()
    s VoucherInput=""
	d VoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ItemDLReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ItemDLReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInitResult("","") 
ClassMethod DecryptionItemDownLoadResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.ItemDownLoadVoucherResult) As %String
{
	s rtn="-1"
	
	//s XMLRes="<?xml version='1.0' encoding='UTF-8'?><Invoice><Head><MsgNo>5901</MsgNo><Version>1.0</Version><AppId>KPQZDWB5629411</AppId><MsgId>20190703105001999</MsgId><MsgRef>20190703105000000</MsgRef><DateTime>20190703105001999</DateTime><Reserve></Reserve></Head><Msg>PFZvdWNoZXI+PEFjY2Vzc1Rva2VuPmFhYWFiYmJiYjExMTExMzMzMzMzPC9BY2Nlc3NUb2tlbj48RXhwaXJlc0luPjcyMDA8L0V4cGlyZXNJbj48L1ZvdWNoZXI+</Msg></Invoice>"
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	//1.将报文头xml转换为对象
	s ItemResObj=##class(BILL.EINV.DTO.TBTCA.ItemDownLoadRes).%New()
	s ItemRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ItemDownLoadRes", .ItemResObj)
	q:ItemRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(ItemResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.ItemDownLoadVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.ItemDownLoadVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3   VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
    q rtn
}

/// 电子票据单张下载接口（8213）  
/// 入参：InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：
ClassMethod EInvPrint(InputPam As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s EInvoiceFile=""
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" EInvoiceFile
	b ;Invalid AccessToken
	
	//2.组织初始化入参请求XML
	s EInvPrintReqXML=..EInvPrintXML(AccessToken,InputPam,InvociePam)
	s:EInvPrintReqXML="" InvociePam.ErrMsgInfo="组织授权接口入参失败"
	q:EInvPrintReqXML="" EInvoiceFile
	b ;EInvPrintReqXML
	
	//调用同步天成HTTP接口
    s EInvPRTResXML=""
    s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(EInvPrintReqXML,InvociePam.ObjUPConfig, .EInvPRTResXML)
    s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" EInvoiceFile
    b ;ResultRtn
    
    //3.对返回结果解密
    s EInvPRTResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionEInvPrintResult(EInvPRTResXML, .EInvPRTResObj, .VoucherResultObj)
    b ;RtnFlag1
    i (RtnFlag="0"){
	   s EInvoiceFile=VoucherResultObj.EInvoiceLayoutFile
    }else{
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
	
	q EInvoiceFile
}

/// 组织授权入参请求XML
ClassMethod EInvPrintXML(AccessToken, InputPam, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	s EPrintReqObj=##class(BILL.EINV.DTO.TBTCA.EInvPrintReq).%New()
	
	//组织报文头
	s ComHeadObj=""
	d ..InvoiceHead("8213","PRT",AccessToken,InvociePam, .ComHeadObj)
	s EPrintReqObj.Head=ComHeadObj	
	//报文体
	
	s VoucherObj=##class(BILL.EINV.DTO.TBTCA.EInvPrintMsgVoucher).%New()
	s VoucherObj.AgencyCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","HispitalCode", 5)	//单位编码
	s VoucherObj.AgencyName=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Hospital_Einvt_Info","HispitalName", 5)	//单位名称
	s VoucherObj.EInvoiceCode=$p(InputPam,"^",1)	;电子票据代码
	s VoucherObj.EInvoiceNumber=$p(InputPam,"^",2)	;电子票据号码
	s VoucherObj.RandomNumber=$p(InputPam,"^",3)	;校验码
	
    s VoucherInput=""
	d VoucherObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s EPrintReqObj.Msg=Msg
	
	s ReqInputXml=""
	d EPrintReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionInitResult("","") 
ClassMethod DecryptionEInvPrintResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvPrintVoucherResult) As %String
{
	s rtn="-1"
	
	//s XMLRes="<?xml version='1.0' encoding='UTF-8'?><Invoice><Head><MsgNo>5901</MsgNo><Version>1.0</Version><AppId>KPQZDWB5629411</AppId><MsgId>20190703105001999</MsgId><MsgRef>20190703105000000</MsgRef><DateTime>20190703105001999</DateTime><Reserve></Reserve></Head><Msg>PFZvdWNoZXI+PEFjY2Vzc1Rva2VuPmFhYWFiYmJiYjExMTExMzMzMzMzPC9BY2Nlc3NUb2tlbj48RXhwaXJlc0luPjcyMDA8L0V4cGlyZXNJbj48L1ZvdWNoZXI+</Msg></Invoice>"
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	b ;0
	//1.将报文头xml转换为对象
	s EInvPrintResObj=##class(BILL.EINV.DTO.TBTCA.EInvPrintRes).%New()
	s EPrintRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.EInvPrintRes", .EInvPrintResObj)
	q:EPrintRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(EInvPrintResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.EInvPrintVoucherResult).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.EInvPrintVoucherResult", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3   VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
    q rtn
}

/// 功能说明：调用服务接口获取换开纸质票据接口服务结果
/// 			  门诊电子票据换开接口（8104）
/// 			  住院电子票据换开接口（8105）
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	徐保保   2020-12-19 
/// 其    他：	w ##class(BILL.EINV.ADP.BSA).PrintPaper("","") 
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).PrintPaper开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s InputReqXml=..TurnPaperInvoice(AccessToken, ObjInvUpDetail ,ObjInvPrtInfo, InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionVoucherResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag'="0"){
	    s RtnFlag="-1"
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
    //5.不管换开是否成功, 都调用服务接口获取开票状态
    s EInvQryFlag=..EInvInfoQueryOfTurnPaper(AccessToken, ObjInvUpDetail, InvociePam)
	i (EInvQryFlag'="0"){
		s RtnFlag="-1"
		s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
    }else{
	    s RtnFlag="0"
    }

	q RtnFlag
}

/// 组织换开纸质票据接口入参请求XML
ClassMethod TurnPaperInvoice(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8104"		;门诊电子票换开
	s:ObjInvUpDetail.IUDPayAdmType="I" MsgNo="8105"		;住院电子票换开
	
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	s TurnPaperReqObj=##class(BILL.EINV.DTO.TBTCA.EInvTurnPaperReq).%New()
	s TurnPaperReqObj.EbillBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;电子票据代码
	s TurnPaperReqObj.EbillNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;电子票据号码
	s TurnPaperReqObj.BillBatchCode=InvociePam.pBillBatchCode	;纸质票据代码
	s TurnPaperReqObj.BillNo=InvociePam.pBillNo					;纸质票据号码	
	s TurnPaperReqObj.RandomNumber=ObjInvUpDetail.OriInvUpDetail.IUDCheckCode	;校验码(传原电子校验码？还是新生成校验码)
	s TurnPaperReqObj.InsuranceSettleNo=ObjInvUpDetail.OriInvUpDetail.Xstr2		;结算号
	s TurnPaperReqObj.PrintSource="1"		;1：窗口,2：自助机							
	s TurnPaperReqObj.PrintTime=##class(BILL.EINV.COM.Common).GetBusDate("","")	;换开时间
	
    s VoucherInput=""
	d TurnPaperReqObj.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 入参：MsgNo 请求编号
/// 	  UserCode 操作员工号
/// 	  ObjUPConfig 服务配置信息对象
/// 	  InitHeadObj 授权头报文对象
/// MsgNo, UserCode, ObjUPConfig As BILL.EINV.PO.InvUpConfig, ByRef InitHeadObj As BILL.EINV.DTO.TBTCA.InitHeaderInfo
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionTurnPaperResult("","") 
ClassMethod DecryptionVoucherResult(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.VoucherResultCom) As %String
{
	s rtn="-1"
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionVoucherResult开始.")
	
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""utf-8""?>","")
	
	;b ;0
	//1.将报文头xml转换为对象
	s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.ComRes).%New()
	s InvoiceRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ComRes", .InvoiceResObj)
	q:InvoiceRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InvoiceResObj.Msg,"UTF8")
	s VoucherResult=OutStream.Read(OutStream.Size)
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.VoucherResultCom).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.VoucherResultCom", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3   VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).DecryptionVoucherResult结束.")
    q rtn
}

/// 电子票据信息查询接口（8302）
/// 入参：UserCode   	操作人
/// 	  InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：授权凭证
ClassMethod EInvInfoQueryOfTurnPaper(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s:(AccessToken="") InvociePam.ErrMsgInfo="查询票据信息接口入参不能为空"
	q:(AccessToken="") RtnFlag
	
	//1.组织电子票据查询接口入参
	s EInvInfoReqXML=..EInvInfoQueryReq(AccessToken, ObjInvUpDetail, InvociePam)
	s:EInvInfoReqXML="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:EInvInfoReqXML="" RtnFlag
	b ;EInvInfoQuery-EInvInfoReqXML
	
	//2.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(EInvInfoReqXML,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
    b ;InvoiceResXML
    
    //3.对返回结果解密
    s EInvInfoResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionEInvInfoQryResult(InvoiceResXML, .EInvInfoResObj, .VoucherResultObj)
    b ;RtnFlag1
    i (RtnFlag="0"){
	    s RtnFlag=..SetInvResultOfTurnPaperStutas(ObjInvUpDetail, InvociePam, .EInvInfoResObj, .VoucherResultObj)
	    s ObjInvUpDetail.Xstr1=AccessToken
	    s:RtnFlag'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
    }else{
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
	
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfTurnPaperStutas(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvoice开始.")
	
	b ;SetInvResultOfInvoiceStutas
	//对返回结果的时间戳进行分割
	
	f i=1:1:VoucherResultObj.BillInfos.Size  d
	.i (InvociePam.pBillBatchCode=VoucherResultObj.BillInfos.GetAt(i).BillInfo.BillBatchCode)&&(InvociePam.pBillNo=VoucherResultObj.BillInfos.GetAt(i).BillInfo.BillNo) d
	..s RtnFlg="0"
	..s createTime=VoucherResultObj.BillInfos.GetAt(i).BillInfo.PrintTime
	..s createDateTime=$e(createTime,1,$l(createTime)-3)
	..s createDate=$zdh($e(createDateTime,1,8),8)
	..s createTime=$zth(($e(createDateTime,9,10)_":"_$e(createDateTime,11,12)_":"_$e(createDateTime,13,14)),1)
	..s ObjInvUpDetail.IUDBillBatchCode=VoucherResultObj.BillInfos.GetAt(i).BillInfo.BillBatchCode			;纸质票据代码
	..s ObjInvUpDetail.IUDBillBatchNo=VoucherResultObj.BillInfos.GetAt(i).BillInfo.BillNo					;纸质票据号码
	..s ObjInvUpDetail.IUDResultMeg="已换开成功"
	..s ObjInvUpDetail.EInvFlg="I"
	..s ObjInvUpDetail.IUDUser=InvociePam.UserID              ;开票人
	..s:ObjInvUpDetail.IUDCreatDate="" ObjInvUpDetail.IUDCreatDate=createDate						;电子票据生成日期
	..s:ObjInvUpDetail.IUDCreatTime="" ObjInvUpDetail.IUDCreatTime=createTime
	..s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	..s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	..s ObjInvUpDetail.IUDBillisScarlet=VoucherResultObj.BillInfos.GetAt(i).BillInfo.ChargeOffStatus			;是否已开红票
	..s ObjInvUpDetail.IUDBillBatchStatus=VoucherResultObj.BillInfos.GetAt(i).BillInfo.CancelStatus				;状态
	
	q RtnFlg
}

/// 功能说明：调用服务接口获取作废换开的纸质票据接口服务结果
/// 			  电子票据和纸质票据同时作废接口（8106）
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.BSA).InvalidPaperInv("","") 
ClassMethod InvalidPaperInv(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvalidPaperInv开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s InputReqXml=..TurnPaperInvalid(AccessToken, ObjInvUpDetail ,ObjInvPrtInfo, InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionVoucherResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag'="0"){
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
    //5.不管作废换开是否成功, 都调用服务接口获取开票状态
    s EInvQryFlag=..EInvInfoQueryOfInvalidPaper(AccessToken, ObjInvUpDetail, InvociePam)
	i (EInvQryFlag'="0"){
		s RtnFlag="-1"
		s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
    }
	
	q RtnFlag
}

/// 组织电子票据和纸质票据同时作废接口（8106）入参请求XML
ClassMethod TurnPaperInvalid(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8106"		;电子票据和纸质票据同时作废
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	s ObjReq=##class(BILL.EINV.DTO.TBTCA.EInvTurnPaperInvalidReq).%New()
	;s ObjReq.EbillBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;电子票据代码
	;s ObjReq.EbillNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;电子票据号码	
	;s ObjReq.InsuranceSettleNo=ObjInvUpDetail.OriInvUpDetail.Xstr2			;结算号
	if ((ObjInvUpDetail.IUDUploadPathCode="InvalidPaperInv")){
		s EInvTradDr=ObjInvUpDetail.OriInvUpDetail.IUDInitRowID  ;纸质票据对应的电子票据交易表dr
		if (EInvTradDr'=""){
			s objEinvTrade=##class(BILL.EINV.PO.InvUpDetails).%OpenId(EInvTradDr)
			if ($isobject(objEinvTrade)'=0) {
				s ObjReq.EbillBatchCode=objEinvTrade.IUDBillBatchCode			;电子票据代码
				s ObjReq.EbillNo=objEinvTrade.IUDBillBatchNo					;电子票据号码
				s ObjReq.InsuranceSettleNo=objEinvTrade.Xstr2			;结算号
			}
		}
	}
	s ObjReq.Reason="患者要求"					;作废原因
	s ObjReq.CancellMan=InvociePam.UserDesc		;作废人								
	s ObjReq.CancellTime=##class(BILL.EINV.COM.Common).GetBusDate(ObjInvPrtInfo.BusDate,ObjInvPrtInfo.BusTime)	;作废时间
	s ObjReq.IsLost="0"	;纸票是否遗失(0:否  1:是);需要核实是否遗失是否影响作废纸质票功能，此功能业务需要作废纸票
	
    s VoucherInput=""
	d ObjReq.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 电子票据信息查询接口（8302）
/// 入参：UserCode   	操作人
/// 	  InvociePam	其它对象(包括电子票据入参属性,扩展字段属性等)	
/// 出参：授权凭证
ClassMethod EInvInfoQueryOfInvalidPaper(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s:(AccessToken="") InvociePam.ErrMsgInfo="查询票据信息接口入参不能为空"
	q:(AccessToken="") RtnFlag
	
	//1.组织电子票据查询接口入参
	s EInvInfoReqXML=..EInvInfoQueryReq(AccessToken, ObjInvUpDetail, InvociePam)
	s:EInvInfoReqXML="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:EInvInfoReqXML="" RtnFlag
	b ;EInvInfoQuery-EInvInfoReqXML
	
	//2.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(EInvInfoReqXML,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
    b ;InvoiceResXML
    
    //3.对返回结果解密
    s EInvInfoResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionEInvInfoQryResult(InvoiceResXML, .EInvInfoResObj, .VoucherResultObj)
    b ;RtnFlag1
    i (RtnFlag="0"){
	    s RtnFlag=..SetInvResultOfInvalidPaper(ObjInvUpDetail, InvociePam, .EInvInfoResObj, .VoucherResultObj)
	    s ObjInvUpDetail.Xstr1=AccessToken
	    s:RtnFlag'="0" InvociePam.ErrMsgInfo="调用接口成功,保存结果失败"
    }else{
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
  
	q RtnFlag
}

/// 功能说明：设置开票结果信息到交易对象表对象中
/// 入参说明：OutJsonStream  --> 开票返回值json数据
/// 返 回 值：0 成功 其他值失败
ClassMethod SetInvResultOfInvalidPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, VoucherResultObj As BILL.EINV.DTO.TBTCA.EInvInfoMsgResult) As %String
{
	s RtnFlg="-1"
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvalidPaper开始.")
	
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
a	.s ObjInvUpDetail.IUDResultCode="0000"
	.s ObjInvUpDetail.Xstr2=VoucherResultObj.InsuranceSettleNo	;结算号
	.s RtnFlg="0"
	e  d
	.s RtnFlg="-1"
	b ;saveto
	//d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).SetInvResultOfInvalidPaper结束.")
	
	q RtnFlg
}

/// 功能说明：调用服务接口获取重新换开纸质票据接口服务结果
/// 			  门诊纸质票据重打接口（8107）
/// 			  住院纸质票据重打接口（8109）
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 其中:	  ,扩展字段属性中"^"分割的第五个字段为'纸质票据代码',"^"分割的第六个字段为'纸质票据号码',不允许随便修改扩展串位置
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.TBTCA).RePrintPaper("","") 
ClassMethod RePrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).RePrintPaper开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s InputReqXml=..ReTurnPaperInvoice(AccessToken, ObjInvUpDetail ,ObjInvPrtInfo, InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionVoucherResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag'="0"){
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
    
    //5.不管换开是否成功, 都调用服务接口获取开票状态
    s EInvQryFlag=..EInvInfoQueryOfTurnPaper(AccessToken, ObjInvUpDetail, InvociePam)
	i (EInvQryFlag'="0"){
		s RtnFlag="-1"
		s InvociePam.ErrMsgInfo="获取发票开票状态信息失败"
    }else{
	    s RtnFlag="0"
    }
	
	
	q RtnFlag
}

/// 组织重新换开纸质票据接口入参请求XML
ClassMethod ReTurnPaperInvoice(AccessToken, ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8107"		;门诊电子票重新换开
	s:ObjInvUpDetail.IUDPayAdmType="I" MsgNo="8109"		;住院电子票重新换开
	
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,ObjInvUpDetail.IUDPayAdmType,AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	s ObjReq=##class(BILL.EINV.DTO.TBTCA.EInvReTurnPaperReq).%New()
	s ObjReq.EbillBatchCode=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode	;电子票据代码
	s ObjReq.EbillNo=ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo			;电子票据号码
	s ObjReq.InsuranceSettleNo=ObjInvUpDetail.OriInvUpDetail.Xstr2			;结算号
	s ObjReq.Reason="票据错误"					;作废原因
	s ObjReq.CancellMan=InvociePam.UserDesc		;作废人								
	s ObjReq.CancellTime=##class(BILL.EINV.COM.Common).GetBusDate("","")	;作废时间
	s ObjReq.IsLost="0"	;纸票是否遗失(0:否  1:是);需要核实是否遗失是否影响作废纸质票功能，此功能业务需要作废纸票
	s ObjReq.BillBatchCode=InvociePam.pBillBatchCode			;纸质票据代码
	s ObjReq.BillNo=InvociePam.pBillNo					;纸质票据号码	
	s ObjReq.PrintTime=##class(BILL.EINV.COM.Common).GetBusDate("","")	;换开时间
	
    s VoucherInput=""
	d ObjReq.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 功能说明：调用空白纸质票据作废接口
/// 			  空白纸质票据作废接口（8108）
/// 入参说明: dataStr    --> 入参数据
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong   2019-09-26
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvalidBlankInv("","","") 
ClassMethod InvalidBlankInv(dataStr As %String, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvalidBlankInv开始")
	s RtnFlag="-1"
	
		
	s UserID=$p(dataStr,"^",1)      //操作人ID
	s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)       ;操作员编码
	s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s InvociePam.ObjUPConfig=ObjUPConfig
	s InvociePam.UserCode=UserCode
	s InvociePam.UserID=UserID
	s InvociePam.UserDesc=UserDesc
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s InputReqXml=..BlankPaperInvalid(AccessToken,dataStr,InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionVoucherResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag'="0"){
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
	
	q RtnFlag
}

/// 组织空白纸质票据作废接口（8108）入参请求XML
ClassMethod BlankPaperInvalid(AccessToken, dataStr, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8108"		;空白纸质票据作废
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,"BKI",AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	
	s ObjReq=##class(BILL.EINV.DTO.TBTCA.BlankPaperInvalidReq).%New()
	s ObjReq.BillBatchCode=$p(dataStr,"^",2)			;纸质票据代码
	s ObjReq.BillNo=$p(dataStr,"^",3)		;纸质票据号码
	s ObjReq.BillNoEnd=$p(dataStr,"^",4)	;纸质票据号码(结束号码)
	s ObjReq.Reason="发票破损"				;作废原因
	s:$p(dataStr,"^",5)'="" ObjReq.Reason=$p(dataStr,"^",5)
	s ObjReq.CancellMan=UserDesc			;作废人								
	s ObjReq.CancellTime=##class(BILL.EINV.COM.Common).GetBusDate("","")	;作废时间
	s ObjReq.IsLost="0"		;纸票是否遗失(0:否  1:是);需要核实是否遗失是否影响作废纸质票功能，此功能业务需要作废纸票
	s ObjReq.BillSource="0"	;票据来源(0：HIS 系统,1：电票系统初始化信息)
	
    s VoucherInput=""
	d ObjReq.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 功能说明：调用空白纸质票据作废接口
/// 			  空白纸质票据作废接口（8108）
/// 入参说明: dataStr    --> 入参数据
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong   2019-09-26
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvalidBlankInv("","","") 
ClassMethod PaperStockInit(dataStr As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).PaperStockInit开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s InputReqXml=..CreatPaperStockInit(AccessToken,dataStr,InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionVoucherResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag'="0"){
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
	
	q RtnFlag
}

/// 组织票据号码初始化接口（8110）入参请求XML
ClassMethod CreatPaperStockInit(AccessToken, dataStr, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8110"		;票据号码初始化
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,"PSI",AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	
	s ObjReq=##class(BILL.EINV.DTO.TBTCA.PaperBillNoInitReq).%New()
	s ObjReq.BillType=$p(dataStr,"^",2)			;窗口类型(mzpj门诊票据、zypj 住院票据、zzpj 自助票据、zcpj 诊查票据 zyyjj 住院预交金、zyzz 住 院自助)
	s ObjReq.BillBatchCode=$p(dataStr,"^",3)	;纸质票据编码
	s ObjReq.BillName=$p(dataStr,"^",4)			;票据名称
	s ObjReq.StartBillNo=$p(dataStr,"^",5)		;开始号码
	s ObjReq.Quantity=$p(dataStr,"^",6)			;数量								
	s ObjReq.EndBillNo=$p(dataStr,"^",7)		;结束号码
	s ObjReq.CurrentBillNo=$p(dataStr,"^",8)	;当前号码
	
    s VoucherInput=""
	d ObjReq.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 功能说明：调用服务接口获取纸质/电子票据有效票据号段接口服务结果
/// 			  个人票据领用查询接口（8215）
/// 入参说明:	placeCode(收费员编码)
/// 			billCode:票据类型(O:门诊发票类型,R:挂号发票类型,I:住院发票类型,D:住院押金类型)
///             billBatchCode:票据代码(是否纸质票据/电子票据)
/// 返 回 值：	成功标志(0 成功 其他值代表失败)  
/// 修改履历：	苏惠德   2019-09-17 
/// 其    他：	w ##class(BILL.EINV.ADP.BSA).InvReceive("","","") 
ClassMethod InvReceive(InputPam As %String, ByRef objValidBillNo As BILL.EINV.DTO.COM.ValidBillNo, ObjUPConfig As BILL.EINV.PO.InvUpConfig) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvReceive开始")
	s RtnFlag="-1"
	
	s UserID=$p(InputPam,"^",1)      //操作人ID
	s UserCode=$p($g(^SSU("SSUSR",UserID)),"^",1)       ;操作员编码
	s UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)		;操作员名称
	s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s InvociePam.ObjUPConfig=ObjUPConfig
	s InvociePam.UserCode=UserCode
	s InvociePam.UserID=UserID
	s InvociePam.UserDesc=UserDesc
	s InvType=$p(InputPam,"^",4)
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s $p(InputPam,"",5)=$zd(##class(websys.Conversions).DateHtmlToLogical($p(InputPam,"",5)),8)
	s $p(InputPam,"",6)=$zd(##class(websys.Conversions).DateHtmlToLogical($p(InputPam,"",6)),8)
	s $p(InputPam,"",4)=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("LogicIUDTypeCon"_ObjConfig.FactoryCode,$p(InputPam,"",4),5)
	s InputReqXml=..CreatInvReceive(AccessToken,InputPam,InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionOfInvReceive(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    
	//对返回的json串数据进行解析并保存objValidBillNo对象中
	i ($isObject(objValidBillNo))=0	d
	.s objValidBillNo=##class(BILL.EINV.DTO.COM.ValidBillNo).%New()
	
	i (RtnFlag="0")&&(VoucherResultObj.ReceiveInfos.Count>0) d
	.f i=1:1:VoucherResultObj.ReceiveInfos.Count  do
	..s DHCInvoiceObj = ##class(BILL.EINV.DTO.COM.DHCInvoiceInfo).%New()
    ..s DHCInvoiceObj.INVtype=InvType  ;VoucherResultObj.ReceiveInfos.GetAt(i).CollectionRecord.BillCode			;票据种类编码
	..s DHCInvoiceObj.INVBillInvName=VoucherResultObj.ReceiveInfos.GetAt(i).CollectionRecord.BillName  			;票据代码
	..s DHCInvoiceObj.INVBillInvCode=VoucherResultObj.ReceiveInfos.GetAt(i).CollectionRecord.BillCode  	;票据代码
	..s DHCInvoiceObj.INVStartInv=VoucherResultObj.ReceiveInfos.GetAt(i).CollectionRecord.StartNo            ;票据起始号码
	..s DHCInvoiceObj.INVEndInv=VoucherResultObj.ReceiveInfos.GetAt(i).CollectionRecord.EndNo		   	    ;;票据终止号码
	..s DHCInvoiceObj.INVUsr=UserID
	..s DHCInvoiceObj.INVhospital=##class(web.UDHCHospitalGroup).GetHospitalIDByUserID(UserID)
	..d objValidBillNo.INVBillNoList.Insert(DHCInvoiceObj)	
	
	q RtnFlag
}

/// 组织个人票据领用查询接口（8215）入参请求XML
ClassMethod CreatInvReceive(AccessToken, dataStr, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8215"		;个人票据领用
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,"INVR",AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	
	s ObjReq=##class(BILL.EINV.DTO.TBTCA.PaperReceiveReq).%New()
	s ObjReq.BeginDate=$p(dataStr,"^",5)		;领用开始日期YYYYMMDD
	s ObjReq.EndDate=$p(dataStr,"^",6)			;领用截止日期YYYYMMDD
	s ObjReq.BillCode=$p(dataStr,"^",4)			;纸质票据代码
	s ObjReq.Receiver=InvociePam.UserCode		;领用人工号
	
    s VoucherInput=""
	d ObjReq.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

/// 入参：XMLRes 出参XML
/// 	  InvoiceResObj 响应请求对象
/// 	  VoucherResultObj 响应报文对象
/// w ##class(BILL.EINV.ADP.TBTCA).DecryptionEInvInfoQryResult("","") 
ClassMethod DecryptionOfInvReceive(XMLRes, ByRef InvoiceResObj As BILL.EINV.DTO.TBTCA.ComRes, ByRef VoucherResultObj As BILL.EINV.DTO.TBTCA.PaperReceiveRes) As %String
{
	s rtn="-1"
	
	s XMLRes=$replace(XMLRes,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
	
	//1.将报文头xml转换为对象
	s InvoiceResObj=##class(BILL.EINV.DTO.TBTCA.ComRes).%New()
	s InvoiceRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(XMLRes, "Invoice", "BILL.EINV.DTO.TBTCA.ComRes", .InvoiceResObj)
	q:InvoiceRtn'="0" rtn
	b ;1
	
	//2.报文体Base64解密
	s OutStream=##class(web.Util.Encryption).Base64Decode(InvoiceResObj.Msg,"UTF8")
	b ;2
	
	//3.将报文体xml转换为对象
	s VoucherResultObj=##class(BILL.EINV.DTO.TBTCA.PaperReceiveRes).%New()
	s VoucherRtn=##class(BILL.EINV.COM.Common).XmlStreamToObj(OutStream, "Voucher", "BILL.EINV.DTO.TBTCA.PaperReceiveRes", .VoucherResultObj) 
	q:VoucherRtn'="0" rtn
	b ;3  VoucherResultObj.ResultCode
	
	if (VoucherResultObj.ResultCode="0000")||(VoucherResultObj.ResultCode=""){		//跟第三方协商确定，如果ResultCode返回0000或者“”,代表交易成功
		s rtn="0"
	}
	
	q rtn
}

/// 功能说明： 旧系统票作废接口（8113）
/// 入参说明: dataStr    --> 入参数据
/// 返 回 值：返回接口文档对应的json格式      
/// 修改履历：guoyunlong   2019-09-26
/// 其    他：w ##class(BILL.EINV.ADP.TBTCA).InvalidOldPaper("","") 
ClassMethod InvalidOldPaper(OldInvStr As %String, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.TBTCA).InvalidOldPaper开始")
	s RtnFlag="-1"
	
	//1.获取授权凭证
	s AccessToken=..InitLogin(InvociePam)
	q:AccessToken="" RtnFlag
	b ;PrintPaper AccessToken
	
	//2.组织退费入参
	s InputReqXml=..CreatInvalidOldPaper(AccessToken,OldInvStr,InvociePam)
	s:InputReqXml="" InvociePam.ErrMsgInfo="组织XML入参发生错误"
	q:InputReqXml="" RtnFlag
	b ;PrintPaper  InputReqXml
	
	//3.调用同步天成HTTP开具接口
	s ResultRtn=##class(BILL.EINV.BI.TBTCA.HTTPRequest).InvoiceRequest(InputReqXml,InvociePam.ObjUPConfig, .InvoiceResXML)
	s:ResultRtn="-9999" InvociePam.ErrMsgInfo="请求异常"
    q:ResultRtn="-9999" RtnFlag
	b ;Invalid InvoiceResXML
	
	//4.对返回结果解密
    s InvoiceResObj=""
    s VoucherResultObj=""
    s RtnFlag=..DecryptionVoucherResult(InvoiceResXML, .InvoiceResObj, .VoucherResultObj)
    i (RtnFlag'="0"){
	    s InvociePam.ErrMsgInfo=VoucherResultObj.ResultMsg
    }
	
	q RtnFlag
}

/// 组织旧系统票作废接口（8113）入参请求XML
ClassMethod CreatInvalidOldPaper(AccessToken, dataStr, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s ComReqObj=##class(BILL.EINV.DTO.TBTCA.ComReq).%New()
	
	//组织报文头
	s MsgNo="8113"		;票据号码初始化
	s ComHeadObj=""
	d ..InvoiceHead(MsgNo,"ZFOLD",AccessToken,InvociePam, .ComHeadObj)
	s ComReqObj.Head=ComHeadObj
	
	//组织报文体
	
	s ObjReq=##class(BILL.EINV.DTO.TBTCA.OldSysInvalidInvPaperReq).%New()
	s ObjReq.BillBatchCode=$p(dataStr,"^",1)			;票据代码
	s ObjReq.BillNo=$p(dataStr,"^",2)					;票据号码
	s ObjReq.InsuranceSettleNo=$p(dataStr,"^",3)		;结算号
	s ObjReq.Reason=$p(dataStr,"^",4)					;作废原因
	s ObjReq.CancellMan=InvociePam.UserDesc				;作废人								
	s ObjReq.CancellTime=##class(BILL.EINV.COM.Common).GetBusDate("","")		;作废时间
	s ObjReq.OperType=$p(dataStr,"^",7)					;操作类型
	
    s VoucherInput=""
	d ObjReq.XMLExportToString(.VoucherInput)     ;生成xml字符串
	s Msg=##class(web.Util.Encryption).Base64Encode(VoucherInput)
	s ComReqObj.Msg=Msg
	
	s ReqInputXml=""
	d ComReqObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
    q ReqInputXml
}

}
