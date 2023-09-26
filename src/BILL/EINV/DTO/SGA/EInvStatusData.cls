Class BILL.EINV.DTO.SGA.EInvStatusData Extends %RegisteredObject
{

Property einvoiceCode As %String(CAPTION = "票据代码");

Property einvoiceNumber As %String(CAPTION = "票据号码");

Property einvoiceNo As %String(CAPTION = "流水号");

/// 开票状态（1：普通 2：作废 3：换开）
Property einvoiceStatus As %String(CAPTION = "开票状态");

Property issueDate As %String(CAPTION = "开票日期");

Property issueTime As %String(CAPTION = "开票时间");

Property totalAmount As %String(CAPTION = "开票金额");

Property acceptId As %String(CAPTION = "受理号码");

/// 打印标识（1: 未打印 0：已打印）
Property printFlag As %String(CAPTION = "打印标识");

}
