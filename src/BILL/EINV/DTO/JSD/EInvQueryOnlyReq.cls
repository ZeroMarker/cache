/// 电子发票单张查询
Class BILL.EINV.DTO.JSD.EInvQueryOnlyReq Extends %RegisteredObject
{

Property accesstoken As %String(CAPTION = "用户token", XMLNAME = "access_token");

Property serviceKey As %String(CAPTION = "应用接口");

Property data As BILL.EINV.DTO.JSD.EInvQueryOnlyData(CAPTION = "数据");

}
