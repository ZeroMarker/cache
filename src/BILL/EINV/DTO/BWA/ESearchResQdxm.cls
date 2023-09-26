Class BILL.EINV.DTO.BWA.ESearchResQdxm Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property group As BILL.EINV.DTO.BWA.ESearchResQdxmGrp(XMLPROJECTION = "ELEMENT");

}
