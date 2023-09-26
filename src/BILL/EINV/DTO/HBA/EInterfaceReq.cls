Class BILL.EINV.DTO.HBA.EInterfaceReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLNAME = "interface";

Property globalInfo As BILL.EINV.DTO.HBA.EInvGlobalReq(CAPTION = "全局信息", XMLNAME = "globalInfo");

Property returnStateInfo As BILL.EINV.DTO.HBA.EInvReturnReq(CAPTION = "返回信息", XMLNAME = "returnStateInfo");

Property Data As BILL.EINV.DTO.HBA.EInvDataReq(CAPTION = "交换数据", XMLNAME = "Data");

}
