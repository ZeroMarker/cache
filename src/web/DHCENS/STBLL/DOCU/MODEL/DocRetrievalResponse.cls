/// 文档检索响应消息体
/// luofanyu
/// 2017-11-28
Class web.DHCENS.STBLL.DOCU.MODEL.DocRetrievalResponse Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Response";

Property Header As web.DHCENS.STBLL.DOCU.MODEL.Header;

Property Body As web.DHCENS.STBLL.DOCU.MODEL.DocuretrievalBody;

}
