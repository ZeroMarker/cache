/// /查询接口返回 值对象
Class BILL.EINV.DTO.BSB.EInvoiceQueryRes Extends %RegisteredObject
{

/// message	结果信息	String	不限	是	节点
Property message As BILL.EINV.DTO.BSB.EInvoiceQuerymessageRes(CAPTION = "结果信息");

/// result	返回结果			是	详见2.5
Property result As %String(CAPTION = "返回结果");

}
