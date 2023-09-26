Class BILL.EINV.DTO.HNA.InvoiceReq Extends %RegisteredObject
{

/// 00-住院 10-门诊 11-急诊 12-体检 30-其他
Property ivcType As %String(CAPTION = "开票类型");

Property ivcCode As %String(CAPTION = "票据代码");

Property ivcNumber As %String(CAPTION = "票据号码");

Property bizCode As %String(CAPTION = "业务流水号");

Property totalAmount As %String(CAPTION = "总金额");

Property issueDate As %String(CAPTION = "开票日期");

Property sysCode As %String(CAPTION = "系统代码");

/// 开票单位(节点)
Property recParty As BILL.EINV.DTO.HNA.InvoiceRecParty(CAPTION = "开票单位");

/// 交款人(节点)
Property payerParty As BILL.EINV.DTO.HNA.InvoicePayerParty(CAPTION = "交款人");

Property payMode As %String(CAPTION = "交款方式");

Property checkNumber As %String(CAPTION = "支票号");

Property currencyType As %String(CAPTION = "货币种类");

Property exchangeRate As %String(CAPTION = "汇率");

Property remark As %String(CAPTION = "其他信息");

Property handlingPerson As %String(CAPTION = "开票人");

Property checker As %String(CAPTION = "复核人");

Property supervisorRemark As %String(CAPTION = "财政部门备注");

/// 扩展信息(节点)
Property mainExt As BILL.EINV.DTO.HNA.InvoiceMainExt(CAPTION = "扩展信息");

/// 开票单位印章(节点)
Property recPartySeal As BILL.EINV.DTO.HNA.InvoiceRecPartySeal(CAPTION = "开票单位印章");

/// 票面明细信息
Property detail As list Of BILL.EINV.DTO.HNA.InvoiceListDetail(CAPTION = "票面明细信息");

}
