Class BILL.EINV.DTO.TBTCA.IPInvoiceMsgVoucher Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Voucher";

/// 主单信息
Property Main As BILL.EINV.DTO.TBTCA.IPInvoiceMsgVoucherMain;

/// 收费大类明细信息
Property Details As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherDetails;

/// 辅助明细信息/明细汇总信息
Property AuxDetails As BILL.EINV.DTO.TBTCA.OPInvoiceMsgVoucherAuxDetails;

}
