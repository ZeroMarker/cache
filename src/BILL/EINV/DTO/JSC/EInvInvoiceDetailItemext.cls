/// 明细信息扩展
Class BILL.EINV.DTO.JSC.EInvInvoiceDetailItemext Extends %RegisteredObject
{

/// 自费金额，如果无自费，填0
Property selfamt As %String(CAPTION = "自费金额", XMLNAME = "self_amt");

Property remark As %String(CAPTION = "备注信息");

}
