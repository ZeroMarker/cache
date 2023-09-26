Class BILL.EINV.DTO.JSD.EInvTokenRows Extends %RegisteredObject
{

/// 凭证有效时间，单位：秒(默认7200秒，可能会存在网络延迟，波动等，以实际时间为准)
Property expirein As %String(CAPTION = "凭证有效时间", XMLNAME = "expire_in");

/// 操作结果;SUCCESS=成功,ERROR=失败
Property accesstoken As %String(CAPTION = "获取到的凭证", XMLNAME = "access_token");

}
