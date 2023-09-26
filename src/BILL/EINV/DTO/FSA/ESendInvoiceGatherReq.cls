/// 发送日终汇总金额、条数信息入参对象
Class BILL.EINV.DTO.FSA.ESendInvoiceGatherReq Extends %RegisteredObject
{

/// 开票日期 yyyyMMdd
Property issuedate As %String(CAPTION = "开票日期");

Property einvoicecode As %String(CAPTION = "电子票据代码");

/// 开票数量：一个正票一个红冲的票对账数量传2
Property invoicequantity As %String(CAPTION = "开票数量");

/// 总金额：一正一负的合计金额为0？需要确认
Property amt As %String(CAPTION = "总金额");

}
