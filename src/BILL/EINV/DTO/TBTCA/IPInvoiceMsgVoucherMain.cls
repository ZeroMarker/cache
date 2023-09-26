Class BILL.EINV.DTO.TBTCA.IPInvoiceMsgVoucherMain Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 校验码
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

/// 总金额
Property TotalAmount As %String(XMLPROJECTION = "ELEMENT");

/// 结算日期(yyyyMMdd)
Property IssueDate As %String(XMLPROJECTION = "ELEMENT");

/// 计算时间(hh:mm:ss 格式)
Property IssueTime As %String(XMLPROJECTION = "ELEMENT");

/// 开票单位
Property InvoicingParty As BILL.EINV.DTO.TBTCA.InvoicingParty;

/// 交款人类型
Property PayerPartyType As %String(XMLPROJECTION = "ELEMENT");

/// 交款方式
Property PayMode As %String(XMLPROJECTION = "ELEMENT");

/// 业务流水号
Property BizCode As %String(XMLPROJECTION = "ELEMENT");

/// 开票人
Property HandlingPerson As %String(XMLPROJECTION = "ELEMENT");

/// 复核人
Property Checker As %String(XMLPROJECTION = "ELEMENT");

/// 备注
Property Remark As %String(XMLPROJECTION = "ELEMENT");

/// 基本信息扩展
Property MainExt As BILL.EINV.DTO.TBTCA.IPInvoiceMainExt;

}
