/// 开具接口返回值。
Class BILL.EINV.DTO.JSC.EInvInvoiceRes Extends %RegisteredObject
{

Property HEADER As BILL.EINV.DTO.JSC.EInvInvoiceHeaderRes(CAPTION = "头文件");

Property BODY As BILL.EINV.DTO.JSC.EInvInvoiceBodyRes(CAPTION = "数据体");

}
