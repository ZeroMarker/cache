/// 获取电子票据文件入参对象
Class BILL.EINV.DTO.FSA.EGetInvoiceReq Extends %RegisteredObject
{

Property bizcode As %String(CAPTION = "业务流水号");

Property einvoicecode As %String(CAPTION = "电子票据代码");

Property einvoicenumber As %String(CAPTION = "电子票据号码");

Property randomnumber As %String(CAPTION = "校验码");

Property payerpartyname As %String(CAPTION = "交款人");

/// 开票日期 yyyymmdd
Property writedate As %String(CAPTION = "开票日期");

/// 电子票据格式 1：png（默认）2：pdf 3：ofd（暂无）
Property billfiletype As %String(CAPTION = "电子票据格式");

/// 备注
Property remark As %String(CAPTION = "备注");

}
