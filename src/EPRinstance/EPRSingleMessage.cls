Class EPRinstance.EPRSingleMessage Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

Property CreateDate As %Date;

Property CreateTime As %Time;

/// 生效标识 - 长期有效不过期L，需要设置过期T
Property EffectiveFlag As %String(TRUNCATE = 1);

/// 生效日期 - 一些非关键实时通知过期了就没有意义了，为空则永久有效
Property EffectiveDate As %Date;

Property EffectiveTime As %Time;

/// 阅读标识 - 未读U，已读R
Property ReadFlag As %String(TRUNCATE = 1);

Property ReadUserID As %String(TRUNCATE = 1);

/// 阅读日期
Property ReadDate As %Date;

Property ReadTime As %Time;

/// 执行标识 - 未执行U，已执行E
Property ExecuteFlag As %String(TRUNCATE = 1);

Property ExecuteUserID As %String(TRUNCATE = 1);

/// 执行日期
Property ExecuteDate As %Date;

Property ExecuteTime As %Time;

/// 修复标识 - 未修复U，已修复C
Property ConfirmFlag As %String(TRUNCATE = 1);

Property ConfirmUserID As %String(TRUNCATE = 1);

/// 修复日期
Property ConfirmDate As %Date;

Property ConfirmTime As %Time;

/// 发送者
Property SenderUserID As %String(TRUNCATE = 1);

/// 接收者
Property ReceiverUserID As %String(TRUNCATE = 1);

/// 此消息是回复哪条消息的，第一个发送的消息此值为空
Property ACKID As %String(TRUNCATE = 1);

/// 消息组，指发给多人时，所有人都处在一个消息组，可回复给组内所有人
Property MessageGroupID As %String(TRUNCATE = 1);

/// 消息头
Property MessageTitle As %String(TRUNCATE = 1);

/// 消息内容
Property Message As %String(MAXLEN = 800, TRUNCATE = 0);

/// 消息类型 - 编码含义见EPRmeta.EPRMessageType
Property MessageType As %String(TRUNCATE = 1);

/// 消息来源 - 编码含义见EPRmeta.EPRMessageSource
Property MessageSource As %String(TRUNCATE = 1);

/// 消息重要程度 - 紧急E，普通N
Property MessagePrioriry As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property InstanceId As %String(TRUNCATE = 1);

Property EmrDocId As %String(TRUNCATE = 1);

Property EntryID As %String(TRUNCATE = 1);

Property EntryScore As %String(TRUNCATE = 1);

Property ExamCount As %String(TRUNCATE = 1);

Property ResumeText As %String(MAXLEN = 800, TRUNCATE = 0);

Property ResultDetailID As %String(TRUNCATE = 1);

Property AppealText As %String(MAXLEN = 800, TRUNCATE = 0);

Property SendNo As %String(TRUNCATE = 1);

Property CtLocDR As %String(TRUNCATE = 1);

Property Path As %String(TRUNCATE = 1);

Index IdxSenderUserID On (SenderUserID, MessagePrioriry, ReadFlag, ExecuteFlag, CreateDate, CreateTime);

Index IdxReceiverUserID On (ReceiverUserID, MessagePrioriry, ReadFlag, ExecuteFlag, CreateDate, CreateTime);

Index IdxACKID On ACKID;

Index IdxMessageGroupID On MessageGroupID;

Index IdxEpisodeID On EpisodeID;

Index IdxResultDetailID On ResultDetailID;

Index IdxEpisodeIDFlag On (EpisodeID, ReadFlag, ExecuteFlag);

Index IdxCreateDateTime On (CreateDate, CreateTime);

Index IdxCreateDateSenderUserID On (CreateDate, SenderUserID);

Storage Default
{
<Data name="EPRSingleMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>EffectiveDate</Value>
</Value>
<Value name="5">
<Value>EffectiveTime</Value>
</Value>
<Value name="6">
<Value>SenderUserID</Value>
</Value>
<Value name="7">
<Value>ReceiverUserID</Value>
</Value>
<Value name="8">
<Value>ACKID</Value>
</Value>
<Value name="9">
<Value>MessageGroupID</Value>
</Value>
<Value name="10">
<Value>Message</Value>
</Value>
<Value name="11">
<Value>MessageType</Value>
</Value>
<Value name="12">
<Value>MessagePrioriry</Value>
</Value>
<Value name="13">
<Value>EffectiveFlag</Value>
</Value>
<Value name="14">
<Value>ReadFlag</Value>
</Value>
<Value name="15">
<Value>ReadDate</Value>
</Value>
<Value name="16">
<Value>ReadTime</Value>
</Value>
<Value name="17">
<Value>MessageSource</Value>
</Value>
<Value name="18">
<Value>MessageHeader</Value>
</Value>
<Value name="19">
<Value>MessageTitle</Value>
</Value>
<Value name="20">
<Value>ExecuteFlag</Value>
</Value>
<Value name="21">
<Value>ExecuteDate</Value>
</Value>
<Value name="22">
<Value>ExecuteTime</Value>
</Value>
<Value name="23">
<Value>EpisodeID</Value>
</Value>
<Value name="24">
<Value>ReadUserID</Value>
</Value>
<Value name="25">
<Value>ExecuteUserID</Value>
</Value>
<Value name="26">
<Value>SendNo</Value>
</Value>
<Value name="27">
<Value>InstanceId</Value>
</Value>
<Value name="28">
<Value>EmrDocId</Value>
</Value>
<Value name="29">
<Value>ConfirmFlag</Value>
</Value>
<Value name="30">
<Value>ConfirmUserID</Value>
</Value>
<Value name="31">
<Value>ConfirmDate</Value>
</Value>
<Value name="32">
<Value>ConfirmTime</Value>
</Value>
<Value name="33">
<Value>EntryScore</Value>
</Value>
<Value name="34">
<Value>ExamCount</Value>
</Value>
<Value name="35">
<Value>EntryDR</Value>
</Value>
<Value name="36">
<Value>EntryID</Value>
</Value>
<Value name="37">
<Value>ResumeText</Value>
</Value>
<Value name="38">
<Value>ResultDetailID</Value>
</Value>
<Value name="39">
<Value>AppealText</Value>
</Value>
<Value name="40">
<Value>Path</Value>
</Value>
<Value name="41">
<Value>CtLocDR</Value>
</Value>
</Data>
<DataLocation>^DHCEPRQ.EPRSingleMessageD</DataLocation>
<DefaultData>EPRSingleMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRQ.EPRSingleMessageD</IdLocation>
<IndexLocation>^DHCEPRQ.EPRSingleMessageI</IndexLocation>
<StreamLocation>^DHCEPRQ.EPRSingleMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
