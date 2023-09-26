/// 航天信息电子发票开票入参
Class BILL.EINV.DTO.HTXXA.EInvoiceReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EIFeiMakeRequest";

Property EInvoice As BILL.EINV.DTO.HTXXA.EInvoiceComData(XMLNAME = "EInvoice", XMLPROJECTION = "ELEMENT");

Property EInvoiceExt As BILL.EINV.DTO.HTXXA.EInvoiceComDataExt(XMLNAME = "EInvoiceExt", XMLPROJECTION = "ELEMENT");

}
