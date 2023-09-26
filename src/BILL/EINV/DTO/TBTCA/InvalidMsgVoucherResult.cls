Class BILL.EINV.DTO.TBTCA.InvalidMsgVoucherResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

/// 红票票据编码
Property CancelEbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 红票票据号码
Property CancelEbillNo As %String(XMLPROJECTION = "ELEMENT");

}
