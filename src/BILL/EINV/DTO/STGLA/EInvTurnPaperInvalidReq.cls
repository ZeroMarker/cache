/// 4.2.4作废纸质票据入参请求对象
Class BILL.EINV.DTO.STGLA.EInvTurnPaperInvalidReq Extends %RegisteredObject
{

Property METHOD As %String(CAPTION = "请求方法名称");

Property DWID As %String(CAPTION = "单位ID");

Property ID As %String(CAPTION = "开票信息ID");

Property YWLSH As %String(CAPTION = "业务流水号");

Property PJDM As %String(CAPTION = "票据代码");

Property PJHM As %String(CAPTION = "票据号码");

Property ZFZZPJDM As %String(CAPTION = "作废纸质票据代码");

Property ZFZZPJHM As %String(CAPTION = "作废纸质票据号码");

Property ZFYY As %String(CAPTION = "作废原因");

}
