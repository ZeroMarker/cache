Class BILL.EINV.DTO.XYHA.OPInvoiceContent Extends %RegisteredObject
{

Property main As BILL.EINV.DTO.XYHA.OPInvoiceMain(CAPTION = "票据信息");

Property details As list Of BILL.EINV.DTO.XYHA.OPInvoiceDetails(CAPTION = "费用分类");

Property auxdetails As list Of BILL.EINV.DTO.XYHA.OPInvoiceAuxDetails(CAPTION = "费用明细");

}
