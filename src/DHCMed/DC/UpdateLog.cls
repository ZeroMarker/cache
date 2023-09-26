/// 名称 : DHCMed.DC.UpdateLog
/// 说明 : 更新日志
Class DHCMed.DC.UpdateLog Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 开始时间（日期+时间）
Property LastStart As %String(MAXLEN = 100, TRUNCATE = 1);

/// 完成时间（日期+时间）
Property Completed As %String(MAXLEN = 100, TRUNCATE = 1);

/// 任务说明
Property TaskName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 执行结果
Property Result As %String(MAXLEN = 200, TRUNCATE = 1);

/// 执行程序
Property Routine As %String(MAXLEN = 200, TRUNCATE = 1);

/// 进程号
Property PID As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日志日期
Property LogDate As %Date;

/// 日志时间
Property LogTime As %Time;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LastStart</Value>
</Value>
<Value name="3">
<Value>Completed</Value>
</Value>
<Value name="4">
<Value>TaskName</Value>
</Value>
<Value name="5">
<Value>Result</Value>
</Value>
<Value name="6">
<Value>Routine</Value>
</Value>
<Value name="7">
<Value>PID</Value>
</Value>
<Value name="8">
<Value>LogDate</Value>
</Value>
<Value name="9">
<Value>LogTime</Value>
</Value>
</Data>
<DataLocation>^DHCMed.DC.UpdateLogD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.DC.UpdateLogD</IdLocation>
<IndexLocation>^DHCMed.DC.UpdateLogI</IndexLocation>
<StreamLocation>^DHCMed.DC.UpdateLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
