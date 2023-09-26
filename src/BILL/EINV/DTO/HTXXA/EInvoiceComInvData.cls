/// 开票请求参数
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvData Extends (%RegisteredObject, %XML.Adaptor)
{

Property Main As BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMain(XMLNAME = "Main", XMLPROJECTION = "ELEMENT");

Property Details As list Of BILL.EINV.DTO.HTXXA.EInvoiceComInvDataDetails(XMLNAME = "Details", XMLPROJECTION = "ELEMENT");

Property AuxDetails As list Of BILL.EINV.DTO.HTXXA.EInvoiceComInvDataAuxDetails(XMLNAME = "AuxDetails", XMLPROJECTION = "ELEMENT");

}
