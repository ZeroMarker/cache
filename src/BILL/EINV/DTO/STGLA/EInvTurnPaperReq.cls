/// 4.2.3换开纸质票据入参请求对象
Class BILL.EINV.DTO.STGLA.EInvTurnPaperReq Extends %RegisteredObject
{

Property METHOD As %String(CAPTION = "请求方法名称");

Property DWID As %String(CAPTION = "单位ID");

Property ID As %String(CAPTION = "开票信息ID");

Property YWLSH As %String(CAPTION = "业务流水号");

Property PJDM As %String(CAPTION = "票据代码");

Property PJHM As %String(CAPTION = "票据号码");

Property HKZZPJDM As %String(CAPTION = "换开纸质票据代码");

Property HKZZPJHM As %String(CAPTION = "换开纸质票据号码");

}
