/// 文档调阅返回消息体
/// luofanyu
/// 2017-11-28
Class web.DHCENS.STBLL.DOCU.MODEL.DocuAcessBody Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Body";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Property ResultCode As %String;

Property ResultContent As %String;

Property DocumentSearchRp As web.DHCENS.STBLL.DOCU.MODEL.DocuAcess;

}
