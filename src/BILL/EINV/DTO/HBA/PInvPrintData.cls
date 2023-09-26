/// 打印记录数据
Class BILL.EINV.DTO.HBA.PInvPrintData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property record As BILL.EINV.DTO.HBA.PInvPrintRecordInfo(CAPTION = "记录数据", XMLNAME = "record");

}
