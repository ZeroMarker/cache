/// 开票接口返回值对象
Class BILL.EINV.DTO.BSB.EInvoiceRes Extends %RegisteredObject
{

/// message	结果信息	String	不限	是	节点
Property message As BILL.EINV.DTO.BSB.EInvoiceMessageRes;

/// result	返回结果		不限	是	详见 2.5
Property result As %String(TRUNCATE = 1, XMLNAME = "result");

}
