Class BILL.EINV.DTO.TBTCA.EInvPrintVoucherResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 电子票据代码
Property EInvoiceCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EInvoiceNumber As %String(XMLPROJECTION = "ELEMENT");

/// 校验码
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

/// 财政电子票据板式文件
Property EInvoiceLayoutFile As %String(MAXLEN = 999999, XMLPROJECTION = "ELEMENT");

/// 格式
Property Format As %String(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
