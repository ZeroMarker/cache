Include (%callout, %occSAX, %occXSLT)

/// 给第三方提供电子票据纸质换开功能
Class BILL.EINV.BL.EInvLogicZZJ Extends %RegisteredObject
{

/// 功能说明：获取病人有效的电子票据信息
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.EInvDetailInfoReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：调用获取病人已开具成功列表数据(格式为XML字符流)
/// 其他
/// w ##class(BILL.EINV.BL.EInvLogicZZJ).GetEInvInfoList("<EINVReq><StaDate>2019-11-05</StaDate><EndDate>2019-11-05</EndDate><PrtInvType>PR</PrtInvType><PatID>360428199108292916</PatID><CardNo>9</CardNo><BillBatchCode></BillBatchCode><BillBatchNo></BillBatchNo><Type>1</Type></EINVReq>")
ClassMethod GetEInvInfoList(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	s InputPam=..StringToStream(InputPam)
	
	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.EInvDetailInfoReq).%New()
	s PamRtnFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.EInvDetailInfoReq", .ObjReq)
	q:PamRtnFlg'="0" ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[GetEInvInfoList]的入参解析失败")

	//2.业务入参验证
	s ErrMsg=""
	s CheckRtnFlg=..CheckEInvInfoListPam(ObjReq, .ErrMsg)
	q:CheckRtnFlg'="0" ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)

	//3.获取病人票据信息
	s ObjRes=##class(BILL.EINV.DTO.ZZJ.EInvDetailInfoRes).%New()
	s EInvRtn=##class(BILL.EINV.BL.COM.Common).GetInvDetailInfo(ObjReq, .ObjRes, .ErrMsg)
	q:EInvRtn'="0" ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)

	//4.调用Adp层的方法 组织第三方获取电子票据信息XML字符流
	s XMLReq=""
	s AdpFlag=##class(BILL.EINV.ADP.ZZJ).SetEInvUpDetailInfo(ObjReq, ObjRes, .XMLReq)
	q:AdpFlag'="0" ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "组织电子票据XML失败")

	q XMLReq
}

/// 功能说明：验证组织挂号数据的参数是否正确
ClassMethod CheckEInvInfoListPam(ObjReq As BILL.EINV.DTO.ZZJ.EInvDetailInfoReq, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="0"
	
	//入参验证
	if (ObjReq.Type=""){
		s RtnFlg="-1"
		s ErrMsg="获取数据类型不能为空"
	}
	
	q RtnFlg
}

/// 功能说明：获取HIS当前纸质票据可用号码
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.PaperBillNoReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：(格式为XML字符流)
/// 其他 w ##class(BILL.EINV.BL.EInvLogicZZJ).GetHISPaperBillNo("<EINVReq><UserID>7</UserID><PrtInvType>PO</PrtInvType></EINVReq>")
ClassMethod GetHISPaperBillNo(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	//将字符串转换为字符流
	s InputPam=..StringToStream(InputPam)

	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.PaperBillNoReq).%New()
	s PamRtnFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.PaperBillNoReq", .ObjReq)
	q:PamRtnFlg'="0" ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[GetHISPaperBillNo]的入参解析失败")
	
	//2.业务入参验证
	s ErrMsg=""
	s CheckRtnFlg=..CheckHISPaperBillNoPam(ObjReq, .ErrMsg)
	q:(CheckRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//3.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "获取电子票据服务的全局配置失败.")
	
	//4.获取当前纸质票据可用号码
	s InputData=ObjReq.UserID_"^"_ObjReq.PrtInvType
	s PaperInfo=##class(BILL.EINV.BL.EInvoiceLogic).GetPaperBillNo(InputData)
	s ErrCode=$p(PaperInfo,"^",1)
	s ErrMsg=$p(PaperInfo,"^",2)
	q:(ErrCode=-1) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//5.调用Adp层的方法 组织第三方XML字符流
	s XMLReq=""
	s pBillBatchCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("LogicIUDTypeCon"_ObjConfig.FactoryCode, ObjReq.PrtInvType, 5)   //票据代码
	q:(pBillBatchCode="") ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "票据类型对照未在电子票据字典中维护.")
	
	s InputData=pBillBatchCode_"^"_PaperInfo
	s AdpFlag=##class(BILL.EINV.ADP.ZZJ).SetPaperBillNoInfo(ObjReq, InputData, .XMLReq)
	q:(AdpFlag'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "组织电子票据XML失败")
	
	q XMLReq
}

