/// 电子票据红冲入参对象
Class BILL.EINV.DTO.ZBXXA.EInvalidReq Extends %RegisteredObject
{

Property REQUESTID As %String(CAPTION = "红请求流水号", XMLNAME = "REQUEST_ID");

Property InvoicingPartyCode As %String(CAPTION = "开票单位编码");

Property PlaceCode As %String(CAPTION = "开票点编码");

Property EInvoiceCode As %String(CAPTION = "票据代码");

Property EInvoiceNumber As %String(CAPTION = "票据号码");

Property IssueDate As %String(CAPTION = "开票日期");

Property TotalAmount As %String(CAPTION = "开票金额");

Property PInvoiceCode As %String(CAPTION = "红冲票据对应红冲纸票代 ");

Property PInvoiceNumber As %String(CAPTION = "红冲票据对应红冲纸票号码");

Property Memo As %String(CAPTION = "红冲原因");

Property SMSEmail As %String(CAPTION = "推送邮箱号", XMLNAME = "SMS_Email");

Property SMSPHONE As %String(CAPTION = "推送手机号", XMLNAME = "SMS_PHONE");

}
