/// 发票查询xml对象
Class BILL.EINV.DTO.BWA.SearchInMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property body As BILL.EINV.DTO.BWA.SearchInvBody(XMLPROJECTION = "ELEMENT");

}
