/// Creater:lulin
/// Descriptions:操作日志
/// Date:2020-06-19
Class DHCINM.Log.MgOperateLog Extends %Persistent
{

/// 类名
Property LogClass As %String [ SqlColumnNumber = 2, SqlFieldName = Log_Class ];

/// 方法
Property LogMethod As %String [ SqlColumnNumber = 3, SqlFieldName = Log_Method ];

/// 描述
Property LogDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Log_Desc ];

/// 入参
Property LogParr As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Log_Parr ];

/// 操作人id
Property LogUserDR As %String [ SqlColumnNumber = 6, SqlFieldName = Log_UserDR ];

/// 操作人姓名
Property LogUserName As %String [ SqlColumnNumber = 7, SqlFieldName = Log_UserName ];

/// 操作日期
Property LogDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Log_Date ];

/// 操作时间
Property LogTime As %Time [ SqlColumnNumber = 9, SqlFieldName = Log_Time ];

Index DateUser On (LogDate, LogTime, LogUserDR);

Index UserDate On (LogUserDR, LogDate, LogTime);

Storage Default
{
<Data name="MgOperateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogClass</Value>
</Value>
<Value name="3">
<Value>LogMethod</Value>
</Value>
<Value name="4">
<Value>LogDesc</Value>
</Value>
<Value name="5">
<Value>LogParr</Value>
</Value>
<Value name="6">
<Value>LogUserDR</Value>
</Value>
<Value name="7">
<Value>LogUserName</Value>
</Value>
<Value name="8">
<Value>LogDate</Value>
</Value>
<Value name="9">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Log.MgOperateLogD</DataLocation>
<DefaultData>MgOperateLogDefaultData</DefaultData>
<IdLocation>^DHCINM.Log.MgOperateLogD</IdLocation>
<IndexLocation>^DHCINM.Log.MgOperateLogI</IndexLocation>
<StreamLocation>^DHCINM.Log.MgOperateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
