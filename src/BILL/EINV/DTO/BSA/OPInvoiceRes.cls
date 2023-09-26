Class BILL.EINV.DTO.BSA.OPInvoiceRes Extends %RegisteredObject
{

///  返回结果标识
Property result As %String(CAPTION = "返回结果标识", TRUNCATE = 1, XMLNAME = "result");

/// 返回结果内容
Property message As list Of BILL.EINV.DTO.BSA.OPInvoiceMegRes(CAPTION = "返回结果内容", XMLNAME = "message");

}
