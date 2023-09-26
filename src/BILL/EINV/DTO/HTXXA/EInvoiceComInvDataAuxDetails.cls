/// 辅助明细信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataAuxDetails Extends (%RegisteredObject, %XML.Adaptor)
{

Property AuxItem As list Of BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailAuxItem(XMLNAME = "AuxItem", XMLPROJECTION = "ELEMENT");

}
