/// 电子票据门诊红冲返回值
Class BILL.EINV.DTO.BSA.OPInvalidMegRes Extends %RegisteredObject
{

/// 电子红票票据代码
Property eScarletBillBatchCode As %String(CAPTION = "电子红票票据代码");

Property eScarletBillNo As %String(CAPTION = "电子红票票据号码");

Property eScarletRandom As %String(CAPTION = "电子红票校验码");

Property createTime As %String(CAPTION = "电子红票生成时间");

Property billQRCode As %String(CAPTION = "电子票据二维码图片数据");

Property pictureUrl As %String(CAPTION = "电子票据H5页面URL");

}
