/// Desc:       待办列表
/// Creator:    Candy
/// CreateDate: 2016-09-18
Class EMRinstance.MessageList Extends (%Persistent, %XML.Adaptor)
{

Index InstanceValid On (InstanceID, MessageType, Receiver);

/// 病历ID
Property InstanceID As %String(TRUNCATE = 1);

/// 消息类型
Property MessageType As %String(TRUNCATE = 1);

/// 发送者(UserID)
Property Sender As %String(TRUNCATE = 1);

/// 接受者(UserID)
Property Receiver As %String(TRUNCATE = 1);

/// 消息头
Property MessageTitle As %String(TRUNCATE = 1);

/// 消息内容
Property Message As %String(TRUNCATE = 1);

/// 发送日期
Property SendDate As %Date;

/// 发送日期
Property SendTime As %Time;

/// 状态（未处理为1，已处理为0）
Property Status As %String(TRUNCATE = 1);

Index IdxInstanceTypeReceiverStatus On (InstanceID, MessageType, Receiver, Status);

Index IdxTypeReceiverInstanceIDStatus On (MessageType, Receiver, InstanceID, Status);

Storage Default
{
<Data name="MessageListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InstanceID</Value>
</Value>
<Value name="3">
<Value>MessageType</Value>
</Value>
<Value name="4">
<Value>Sender</Value>
</Value>
<Value name="5">
<Value>Receiver</Value>
</Value>
<Value name="6">
<Value>MessageTitle</Value>
</Value>
<Value name="7">
<Value>Message</Value>
</Value>
<Value name="8">
<Value>SendDate</Value>
</Value>
<Value name="9">
<Value>SendTime</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.MessageListD</DataLocation>
<DefaultData>MessageListDefaultData</DefaultData>
<IdLocation>^DHCEMRI.MessageListD</IdLocation>
<IndexLocation>^DHCEMRI.MessageListI</IndexLocation>
<StreamLocation>^DHCEMRI.MessageListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
