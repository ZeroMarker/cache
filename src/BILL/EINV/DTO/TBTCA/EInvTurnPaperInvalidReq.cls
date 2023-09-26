Class BILL.EINV.DTO.TBTCA.EInvTurnPaperInvalidReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 电子票据代码
Property EbillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 电子票据号码
Property EbillNo As %String(XMLPROJECTION = "ELEMENT");

/// 结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 作废原因
Property Reason As %String(XMLPROJECTION = "ELEMENT");

/// 作废人
Property CancellMan As %String(XMLPROJECTION = "ELEMENT");

/// 作废时间 yyyyMMddhhmmssSSS
Property CancellTime As %String(XMLPROJECTION = "ELEMENT");

/// 纸票是否遗失 (0:否  1:是)
Property IsLost As %String(XMLPROJECTION = "ELEMENT");

}
