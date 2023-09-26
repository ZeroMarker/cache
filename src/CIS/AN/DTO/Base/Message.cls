Class CIS.AN.DTO.Base.Message Extends (CIS.AN.DTO.Abstract.Model, CIS.AN.DTO.Abstract.Message, %XML.Adaptor) [ Inheritance = right ]
{

Parameter XMLNAME = "Message";

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLIGNORENULL = 1;

/// 就诊号
Property EpisodeID As %String;

/// 手术申请表ID
Property ApplicationID As %String;

/// 发送时间（yyyy-MM-dd HH:mm:ss）
Property SendDateTime As %String;

/// 发送人ID
Property SendUserID As %String;

/// 发送人
Property SendUser As %String;

/// 接收人ID
Property TargetUserID As %String;

/// 接收人
Property TargetUser As %String;

/// 消息
Property Content As %String(MAXLEN = 200);

}
