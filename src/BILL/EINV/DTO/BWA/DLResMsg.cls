Class BILL.EINV.DTO.BWA.DLResMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property returnCode As %String(XMLPROJECTION = "ELEMENT");

Property returnMsg As %String(XMLPROJECTION = "ELEMENT");

Property DLResComXX As BILL.EINV.DTO.BWA.DLResComFPXXS(XMLPROJECTION = "ELEMENT");

}
