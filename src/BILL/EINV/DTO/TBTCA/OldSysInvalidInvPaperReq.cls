Class BILL.EINV.DTO.TBTCA.OldSysInvalidInvPaperReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 票据代码
Property BillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 票据号码
Property BillNo As %String(XMLPROJECTION = "ELEMENT");

/// 结算号
Property InsuranceSettleNo As %String(XMLPROJECTION = "ELEMENT");

/// 作废原因
Property Reason As %String(XMLPROJECTION = "ELEMENT");

/// 作废人
Property CancellMan As %String(XMLPROJECTION = "ELEMENT");

/// 作废时间
Property CancellTime As %String(XMLPROJECTION = "ELEMENT");

/// 操作类型
Property OperType As %String(XMLPROJECTION = "ELEMENT");

}
