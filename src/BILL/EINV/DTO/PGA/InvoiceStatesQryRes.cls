Class BILL.EINV.DTO.PGA.InvoiceStatesQryRes Extends %RegisteredObject
{

Property IvcAgcCode As %String(CAPTION = "单位编码");

Property SerialNumber As %String(CAPTION = "业务流水号");

Property State As %String(CAPTION = "开票状态");

Property ErrorMsg As %String(CAPTION = "错误信息");

Property EInvoiceCode As %String(CAPTION = "票据代码");

Property EInvoiceNumber As %String(CAPTION = "票据号码");

Property RandomNumber As %String(CAPTION = "校验码");

Property States As BILL.EINV.DTO.PGA.InvoiceStates(CAPTION = "票据状态");

Property EinvoiceContent As BILL.EINV.DTO.PGA.InvoiceStatesContent(CAPTION = "票据内容");

}
