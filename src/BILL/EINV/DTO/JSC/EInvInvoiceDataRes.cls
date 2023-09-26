/// 返回列表信息
Class BILL.EINV.DTO.JSC.EInvInvoiceDataRes Extends %RegisteredObject
{

Property issuedate As %String(CAPTION = "开具日期", XMLNAME = "issue_date");

Property invoiceurl As %String(CAPTION = "电子票获取地址", XMLNAME = "invoice_url");

/// 附加信息，在业务上有特殊要求的在此协商增加扩展参数，格式一般约定为JSON ARRAY格式的字符串
Property attachinfo As %String(CAPTION = "附加信息", XMLNAME = "attach_info");

Property invoicecode As %String(CAPTION = "票据代码", XMLNAME = "invoice_code");

Property invoicenumber As %String(CAPTION = "电子票据号码", XMLNAME = "invoice_number");

Property rcptno As %String(CAPTION = "发票号", XMLNAME = "rcpt_no");

Property invoicingpartyname As %String(CAPTION = "开票单位名称", XMLNAME = "invoicing_party_name");

Property payerpartyname As %String(CAPTION = "交款人名称", XMLNAME = "payer_party_name");

Property totalamount As %String(CAPTION = "总金额", XMLNAME = "total_amount");

Property invoicestatus As %String(CAPTION = "票据状态", XMLNAME = "invoice_status");

Property bizcode As %String(CAPTION = "业务流水号", XMLNAME = "bizcode");

Property CLBZ As %String(CAPTION = "处理标志");

Property CLJG As %String(CAPTION = "处理结果");

}
