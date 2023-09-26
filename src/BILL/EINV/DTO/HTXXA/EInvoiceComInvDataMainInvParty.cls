/// 开票信息开票单位
Class BILL.EINV.DTO.HTXXA.EInvoiceComInvDataMainInvParty Extends (%RegisteredObject, %XML.Adaptor)
{

Property InvoicingPartyCode As %String(CAPTION = "开票单位代码", XMLPROJECTION = "ELEMENT");

Property InvoicingPartyName As %String(CAPTION = "开票单位名称", XMLPROJECTION = "ELEMENT");

Property RecName As %String(CAPTION = "收款人全称", XMLPROJECTION = "ELEMENT");

Property RecAcct As %String(CAPTION = "收款人账号", XMLPROJECTION = "ELEMENT");

Property RecOpBk As %String(CAPTION = "收款人开户行", XMLPROJECTION = "ELEMENT");

}
