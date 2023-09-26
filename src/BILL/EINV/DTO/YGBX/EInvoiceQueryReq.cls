/// 发票查询接口参数
Class BILL.EINV.DTO.YGBX.EInvoiceQueryReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

/// 发票金额的概要总括信息
Property PACKET As BILL.EINV.DTO.YGBX.EInvoicePACKETQueryReq(XMLNAME = "PACKET", XMLPROJECTION = "ELEMENT");

}
