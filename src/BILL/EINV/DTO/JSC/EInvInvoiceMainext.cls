/// 相关票据信息
Class BILL.EINV.DTO.JSC.EInvInvoiceMainext Extends %RegisteredObject
{

Property relatedinvoicecode As %String(CAPTION = "相关票据代码", XMLNAME = "related_invoice_code");

Property relatedinvoicenumber As %String(CAPTION = "相关票据号码", XMLNAME = "related_invoice_number");

Property paycode As %String(CAPTION = "缴款码", XMLNAME = "pay_code");

}
