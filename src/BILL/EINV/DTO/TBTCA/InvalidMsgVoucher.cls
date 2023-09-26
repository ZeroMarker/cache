Class BILL.EINV.DTO.TBTCA.InvalidMsgVoucher Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 电子票据代码
Property EbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 医保结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 冲销原因
Property Reason As %String(XMLPROJECTION = "ELEMENT");

/// 冲销人
Property ChargeOfflMan As %String(XMLPROJECTION = "ELEMENT");

/// 冲销时间
Property ChargeOffTime As %String(XMLPROJECTION = "ELEMENT");

}
