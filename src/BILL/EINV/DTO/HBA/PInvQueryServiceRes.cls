/// 发票单张查询返回值对象
Class BILL.EINV.DTO.HBA.PInvQueryServiceRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property service As BILL.EINV.DTO.HBA.PInvQueryComDataRes(CAPTION = "发票请求唯一流水号", XMLNAME = "service");

}
