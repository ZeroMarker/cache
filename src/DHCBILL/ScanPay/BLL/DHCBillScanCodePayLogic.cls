Import SQLUser

Class DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic Extends BILL.COM.Abstract
{

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 生成扫码付订单
/// Input:  TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,CANCEL:冲销)
/// 		PayModeDR:支付方式
/// 		TradeAmt:交易金额(元)
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^病人ID^就诊^业务表指针串(以!分隔,可为空)^原订单ID^收退标志(C收D退))
/// Return:	是否成功^订单ID^描述
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).CreateScanCodePay("PRE","46","0.01","132388462368260787","3^239^2^17275^703^^^^C")
ClassMethod CreateScanCodePay(TradeType As %String, PayModeDR As %String, TradeAmt As %String, ScanCode As %String, ExpStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("CreateScanCodePay")=$lb(TradeType, PayModeDR, TradeAmt, ScanCode, ExpStr)
	
	set HospDR=$p(ExpStr,"^",3)
	set Guser=$p(ExpStr,"^",4)
	set PatientId=$p(ExpStr,"^",5)
	set Adm=$p(ExpStr,"^",6)
	set PrtStr=$p(ExpStr,"^",7)
	
	set rtn=0
	
	ts
	
	//创建支付订单
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreatePayOrder(TradeType, PayModeDR, TradeAmt, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set ETPRowID=$p(rtnValue,"^",2)
	
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_ScanCode = :ScanCode
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	if ($tl>0) tc

	//调用第三方生成订单
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName="") quit 300_"^"_"支付方式未配置Adapter类"
	
	set PMEClassMethod="CreateScanCodePay"
	if ('##class(websys.Conversions).IsValidMethodName(PMEClassName, PMEClassMethod)) {
		quit 301_"^"_"配置的Adapter类方法不存在"
	}

	set rtnValue=$classmethod(PMEClassName, PMEClassMethod, ETPRowID, ScanCode, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) quit rtnValue
	
	quit rtn_"^"_ETPRowID

ERROR
	quit ..AppException()
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 提交扫码付支付
/// Input: ETPRowID:订单ID， ScanCode:病人手机支付码
/// Return: 订单支付状态^his保存返回码
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).CommitScanCodePay("46", "12876543567", "")
ClassMethod CommitScanCodePay(ETPRowID As %String, ScanCode As %String, ExpStr As %String = "")
{
	set ^TMP("CommitScanCodePay")=$lb(ETPRowID, ScanCode, ExpStr)
	quit:(ETPRowID="") -1_"^"_"参数错误"
	
	set PayModeDR=##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName="") quit 300_"^"_"支付方式未配置Adapter类"
	
	set PMEClassMethod="CommitScanCodePay"
	if ('##class(websys.Conversions).IsValidMethodName(PMEClassName, PMEClassMethod)) {
		quit 301_"^"_"配置的Adapter类方法不存在"
	}
	
	set rtnValue=$classmethod(PMEClassName, PMEClassMethod, ETPRowID, ScanCode, ExpStr)
	quit rtnValue
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 查询订单支付状态
/// Input: ETPRowID:订单ID， ExpStr: 扩展串
/// Return: 
/// Debug:w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).VerifyScanCodePayStatus(118,"134816083819344511")
ClassMethod VerifyScanCodePayStatus(ETPRowID As %String, ExpStr As %String = "")
{
	quit:(ETPRowID="") -1_"^"_"参数错误"
    
    set PayModeDR=##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)	
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName="") quit 300_"^"_"支付方式未配置Adapter类"
	
	set PMEClassMethod="VerifyScanCodePayStatus"
	if ('##class(websys.Conversions).IsValidMethodName(PMEClassName, PMEClassMethod)) {
		quit 301_"^"_"配置的Adapter类方法不存在"
	}
	
	set rtnValue=$classmethod(PMEClassName, PMEClassMethod, ETPRowID, ExpStr)
	quit rtnValue
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 关闭订单
/// Input: ETPRowID:订单ID，ExpStr
/// Return: 
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).CancelScanCodePay(118,"")
ClassMethod CancelScanCodePay(ETPRowID As %String, ExpStr As %String = "")
{
	quit:(ETPRowID="") -1_"^"_"参数错误"
	
	set PayModeDR=##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName="") quit 300_"^"_"支付方式未配置Adapter类"
	
	set PMEClassMethod="CancelScanCodePay"
	if ('##class(websys.Conversions).IsValidMethodName(PMEClassName, PMEClassMethod)) {
		quit 301_"^"_"配置的Adapter类方法不存在"
	}
	
	set rtnValue=$classmethod(PMEClassName, PMEClassMethod, ETPRowID, ExpStr)
	quit rtnValue
}

