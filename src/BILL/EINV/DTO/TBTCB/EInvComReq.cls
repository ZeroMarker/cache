Class BILL.EINV.DTO.TBTCB.EInvComReq Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Request";

Property Data As BILL.EINV.DTO.TBTCB.EInvComDataReq(XMLPROJECTION = "ELEMENT");

}
