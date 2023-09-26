/// 对象功能说明：预交金开票返回值
Class BILL.EINV.DTO.BSA.PreDepositInvoiceRes Extends %RegisteredObject
{

Property voucherBatchCode As %String(CAPTION = "预交金凭证代码");

Property voucherNo As %String(CAPTION = "预交金凭证号码");

Property voucherRandom As %String(CAPTION = "预交金凭证校验码");

Property billBatchCode As %String(CAPTION = "电子票据代码");

Property billNo As %String(CAPTION = "电子票据号码");

Property random As %String(CAPTION = "电子校验码");

Property createTime As %String(CAPTION = "电子票据生成时间");

Property billQRCode As %String(CAPTION = "电子票据二维码图片数据");

Property pictureUrl As %String(CAPTION = "电子票据H5页面URL");

}
