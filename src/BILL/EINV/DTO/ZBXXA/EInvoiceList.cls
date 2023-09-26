/// 返回的票面信息
Class BILL.EINV.DTO.ZBXXA.EInvoiceList Extends %RegisteredObject
{

Property EInvoiceCode As %String(CAPTION = "票据代码");

Property EInvoiceNumber As %String(CAPTION = "票据号码");

Property IssueDate As %String(CAPTION = "开票日期");

Property TotalAmount As %String(CAPTION = "开票金额");

Property PdfUrl As %String(CAPTION = "板式文件地址");

}
