/// creator: xbl
/// createdate: 20171008
/// description: 操作日志
Class DHCNMG.Log.MgOperateLog Extends %Persistent
{

/// 记录表名
Property LogTable As %String [ SqlColumnNumber = 2, SqlFieldName = Log_Table ];

/// 类型
Property LogType As %String [ SqlColumnNumber = 3, SqlFieldName = Log_Type ];

/// 原始值
Property LogOldData As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = Log_OldData ];

/// 最新值
Property LogNewData As %String(MAXLEN = 1000) [ SqlColumnNumber = 5, SqlFieldName = Log_NewData ];

/// 操作人
Property LogUserDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 6, SqlFieldName = Log_UserDR ];

/// 操作日期
Property LogDate As %Date [ SqlColumnNumber = 7, SqlFieldName = Log_Date ];

/// 操作时间
Property LogTime As %Time [ SqlColumnNumber = 8, SqlFieldName = Log_Time ];

Index Table On LogTable;

Storage Default
{
<Data name="MgOperateLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LogTable</Value>
</Value>
<Value name="3">
<Value>LogType</Value>
</Value>
<Value name="4">
<Value>LogOldData</Value>
</Value>
<Value name="5">
<Value>LogNewData</Value>
</Value>
<Value name="6">
<Value>LogUserDR</Value>
</Value>
<Value name="7">
<Value>LogDate</Value>
</Value>
<Value name="8">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Log.MgOperateLogD</DataLocation>
<DefaultData>MgOperateLogDefaultData</DefaultData>
<IdLocation>^DHCNMG.Log.MgOperateLogD</IdLocation>
<IndexLocation>^DHCNMG.Log.MgOperateLogI</IndexLocation>
<StreamLocation>^DHCNMG.Log.MgOperateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
