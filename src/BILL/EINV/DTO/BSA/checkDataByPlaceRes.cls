Class BILL.EINV.DTO.BSA.checkDataByPlaceRes Extends %RegisteredObject
{

Property busDate As %String(CAPTION = "业务日期");

Property copyNum As %String(CAPTION = "总笔数");

Property totalAmt As %String(CAPTION = "当前页总金额");

Property totalNum As %String(CAPTION = "当前页总开票数");

Property allTotalAmt As %String(CAPTION = "所有页总金额");

Property allTotalNum As %String(CAPTION = "所有页总开票数");

Property billNoList As list Of BILL.EINV.DTO.BSA.billNoList(CAPTION = "票号段明细");

}
