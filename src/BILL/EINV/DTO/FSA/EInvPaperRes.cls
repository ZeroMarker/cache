/// 富深获取换开纸质发票数据对象
Class BILL.EINV.DTO.FSA.EInvPaperRes Extends %RegisteredObject
{

Property code As %String(CAPTION = "返回编码");

Property msg As %String(CAPTION = "返回消息");

Property data As list Of BILL.EINV.DTO.FSA.EInvPaperResData(CAPTION = "换开返回结果");

}
