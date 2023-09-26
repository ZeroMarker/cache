/// 预交金明细信息
Class BILL.EINV.DTO.COM.IPPreDepositInfo Extends %RegisteredObject
{

///  预交金凭证消费金额
Property voucherAmt As %String(CAPTION = "预交金凭证消费金额");

/// 预交金凭证代码
Property voucherBatchCode As %String(CAPTION = "预交金凭证代码");

///  预交金凭证号码
Property voucherNo As %String(CAPTION = "预交金凭证号码");

}
