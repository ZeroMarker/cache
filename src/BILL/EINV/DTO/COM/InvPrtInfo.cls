/// 发票信息表
Class BILL.EINV.DTO.COM.InvPrtInfo Extends %RegisteredObject
{

/// 门诊有多账单，多账单用","分割
Property BillDr As %String(CAPTION = "账单号");

Property BusinessNo As %String(CAPTION = "流水号");

Property BusDate As %Date(CAPTION = "缴费日期");

Property BusTime As %Time(CAPTION = "缴费时间");

Property BusUserId As %String(CAPTION = "结算人ID");

Property BusUserCode As %String(CAPTION = "结算人编号");

Property BusUserDesc As %String(CAPTION = "结算人描述");

Property InvAmt As %String(CAPTION = "总金额");

Property InvShareAmt As %String(CAPTION = "自付金额");

Property InvoceType As %String(CAPTION = "票据类型");

Property InvNo As %String(CAPTION = "发票号");

Property InvFlag As %String(CAPTION = "结算状态");

Property InvInit As %String(CAPTION = "正记录ID");

Property PrtHospDr As %String(CAPTION = "院区指针");

Property InvPrtFlag As %String(CAPTION = "打印标志");

Property GroupDr As %String(CAPTION = "安全组指针");

Property InsTypeDr As %String(CAPTION = "费别指针");

Property weChatOrderNo As %String(CAPTION = "微信订单");

/// 住院用
Property RecAmt As %String(CAPTION = "应收金额");

Property RefAmt As %String(CAPTION = "应退金额");

Property DepositAmt As %String(CAPTION = "预交总金额");

/// 患者基本信息对象
Property PatBaseInfo As BILL.EINV.DTO.COM.PatBaseInfo(CAPTION = "患者基本信息");

/// 患者本次就诊信息对象
Property PatAdmInfo As BILL.EINV.DTO.COM.PatAdmInfo(CAPTION = "本次就诊信息");

/// 医保结算信息和患者参保信息对象
Property InsuDivInfo As BILL.EINV.DTO.COM.InsuDivideInfo(CAPTION = "医保结算信息");

/// 支付方式对象
Property PayModeInfo As list Of BILL.EINV.DTO.COM.InvPayModeInfo(CAPTION = "支付方式信息");

/// 费用分类信息对象
Property InvCateInfo As list Of BILL.EINV.DTO.COM.InvCateInfo(CAPTION = "费用分类信息");

/// 费用明细信息对象
Property InvItmDetInfo As list Of BILL.EINV.DTO.COM.InvItmDetailInfo(CAPTION = "费用明细信息");

/// 住院预交金明细   add   guoyunlong
Property IPPreDepositInfo As list Of BILL.EINV.DTO.COM.IPPreDepositInfo(CAPTION = "住院预交金明细");

/// 体检其他信息对象
Property PEBaseInfo As BILL.EINV.DTO.COM.PEBaseInfo(CAPTION = "体检其他信息对象");

/// 诊断信息对象
Property DiagnosisInfo As list Of BILL.EINV.DTO.COM.DiagnosisInfo(CAPTION = "体检其他信息对象");

}
