/// 电子票据开具接口返回值
Class BILL.EINV.DTO.ZBXXA.EInvoiceRes Extends %RegisteredObject
{

/// 与请求报文中一致
Property BizCode As %String(CAPTION = "业务流水号");

/// 票面其他信息OtherInfo
Property EInvoiceList As BILL.EINV.DTO.ZBXXA.EInvoiceList(CAPTION = "开具的票据信息");

}
