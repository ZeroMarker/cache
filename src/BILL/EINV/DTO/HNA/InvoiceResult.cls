Class BILL.EINV.DTO.HNA.InvoiceResult Extends %RegisteredObject
{

Property sysCode As %String(CAPTION = "系统标识");

Property ivcCode As %String(CAPTION = "票据代码");

Property bizCode As %String(CAPTION = "业务流水号");

Property ivcNumber As %String(CAPTION = "票据号码");

Property state As %Integer(CAPTION = "完成状态");

Property ivcWebUrl As %String(CAPTION = "财政厅票据展示地址");

Property pdfUrl As %String(CAPTION = "票据pdf下载地址");

Property pdfQr As %String(CAPTION = "票据下载二维码");

Property "pdfUrl_nw" As %String(CAPTION = "票据下载二维码内网");

}
