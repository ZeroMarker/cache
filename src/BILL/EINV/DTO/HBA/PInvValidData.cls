Class BILL.EINV.DTO.HBA.PInvValidData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property record As BILL.EINV.DTO.HBA.PInvValidRecordInfo(CAPTION = "记录数据", XMLNAME = "record");

}
