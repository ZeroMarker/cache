/// 赛通港联电子票据开具接口出参组织对象
Class BILL.EINV.DTO.STGLA.InvoiceRes Extends %RegisteredObject
{

Property FPHM As %String(CAPTION = "发票号码");

Property FPDM As %String(CAPTION = "发票代码");

Property KPXXID As %String(CAPTION = "开票信息ID");

Property EWMURL As %String(CAPTION = "Pdf文件二维码路径");

Property PDFURL As %String(CAPTION = "Pdf文件下载地址");

}