/// Creator: xiongwang
/// CreatDate: 2018-03-22
/// Descripiton: 冲正接口
/// Input: ETPRowID: 原订单ID
/// Return: 格式化后的返回参数
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).CorrectScanCodePay(14,"186^19^2^4046")
ClassMethod CorrectScanCodePay(OrgETPRowID As %String, ExpStr As %String) As %String
{
	quit:(OrgETPRowID="") -1_"^"_"参数错误"
	
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).GetCanRevokeFlag(OrgETPRowID)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue   //+2023-05-08 ZhYW 冲正前增加校验
	
	set ETPData=$g(^DHCBILLETP(OrgETPRowID))
	//退费金额=原交易金额
	set RefAmt=$p(ETPData,"^",4)
	//冲正订单类型为：CANCEL,
	//set TradeType="CANCEL"
	set TradeType=$p(ETPData,"^",25)	//取原订单类型
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreateRefOrder(TradeType, OrgETPRowID, "D", RefAmt, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set ETPRowID=$p(rtnValue,"^",2)
	
	set PayModeDR=##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName="") quit 300_"^"_"支付方式未配置Adapter类"
	
	set PMEClassMethod="RefundScanCodePay"	//调用退费接口
	if ('##class(websys.Conversions).IsValidMethodName(PMEClassName, PMEClassMethod)) {
		quit 301_"^"_"配置的Adapter类方法不存在"
	}
	
	set rtnValue=$classmethod(PMEClassName, PMEClassMethod, ETPRowID, ExpStr)
	quit rtnValue
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 退费接口
/// Input:  TradeType:业务类型(OP:门诊,IP:住院,DEP:住院押金,PRE:门诊充值,CARD:发卡,INSU:医保报销,CANCEL:冲销)
/// 		OrgETPRowID:原业务交易记录
///         RefundAmt: 退费金额
/// 		ExpStr:扩展串(科室^安全组^院区^操作员ID^业务表指针串(以!分隔,可为空))
/// Return: 
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).RefundScanCodePay()
ClassMethod RefundScanCodePay(TradeType As %String, OrgETPRowID As %String, RefundAmt As %String, ExpStr As %String)
{
	set rtnValue=##class(DHCBILL.Common.DHCBILLCommon).CreateRefOrder(TradeType, OrgETPRowID, "D", RefundAmt, ExpStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	set ETPRowID=$p(rtnValue,"^",2)
	
	set PayModeDR=##class(DHCBILL.Common.DHCBILLCommon).GetETPPayModeID(ETPRowID)
	set payModeInfo=##class(DHCBILL.Common.DHCBILLCommon).GetCallModeByPayMode(PayModeDR)
	set PMEClassName=$p(payModeInfo,"^",2)
	if (PMEClassName="") quit 300_"^"_"支付方式未配置Adapter类"
	
	set PMEClassMethod="RefundScanCodePay"	//调用退费接口
	if ('##class(websys.Conversions).IsValidMethodName(PMEClassName, PMEClassMethod)) {
		quit 301_"^"_"配置的Adapter类方法不存在"
	}
	
	set rtnValue=$classmethod(PMEClassName, PMEClassMethod, ETPRowID, ExpStr)
	quit rtnValue
}

/// Creator: zhenghao
/// CreatDate: 2018-03-07
/// Descripiton: 保存交易日志
/// Input: ETPRowID:订单表ID, BankData:保存扫码交易返回原始数据
/// Return: 0:成功	(ETPRowID,FormatType,ScanOutput)
/// Debug: w ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveLog()
ClassMethod SaveLog(ETPRowID As %String, FormatType As %String, BankData As %String)
{
	set $zt="ERROR"
	//wangjian 2018-04-04
	do ..SaveScanCodeLog(ETPRowID, FormatType, BankData)
	&SQL(
		UPDATE DHC_BillExtTradePay
		SET ETP_ExtOutString = REPLACE(:BankData,"^","＾")
		WHERE %ID = :ETPRowID
	)
	set rtn=SQLCODE
	if (+rtn) quit rtn_"^"_$g(%msg)
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: wangjian
/// CreatDate: 2018-04-04
/// Descripiton: 保存交易日志到Global
/// Input: ETPRowID:订单表ID
/// 	   FormatType:接口名称
///        SaveData:保存扫码交易出参或者入参
/// 	   DataType:Input 或 OutPut
/// Debug: d ##class(DHCBILL.ScanPay.BLL.DHCBillScanCodePayLogic).SaveScanCodeLog()
ClassMethod SaveScanCodeLog(ETPRowID As %String, FormatType As %String, SaveData As %String, DataType As %String = "Output")
{
	set Num=$i(^DHCBILLScanCodePayLog(DataType,ETPRowID,FormatType))
	set CurrDate=$zd(+$h,3)
	set CurrTime=$zt($p($h,",",2),1)
	set ^DHCBILLScanCodePayLog(DataType,ETPRowID,FormatType,Num,CurrDate,CurrTime)=SaveData
	quit ""
}

}
