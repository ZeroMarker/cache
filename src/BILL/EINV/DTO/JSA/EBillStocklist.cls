Class BILL.EINV.DTO.JSA.EBillStocklist Extends %RegisteredObject
{

Property count As %String(CAPTION = "电子票据总数");

Property "start_no" As %String(CAPTION = "起始号码");

Property "end_no" As %String(CAPTION = "结束号码");

/// status(1：待入库 2：已入库 9：已撤销)
Property status As %String(CAPTION = "库存状态");

}
