Class web.DHCEkg.Remote.Dict.Request Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Request";

/// 申请单号
Property appid As %String;

/// 申请单状态 0申请;1数据已采集;2已出报告;3已下载
Property appState As %String;

}
