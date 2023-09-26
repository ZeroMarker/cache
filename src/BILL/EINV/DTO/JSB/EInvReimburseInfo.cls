/// 报销信息
Class BILL.EINV.DTO.JSB.EInvReimburseInfo Extends %RegisteredObject
{

Property "ill_assist" As %String(CAPTION = "大病救助报销金额");

Property "ill_insur" As %String(CAPTION = "大病保险报销金额");

Property "civil_assist" As %String(CAPTION = "民政救助报销金额");

Property "med_insur" As %String(CAPTION = "医保范围内费用");

Property "self_pay" As %String(CAPTION = "个人自理金额");

}
