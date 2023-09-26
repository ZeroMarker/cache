/// 门诊大类明细列表
Class BILL.EINV.DTO.BSA.OPChargeDetail Extends %RegisteredObject
{

Property sortNo As %String(CAPTION = "序号");

Property chargeCode As %String(CAPTION = "收费项目代码");

Property chargeName As %String(CAPTION = "收费项目名称");

Property unit As %String(CAPTION = "计量单位");

Property std As %String(CAPTION = "收费标准");

Property number As %String(CAPTION = "数量");

Property amt As %String(CAPTION = "金额");

Property selfAmt As %String(CAPTION = "自费金额");

Property remark As %String(CAPTION = "备注");

}
