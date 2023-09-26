/// 住院预交金电子票据红冲入参
Class BILL.EINV.DTO.BSA.PreDepositInvalidReq Extends %RegisteredObject
{

Property placeCode As %String(CAPTION = "开票点编码");

Property busNo As %String(CAPTION = "预交金业务流水号");

Property operator As %String(CAPTION = "经办人");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property visitNo As %String(CAPTION = "就诊号");

/// hospitalNo
Property hospitalNo As %String(CAPTION = "住院号");

Property cardType As %String(CAPTION = "卡类型");

Property cardNo As %String(CAPTION = "卡号");

Property voucherBatchCode As %String(CAPTION = "预交金凭证代码");

Property voucherNo As %String(CAPTION = "预交金凭证号码");

Property reason As %String(CAPTION = "冲红原因");

Property amt As %String(CAPTION = "预缴金退款金额");

Property ownAcBalance As %String(CAPTION = "预缴金账户余额");

Property remark As %String(CAPTION = "备注");

/*
Property busType As %String(CAPTION = "业务标识");

Property billBatchCode As %String(CAPTION = "电子票据代码");

Property billNo As %String(CAPTION = "电子票据号码");

Property reason As %String(CAPTION = "冲红原因");

Property operator As %String(CAPTION = "经办人");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property placeCode As %String(CAPTION = "开票点编码");

Property voucherBatchCode As %String(CAPTION = "预交金凭证代码");

Property voucherNo As %String(CAPTION = "预交金凭证号码");

Property amt As %String(CAPTION = "预缴金退款金额");

Property ownAcBalance As %String(CAPTION = "预缴金账户余额");

Property remark As %String(CAPTION = "备注");
*/
}
