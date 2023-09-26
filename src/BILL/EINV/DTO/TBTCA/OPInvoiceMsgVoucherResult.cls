Class BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherResult Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

/// 电子票据代码
Property EbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 校验码
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

/// 医保结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 结算号
Property SettlementNo As %String(XMLPROJECTION = "ELEMENT");

/// 错误代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 错误描述
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
