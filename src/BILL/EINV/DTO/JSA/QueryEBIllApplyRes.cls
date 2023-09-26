Class BILL.EINV.DTO.JSA.QueryEBIllApplyRes Extends %RegisteredObject
{

Property result As %String(CAPTION = "处理结果代码");

Property information As %String(CAPTION = "详细信息");

Property applycount As %String(CAPTION = "申请单数量");

Property applylist As list Of BILL.EINV.DTO.JSA.EBillApplylist(CAPTION = "申请单列表");

}
