/// 获取token返回值对象
Class BILL.EINV.DTO.JSD.EInvTokenRes Extends %RegisteredObject
{

/// 用操作结果描述
Property msg As %String(CAPTION = "操作结果描述");

/// 操作结果;SUCCESS=成功,ERROR=失败
Property result As %String(CAPTION = "操作结果");

Property rows As BILL.EINV.DTO.JSD.EInvTokenRows(CAPTION = "操作结果");

}
