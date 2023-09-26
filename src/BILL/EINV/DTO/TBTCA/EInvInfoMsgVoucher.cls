Class BILL.EINV.DTO.TBTCA.EInvInfoMsgVoucher Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 电子票据代码
Property EbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

}
