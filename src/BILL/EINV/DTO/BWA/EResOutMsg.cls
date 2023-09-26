Class BILL.EINV.DTO.BWA.EResOutMsg Extends %RegisteredObject
{

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property ResComFPKJ As BILL.EINV.DTO.BWA.EResComFPKJ(XMLNAME = "RESPONSE_COMMON_FPKJ", XMLPROJECTION = "ELEMENT");

}
