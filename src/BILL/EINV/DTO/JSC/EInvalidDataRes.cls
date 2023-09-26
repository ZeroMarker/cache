Class BILL.EINV.DTO.JSC.EInvalidDataRes Extends %RegisteredObject
{

Property issuedate As %String(CAPTION = "开具日期", XMLNAME = "issue_date");

Property invoiceurl As %String(CAPTION = "电子票获取地址", XMLNAME = "invoice_url");

Property attachinfo As %String(CAPTION = "附加信息", XMLNAME = "attach_info");

Property invoicecode As %String(CAPTION = "票据代码", XMLNAME = "invoice_code");

Property invoicenumber As %String(CAPTION = "票据号码", XMLNAME = "invoice_number");

Property oldinvoicecode As %String(CAPTION = "原票据代码", XMLNAME = "oldinvoice_code");

Property oldinvoicenumber As %String(CAPTION = "原票据号码", XMLNAME = "oldinvoice_number");

}
