/// 电子发票换纸质发票入参组织对象
Class BILL.EINV.DTO.FSA.EInvTurnPaperReq Extends %RegisteredObject
{

Property bizcode As %String(CAPTION = "业务流水号");

Property einvoicecode As %String(CAPTION = "电子票据代码");

Property einvoicenumber As %String(CAPTION = "电子票据号码");

Property billcode As %String(CAPTION = "纸质票据代码");

Property billnumber As %String(CAPTION = "纸质票据号码");

Property remark As %String(CAPTION = "测试代码");

}
