Class BILL.EINV.DTO.XYHA.OPInvoiceReq Extends %RegisteredObject
{

Property orgCode As %String(CAPTION = "机构编码");

/// 开票类型（1：门诊；2：住院）
Property billType As %String(CAPTION = "开票类型");

Property signContent As %String(CAPTION = "开票业务参数");

}
