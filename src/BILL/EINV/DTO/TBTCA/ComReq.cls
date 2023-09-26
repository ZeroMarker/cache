/// 请求对象
Class BILL.EINV.DTO.TBTCA.ComReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

/// 请求内容
Property Msg As %String(XMLPROJECTION = "ELEMENT");

}
