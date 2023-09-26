/// 开具接口返回值对象
Class BILL.EINV.DTO.JSB.EInvInvoiceRes Extends %RegisteredObject
{

/// 响应代码，00000：成功,其他：失败
Property result As %String(CAPTION = "响应代码");

Property infomation As %String(CAPTION = "响应消息");

Property "invoice_code" As %String(CAPTION = "票据代码");

Property "invoice_number" As %String(CAPTION = "票据号码");

Property random As %String(CAPTION = "校验码");

Property bizcode As %String(CAPTION = "业务流水号");

Property "invoicing_party_name" As %String(CAPTION = "开票单位名称");

Property "payer_party_name" As %String(CAPTION = "交款人名称");

Property "total_amount" As %String(CAPTION = "总金额");

/// 开票状态，00：开票中  01：开票成功 02：开票失败
Property "invoice_status" As %String(CAPTION = "开票状态");

Property "issue_date" As %String(CAPTION = "开具日期");

Property "invoice_url" As %String(CAPTION = "电子票获取地址");

/// 附加信息，在业务上有特殊要求的在此协商 增 加 扩 展 参 数 ， 格 式 一 般 约 定 为JsonArray 格式的字符串。
Property "attach_info" As %String(CAPTION = "附加信息");

}
