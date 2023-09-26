Class BILL.EINV.DTO.HBA.PInvQueryDataRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property refp As list Of BILL.EINV.DTO.HBA.PInvQueryRefpInfo(CAPTION = "记录数据", XMLNAME = "refp");

}
