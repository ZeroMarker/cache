/// 同步天成诊断信息
Class BILL.EINV.DTO.TBTCB.EInvDiseInfoList Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "Request";

Property DiagInfo As list Of BILL.EINV.DTO.TBTCB.EInvDiseInfo(XMLPROJECTION = "ELEMENT");

}
