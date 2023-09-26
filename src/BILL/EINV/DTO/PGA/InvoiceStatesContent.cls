Class BILL.EINV.DTO.PGA.InvoiceStatesContent Extends %RegisteredObject
{

Property MainContent As %String(CAPTION = "票据文件");

Property BillPdfAddr As %String(CAPTION = "二维码预览地址");

Property EinvoiceDetailCount As %String(CAPTION = "收费明细文件个数");

Property IssueDate As %String(CAPTION = "开票日期");

Property IssueTime As %String(CAPTION = "开票时间");

Property PlatformCheckUrl As %String(CAPTION = "平台核验地址");

}
