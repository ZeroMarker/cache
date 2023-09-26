Class BILL.EINV.DTO.YGBX.EInvoiceDataBodyUL Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "InvoiceInfos";

Property InvoiceInfos As BILL.EINV.DTO.YGBX.EInvoiceDataBodyInvoiceInfosUL(XMLNAME = "InvoiceInfos", XMLPROJECTION = "ELEMENT");

}
