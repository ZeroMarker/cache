Class BILL.EINV.DTO.TBTCA.EInvPrintRes Extends (%RegisteredObject, %Populate, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Invoice";

/// 请求报文头
Property Head As BILL.EINV.DTO.TBTCA.ComHeaderInfo;

/// 请求内容
Property Msg As %String(MAXLEN = 999999, XMLPROJECTION = "ELEMENT");

}
