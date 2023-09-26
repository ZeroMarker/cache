Class web.DHCENS.STBLL.DICT.MODEL.Header Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Header";

/// 代码
Property SourceSystem As %Library.String(XMLNAME = "SourceSystem");

/// 描述
Property MessageID As %Library.String(XMLNAME = "MessageID");

}
