/// Creater:lulin
/// Descriptions:消息追踪
/// Date:2021-05-25
Class DHCINM.PF.TrackMessage Extends %Persistent
{

/// 接收人:对应user表id
Property MessagePer As %Integer [ SqlColumnNumber = 2, SqlFieldName = MessagePer ];

/// 通知日期
Property MessageDate As %Date [ SqlColumnNumber = 3, SqlFieldName = MessageDate ];

/// 是否已读 N:未读,Y：已读
Property MessageStatus As %String [ SqlColumnNumber = 4, SqlFieldName = MessageStatus ];

/// 已读日期
Property ReadDate As %Date [ SqlColumnNumber = 5, SqlFieldName = ReadDate ];

/// 已读时间
Property ReadTime As %Time [ SqlColumnNumber = 6, SqlFieldName = ReadTime ];

/// 消息标签【【功能】状态 病区 事件 相关人员。。。标题】
Property MessageTitle As %String(MAXLEN = 500) [ SqlColumnNumber = 7, SqlFieldName = MessageTitle ];

/// 详细内容
Property MessageContext As %String(MAXLEN = 2000) [ SqlColumnNumber = 8, SqlFieldName = MessageContext ];

/// 表名称
Property MessageTableName As %String [ SqlColumnNumber = 9, SqlFieldName = MessageTableName ];

/// 表ID
Property MessageTableID As %String [ SqlColumnNumber = 10, SqlFieldName = MessageTableID ];

Index perDate On (MessagePer, MessageDate);

Index tableID On (MessageTableName, MessageTableID);

Storage Default
{
<Data name="TrackMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MessagePer</Value>
</Value>
<Value name="3">
<Value>MessageDate</Value>
</Value>
<Value name="4">
<Value>MessageStatus</Value>
</Value>
<Value name="5">
<Value>ReadDate</Value>
</Value>
<Value name="6">
<Value>ReadTime</Value>
</Value>
<Value name="7">
<Value>MessageTitle</Value>
</Value>
<Value name="8">
<Value>MessageContext</Value>
</Value>
<Value name="9">
<Value>MessageTableName</Value>
</Value>
<Value name="10">
<Value>MessageTableID</Value>
</Value>
</Data>
<DataLocation>^DHCINM.PF.TrackMessageD</DataLocation>
<DefaultData>TrackMessageDefaultData</DefaultData>
<IdLocation>^DHCINM.PF.TrackMessageD</IdLocation>
<IndexLocation>^DHCINM.PF.TrackMessageI</IndexLocation>
<StreamLocation>^DHCINM.PF.TrackMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
