Class BILL.EINV.DTO.COM.InvBillNoList Extends %RegisteredObject
{

Property billName As %String(CAPTION = "票据种类名称");

Property billBatchCode As %String(CAPTION = "票据代码");

Property bgnNo As %String(CAPTION = "起始号码");

Property endNo As %String(CAPTION = "终止号码");

Property copyNum As %String(CAPTION = "票号段内总开票数");

Property totalAmt As %String(CAPTION = "票号段内总金额");

Property applyNo As %String(CAPTION = "申请单号");

/// 明细list
Property busDate As %String(CAPTION = "业务日期");

Property busNo As %String(CAPTION = "业务流水号");

Property placeCode As %String(CAPTION = "开票点编码");

Property billNo As %String(CAPTION = "票据号码");

Property random As %String(CAPTION = "校验码");

Property ivcDateTime As %String(CAPTION = "开票时间");

Property dataType As %String(CAPTION = "数据类型");

Property state As %String(CAPTION = "状态");

Property relateBillBatchCode As %String(CAPTION = "关联电子票据代码");

Property relateBillNo As %String(CAPTION = "关联电子票据号码");

}
