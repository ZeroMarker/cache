Class BILL.EINV.DTO.YGBX.EInvoiceQueryRes Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票金额的概要总括信息
Property PACKET As BILL.EINV.DTO.YGBX.EInvoicePACKETQueryRes(XMLNAME = "PACKET", XMLPROJECTION = "ELEMENT");

}
