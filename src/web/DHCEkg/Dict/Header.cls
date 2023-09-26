/// Creator：      yangyali
/// CreatDate：    2021-11-24
/// Description:   与平台接口交互的消息头
/// 				用途：解析平台发来的入参或返回信息，或生成要发出或返回的消息
Class web.DHCEkg.Dict.Header Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Header";

/// 消息来源
Property SourceSystem As %String(MAXLEN = 32767);

/// 消息ID
Property MessageID As %String(MAXLEN = 32767);

}
