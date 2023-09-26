Class BILL.EINV.DTO.HBA.PInvStockData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property record As BILL.EINV.DTO.HBA.PInvStockRecordInfo(CAPTION = "记录数据", XMLNAME = "record");

}
