/// 票面明细信息
Class BILL.EINV.DTO.JSB.EInvDetailList Extends %RegisteredObject
{

Property "item_code" As %String(CAPTION = "项目编码");

Property "item_name" As %String(CAPTION = "项目名称");

Property "item_amount" As %String(CAPTION = "金额");

Property unit As %String(CAPTION = "计量单位");

Property num As %String(CAPTION = "数量");

Property stdtype As %String(CAPTION = "标准类型");

Property Itemext As BILL.EINV.DTO.JSB.EInvDetailListExt(CAPTION = "明细信息扩展");

}
