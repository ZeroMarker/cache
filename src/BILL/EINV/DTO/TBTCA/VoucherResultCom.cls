Class BILL.EINV.DTO.TBTCA.VoucherResultCom Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 0;

/// 处理结果代码
Property ResultCode As %String(XMLPROJECTION = "ELEMENT");

/// 处理结果消息
Property ResultMsg As %String(XMLPROJECTION = "ELEMENT");

}
