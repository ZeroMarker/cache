/// 获取授权接口（8901）响应
Class BILL.EINV.DTO.TBTCA.InitRes Extends (%RegisteredObject, %Populate, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.InitHeaderInfo;

/// 请求内容
Property Msg As %String(MAXLEN = 9999, XMLPROJECTION = "ELEMENT");

// Property Msg As BILL.EINV.DTO.TBTCA.InitMsgResult;

}
