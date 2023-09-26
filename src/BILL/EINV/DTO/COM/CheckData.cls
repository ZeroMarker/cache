Class BILL.EINV.DTO.COM.CheckData Extends %RegisteredObject
{

Property BusDate As %Date(CAPTION = "业务日期");

Property CopyNum As %String(CAPTION = "总笔数");

Property AllTotalAmt As %String(CAPTION = "总金额");

Property AllTotalNum As %String(CAPTION = "总开票数");

Property InvBillNoList As list Of BILL.EINV.DTO.COM.InvBillNoList(CAPTION = "票号段明细");

/// 明细pageNo
Property total As %String(CAPTION = "总条数");

Property pageNo As %String(CAPTION = "当前页面");

Property ivcDate As %String(CAPTION = "开票日期");

}
