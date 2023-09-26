/// 航天信息电子发票信息
Class BILL.EINV.ADP.HTXXA Extends %RegisteredObject
{

/// 电子发票开具接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).Invoice("","","") 
/// guoyunlong  2021-05-04
ClassMethod Invoice(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	d ##class(BILL.EINV.BL.COM.LogInfoCtl).Info("##class(BILL.EINV.ADP.HXA).Invoice开始")
	s RtnFlag="-1"
	;调用开具之前先调用查询交易查询一下该流水号下有无开票信息
	s RtnFlag=..EInvQuery(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:RtnFlag="0" "0"   ;查询成功后直接Q出去，不在进行开具
	s InputXML=..EInvoiceCom(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputXML="" "-1"   ;组织入参发生错误
	;调用第三方接口
	s OutData=""
	s ErrMsg=""
	s InvoiceRtn=##class(BILL.EINV.BI.HTXXA.HTTPRequest).InvoiceRequest(InputXML,InvociePam.ObjUPConfig,.OutData,.ErrMsg)
	i InvoiceRtn="0" d
	.s InvoiceData=##class(BILL.EINV.DTO.HTXXA.EInvoiceRes).%New()
	.d InvoiceData.XMLDeserialize(.InvoiceData,"EIFeiMakeResponse",OutData)
	.s ObjInvUpDetail.IUDBillBatchCode=InvoiceData.EInvoiceCode   ;票据代码
	.s ObjInvUpDetail.IUDBillBatchNo=InvoiceData.EInvoiceNumber   ;票据号码
	.s ObjInvUpDetail.Xstr2=InvoiceData.SerialNum                 ;票据处理唯一标识
	.s ObjInvUpDetail.Xstr1=InvoiceData.HoldSerialBiz        ;业务流水号
	.;s RtnFlag="0"
	.;开具成功后需要调用查询交易查询开票时间，校验码等数据？？？
	.s RtnFlag=..EInvQuery(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	.i RtnFlag="0" d
	..s RtnFlag="0"
	.else  d
	..s RtnFlag="-1"
	else  d
	.s InvociePam.ErrMsgInfo=ErrMsg
	.s RtnFlag="-1"
	q RtnFlag
}

/// 功能描述：电子发票红冲接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.BSA).Invalid("","","") 
ClassMethod Invalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s RtnFlag="-1"
	s InputXML=..Invalid(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	q:InputXML="" RtnFlag 
	;调用第三方接口
	s OutData=""
	s ErrMsg=""
	s InvalidRtn=##class(BILL.EINV.BI.HTXXA.HTTPRequest).InvoiceRequest(InputXML,InvociePam.ObjUPConfig,.OutData,.ErrMsg)
	i InvalidRtn="0" d
	.s InvalidData=##class(BILL.EINV.DTO.HTXXA.EInvalidRes).%New()
	.d InvalidData.XMLDeserialize(.InvalidData,"EIFeiCancelResponse",OutData)
	.s ObjInvUpDetail.Xstr1=InvalidData.HoldSerialBiz        ;业务流水号
	.s ObjInvUpDetail.Xstr3=InvalidData.BillState 	     ;业务类型
	.;红冲成功后需要调用查询交易查询开票时间，校验码等数据？？？
	.s RtnFlag=..EInvQuery(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)
	.i RtnFlag="0" d
	..s RtnFlag="0"
	.else  d
	..s RtnFlag="-1"
	q RtnFlag
}

/// 组织门诊开具接口外部参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).EInvoiceCom("","","") 
/// guoyunlong  2021-05-04
ClassMethod EInvoiceCom(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	s InvoicecomObj=##class(BILL.EINV.DTO.HTXXA.EInvComData).%New()
	s InvoicecomObj.Sign=""  ;签名值	String	40	必填	SM3算法
	///头文件
	s IFSHeaderObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataHeader).%New()
	s IFSHeaderObj.AppId=""  ;应用id	String	50
	s IFSHeaderObj.AppKey=""  ;应用密钥	String	50
	s IFSHeaderObj.Version="FINEISX1.0"  ;接口版本	String	10	必填	FINEISX1.0
	s IFSHeaderObj.HuCode=""  ;执收单位编码	String	20	必填
	s IFSHeaderObj.Cuscc=""  ;统一社会信用代码	String	30	必填
	s IFSHeaderObj.AuthorizeCode=""   ;执收单位授权码	String	20
	s IFSHeaderObj.IfName="EIFeiMakeRequest"   ;接口业务代码	String	20	必填	参考4.4详情
	s IFSHeaderObj.ReqTime=..GetDateLength()_"000"   ;请求时间	String	13	必填	毫秒级时间戳 1545211544000
	s IFSHeaderObj.ReqSeq=""   ;请求顺序号	String	100
	s InvoicecomObj.IFSHeader=IFSHeaderObj
	///数据接口
	s IFSDATAOBj=##class(BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA).%New()
	s IFSDATAOBj.ZipCode="0"  ;压缩方式	Integer	2	必填	0：不压缩；1：zip压缩
	s IFSDATAOBj.EncryptCode="0"  ;加密方式	Integer	2	必填	0: 非加密1：RSA
	s IFSDATAOBj.CACode="CZBCA"  ;Ca类型	Integer	2	必填	0:CZBCA
	s IFSDATAOBj.FormatCode=""  ;票据类型	String	10	必填	002：门诊票  003：住院票
	s IFSDATAOBj.Content=..EInvoiceComInData(ObjInvUpDetail,ObjInvPrtInfo,InvociePam)   ;业务报文内容	String	不限长	必填	BASE64.encode(GZIP压缩(RSA(业务报文xml明文)))
	s InvoicecomObj.IFSDATA=IFSDATAOBj
	///返回值信息
	s ReturnInfoObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo).%New()         ;返回内容	节点			[1]
	s ReturnInfoObj.ReturnCode=""  ;返回码	String	不限长		返回参数不为200，获取错误信息
	s ReturnInfoObj.ReturnMessage=""  ;返回信息	String	不限长
	s InvoicecomObj.ReturnInfo=""
	
	s ReqInputXml=""
	d InvoicecomObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	q:ReqInputXml="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    ;s ReqInputXml=##class(web.Util.Encryption).Base64Encode(ReqInputXml)
    q ReqInputXml
}

/// 组织门诊开具接口内部参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).EInvoiceComInData("","","") 
/// guoyunlong  2021-05-04
ClassMethod EInvoiceComInData(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	s InvoiceObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceReq).%New()
	s EInvoiceComDataObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComData).%New()
	///头文件
	s HeaderObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComDataHeader).%New()
	s HeaderObj.EInvoiceTag=""  ;电子票据标签	String	8	必填	
	///格式为“财政电子票据标识–监管机构行政区划代码”。其中，财政电子票据标识为“CZ-EI”；区划代码为2位数字(地区为61)
	s HeaderObj.EInvoiceID=""  ;电子票据标识	String	19
	s HeaderObj.Version="1.0"   ;版本	String	[1,5]	必填	固定值，1.0财政电子票据规范版本
    s EInvoiceComDataObj.Header=HeaderObj
    ///电子票据票面信息
    
    s EInvoiceDataObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvData).%New()
    s MainObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMain).%New()
    s MainObj.EInvoiceName=""   ;电子票据名称	String	[1,100]
    s MainObj.EInvoiceCode=""  ;电子票据代码	NString	8
    s MainObj.EInvoiceNumber=""   ;电子票据号码	NString	10
    s MainObj.RandomNumber=""   ;校验码	String	6
    s MainObj.EInvoiceSpecimenCode=""   ;电子票据模版代码	String	10
    s MainObj.SupervisorAreaCode=""   ;电子票据监管机构代码	String	6
    s MainObj.TotalAmount=ObjInvPrtInfo.InvAmt   ;总金额	Currency		必填小数点后需保留2位
    s MainObj.IssueDate=$tr($zd(+$h,3),"-","")      ;开票日期	Date		必填	格式为yyyyMMdd
    s MainObj.IssueTime=$zt($p($h,",",2),1)     ;开票时间	Time		必填	格式为HH:mm:ss如09:29:53
    ///开票单位
    s InvoicingPartyObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainInvParty).%New()
    s InvoicingPartyObj.InvoicingPartyCode=""   ;开票单位代码	String	[1,30]	必填
    s InvoicingPartyObj.InvoicingPartyName=""   ;开票单位名称	String	[1,200]	必填
    s InvoicingPartyObj.RecName=""  ;收款人全称	String	[0,100]		开电子缴款书时填写
    s InvoicingPartyObj.RecAcct=""  ;收款人账号	String	[0,50]		开电子缴款书时填写
    s InvoicingPartyObj.RecOpBk=""   ;收款人开户行	String	[0,100]		开电子缴款书时填写
    s MainObj.InvoicingParty=InvoicingPartyObj
    ;;;交款人信息
    s PayerPartyObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainPayerParty).%New()
    s PayerPartyObj.PayerPartyType="1"  ;交款人类型	String	1	必填	1:个人; 2:单位
    s PayerPartyObj.PayerPartyCode=ObjInvPrtInfo.PatBaseInfo.PatID  ;交款人代码	String	[1,30]		单位采用统一社会信用代码；个人一般为身份证号
    s PayerPartyObj.PayerPartyName=ObjInvPrtInfo.PatBaseInfo.PatName  ;交款人名称	String	[1,100]	必填
    s PayerPartyObj.PayerAcct=""   ;交款人账号	String	[0,50]		开电子缴款书时选填
    s PayerPartyObj.PayerOpBk=""    ;交款人开户行	String	[0,100]		开电子缴款书时选填
    s MainObj.PayerParty=PayerPartyObj
    
    s MainObj.PayMode=""     ;交款方式	String	[0,30]		现金,支付宝,微信,银行卡,银行,转账,其他方式
    s MainObj.BizCode=ObjInvUpDetail.IUDBusNo     ;业务流水号	String	[1,32]	必填	医院内部单张票据唯一编码
    s MainObj.CurrencyType=""  ;货币种类	String	[0,30]
    s MainObj.ExchangeRate=""   ;汇率	Decimal
    s MainObj.Remark=""   ;备注	String	[0,500]
    s MainObj.HandlingPerson=InvociePam.UserDesc   ;开票人	String	[1,20]	必填
    s MainObj.Checker=InvociePam.UserDesc   ;复核人	String	[1,20]
    s MainObj.SupervisorRemark=""   ;财政部门备注	String	[0,500]
   
    ///基本信息扩展
    s MainExtObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainExt).%New()
    s MainExtObj.BusinessNumber=""   ;业务单号	String	[0,32]	必填
    s MainExtObj.BusinessDate=""     ;业务日期	Date		必填	业务发生日期
    s MainExtObj.Gender=ObjInvPrtInfo.PatBaseInfo.Sex     ;性别	String	1	必填	1:男 2：女
    ;医疗类别	String	[1,30]	必填	门诊、急诊、住院等
    s MainExtObj.MedicalType=$case(ObjInvUpDetail.IUDPayAdmType,"OP":"门诊","REG":"门诊","IP":"住院",:"")   
    
    s MainExtObj.OrgType=""      ;医疗机构类型	String	[1,30]	必填	
    s MainExtObj.MedicalInsuranceType=""   ;医保类型	String	[1,30]	必填	有医保则必填写；无医保则填“无”
    s MainExtObj.InsuranceID=""   ;医保编号	String	[1,30]	必填	有医保则必填写；无医保则可“无”
    s MainExtObj.FundPayAmount=""   ;医保统筹基金支付	Currency		必填	有医保则必填写；无医保则填0.00
    s MainExtObj.OtherPayAmount=""   ;其他支付	Currency		必填	有则必填写；无则填0.00
    s MainExtObj.AccountPayAmount="" ;个人账户支付	Currency		必填	有则必填写；无则填0.00
    s MainExtObj.OwnPayAmount="" ;个人现金支付	Currency		必填	有则必填写；无则填0.00
    s MainExtObj.SelfpaymentAmount=""  ;个人自付	Currency		必填	有则必填写；无则填0.00
    s MainExtObj.SelfpaymentCost=""   ;个人自费	Currency		必填	有则必填写；无则填0.00
    s MainExtObj.PatientNumber=ObjInvPrtInfo.PatAdmInfo.AdmNo  ;门诊号	String	[0,30]	*M	门诊票填写
    s MainExtObj.MedicalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate  ;就诊日期	Date		*M	门诊票填写
    s MainExtObj.CaseNumber=ObjInvPrtInfo.PatAdmInfo.MedicalCode  ;病例号	String	[0,50]	*M	住院票填写
    s MainExtObj.HospitalizationNumber=ObjInvPrtInfo.PatAdmInfo.IPNo  ;住院号	String	[0,20]	*M	住院票填写
    s MainExtObj.DepartmentName=ObjInvPrtInfo.PatAdmInfo.DepDesc   ;科别	String	[1,50]	*M	住院票填写
    s MainExtObj.InHospitalDate=ObjInvPrtInfo.PatAdmInfo.AdmDate    ;住院日期	Date		*M	住院票填写
    s MainExtObj.InHospitalDate=ObjInvPrtInfo.PatAdmInfo.OutDate     ;出院日期	Date		*M	住院票填写
    s MainExtObj.PrepayAmount=ObjInvPrtInfo.DepositAmt   ;预缴金额	Currency		*M	住院票填写有则必填写；无则填0.00
    s MainExtObj.RechargeAmount=ObjInvPrtInfo.RecAmt   ;补缴金额	Currency		*M	住院票填写有则必填写；无则填0.00
    s MainExtObj.RefundAmount=ObjInvPrtInfo.RefAmt    ;住院退款	Currency		*M	住院票填写有则必填写；无则填0.00
    s MainExtObj.PrepaidAmount=ObjInvPrtInfo.RefAmt  ;退费金额	Currency		*M	住院票填写有则必填写；无则填0.00
    s MainExtObj.RelatedInvoiceCode=""     ;相关票据代码	String	8		预留扩展字段，开具红票时在此填写原票据代码
    s MainExtObj.RelatedInvoiceNumber=""   ;相关票据号码	String	10		预留扩展字段，开具红票时在此填写原票据代码
    s MainExtObj.PayCode=""   ;缴款码	String	[0,20]		预留扩展字段，开电子缴款书时填写
    s MainObj.MainExt=MainExtObj
    ///开票单位印章
    s MainPartySealObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainPartySeal).%New()
    s MainPartySealObj.SealId=""   ;印章编号	String	32
    s MainPartySealObj.SealName=""   ;印章名称	String	[1,100]
    s MainPartySealObj.SealHash=""   ;印章Hash	String	[1,256]
    s MainObj.InvoicingPartySeal=MainPartySealObj
    s EInvoiceDataObj.Main=MainObj  ; 票面基本信息
    ///票面明细信息
    s DetailsObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetails).%New()
    for Index=1:1:ObjInvPrtInfo.InvCateInfo.Size  d
    .s DetailItemObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailItem).%New()
    .s DetailItemObj.ItemCode=ObjInvPrtInfo.InvCateInfo.GetAt(Index).Code   ;项目编码	String	[1,30]	必填
    .s DetailItemObj.ItemName=ObjInvPrtInfo.InvCateInfo.GetAt(Index).Desc  ;项目名称	String	[1,100]	必填	参考备注表1，可按医疗票据重新制定项目名称
    .s DetailItemObj.ItemAmount=ObjInvPrtInfo.InvCateInfo.GetAt(Index).Amt  ;金额	Currency		必填
    .s DetailItemObj.ItemUnit=""    ;单位	String	[1,30]
    .s DetailItemObj.ItemQuantity="1"   ;数量	Integer
    .s DetailItemObj.ItemStd=""    ;标准	Currency
    .s DetailItemObj.ItemRemark=""  ;项目备注	String	[0,200]
    .d DetailsObj.Item.Insert(DetailItemObj)
    s EInvoiceDataObj.Details=DetailsObj
    ///明细信息扩展
    s DetailItemExtObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailItemExt).%New()
    s DetailItemExtObj.ItemDetailName=""    ;项目明细	String	[0,200]	
    ///辅助明细信息
    s AuxDetailObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataAuxDetails).%New()
    ///辅助项目
    for DetailIndex=1:1:ObjInvPrtInfo.InvItmDetInfo.Size  d
    .s DetailAuxItemObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailAuxItem).%New()
    .s DetailAuxItemObj.AuxItemRelatedCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).CateCode   ;对应项目编码	String	[1,30]	必填
    .s DetailAuxItemObj.AuxItemRelatedName=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).CateDesc   ;对应项目名称	String	[1,100]	必填
    .s DetailAuxItemObj.AuxItemCode=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).TarCode  ;收费明细项目编码	NString	[0,30]	必填
    .s DetailAuxItemObj.AuxItemName=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).TarDesc    ;收费明细项目名称	String	[1,100]	必填
    .s DetailAuxItemObj.AuxItemQuantity=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).Qty    ;收费明细项目数量	Decimal
    .s DetailAuxItemObj.AuxItemUnit=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).Unit   ;收费明细项目单位	String	[0,30]
    .s DetailAuxItemObj.AuxItemStd=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).Spec    ;收费明细项目标准	Currency4
    .s DetailAuxItemObj.AuxItemAmount=ObjInvPrtInfo.InvItmDetInfo.GetAt(DetailIndex).Amt   ;收费明细项目金额	Currency4		必填
    .s DetailAuxItemObj.AuxItemRemark=""   ;收费明细项目备注	String	[0,100]
    .d AuxDetailObj.AuxItem.Insert(DetailAuxItemObj)
    s EInvoiceDataObj.AuxDetails=AuxDetailObj

	s EInvoiceComDataObj.EInvoiceData=EInvoiceDataObj
	
	///电子票据数字签名
	s EInvoiceSignatureObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceEInvoiceSignature).%New()
	s SignatureObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceSignature).%New()
	s SignedInfoobj=##class(BILL.EINV.DTO.HTXXA.EInvoiceSignedInfo).%New()
	s SignedInfoobj.Reference=""   ;签名原文引用	String 
	s SignedInfoobj.SignatureAlgorithm=""   ;签名算法	String
	s SignedInfoobj.SignatureFormat=""   ;签名格式类型	String
	s SignatureObj.SignedInfo=SignedInfoobj
	s SignatureObj.SignatureTime=""   ;签名时间	UTCDateTime
	s SignatureObj.SignatureValue=""   ;签名值	Base64Binary
	s KeyInfoobj=##class(BILL.EINV.DTO.HTXXA.EInvoiceKeyInfo).%New()
	s KeyInfoobj.SerialNumber=""   ;证书编号	String 	
	s KeyInfoobj.X509IssuerName=""   ;X.509证书颁发者名称	String
	s SignatureObj.KeyInfo=KeyInfoobj    ;证书信息	节点
	s EInvoiceSignatureObj.Signature=SignatureObj
	s EInvoiceComDataObj.EInvoiceSignature=EInvoiceSignatureObj
	s InvoiceObj.EInvoice=EInvoiceComDataObj ;

	///财政电子票据数据拓展项
	s EInvoiceComDataExtObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComDataExt).%New()
	s EInvoiceComDataExtObj.PlaceCode=InvociePam.UserCode   ;开票点	String	[0,30]	必填	开票点信息
	s EInvoiceComPayerPartyExtObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComPayerPartyExt).%New()
	s EInvoiceComPayerPartyExtObj.SickId=ObjInvPrtInfo.PatBaseInfo.PAPMINO  ;病人信息ID	String	[1,32]	必填	能唯一标识病人
	s EInvoiceComPayerPartyExtObj.PayerPhoneNo=ObjInvPrtInfo.PatBaseInfo.Mobphone    ;交款人手机号码	NString
	///卡信息
	s EInvoiceComDataExtObj.PayerPartyExt=EInvoiceComPayerPartyExtObj  ;
	s CardInfosObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComCardInfos).%New()
	s CardInfosObj.CardType=ObjInvPrtInfo.PatBaseInfo.CardType   ;就诊卡类型	Integer	2	必填	0:医院就诊卡1：市民卡2：健康卡3：社保卡4：身份证
	s CardInfosObj.CardNum=ObjInvPrtInfo.PatBaseInfo.CardNo    ;就诊卡卡号	String	[1,30]	必填	全小写
	s CardInfosObj.Remark=""     ;备注	String	[1,100]
	s EInvoiceComPayerPartyExtObj.CardInfos=CardInfosObj    ;就诊卡片信息	节点
	///签名值扩展节点
	s EInvoiceComSignatureExtObj=##class(BILL.EINV.DTO.HTXXA.EInvoiceComSignatureExt).%New()
	s EInvoiceComSignatureExtObj.CryptographyStan=""   ;公开密钥密码学标准
	
	s EInvoiceComDataExtObj.EInvoiceSignatureExt=EInvoiceComSignatureExtObj
	s EInvoiceComDataExtObj.WindowNo=""   ;窗口号	String	[0,5]	必填
	s InvoiceObj.EInvoiceExt=EInvoiceComDataExtObj
	
	s ReqInputXml=""
	d InvoiceObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	q:ReqInputXml="" rtn
	q ReqInputXml
}

