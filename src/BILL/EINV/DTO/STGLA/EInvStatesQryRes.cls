Class BILL.EINV.DTO.STGLA.EInvStatesQryRes Extends %RegisteredObject
{

Property Message As BILL.EINV.DTO.STGLA.EInvStatesMessage(CAPTION = "响应报文");

Property BillBatchCode As %String(CAPTION = "电子票据代码");

Property BillNo As %String(CAPTION = "电子票据号码");

Property BillPdfAddr As %String(CAPTION = "二维码预览地址");

}
