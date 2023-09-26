/// 空白纸质票据作废接口
Class BILL.EINV.DTO.BSA.BlankPaperInvalidReq Extends %RegisteredObject
{

Property pBillBatchCode As %String(CAPTION = "纸质票据代码");

Property pBillNoStart As %String(CAPTION = "起始纸质票据号");

/// 终止纸质票据号
Property pBillNoEnd As %String(CAPTION = "终止纸质票据号");

/// 开票点编码
Property placeCode As %String(CAPTION = "开票点编码");

/// 作废人
Property author As %String(CAPTION = "作废人");

/// 作废原因
Property reason As %String(CAPTION = "作废原因");

/// 业务发生时间 (yyyyMMddHHmmssSSS)
Property busDateTime As %String(CAPTION = "业务发生时间");

}
