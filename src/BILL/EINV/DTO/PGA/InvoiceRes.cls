Class BILL.EINV.DTO.PGA.InvoiceRes Extends %RegisteredObject
{

Property SerialNumber As %String(CAPTION = "业务流水号");

Property EInvoiceCode As %String(CAPTION = "票据代码");

Property EInvoiceNumber As %String(CAPTION = "票据号码");

Property RandomNumber As %String(CAPTION = "校验码");

Property IssueDate As %String(CAPTION = "开票日期");

Property IssueTime As %String(CAPTION = "开票时间");

Property BillPdfUrl As %String(CAPTION = "二维码预览地址");

Property BillPdfAddr As %String(CAPTION = "二维码预览");

Property File As %String(CAPTION = "票据文件");

Property NowStock As %String(CAPTION = "剩余库存");

}
