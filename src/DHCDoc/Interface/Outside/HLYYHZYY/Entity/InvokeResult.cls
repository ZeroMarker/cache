Class DHCDoc.Interface.Outside.HLYYHZYY.Entity.InvokeResult Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 0;

/// 标识一次调用,值唯一,最长64位
Property invokeid As %String(TRUNCATE = 1, XMLNAME = "invoke_id");

/// 是否调用成功	1: 成功,0: 失败
Property invokestatus As %String(TRUNCATE = 1, XMLNAME = "invoke_status");

/// 返回信息
Property invokemessage As %String(TRUNCATE = 1, XMLNAME = "invoke_message");

}
