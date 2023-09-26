/// 发票明细分组
Class BILL.EINV.DTO.HBA.PInvFPGroup Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Property fpmx As list Of BILL.EINV.DTO.HBA.PInvFPGroupFpmxInfo(CAPTION = "发票明细", XMLPROJECTION = "ELEMENT");

}
