/// 获取电子票据文件返回结果对象
Class BILL.EINV.DTO.FSA.EInvoiceMegRes Extends %RegisteredObject
{

Property einvoicename As %String(CAPTION = "电子票据名称");

Property einvoicecode As %String(CAPTION = "电子票据代码");

Property einvoicenumber As %String(CAPTION = "电子票据号码");

Property bizcode As %String(CAPTION = "业务流水号");

Property payerpartyname As %String(CAPTION = "交款人");

Property randomnumber As %String(CAPTION = "校验码");

/// 开票日期yyyymmdd
Property writedate As %String(CAPTION = "开票日期");

/// 电子票据格式 1：png（默认）2：pdf3：ofd（暂无）
Property billfiletype As %String(CAPTION = "电子票据格式");

Property einvoicefilename As %String(CAPTION = "文件名称");

Property einvoicefile As %String(CAPTION = "文件");

}
