Class BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxDetails Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

/// 辅助明细信息/明细汇总信息
Property AuxItem As list Of BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxItem(XMLPROJECTION = "ELEMENT");

}
