Class BILL.EINV.DTO.PGA.EInvResultRes Extends %RegisteredObject
{

/// 	0失败 1成功
Property code As %String(CAPTION = "响应状态码");

Property message As %String(CAPTION = "响应状态");

Property data As %String(CAPTION = "响应结果信息");

Property frontServiceName As %String(CAPTION = "前置服务提供方");

Property mode As %String(CAPTION = "当前开票模式");

}
