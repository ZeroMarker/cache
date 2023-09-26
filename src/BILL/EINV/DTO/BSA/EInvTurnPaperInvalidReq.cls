/// 电子发票换纸质发票红冲接口
Class BILL.EINV.DTO.BSA.EInvTurnPaperInvalidReq Extends %RegisteredObject
{

Property pBillBatchCode As %String(CAPTION = "纸质票据代码");

Property pBillNo As %String(CAPTION = "纸质票据号");

Property placeCode As %String(CAPTION = "开票点编码");

Property author As %String(CAPTION = "作废人");

Property reason As %String(CAPTION = "作废原因");

Property busDateTime As %String(CAPTION = "业务发生时间");

}
