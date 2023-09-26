Class CSM.ErrorLog Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 错误发生时间
Property ErrDateTime As %String(MAXLEN = 30, TRUNCATE = 1);

/// ID
/// Property ErrorID As %Integer [ Required ];
/// 错误消息
Property Message As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 错误堆栈
Property StackTrace As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 引起错误的用户ID
Property UserID As %Integer;

/// 引起错误的用户名
Property UserName As %String(MAXLEN = 100, TRUNCATE = 1);

/// 引起错误的客户端IP
Property ClientIP As %String(MAXLEN = 15, TRUNCATE = 1);

///  Index MainIdx On ErrorID [ PrimaryKey, Unique ];

Storage Default
{
<Data name="ErrorLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ErrDateTime</Value>
</Value>
<Value name="3">
<Value>Message</Value>
</Value>
<Value name="4">
<Value>StackTrace</Value>
</Value>
<Value name="5">
<Value>IP</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
<Value name="7">
<Value>UserName</Value>
</Value>
<Value name="8">
<Value>ErrorID</Value>
</Value>
<Value name="9">
<Value>ClientIP</Value>
</Value>
</Data>
<DataLocation>^CSM.ErrorLogD</DataLocation>
<DefaultData>ErrorLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CSM.ErrorLogD</IdLocation>
<IndexLocation>^CSM.ErrorLogI</IndexLocation>
<StreamLocation>^CSM.ErrorLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
