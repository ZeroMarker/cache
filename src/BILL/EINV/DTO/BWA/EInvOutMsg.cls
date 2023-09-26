/// 百望公司的电子票据外部报文格式定义
Class BILL.EINV.DTO.BWA.EInvOutMsg Extends (%RegisteredObject, %Populate, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLNAME = "business";

Property id As %String(XMLPROJECTION = "ATTRIBUTE");

Property comment As %String(XMLPROJECTION = "ATTRIBUTE");

Property body As BILL.EINV.DTO.BWA.EMsgBody(XMLPROJECTION = "ELEMENT");

}
