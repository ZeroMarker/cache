/// 电子票据红冲接口入参组织对象
Class BILL.EINV.DTO.BSA.OPInvalidReq Extends %RegisteredObject
{

Property billBatchCode As %String(CAPTION = "电子票据代码");

Property billNo As %String(CAPTION = "电子票据号码");

Property reason As %String(CAPTION = "冲红原因");

Property operator As %String(CAPTION = "经办人");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property placeCode As %String(CAPTION = "开票点编码");

}
