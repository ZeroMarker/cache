Class BILL.EINV.DTO.XCA.InvoiceItems Extends %RegisteredObject
{

Property ItemCode As %String(CAPTION = "项目编码");

Property ItemStd As %String(CAPTION = "标准");

Property ItemUnit As %String(CAPTION = "单位");

Property ItemAmount As %String(CAPTION = "数量");

Property Amount As %String(CAPTION = "项目金额");

Property Note As %String(CAPTION = "项目备注");

Property AuxItem As BILL.EINV.DTO.XCA.InvoiceAuxItem(CAPTION = "收费项目明细");

}
