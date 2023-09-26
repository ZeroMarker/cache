Class BILL.EINV.DTO.JSA.QueryEBillTypeRes Extends %RegisteredObject
{

Property result As %String(CAPTION = "处理结果代码");

Property information As %String(CAPTION = "详细信息");

Property count As %String(CAPTION = "电子票据种类数量");

Property invoicetypelist As list Of BILL.EINV.DTO.JSA.QueryEBillTypeList(CAPTION = "电子票据种类列表");

Property applyno As %String(CAPTION = "申请单号", XMLNAME = "apply_no");

}
