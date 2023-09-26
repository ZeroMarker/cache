/// 单张票据查询
Class BILL.EINV.DTO.JSB.EInvQueryOnlyReq Extends %RegisteredObject
{

Property method As %String(CAPTION = "方法名");

Property "channel_code" As %String(CAPTION = "渠道编码", XMLNAME = "channel_code");

Property "org_code" As %String(CAPTION = "机构编码", XMLNAME = "org_code");

/// 请求时间，格式：yyyyMMddHHmmss
Property timestamp As %String(CAPTION = "秘钥");

/// MD5(method+timestamp+   分  配   的accessKey)
Property sign As %String(CAPTION = "秘钥");

Property "invoice_code" As %String(CAPTION = "票据代码");

Property "invoice_number" As %String(CAPTION = "票据号码");

}
