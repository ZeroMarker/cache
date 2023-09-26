Class BILL.EINV.DTO.JSA.InvoiceTradeInfo Extends %RegisteredObject
{

Property accountpay As %String(CAPTION = "个人账户支付金额", XMLNAME = "account_pay");

Property fundpay As %String(CAPTION = "医保统筹基金支付金额", XMLNAME = "fund_pay");

Property otherfundpay As %String(CAPTION = "其它医保支付金额", XMLNAME = "otherfund_pay");

Property ownpay As %String(CAPTION = "自费金额", XMLNAME = "own_pay");

Property cashpay As %String(CAPTION = "现金预交款金额", XMLNAME = "cash_pay");

Property chequepay As %String(CAPTION = "支票预交款金额", XMLNAME = "cheque_pay");

Property transferaccountpay As %String(CAPTION = "转账预交款金额", XMLNAME = "transfer_account_pay");

Property cashrecharge As %String(CAPTION = "补交金额(现金)", XMLNAME = "cash_recharge");

Property chequerecharge As %String(CAPTION = "补交金额(支票)", XMLNAME = "cheque_recharge");

Property transferrecharge As %String(CAPTION = "补交金额（转账）", XMLNAME = "transfer_recharge");

Property cashrefund As %String(CAPTION = "退还金额(现金)", XMLNAME = "cash_refund");

Property chequerefund As %String(CAPTION = "退交金额(支票)", XMLNAME = "cheque_refund");

Property transferrefund As %String(CAPTION = "退交金额(转账)", XMLNAME = "transfer_refund");

Property acctBalance As %String(CAPTION = "个人账户余额", XMLNAME = "acct_Balance");

Property paychannellist As list Of BILL.EINV.DTO.JSA.InvoicePaychannelList(CAPTION = "补交金额（转账）", XMLNAME = "pay_channel_list");

}
