/// 开具纸质票据返回值对象
Class BILL.EINV.DTO.HBA.PInvInvoiceServiceRes Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Property service As BILL.EINV.DTO.HBA.PInvInvoiceComDataRes(CAPTION = "发票请求唯一流水号", XMLNAME = "service");

}
