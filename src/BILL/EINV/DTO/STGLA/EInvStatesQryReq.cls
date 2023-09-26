/// 4.2.6开票结果查询（远程）请求入参对象
Class BILL.EINV.DTO.STGLA.EInvStatesQryReq Extends %RegisteredObject
{

Property METHOD As %String(CAPTION = "请求方法名称");

Property DWID As %String(CAPTION = "单位ID");

Property ID As %String(CAPTION = "开票信息ID");

Property YWLSH As %String(CAPTION = "业务流水号");

Property PJDM As %String(CAPTION = "票据代码");

Property PJHM As %String(CAPTION = "票据号码");

}