/// 组织门诊红冲接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).EInvalid("","","") 
/// guoyunlong  2021-05-04
ClassMethod EInvalid(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	
	;HoldSerialBiz   ;业务流水号	String	[1,32]	必填	单位内唯一业务流水号
	s ReqXML="<EIFeiCancelRequest><HoldSerialBiz>"_ObjInvUpDetail.IUDBusNo_"</HoldSerialBiz>"
	s ReqXML=ReqXML_"<PlaceCode>"_InvociePam.UserCode_"</PlaceCode>"     ///开票点编码	NString	[0,20]	必填
	s ReqXML=ReqXML_"<CancelDate>"_$tr($zd(+$h,3),"-","")_$zt($p($h,",",2),1)_"</CancelDate>"   ///冲红时间	DateTime		必填
	s ReqXML=ReqXML_"<BillState>"_3_"</BillState>"   ///业务类型	Integer	1	必填	3：电子票据冲红
	s ReqXML=ReqXML_"<Reason>"_"退费"_"</Reason>"      ///冲红原因	String	[1,50]	必填	冲红原因
	s ReqXML=ReqXML_"<IsLost>"_0_"</IsLost>"      ///是否遗失	Boolean
	s ReqXML=ReqXML_"</EIFeiCancelRequest>"
	
	s InvoicecomObj=##class(BILL.EINV.DTO.HTXXA.EInvComData).%New()
	s InvoicecomObj.Sign=""  ;签名值	String	40	必填	SM3算法
	///头文件
	s IFSHeaderObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataHeader).%New()
	s IFSHeaderObj.AppId=""  ;应用id	String	50
	s IFSHeaderObj.AppKey=""  ;应用密钥	String	50
	s IFSHeaderObj.Version="FINEISX1.0"  ;接口版本	String	10	必填	FINEISX1.0
	s IFSHeaderObj.HuCode=""  ;执收单位编码	String	20	必填
	s IFSHeaderObj.Cuscc=""  ;统一社会信用代码	String	30	必填
	s IFSHeaderObj.AuthorizeCode=""   ;执收单位授权码	String	20
	s IFSHeaderObj.IfName="EIFeiCancelRequest"   ;接口业务代码	String	20	必填	参考4.4详情
	s IFSHeaderObj.ReqTime=..GetDateLength()_"000"   ;请求时间	String	13	必填	毫秒级时间戳 1545211544000
	s IFSHeaderObj.ReqSeq=""   ;请求顺序号	String	100
	s InvoicecomObj.IFSHeader=IFSHeaderObj
	///数据接口
	s IFSDATAOBj=##class(BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA).%New()
	s IFSDATAOBj.ZipCode="0"  ;压缩方式	Integer	2	必填	0：不压缩；1：zip压缩
	s IFSDATAOBj.EncryptCode="0"  ;加密方式	Integer	2	必填	0: 非加密1：RSA
	s IFSDATAOBj.CACode="CZBCA"  ;Ca类型	Integer	2	必填	0:CZBCA
	s IFSDATAOBj.FormatCode=""  ;票据类型	String	10	必填	002：门诊票  003：住院票
	s IFSDATAOBj.Content=ReqXML  ;业务报文内容	String	不限长	必填	BASE64.encode(GZIP压缩(RSA(业务报文xml明文)))
	s InvoicecomObj.IFSDATA=IFSDATAOBj
	///返回值信息
	s ReturnInfoObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo).%New()         ;返回内容	节点			[1]
	s ReturnInfoObj.ReturnCode=""  ;返回码	String	不限长		返回参数不为200，获取错误信息
	s ReturnInfoObj.ReturnMessage=""  ;返回信息	String	不限长
	s InvoicecomObj.ReturnInfo=""
	s ReqInputXml=""
	d InvoicecomObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	q:ReqInputXml="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    ;s ReqInputXml=##class(web.Util.Encryption).Base64Encode(ReqInputXml)
	
	q ReqInputXml
}

