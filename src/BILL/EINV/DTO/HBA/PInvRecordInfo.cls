Class BILL.EINV.DTO.HBA.PInvRecordInfo Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property fp As BILL.EINV.DTO.HBA.PInvFPInfo(CAPTION = "发票信息", XMLNAME = "fp");

Property group As BILL.EINV.DTO.HBA.PInvFPGroup(CAPTION = "发票信息明细信息");

}
