/// 作废发票XML对象
Class BILL.EINV.DTO.BWA.InvaildInvReqMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property body As BILL.EINV.DTO.BWA.InvaildInvBody(XMLPROJECTION = "ELEMENT");

}