/// 功能说明：验证获取HIS当前纸质票据可用号码的参数是否正确
ClassMethod CheckHISPaperBillNoPam(ObjReq As BILL.EINV.DTO.ZZJ.PaperBillNoReq, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="0"
	
	//入参验证
	i (ObjReq.UserID="") d
	.s RtnFlg="-1"
	.s ErrMsg="操作员ID不能为空."
	
	i (ObjReq.PrtInvType="") d
	.s RtnFlg="-1"  
	.s ErrMsg="票据类型不能为空."
	
	q RtnFlg
}

/// 功能说明：换开纸质票据
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.PrintPaperReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：(格式为XML字符流)
/// 其他 w ##class(BILL.EINV.BL.EInvLogicZZJ).PrintPaper("<EINVReq><PayAdmType>OP</PayAdmType><HISPrtRowID>6839188</HISPrtRowID><UserID>7</UserID><GroupID></GroupID><CTLocID></CTLocID><HospitalID></HospitalID><pBillBatchCode>31101</pBillBatchCode><pBillNo>4311304176</pBillNo></EINVReq>")
ClassMethod PrintPaper(InputPam As %GlobalCharacterStream, PathCode As %String = "PrintPaper") As %GlobalCharacterStream
{
	//将字符串转换为字符流
	s InputPam=..StringToStream(InputPam)
	
	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.PrintPaperReq).%New()
	s PamRtnFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.PrintPaperReq", .ObjReq)
	q:(PamRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[PrintPaper]的入参解析失败")
	
	//2.业务入参验证
	s ErrMsg=""
	s CheckRtnFlg=..CheckPrintPaperPam(ObjReq, .ErrMsg)
	q:(CheckRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//3.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig(ObjReq.HospitalID, .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "获取电子票据服务的全局配置失败.")

	//4.换开纸质票据
	s ExpStr=ObjReq.UserID_"^"_ObjReq.GroupID_"^"_ObjReq.CTLocID_"^"_ObjReq.HospitalID_"^"_ObjReq.pBillBatchCode_"^"_ObjReq.pBillNo
	s RtnStr=##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill(ObjReq.PayAdmType, ObjReq.HISPrtRowID, "", PathCode, ExpStr)
	s ErrCode=$p(RtnStr,"^",1)
	s ErrMsg=$p(RtnStr,"^",2)
	q:(ErrCode'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//4.换开成功后更新发放表当前可用票号
	s PrtType=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("BusinessToPrtInvType","P_"_ObjReq.PayAdmType, 5)   //票据代码
	q:(PrtType="") ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "票据类型对照未在电子票据字典中维护.")
	
	s InputData=ObjReq.UserID_"^"_ObjReq.pBillNo_"^"_PrtType
	s UpdateFlag=##class(BILL.EINV.BL.EInvoiceLogic).UpdateInvoice(InputData)
	q:(UpdateFlag<0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "换开成功,但更新发放表当前可用票号失败.")
	
	//4.组织第三方XML字符流
	s XMLReq=##class(BILL.EINV.COM.Common).BuildComOutStream("0", "成功")

	q XMLReq
}

/// 功能说明：重新换开纸质票据
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.PrintPaperReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：(格式为XML字符流)
/// 其他 w ##class(BILL.EINV.BL.EInvLogicZZJ).RePrintPaper("")
ClassMethod RePrintPaper(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	q ##class(BILL.EINV.BL.EInvLogicZZJ).PrintPaper(InputPam,"RePrintPaper")
}

/// 功能说明：验证换开纸质票据的参数是否正确
ClassMethod CheckPrintPaperPam(ObjReq As BILL.EINV.DTO.ZZJ.PrintPaperReq, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="0"
	
	//入参验证
	s:(ObjReq.UserID="") RtnFlg="-1",ErrMsg="操作员ID不能为空."
	q:(RtnFlg="-1") RtnFlg
	s:(ObjReq.HISPrtRowID="") RtnFlg="-1",ErrMsg="发票ID不能为空."
	q:(RtnFlg="-1") RtnFlg
	s:(ObjReq.PayAdmType="") RtnFlg="-1",ErrMsg="业务类型不能为空."
	q:(RtnFlg="-1") RtnFlg
	s:(ObjReq.pBillBatchCode="") RtnFlg="-1",ErrMsg="纸质票据代码不能为空."
	q:(RtnFlg="-1") RtnFlg
	s:(ObjReq.pBillNo="") RtnFlg="-1",ErrMsg="纸质票据号码不能为空."
	q:(RtnFlg="-1") RtnFlg
	
	q RtnFlg
}

/// 功能说明：空白纸质票据作废
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.InvalidBlankBillNoReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：(格式为XML字符流)
/// 其他   w ##class(BILL.EINV.BL.EInvLogicZZJ).InvalidBlankBillNo("<EINVReq><UserID>7</UserID><GroupDr></GroupDr><PrtInvType>PO</PrtInvType><pBillNoStart>4311304190</pBillNoStart><pBillNoEnd>4311304191</pBillNoEnd><number>2</number><Reason>票据不完整</Reason></EINVReq>")
ClassMethod InvalidBlankBillNo(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	//将字符串转换为字符流
	s InputPam=..StringToStream(InputPam)
	
	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.InvalidBlankBillNoReq).%New()
	s PamRtnFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.InvalidBlankBillNoReq", .ObjReq)
	q:(PamRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[InvalidBlankBillNo]的入参解析失败")

	//2.业务入参验证
	s ErrMsg=""
	s CheckRtnFlg=..CheckInvalidBillNoPam(ObjReq, .ErrMsg)
	q:(CheckRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//3.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=1) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "获取电子发票服务配置失败.")
	
	//4.根据票据类型获取第三方纸质票据代码
	s pBillBatchCode=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("LogicIUDTypeCon"_ObjConfig.FactoryCode, ObjReq.PrtInvType, 5)   //票据代码
	q:(pBillBatchCode="") ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "票据类型对照未在电子票据字典中维护.")
	
	//5.空白纸质票据作废(跳号)
	s InputData=ObjReq.UserID_"^"_ObjReq.GroupDr_"^"_ObjReq.pBillNoStart_"^"_ObjReq.Reason_"^"_ObjReq.pBillNoEnd_"^"_ObjReq.number_"^^^^"_ObjReq.PrtInvType
	s RtnStr=##class(BILL.EINV.BL.EInvoiceLogic).ValidPaper(InputData, pBillBatchCode)
	s ErrCode=$p(RtnStr,"^",1)
	s ErrMsg=$p(RtnStr,"^",2)
	q:(ErrCode'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//6.组织第三方XML字符流
	s XMLReq=##class(BILL.EINV.COM.Common).BuildComOutStream("0", "成功")
	
	q XMLReq
}

/// 功能说明：验证空白纸质票据作废的参数是否正确
ClassMethod CheckInvalidBillNoPam(ObjReq As BILL.EINV.DTO.ZZJ.PrintPaperReq, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="0"
	
	//入参验证
	s:ObjReq.UserID="" RtnFlg="-1",ErrMsg="操作员ID不能为空."
	q:RtnFlg="-1" RtnFlg
	//s:ObjReq.GroupDr="" RtnFlg="-1",ErrMsg="安全组不能为空."
	//q:RtnFlg="-1" RtnFlg
	s:ObjReq.PrtInvType="" RtnFlg="-1",ErrMsg="票据类型不能为空."
	q:RtnFlg="-1" RtnFlg
	s:ObjReq.pBillNoStart="" RtnFlg="-1",ErrMsg="起始纸质票据号不能为空."
	q:RtnFlg="-1" RtnFlg
	s:ObjReq.pBillNoEnd="" RtnFlg="-1",ErrMsg="终止纸质票据号不能为空."
	q:RtnFlg="-1" RtnFlg
	s:ObjReq.Reason="" RtnFlg="-1",ErrMsg="作废原因不能为空."
	q:RtnFlg="-1" RtnFlg
	s:ObjReq.number="" RtnFlg="-1",ErrMsg="作废张数不能为空."
	q:RtnFlg="-1" RtnFlg
	
	q RtnFlg
}

/// 功能说明：获取第三方当前纸质票据可用号码
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.PaperBillNoReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：(格式为XML字符流)
/// 其他  w ##class(BILL.EINV.BL.EInvLogicZZJ).GetPaperBillNo("")
ClassMethod GetPaperBillNo(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	//s InputPam="<EINVReq><UserID>7</UserID><PrtInvType>PO</PrtInvType></EINVReq>"
	
	//将字符串转换为字符流
	s InputPam=..StringToStream(InputPam)
	
	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.PaperBillNoReq).%New()
	s PamRtnFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.PaperBillNoReq", .ObjReq)
	q:(PamRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[GetPaperBillNo]的入参解析失败")

	//2.业务入参验证
	s ErrMsg=""
	s CheckRtnFlg=..CheckPaperBillNoPam(ObjReq, .ErrMsg)
	q:(CheckRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//3.获取第三方当前纸质票据可用号码
	s InputData=ObjReq.UserID_"^"_ObjReq.PrtInvType
	s RtnStr=##class(BILL.EINV.BL.EInvoiceLogic).GetStockBillNo(InputData, "PaperNo")
	s ErrCode=$p(RtnStr,"^",1)
	s ErrMsg=$p(RtnStr,"^",2)
	q:(ErrCode<0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	s OutString=RtnStr
	
	//4.调用Adp层的方法 组织第三方XML字符流
	s XMLReq=""
	s AdpFlag=##class(BILL.EINV.ADP.ZZJ).SetPaperBillNoInfo(ObjReq, OutString, .XMLReq)
	q:(AdpFlag'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "组织电子票据XML失败")

	q XMLReq
}

/// 功能说明：验证获取第三方当前纸质票据可用号码的参数是否正确
ClassMethod CheckPaperBillNoPam(ObjReq As BILL.EINV.DTO.ZZJ.PrintPaperReq, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="0"
	//入参验证
	s:(ObjReq.UserID="") RtnFlg="-1", ErrMsg="操作员ID不能为空."
	q:(RtnFlg="-1")
	s:(ObjReq.PrtInvType="") RtnFlg="-1", ErrMsg="票据类型不能为空."
	q:(RtnFlg="-1")
	
	q RtnFlg
}

/// 功能说明：获取电子票据明细
/// 入参说明: InputPam   --> XML字符流对应的解析对象为：BILL.EINV.DTO.ZZJ.PatBillDetailsReq
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：调用获取病人已开具成功列表数据(格式为XML字符流)
/// 其他	 w ##class(BILL.EINV.BL.EInvLogicZZJ).GetBillDetails("")
///  s InputPam="<EINVReq><BillBatchCode>33060119</BillBatchCode><BillBatchNo>2005002208</BillBatchNo><CheckCode>01bd88</CheckCode></EINVReq>"
ClassMethod GetBillDetails(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	//将字符串转换为字符流
	s InputPam=..StringToStream(InputPam)
	
	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.PatBillDetailsReq).%New()
	s PamRtnFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.PatBillDetailsReq", .ObjReq)
	q:(PamRtnFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[GetBillDetails]的入参解析失败")
	
	//2.业务入参验证
	s ErrMsg=""
	s CheckFlg=..CheckBillDetailsPam(ObjReq, .ErrMsg)
	q:(CheckFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//3.电子发票服务商基本配置信息获取
	s ObjConfig=""
	s RtnConfig=##Class(BILL.EINV.BL.COM.InvUpConfigCtl).GetUploadConfig("", .ObjConfig)  ;获取电子发票开发商服务的地址、端口号、密钥等基本配置信息
	q:(RtnConfig'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "获取电子发票服务配置失败.")
	
	//4.组织入参调用第三方接口获取电子票据明细信息
	s ObjRes=##class(BILL.EINV.DTO.ZZJ.PatBillDetailsRes).%New()
	s InputData=ObjReq.BillBatchCode_"^"_ObjReq.BillBatchNo_"^"_ObjReq.CheckCode
	s EInvRtn=##class(BILL.EINV.BL.EInvoiceLogic).GetBillDetailInfo(InputData)
	s ErrCode=$p(EInvRtn,"^",1)
	s ErrMsg=$p(EInvRtn,"^",2)
	q:(ErrCode'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	s ObjRes.ResultStr=$p(EInvRtn,"^",2)     //将第三方返回值赋给请求出参对象
	
	//5.根据电子票据代码与电子票据号码获取发票信息
	s InvociePam=##class(BILL.EINV.DTO.COM.InvocieInputPam).%New()
	s PatInvFlg=..GetPatBillDetailInfo(ObjReq, .InvociePam, .ObjInvPrtInfo)
	q:(PatInvFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", InvociePam.ErrMsgInfo)
	 
	//6.调用Adp层的方法 组织第三方获取电子票据明细XML字符流
	s XMLReq=""
	s AdpFlag=##class(BILL.EINV.ADP.ZZJ).SetBillDetailsInfo(ObjReq, ObjInvPrtInfo, ObjRes, .XMLReq)
	q:(AdpFlag'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "组织电子票据明细XML失败")
	
	q XMLReq
}

/// 功能说明：验证组织获取电子票据明细的参数是否正确
ClassMethod CheckBillDetailsPam(ObjReq As BILL.EINV.DTO.ZZJ.PatBillDetailsReq, ErrMsg As %String) As %String
{
	s RtnFlg="0"
	
	//入参验证
	s:ObjReq.BillBatchCode="" RtnFlg="-1",ErrMsg="电子票据代码不能为空"
	q:RtnFlg="-1"
	s:ObjReq.BillBatchNo="" RtnFlg="-1",ErrMsg="电子票据号码不能为空"
	q:RtnFlg="-1"
	s:ObjReq.CheckCode="" RtnFlg="-1",ErrMsg="电子票据校验码不能为空"
	q:RtnFlg="-1"
	
	q RtnFlg
}

/// 功能说明：根据电子票据代码与电子票据号码获取发票对象
ClassMethod GetPatBillDetailInfo(ObjReq As BILL.EINV.DTO.ZZJ.PatBillDetailsReq, InvociePam As BILL.EINV.DTO.COM.InvocieInputPam, ObjInvPrtInfo As BILL.EINV.DTO.COM.InvPrtInfo) As %String
{
	s RtnFlg="0"
	s:'$d(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo",ObjReq.BillBatchCode,ObjReq.BillBatchNo)) RtnFlg="-1",InvociePam.ErrMsgInfo="不存在电子票据信息"
	q:(RtnFlg="-1")
	
	s ID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvoiceNo",ObjReq.BillBatchCode,ObjReq.BillBatchNo,""),-1)
	s objInv=##class(BILL.EINV.PO.InvUpDetails).%OpenId(ID)
	s:(objInv.EInvFlg'="I") RtnFlg="-1", InvociePam.ErrMsgInfo="入参电子票据号码在系统不是已开具状态"
	q:(RtnFlg="-1")
	
	s:(objInv.IUDPrintType'="E") RtnFlg="-1", InvociePam.ErrMsgInfo="入参电子票据号码在系统不是电子发票"
	q:(RtnFlg="-1")
	
	//2.基本信息和就诊信息
	s ObjPatBaseInfo=""   ;基本信息对象
	s ObjPatAdmInfo=""    ;就诊信息对象
	s PatRtn=##class(BILL.EINV.BL.COM.Common).GetPatInfoByInv(objInv.IUDPayAdmType, objInv.IUDInvDr, .ObjPatBaseInfo, .ObjPatAdmInfo)  ;根据发票票信息获取患者基本信息及就诊信息
	s:(PatRtn'="0") RtnFlg="-1",InvociePam.ErrMsgInfo="获取患者的基本信息或就诊信息失败."
	q:(RtnFlg="-1")
	
	//4.发票数据对象获取
	s InvociePam.HISPrtRowID=objInv.IUDInvDr
	s InvociePam.PayAdmType=objInv.IUDPayAdmType
	s ObjInvPrtInfo=##class(BILL.EINV.DTO.COM.InvPrtInfo).%New()
	s InvRtn=##class(BILL.EINV.BL.COM.Common).GetInvPrtInfo(ObjPatBaseInfo, ObjPatAdmInfo, InvociePam, .ObjInvPrtInfo)
	s:(InvRtn'="0") RtnFlg="-1"
	q:(RtnFlg="-1")
	
	q RtnFlg
}

/// 将字符串转换为字符流
ClassMethod StringToStream(InputPam) As %GlobalCharacterStream
{
	//将字符串转换为字符流
	//s objstream=##class(%Stream.GlobalCharacter).%New()
	//d objstream.Write(InputPam)
	//s InputPam=objstream
	
	q InputPam
}

/// 功能说明：电子票据开具、冲红、换开、重新换开、作废已换开统一接口
/// 入参说明: InputPam   --> XML字符流
///           tDocument  --> 利用XPATH读取xml字符流读出的文档结构
/// 返 回 值：调用获取病人已开具成功列表数据(格式为XML字符流)
/// 其他
/// w ##class(BILL.EINV.BL.EInvLogicZZJ).InvocieBill("<EINVReq><StaDate>2019-11-05</StaDate><EndDate>2019-11-05</EndDate><PrtInvType>PR</PrtInvType><PatID>360428199108292916</PatID><CardNo>9</CardNo><BillBatchCode></BillBatchCode><BillBatchNo></BillBatchNo><Type>1</Type></EINVReq>")
/// w ##class(BILL.EINV.BL.EInvLogicZZJ).InvocieBill("<EINVReq><PayAdmType>OP</PayAdmType><HISPrtRowID>发票ID</HISPrtRowID><OrgHISPrtRowID>原发票ID</OrgHISPrtRowID><PathCode></PathCode><UserID>操作员ID</UserID><GroupID>安全组ID</GroupID><CTLocID></CTLocID><HospitalID></HospitalID><pBillBatchCode></pBillBatchCode><pBillNo></pBillNo><AdmreasonDr></AdmreasonDr></EINVReq>")
ClassMethod InvocieBill(InputPam As %GlobalCharacterStream) As %GlobalCharacterStream
{
	
	set $ZT="InvocieBillZZJ"
	
	s InputPam=..StringToStream(InputPam)
	
	//1.解析入参信息
	s ObjReq=##class(BILL.EINV.DTO.ZZJ.InvocieBillReq).%New()
	s InputFlg=##class(BILL.EINV.COM.Common).XmlStreamToObj(InputPam, "EINVReq", "BILL.EINV.DTO.ZZJ.InvocieBillReq", .ObjReq)
	q:(InputFlg'=0) ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", "方法[InvocieBill]的入参解析失败")
	
	//2.业务入参验证
	s ErrMsg=""
	s CheckRtnFlg=..CheckInvocieBillPam(ObjReq, .ErrMsg)
	q:CheckRtnFlg'="0" ##class(BILL.EINV.COM.Common).BuildComOutStream("-1", ErrMsg)
	
	//调用开票接口
	//				1				2					3					4						5						6					7
	s ExpStr=ObjReq.UserID_"^"_ObjReq.GroupID_"^"_ObjReq.CTLocID_"^"_ObjReq.HospitalID_"^"_ObjReq.pBillBatchCode_"^"_ObjReq.pBillNo_"^"_ObjReq.AdmreasonDr
	s RtnStr=##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill(ObjReq.PayAdmType,ObjReq.HISPrtRowID,ObjReq.OrgHISPrtRowID,ObjReq.PathCode,ExpStr) 
	if ($p(RtnStr,"^",1)="0"){
		s XMLReq=##class(BILL.EINV.COM.Common).BuildComOutStream("0", "成功")
	}else{
		s XMLReq=##class(BILL.EINV.COM.Common).BuildComOutStream("-1", $p(RtnStr,"^",2))
	}
	
	q XMLReq
InvocieBillZZJ
	s XMLReq=##class(BILL.EINV.COM.Common).BuildComOutStream("-1","调用电子票据服务发生异常")
	q XMLReq
}

/// 功能说明：验证组织挂号数据的参数是否正确
ClassMethod CheckInvocieBillPam(ObjReq As BILL.EINV.DTO.ZZJ.InvocieBillReq, ByRef ErrMsg As %String) As %String
{
	s RtnFlg="0"
	
	//入参验证
	if (ObjReq.PayAdmType=""){			//业务类型
		s RtnFlg="-1"
		s ErrMsg="入参业务类型[PayAdmType]不能为空,请检查."
	}
	
	if (ObjReq.HISPrtRowID=""){
		s RtnFlg="-1"
		s ErrMsg="入参发票表ID[HISPrtRowID]不能为空,请检查."
	}
	
	q RtnFlg
}

}
