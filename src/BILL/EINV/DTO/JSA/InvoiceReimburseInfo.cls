Class BILL.EINV.DTO.JSA.InvoiceReimburseInfo Extends %RegisteredObject
{

Property illassist As %String(CAPTION = "大病救助报销金额", XMLNAME = "ill_assist");

Property illinsur As %String(CAPTION = "大病保险报销金额", XMLNAME = "ill_insur");

Property civilassist As %String(CAPTION = "民政救助报销金额", XMLNAME = "civil_assist");

Property medinsur As %String(CAPTION = "医保范围内费用", XMLNAME = "med_insur");

Property selfpay As %String(CAPTION = "个人自理金额", XMLNAME = "self_pay");

}
