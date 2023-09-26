Class BILL.EINV.DTO.JSA.EBillApplylist Extends %RegisteredObject
{

Property "apply_no" As %String(CAPTION = "申请单号");

Property "bus_no" As %String(CAPTION = "申请时填写的业务编码");

/// 1：已审核2：未审核3：作废
Property "apply_state" As %String(CAPTION = "申请状态");

Property "apply_datetime" As %String(CAPTION = "申请时间");

Property "invoice_type_code" As %String(CAPTION = "申请电子票据种类代码");

Property "invoice_type_name" As %String(CAPTION = "申请电子票据种类名称");

Property "apply_count" As %String(CAPTION = "申请电子票据总数");

Property "invoice_code" As %String(CAPTION = "审批电子票据代码");

Property "invoice_name" As %String(CAPTION = "审批电子票据名称");

Property stockcount As %String(CAPTION = "审批库存列表个数");

Property stocklist As list Of BILL.EINV.DTO.JSA.EBillStocklist(CAPTION = "审批库存列表");

Property "approved_datetime" As %String(CAPTION = "批准时间");

Property "apply_remark" As %String(CAPTION = "申请备注");

Property "approved_remark" As %String(CAPTION = "审批备注");

}
