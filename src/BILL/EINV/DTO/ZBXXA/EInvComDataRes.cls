/// 电子票据开票公共返回值
Class BILL.EINV.DTO.ZBXXA.EInvComDataRes Extends %RegisteredObject
{

/// 接口标识	入	String	见本文中的“接口标识”
Property ifResult As %String(CAPTION = "接口处理结果");

Property ifWarning As %String(CAPTION = "接口警告详细信息");

Property ifError As %String(CAPTION = "接口错误详细信息");

Property ifErrorStack As %String(CAPTION = "接口错误异常信息");

Property ifResultInfo As %String(CAPTION = "接口返回信息");

}
