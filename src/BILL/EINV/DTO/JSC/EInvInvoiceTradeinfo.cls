/// 收费信息
Class BILL.EINV.DTO.JSC.EInvInvoiceTradeinfo Extends %RegisteredObject
{

/// 个人账户支付金额，即医疗保险个人账户支出
Property accountpay As %String(CAPTION = "个人账户支付金额", XMLNAME = "account_pay");

/// 医保统筹基金支付金额，即医疗保险统筹基金支付。指职工基本医疗保险、城镇居发基本医疗保险、
/// 新型农村合作医疗、其它医疗保险等按有关规定在医疗保险统筹基金支付范围以内，并在起付标准以上、
/// 最高支付限额以下由医疗保险统筹基金支付的费用；
Property fundpay As %String(CAPTION = "医保统筹基金", XMLNAME = "fund_pay");

Property otherfundpay As %String(CAPTION = "其它医保支付金额", XMLNAME = "otherfund_pay");

/// 自费金额，患者就诊过程中所发生的医疗保险政策范围外的药品、诊疗及医疗服务设施费用预缴金额；
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

Property paychannellist As BILL.EINV.DTO.JSC.EInvInvoicePaychannellist(CAPTION = "交费渠道列表", XMLNAME = "pay_channel_list");

}