/// 电子票据查询接口参数
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).EInvQuery("","","") 
/// guoyunlong  2021-05-04
ClassMethod EInvQuery(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	;HoldSerialBiz   ;业务流水号	String	[1,32]	必填	单位内唯一业务流水号
	s ReqXML="<EIFeiBasicQueryRequest><HoldSerialBiz>"_ObjInvUpDetail.IUDBusNo_"</HoldSerialBiz></EIFeiBasicQueryRequest>"
	
	s InvoicecomObj=##class(BILL.EINV.DTO.HTXXA.EInvComData).%New()
	s InvoicecomObj.Sign=""  ;签名值	String	40	必填	SM3算法
	///头文件
	s IFSHeaderObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataHeader).%New()
	s IFSHeaderObj.AppId=""  ;应用id	String	50
	s IFSHeaderObj.AppKey=""  ;应用密钥	String	50
	s IFSHeaderObj.Version="FINEISX1.0"  ;接口版本	String	10	必填	FINEISX1.0
	s IFSHeaderObj.HuCode=""  ;执收单位编码	String	20	必填
	s IFSHeaderObj.Cuscc=""  ;统一社会信用代码	String	30	必填
	s IFSHeaderObj.AuthorizeCode=""   ;执收单位授权码	String	20
	s IFSHeaderObj.IfName="EIFeiBasicQueryRequest"   ;接口业务代码	String	20	必填	参考4.4详情
	s IFSHeaderObj.ReqTime=..GetDateLength()_"000"   ;请求时间	String	13	必填	毫秒级时间戳 1545211544000
	s IFSHeaderObj.ReqSeq=""   ;请求顺序号	String	100
	s InvoicecomObj.IFSHeader=IFSHeaderObj
	///数据接口
	s IFSDATAOBj=##class(BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA).%New()
	s IFSDATAOBj.ZipCode="0"  ;压缩方式	Integer	2	必填	0：不压缩；1：zip压缩
	s IFSDATAOBj.EncryptCode="0"  ;加密方式	Integer	2	必填	0: 非加密1：RSA
	s IFSDATAOBj.CACode="CZBCA"  ;Ca类型	Integer	2	必填	0:CZBCA
	s IFSDATAOBj.FormatCode=""  ;票据类型	String	10	必填	002：门诊票  003：住院票
	s IFSDATAOBj.Content=ReqXML  ;业务报文内容	String	不限长	必填	BASE64.encode(GZIP压缩(RSA(业务报文xml明文)))
	s InvoicecomObj.IFSDATA=IFSDATAOBj
	///返回值信息
	s ReturnInfoObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo).%New()         ;返回内容	节点			[1]
	s ReturnInfoObj.ReturnCode=""  ;返回码	String	不限长		返回参数不为200，获取错误信息
	s ReturnInfoObj.ReturnMessage=""  ;返回信息	String	不限长
	s InvoicecomObj.ReturnInfo=""
	s ReqInputXml=""
	d InvoicecomObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	q:ReqInputXml="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    ;s ReqInputXml=##class(web.Util.Encryption).Base64Encode(ReqInputXml)
	;调用第三方查询接口开始查询
	s OutData=##class(BILL.EINV.DTO.HTXXA.EInvQueryRes).%New()
	s ErrMsg=""
	s QueryRtn=##class(BILL.EINV.BI.HTXXA.HTTPRequest).InvoiceRequest(ReqInputXml,InvociePam.ObjUPConfig,.OutData,.ErrMsg)
	//对返回结果进行解密并保存
	i (QueryRtn="0")  d
	.Do OutData.XMLNodeDeserialize(.OutData,"EIFeiBasicQueryResponse",OutData)
	.s ObjInvUpDetail.IUDBusNo=OutData.HoldSerialBiz   ;业务流水号
	.s ObjInvUpDetail.IUDBillBatchStatus=OutData.BillCurStatus			;状态
    .s ObjInvUpDetail.IUDBillBatchCode=OutData.EInvoiceCode   ;票据代码
    .s ObjInvUpDetail.IUDBillBatchNo=OutData.EInvoiceNumber   ;票据号码
    .s ObjInvUpDetail.IUDCheckCode=OutData.RandomNumber      ;校验码
    .s CreatDate=OutData.IssueDateTime
    .s Date=$zdh($e(CreatDate,1,4)_"-"_$e(CreatDate,5,6)_"-"_$e(CreatDate,7,8),3)
    .s Time=$zth($e(CreatDate,9,*),3)
    .s ObjInvUpDetail.IUDCreatDate=Date     ;开具日期
    .s ObjInvUpDetail.IUDCreatTime=Time     ;开具时间
    .s ObjInvUpDetail.Xstr1=OutData.WindowNo     ;窗口号
	.s ObjInvUpDetail.IUDUplodeFlag="Y"                                 ;上传标志 Y:上传成功，N:上传失败
	.s ObjInvUpDetail.IUDResultMeg="上传成功"   						;查询状态 信息是否成功
	.s ObjInvUpDetail.EInvFlg="I"										;发票状态
	.i ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode'=""  d
	..s ObjInvUpDetail.IUDResultMeg="红冲成功"   						;查询状态 信息是否成功
	..s ObjInvUpDetail.EInvFlg="S"										;发票状态
	.s rtn="0"
	else  d
	.s InvociePam.ErrMsgInfo=ErrMsg
	.s rtn="-1"
	q rtn
}

