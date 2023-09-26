Class BILL.EINV.DTO.TBTCA.EInvTurnPaperReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 电子票据代码
Property EbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据代码
Property BillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据号码
Property BillNo As %String(XMLPROJECTION = "ELEMENT");

/// 校验码
Property RandomNumber As %String(XMLPROJECTION = "ELEMENT");

/// 医保结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 换开来源
Property PrintSource As %String(XMLPROJECTION = "ELEMENT");

/// 换开时间
Property PrintTime As %String(XMLPROJECTION = "ELEMENT");

}
