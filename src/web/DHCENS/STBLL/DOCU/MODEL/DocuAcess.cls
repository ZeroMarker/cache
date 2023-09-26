/// 文档调阅返回消息体
/// luofanyu
/// 2017-11-28
Class web.DHCENS.STBLL.DOCU.MODEL.DocuAcess Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Documents";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Documents As web.DHCENS.STBLL.DOCU.MODEL.Documents(XMLNAME = "Documents", XMLPROJECTION = "ELEMENT");

}
