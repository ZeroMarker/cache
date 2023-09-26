/// 手术麻醉日志表
Class CIS.AN.Log Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = Log ]
{

/// 业务代码
Property BSCode As %String(MAXLEN = 200) [ SqlColumnNumber = 2 ];

/// 入参
Property InParam As %String(MAXLEN = 1000000) [ SqlColumnNumber = 3 ];

/// 出参
Property OutParam As %String(MAXLEN = 1000000) [ SqlColumnNumber = 4 ];

/// 日志日期
Property LogDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5 ];

/// 日志时间
Property LogTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 6 ];

/// 日志用户
Property LogUser As %String [ SqlColumnNumber = 7 ];

/// 日志说明
Property Note As %String(MAXLEN = 200) [ SqlColumnNumber = 8 ];

Index IBSCodeDate On (BSCode, LogDate);

Index ILogDate On LogDate;

Index IBSCode On BSCode;

Storage Default
{
<Data name="LogDefaultData">
<Value name="1">
<Value>BSCode</Value>
</Value>
<Value name="2">
<Value>InParam</Value>
</Value>
<Value name="3">
<Value>OutParam</Value>
</Value>
<Value name="4">
<Value>LogDate</Value>
</Value>
<Value name="5">
<Value>LogTime</Value>
</Value>
<Value name="6">
<Value>LogUser</Value>
</Value>
<Value name="7">
<Value>Note</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.LogD</DataLocation>
<DefaultData>LogDefaultData</DefaultData>
<IdLocation>^CIS.AN.LogD</IdLocation>
<IndexLocation>^CIS.AN.LogI</IndexLocation>
<StreamLocation>^CIS.AN.LogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
