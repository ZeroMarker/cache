Class BILL.EINV.DTO.XYHA.IPInvoiceContent Extends %RegisteredObject
{

Property main As BILL.EINV.DTO.XYHA.IPInvoiceMain(CAPTION = "票据信息");

Property details As list Of BILL.EINV.DTO.XYHA.IPInvoiceDetails(CAPTION = "费用分类");

Property auxdetails As list Of BILL.EINV.DTO.XYHA.IPInvoiceAuxDetails(CAPTION = "费用明细");

}
