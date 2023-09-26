/// 下载发票信息内部报文
Class BILL.EINV.DTO.BWA.DLInvInMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property ReqDLComFPXX As BILL.EINV.DTO.BWA.DLComFPXXS(XMLPROJECTION = "ELEMENT");

}