/// 6.4	电子票据单张下载请求报文
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).EInvDownLoadOnly("","","") 
/// guoyunlong  2021-05-04
ClassMethod EInvDownLoadOnly(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	s ReqXML="<EIFeiBillFileLoadRequest><AgencyCode>"_""_"</AgencyCode>"   ;单位内唯一业务流水号开票单位代码，一般采用统一社会信用代码
	s ReqXML=ReqXML_"<AgencyName>"_""_"</AgencyName>"    ;开票单位名称
	s ReqXML=ReqXML_"<EInvoiceCode>"_ObjInvUpDetail.IUDBillBatchCode_"</EInvoiceCode>"    ;电子票据代码
	s ReqXML=ReqXML_"<EInvoiceNumber>"_ObjInvUpDetail.IUDBillBatchNo_"</EInvoiceNumber>"       ;电子票据号码
	s ReqXML=ReqXML_"<RandomNumber>"_ObjInvUpDetail.IUDCheckCode_"</RandomNumber>"      ;校验码
	s ReqXML=ReqXML_"</EIFeiBillFileLoadRequest>"
	s InvoicecomObj=##class(BILL.EINV.DTO.HTXXA.EInvComData).%New()
	s InvoicecomObj.Sign=""  ;签名值	String	40	必填	SM3算法
	///头文件
	s IFSHeaderObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataHeader).%New()
	s IFSHeaderObj.AppId=""  ;应用id	String	50
	s IFSHeaderObj.AppKey=""  ;应用密钥	String	50
	s IFSHeaderObj.Version="FINEISX1.0"  ;接口版本	String	10	必填	FINEISX1.0
	s IFSHeaderObj.HuCode=""  ;执收单位编码	String	20	必填
	s IFSHeaderObj.Cuscc=""  ;统一社会信用代码	String	30	必填
	s IFSHeaderObj.AuthorizeCode=""   ;执收单位授权码	String	20
	s IFSHeaderObj.IfName="EIFeiBasicQueryRequest"   ;接口业务代码	String	20	必填	参考4.4详情
	s IFSHeaderObj.ReqTime=..GetDateLength()_"000"   ;请求时间	String	13	必填	毫秒级时间戳 1545211544000
	s IFSHeaderObj.ReqSeq=""   ;请求顺序号	String	100
	s InvoicecomObj.IFSHeader=IFSHeaderObj
	///数据接口
	s IFSDATAOBj=##class(BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA).%New()
	s IFSDATAOBj.ZipCode="0"  ;压缩方式	Integer	2	必填	0：不压缩；1：zip压缩
	s IFSDATAOBj.EncryptCode="0"  ;加密方式	Integer	2	必填	0: 非加密1：RSA
	s IFSDATAOBj.CACode="CZBCA"  ;Ca类型	Integer	2	必填	0:CZBCA
	s IFSDATAOBj.FormatCode=""  ;票据类型	String	10	必填	002：门诊票  003：住院票
	s IFSDATAOBj.Content=ReqXML  ;业务报文内容	String	不限长	必填	BASE64.encode(GZIP压缩(RSA(业务报文xml明文)))
	s InvoicecomObj.IFSDATA=IFSDATAOBj
	///返回值信息
	s ReturnInfoObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo).%New()         ;返回内容	节点			[1]
	s ReturnInfoObj.ReturnCode=""  ;返回码	String	不限长		返回参数不为200，获取错误信息
	s ReturnInfoObj.ReturnMessage=""  ;返回信息	String	不限长
	s InvoicecomObj.ReturnInfo=""
	s ReqInputXml=""
	d InvoicecomObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	q:ReqInputXml="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    ;s ReqInputXml=##class(web.Util.Encryption).Base64Encode(ReqInputXml)
	s OutData=""
	s ErrMsg=""
	s QueryRtn=##class(BILL.EINV.BI.HTXXA.HTTPRequest).InvoiceRequest(ReqInputXml,InvociePam.ObjUPConfig,.OutData,.ErrMsg)
	//对返回结果进行解密并保存
	s tDocument="",	tRes=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(OutData, .tDocument)
	i (QueryRtn="0")  d
    .set tSC=tDocument.EvaluateExpression("/EIFeiBillFileLoadResponse/ReturnCode","text()",.tRes)	
	.if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")) d
	..set fieldValue=tRes.GetAt(1).Value
	..set RtnCode=$tr(fieldValue,$c(0),"")
	.s rtn="0^"_RtnCode
	else  d
	.s InvociePam.ErrMsgInfo=ErrMsg
	.s rtn="-1^"_ErrMsg
	q rtn
}

