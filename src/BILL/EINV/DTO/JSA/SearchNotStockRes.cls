Class BILL.EINV.DTO.JSA.SearchNotStockRes Extends %RegisteredObject
{

Property result As %String(CAPTION = "处理结果代码");

Property information As %String(CAPTION = "详细信息");

Property stockcount As %String(CAPTION = "库存段数量");

/// 库存列表
Property stocklist As list Of BILL.EINV.DTO.JSA.SearchNotStockList(CAPTION = "库存列表", XMLNAME = "stocklist");

}
