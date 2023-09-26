/// 电子票据内层报文格式定义
Class BILL.EINV.DTO.BWA.EInvInMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property ReqComFPKJ As BILL.EINV.DTO.BWA.EReqComFPKJ(XMLNAME = "REQUEST_COMMON_FPKJ", XMLPROJECTION = "ELEMENT");

}
