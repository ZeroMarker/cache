/// 税歌电子票据查询响应信息
Class BILL.EINV.DTO.SGA.EInvStatusRes Extends %RegisteredObject
{

Property code As %String(CAPTION = "返回编码");

Property msg As %String(CAPTION = "返回信息");

Property data As BILL.EINV.DTO.SGA.EInvStatusData(CAPTION = "返回数据");

Property links As %String(CAPTION = "返回链接");

}
