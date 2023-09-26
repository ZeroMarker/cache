/// 文档检索消息体
/// luofanyu
/// 2017-11-28
Class web.DHCENS.STBLL.DOCU.MODEL.DocuretrievalBody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property ResultCode As %String;

Property ResultContent As %String;

Property DocumentRetrievalRp As web.DHCENS.STBLL.DOCU.MODEL.Retrieveal;

}
