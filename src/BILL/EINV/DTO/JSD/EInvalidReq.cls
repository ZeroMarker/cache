/// 开红冲票入参对象
Class BILL.EINV.DTO.JSD.EInvalidReq Extends %RegisteredObject
{

Property accesstoken As %String(CAPTION = "用户token", XMLNAME = "access_token");

Property serviceKey As %String(CAPTION = "应用接口");

Property data As BILL.EINV.DTO.JSD.EInvalidData(CAPTION = "数据");

}
