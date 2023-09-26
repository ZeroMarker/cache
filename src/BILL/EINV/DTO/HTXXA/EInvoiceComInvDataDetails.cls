/// 开票明细对象信息
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetails Extends (%RegisteredObject, %XML.Adaptor)
{

Property Item As list Of BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetailItem(XMLNAME = "Item", XMLPROJECTION = "ELEMENT");

}
