/// 票据种类查询 返回值
Class BILL.EINV.DTO.JSB.EInvQueryTypeRes Extends %RegisteredObject
{

/// 响应代码，00000：成功其他：失败
Property result As %String(CAPTION = "响应代码");

Property infomation As %String(CAPTION = "响应消息");

/// 票据种类数量，结果代码成功时必填
Property count As %String(CAPTION = "票据种类数量");

Property invoicetypelist As list Of BILL.EINV.DTO.JSB.EInvInvoiceTypelist(CAPTION = "票据种类列表");

}
