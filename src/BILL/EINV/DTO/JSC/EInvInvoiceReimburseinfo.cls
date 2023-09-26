/// 报销信息
Class BILL.EINV.DTO.JSC.EInvInvoiceReimburseinfo Extends %RegisteredObject
{

Property illassist As %String(CAPTION = "大病救助报销金额", XMLNAME = "ill_assist");

Property illinsur As %String(CAPTION = "大病保险报销金额", XMLNAME = "ill_insur");

Property civilassist As %String(CAPTION = "民政救助报销金额", XMLNAME = "civil_assist");

Property medinsur As %String(CAPTION = "医保范围内费用", XMLNAME = "med_insur");

Property selfpay As %String(CAPTION = "个人自理金额", XMLNAME = "self_pay");

Property civilServantNum As %String(CAPTION = "公务员补助支付");

Property personAccountPayNum As %String(CAPTION = "本次账户支付自付");

Property personAccountCareNum As %String(CAPTION = "本次账户支付自理");

Property cashPayNum As %String(CAPTION = "本次现金支付自付");

Property cashCareNum As %String(CAPTION = "本次现金支付自理");

Property personPay As %String(CAPTION = "个人自付金额");

Property inBalance As %String(CAPTION = "入院时账户余额");

Property payLevel As %String(CAPTION = "起付标准（异地就医）");

Property genFee As %String(CAPTION = "3个范围内费用");

Property pubSelf As %String(CAPTION = "统筹个人支付");

Property helpSelf As %String(CAPTION = "大病救助个人支付");

Property supplyPay As %String(CAPTION = "公务员补充支付/企业补充支付");

Property supplySelf As %String(CAPTION = "公务员补充支付/企业补充支付 个人支付");

Property bankAccPay As %String(CAPTION = "个人储蓄账户支付");

}
