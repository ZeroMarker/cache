Class BILL.EINV.DTO.PGA.EInvPrintReq Extends %RegisteredObject
{

Property ivcCode As %String(CAPTION = "发票代码");

Property ivcNo As %String(CAPTION = "发票号码");

Property checkCode As %String(CAPTION = "发票校验码");

/// 1 pdf 2 jpg ,默认1
Property format As %String(CAPTION = "格式");

}
