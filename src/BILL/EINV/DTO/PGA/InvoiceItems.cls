Class BILL.EINV.DTO.PGA.InvoiceItems Extends %RegisteredObject
{

Property itemCode As %String(CAPTION = "项目编码");

Property itemName As %String(CAPTION = "项目名称");

Property itemStd As %String(CAPTION = "标准");

Property itemUnit As %String(CAPTION = "单位");

Property itemAmount As %String(CAPTION = "数量");

Property amount As %String(CAPTION = "项目金额");

Property note As %String(CAPTION = "项目备注");

Property auxItem As list Of BILL.EINV.DTO.PGA.InvoiceAuxItem(CAPTION = "收费项目明细");

}
