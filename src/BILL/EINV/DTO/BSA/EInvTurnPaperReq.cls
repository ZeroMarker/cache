/// 电子发票换纸质发票入参组织对象
Class BILL.EINV.DTO.BSA.EInvTurnPaperReq Extends %RegisteredObject
{

/// 电子票据代码
Property billBatchCode As %String(CAPTION = "电子票据代码");

/// 电子票据号
Property billNo As %String(CAPTION = "电子票据号");

/// 纸质票据代码
Property pBillBatchCode As %String(CAPTION = "纸质票据代码");

/// 纸质票据号
Property pBillNo As %String(CAPTION = "纸质票据号");

/// 业务发生时间 (yyyyMMddHHmmssSSS)
Property busDateTime As %String(CAPTION = "业务发生时间");

/// 开票点编码
Property placeCode As %String(CAPTION = "开票点编码");

/// 经办人
Property operator As %String(CAPTION = "经办人");

}
