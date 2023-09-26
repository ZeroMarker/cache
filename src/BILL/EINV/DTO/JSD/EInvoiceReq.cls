/// 江苏宿迁钟吾中医院电子发票接口（江苏百旺）
Class BILL.EINV.DTO.JSD.EInvoiceReq Extends %RegisteredObject
{

Property accesstoken As %String(CAPTION = "用户token", XMLNAME = "access_token");

Property serviceKey As %String(CAPTION = "应用接口");

Property data As BILL.EINV.DTO.JSD.EInvoiceData(CAPTION = "数据");

}
