/// 阳光保险开票返回值
Class BILL.EINV.DTO.YGBX.EInvoiceRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票金额的概要总括信息
Property PACKET As BILL.EINV.DTO.YGBX.EInvoicePACKETRes(XMLNAME = "PACKET", XMLPROJECTION = "ELEMENT");

}
