/// 电子票据信息查询接口（8302）
Class BILL.EINV.DTO.TBTCA.EInvInfoQryReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

// Property Msg As BILL.EINV.DTO.TBTCA.InitMsgBody;

/// 请求内容
Property Msg As %String(XMLPROJECTION = "ELEMENT");

}
