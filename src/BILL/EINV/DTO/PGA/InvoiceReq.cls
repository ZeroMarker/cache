Class BILL.EINV.DTO.PGA.InvoiceReq Extends %RegisteredObject
{

Property reqSource As %String(CAPTION = "开票请求来源");

Property patType As %String(CAPTION = "就诊类型");

Property patNumber As %String(CAPTION = "就诊号");

Property email As %String(CAPTION = "邮箱地址");

Property phone As %String(CAPTION = "交款人手机号");

Property idcardNo As %String(CAPTION = "身份证号");

Property type As %String(CAPTION = "开票类型");

Property payerPartyType As %String(CAPTION = "交款人类型");

Property payerPartyCode As %String(CAPTION = "单位是社会信用代码个人是身份证号");

Property payerPartyName As %String(CAPTION = "交款人名称");

Property payerAcct As %String(CAPTION = "交款人账号");

Property payerOpBk As %String(CAPTION = "交款人开户行");

Property payMode As %String(CAPTION = "交款方式");

Property recName As %String(CAPTION = "收款人名称");

Property recOpBk As %String(CAPTION = "收款人开户银行名称");

Property recAcct As %String(CAPTION = "收款人账号");

Property totalAmount As %String(CAPTION = "总金额");

Property repCreater As %String(CAPTION = "开票人");

Property checker As %String(CAPTION = "复核人");

Property mainExt As BILL.EINV.DTO.PGA.InvoiceMainExt(CAPTION = "其他信息");

Property items As list Of BILL.EINV.DTO.PGA.InvoiceItems(CAPTION = "项目列表");

}
