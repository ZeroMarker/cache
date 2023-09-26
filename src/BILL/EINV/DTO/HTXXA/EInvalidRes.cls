/// 红冲返回值
Class BILL.EINV.DTO.HTXXA.EInvalidRes Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "EIFeiCancelResponse";

Property HoldSerialBiz As %String(CAPTION = "业务流水号", XMLPROJECTION = "ELEMENT");

Property BillState As %String(CAPTION = "业务类型", XMLPROJECTION = "ELEMENT");

}
