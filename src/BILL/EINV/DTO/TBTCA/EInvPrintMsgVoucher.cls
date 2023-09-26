Class BILL.EINV.DTO.TBTCA.EInvPrintMsgVoucher Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 单位代码
Property AgencyCode As %String(XMLPROJECTION = "ELEMENT");

/// 单位名称
Property AgencyName As %String(XMLPROJECTION = "ELEMENT");

/// 电 子 票 据代码
Property EInvoiceCode As %String(XMLPROJECTION = "ELEMENT");

/// 电 子 票 据号码
Property EInvoiceNumber As %String(XMLPROJECTION = "ELEMENT");

/// 校验码
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

}
