/// 获取授权接口（8901）请求
Class BILL.EINV.DTO.TBTCA.InitReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.InitHeaderInfo;

// Property Msg As BILL.EINV.DTO.TBTCA.InitMsgBody;

/// 请求内容
Property Msg As %String(XMLPROJECTION = "ELEMENT");

}
