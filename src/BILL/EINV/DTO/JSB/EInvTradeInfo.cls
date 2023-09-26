/// 开票收费信息
Class BILL.EINV.DTO.JSB.EInvTradeInfo Extends %RegisteredObject
{

Property "account_pay" As %String(CAPTION = "医保个人账户支付金额");

Property "fund_pay" As %String(CAPTION = "医保统筹基金支付金额");

Property "otherfund_pay" As %String(CAPTION = "其它医保支付金额");

Property "own_pay" As %String(CAPTION = "自费金额");

Property "cash_pay" As %String(CAPTION = "现金预交款金额");

Property "cheque_pay" As %String(CAPTION = "支票预交款金额");

Property "transfer_account_pay" As %String(CAPTION = "转账预交款金额");

Property "cash_recharge" As %String(CAPTION = "补交金额(现金)");

Property "cheque_recharge" As %String(CAPTION = "补交金额(支票)");

Property "transfer_recharge" As %String(CAPTION = "补交金额（转账)");

Property "cash_refund" As %String(CAPTION = "退交金额(现金)");

Property "cheque_refund" As %String(CAPTION = "退交金额(支票)");

Property "transfer_refund" As %String(CAPTION = "支票预交款金额");

Property "acct_Balance" As %String(CAPTION = "个人账户余额");

Property "pay_channel_list" As list Of BILL.EINV.DTO.JSB.EInvPayChannelList(CAPTION = "交费渠道列表");

}
