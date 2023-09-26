Class BILL.EINV.DTO.BSA.IPResultMessage Extends %RegisteredObject
{

Property billBatchCode As %String(CAPTION = "电子票据代码");

Property billNo As %String(CAPTION = "电子票据号码");

Property random As %String(CAPTION = "电子校验码");

Property createTime As %String(CAPTION = "电子票据生成时间");

Property billQRCode As %String(CAPTION = "电子票据二维码图片数据");

Property pictureUrl As %String(CAPTION = "电子票据H5页面URL");

}
