Class BILL.EINV.DTO.TBTCA.OPEInvTurnPaperBillInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

/// 纸质票据号码
Property BillNo As %String(XMLPROJECTION = "ELEMENT");

/// 纸质票据代码
Property BillBatchCode As %String(XMLPROJECTION = "ELEMENT");

/// 开票时间
Property BillingTime As %String(XMLPROJECTION = "ELEMENT");

/// 页码
Property PageNumber As %String(XMLPROJECTION = "ELEMENT");

/// 收费项目大类明细
Property Details As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetails(XMLPROJECTION = "ELEMENT");

/// 辅助明细信息
Property AuxDetails As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxDetails(XMLPROJECTION = "ELEMENT");

}
