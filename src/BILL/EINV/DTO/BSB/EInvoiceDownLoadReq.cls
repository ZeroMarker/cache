/// 电子发票下载接口入参对象
Class BILL.EINV.DTO.BSB.EInvoiceDownLoadReq Extends %RegisteredObject
{

/// agencyId	单位识别码	String	32	是	由票据云分配，唯一
Property agencyId As %String(CAPTION = "单位识别码");

/// invoiceCode	发票代码	String	12	是
Property invoiceCode As %String(CAPTION = "发票代码");

/// invoiceNum	发票号码	String	8	是
Property invoiceNum As %String(CAPTION = "发票号码");

/// checkCode	发票校验码	String	20	是
Property checkCode As %String(CAPTION = "发票校验码");

}
