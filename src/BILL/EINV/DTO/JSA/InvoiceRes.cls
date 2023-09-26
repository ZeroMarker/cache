Class BILL.EINV.DTO.JSA.InvoiceRes Extends %RegisteredObject
{

Property result As %String(CAPTION = "处理结果代码");

Property information As %String(CAPTION = "详细信息");

Property "invoice_code" As %String(CAPTION = "票据代码");

Property "invoice_number" As %String(CAPTION = "电子票据号码");

Property bizcode As %String(CAPTION = "业务流水号");

Property "issue_date" As %String(CAPTION = "开具日期");

Property "invoicing_party_name" As %String(CAPTION = "开票单位名称");

Property "payer_party_name" As %String(CAPTION = "交款人名称");

Property "total_amount" As %String(CAPTION = "总金额");

Property "invoice_url" As %String(CAPTION = "电子票获取地址");

Property "invoice_status" As %String(CAPTION = "票据状态");

Property "attach_info" As %String(CAPTION = "附加信息");

}
