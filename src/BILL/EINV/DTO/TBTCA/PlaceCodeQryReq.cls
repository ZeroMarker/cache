/// 开票点查询接口（8902）请求
Class BILL.EINV.DTO.TBTCA.PlaceCodeQryReq Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

/// 请求内容
Property Msg As BILL.EINV.DTO.TBTCA.InitMsgBody;

}
