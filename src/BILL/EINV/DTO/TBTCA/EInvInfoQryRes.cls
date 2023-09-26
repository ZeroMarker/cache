/// 电子票据信息查询接口响应（8302）
Class BILL.EINV.DTO.TBTCA.EInvInfoQryRes Extends (%RegisteredObject, %Populate, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

/// 请求内容
Property Msg As %String(MAXLEN = 9999, XMLPROJECTION = "ELEMENT");

}
