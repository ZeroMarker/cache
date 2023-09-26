Class BILL.EINV.DTO.BSA.GetBillByBusDateRes Extends %RegisteredObject
{

Property total As %String(CAPTION = "总条数");

Property pageNo As %String(CAPTION = "当前页面");

Property billList As list Of BILL.EINV.DTO.BSA.billList(CAPTION = "开票明细列表");

}
