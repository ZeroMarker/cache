Class CIS.AN.DaySurgeryDecline Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DaySurgeryDecline, StorageStrategy = Default ]
{

/// 手术申请
Property OperSchedule As CIS.AN.OperSchedule [ Required, SqlColumnNumber = 2 ];

/// 短信内容
Property Content As %String(MAXLEN = 1000) [ Required, SqlColumnNumber = 3 ];

/// 短信发送用户
Property UpdateUser As %String [ SqlColumnNumber = 4 ];

/// 短信发送日期
Property UpdateDate As %Date [ SqlColumnNumber = 5 ];

/// 短信发送时间
Property UpdateTime As %Time [ SqlColumnNumber = 6 ];

Index IOPS On OperSchedule;

Storage Default
{
<Data name="Default">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperSchedule</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>UpdateUser</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.DaySurgeryDeclineD</DataLocation>
<DefaultData>Default</DefaultData>
<IdLocation>^CIS.AN.DaySurgeryDeclineD</IdLocation>
<IndexLocation>^CIS.AN.DaySurgeryDeclineI</IndexLocation>
<StreamLocation>^CIS.AN.DaySurgeryDeclineS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
