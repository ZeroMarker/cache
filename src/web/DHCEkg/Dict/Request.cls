/// Creator：      yangyali
/// CreatDate：    2021-11-24
/// Description:   与平台接口交互，接口入参字典
Class web.DHCEkg.Dict.Request Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

/// 消息头
Property Header As web.DHCEkg.Dict.Header;

/// 消息体
Property Body As web.DHCEkg.Dict.Body;

}
