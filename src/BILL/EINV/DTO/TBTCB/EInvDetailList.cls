/// /同步天成组织明细数据
Class BILL.EINV.DTO.TBTCB.EInvDetailList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Request";

Property Details As list Of BILL.EINV.DTO.TBTCB.EInvDetails(XMLPROJECTION = "ELEMENT");

}
