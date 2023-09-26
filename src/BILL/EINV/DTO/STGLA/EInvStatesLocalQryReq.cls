/// 4.2.7开票结果查询（本地）请求入参对象
Class BILL.EINV.DTO.STGLA.EInvStatesLocalQryReq Extends %RegisteredObject
{

Property METHOD As %String(CAPTION = "请求方法名称");

Property DWID As %String(CAPTION = "单位ID");

Property ID As %String(CAPTION = "开票信息ID");

Property CXPJLX As %String(CAPTION = "查询票据类型");

Property YWLSH As %String(CAPTION = "业务流水号");

}
