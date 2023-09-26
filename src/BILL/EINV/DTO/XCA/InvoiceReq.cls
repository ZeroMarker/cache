/// 7.1.2 直接开票请求对象
Class BILL.EINV.DTO.XCA.InvoiceReq Extends %RegisteredObject
{

Property RegionCode As %String(CAPTION = "区划编码");

Property IvcAgcCode As %String(CAPTION = "单位编码");

Property SerialNumber As %String(CAPTION = "业务流水号");

Property Type As %String(CAPTION = "开票类型");

Property PayerPartyType As %String(CAPTION = "交款人类型");

Property PayerPartyCode As %String(CAPTION = "交款人代码");

Property PayerPartyName As %String(CAPTION = "交款人名称");

Property PayerAcct As %String(CAPTION = "交款人账号");

Property PayerOpBk As %String(CAPTION = "交款人开户行");

Property PayMode As %String(CAPTION = "交款方式");

Property RecName As %String(CAPTION = "收款人名称");

Property RecOpBk As %String(CAPTION = "收款人开户银行名称");

Property RecAcct As %String(CAPTION = "收款人账号");

Property TotalAmount As %String(CAPTION = "总金额");

Property RepCreater As %String(CAPTION = "开票人");

Property Checker As %String(CAPTION = "复核人");

Property MainExt As BILL.EINV.DTO.XCA.InvoiceMainExt(CAPTION = "其他信息");

Property Items As list Of BILL.EINV.DTO.XCA.InvoiceItems(CAPTION = "项目列表");

Property Notice As %String(CAPTION = "邮箱地址/手机号/第三方用户ID");

}
