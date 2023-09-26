Class BILL.EINV.DTO.HBA.PInvQueryData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property record As list Of BILL.EINV.DTO.HBA.PInvQueryRecordInfo(CAPTION = "记录数据", XMLNAME = "record");

}
