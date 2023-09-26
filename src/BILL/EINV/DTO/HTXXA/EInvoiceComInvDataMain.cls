/// 电子发票开票主要信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMain Extends (%RegisteredObject, %XML.Adaptor)
{

Property EInvoiceName As %String(CAPTION = "电子票据名称", XMLPROJECTION = "ELEMENT");

Property EInvoiceCode As %String(CAPTION = "电子票据代码", XMLPROJECTION = "ELEMENT");

Property EInvoiceNumber As %String(CAPTION = "电子票据号码", XMLPROJECTION = "ELEMENT");

Property RandomNumber As %String(CAPTION = "校验码", XMLPROJECTION = "ELEMENT");

Property EInvoiceSpecimenCode As %String(CAPTION = "电子票据模版代码", XMLPROJECTION = "ELEMENT");

Property SupervisorAreaCode As %String(CAPTION = "电子票据监管机构代码", XMLPROJECTION = "ELEMENT");

/// 小数点后需保留2位
Property TotalAmount As %String(CAPTION = "总金额", XMLPROJECTION = "ELEMENT");

/// 格式为yyyyMMdd
Property IssueDate As %String(CAPTION = "开票日期", XMLPROJECTION = "ELEMENT");

/// 格式为HH:mm:ss如09:29:53
Property IssueTime As %String(CAPTION = "开票时间", XMLPROJECTION = "ELEMENT");

/// 开票单位信息
Property InvoicingParty As BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainInvParty(XMLNAME = "InvoicingParty", XMLPROJECTION = "ELEMENT");

/// 交款人信息
Property PayerParty As BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainPayerParty(CAPTION = "交款人", XMLNAME = "PayerParty", XMLPROJECTION = "ELEMENT");

Property PayMode As %String(CAPTION = "交款方式", XMLPROJECTION = "ELEMENT");

Property BizCode As %String(CAPTION = "业务流水号", XMLPROJECTION = "ELEMENT");

Property CurrencyType As %String(CAPTION = "货币种类", XMLPROJECTION = "ELEMENT");

Property ExchangeRate As %String(CAPTION = "汇率", XMLPROJECTION = "ELEMENT");

Property Remark As %String(CAPTION = "备注", XMLPROJECTION = "ELEMENT");

Property HandlingPerson As %String(CAPTION = "开票人", XMLPROJECTION = "ELEMENT");

Property Checker As %String(CAPTION = "复核人", XMLPROJECTION = "ELEMENT");

Property SupervisorRemark As %String(CAPTION = "财政部门备注", XMLPROJECTION = "ELEMENT");

/// 基本信息扩展
Property MainExt As BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainExt(CAPTION = "基本信息扩展", XMLNAME = "MainExt", XMLPROJECTION = "ELEMENT");

/// /开票单位印章
Property InvoicingPartySeal As BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainPartySeal(CAPTION = "汇率", XMLPROJECTION = "ELEMENT");

}
