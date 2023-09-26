/// Creator：      yangyali
/// CreatDate：    2021-11-24
/// Description:   与平台接口交互的消息体
/// 				用途：解析平台发来的入参或返回信息，或生成要发出或返回的消息
Class web.DHCEkg.Dict.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

/// 
/// 
/// 申请单信息-最后更新人代码
Property UpdateUserCode As %String(MAXLEN = 32767);

/// 申请单信息-最后更新人
Property UpdateUserDesc As %String(MAXLEN = 32767);

/// 申请单信息-更新日期
Property UpdateDate As %String(MAXLEN = 32767);

/// 申请单信息-更新时间
Property UpdateTime As %String(MAXLEN = 32767);

/// 
/// 
/// -------- 检查状态状态变更回传 start -----------
/// 检查状态信息
Property StatusParameter As web.DHCEkg.Dict.StatusParameter;

}
