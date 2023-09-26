/// 文档调阅返回消息体
/// luofanyu
/// 2017-11-28
Class web.DHCENS.STBLL.DOCU.MODEL.DocuAccessRp Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Response";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property Header As web.DHCENS.STBLL.DOCU.MODEL.Header;

Property Body As web.DHCENS.STBLL.DOCU.MODEL.DocuAcessBody(XMLPROJECTION = "ELEMENT");

}
