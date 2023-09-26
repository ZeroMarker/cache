/// 发票查询外部报文
Class BILL.EINV.DTO.BWA.ESearchInvOutMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property body As BILL.EINV.DTO.BWA.ESearchOutMsgBody(XMLPROJECTION = "ELEMENT");

}
