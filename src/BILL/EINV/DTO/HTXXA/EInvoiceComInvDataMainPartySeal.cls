/// 开票单位印章
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainPartySeal Extends (%RegisteredObject, %XML.Adaptor)
{

Property SealId As %String(CAPTION = "印章编号", XMLPROJECTION = "ELEMENT");

Property SealName As %String(CAPTION = "印章名称", XMLPROJECTION = "ELEMENT");

Property SealHash As %String(CAPTION = "印章Hash", XMLPROJECTION = "ELEMENT");

}
