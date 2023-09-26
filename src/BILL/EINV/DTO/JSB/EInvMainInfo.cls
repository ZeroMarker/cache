/// 红冲相关票据信息
Class BILL.EINV.DTO.JSB.EInvMainInfo Extends %RegisteredObject
{

/// 相关票据代码,预留扩展字段，开具红票时在此填写原票据代码
Property "related_invoice_code" As %String(CAPTION = "原票据代码");

/// 相关票据号码,开具红票时在此填写原票据号码
Property "related_invoice_number" As %String(CAPTION = "原票据号码");

Property "pay_code" As %String(CAPTION = "缴款码");

}
