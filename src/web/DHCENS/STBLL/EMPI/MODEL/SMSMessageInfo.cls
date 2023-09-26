Class web.DHCENS.STBLL.EMPI.MODEL.SMSMessageInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "MessageInfo";

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

/// 电话号码
Property Mobile As %Library.String(MAXLEN = 30, XMLNAME = "Mobile");

/// 内容
Property Content As %Library.String(MAXLEN = 1000, XMLNAME = "Content");

}
