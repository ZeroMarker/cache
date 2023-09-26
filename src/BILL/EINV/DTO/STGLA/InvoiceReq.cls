/// 赛通港联电子票据开具接口入参组织对象
Class BILL.EINV.DTO.STGLA.InvoiceReq Extends %RegisteredObject
{

/// 票据基础信息
Property METHOD As %String(CAPTION = "请求方法名称");

Property DWID As %String(CAPTION = "单位ID");

Property LX As %String(CAPTION = "开票类型");

Property ND As %String(CAPTION = "年度");

Property YWLSH As %String(CAPTION = "业务受理号");

Property YWRQ As %String(CAPTION = "业务日期");

Property KPDBM As %String(CAPTION = "开票点编码");

Property YWLX As %String(CAPTION = "业务类型");

Property PJHM As %String(CAPTION = "发票号码");

/// 开票明细
Property DATA As BILL.EINV.DTO.STGLA.InvoiceData(CAPTION = "开票明细");

}
