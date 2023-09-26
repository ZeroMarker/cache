Class BILL.EINV.DTO.TBTCA.ItemDownLoadReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

// Property Msg As BILL.EINV.DTO.TBTCA.InitMsgBody;

/// 请求内容
Property Msg As %String(XMLPROJECTION = "ELEMENT");

}
