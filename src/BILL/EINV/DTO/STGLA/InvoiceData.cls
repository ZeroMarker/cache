Class BILL.EINV.DTO.STGLA.InvoiceData Extends %RegisteredObject
{

Property datamain As BILL.EINV.DTO.STGLA.InvoiceDataMain(CAPTION = "开票信息");

Property datadetails As list Of BILL.EINV.DTO.STGLA.InvoiceDataDetails(CAPTION = "开票分类明细");

Property dataauxdetails As list Of BILL.EINV.DTO.STGLA.InvoiceDataAuxdetails(CAPTION = "开票费用明细");

}
