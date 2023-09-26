/// 电子发票红冲返回值
Class BILL.EINV.DTO.ZBXXA.EInvalidRes Extends %RegisteredObject
{

/// 1已红冲,2红冲失败
Property REDRUSHSTATE As %String(CAPTION = "红冲状态", XMLNAME = "RED_RUSH_STATE");

Property EInvoiceCode As %String(CAPTION = "票据代码");

Property EInvoiceNumber As %String(CAPTION = "票据号码");

Property IssueDate As %String(CAPTION = "开票日期");

Property PdfUrl As %String(CAPTION = "板式文件地址");

}
