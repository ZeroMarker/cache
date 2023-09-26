/// 住院红冲票据入参组织
Class BILL.EINV.DTO.BSA.IPInvalidReq Extends %RegisteredObject
{

Property billBatchCode As %String(CAPTION = "电子票据代码");

Property billNo As %String(CAPTION = "电子票据号码");

Property reason As %String(CAPTION = "冲红原因");

Property operator As %String(CAPTION = "经办人");

Property busDateTime As %String(CAPTION = "业务发生时间");

Property placeCode As %String(CAPTION = "开票点编码");

Property patientId As %String(CAPTION = "患者唯一ID");

Property hospitalNo As %String(CAPTION = "患者住院号");

Property remark As %String(CAPTION = "备注");

}
