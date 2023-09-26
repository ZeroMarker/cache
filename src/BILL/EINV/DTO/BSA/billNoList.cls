Class BILL.EINV.DTO.BSA.billNoList Extends %RegisteredObject
{

Property billName As %String(CAPTION = "票据种类名称");

Property billBatchCode As %String(CAPTION = "票据代码");

Property bgnNo As %String(CAPTION = "起始号码");

Property endNo As %String(CAPTION = "终止号码");

Property copyNum As %String(CAPTION = "票号段内总开票数");

Property totalAmt As %String(CAPTION = "票号段内总金额");

}
