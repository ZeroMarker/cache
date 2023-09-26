/// 赛通港联电子票据冲红接口入参组织对象
Class BILL.EINV.DTO.STGLA.InvalidReq Extends %RegisteredObject
{

Property METHOD As %String(CAPTION = "请求方法名称");

Property DWID As %String(CAPTION = "单位ID");

Property LX As %String(CAPTION = "开票类型");

Property ND As %String(CAPTION = "年度");

Property YWLSH As %String(CAPTION = "业务受理号");

Property YWRQ As %String(CAPTION = "业务日期");

Property KPDBM As %String(CAPTION = "开票点编码");

Property HCYY As %String(CAPTION = "红冲原因");

Property YWLX As %String(CAPTION = "业务类型");

}
