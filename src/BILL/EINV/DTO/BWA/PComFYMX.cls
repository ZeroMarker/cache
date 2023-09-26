Class BILL.EINV.DTO.BWA.PComFYMX Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property group As list Of BILL.EINV.DTO.BWA.PComFYMXGroup(XMLPROJECTION = "ELEMENT");

}
