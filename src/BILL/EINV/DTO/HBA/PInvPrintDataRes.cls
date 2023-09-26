Class BILL.EINV.DTO.HBA.PInvPrintDataRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property refp As list Of BILL.EINV.DTO.HBA.PInvPrintRefpInfo(CAPTION = "记录数据", XMLNAME = "refp");

}
