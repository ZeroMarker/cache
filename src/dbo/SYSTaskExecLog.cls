///     
Class dbo.SYSTaskExecLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_TaskExecLog, StorageStrategy = Default ]
{

/// Foreign Key SystemTaskExecLog created via DDL
ForeignKey SystemTaskExecLog(TaskDR) References dbo.SYSTask(PKSYSTASK) [ SqlName = SystemTaskExecLog ];

Index IndexExecDate On (ExecDate, TaskDR) [ SqlName = Index_ExecDate, Type = index ];

/// DDL Primary Key Specification
Index PKSYSTASKEXECLOG On RowID [ PrimaryKey, SqlName = PK_SYS_TASKEXECLOG, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TaskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Property ExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="SYSTaskExecLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskDR</Value>
</Value>
<Value name="3">
<Value>ExecDate</Value>
</Value>
<Value name="4">
<Value>ExecTime</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSTaskExecLogD</DataLocation>
<DefaultData>SYSTaskExecLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSTaskExecLogD</IdLocation>
<IndexLocation>^dbo.SYSTaskExecLogI</IndexLocation>
<StreamLocation>^dbo.SYSTaskExecLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
