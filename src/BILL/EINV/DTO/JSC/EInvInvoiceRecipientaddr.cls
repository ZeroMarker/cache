/// 票据开具后的寄送\通知目的
Class BILL.EINV.DTO.JSC.EInvInvoiceRecipientaddr Extends %RegisteredObject
{

Property email As %String(CAPTION = "通知邮件地址");

Property telephone As %String(CAPTION = "通知人电话");

/// 如果使用支付宝结算，填写支付宝UserID，用于支付宝电子票据管家
Property alipaycode As %String(CAPTION = "支付宝电子票据管家", XMLNAME = "alipay_code");

/// 如果使用微信结算，填写微信订单号，用于发微信服务通知
Property wechatorderno As %String(CAPTION = "微信订单号", XMLNAME = "wechat_orderno");

}
