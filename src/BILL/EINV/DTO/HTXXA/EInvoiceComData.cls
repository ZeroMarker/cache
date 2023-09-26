/// 开票参数
Class BILL.EINV.DTO.HTXXA.EInvoiceComData Extends (%RegisteredObject, %XML.Adaptor)
{

Property Header As BILL.EINV.DTO.HTXXA.EInvoiceComDataHeader(XMLNAME = "Header", XMLPROJECTION = "ELEMENT");

Property EInvoiceData As BILL.EINV.DTO.HTXXA.EInvoiceComInvData(XMLNAME = "EInvoiceData", XMLPROJECTION = "ELEMENT");

Property EInvoiceSignature As BILL.EINV.DTO.HTXXA.EInvoiceEInvoiceSignature(XMLNAME = "EInvoiceSignature", XMLPROJECTION = "ELEMENT");

}
