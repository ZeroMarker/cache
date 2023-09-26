/// auxdetails项目清单（List） 住院也需要传明细
Class BILL.EINV.DTO.FSA.auxdetailslist Extends %RegisteredObject
{

Property auxitemrelatedcode As %String(CAPTION = "对应项目编码");

Property auxitemrelatedname As %String(CAPTION = "对应项目名称");

Property auxitemcode As %String(CAPTION = "收费明细项目编码");

Property auxitemname As %String(CAPTION = "收费明细项目名称");

Property auxitemquantity As %String(CAPTION = "收费明细项目数量");

Property auxitemunit As %String(CAPTION = "收费明细项目单位");

Property auxitemstd As %String(CAPTION = "收费明细项目标准");

Property auxitemamount As %String(CAPTION = "收费明细项目金额");

Property auxitemremark As %String(CAPTION = "收费明细项目备注");

}
