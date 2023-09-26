/// 票据邮寄地址辅助信息
Class BILL.EINV.DTO.JSB.EInvDetailListAux Extends %RegisteredObject
{

Property email As %String(CAPTION = "通知邮件地址");

Property telephone As %String(CAPTION = "通知人电话");

/// 如 果 使 用 支 付 宝 结 算 ， 填 写 支 付 宝UserID，用于支付宝电子票据管家
Property "alipay_code" As %String(CAPTION = "支付宝结算ID");

/// 如果使用微信结算，填写微信订单号，用于发微信服务通知
Property "wechat_orderno" As %String(CAPTION = "微信结算ID");

}
