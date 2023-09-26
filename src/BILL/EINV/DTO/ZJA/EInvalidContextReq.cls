/// 作废票据请求参数
Class BILL.EINV.DTO.ZJA.EInvalidContextReq Extends %RegisteredObject
{

/// 开票日期
Property kprq As %String(XMLPROJECTION = "ELEMENT");

/// 发票代码
Property fpdm As %String(XMLPROJECTION = "ELEMENT");

/// 发票号码
Property fphm As %String(XMLPROJECTION = "ELEMENT");

/// 发票金额
Property hj As %String(XMLPROJECTION = "ELEMENT");

}
