/// 电子发票下载接口返回值对象
Class BILL.EINV.DTO.BSB.EInvoiceDownLoadRes Extends %RegisteredObject
{

/// message	结果信息	String	不限	是	节点
Property message As %String(CAPTION = "结果信息");

/// result	返回结果			是	详见2.5
Property result As %String(CAPTION = "返回结果");

}
