/// 住院预交金电子票据红冲返回值
Class BILL.EINV.DTO.BSA.PreDepositInvalidRes Extends %RegisteredObject
{

// 电子红票票据代码

Property voucherBatchCode As %String(CAPTION = "预交金红票凭证代码");

Property voucherNo As %String(CAPTION = "预交金红票凭证号码");

Property voucherRandom As %String(CAPTION = "预交金红票凭证校验码");

Property eScarletBillBatchCode As %String(CAPTION = "电子红票票据代码");

Property eScarletBillNo As %String(CAPTION = "电子红票票据号码");

Property eScarletRandom As %String(CAPTION = "电子红票票据校验码");

Property createTime As %String(CAPTION = "电子红票生成时间");

Property billQRCode As %String(CAPTION = "电子红票二维码图片数据");

Property pictureUrl As %String(CAPTION = "电子票据H5页面URL");

}
