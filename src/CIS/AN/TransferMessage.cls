/// 消息
Class CIS.AN.TransferMessage Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = TransferMessage ]
{

/// 发送的消息
Property Message As %String(MAXLEN = 500) [ Required, SqlColumnNumber = 2 ];

/// 发送者
Property TransFrom As %String [ Required, SqlColumnNumber = 3 ];

/// 接收者
Property TransTo As %String [ SqlColumnNumber = 4 ];

/// 发消息日期
Property TransDate As %Date [ SqlColumnNumber = 5 ];

/// 发消息时间
Property TransTime As %Time [ SqlColumnNumber = 6 ];

/// 发送状态
Property Status As %String(DISPLAYLIST = ",未发送,已发送,已确认,完成,撤销", VALUELIST = ",N,S,C,F,D") [ SqlColumnNumber = 7 ];

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ SqlColumnNumber = 8 ];

/// 消息确认用户
Property ConfirmUser As %String [ SqlColumnNumber = 9 ];

/// 消息确认日期
Property ConfirmDate As %Date [ SqlColumnNumber = 10 ];

/// 消息确认时间
Property ConfirmTime As %Time [ SqlColumnNumber = 11 ];

/// 消息类型
Property MessageType As %String [ SqlColumnNumber = 12 ];

/// 消息接收安全组
Property RecvGroup As %String [ SqlColumnNumber = 13 ];

/// 消息接收科室
Property RecvDept As %String [ SqlColumnNumber = 14 ];

/// 大屏客户端IP地址
Property ClientIP As %String [ SqlColumnNumber = 15 ];

/// 撤销消息用户
Property CancelUser As %String [ SqlColumnNumber = 16 ];

/// 撤销日期
Property CancelDate As %Date [ SqlColumnNumber = 17 ];

/// 撤销时间
Property CancelTime As %Time [ SqlColumnNumber = 18 ];

/// 发送日期索引
Index ITransDate On TransDate;

/// 手术申请索引
Index IOPS On OperSchedule;

Storage Default
{
<Data name="TransferMessageDefaultData">
<Value name="1">
<Value>Message</Value>
</Value>
<Value name="2">
<Value>TransFrom</Value>
</Value>
<Value name="3">
<Value>TransTo</Value>
</Value>
<Value name="4">
<Value>TransDate</Value>
</Value>
<Value name="5">
<Value>TransTime</Value>
</Value>
<Value name="6">
<Value>Status</Value>
</Value>
<Value name="7">
<Value>OperSchedule</Value>
</Value>
<Value name="8">
<Value>ConfirmUser</Value>
</Value>
<Value name="9">
<Value>ConfirmDate</Value>
</Value>
<Value name="10">
<Value>ConfirmTime</Value>
</Value>
<Value name="11">
<Value>MessageType</Value>
</Value>
<Value name="12">
<Value>RecvGroup</Value>
</Value>
<Value name="13">
<Value>RecvDept</Value>
</Value>
<Value name="14">
<Value>ClientIP</Value>
</Value>
<Value name="15">
<Value>CancelUser</Value>
</Value>
<Value name="16">
<Value>CancelDate</Value>
</Value>
<Value name="17">
<Value>CancelTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.TransferMessageD</DataLocation>
<DefaultData>TransferMessageDefaultData</DefaultData>
<IdLocation>^CIS.AN.TransferMessageD</IdLocation>
<IndexLocation>^CIS.AN.TransferMessageI</IndexLocation>
<StreamLocation>^CIS.AN.TransferMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
