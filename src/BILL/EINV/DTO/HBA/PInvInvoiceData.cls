/// 开具参数
Class BILL.EINV.DTO.HBA.PInvInvoiceData Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property count As %String(XMLPROJECTION = "ATTRIBUTE");

Property record As BILL.EINV.DTO.HBA.PInvRecordInfo(CAPTION = "记录数据", XMLNAME = "record");

}
