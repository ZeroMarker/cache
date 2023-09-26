Class BILL.EINV.DTO.TBTCA.BlankPaperInvalidReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 纸质票据号码
Property BillNo As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据号码(结束号码)
Property BillNoEnd As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据代码
Property BillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 作废原因
Property Reason As %String(XMLPROJECTION = "ELEMENT");

/// 作废人
Property CancellMan As %String(XMLPROJECTION = "ELEMENT");

/// 作废时间
Property CancellTime As %String(XMLPROJECTION = "ELEMENT");

/// 是否遗失(0:否  1:是)
Property IsLost As %String(XMLPROJECTION = "ELEMENT");

/// 票据来源(0：HIS 系统,1：电票系统初始化信息)
Property BillSource As %String(XMLPROJECTION = "ELEMENT");

}
