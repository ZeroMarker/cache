/// 门诊结算数据接收接口（8101）请求
Class BILL.EINV.DTO.TBTCA.OPInvoiceReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

/// 请求内容
Property Msg As %String(XMLPROJECTION = "ELEMENT");

// Property Msg As BILL.EINV.DTO.TBTCA.OPInvoiceMsgBody;

}
