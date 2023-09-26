/// 电子发票开具状态查询返回值
Class BILL.EINV.DTO.BSA.EInvStatesMegRes Extends %RegisteredObject
{

/// 电子票据种类名称
Property billName As %String(CAPTION = "电子票据种类名称");

/// 电子票据代码
Property billBatchCode As %String(CAPTION = "电子票据代码");

/// 电子票据号码
Property billNo As %String(CAPTION = "电子票据号码");

/// 电子校验码
Property random As %String(CAPTION = "电子校验码");

/// 开票时间 (yyyyMMddHHmmssSSS)
Property ivcDateTime As %String(CAPTION = "开票时间");

/// 状态 (状态：1正常，2作废)
Property state As %String(CAPTION = "状态");

/// 是否打印纸质票据  (0未打印，1已打印)
Property isPrtPaper As %String(CAPTION = "是否打印纸质票据");

/// 纸质票据代码 (如已打印纸质，则有值)
Property pBillBatchCode As %String(CAPTION = "纸质票据代码");

/// 纸质票据号码 (如已打印纸质，则有值)
Property pBillNo As %String(CAPTION = "纸质票据号码");

/// 是否已开红票 (0未开红票，1已开红票)
Property isScarlet As %String(CAPTION = "是否已开红票");

/// 红字电子票据代码 (如已开红票，有值)
Property scarletBillBatchCode As %String(CAPTION = "红字电子票据代码");

/// 红字电子票据号码 (如已开红票，有值)
Property scarletBillNo As %String(CAPTION = "红字电子票据号码");

/// 红票电子票据随机码 (如已开红票，有值)
Property scarletRandom As %String(CAPTION = "红票电子票据随机码");

/// 红票电子票据二维码图片
Property scarletBillQRCode As %String(CAPTION = "红票电子票据二维码图片");

}
