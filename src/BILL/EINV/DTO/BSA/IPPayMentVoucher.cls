/// 住院预交金明细列表
Class BILL.EINV.DTO.BSA.IPPayMentVoucher Extends %RegisteredObject
{

/// voucherBatchCode 预交金凭证代码
Property voucherBatchCode As %String(TRUNCATE = 1, XMLNAME = "voucherBatchCode");

/// voucherNo 预交金凭证号码
Property voucherNo As %String(TRUNCATE = 1, XMLNAME = "voucherNo");

/// amt 预交金凭证消费金额
Property voucherAmt As %String(TRUNCATE = 1, XMLNAME = "voucherAmt");

}
