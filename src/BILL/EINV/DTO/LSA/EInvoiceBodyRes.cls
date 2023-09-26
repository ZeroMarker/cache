Class BILL.EINV.DTO.LSA.EInvoiceBodyRes Extends %RegisteredObject
{

Property code As %String(CAPTION = "返回码");

Property msg As %String(CAPTION = "返回消息");

Property billGuid As %String(CAPTION = "单据流水号");

Property billNo As %String(CAPTION = "单据编号");

Property invCode As %String(CAPTION = "发票代码");

Property invNo As %String(CAPTION = "发票号码");

Property invDate As %String(CAPTION = "开票时间");

/// 发票状态 0正常 1作废 
Property status As %String(CAPTION = "发票状态");

Property invType As %String(CAPTION = "发票类型");

Property sellName As %String(CAPTION = "销方名称");

Property sellTaxNo As %String(CAPTION = "销方税号");

/// 合计税额（不传时，按明细税额累加） N
Property totalTaxAmount As %String(CAPTION = "合计税额");

/// 价税合计（不传时，按明细价税累加） N
Property totalAmount As %String(CAPTION = "价税合计");

/// 不含税总额（不传时，按明细不含税金额累加） N
Property totalAmountWithoutTax As %String(CAPTION = "不含税总额");

Property note As %String(CAPTION = "备注");

Property details As list Of BILL.EINV.DTO.LSA.EInvoiceDetails(CAPTION = "单据明细");

}