/// 6.5	换开纸质票据接口
/// 入参说明: ObjInvUpDetail    --> 交易对象
///           ObjInvPrtInfo    	--> 发票对象
///           InvociePam  		--> 其它对象(包括电子票据入参属性,扩展字段属性等)
/// 返 回 值：成功标志(0 成功 其他值代表失败) 
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).EInvDownLoadOnly("","","") 
/// guoyunlong  2021-05-04
ClassMethod PrintPaper(ObjInvUpDetail As BILL.EINV.DTO.COM.InvUpDetailInfo, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam) As %String
{
	s rtn="-1"
	s ReqXML="<EIFeiMakePaperRequest><PlaceCode>"_InvociePam.UserCode_"</PlaceCode>"   ;开票点编码
	s ReqXML=ReqXML_"<EInvoiceCode>"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchCode_"</EInvoiceCode>"    ;电子票据代码
	s ReqXML=ReqXML_"<EInvoiceNumber>"_ObjInvUpDetail.OriInvUpDetail.IUDBillBatchNo_"</EInvoiceNumber>"    ;电子票据号码
	s ReqXML=ReqXML_"<PaperInvoiceCode>"_InvociePam.pBillBatchCode_"</PaperInvoiceCode>"      ;纸质票据代码
	s ReqXML=ReqXML_"<PaperInvoiceNumber>"_InvociePam.pBillNo_"</PaperInvoiceNumber>"      ;纸质票据号码
	s ReqXML=ReqXML_"<Reprint>"_"0"_"</Reprint>"      ;是否重打
	s ReqXML=ReqXML_"</EIFeiMakePaperRequest>"
	s InvoicecomObj=##class(BILL.EINV.DTO.HTXXA.EInvComData).%New()
	s InvoicecomObj.Sign=""  ;签名值	String	40	必填	SM3算法
	///头文件
	s IFSHeaderObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataHeader).%New()
	s IFSHeaderObj.AppId=""  ;应用id	String	50
	s IFSHeaderObj.AppKey=""  ;应用密钥	String	50
	s IFSHeaderObj.Version="FINEISX1.0"  ;接口版本	String	10	必填	FINEISX1.0
	s IFSHeaderObj.HuCode=""  ;执收单位编码	String	20	必填
	s IFSHeaderObj.Cuscc=""  ;统一社会信用代码	String	30	必填
	s IFSHeaderObj.AuthorizeCode=""   ;执收单位授权码	String	20
	s IFSHeaderObj.IfName="EIFeiBasicQueryRequest"   ;接口业务代码	String	20	必填	参考4.4详情
	s IFSHeaderObj.ReqTime=..GetDateLength()_"000"   ;请求时间	String	13	必填	毫秒级时间戳 1545211544000
	s IFSHeaderObj.ReqSeq=""   ;请求顺序号	String	100
	s InvoicecomObj.IFSHeader=IFSHeaderObj
	///数据接口
	s IFSDATAOBj=##class(BILL.EINV.DTO.HTXXA.EInvComDataIFSDATA).%New()
	s IFSDATAOBj.ZipCode="0"  ;压缩方式	Integer	2	必填	0：不压缩；1：zip压缩
	s IFSDATAOBj.EncryptCode="0"  ;加密方式	Integer	2	必填	0: 非加密1：RSA
	s IFSDATAOBj.CACode="CZBCA"  ;Ca类型	Integer	2	必填	0:CZBCA
	s IFSDATAOBj.FormatCode=""  ;票据类型	String	10	必填	002：门诊票  003：住院票
	s IFSDATAOBj.Content=ReqXML  ;业务报文内容	String	不限长	必填	BASE64.encode(GZIP压缩(RSA(业务报文xml明文)))
	s InvoicecomObj.IFSDATA=IFSDATAOBj
	///返回值信息
	s ReturnInfoObj=##class(BILL.EINV.DTO.HTXXA.EInvComDataReturnInfo).%New()         ;返回内容	节点			[1]
	s ReturnInfoObj.ReturnCode=""  ;返回码	String	不限长		返回参数不为200，获取错误信息
	s ReturnInfoObj.ReturnMessage=""  ;返回信息	String	不限长
	s InvoicecomObj.ReturnInfo=""
	s ReqInputXml=""
	d InvoicecomObj.XMLExportToString(.ReqInputXml)     ;生成xml字符串
	q:ReqInputXml="" rtn
	;s InputPamStream=..GetXMLTitle()_InputPamStream     ;加上xml文件头数据
    b ;xml
    ;s ReqInputXml=##class(web.Util.Encryption).Base64Encode(ReqInputXml)
	s OutData=""
	s ErrMsg=""
	s QueryRtn=##class(BILL.EINV.BI.HTXXA.HTTPRequest).InvoiceRequest(ReqInputXml,InvociePam.ObjUPConfig,.OutData,.ErrMsg)
	//对返回结果进行解密并保存
	s tDocument="",	tRes=""
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(OutData, .tDocument)
	i (QueryRtn="0")  d
	.s rtn="0"
	else  d
	.s InvociePam.ErrMsgInfo=ErrMsg
	.s rtn="-1^"_ErrMsg
	q rtn
}

/// /获取时间戳
/// 其    他：w ##class(BILL.EINV.ADP.HTXXA).GetDateLength()
ClassMethod GetDateLength() As %String
{
	q +$h*86400+$p($h,",",2)-4070937600
}

}
