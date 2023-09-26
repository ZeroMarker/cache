Class BILL.EINV.DTO.HBA.PInvStockDataRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property refp As list Of BILL.EINV.DTO.HBA.PInvRefpInfo(CAPTION = "记录数据", XMLNAME = "refp");

}
