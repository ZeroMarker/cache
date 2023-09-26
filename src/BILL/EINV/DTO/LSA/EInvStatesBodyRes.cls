Class BILL.EINV.DTO.LSA.EInvStatesBodyRes Extends %RegisteredObject
{

Property billGuid As %String(CAPTION = "单据流水号");

Property billNo As %String(CAPTION = "单据编号");

Property invCode As %String(CAPTION = "开票代码");

Property invNo As %String(CAPTION = "开票号码");

/// 开票日期（yyyy-MM-dd）
Property invDate As %String(CAPTION = "开票日期");

/// 开票状态（0为正常票，1为作废票，2为红冲票;）
Property status As %String(CAPTION = "开票状态");

/// 作废日期（yyyy-MM-dd）
Property cancelDate As %String(CAPTION = "作废日期");

/// 开票类型（0专票，2普票，51电子票）
Property invType As %String(CAPTION = "开票类型");

Property sellName As %String(CAPTION = "销方名称");

Property sellTaxNo As %String(CAPTION = "销方税号");

Property totalTaxAmount As %String(CAPTION = "合计税额");

Property totalAmount As %String(CAPTION = "价税合计");

Property totalAmountWithoutTax As %String(CAPTION = "不含税总额");

Property note As %String(CAPTION = "备注");

Property pdfUrl As %String(CAPTION = "电子票pdf下载路径");

Property pdfMsg As %String(CAPTION = "签章信息");

}
