/// 号段集合信息对象
Class BILL.EINV.DTO.COM.ValidBillNo Extends %RegisteredObject
{

Property INVCount As %String(CAPTION = "票据总条数");

/// 票据号码段列表
Property INVBillNoList As list Of BILL.EINV.DTO.COM.DHCInvoiceInfo(CAPTION = "票据号码段列表");

}
